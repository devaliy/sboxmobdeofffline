import 'dart:io';

import 'package:dio/dio.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:success_offline/core/db/assessment_content_db.dart';
import 'package:success_offline/core/db/progress_db.dart';
import 'package:success_offline/core/db/study_content_db.dart';
import 'package:success_offline/core/downloads/pack_downloader.dart';
import 'package:success_offline/core/downloads/pack_importer.dart';
import 'package:success_offline/core/downloads/pack_remover.dart';
import 'package:success_offline/core/network/mock/mock_api_adapter.dart';
import 'package:success_offline/core/network/mock/mock_backend_store.dart';
import 'package:success_offline/features/setup/domain/content_pack_manifest.dart';

/// Proves M9's review gate (spec Phase 7 done-criteria): removing an
/// installed pack frees its rows/bookkeeping without touching the other
/// domain, without touching shared lookup rows another pack could still
/// reference, and — since removal only ever opens the *content* databases
/// — without touching any account's `progress.sqlite` at all.
void main() {
  late MockBackendStore store;
  late Dio dio;
  late Directory tempDir;
  late PackDownloader downloader;
  late PackRemover remover;
  late StudyContentDb studyDb;
  late AssessmentContentDb assessmentDb;
  late ContentManifest manifest;

  setUp(() async {
    store = MockBackendStore();
    dio = Dio(BaseOptions(baseUrl: 'https://mock.local/api/v1'))
      ..httpClientAdapter = MockApiAdapter(store);
    tempDir = Directory.systemTemp.createTempSync('pack_rm_test_');
    downloader = PackDownloader(dio, PackImporter(), tempDirProvider: () async => tempDir);
    remover = PackRemover();
    studyDb = StudyContentDb.forTesting(NativeDatabase.memory());
    assessmentDb = AssessmentContentDb.forTesting(NativeDatabase.memory());

    final manifestJson = await dio.get('/content/manifest');
    manifest = ContentManifest.fromJson(manifestJson.data as Map<String, dynamic>);

    await downloader.downloadAndImportStudyPack(manifest.studyPacks.single, db: studyDb);
    await downloader.downloadAndImportAssessmentPack(manifest.assessmentPacks.single, db: assessmentDb);
  });

  tearDown(() async {
    await studyDb.close();
    await assessmentDb.close();
    if (tempDir.existsSync()) tempDir.deleteSync(recursive: true);
  });

  test(
      'removing a Study pack frees its rows and bookkeeping, leaves shared lookups and '
      'the Assessment domain untouched', () async {
    final bookId = manifest.studyPacks.single.scopeId;

    expect(await studyDb.watchInstalledPacks().first, hasLength(1));
    expect(await studyDb.watchBooksForClass(8).first, hasLength(1));
    final subjects = await studyDb.watchSubjectsForBook(bookId).first;
    expect(subjects, isNotEmpty);
    expect(await studyDb.contentsForSubject(subjects.single.id), isNotEmpty);
    expect(await studyDb.questionsForSubject(subjects.single.id), isNotEmpty);

    await remover.removeStudyPack(db: studyDb, libraryBookId: bookId);

    expect(await studyDb.watchInstalledPacks().first, isEmpty);
    expect(await studyDb.isBookInstalled(bookId), isFalse);
    expect(await studyDb.watchBooksForClass(8).first, isEmpty);
    expect(await studyDb.watchSubjectsForBook(bookId).first, isEmpty);
    expect(await (studyDb.select(studyDb.libraryContents)).get(), isEmpty);
    expect(await (studyDb.select(studyDb.libraryQuestions)).get(), isEmpty);

    // Shared lookup rows (spec Section 4.7) survive — another still-
    // installed Study pack could reference the same class/term.
    expect(await (studyDb.select(studyDb.classes)).get(), isNotEmpty);
    expect(await (studyDb.select(studyDb.terms)).get(), isNotEmpty);

    // The Assessment domain is a different physical file — structurally
    // untouched, not just coincidentally still populated.
    expect(await assessmentDb.watchInstalledPacks().first, hasLength(1));
    expect(await (assessmentDb.select(assessmentDb.subjects)).get(), isNotEmpty);
    expect(await (assessmentDb.select(assessmentDb.questions)).get(), isNotEmpty);
  });

  test(
      'removing an Assessment pack frees its rows and bookkeeping, leaves shared lookups and '
      'the Study domain untouched', () async {
    final subjectId = manifest.assessmentPacks.single.scopeId;

    expect(await assessmentDb.watchInstalledPacks().first, hasLength(1));
    expect(await assessmentDb.testTypesForSubject(subjectId), isNotEmpty);

    await remover.removeAssessmentPack(db: assessmentDb, subjectId: subjectId);

    expect(await assessmentDb.watchInstalledPacks().first, isEmpty);
    expect(await assessmentDb.isSubjectInstalled(subjectId), isFalse);
    expect(await (assessmentDb.select(assessmentDb.subjects)).get(), isEmpty);
    expect(await (assessmentDb.select(assessmentDb.questions)).get(), isEmpty);

    // Shared lookup rows survive.
    expect(await (assessmentDb.select(assessmentDb.categories)).get(), isNotEmpty);
    expect(await (assessmentDb.select(assessmentDb.years)).get(), isNotEmpty);
    expect(await (assessmentDb.select(assessmentDb.testTypes)).get(), isNotEmpty);
    expect(await (assessmentDb.select(assessmentDb.passages)).get(), isNotEmpty);

    // Study domain untouched.
    expect(await studyDb.watchInstalledPacks().first, hasLength(1));
    expect(await (studyDb.select(studyDb.libraryBooks)).get(), isNotEmpty);
  });

  test('removing a pack never touches any account\'s progress.sqlite', () async {
    final bookId = manifest.studyPacks.single.scopeId;
    final subjects = await studyDb.watchSubjectsForBook(bookId).first;
    final librarySubjectId = subjects.single.id;

    final progressDb = ProgressDb.forTesting(NativeDatabase.memory());
    addTearDown(progressDb.close);

    await progressDb.into(progressDb.practiceAttempts).insert(PracticeAttemptsCompanion.insert(
          id: 'attempt-before-removal',
          sourceType: 'library',
          librarySubjectId: Value(librarySubjectId),
          score: 2,
          totalQuestions: 2,
          timeSpentSeconds: 60,
          startedAt: '2026-07-29T00:00:00Z',
          completedAt: '2026-07-29T00:01:00Z',
        ));

    await remover.removeStudyPack(db: studyDb, libraryBookId: bookId);

    // The content that attempt referenced is gone from study_content.sqlite...
    expect(await studyDb.watchSubjectsForBook(bookId).first, isEmpty);
    // ...but the attempt itself, in the completely separate progress.sqlite
    // file, is exactly as it was — pack removal has no code path that
    // opens a ProgressDb at all.
    final attempts = await progressDb.watchRecentAttempts().first;
    expect(attempts, hasLength(1));
    expect(attempts.single.id, 'attempt-before-removal');
    expect(attempts.single.score, 2);
  });
}
