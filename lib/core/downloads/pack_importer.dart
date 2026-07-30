import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart' show compute;
import 'package:path/path.dart' as p;

import '../db/assessment_content_db.dart';
import '../db/db_paths.dart';
import '../db/study_content_db.dart';
import 'pack_json_models.dart';

/// pack.json plus any `images/` entries, decoded off the main isolate —
/// large zip extraction shouldn't freeze the UI (spec Section 8).
typedef _DecodedPack = ({Map<String, dynamic> packJson, Map<String, Uint8List> images});

_DecodedPack _decodeZip(Uint8List zipBytes) {
  final archive = ZipDecoder().decodeBytes(zipBytes);
  Map<String, dynamic>? packJson;
  final images = <String, Uint8List>{};

  for (final file in archive.files) {
    if (!file.isFile) continue;
    if (file.name == 'pack.json') {
      packJson = jsonDecode(utf8.decode(file.content as List<int>)) as Map<String, dynamic>;
    } else if (file.name.startsWith('images/')) {
      images[file.name.substring('images/'.length)] = Uint8List.fromList(file.content as List<int>);
    }
  }

  if (packJson == null) {
    throw const FormatException('Corrupt pack: pack.json missing from archive');
  }
  return (packJson: packJson, images: images);
}

/// Transactional pack import (spec Section 4.7 / 8): parses the zip off
/// the main isolate, then writes everything — rows plus the
/// `installed_*_packs` bookkeeping row — inside a single drift
/// transaction, so a crash mid-import can't leave the database
/// half-populated. Shared lookup rows (`classes`/`terms`,
/// `categories`/`years`/`test_types`) are upserted by id since the same
/// row can legitimately reappear across independently-downloaded packs;
/// pack-owned rows are upserted too, so re-importing an updated version
/// of a pack replaces its rows in place rather than erroring.
class PackImporter {
  Future<void> importStudyPack({
    required StudyContentDb db,
    required Uint8List zipBytes,
    required String checksum,
    required int sizeBytes,
  }) async {
    final decoded = await compute(_decodeZip, zipBytes);
    final pack = StudyPackJson.fromJson(decoded.packJson);
    await _writeImages('study', decoded.images);

    await db.transaction(() async {
      await db.upsertClass(ClassesCompanion(
        id: Value(pack.classJson['id'] as int),
        name: Value(pack.classJson['name'] as String),
        code: Value(pack.classJson['code'] as String?),
        sortOrder: Value(pack.classJson['sort_order'] as int),
        category: Value(pack.classJson['category'] as String),
      ));

      for (final termJson in pack.terms) {
        await db.upsertTerm(TermsCompanion(
          id: Value(termJson['id'] as int),
          name: Value(termJson['name'] as String),
          startDate: Value(termJson['start_date'] as String),
          endDate: Value(termJson['end_date'] as String),
        ));
      }

      final book = pack.bookJson;
      await db.into(db.libraryBooks).insertOnConflictUpdate(LibraryBooksCompanion(
            id: Value(book['id'] as int),
            classId: Value(book['class_id'] as int),
            name: Value(book['name'] as String),
            imagePath: Value(_rewrite('study', book['image'] as String?)),
            color: Value(book['color'] as String),
          ));

      for (final subject in pack.subjects) {
        final s = subject.json;
        final subjectId = s['id'] as int;
        await db.into(db.librarySubjects).insertOnConflictUpdate(LibrarySubjectsCompanion(
              id: Value(subjectId),
              libraryBookId: Value(s['library_book_id'] as int),
              termId: Value(s['term_id'] as int),
              title: Value(s['title'] as String),
              description: Value(s['description'] as String?),
              coverImagePath: Value(_rewrite('study', s['cover_image'] as String?)),
              author: Value(s['author'] as String),
              week: Value(s['week'] as int),
              numOfTestQuestions: Value(s['num_of_test_questions'] as int),
            ));

        for (final c in subject.contents) {
          await db.into(db.libraryContents).insertOnConflictUpdate(LibraryContentsCompanion(
                id: Value(c['id'] as int),
                librarySubjectId: Value(subjectId),
                contentHtml: Value(c['content'] as String),
              ));
        }

        for (final q in subject.questions) {
          await db.into(db.libraryQuestions).insertOnConflictUpdate(LibraryQuestionsCompanion(
                id: Value(q['id'] as int),
                librarySubjectId: Value(subjectId),
                questionText: Value(q['question_text'] as String),
                imagePath: Value(_rewrite('study', q['image'] as String?)),
                optionA: Value(q['option_a'] as String),
                optionB: Value(q['option_b'] as String),
                optionC: Value(q['option_c'] as String),
                optionD: Value(q['option_d'] as String),
                optionE: Value(q['option_e'] as String?),
                correctOption: Value(q['correct_option'] as String),
                explanation: Value(q['explanation'] as String?),
              ));
        }
      }

      await _upsertStudyPackRecord(
        db: db,
        scopeId: pack.scopeId,
        version: pack.version,
        checksum: checksum,
        sizeBytes: sizeBytes,
      );
    });
  }

