import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/assessment_content_db.dart';
import '../../../core/db/db_providers.dart';

final subjectByIdProvider = StreamProvider.family<Subject?, int>((ref, subjectId) {
  final db = ref.watch(assessmentContentDbProvider);
  return (db.select(db.subjects)..where((t) => t.id.equals(subjectId))).watchSingleOrNull();
});

/// Every installed category — the practice picker's first step. Reactive:
/// a newly-downloaded (or re-imported) pack's categories show up live, the
/// same reasoning as everything else in this file being stream-based.
final installedCategoriesProvider = StreamProvider<List<Category>>((ref) {
  return ref.watch(assessmentContentDbProvider).watchCategories();
});

/// Subjects with at least one question in the given category — the
/// picker's third step, scoped to whatever's actually relevant to the
/// category just chosen.
final subjectsForCategoryProvider = StreamProvider.family<List<Subject>, int>((ref, categoryId) {
  return ref.watch(assessmentContentDbProvider).watchSubjectsForCategory(categoryId);
});

/// Years with at least one question in the given subject+category — the
/// picker's fourth step. A subject's `years` aren't uniformly represented
/// within any one category (each question picks its own year and
/// category independently), so this is scoped to the category just
/// chosen, not every year the subject's pack ever mentions.
final yearsForSubjectAndCategoryProvider =
    StreamProvider.family<List<Year>, ({int subjectId, int categoryId})>((ref, params) {
  return ref
      .watch(assessmentContentDbProvider)
      .watchYearsForSubjectAndCategory(params.subjectId, params.categoryId);
});

/// One-shot on purpose (not a stream): a fresh pull for the specific
/// subject+category+year+format the student just picked to start a
/// session, not something that should re-fire mid-exam if unrelated
/// content changes elsewhere. `autoDispose` so leaving the exam screen
/// (and later starting a *different* attempt against the same
/// combination) doesn't reuse a stale cached read.
final examQuestionsProvider = FutureProvider.autoDispose
    .family<List<Question>, ({int subjectId, int categoryId, int yearId, int limit})>((ref, params) {
  return ref.watch(assessmentContentDbProvider).questionsForSubjectAndCategory(
        params.subjectId,
        params.categoryId,
        yearId: params.yearId,
        limit: params.limit,
      );
});

final passageByIdProvider = FutureProvider.family<Passage?, int>((ref, passageId) {
  return ref.watch(assessmentContentDbProvider).passageById(passageId);
});
