import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/assessment_content_db.dart';
import '../../../core/db/db_providers.dart';

/// Every row in `subjects` was, by construction, imported together with
/// its `installed_assessment_packs` bookkeeping row in one transaction
/// (spec Section 4.7) — same reasoning as Study Center's
/// `installedBooksProvider` (M6): "every subject in this table" already
/// means "every installed subject".
final installedSubjectsProvider = StreamProvider<List<Subject>>((ref) {
  final db = ref.watch(assessmentContentDbProvider);
  return db.select(db.subjects).watch();
});

final subjectByIdProvider = StreamProvider.family<Subject?, int>((ref, subjectId) {
  final db = ref.watch(assessmentContentDbProvider);
  return (db.select(db.subjects)..where((t) => t.id.equals(subjectId))).watchSingleOrNull();
});

final testTypesForSubjectProvider = FutureProvider.family<List<TestType>, int>((ref, subjectId) {
  return ref.watch(assessmentContentDbProvider).testTypesForSubject(subjectId);
});

final testTypeByIdProvider = StreamProvider.family<TestType?, int>((ref, testTypeId) {
  final db = ref.watch(assessmentContentDbProvider);
  return (db.select(db.testTypes)..where((t) => t.id.equals(testTypeId))).watchSingleOrNull();
});

final questionsForTestTypeProvider = FutureProvider.family<List<Question>, int>((ref, testTypeId) {
  return ref.watch(assessmentContentDbProvider).questionsForTestType(testTypeId);
});

final passageByIdProvider = FutureProvider.family<Passage?, int>((ref, passageId) {
  return ref.watch(assessmentContentDbProvider).passageById(passageId);
});
