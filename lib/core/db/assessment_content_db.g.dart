// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assessment_content_db.dart';

// ignore_for_file: type=lint
class $SubjectsTable extends Subjects with TableInfo<$SubjectsTable, Subject> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubjectsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'subjects';
  @override
  VerificationContext validateIntegrity(
    Insertable<Subject> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Subject map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Subject(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $SubjectsTable createAlias(String alias) {
    return $SubjectsTable(attachedDatabase, alias);
  }
}

class Subject extends DataClass implements Insertable<Subject> {
  final int id;
  final String name;
  const Subject({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  SubjectsCompanion toCompanion(bool nullToAbsent) {
    return SubjectsCompanion(id: Value(id), name: Value(name));
  }

  factory Subject.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Subject(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  Subject copyWith({int? id, String? name}) =>
      Subject(id: id ?? this.id, name: name ?? this.name);
  Subject copyWithCompanion(SubjectsCompanion data) {
    return Subject(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Subject(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Subject && other.id == this.id && other.name == this.name);
}

class SubjectsCompanion extends UpdateCompanion<Subject> {
  final Value<int> id;
  final Value<String> name;
  const SubjectsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  SubjectsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
  }) : name = Value(name);
  static Insertable<Subject> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  SubjectsCompanion copyWith({Value<int>? id, Value<String>? name}) {
    return SubjectsCompanion(id: id ?? this.id, name: name ?? this.name);
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubjectsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _catNameMeta = const VerificationMeta(
    'catName',
  );
  @override
  late final GeneratedColumn<String> catName = GeneratedColumn<String>(
    'cat_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, catName];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<Category> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('cat_name')) {
      context.handle(
        _catNameMeta,
        catName.isAcceptableOrUnknown(data['cat_name']!, _catNameMeta),
      );
    } else if (isInserting) {
      context.missing(_catNameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      catName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cat_name'],
      )!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class Category extends DataClass implements Insertable<Category> {
  final int id;
  final String catName;
  const Category({required this.id, required this.catName});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['cat_name'] = Variable<String>(catName);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(id: Value(id), catName: Value(catName));
  }

  factory Category.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<int>(json['id']),
      catName: serializer.fromJson<String>(json['catName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'catName': serializer.toJson<String>(catName),
    };
  }

  Category copyWith({int? id, String? catName}) =>
      Category(id: id ?? this.id, catName: catName ?? this.catName);
  Category copyWithCompanion(CategoriesCompanion data) {
    return Category(
      id: data.id.present ? data.id.value : this.id,
      catName: data.catName.present ? data.catName.value : this.catName,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('catName: $catName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, catName);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.catName == this.catName);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<int> id;
  final Value<String> catName;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.catName = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String catName,
  }) : catName = Value(catName);
  static Insertable<Category> custom({
    Expression<int>? id,
    Expression<String>? catName,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (catName != null) 'cat_name': catName,
    });
  }

  CategoriesCompanion copyWith({Value<int>? id, Value<String>? catName}) {
    return CategoriesCompanion(
      id: id ?? this.id,
      catName: catName ?? this.catName,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (catName.present) {
      map['cat_name'] = Variable<String>(catName.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('catName: $catName')
          ..write(')'))
        .toString();
  }
}

class $YearsTable extends Years with TableInfo<$YearsTable, Year> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $YearsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _subjectIdMeta = const VerificationMeta(
    'subjectId',
  );
  @override
  late final GeneratedColumn<int> subjectId = GeneratedColumn<int>(
    'subject_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _yearNameMeta = const VerificationMeta(
    'yearName',
  );
  @override
  late final GeneratedColumn<String> yearName = GeneratedColumn<String>(
    'year_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, subjectId, yearName];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'years';
  @override
  VerificationContext validateIntegrity(
    Insertable<Year> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('subject_id')) {
      context.handle(
        _subjectIdMeta,
        subjectId.isAcceptableOrUnknown(data['subject_id']!, _subjectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_subjectIdMeta);
    }
    if (data.containsKey('year_name')) {
      context.handle(
        _yearNameMeta,
        yearName.isAcceptableOrUnknown(data['year_name']!, _yearNameMeta),
      );
    } else if (isInserting) {
      context.missing(_yearNameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Year map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Year(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      subjectId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}subject_id'],
      )!,
      yearName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}year_name'],
      )!,
    );
  }

  @override
  $YearsTable createAlias(String alias) {
    return $YearsTable(attachedDatabase, alias);
  }
}

class Year extends DataClass implements Insertable<Year> {
  final int id;
  final int subjectId;
  final String yearName;
  const Year({
    required this.id,
    required this.subjectId,
    required this.yearName,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['subject_id'] = Variable<int>(subjectId);
    map['year_name'] = Variable<String>(yearName);
    return map;
  }

  YearsCompanion toCompanion(bool nullToAbsent) {
    return YearsCompanion(
      id: Value(id),
      subjectId: Value(subjectId),
      yearName: Value(yearName),
    );
  }

  factory Year.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Year(
      id: serializer.fromJson<int>(json['id']),
      subjectId: serializer.fromJson<int>(json['subjectId']),
      yearName: serializer.fromJson<String>(json['yearName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'subjectId': serializer.toJson<int>(subjectId),
      'yearName': serializer.toJson<String>(yearName),
    };
  }

  Year copyWith({int? id, int? subjectId, String? yearName}) => Year(
    id: id ?? this.id,
    subjectId: subjectId ?? this.subjectId,
    yearName: yearName ?? this.yearName,
  );
  Year copyWithCompanion(YearsCompanion data) {
    return Year(
      id: data.id.present ? data.id.value : this.id,
      subjectId: data.subjectId.present ? data.subjectId.value : this.subjectId,
      yearName: data.yearName.present ? data.yearName.value : this.yearName,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Year(')
          ..write('id: $id, ')
          ..write('subjectId: $subjectId, ')
          ..write('yearName: $yearName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, subjectId, yearName);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Year &&
          other.id == this.id &&
          other.subjectId == this.subjectId &&
          other.yearName == this.yearName);
}

class YearsCompanion extends UpdateCompanion<Year> {
  final Value<int> id;
  final Value<int> subjectId;
  final Value<String> yearName;
  const YearsCompanion({
    this.id = const Value.absent(),
    this.subjectId = const Value.absent(),
    this.yearName = const Value.absent(),
  });
  YearsCompanion.insert({
    this.id = const Value.absent(),
    required int subjectId,
    required String yearName,
  }) : subjectId = Value(subjectId),
       yearName = Value(yearName);
  static Insertable<Year> custom({
    Expression<int>? id,
    Expression<int>? subjectId,
    Expression<String>? yearName,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (subjectId != null) 'subject_id': subjectId,
      if (yearName != null) 'year_name': yearName,
    });
  }

  YearsCompanion copyWith({
    Value<int>? id,
    Value<int>? subjectId,
    Value<String>? yearName,
  }) {
    return YearsCompanion(
      id: id ?? this.id,
      subjectId: subjectId ?? this.subjectId,
      yearName: yearName ?? this.yearName,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (subjectId.present) {
      map['subject_id'] = Variable<int>(subjectId.value);
    }
    if (yearName.present) {
      map['year_name'] = Variable<String>(yearName.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('YearsCompanion(')
          ..write('id: $id, ')
          ..write('subjectId: $subjectId, ')
          ..write('yearName: $yearName')
          ..write(')'))
        .toString();
  }
}

class $TestTypesTable extends TestTypes
    with TableInfo<$TestTypesTable, TestType> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TestTypesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _testTypeNameMeta = const VerificationMeta(
    'testTypeName',
  );
  @override
  late final GeneratedColumn<String> testTypeName = GeneratedColumn<String>(
    'test_type_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationMinutesMeta = const VerificationMeta(
    'durationMinutes',
  );
  @override
  late final GeneratedColumn<int> durationMinutes = GeneratedColumn<int>(
    'duration_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _numOfQuestionsMeta = const VerificationMeta(
    'numOfQuestions',
  );
  @override
  late final GeneratedColumn<int> numOfQuestions = GeneratedColumn<int>(
    'num_of_questions',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subjectIdMeta = const VerificationMeta(
    'subjectId',
  );
  @override
  late final GeneratedColumn<int> subjectId = GeneratedColumn<int>(
    'subject_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _assocCategoryIdMeta = const VerificationMeta(
    'assocCategoryId',
  );
  @override
  late final GeneratedColumn<int> assocCategoryId = GeneratedColumn<int>(
    'assoc_category_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    testTypeName,
    durationMinutes,
    numOfQuestions,
    subjectId,
    assocCategoryId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'test_types';
  @override
  VerificationContext validateIntegrity(
    Insertable<TestType> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('test_type_name')) {
      context.handle(
        _testTypeNameMeta,
        testTypeName.isAcceptableOrUnknown(
          data['test_type_name']!,
          _testTypeNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_testTypeNameMeta);
    }
    if (data.containsKey('duration_minutes')) {
      context.handle(
        _durationMinutesMeta,
        durationMinutes.isAcceptableOrUnknown(
          data['duration_minutes']!,
          _durationMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_durationMinutesMeta);
    }
    if (data.containsKey('num_of_questions')) {
      context.handle(
        _numOfQuestionsMeta,
        numOfQuestions.isAcceptableOrUnknown(
          data['num_of_questions']!,
          _numOfQuestionsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_numOfQuestionsMeta);
    }
    if (data.containsKey('subject_id')) {
      context.handle(
        _subjectIdMeta,
        subjectId.isAcceptableOrUnknown(data['subject_id']!, _subjectIdMeta),
      );
    }
    if (data.containsKey('assoc_category_id')) {
      context.handle(
        _assocCategoryIdMeta,
        assocCategoryId.isAcceptableOrUnknown(
          data['assoc_category_id']!,
          _assocCategoryIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TestType map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TestType(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      testTypeName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}test_type_name'],
      )!,
      durationMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_minutes'],
      )!,
      numOfQuestions: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}num_of_questions'],
      )!,
      subjectId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}subject_id'],
      ),
      assocCategoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}assoc_category_id'],
      ),
    );
  }

  @override
  $TestTypesTable createAlias(String alias) {
    return $TestTypesTable(attachedDatabase, alias);
  }
}

class TestType extends DataClass implements Insertable<TestType> {
  final int id;
  final String testTypeName;
  final int durationMinutes;
  final int numOfQuestions;
  final int? subjectId;
  final int? assocCategoryId;
  const TestType({
    required this.id,
    required this.testTypeName,
    required this.durationMinutes,
    required this.numOfQuestions,
    this.subjectId,
    this.assocCategoryId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['test_type_name'] = Variable<String>(testTypeName);
    map['duration_minutes'] = Variable<int>(durationMinutes);
    map['num_of_questions'] = Variable<int>(numOfQuestions);
    if (!nullToAbsent || subjectId != null) {
      map['subject_id'] = Variable<int>(subjectId);
    }
    if (!nullToAbsent || assocCategoryId != null) {
      map['assoc_category_id'] = Variable<int>(assocCategoryId);
    }
    return map;
  }

  TestTypesCompanion toCompanion(bool nullToAbsent) {
    return TestTypesCompanion(
      id: Value(id),
      testTypeName: Value(testTypeName),
      durationMinutes: Value(durationMinutes),
      numOfQuestions: Value(numOfQuestions),
      subjectId: subjectId == null && nullToAbsent
          ? const Value.absent()
          : Value(subjectId),
      assocCategoryId: assocCategoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(assocCategoryId),
    );
  }

  factory TestType.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TestType(
      id: serializer.fromJson<int>(json['id']),
      testTypeName: serializer.fromJson<String>(json['testTypeName']),
      durationMinutes: serializer.fromJson<int>(json['durationMinutes']),
      numOfQuestions: serializer.fromJson<int>(json['numOfQuestions']),
      subjectId: serializer.fromJson<int?>(json['subjectId']),
      assocCategoryId: serializer.fromJson<int?>(json['assocCategoryId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'testTypeName': serializer.toJson<String>(testTypeName),
      'durationMinutes': serializer.toJson<int>(durationMinutes),
      'numOfQuestions': serializer.toJson<int>(numOfQuestions),
      'subjectId': serializer.toJson<int?>(subjectId),
      'assocCategoryId': serializer.toJson<int?>(assocCategoryId),
    };
  }

  TestType copyWith({
    int? id,
    String? testTypeName,
    int? durationMinutes,
    int? numOfQuestions,
    Value<int?> subjectId = const Value.absent(),
    Value<int?> assocCategoryId = const Value.absent(),
  }) => TestType(
    id: id ?? this.id,
    testTypeName: testTypeName ?? this.testTypeName,
    durationMinutes: durationMinutes ?? this.durationMinutes,
    numOfQuestions: numOfQuestions ?? this.numOfQuestions,
    subjectId: subjectId.present ? subjectId.value : this.subjectId,
    assocCategoryId: assocCategoryId.present
        ? assocCategoryId.value
        : this.assocCategoryId,
  );
  TestType copyWithCompanion(TestTypesCompanion data) {
    return TestType(
      id: data.id.present ? data.id.value : this.id,
      testTypeName: data.testTypeName.present
          ? data.testTypeName.value
          : this.testTypeName,
      durationMinutes: data.durationMinutes.present
          ? data.durationMinutes.value
          : this.durationMinutes,
      numOfQuestions: data.numOfQuestions.present
          ? data.numOfQuestions.value
          : this.numOfQuestions,
      subjectId: data.subjectId.present ? data.subjectId.value : this.subjectId,
      assocCategoryId: data.assocCategoryId.present
          ? data.assocCategoryId.value
          : this.assocCategoryId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TestType(')
          ..write('id: $id, ')
          ..write('testTypeName: $testTypeName, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('numOfQuestions: $numOfQuestions, ')
          ..write('subjectId: $subjectId, ')
          ..write('assocCategoryId: $assocCategoryId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    testTypeName,
    durationMinutes,
    numOfQuestions,
    subjectId,
    assocCategoryId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TestType &&
          other.id == this.id &&
          other.testTypeName == this.testTypeName &&
          other.durationMinutes == this.durationMinutes &&
          other.numOfQuestions == this.numOfQuestions &&
          other.subjectId == this.subjectId &&
          other.assocCategoryId == this.assocCategoryId);
}

class TestTypesCompanion extends UpdateCompanion<TestType> {
  final Value<int> id;
  final Value<String> testTypeName;
  final Value<int> durationMinutes;
  final Value<int> numOfQuestions;
  final Value<int?> subjectId;
  final Value<int?> assocCategoryId;
  const TestTypesCompanion({
    this.id = const Value.absent(),
    this.testTypeName = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    this.numOfQuestions = const Value.absent(),
    this.subjectId = const Value.absent(),
    this.assocCategoryId = const Value.absent(),
  });
  TestTypesCompanion.insert({
    this.id = const Value.absent(),
    required String testTypeName,
    required int durationMinutes,
    required int numOfQuestions,
    this.subjectId = const Value.absent(),
    this.assocCategoryId = const Value.absent(),
  }) : testTypeName = Value(testTypeName),
       durationMinutes = Value(durationMinutes),
       numOfQuestions = Value(numOfQuestions);
  static Insertable<TestType> custom({
    Expression<int>? id,
    Expression<String>? testTypeName,
    Expression<int>? durationMinutes,
    Expression<int>? numOfQuestions,
    Expression<int>? subjectId,
    Expression<int>? assocCategoryId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (testTypeName != null) 'test_type_name': testTypeName,
      if (durationMinutes != null) 'duration_minutes': durationMinutes,
      if (numOfQuestions != null) 'num_of_questions': numOfQuestions,
      if (subjectId != null) 'subject_id': subjectId,
      if (assocCategoryId != null) 'assoc_category_id': assocCategoryId,
    });
  }

  TestTypesCompanion copyWith({
    Value<int>? id,
    Value<String>? testTypeName,
    Value<int>? durationMinutes,
    Value<int>? numOfQuestions,
    Value<int?>? subjectId,
    Value<int?>? assocCategoryId,
  }) {
    return TestTypesCompanion(
      id: id ?? this.id,
      testTypeName: testTypeName ?? this.testTypeName,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      numOfQuestions: numOfQuestions ?? this.numOfQuestions,
      subjectId: subjectId ?? this.subjectId,
      assocCategoryId: assocCategoryId ?? this.assocCategoryId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (testTypeName.present) {
      map['test_type_name'] = Variable<String>(testTypeName.value);
    }
    if (durationMinutes.present) {
      map['duration_minutes'] = Variable<int>(durationMinutes.value);
    }
    if (numOfQuestions.present) {
      map['num_of_questions'] = Variable<int>(numOfQuestions.value);
    }
    if (subjectId.present) {
      map['subject_id'] = Variable<int>(subjectId.value);
    }
    if (assocCategoryId.present) {
      map['assoc_category_id'] = Variable<int>(assocCategoryId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TestTypesCompanion(')
          ..write('id: $id, ')
          ..write('testTypeName: $testTypeName, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('numOfQuestions: $numOfQuestions, ')
          ..write('subjectId: $subjectId, ')
          ..write('assocCategoryId: $assocCategoryId')
          ..write(')'))
        .toString();
  }
}

class $PassagesTable extends Passages with TableInfo<$PassagesTable, Passage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PassagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _yearIdMeta = const VerificationMeta('yearId');
  @override
  late final GeneratedColumn<int> yearId = GeneratedColumn<int>(
    'year_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _passageTextMeta = const VerificationMeta(
    'passageText',
  );
  @override
  late final GeneratedColumn<String> passageText = GeneratedColumn<String>(
    'passage_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, title, yearId, passageText];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'passages';
  @override
  VerificationContext validateIntegrity(
    Insertable<Passage> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('year_id')) {
      context.handle(
        _yearIdMeta,
        yearId.isAcceptableOrUnknown(data['year_id']!, _yearIdMeta),
      );
    }
    if (data.containsKey('passage_text')) {
      context.handle(
        _passageTextMeta,
        passageText.isAcceptableOrUnknown(
          data['passage_text']!,
          _passageTextMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_passageTextMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Passage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Passage(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      ),
      yearId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year_id'],
      ),
      passageText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}passage_text'],
      )!,
    );
  }

  @override
  $PassagesTable createAlias(String alias) {
    return $PassagesTable(attachedDatabase, alias);
  }
}

class Passage extends DataClass implements Insertable<Passage> {
  final int id;
  final String? title;
  final int? yearId;
  final String passageText;
  const Passage({
    required this.id,
    this.title,
    this.yearId,
    required this.passageText,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || yearId != null) {
      map['year_id'] = Variable<int>(yearId);
    }
    map['passage_text'] = Variable<String>(passageText);
    return map;
  }

  PassagesCompanion toCompanion(bool nullToAbsent) {
    return PassagesCompanion(
      id: Value(id),
      title: title == null && nullToAbsent
          ? const Value.absent()
          : Value(title),
      yearId: yearId == null && nullToAbsent
          ? const Value.absent()
          : Value(yearId),
      passageText: Value(passageText),
    );
  }

  factory Passage.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Passage(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String?>(json['title']),
      yearId: serializer.fromJson<int?>(json['yearId']),
      passageText: serializer.fromJson<String>(json['passageText']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String?>(title),
      'yearId': serializer.toJson<int?>(yearId),
      'passageText': serializer.toJson<String>(passageText),
    };
  }

  Passage copyWith({
    int? id,
    Value<String?> title = const Value.absent(),
    Value<int?> yearId = const Value.absent(),
    String? passageText,
  }) => Passage(
    id: id ?? this.id,
    title: title.present ? title.value : this.title,
    yearId: yearId.present ? yearId.value : this.yearId,
    passageText: passageText ?? this.passageText,
  );
  Passage copyWithCompanion(PassagesCompanion data) {
    return Passage(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      yearId: data.yearId.present ? data.yearId.value : this.yearId,
      passageText: data.passageText.present
          ? data.passageText.value
          : this.passageText,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Passage(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('yearId: $yearId, ')
          ..write('passageText: $passageText')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, yearId, passageText);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Passage &&
          other.id == this.id &&
          other.title == this.title &&
          other.yearId == this.yearId &&
          other.passageText == this.passageText);
}

class PassagesCompanion extends UpdateCompanion<Passage> {
  final Value<int> id;
  final Value<String?> title;
  final Value<int?> yearId;
  final Value<String> passageText;
  const PassagesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.yearId = const Value.absent(),
    this.passageText = const Value.absent(),
  });
  PassagesCompanion.insert({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.yearId = const Value.absent(),
    required String passageText,
  }) : passageText = Value(passageText);
  static Insertable<Passage> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<int>? yearId,
    Expression<String>? passageText,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (yearId != null) 'year_id': yearId,
      if (passageText != null) 'passage_text': passageText,
    });
  }

  PassagesCompanion copyWith({
    Value<int>? id,
    Value<String?>? title,
    Value<int?>? yearId,
    Value<String>? passageText,
  }) {
    return PassagesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      yearId: yearId ?? this.yearId,
      passageText: passageText ?? this.passageText,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (yearId.present) {
      map['year_id'] = Variable<int>(yearId.value);
    }
    if (passageText.present) {
      map['passage_text'] = Variable<String>(passageText.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PassagesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('yearId: $yearId, ')
          ..write('passageText: $passageText')
          ..write(')'))
        .toString();
  }
}

class $QuestionsTable extends Questions
    with TableInfo<$QuestionsTable, Question> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuestionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _subjectIdMeta = const VerificationMeta(
    'subjectId',
  );
  @override
  late final GeneratedColumn<int> subjectId = GeneratedColumn<int>(
    'subject_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _yearIdMeta = const VerificationMeta('yearId');
  @override
  late final GeneratedColumn<int> yearId = GeneratedColumn<int>(
    'year_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _passageIdMeta = const VerificationMeta(
    'passageId',
  );
  @override
  late final GeneratedColumn<int> passageId = GeneratedColumn<int>(
    'passage_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _testTypeIdMeta = const VerificationMeta(
    'testTypeId',
  );
  @override
  late final GeneratedColumn<int> testTypeId = GeneratedColumn<int>(
    'test_type_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _questionTextMeta = const VerificationMeta(
    'questionText',
  );
  @override
  late final GeneratedColumn<String> questionText = GeneratedColumn<String>(
    'question_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imagePathMeta = const VerificationMeta(
    'imagePath',
  );
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
    'image_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _optionAMeta = const VerificationMeta(
    'optionA',
  );
  @override
  late final GeneratedColumn<String> optionA = GeneratedColumn<String>(
    'option_a',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _optionBMeta = const VerificationMeta(
    'optionB',
  );
  @override
  late final GeneratedColumn<String> optionB = GeneratedColumn<String>(
    'option_b',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _optionCMeta = const VerificationMeta(
    'optionC',
  );
  @override
  late final GeneratedColumn<String> optionC = GeneratedColumn<String>(
    'option_c',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _optionDMeta = const VerificationMeta(
    'optionD',
  );
  @override
  late final GeneratedColumn<String> optionD = GeneratedColumn<String>(
    'option_d',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _optionEMeta = const VerificationMeta(
    'optionE',
  );
  @override
  late final GeneratedColumn<String> optionE = GeneratedColumn<String>(
    'option_e',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _correctOptionMeta = const VerificationMeta(
    'correctOption',
  );
  @override
  late final GeneratedColumn<String> correctOption = GeneratedColumn<String>(
    'correct_option',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _explanationMeta = const VerificationMeta(
    'explanation',
  );
  @override
  late final GeneratedColumn<String> explanation = GeneratedColumn<String>(
    'explanation',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    subjectId,
    categoryId,
    yearId,
    passageId,
    testTypeId,
    questionText,
    imagePath,
    optionA,
    optionB,
    optionC,
    optionD,
    optionE,
    correctOption,
    explanation,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'questions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Question> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('subject_id')) {
      context.handle(
        _subjectIdMeta,
        subjectId.isAcceptableOrUnknown(data['subject_id']!, _subjectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_subjectIdMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('year_id')) {
      context.handle(
        _yearIdMeta,
        yearId.isAcceptableOrUnknown(data['year_id']!, _yearIdMeta),
      );
    } else if (isInserting) {
      context.missing(_yearIdMeta);
    }
    if (data.containsKey('passage_id')) {
      context.handle(
        _passageIdMeta,
        passageId.isAcceptableOrUnknown(data['passage_id']!, _passageIdMeta),
      );
    }
    if (data.containsKey('test_type_id')) {
      context.handle(
        _testTypeIdMeta,
        testTypeId.isAcceptableOrUnknown(
          data['test_type_id']!,
          _testTypeIdMeta,
        ),
      );
    }
    if (data.containsKey('question_text')) {
      context.handle(
        _questionTextMeta,
        questionText.isAcceptableOrUnknown(
          data['question_text']!,
          _questionTextMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_questionTextMeta);
    }
    if (data.containsKey('image_path')) {
      context.handle(
        _imagePathMeta,
        imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta),
      );
    }
    if (data.containsKey('option_a')) {
      context.handle(
        _optionAMeta,
        optionA.isAcceptableOrUnknown(data['option_a']!, _optionAMeta),
      );
    } else if (isInserting) {
      context.missing(_optionAMeta);
    }
    if (data.containsKey('option_b')) {
      context.handle(
        _optionBMeta,
        optionB.isAcceptableOrUnknown(data['option_b']!, _optionBMeta),
      );
    } else if (isInserting) {
      context.missing(_optionBMeta);
    }
    if (data.containsKey('option_c')) {
      context.handle(
        _optionCMeta,
        optionC.isAcceptableOrUnknown(data['option_c']!, _optionCMeta),
      );
    } else if (isInserting) {
      context.missing(_optionCMeta);
    }
    if (data.containsKey('option_d')) {
      context.handle(
        _optionDMeta,
        optionD.isAcceptableOrUnknown(data['option_d']!, _optionDMeta),
      );
    } else if (isInserting) {
      context.missing(_optionDMeta);
    }
    if (data.containsKey('option_e')) {
      context.handle(
        _optionEMeta,
        optionE.isAcceptableOrUnknown(data['option_e']!, _optionEMeta),
      );
    }
    if (data.containsKey('correct_option')) {
      context.handle(
        _correctOptionMeta,
        correctOption.isAcceptableOrUnknown(
          data['correct_option']!,
          _correctOptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_correctOptionMeta);
    }
    if (data.containsKey('explanation')) {
      context.handle(
        _explanationMeta,
        explanation.isAcceptableOrUnknown(
          data['explanation']!,
          _explanationMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Question map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Question(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      subjectId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}subject_id'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      )!,
      yearId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year_id'],
      )!,
      passageId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}passage_id'],
      ),
      testTypeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}test_type_id'],
      ),
      questionText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}question_text'],
      )!,
      imagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_path'],
      ),
      optionA: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}option_a'],
      )!,
      optionB: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}option_b'],
      )!,
      optionC: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}option_c'],
      )!,
      optionD: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}option_d'],
      )!,
      optionE: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}option_e'],
      ),
      correctOption: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}correct_option'],
      )!,
      explanation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}explanation'],
      ),
    );
  }

  @override
  $QuestionsTable createAlias(String alias) {
    return $QuestionsTable(attachedDatabase, alias);
  }
}

