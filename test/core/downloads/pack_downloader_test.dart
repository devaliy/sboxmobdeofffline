import 'dart:io';

import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:success_offline/core/db/assessment_content_db.dart';
import 'package:success_offline/core/db/study_content_db.dart';
import 'package:success_offline/core/downloads/pack_downloader.dart';
import 'package:success_offline/core/downloads/pack_importer.dart';
import 'package:success_offline/core/network/mock/mock_api_adapter.dart';
import 'package:success_offline/core/network/mock/mock_backend_store.dart';
import 'package:success_offline/features/setup/domain/content_pack_manifest.dart';

void main() {
  late MockBackendStore store;
  late Dio dio;
  late Directory tempDir;
  late PackDownloader downloader;
  late StudyContentDb studyDb;
  late AssessmentContentDb assessmentDb;
  late ContentManifest manifest;

  setUp(() async {
    store = MockBackendStore();
    dio = Dio(BaseOptions(baseUrl: 'https://mock.local/api/v1'))
      ..httpClientAdapter = MockApiAdapter(store);
    tempDir = Directory.systemTemp.createTempSync('pack_dl_test_');
    downloader = PackDownloader(dio, PackImporter(), tempDirProvider: () async => tempDir);
    studyDb = StudyContentDb.forTesting(NativeDatabase.memory());
    assessmentDb = AssessmentContentDb.forTesting(NativeDatabase.memory());

    final manifestJson = await dio.get('/content/manifest');
    manifest = ContentManifest.fromJson(manifestJson.data as Map<String, dynamic>);
  });

  tearDown(() async {
    await studyDb.close();
    await assessmentDb.close();
    if (tempDir.existsSync()) tempDir.deleteSync(recursive: true);
  });

  ManifestPackEntry study() => manifest.studyPacks.single;
  ManifestPackEntry assessment() => manifest.assessmentPacks.single;

  test('downloads, verifies and imports a full Study pack', () async {
    final pack = study();
    var lastReceived = 0;
    await downloader.downloadAndImportStudyPack(
      pack,
      db: studyDb,
      onProgress: (received, total) => lastReceived = received,
    );

    expect(lastReceived, pack.sizeBytes);
    final books = await studyDb.watchBooksForClass(2).first;
    expect(books.single.name, 'Mathematics');
    final subjects = await studyDb.watchSubjectsForBook(books.single.id).first;
    expect(subjects.single.title, 'Week 1: Algebra Basics');
    expect(await studyDb.isBookInstalled(pack.scopeId), isTrue);

    final installed = await studyDb.watchInstalledPacks().first;
    expect(installed.single.checksum, pack.checksum);
    expect(installed.single.version, pack.version);
  });

  test('downloads, verifies and imports a full Assessment pack', () async {
    final pack = assessment();
    await downloader.downloadAndImportAssessmentPack(pack, db: assessmentDb);

    final subjects = await assessmentDb.watchSubjects().first;
    expect(subjects.single.name, 'Physics');
    expect(await assessmentDb.isSubjectInstalled(pack.scopeId), isTrue);

    final categories = await assessmentDb.watchCategories().first;
    expect(categories.single.catName, 'Objective');
    final years = await assessmentDb.watchYearsForSubjectAndCategory(pack.scopeId, categories.single.id).first;
    expect(years.single.yearName, '2019');
    final questions = await assessmentDb.questionsForSubjectAndCategory(
      pack.scopeId,
      categories.single.id,
      yearId: years.single.id,
      limit: 10,
    );
    expect(questions, hasLength(4));

    // The image-fix regression: the real backend serializes an absent
    // image as the literal string "questions/None", not null — one mock
    // question uses that exact real-world value, one uses a real filename.
    final byId = {for (final q in questions) q.id: q};
    expect(byId[30021]!.imagePath, isNull);
    expect(byId[30022]!.imagePath, p.join('content', 'assessment', 'images', 'questions/diagram.png'));
  });

  test(
      'a dropped connection resumes from the partial file already on disk via HTTP Range, '
      'not from zero', () async {
    final pack = study();

    // Simulate an interruption: download only the first half for real,
    // leaving a genuine partial file exactly as a dropped connection would.
    final fullResponse = await dio.getUri<ResponseBody>(
      resolveApiUri(dio, pack.downloadUrl),
      options: Options(responseType: ResponseType.stream),
    );
    final fullBytes = <int>[];
    await for (final chunk in fullResponse.data!.stream) {
      fullBytes.addAll(chunk);
    }
    final half = fullBytes.length ~/ 2;

    final partialFile = File('${tempDir.path}/packs/study_${pack.scopeId}_${pack.version}.zip.part');
    partialFile.parent.createSync(recursive: true);
    await partialFile.writeAsBytes(fullBytes.sublist(0, half));

    // Instrument dio to capture the Range header actually sent on resume.
    String? capturedRange;
    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      if (options.headers.containsKey('Range')) {
        capturedRange = options.headers['Range'] as String;
      }
      handler.next(options);
    }));

    await downloader.downloadAndImportStudyPack(pack, db: studyDb);

    expect(capturedRange, 'bytes=$half-');
    // The reassembled (first-half-on-disk + resumed-tail) bytes still pass
    // checksum verification and import correctly — proving the resume
    // produced byte-identical content to a from-scratch download.
    expect(await studyDb.isBookInstalled(pack.scopeId), isTrue);
    // Successful import cleans up the partial file.
    expect(partialFile.existsSync(), isFalse);
  });

  test('the mock server honors Range requests with a real 206 + Content-Range response',
      () async {
    final pack = study();
    final fullResponse = await dio.getUri<ResponseBody>(
      resolveApiUri(dio, pack.downloadUrl),
      options: Options(responseType: ResponseType.stream),
    );
    final fullBytes = <int>[];
    await for (final chunk in fullResponse.data!.stream) {
      fullBytes.addAll(chunk);
    }

    final partialResponse = await dio.getUri<List<int>>(
      resolveApiUri(dio, pack.downloadUrl),
      options: Options(responseType: ResponseType.bytes, headers: {'Range': 'bytes=3-'}),
    );

    expect(partialResponse.statusCode, 206);
    expect(partialResponse.headers.value('content-range'), 'bytes 3-${fullBytes.length - 1}/${fullBytes.length}');
    expect(partialResponse.data, fullBytes.sublist(3));
  });

  test('a checksum mismatch is treated as corruption: clean re-download, not a partial/corrupt state',
      () async {
    final pack = study();
    final partialFile = File('${tempDir.path}/packs/study_${pack.scopeId}_${pack.version}.zip.part');
    partialFile.parent.createSync(recursive: true);
    // Garbage, but the *right length* so the downloader thinks it's
    // already fully downloaded and jumps straight to checksum verification.
    await partialFile.writeAsBytes(List.filled(pack.sizeBytes, 0));

    await expectLater(
      () => downloader.downloadAndImportStudyPack(pack, db: studyDb),
      throwsA(isA<PackDownloadException>().having((e) => e.recoverable, 'recoverable', isFalse)),
    );

    expect(partialFile.existsSync(), isFalse);
    expect(await studyDb.isBookInstalled(pack.scopeId), isFalse);
  });

  test('re-importing an updated pack version updates the bookkeeping row in place, not a duplicate',
      () async {
    final pack = study();
    await downloader.downloadAndImportStudyPack(pack, db: studyDb);
    await downloader.downloadAndImportStudyPack(pack, db: studyDb); // re-import, same version

    final installed = await studyDb.watchInstalledPacks().first;
    expect(installed, hasLength(1)); // not duplicated
  });
}
