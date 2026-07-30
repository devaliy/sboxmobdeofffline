/// Static reference data — the class taxonomy barely ever changes, so
/// (per the spec's "no admin/CMS" ethos) it's a constant, not a fetched
/// resource. Shared by Register's class picker (M3) and Setup's per-class
/// Study panel (M4) so their ids always agree with each other and with the
/// mock backend's seed data.
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

  /// 'primary' | 'juniorsecondary' | 'seniorsecondary' | 'higherinstitution'
  final String category;
}

const List<ClassOption> kClassOptions = [
  ClassOption(id: 1, name: 'Primary 1', code: 'PRY1', sortOrder: 1, category: 'primary'),
  ClassOption(id: 2, name: 'Primary 2', code: 'PRY2', sortOrder: 2, category: 'primary'),
  ClassOption(id: 3, name: 'Primary 3', code: 'PRY3', sortOrder: 3, category: 'primary'),
  ClassOption(id: 4, name: 'Primary 4', code: 'PRY4', sortOrder: 4, category: 'primary'),
  ClassOption(id: 5, name: 'Primary 5', code: 'PRY5', sortOrder: 5, category: 'primary'),
  ClassOption(id: 6, name: 'Primary 6', code: 'PRY6', sortOrder: 6, category: 'primary'),
  ClassOption(id: 7, name: 'JSS 1', code: 'JSS1', sortOrder: 7, category: 'juniorsecondary'),
  ClassOption(id: 8, name: 'JSS 2', code: 'JSS2', sortOrder: 8, category: 'juniorsecondary'),
  ClassOption(id: 9, name: 'JSS 3', code: 'JSS3', sortOrder: 9, category: 'juniorsecondary'),
  ClassOption(id: 10, name: 'SS 1', code: 'SS1', sortOrder: 10, category: 'seniorsecondary'),
  ClassOption(id: 11, name: 'SS 2', code: 'SS2', sortOrder: 11, category: 'seniorsecondary'),
  ClassOption(id: 12, name: 'SS 3', code: 'SS3', sortOrder: 12, category: 'seniorsecondary'),
  ClassOption(
      id: 13, name: 'Higher Institution', code: 'HI', sortOrder: 13, category: 'higherinstitution'),
];

ClassOption classOptionById(int id) => kClassOptions.firstWhere((c) => c.id == id);