class Question extends DataClass implements Insertable<Question> {
  final int id;
  final int subjectId;
  final int categoryId;
  final int yearId;
  final int? passageId;
  final int? testTypeId;
  final String questionText;
  final String? imagePath;
  final String optionA;
  final String optionB;
  final String optionC;
  final String optionD;
  final String? optionE;
  final String correctOption;
  final String? explanation;
  const Question({
    required this.id,
    required this.subjectId,
    required this.categoryId,
    required this.yearId,
    this.passageId,
    this.testTypeId,
    required this.questionText,
    this.imagePath,
    required this.optionA,
    required this.optionB,
    required this.optionC,
    required this.optionD,
    this.optionE,
    required this.correctOption,
    this.explanation,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['subject_id'] = Variable<int>(subjectId);
    map['category_id'] = Variable<int>(categoryId);
    map['year_id'] = Variable<int>(yearId);
    if (!nullToAbsent || passageId != null) {
      map['passage_id'] = Variable<int>(passageId);
    }
    if (!nullToAbsent || testTypeId != null) {
      map['test_type_id'] = Variable<int>(testTypeId);
    }
    map['question_text'] = Variable<String>(questionText);
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = Variable<String>(imagePath);
    }
    map['option_a'] = Variable<String>(optionA);
    map['option_b'] = Variable<String>(optionB);
    map['option_c'] = Variable<String>(optionC);
    map['option_d'] = Variable<String>(optionD);
    if (!nullToAbsent || optionE != null) {
      map['option_e'] = Variable<String>(optionE);
    }
    map['correct_option'] = Variable<String>(correctOption);
    if (!nullToAbsent || explanation != null) {
      map['explanation'] = Variable<String>(explanation);
    }
    return map;
  }

