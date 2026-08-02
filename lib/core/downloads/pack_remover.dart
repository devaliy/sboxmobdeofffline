import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;

import '../db/assessment_content_db.dart';
import '../db/db_paths.dart';
import '../db/study_content_db.dart';

/// Reverses what [PackImporter] does (spec Section 4.7's removal rules):
/// deletes only rows uniquely owned by the removed scope, plus whatever
/// image files those rows referenced — shared lookup rows (`classes`/
/// `terms` for Study, `categories`/`years`/`test_types`/`passages` for
/// Assessment) are left untouched since another still-installed pack may
/// reference them.
class PackRemover {
  PackRemover({Future<Directory> Function()? documentsDirProvider})
      : _documentsDirProvider = documentsDirProvider ?? DbPaths.documentsDir;

  /// Overridable so tests can use [Directory.systemTemp] directly —
  /// `path_provider`'s real implementation needs a platform channel that
  /// doesn't exist under plain `test()`/`flutter test`, same reasoning as
  /// [PackDownloader]'s `tempDirProvider`.
  final Future<Directory> Function() _documentsDirProvider;

  Future<void> removeStudyPack({required StudyContentDb db, required int libraryBookId}) async {
    late final List<String> imagePaths;

    await db.transaction(() async {
      final book =
          await (db.select(db.libraryBooks)..where((t) => t.id.equals(libraryBookId))).getSingleOrNull();
      final subjects = await (db.select(db.librarySubjects)
            ..where((t) => t.libraryBookId.equals(libraryBookId)))
          .get();
      final subjectIds = subjects.map((s) => s.id).toList();
      final questions = subjectIds.isEmpty
          ? const <LibraryQuestion>[]
          : await (db.select(db.libraryQuestions)..where((t) => t.librarySubjectId.isIn(subjectIds)))
              .get();

      imagePaths = [
        if (book?.imagePath != null) book!.imagePath!,
        for (final s in subjects)
          if (s.coverImagePath != null) s.coverImagePath!,
        for (final q in questions)
          if (q.imagePath != null) q.imagePath!,
      ];

      if (subjectIds.isNotEmpty) {
        await (db.delete(db.libraryContents)..where((t) => t.librarySubjectId.isIn(subjectIds))).go();
        await (db.delete(db.libraryQuestions)..where((t) => t.librarySubjectId.isIn(subjectIds))).go();
        await (db.delete(db.librarySubjects)..where((t) => t.libraryBookId.equals(libraryBookId))).go();
      }
      await (db.delete(db.libraryBooks)..where((t) => t.id.equals(libraryBookId))).go();
      await (db.delete(db.installedStudyPacks)
            ..where((t) => t.scopeType.equals('book') & t.scopeId.equals(libraryBookId)))
          .go();
    });

    await _deleteFiles(imagePaths);
  }

  Future<void> removeAssessmentPack({required AssessmentContentDb db, required int subjectId}) async {
    late final List<String> imagePaths;

    await db.transaction(() async {
      final questions =
          await (db.select(db.questions)..where((t) => t.subjectId.equals(subjectId))).get();
      imagePaths = [
        for (final q in questions)
          if (q.imagePath != null) q.imagePath!,
      ];

      await (db.delete(db.questions)..where((t) => t.subjectId.equals(subjectId))).go();
      await (db.delete(db.subjects)..where((t) => t.id.equals(subjectId))).go();
      await (db.delete(db.installedAssessmentPacks)
            ..where((t) => t.scopeType.equals('subject') & t.scopeId.equals(subjectId)))
          .go();
    });

    await _deleteFiles(imagePaths);
  }

  Future<void> _deleteFiles(List<String> relativePaths) async {
    if (relativePaths.isEmpty) return;
    final docs = await _documentsDirProvider();
    for (final rel in relativePaths) {
      final file = File(p.join(docs.path, rel));
      if (await file.exists()) {
        try {
          await file.delete();
        } catch (_) {
          // Best-effort — a stray leftover file isn't worth failing the
          // whole removal over.
        }
      }
    }
  }
}