  /// Upserts by (scopeType, scopeId) rather than the autoincrement id —
  /// re-importing an updated pack must replace the existing bookkeeping
  /// row, not create a duplicate (spec Section 4.7).
  Future<void> _upsertStudyPackRecord({
    required StudyContentDb db,
    required int scopeId,
    required String version,
    required String checksum,
    required int sizeBytes,
  }) async {
    final installedAt = DateTime.now().toUtc().toIso8601String();
    final existing = await (db.select(db.installedStudyPacks)
          ..where((t) => t.scopeType.equals('book') & t.scopeId.equals(scopeId)))
        .getSingleOrNull();

    if (existing == null) {
      await db.into(db.installedStudyPacks).insert(InstalledStudyPacksCompanion.insert(
            scopeType: 'book',
            scopeId: scopeId,
            version: version,
            checksum: checksum,
            sizeBytes: sizeBytes,
            installedAt: installedAt,
          ));
    } else {
      await (db.update(db.installedStudyPacks)..where((t) => t.id.equals(existing.id))).write(
        InstalledStudyPacksCompanion(
          version: Value(version),
          checksum: Value(checksum),
          sizeBytes: Value(sizeBytes),
          installedAt: Value(installedAt),
        ),
      );
    }
  }

  Future<void> importAssessmentPack({
    required AssessmentContentDb db,
    required Uint8List zipBytes,
    required String checksum,
    required int sizeBytes,
  }) async {
    final decoded = await compute(_decodeZip, zipBytes);
    final pack = AssessmentPackJson.fromJson(decoded.packJson);
    await _writeImages('assessment', decoded.images);

    await db.transaction(() async {
      await db.into(db.subjects).insertOnConflictUpdate(SubjectsCompanion(
            id: Value(pack.subjectJson['id'] as int),
            name: Value(pack.subjectJson['name'] as String),
          ));

      for (final c in pack.categories) {
        await db.upsertCategory(CategoriesCompanion(
          id: Value(c['id'] as int),
          catName: Value(c['cat_name'] as String),
        ));
      }
      for (final y in pack.years) {
        await db.upsertYear(YearsCompanion(
          id: Value(y['id'] as int),
          subjectId: Value(y['subject_id'] as int),
          yearName: Value(y['year_name'] as String),
        ));
      }
      for (final tt in pack.testTypes) {
        await db.upsertTestType(TestTypesCompanion(
          id: Value(tt['id'] as int),
          testTypeName: Value(tt['test_type_name'] as String),
          durationMinutes: Value(tt['duration_minutes'] as int),
          numOfQuestions: Value(tt['num_of_questions'] as int),
          subjectId: Value(tt['subject_id'] as int?),
          assocCategoryId: Value(tt['assoc_category_id'] as int?),
        ));
      }
      for (final ps in pack.passages) {
        await db.into(db.passages).insertOnConflictUpdate(PassagesCompanion(
              id: Value(ps['id'] as int),
              title: Value(ps['title'] as String?),
              yearId: Value(ps['year_id'] as int?),
              passageText: Value(ps['passage_text'] as String),
            ));
      }
      for (final q in pack.questions) {
        await db.into(db.questions).insertOnConflictUpdate(QuestionsCompanion(
              id: Value(q['id'] as int),
              subjectId: Value(q['subject_id'] as int),
              categoryId: Value(q['category_id'] as int),
              yearId: Value(q['year_id'] as int),
              passageId: Value(q['passage_id'] as int?),
              testTypeId: Value(q['test_type_id'] as int?),
              questionText: Value(q['question_text'] as String),
              imagePath: Value(_rewrite('assessment', q['image'] as String?)),
              optionA: Value(q['option_a'] as String),
              optionB: Value(q['option_b'] as String),
              optionC: Value(q['option_c'] as String),
              optionD: Value(q['option_d'] as String),
              optionE: Value(q['option_e'] as String?),
              correctOption: Value(q['correct_option'] as String),
              explanation: Value(q['explanation'] as String?),
            ));
      }

      await _upsertAssessmentPackRecord(
        db: db,
        scopeId: pack.scopeId,
        version: pack.version,
        checksum: checksum,
        sizeBytes: sizeBytes,
      );
    });
  }

  Future<void> _upsertAssessmentPackRecord({
    required AssessmentContentDb db,
    required int scopeId,
    required String version,
    required String checksum,
    required int sizeBytes,
  }) async {
    final installedAt = DateTime.now().toUtc().toIso8601String();
    final existing = await (db.select(db.installedAssessmentPacks)
          ..where((t) => t.scopeType.equals('subject') & t.scopeId.equals(scopeId)))
        .getSingleOrNull();

    if (existing == null) {
      await db.into(db.installedAssessmentPacks).insert(InstalledAssessmentPacksCompanion.insert(
            scopeType: 'subject',
            scopeId: scopeId,
            version: version,
            checksum: checksum,
            sizeBytes: sizeBytes,
            installedAt: installedAt,
          ));
    } else {
      await (db.update(db.installedAssessmentPacks)..where((t) => t.id.equals(existing.id))).write(
        InstalledAssessmentPacksCompanion(
          version: Value(version),
          checksum: Value(checksum),
          sizeBytes: Value(sizeBytes),
          installedAt: Value(installedAt),
        ),
      );
    }
  }

  Future<void> _writeImages(String domain, Map<String, Uint8List> images) async {
    if (images.isEmpty) return;
    final docs = await DbPaths.documentsDir();
    for (final entry in images.entries) {
      final target = File(p.join(docs.path, 'content', domain, 'images', entry.key));
      await target.parent.create(recursive: true);
      await target.writeAsBytes(entry.value);
    }
  }

  String? _rewrite(String domain, String? zipRelativePath) {
    if (zipRelativePath == null) return null;
    return p.join('content', domain, 'images', zipRelativePath);
  }
}