  QuestionsCompanion toCompanion(bool nullToAbsent) {
    return QuestionsCompanion(
      id: Value(id),
      subjectId: Value(subjectId),
      categoryId: Value(categoryId),
      yearId: Value(yearId),
      passageId: passageId == null && nullToAbsent
          ? const Value.absent()
          : Value(passageId),
      testTypeId: testTypeId == null && nullToAbsent
          ? const Value.absent()
          : Value(testTypeId),
      questionText: Value(questionText),
      imagePath: imagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagePath),
      optionA: Value(optionA),
      optionB: Value(optionB),
      optionC: Value(optionC),
      optionD: Value(optionD),
      optionE: optionE == null && nullToAbsent
          ? const Value.absent()
          : Value(optionE),
      correctOption: Value(correctOption),
      explanation: explanation == null && nullToAbsent
          ? const Value.absent()
          : Value(explanation),
    );
  }

  factory Question.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Question(
      id: serializer.fromJson<int>(json['id']),
      subjectId: serializer.fromJson<int>(json['subjectId']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      yearId: serializer.fromJson<int>(json['yearId']),
      passageId: serializer.fromJson<int?>(json['passageId']),
      testTypeId: serializer.fromJson<int?>(json['testTypeId']),
      questionText: serializer.fromJson<String>(json['questionText']),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
      optionA: serializer.fromJson<String>(json['optionA']),
      optionB: serializer.fromJson<String>(json['optionB']),
      optionC: serializer.fromJson<String>(json['optionC']),
      optionD: serializer.fromJson<String>(json['optionD']),
      optionE: serializer.fromJson<String?>(json['optionE']),
      correctOption: serializer.fromJson<String>(json['correctOption']),
      explanation: serializer.fromJson<String?>(json['explanation']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'subjectId': serializer.toJson<int>(subjectId),
      'categoryId': serializer.toJson<int>(categoryId),
      'yearId': serializer.toJson<int>(yearId),
      'passageId': serializer.toJson<int?>(passageId),
      'testTypeId': serializer.toJson<int?>(testTypeId),
      'questionText': serializer.toJson<String>(questionText),
      'imagePath': serializer.toJson<String?>(imagePath),
      'optionA': serializer.toJson<String>(optionA),
      'optionB': serializer.toJson<String>(optionB),
      'optionC': serializer.toJson<String>(optionC),
      'optionD': serializer.toJson<String>(optionD),
      'optionE': serializer.toJson<String?>(optionE),
      'correctOption': serializer.toJson<String>(correctOption),
      'explanation': serializer.toJson<String?>(explanation),
    };
  }

  Question copyWith({
    int? id,
    int? subjectId,
    int? categoryId,
    int? yearId,
    Value<int?> passageId = const Value.absent(),
    Value<int?> testTypeId = const Value.absent(),
    String? questionText,
    Value<String?> imagePath = const Value.absent(),
    String? optionA,
    String? optionB,
    String? optionC,
    String? optionD,
    Value<String?> optionE = const Value.absent(),
    String? correctOption,
    Value<String?> explanation = const Value.absent(),
  }) => Question(
    id: id ?? this.id,
    subjectId: subjectId ?? this.subjectId,
    categoryId: categoryId ?? this.categoryId,
    yearId: yearId ?? this.yearId,
    passageId: passageId.present ? passageId.value : this.passageId,
    testTypeId: testTypeId.present ? testTypeId.value : this.testTypeId,
    questionText: questionText ?? this.questionText,
    imagePath: imagePath.present ? imagePath.value : this.imagePath,
    optionA: optionA ?? this.optionA,
    optionB: optionB ?? this.optionB,
    optionC: optionC ?? this.optionC,
    optionD: optionD ?? this.optionD,
    optionE: optionE.present ? optionE.value : this.optionE,
    correctOption: correctOption ?? this.correctOption,
    explanation: explanation.present ? explanation.value : this.explanation,
  );
  Question copyWithCompanion(QuestionsCompanion data) {
    return Question(
      id: data.id.present ? data.id.value : this.id,
      subjectId: data.subjectId.present ? data.subjectId.value : this.subjectId,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      yearId: data.yearId.present ? data.yearId.value : this.yearId,
      passageId: data.passageId.present ? data.passageId.value : this.passageId,
      testTypeId: data.testTypeId.present
          ? data.testTypeId.value
          : this.testTypeId,
      questionText: data.questionText.present
          ? data.questionText.value
          : this.questionText,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      optionA: data.optionA.present ? data.optionA.value : this.optionA,
      optionB: data.optionB.present ? data.optionB.value : this.optionB,
      optionC: data.optionC.present ? data.optionC.value : this.optionC,
      optionD: data.optionD.present ? data.optionD.value : this.optionD,
      optionE: data.optionE.present ? data.optionE.value : this.optionE,
      correctOption: data.correctOption.present
          ? data.correctOption.value
          : this.correctOption,
      explanation: data.explanation.present
          ? data.explanation.value
          : this.explanation,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Question(')
          ..write('id: $id, ')
          ..write('subjectId: $subjectId, ')
          ..write('categoryId: $categoryId, ')
          ..write('yearId: $yearId, ')
          ..write('passageId: $passageId, ')
          ..write('testTypeId: $testTypeId, ')
          ..write('questionText: $questionText, ')
          ..write('imagePath: $imagePath, ')
          ..write('optionA: $optionA, ')
          ..write('optionB: $optionB, ')
          ..write('optionC: $optionC, ')
          ..write('optionD: $optionD, ')
          ..write('optionE: $optionE, ')
          ..write('correctOption: $correctOption, ')
          ..write('explanation: $explanation')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    subjectId,
    categoryId,
    yearId,
    passageId,
    testTypeId,
    questionText,
    imagePath,
    optionA,
    optionB,
    optionC,
    optionD,
    optionE,
    correctOption,
    explanation,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Question &&
          other.id == this.id &&
          other.subjectId == this.subjectId &&
          other.categoryId == this.categoryId &&
          other.yearId == this.yearId &&
          other.passageId == this.passageId &&
          other.testTypeId == this.testTypeId &&
          other.questionText == this.questionText &&
          other.imagePath == this.imagePath &&
          other.optionA == this.optionA &&
          other.optionB == this.optionB &&
          other.optionC == this.optionC &&
          other.optionD == this.optionD &&
          other.optionE == this.optionE &&
          other.correctOption == this.correctOption &&
          other.explanation == this.explanation);
}

class QuestionsCompanion extends UpdateCompanion<Question> {
  final Value<int> id;
  final Value<int> subjectId;
  final Value<int> categoryId;
  final Value<int> yearId;
  final Value<int?> passageId;
  final Value<int?> testTypeId;
  final Value<String> questionText;
  final Value<String?> imagePath;
  final Value<String> optionA;
  final Value<String> optionB;
  final Value<String> optionC;
  final Value<String> optionD;
  final Value<String?> optionE;
  final Value<String> correctOption;
  final Value<String?> explanation;
  const QuestionsCompanion({
    this.id = const Value.absent(),
    this.subjectId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.yearId = const Value.absent(),
    this.passageId = const Value.absent(),
    this.testTypeId = const Value.absent(),
    this.questionText = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.optionA = const Value.absent(),
    this.optionB = const Value.absent(),
    this.optionC = const Value.absent(),
    this.optionD = const Value.absent(),
    this.optionE = const Value.absent(),
    this.correctOption = const Value.absent(),
    this.explanation = const Value.absent(),
  });
  QuestionsCompanion.insert({
    this.id = const Value.absent(),
    required int subjectId,
    required int categoryId,
    required int yearId,
    this.passageId = const Value.absent(),
    this.testTypeId = const Value.absent(),
    required String questionText,
    this.imagePath = const Value.absent(),
    required String optionA,
    required String optionB,
    required String optionC,
    required String optionD,
    this.optionE = const Value.absent(),
    required String correctOption,
    this.explanation = const Value.absent(),
  }) : subjectId = Value(subjectId),
       categoryId = Value(categoryId),
       yearId = Value(yearId),
       questionText = Value(questionText),
       optionA = Value(optionA),
       optionB = Value(optionB),
       optionC = Value(optionC),
       optionD = Value(optionD),
       correctOption = Value(correctOption);
  static Insertable<Question> custom({
    Expression<int>? id,
    Expression<int>? subjectId,
    Expression<int>? categoryId,
    Expression<int>? yearId,
    Expression<int>? passageId,
    Expression<int>? testTypeId,
    Expression<String>? questionText,
    Expression<String>? imagePath,
    Expression<String>? optionA,
    Expression<String>? optionB,
    Expression<String>? optionC,
    Expression<String>? optionD,
    Expression<String>? optionE,
    Expression<String>? correctOption,
    Expression<String>? explanation,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (subjectId != null) 'subject_id': subjectId,
      if (categoryId != null) 'category_id': categoryId,
      if (yearId != null) 'year_id': yearId,
      if (passageId != null) 'passage_id': passageId,
      if (testTypeId != null) 'test_type_id': testTypeId,
      if (questionText != null) 'question_text': questionText,
      if (imagePath != null) 'image_path': imagePath,
      if (optionA != null) 'option_a': optionA,
      if (optionB != null) 'option_b': optionB,
      if (optionC != null) 'option_c': optionC,
      if (optionD != null) 'option_d': optionD,
      if (optionE != null) 'option_e': optionE,
      if (correctOption != null) 'correct_option': correctOption,
      if (explanation != null) 'explanation': explanation,
    });
  }

  QuestionsCompanion copyWith({
    Value<int>? id,
    Value<int>? subjectId,
    Value<int>? categoryId,
    Value<int>? yearId,
    Value<int?>? passageId,
    Value<int?>? testTypeId,
    Value<String>? questionText,
    Value<String?>? imagePath,
    Value<String>? optionA,
    Value<String>? optionB,
    Value<String>? optionC,
    Value<String>? optionD,
    Value<String?>? optionE,
    Value<String>? correctOption,
    Value<String?>? explanation,
  }) {
    return QuestionsCompanion(
      id: id ?? this.id,
      subjectId: subjectId ?? this.subjectId,
      categoryId: categoryId ?? this.categoryId,
      yearId: yearId ?? this.yearId,
      passageId: passageId ?? this.passageId,
      testTypeId: testTypeId ?? this.testTypeId,
      questionText: questionText ?? this.questionText,
      imagePath: imagePath ?? this.imagePath,
      optionA: optionA ?? this.optionA,
      optionB: optionB ?? this.optionB,
      optionC: optionC ?? this.optionC,
      optionD: optionD ?? this.optionD,
      optionE: optionE ?? this.optionE,
      correctOption: correctOption ?? this.correctOption,
      explanation: explanation ?? this.explanation,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (subjectId.present) {
      map['subject_id'] = Variable<int>(subjectId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (yearId.present) {
      map['year_id'] = Variable<int>(yearId.value);
    }
    if (passageId.present) {
      map['passage_id'] = Variable<int>(passageId.value);
    }
    if (testTypeId.present) {
      map['test_type_id'] = Variable<int>(testTypeId.value);
    }
    if (questionText.present) {
      map['question_text'] = Variable<String>(questionText.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (optionA.present) {
      map['option_a'] = Variable<String>(optionA.value);
    }
    if (optionB.present) {
      map['option_b'] = Variable<String>(optionB.value);
    }
    if (optionC.present) {
      map['option_c'] = Variable<String>(optionC.value);
    }
    if (optionD.present) {
      map['option_d'] = Variable<String>(optionD.value);
    }
    if (optionE.present) {
      map['option_e'] = Variable<String>(optionE.value);
    }
    if (correctOption.present) {
      map['correct_option'] = Variable<String>(correctOption.value);
    }
    if (explanation.present) {
      map['explanation'] = Variable<String>(explanation.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuestionsCompanion(')
          ..write('id: $id, ')
          ..write('subjectId: $subjectId, ')
          ..write('categoryId: $categoryId, ')
          ..write('yearId: $yearId, ')
          ..write('passageId: $passageId, ')
          ..write('testTypeId: $testTypeId, ')
          ..write('questionText: $questionText, ')
          ..write('imagePath: $imagePath, ')
          ..write('optionA: $optionA, ')
          ..write('optionB: $optionB, ')
          ..write('optionC: $optionC, ')
          ..write('optionD: $optionD, ')
          ..write('optionE: $optionE, ')
          ..write('correctOption: $correctOption, ')
          ..write('explanation: $explanation')
          ..write(')'))
        .toString();
  }
}

class $InstalledAssessmentPacksTable extends InstalledAssessmentPacks
    with TableInfo<$InstalledAssessmentPacksTable, InstalledAssessmentPack> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InstalledAssessmentPacksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _scopeTypeMeta = const VerificationMeta(
    'scopeType',
  );
  @override
  late final GeneratedColumn<String> scopeType = GeneratedColumn<String>(
    'scope_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scopeIdMeta = const VerificationMeta(
    'scopeId',
  );
  @override
  late final GeneratedColumn<int> scopeId = GeneratedColumn<int>(
    'scope_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<String> version = GeneratedColumn<String>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _checksumMeta = const VerificationMeta(
    'checksum',
  );
  @override
  late final GeneratedColumn<String> checksum = GeneratedColumn<String>(
    'checksum',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sizeBytesMeta = const VerificationMeta(
    'sizeBytes',
  );
  @override
  late final GeneratedColumn<int> sizeBytes = GeneratedColumn<int>(
    'size_bytes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _installedAtMeta = const VerificationMeta(
    'installedAt',
  );
  @override
  late final GeneratedColumn<String> installedAt = GeneratedColumn<String>(
    'installed_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    scopeType,
    scopeId,
    version,
    checksum,
    sizeBytes,
    installedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'installed_assessment_packs';
  @override
  VerificationContext validateIntegrity(
    Insertable<InstalledAssessmentPack> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('scope_type')) {
      context.handle(
        _scopeTypeMeta,
        scopeType.isAcceptableOrUnknown(data['scope_type']!, _scopeTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_scopeTypeMeta);
    }
    if (data.containsKey('scope_id')) {
      context.handle(
        _scopeIdMeta,
        scopeId.isAcceptableOrUnknown(data['scope_id']!, _scopeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_scopeIdMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('checksum')) {
      context.handle(
        _checksumMeta,
        checksum.isAcceptableOrUnknown(data['checksum']!, _checksumMeta),
      );
    } else if (isInserting) {
      context.missing(_checksumMeta);
    }
    if (data.containsKey('size_bytes')) {
      context.handle(
        _sizeBytesMeta,
        sizeBytes.isAcceptableOrUnknown(data['size_bytes']!, _sizeBytesMeta),
      );
    } else if (isInserting) {
      context.missing(_sizeBytesMeta);
    }
    if (data.containsKey('installed_at')) {
      context.handle(
        _installedAtMeta,
        installedAt.isAcceptableOrUnknown(
          data['installed_at']!,
          _installedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_installedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InstalledAssessmentPack map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InstalledAssessmentPack(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      scopeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scope_type'],
      )!,
      scopeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}scope_id'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}version'],
      )!,
      checksum: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}checksum'],
      )!,
      sizeBytes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}size_bytes'],
      )!,
      installedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}installed_at'],
      )!,
    );
  }

  @override
  $InstalledAssessmentPacksTable createAlias(String alias) {
    return $InstalledAssessmentPacksTable(attachedDatabase, alias);
  }
}

class InstalledAssessmentPack extends DataClass
    implements Insertable<InstalledAssessmentPack> {
  final int id;
  final String scopeType;
  final int scopeId;
  final String version;
  final String checksum;
  final int sizeBytes;
  final String installedAt;
  const InstalledAssessmentPack({
    required this.id,
    required this.scopeType,
    required this.scopeId,
    required this.version,
    required this.checksum,
    required this.sizeBytes,
    required this.installedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['scope_type'] = Variable<String>(scopeType);
    map['scope_id'] = Variable<int>(scopeId);
    map['version'] = Variable<String>(version);
    map['checksum'] = Variable<String>(checksum);
    map['size_bytes'] = Variable<int>(sizeBytes);
    map['installed_at'] = Variable<String>(installedAt);
    return map;
  }

  InstalledAssessmentPacksCompanion toCompanion(bool nullToAbsent) {
    return InstalledAssessmentPacksCompanion(
      id: Value(id),
      scopeType: Value(scopeType),
      scopeId: Value(scopeId),
      version: Value(version),
      checksum: Value(checksum),
      sizeBytes: Value(sizeBytes),
      installedAt: Value(installedAt),
    );
  }

  factory InstalledAssessmentPack.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InstalledAssessmentPack(
      id: serializer.fromJson<int>(json['id']),
      scopeType: serializer.fromJson<String>(json['scopeType']),
      scopeId: serializer.fromJson<int>(json['scopeId']),
      version: serializer.fromJson<String>(json['version']),
      checksum: serializer.fromJson<String>(json['checksum']),
      sizeBytes: serializer.fromJson<int>(json['sizeBytes']),
      installedAt: serializer.fromJson<String>(json['installedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'scopeType': serializer.toJson<String>(scopeType),
      'scopeId': serializer.toJson<int>(scopeId),
      'version': serializer.toJson<String>(version),
      'checksum': serializer.toJson<String>(checksum),
      'sizeBytes': serializer.toJson<int>(sizeBytes),
      'installedAt': serializer.toJson<String>(installedAt),
    };
  }

  InstalledAssessmentPack copyWith({
    int? id,
    String? scopeType,
    int? scopeId,
    String? version,
    String? checksum,
    int? sizeBytes,
    String? installedAt,
  }) => InstalledAssessmentPack(
    id: id ?? this.id,
    scopeType: scopeType ?? this.scopeType,
    scopeId: scopeId ?? this.scopeId,
    version: version ?? this.version,
    checksum: checksum ?? this.checksum,
    sizeBytes: sizeBytes ?? this.sizeBytes,
    installedAt: installedAt ?? this.installedAt,
  );
  InstalledAssessmentPack copyWithCompanion(
    InstalledAssessmentPacksCompanion data,
  ) {
    return InstalledAssessmentPack(
      id: data.id.present ? data.id.value : this.id,
      scopeType: data.scopeType.present ? data.scopeType.value : this.scopeType,
      scopeId: data.scopeId.present ? data.scopeId.value : this.scopeId,
      version: data.version.present ? data.version.value : this.version,
      checksum: data.checksum.present ? data.checksum.value : this.checksum,
      sizeBytes: data.sizeBytes.present ? data.sizeBytes.value : this.sizeBytes,
      installedAt: data.installedAt.present
          ? data.installedAt.value
          : this.installedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InstalledAssessmentPack(')
          ..write('id: $id, ')
          ..write('scopeType: $scopeType, ')
          ..write('scopeId: $scopeId, ')
          ..write('version: $version, ')
          ..write('checksum: $checksum, ')
          ..write('sizeBytes: $sizeBytes, ')
          ..write('installedAt: $installedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    scopeType,
    scopeId,
    version,
    checksum,
    sizeBytes,
    installedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InstalledAssessmentPack &&
          other.id == this.id &&
          other.scopeType == this.scopeType &&
          other.scopeId == this.scopeId &&
          other.version == this.version &&
          other.checksum == this.checksum &&
          other.sizeBytes == this.sizeBytes &&
          other.installedAt == this.installedAt);
}

class InstalledAssessmentPacksCompanion
    extends UpdateCompanion<InstalledAssessmentPack> {
  final Value<int> id;
  final Value<String> scopeType;
  final Value<int> scopeId;
  final Value<String> version;
  final Value<String> checksum;
  final Value<int> sizeBytes;
  final Value<String> installedAt;
  const InstalledAssessmentPacksCompanion({
    this.id = const Value.absent(),
    this.scopeType = const Value.absent(),
    this.scopeId = const Value.absent(),
    this.version = const Value.absent(),
    this.checksum = const Value.absent(),
    this.sizeBytes = const Value.absent(),
    this.installedAt = const Value.absent(),
  });
  InstalledAssessmentPacksCompanion.insert({
    this.id = const Value.absent(),
    required String scopeType,
    required int scopeId,
    required String version,
    required String checksum,
    required int sizeBytes,
    required String installedAt,
  }) : scopeType = Value(scopeType),
       scopeId = Value(scopeId),
       version = Value(version),
       checksum = Value(checksum),
       sizeBytes = Value(sizeBytes),
       installedAt = Value(installedAt);
  static Insertable<InstalledAssessmentPack> custom({
    Expression<int>? id,
    Expression<String>? scopeType,
    Expression<int>? scopeId,
    Expression<String>? version,
    Expression<String>? checksum,
    Expression<int>? sizeBytes,
    Expression<String>? installedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (scopeType != null) 'scope_type': scopeType,
      if (scopeId != null) 'scope_id': scopeId,
      if (version != null) 'version': version,
      if (checksum != null) 'checksum': checksum,
      if (sizeBytes != null) 'size_bytes': sizeBytes,
      if (installedAt != null) 'installed_at': installedAt,
    });
  }

  InstalledAssessmentPacksCompanion copyWith({
    Value<int>? id,
    Value<String>? scopeType,
    Value<int>? scopeId,
    Value<String>? version,
    Value<String>? checksum,
    Value<int>? sizeBytes,
    Value<String>? installedAt,
  }) {
    return InstalledAssessmentPacksCompanion(
      id: id ?? this.id,
      scopeType: scopeType ?? this.scopeType,
      scopeId: scopeId ?? this.scopeId,
      version: version ?? this.version,
      checksum: checksum ?? this.checksum,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      installedAt: installedAt ?? this.installedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (scopeType.present) {
      map['scope_type'] = Variable<String>(scopeType.value);
    }
    if (scopeId.present) {
      map['scope_id'] = Variable<int>(scopeId.value);
    }
    if (version.present) {
      map['version'] = Variable<String>(version.value);
    }
    if (checksum.present) {
      map['checksum'] = Variable<String>(checksum.value);
    }
    if (sizeBytes.present) {
      map['size_bytes'] = Variable<int>(sizeBytes.value);
    }
    if (installedAt.present) {
      map['installed_at'] = Variable<String>(installedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InstalledAssessmentPacksCompanion(')
          ..write('id: $id, ')
          ..write('scopeType: $scopeType, ')
          ..write('scopeId: $scopeId, ')
          ..write('version: $version, ')
          ..write('checksum: $checksum, ')
          ..write('sizeBytes: $sizeBytes, ')
          ..write('installedAt: $installedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AssessmentContentDb extends GeneratedDatabase {
  _$AssessmentContentDb(QueryExecutor e) : super(e);
  $AssessmentContentDbManager get managers => $AssessmentContentDbManager(this);
  late final $SubjectsTable subjects = $SubjectsTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $YearsTable years = $YearsTable(this);
  late final $TestTypesTable testTypes = $TestTypesTable(this);
  late final $PassagesTable passages = $PassagesTable(this);
  late final $QuestionsTable questions = $QuestionsTable(this);
  late final $InstalledAssessmentPacksTable installedAssessmentPacks =
      $InstalledAssessmentPacksTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    subjects,
    categories,
    years,
    testTypes,
    passages,
    questions,
    installedAssessmentPacks,
  ];
}

typedef $$SubjectsTableCreateCompanionBuilder =
    SubjectsCompanion Function({Value<int> id, required String name});
typedef $$SubjectsTableUpdateCompanionBuilder =
    SubjectsCompanion Function({Value<int> id, Value<String> name});

class $$SubjectsTableFilterComposer
    extends Composer<_$AssessmentContentDb, $SubjectsTable> {
  $$SubjectsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SubjectsTableOrderingComposer
    extends Composer<_$AssessmentContentDb, $SubjectsTable> {
  $$SubjectsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SubjectsTableAnnotationComposer
    extends Composer<_$AssessmentContentDb, $SubjectsTable> {
  $$SubjectsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);
}

class $$SubjectsTableTableManager
    extends
        RootTableManager<
          _$AssessmentContentDb,
          $SubjectsTable,
          Subject,
          $$SubjectsTableFilterComposer,
          $$SubjectsTableOrderingComposer,
          $$SubjectsTableAnnotationComposer,
          $$SubjectsTableCreateCompanionBuilder,
          $$SubjectsTableUpdateCompanionBuilder,
          (
            Subject,
            BaseReferences<_$AssessmentContentDb, $SubjectsTable, Subject>,
          ),
          Subject,
          PrefetchHooks Function()
        > {
  $$SubjectsTableTableManager(_$AssessmentContentDb db, $SubjectsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubjectsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SubjectsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubjectsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
              }) => SubjectsCompanion(id: id, name: name),
          createCompanionCallback:
              ({Value<int> id = const Value.absent(), required String name}) =>
                  SubjectsCompanion.insert(id: id, name: name),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SubjectsTableProcessedTableManager =
    ProcessedTableManager<
      _$AssessmentContentDb,
      $SubjectsTable,
      Subject,
      $$SubjectsTableFilterComposer,
      $$SubjectsTableOrderingComposer,
      $$SubjectsTableAnnotationComposer,
      $$SubjectsTableCreateCompanionBuilder,
      $$SubjectsTableUpdateCompanionBuilder,
      (Subject, BaseReferences<_$AssessmentContentDb, $SubjectsTable, Subject>),
      Subject,
      PrefetchHooks Function()
    >;
typedef $$CategoriesTableCreateCompanionBuilder =
    CategoriesCompanion Function({Value<int> id, required String catName});
typedef $$CategoriesTableUpdateCompanionBuilder =
    CategoriesCompanion Function({Value<int> id, Value<String> catName});

class $$CategoriesTableFilterComposer
    extends Composer<_$AssessmentContentDb, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get catName => $composableBuilder(
    column: $table.catName,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AssessmentContentDb, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get catName => $composableBuilder(
    column: $table.catName,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AssessmentContentDb, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get catName =>
      $composableBuilder(column: $table.catName, builder: (column) => column);
}

class $$CategoriesTableTableManager
    extends
        RootTableManager<
          _$AssessmentContentDb,
          $CategoriesTable,
          Category,
          $$CategoriesTableFilterComposer,
          $$CategoriesTableOrderingComposer,
          $$CategoriesTableAnnotationComposer,
          $$CategoriesTableCreateCompanionBuilder,
          $$CategoriesTableUpdateCompanionBuilder,
          (
            Category,
            BaseReferences<_$AssessmentContentDb, $CategoriesTable, Category>,
          ),
          Category,
          PrefetchHooks Function()
        > {
  $$CategoriesTableTableManager(
    _$AssessmentContentDb db,
    $CategoriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> catName = const Value.absent(),
              }) => CategoriesCompanion(id: id, catName: catName),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String catName,
              }) => CategoriesCompanion.insert(id: id, catName: catName),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AssessmentContentDb,
      $CategoriesTable,
      Category,
      $$CategoriesTableFilterComposer,
      $$CategoriesTableOrderingComposer,
      $$CategoriesTableAnnotationComposer,
      $$CategoriesTableCreateCompanionBuilder,
      $$CategoriesTableUpdateCompanionBuilder,
      (
        Category,
        BaseReferences<_$AssessmentContentDb, $CategoriesTable, Category>,
      ),
      Category,
      PrefetchHooks Function()
    >;
typedef $$YearsTableCreateCompanionBuilder =
    YearsCompanion Function({
      Value<int> id,
      required int subjectId,
      required String yearName,
    });
typedef $$YearsTableUpdateCompanionBuilder =
    YearsCompanion Function({
      Value<int> id,
      Value<int> subjectId,
      Value<String> yearName,
    });

class $$YearsTableFilterComposer
    extends Composer<_$AssessmentContentDb, $YearsTable> {
  $$YearsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get subjectId => $composableBuilder(
    column: $table.subjectId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get yearName => $composableBuilder(
    column: $table.yearName,
    builder: (column) => ColumnFilters(column),
  );
}

class $$YearsTableOrderingComposer
    extends Composer<_$AssessmentContentDb, $YearsTable> {
  $$YearsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get subjectId => $composableBuilder(
    column: $table.subjectId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get yearName => $composableBuilder(
    column: $table.yearName,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$YearsTableAnnotationComposer
    extends Composer<_$AssessmentContentDb, $YearsTable> {
  $$YearsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get subjectId =>
      $composableBuilder(column: $table.subjectId, builder: (column) => column);

  GeneratedColumn<String> get yearName =>
      $composableBuilder(column: $table.yearName, builder: (column) => column);
}

class $$YearsTableTableManager
    extends
        RootTableManager<
          _$AssessmentContentDb,
          $YearsTable,
          Year,
          $$YearsTableFilterComposer,
          $$YearsTableOrderingComposer,
          $$YearsTableAnnotationComposer,
          $$YearsTableCreateCompanionBuilder,
          $$YearsTableUpdateCompanionBuilder,
          (Year, BaseReferences<_$AssessmentContentDb, $YearsTable, Year>),
          Year,
          PrefetchHooks Function()
        > {
  $$YearsTableTableManager(_$AssessmentContentDb db, $YearsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$YearsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$YearsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$YearsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> subjectId = const Value.absent(),
                Value<String> yearName = const Value.absent(),
              }) => YearsCompanion(
                id: id,
                subjectId: subjectId,
                yearName: yearName,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int subjectId,
                required String yearName,
              }) => YearsCompanion.insert(
                id: id,
                subjectId: subjectId,
                yearName: yearName,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$YearsTableProcessedTableManager =
    ProcessedTableManager<
      _$AssessmentContentDb,
      $YearsTable,
      Year,
      $$YearsTableFilterComposer,
      $$YearsTableOrderingComposer,
      $$YearsTableAnnotationComposer,
      $$YearsTableCreateCompanionBuilder,
      $$YearsTableUpdateCompanionBuilder,
      (Year, BaseReferences<_$AssessmentContentDb, $YearsTable, Year>),
      Year,
      PrefetchHooks Function()
    >;
typedef $$TestTypesTableCreateCompanionBuilder =
    TestTypesCompanion Function({
      Value<int> id,
      required String testTypeName,
      required int durationMinutes,
      required int numOfQuestions,
      Value<int?> subjectId,
      Value<int?> assocCategoryId,
    });
typedef $$TestTypesTableUpdateCompanionBuilder =
    TestTypesCompanion Function({
      Value<int> id,
      Value<String> testTypeName,
      Value<int> durationMinutes,
      Value<int> numOfQuestions,
      Value<int?> subjectId,
      Value<int?> assocCategoryId,
    });

class $$TestTypesTableFilterComposer
    extends Composer<_$AssessmentContentDb, $TestTypesTable> {
  $$TestTypesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get testTypeName => $composableBuilder(
    column: $table.testTypeName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get numOfQuestions => $composableBuilder(
    column: $table.numOfQuestions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get subjectId => $composableBuilder(
    column: $table.subjectId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get assocCategoryId => $composableBuilder(
    column: $table.assocCategoryId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TestTypesTableOrderingComposer
    extends Composer<_$AssessmentContentDb, $TestTypesTable> {
  $$TestTypesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get testTypeName => $composableBuilder(
    column: $table.testTypeName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get numOfQuestions => $composableBuilder(
    column: $table.numOfQuestions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get subjectId => $composableBuilder(
    column: $table.subjectId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get assocCategoryId => $composableBuilder(
    column: $table.assocCategoryId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TestTypesTableAnnotationComposer
    extends Composer<_$AssessmentContentDb, $TestTypesTable> {
  $$TestTypesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get testTypeName => $composableBuilder(
    column: $table.testTypeName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get numOfQuestions => $composableBuilder(
    column: $table.numOfQuestions,
    builder: (column) => column,
  );

  GeneratedColumn<int> get subjectId =>
      $composableBuilder(column: $table.subjectId, builder: (column) => column);

  GeneratedColumn<int> get assocCategoryId => $composableBuilder(
    column: $table.assocCategoryId,
    builder: (column) => column,
  );
}

class $$TestTypesTableTableManager
    extends
        RootTableManager<
          _$AssessmentContentDb,
          $TestTypesTable,
          TestType,
          $$TestTypesTableFilterComposer,
          $$TestTypesTableOrderingComposer,
          $$TestTypesTableAnnotationComposer,
          $$TestTypesTableCreateCompanionBuilder,
          $$TestTypesTableUpdateCompanionBuilder,
          (
            TestType,
            BaseReferences<_$AssessmentContentDb, $TestTypesTable, TestType>,
          ),
          TestType,
          PrefetchHooks Function()
        > {
  $$TestTypesTableTableManager(_$AssessmentContentDb db, $TestTypesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TestTypesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TestTypesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TestTypesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> testTypeName = const Value.absent(),
                Value<int> durationMinutes = const Value.absent(),
                Value<int> numOfQuestions = const Value.absent(),
                Value<int?> subjectId = const Value.absent(),
                Value<int?> assocCategoryId = const Value.absent(),
              }) => TestTypesCompanion(
                id: id,
                testTypeName: testTypeName,
                durationMinutes: durationMinutes,
                numOfQuestions: numOfQuestions,
                subjectId: subjectId,
                assocCategoryId: assocCategoryId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String testTypeName,
                required int durationMinutes,
                required int numOfQuestions,
                Value<int?> subjectId = const Value.absent(),
                Value<int?> assocCategoryId = const Value.absent(),
              }) => TestTypesCompanion.insert(
                id: id,
                testTypeName: testTypeName,
                durationMinutes: durationMinutes,
                numOfQuestions: numOfQuestions,
                subjectId: subjectId,
                assocCategoryId: assocCategoryId,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TestTypesTableProcessedTableManager =
    ProcessedTableManager<
      _$AssessmentContentDb,
      $TestTypesTable,
      TestType,
      $$TestTypesTableFilterComposer,
      $$TestTypesTableOrderingComposer,
      $$TestTypesTableAnnotationComposer,
      $$TestTypesTableCreateCompanionBuilder,
      $$TestTypesTableUpdateCompanionBuilder,
      (
        TestType,
        BaseReferences<_$AssessmentContentDb, $TestTypesTable, TestType>,
      ),
      TestType,
      PrefetchHooks Function()
    >;
typedef $$PassagesTableCreateCompanionBuilder =
    PassagesCompanion Function({
      Value<int> id,
      Value<String?> title,
      Value<int?> yearId,
      required String passageText,
    });
typedef $$PassagesTableUpdateCompanionBuilder =
    PassagesCompanion Function({
      Value<int> id,
      Value<String?> title,
      Value<int?> yearId,
      Value<String> passageText,
    });

class $$PassagesTableFilterComposer
    extends Composer<_$AssessmentContentDb, $PassagesTable> {
  $$PassagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get yearId => $composableBuilder(
    column: $table.yearId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get passageText => $composableBuilder(
    column: $table.passageText,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PassagesTableOrderingComposer
    extends Composer<_$AssessmentContentDb, $PassagesTable> {
  $$PassagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get yearId => $composableBuilder(
    column: $table.yearId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get passageText => $composableBuilder(
    column: $table.passageText,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PassagesTableAnnotationComposer
    extends Composer<_$AssessmentContentDb, $PassagesTable> {
  $$PassagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get yearId =>
      $composableBuilder(column: $table.yearId, builder: (column) => column);

  GeneratedColumn<String> get passageText => $composableBuilder(
    column: $table.passageText,
    builder: (column) => column,
  );
}

class $$PassagesTableTableManager
    extends
        RootTableManager<
          _$AssessmentContentDb,
          $PassagesTable,
          Passage,
          $$PassagesTableFilterComposer,
          $$PassagesTableOrderingComposer,
          $$PassagesTableAnnotationComposer,
          $$PassagesTableCreateCompanionBuilder,
          $$PassagesTableUpdateCompanionBuilder,
          (
            Passage,
            BaseReferences<_$AssessmentContentDb, $PassagesTable, Passage>,
          ),
          Passage,
          PrefetchHooks Function()
        > {
  $$PassagesTableTableManager(_$AssessmentContentDb db, $PassagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PassagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PassagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PassagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<int?> yearId = const Value.absent(),
                Value<String> passageText = const Value.absent(),
              }) => PassagesCompanion(
                id: id,
                title: title,
                yearId: yearId,
                passageText: passageText,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<int?> yearId = const Value.absent(),
                required String passageText,
              }) => PassagesCompanion.insert(
                id: id,
                title: title,
                yearId: yearId,
                passageText: passageText,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PassagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AssessmentContentDb,
      $PassagesTable,
      Passage,
      $$PassagesTableFilterComposer,
      $$PassagesTableOrderingComposer,
      $$PassagesTableAnnotationComposer,
      $$PassagesTableCreateCompanionBuilder,
      $$PassagesTableUpdateCompanionBuilder,
      (Passage, BaseReferences<_$AssessmentContentDb, $PassagesTable, Passage>),
      Passage,
      PrefetchHooks Function()
    >;
typedef $$QuestionsTableCreateCompanionBuilder =
    QuestionsCompanion Function({
      Value<int> id,
      required int subjectId,
      required int categoryId,
      required int yearId,
      Value<int?> passageId,
      Value<int?> testTypeId,
      required String questionText,
      Value<String?> imagePath,
      required String optionA,
      required String optionB,
      required String optionC,
      required String optionD,
      Value<String?> optionE,
      required String correctOption,
      Value<String?> explanation,
    });
typedef $$QuestionsTableUpdateCompanionBuilder =
    QuestionsCompanion Function({
      Value<int> id,
      Value<int> subjectId,
      Value<int> categoryId,
      Value<int> yearId,
      Value<int?> passageId,
      Value<int?> testTypeId,
      Value<String> questionText,
      Value<String?> imagePath,
      Value<String> optionA,
      Value<String> optionB,
      Value<String> optionC,
      Value<String> optionD,
      Value<String?> optionE,
      Value<String> correctOption,
      Value<String?> explanation,
    });

class $$QuestionsTableFilterComposer
    extends Composer<_$AssessmentContentDb, $QuestionsTable> {
  $$QuestionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get subjectId => $composableBuilder(
    column: $table.subjectId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get yearId => $composableBuilder(
    column: $table.yearId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get passageId => $composableBuilder(
    column: $table.passageId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get testTypeId => $composableBuilder(
    column: $table.testTypeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get questionText => $composableBuilder(
    column: $table.questionText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get optionA => $composableBuilder(
    column: $table.optionA,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get optionB => $composableBuilder(
    column: $table.optionB,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get optionC => $composableBuilder(
    column: $table.optionC,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get optionD => $composableBuilder(
    column: $table.optionD,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get optionE => $composableBuilder(
    column: $table.optionE,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get correctOption => $composableBuilder(
    column: $table.correctOption,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => ColumnFilters(column),
  );
}

class $$QuestionsTableOrderingComposer
    extends Composer<_$AssessmentContentDb, $QuestionsTable> {
  $$QuestionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get subjectId => $composableBuilder(
    column: $table.subjectId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get yearId => $composableBuilder(
    column: $table.yearId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get passageId => $composableBuilder(
    column: $table.passageId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get testTypeId => $composableBuilder(
    column: $table.testTypeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get questionText => $composableBuilder(
    column: $table.questionText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get optionA => $composableBuilder(
    column: $table.optionA,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get optionB => $composableBuilder(
    column: $table.optionB,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get optionC => $composableBuilder(
    column: $table.optionC,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get optionD => $composableBuilder(
    column: $table.optionD,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get optionE => $composableBuilder(
    column: $table.optionE,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get correctOption => $composableBuilder(
    column: $table.correctOption,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$QuestionsTableAnnotationComposer
    extends Composer<_$AssessmentContentDb, $QuestionsTable> {
  $$QuestionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get subjectId =>
      $composableBuilder(column: $table.subjectId, builder: (column) => column);

  GeneratedColumn<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get yearId =>
      $composableBuilder(column: $table.yearId, builder: (column) => column);

  GeneratedColumn<int> get passageId =>
      $composableBuilder(column: $table.passageId, builder: (column) => column);

  GeneratedColumn<int> get testTypeId => $composableBuilder(
    column: $table.testTypeId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get questionText => $composableBuilder(
    column: $table.questionText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<String> get optionA =>
      $composableBuilder(column: $table.optionA, builder: (column) => column);

  GeneratedColumn<String> get optionB =>
      $composableBuilder(column: $table.optionB, builder: (column) => column);

  GeneratedColumn<String> get optionC =>
      $composableBuilder(column: $table.optionC, builder: (column) => column);

  GeneratedColumn<String> get optionD =>
      $composableBuilder(column: $table.optionD, builder: (column) => column);

  GeneratedColumn<String> get optionE =>
      $composableBuilder(column: $table.optionE, builder: (column) => column);

  GeneratedColumn<String> get correctOption => $composableBuilder(
    column: $table.correctOption,
    builder: (column) => column,
  );

  GeneratedColumn<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => column,
  );
}

class $$QuestionsTableTableManager
    extends
        RootTableManager<
          _$AssessmentContentDb,
          $QuestionsTable,
          Question,
          $$QuestionsTableFilterComposer,
          $$QuestionsTableOrderingComposer,
          $$QuestionsTableAnnotationComposer,
          $$QuestionsTableCreateCompanionBuilder,
          $$QuestionsTableUpdateCompanionBuilder,
          (
            Question,
            BaseReferences<_$AssessmentContentDb, $QuestionsTable, Question>,
          ),
          Question,
          PrefetchHooks Function()
        > {
  $$QuestionsTableTableManager(_$AssessmentContentDb db, $QuestionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuestionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuestionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuestionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> subjectId = const Value.absent(),
                Value<int> categoryId = const Value.absent(),
                Value<int> yearId = const Value.absent(),
                Value<int?> passageId = const Value.absent(),
                Value<int?> testTypeId = const Value.absent(),
                Value<String> questionText = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                Value<String> optionA = const Value.absent(),
                Value<String> optionB = const Value.absent(),
                Value<String> optionC = const Value.absent(),
                Value<String> optionD = const Value.absent(),
                Value<String?> optionE = const Value.absent(),
                Value<String> correctOption = const Value.absent(),
                Value<String?> explanation = const Value.absent(),
              }) => QuestionsCompanion(
                id: id,
                subjectId: subjectId,
                categoryId: categoryId,
                yearId: yearId,
                passageId: passageId,
                testTypeId: testTypeId,
                questionText: questionText,
                imagePath: imagePath,
                optionA: optionA,
                optionB: optionB,
                optionC: optionC,
                optionD: optionD,
                optionE: optionE,
                correctOption: correctOption,
                explanation: explanation,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int subjectId,
                required int categoryId,
                required int yearId,
                Value<int?> passageId = const Value.absent(),
                Value<int?> testTypeId = const Value.absent(),
                required String questionText,
                Value<String?> imagePath = const Value.absent(),
                required String optionA,
                required String optionB,
                required String optionC,
                required String optionD,
                Value<String?> optionE = const Value.absent(),
                required String correctOption,
                Value<String?> explanation = const Value.absent(),
              }) => QuestionsCompanion.insert(
                id: id,
                subjectId: subjectId,
                categoryId: categoryId,
                yearId: yearId,
                passageId: passageId,
                testTypeId: testTypeId,
                questionText: questionText,
                imagePath: imagePath,
                optionA: optionA,
                optionB: optionB,
                optionC: optionC,
                optionD: optionD,
                optionE: optionE,
                correctOption: correctOption,
                explanation: explanation,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$QuestionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AssessmentContentDb,
      $QuestionsTable,
      Question,
      $$QuestionsTableFilterComposer,
      $$QuestionsTableOrderingComposer,
      $$QuestionsTableAnnotationComposer,
      $$QuestionsTableCreateCompanionBuilder,
      $$QuestionsTableUpdateCompanionBuilder,
      (
        Question,
        BaseReferences<_$AssessmentContentDb, $QuestionsTable, Question>,
      ),
      Question,
      PrefetchHooks Function()
    >;
typedef $$InstalledAssessmentPacksTableCreateCompanionBuilder =
    InstalledAssessmentPacksCompanion Function({
      Value<int> id,
      required String scopeType,
      required int scopeId,
      required String version,
      required String checksum,
      required int sizeBytes,
      required String installedAt,
    });
typedef $$InstalledAssessmentPacksTableUpdateCompanionBuilder =
    InstalledAssessmentPacksCompanion Function({
      Value<int> id,
      Value<String> scopeType,
      Value<int> scopeId,
      Value<String> version,
      Value<String> checksum,
      Value<int> sizeBytes,
      Value<String> installedAt,
    });

class $$InstalledAssessmentPacksTableFilterComposer
    extends Composer<_$AssessmentContentDb, $InstalledAssessmentPacksTable> {
  $$InstalledAssessmentPacksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scopeType => $composableBuilder(
    column: $table.scopeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get scopeId => $composableBuilder(
    column: $table.scopeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get checksum => $composableBuilder(
    column: $table.checksum,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sizeBytes => $composableBuilder(
    column: $table.sizeBytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get installedAt => $composableBuilder(
    column: $table.installedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$InstalledAssessmentPacksTableOrderingComposer
    extends Composer<_$AssessmentContentDb, $InstalledAssessmentPacksTable> {
  $$InstalledAssessmentPacksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scopeType => $composableBuilder(
    column: $table.scopeType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get scopeId => $composableBuilder(
    column: $table.scopeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get checksum => $composableBuilder(
    column: $table.checksum,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sizeBytes => $composableBuilder(
    column: $table.sizeBytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get installedAt => $composableBuilder(
    column: $table.installedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InstalledAssessmentPacksTableAnnotationComposer
    extends Composer<_$AssessmentContentDb, $InstalledAssessmentPacksTable> {
  $$InstalledAssessmentPacksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get scopeType =>
      $composableBuilder(column: $table.scopeType, builder: (column) => column);

  GeneratedColumn<int> get scopeId =>
      $composableBuilder(column: $table.scopeId, builder: (column) => column);

  GeneratedColumn<String> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get checksum =>
      $composableBuilder(column: $table.checksum, builder: (column) => column);

  GeneratedColumn<int> get sizeBytes =>
      $composableBuilder(column: $table.sizeBytes, builder: (column) => column);

  GeneratedColumn<String> get installedAt => $composableBuilder(
    column: $table.installedAt,
    builder: (column) => column,
  );
}

class $$InstalledAssessmentPacksTableTableManager
    extends
        RootTableManager<
          _$AssessmentContentDb,
          $InstalledAssessmentPacksTable,
          InstalledAssessmentPack,
          $$InstalledAssessmentPacksTableFilterComposer,
          $$InstalledAssessmentPacksTableOrderingComposer,
          $$InstalledAssessmentPacksTableAnnotationComposer,
          $$InstalledAssessmentPacksTableCreateCompanionBuilder,
          $$InstalledAssessmentPacksTableUpdateCompanionBuilder,
          (
            InstalledAssessmentPack,
            BaseReferences<
              _$AssessmentContentDb,
              $InstalledAssessmentPacksTable,
              InstalledAssessmentPack
            >,
          ),
          InstalledAssessmentPack,
          PrefetchHooks Function()
        > {
  $$InstalledAssessmentPacksTableTableManager(
    _$AssessmentContentDb db,
    $InstalledAssessmentPacksTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InstalledAssessmentPacksTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$InstalledAssessmentPacksTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$InstalledAssessmentPacksTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> scopeType = const Value.absent(),
                Value<int> scopeId = const Value.absent(),
                Value<String> version = const Value.absent(),
                Value<String> checksum = const Value.absent(),
                Value<int> sizeBytes = const Value.absent(),
                Value<String> installedAt = const Value.absent(),
              }) => InstalledAssessmentPacksCompanion(
                id: id,
                scopeType: scopeType,
                scopeId: scopeId,
                version: version,
                checksum: checksum,
                sizeBytes: sizeBytes,
                installedAt: installedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String scopeType,
                required int scopeId,
                required String version,
                required String checksum,
                required int sizeBytes,
                required String installedAt,
              }) => InstalledAssessmentPacksCompanion.insert(
                id: id,
                scopeType: scopeType,
                scopeId: scopeId,
                version: version,
                checksum: checksum,
                sizeBytes: sizeBytes,
                installedAt: installedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InstalledAssessmentPacksTableProcessedTableManager =
    ProcessedTableManager<
      _$AssessmentContentDb,
      $InstalledAssessmentPacksTable,
      InstalledAssessmentPack,
      $$InstalledAssessmentPacksTableFilterComposer,
      $$InstalledAssessmentPacksTableOrderingComposer,
      $$InstalledAssessmentPacksTableAnnotationComposer,
      $$InstalledAssessmentPacksTableCreateCompanionBuilder,
      $$InstalledAssessmentPacksTableUpdateCompanionBuilder,
      (
        InstalledAssessmentPack,
        BaseReferences<
          _$AssessmentContentDb,
          $InstalledAssessmentPacksTable,
          InstalledAssessmentPack
        >,
      ),
      InstalledAssessmentPack,
      PrefetchHooks Function()
    >;

class $AssessmentContentDbManager {
  final _$AssessmentContentDb _db;
  $AssessmentContentDbManager(this._db);
  $$SubjectsTableTableManager get subjects =>
      $$SubjectsTableTableManager(_db, _db.subjects);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$YearsTableTableManager get years =>
      $$YearsTableTableManager(_db, _db.years);
  $$TestTypesTableTableManager get testTypes =>
      $$TestTypesTableTableManager(_db, _db.testTypes);
  $$PassagesTableTableManager get passages =>
      $$PassagesTableTableManager(_db, _db.passages);
  $$QuestionsTableTableManager get questions =>
      $$QuestionsTableTableManager(_db, _db.questions);
  $$InstalledAssessmentPacksTableTableManager get installedAssessmentPacks =>
      $$InstalledAssessmentPacksTableTableManager(
        _db,
        _db.installedAssessmentPacks,
      );
}
