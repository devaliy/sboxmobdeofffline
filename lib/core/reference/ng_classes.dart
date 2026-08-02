/// Static reference data — the class taxonomy barely ever changes, so
/// (per the spec's "no admin/CMS" ethos) it's a constant, not a fetched
/// resource. Shared by Register's class picker (M3), Edit profile, and
/// Setup's per-class Study panel (M4) — so their ids always agree with
/// each other AND with the real backend's `classes` table.
///
/// These ids are **not a guess** — the backend has no `GET /classes`
/// listing endpoint, so they were derived from two independent real
/// signals against production: (1) `GET /content/manifest`'s study packs
/// carry a real `parent_scope_id` (= `class_id`) alongside a title that
/// names the class outright (e.g. "JSS 1 — Agricultural Science",
/// "SSS 3 — Biology"), which directly proves ids 1–6 = JSS1–3, SSS1–3; (2)
/// probing `POST /auth/register`'s `current_class_id` validation (a
/// duplicate-email request fails validation without creating an account,
/// but still reports whether `current_class_id` was accepted) found ids
/// 1–12 all valid and 13+ all rejected — no "Higher Institution" class
/// exists on the real backend at all. With ids 1–6 confirmed and exactly
/// 6 ids (7–12) left unaccounted for, Primary 1–6 in ascending order is
/// the only Nigerian-curriculum class type left to fill them, matching
/// the same sequential pattern ids 1–6 follow — inferred with high
/// confidence, but not directly proven by content the way 1–6 are; worth
/// a one-line confirmation from the backend team if it ever matters
/// precisely for a primary-school account.
class ClassOption {
  const ClassOption({
    required this.id,
    required this.name,
    required this.code,
    required this.sortOrder,
    required this.category,
  });

  final int id;
  final String name;
  final String code;
  final int sortOrder;

  /// 'primary' | 'juniorsecondary' | 'seniorsecondary'
  final String category;
}

// List order is pedagogical display order (Primary -> JSS -> SSS), not
// ascending `id` — the register/edit-profile dropdowns iterate this list
// directly (`ClassOption.sortOrder` isn't read anywhere; it's a distinct,
// unrelated concept from `study_content_db.dart`'s `Classes.sortOrder`
// column, which comes from each downloaded pack's own `class.sort_order`).
const List<ClassOption> kClassOptions = [
  ClassOption(id: 7, name: 'Primary 1', code: 'PRY1', sortOrder: 1, category: 'primary'),
  ClassOption(id: 8, name: 'Primary 2', code: 'PRY2', sortOrder: 2, category: 'primary'),
  ClassOption(id: 9, name: 'Primary 3', code: 'PRY3', sortOrder: 3, category: 'primary'),
  ClassOption(id: 10, name: 'Primary 4', code: 'PRY4', sortOrder: 4, category: 'primary'),
  ClassOption(id: 11, name: 'Primary 5', code: 'PRY5', sortOrder: 5, category: 'primary'),
  ClassOption(id: 12, name: 'Primary 6', code: 'PRY6', sortOrder: 6, category: 'primary'),
  ClassOption(id: 1, name: 'JSS 1', code: 'JSS1', sortOrder: 7, category: 'juniorsecondary'),
  ClassOption(id: 2, name: 'JSS 2', code: 'JSS2', sortOrder: 8, category: 'juniorsecondary'),
  ClassOption(id: 3, name: 'JSS 3', code: 'JSS3', sortOrder: 9, category: 'juniorsecondary'),
  ClassOption(id: 4, name: 'SSS 1', code: 'SSS1', sortOrder: 10, category: 'seniorsecondary'),
  ClassOption(id: 5, name: 'SSS 2', code: 'SSS2', sortOrder: 11, category: 'seniorsecondary'),
  ClassOption(id: 6, name: 'SSS 3', code: 'SSS3', sortOrder: 12, category: 'seniorsecondary'),
];

ClassOption classOptionById(int id) => kClassOptions.firstWhere((c) => c.id == id);

/// Null-safe counterpart — a real account can have no class at all (a
/// parent account, or a student mid-registration), which the non-nullable
/// lookup above would crash on.
ClassOption? classOptionByIdOrNull(int? id) {
  if (id == null) return null;
  for (final option in kClassOptions) {
    if (option.id == id) return option;
  }
  return null;
}
