// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'study_content_db.dart';

// ignore_for_file: type=lint
class $ClassesTable extends Classes
    with TableInfo<$ClassesTable, LibraryClass> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClassesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, code, sortOrder, category];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'classes';
  @override
  VerificationContext validateIntegrity(
    Insertable<LibraryClass> instance, {
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
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LibraryClass map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LibraryClass(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
    );
  }

  @override
  $ClassesTable createAlias(String alias) {
    return $ClassesTable(attachedDatabase, alias);
  }
}

class LibraryClass extends DataClass implements Insertable<LibraryClass> {
  final int id;
  final String name;
  final String? code;
  final int sortOrder;
  final String category;
  const LibraryClass({
    required this.id,
    required this.name,
    this.code,
    required this.sortOrder,
    required this.category,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || code != null) {
      map['code'] = Variable<String>(code);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    map['category'] = Variable<String>(category);
    return map;
  }

  ClassesCompanion toCompanion(bool nullToAbsent) {
    return ClassesCompanion(
      id: Value(id),
      name: Value(name),
      code: code == null && nullToAbsent ? const Value.absent() : Value(code),
      sortOrder: Value(sortOrder),
      category: Value(category),
    );
  }

  factory LibraryClass.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LibraryClass(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      code: serializer.fromJson<String?>(json['code']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      category: serializer.fromJson<String>(json['category']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'code': serializer.toJson<String?>(code),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'category': serializer.toJson<String>(category),
    };
  }

  LibraryClass copyWith({
    int? id,
    String? name,
    Value<String?> code = const Value.absent(),
    int? sortOrder,
    String? category,
  }) => LibraryClass(
    id: id ?? this.id,
    name: name ?? this.name,
    code: code.present ? code.value : this.code,
    sortOrder: sortOrder ?? this.sortOrder,
    category: category ?? this.category,
  );
  LibraryClass copyWithCompanion(ClassesCompanion data) {
    return LibraryClass(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      code: data.code.present ? data.code.value : this.code,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      category: data.category.present ? data.category.value : this.category,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LibraryClass(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('code: $code, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('category: $category')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, code, sortOrder, category);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LibraryClass &&
          other.id == this.id &&
          other.name == this.name &&
          other.code == this.code &&
          other.sortOrder == this.sortOrder &&
          other.category == this.category);
}

class ClassesCompanion extends UpdateCompanion<LibraryClass> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> code;
  final Value<int> sortOrder;
  final Value<String> category;
  const ClassesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.code = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.category = const Value.absent(),
  });
  ClassesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.code = const Value.absent(),
    required int sortOrder,
    required String category,
  }) : name = Value(name),
       sortOrder = Value(sortOrder),
       category = Value(category);
  static Insertable<LibraryClass> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? code,
    Expression<int>? sortOrder,
    Expression<String>? category,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (code != null) 'code': code,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (category != null) 'category': category,
    });
  }

  ClassesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? code,
    Value<int>? sortOrder,
    Value<String>? category,
  }) {
    return ClassesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      sortOrder: sortOrder ?? this.sortOrder,
      category: category ?? this.category,
    );
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
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClassesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('code: $code, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('category: $category')
          ..write(')'))
        .toString();
  }
}

class $TermsTable extends Terms with TableInfo<$TermsTable, Term> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TermsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<String> startDate = GeneratedColumn<String>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<String> endDate = GeneratedColumn<String>(
    'end_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, startDate, endDate];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'terms';
  @override
  VerificationContext validateIntegrity(
    Insertable<Term> instance, {
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
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    } else if (isInserting) {
      context.missing(_endDateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Term map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Term(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}end_date'],
      )!,
    );
  }

  @override
  $TermsTable createAlias(String alias) {
    return $TermsTable(attachedDatabase, alias);
  }
}

class Term extends DataClass implements Insertable<Term> {
  final int id;
  final String name;
  final String startDate;
  final String endDate;
  const Term({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['start_date'] = Variable<String>(startDate);
    map['end_date'] = Variable<String>(endDate);
    return map;
  }

  TermsCompanion toCompanion(bool nullToAbsent) {
    return TermsCompanion(
      id: Value(id),
      name: Value(name),
      startDate: Value(startDate),
      endDate: Value(endDate),
    );
  }

  factory Term.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Term(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      startDate: serializer.fromJson<String>(json['startDate']),
      endDate: serializer.fromJson<String>(json['endDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'startDate': serializer.toJson<String>(startDate),
      'endDate': serializer.toJson<String>(endDate),
    };
  }

  Term copyWith({int? id, String? name, String? startDate, String? endDate}) =>
      Term(
        id: id ?? this.id,
        name: name ?? this.name,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
      );
  Term copyWithCompanion(TermsCompanion data) {
    return Term(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Term(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, startDate, endDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Term &&
          other.id == this.id &&
          other.name == this.name &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate);
}

class TermsCompanion extends UpdateCompanion<Term> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> startDate;
  final Value<String> endDate;
  const TermsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
  });
  TermsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String startDate,
    required String endDate,
  }) : name = Value(name),
       startDate = Value(startDate),
       endDate = Value(endDate);
  static Insertable<Term> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? startDate,
    Expression<String>? endDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
    });
  }

  TermsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? startDate,
    Value<String>? endDate,
  }) {
    return TermsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
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
    if (startDate.present) {
      map['start_date'] = Variable<String>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<String>(endDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TermsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate')
          ..write(')'))
        .toString();
  }
}

class $LibraryBooksTable extends LibraryBooks
    with TableInfo<$LibraryBooksTable, LibraryBook> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LibraryBooksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _classIdMeta = const VerificationMeta(
    'classId',
  );
  @override
  late final GeneratedColumn<int> classId = GeneratedColumn<int>(
    'class_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
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
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, classId, name, imagePath, color];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'library_books';
  @override
  VerificationContext validateIntegrity(
    Insertable<LibraryBook> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('class_id')) {
      context.handle(
        _classIdMeta,
        classId.isAcceptableOrUnknown(data['class_id']!, _classIdMeta),
      );
    } else if (isInserting) {
      context.missing(_classIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('image_path')) {
      context.handle(
        _imagePathMeta,
        imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta),
      );
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LibraryBook map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LibraryBook(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      classId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}class_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      imagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_path'],
      ),
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      )!,
    );
  }

  @override
  $LibraryBooksTable createAlias(String alias) {
    return $LibraryBooksTable(attachedDatabase, alias);
  }
}

class LibraryBook extends DataClass implements Insertable<LibraryBook> {
  final int id;
  final int classId;
  final String name;
  final String? imagePath;
  final String color;
  const LibraryBook({
    required this.id,
    required this.classId,
    required this.name,
    this.imagePath,
    required this.color,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['class_id'] = Variable<int>(classId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = Variable<String>(imagePath);
    }
    map['color'] = Variable<String>(color);
    return map;
  }

  LibraryBooksCompanion toCompanion(bool nullToAbsent) {
    return LibraryBooksCompanion(
      id: Value(id),
      classId: Value(classId),
      name: Value(name),
      imagePath: imagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagePath),
      color: Value(color),
    );
  }

  factory LibraryBook.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LibraryBook(
      id: serializer.fromJson<int>(json['id']),
      classId: serializer.fromJson<int>(json['classId']),
      name: serializer.fromJson<String>(json['name']),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
      color: serializer.fromJson<String>(json['color']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'classId': serializer.toJson<int>(classId),
      'name': serializer.toJson<String>(name),
      'imagePath': serializer.toJson<String?>(imagePath),
      'color': serializer.toJson<String>(color),
    };
  }

  LibraryBook copyWith({
    int? id,
    int? classId,
    String? name,
    Value<String?> imagePath = const Value.absent(),
    String? color,
  }) => LibraryBook(
    id: id ?? this.id,
    classId: classId ?? this.classId,
    name: name ?? this.name,
    imagePath: imagePath.present ? imagePath.value : this.imagePath,
    color: color ?? this.color,
  );
  LibraryBook copyWithCompanion(LibraryBooksCompanion data) {
    return LibraryBook(
      id: data.id.present ? data.id.value : this.id,
      classId: data.classId.present ? data.classId.value : this.classId,
      name: data.name.present ? data.name.value : this.name,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      color: data.color.present ? data.color.value : this.color,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LibraryBook(')
          ..write('id: $id, ')
          ..write('classId: $classId, ')
          ..write('name: $name, ')
          ..write('imagePath: $imagePath, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, classId, name, imagePath, color);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LibraryBook &&
          other.id == this.id &&
          other.classId == this.classId &&
          other.name == this.name &&
          other.imagePath == this.imagePath &&
          other.color == this.color);
}

class LibraryBooksCompanion extends UpdateCompanion<LibraryBook> {
  final Value<int> id;
  final Value<int> classId;
  final Value<String> name;
  final Value<String?> imagePath;
  final Value<String> color;
  const LibraryBooksCompanion({
    this.id = const Value.absent(),
    this.classId = const Value.absent(),
    this.name = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.color = const Value.absent(),
  });
  LibraryBooksCompanion.insert({
    this.id = const Value.absent(),
    required int classId,
    required String name,
    this.imagePath = const Value.absent(),
    required String color,
  }) : classId = Value(classId),
       name = Value(name),
       color = Value(color);
  static Insertable<LibraryBook> custom({
    Expression<int>? id,
    Expression<int>? classId,
    Expression<String>? name,
    Expression<String>? imagePath,
    Expression<String>? color,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (classId != null) 'class_id': classId,
      if (name != null) 'name': name,
      if (imagePath != null) 'image_path': imagePath,
      if (color != null) 'color': color,
    });
  }

  LibraryBooksCompanion copyWith({
    Value<int>? id,
    Value<int>? classId,
    Value<String>? name,
    Value<String?>? imagePath,
    Value<String>? color,
  }) {
    return LibraryBooksCompanion(
      id: id ?? this.id,
      classId: classId ?? this.classId,
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      color: color ?? this.color,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (classId.present) {
      map['class_id'] = Variable<int>(classId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LibraryBooksCompanion(')
          ..write('id: $id, ')
          ..write('classId: $classId, ')
          ..write('name: $name, ')
          ..write('imagePath: $imagePath, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }
}

class $LibrarySubjectsTable extends LibrarySubjects
    with TableInfo<$LibrarySubjectsTable, LibrarySubject> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LibrarySubjectsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _libraryBookIdMeta = const VerificationMeta(
    'libraryBookId',
  );
  @override
  late final GeneratedColumn<int> libraryBookId = GeneratedColumn<int>(
    'library_book_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _termIdMeta = const VerificationMeta('termId');
  @override
  late final GeneratedColumn<int> termId = GeneratedColumn<int>(
    'term_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _coverImagePathMeta = const VerificationMeta(
    'coverImagePath',
  );
  @override
  late final GeneratedColumn<String> coverImagePath = GeneratedColumn<String>(
    'cover_image_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _authorMeta = const VerificationMeta('author');
  @override
  late final GeneratedColumn<String> author = GeneratedColumn<String>(
    'author',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weekMeta = const VerificationMeta('week');
  @override
  late final GeneratedColumn<int> week = GeneratedColumn<int>(
    'week',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _numOfTestQuestionsMeta =
      const VerificationMeta('numOfTestQuestions');
  @override
  late final GeneratedColumn<int> numOfTestQuestions = GeneratedColumn<int>(
    'num_of_test_questions',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    libraryBookId,
    termId,
    title,
    description,
    coverImagePath,
    author,
    week,
    numOfTestQuestions,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'library_subjects';
  @override
  VerificationContext validateIntegrity(
    Insertable<LibrarySubject> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('library_book_id')) {
      context.handle(
        _libraryBookIdMeta,
        libraryBookId.isAcceptableOrUnknown(
          data['library_book_id']!,
          _libraryBookIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_libraryBookIdMeta);
    }
    if (data.containsKey('term_id')) {
      context.handle(
        _termIdMeta,
        termId.isAcceptableOrUnknown(data['term_id']!, _termIdMeta),
      );
    } else if (isInserting) {
      context.missing(_termIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('cover_image_path')) {
      context.handle(
        _coverImagePathMeta,
        coverImagePath.isAcceptableOrUnknown(
          data['cover_image_path']!,
          _coverImagePathMeta,
        ),
      );
    }
    if (data.containsKey('author')) {
      context.handle(
        _authorMeta,
        author.isAcceptableOrUnknown(data['author']!, _authorMeta),
      );
    } else if (isInserting) {
      context.missing(_authorMeta);
    }
    if (data.containsKey('week')) {
      context.handle(
        _weekMeta,
        week.isAcceptableOrUnknown(data['week']!, _weekMeta),
      );
    } else if (isInserting) {
      context.missing(_weekMeta);
    }
    if (data.containsKey('num_of_test_questions')) {
      context.handle(
        _numOfTestQuestionsMeta,
        numOfTestQuestions.isAcceptableOrUnknown(
          data['num_of_test_questions']!,
          _numOfTestQuestionsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_numOfTestQuestionsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LibrarySubject map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LibrarySubject(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      libraryBookId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}library_book_id'],
      )!,
      termId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}term_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      coverImagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cover_image_path'],
      ),
      author: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author'],
      )!,
      week: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}week'],
      )!,
      numOfTestQuestions: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}num_of_test_questions'],
      )!,
    );
  }

  @override
  $LibrarySubjectsTable createAlias(String alias) {
    return $LibrarySubjectsTable(attachedDatabase, alias);
  }
}

class LibrarySubject extends DataClass implements Insertable<LibrarySubject> {
  final int id;
  final int libraryBookId;
  final int termId;
  final String title;
  final String? description;
  final String? coverImagePath;
  final String author;
  final int week;
  final int numOfTestQuestions;
  const LibrarySubject({
    required this.id,
    required this.libraryBookId,
    required this.termId,
    required this.title,
    this.description,
    this.coverImagePath,
    required this.author,
    required this.week,
    required this.numOfTestQuestions,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['library_book_id'] = Variable<int>(libraryBookId);
    map['term_id'] = Variable<int>(termId);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || coverImagePath != null) {
      map['cover_image_path'] = Variable<String>(coverImagePath);
    }
    map['author'] = Variable<String>(author);
    map['week'] = Variable<int>(week);
    map['num_of_test_questions'] = Variable<int>(numOfTestQuestions);
    return map;
  }

  LibrarySubjectsCompanion toCompanion(bool nullToAbsent) {
    return LibrarySubjectsCompanion(
      id: Value(id),
      libraryBookId: Value(libraryBookId),
      termId: Value(termId),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      coverImagePath: coverImagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(coverImagePath),
      author: Value(author),
      week: Value(week),
      numOfTestQuestions: Value(numOfTestQuestions),
    );
  }

  factory LibrarySubject.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LibrarySubject(
      id: serializer.fromJson<int>(json['id']),
      libraryBookId: serializer.fromJson<int>(json['libraryBookId']),
      termId: serializer.fromJson<int>(json['termId']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      coverImagePath: serializer.fromJson<String?>(json['coverImagePath']),
      author: serializer.fromJson<String>(json['author']),
      week: serializer.fromJson<int>(json['week']),
      numOfTestQuestions: serializer.fromJson<int>(json['numOfTestQuestions']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'libraryBookId': serializer.toJson<int>(libraryBookId),
      'termId': serializer.toJson<int>(termId),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'coverImagePath': serializer.toJson<String?>(coverImagePath),
      'author': serializer.toJson<String>(author),
      'week': serializer.toJson<int>(week),
      'numOfTestQuestions': serializer.toJson<int>(numOfTestQuestions),
    };
  }

  LibrarySubject copyWith({
    int? id,
    int? libraryBookId,
    int? termId,
    String? title,
    Value<String?> description = const Value.absent(),
    Value<String?> coverImagePath = const Value.absent(),
    String? author,
    int? week,
    int? numOfTestQuestions,
  }) => LibrarySubject(
    id: id ?? this.id,
    libraryBookId: libraryBookId ?? this.libraryBookId,
    termId: termId ?? this.termId,
    title: title ?? this.title,
    description: description.present ? description.value : this.description,
    coverImagePath: coverImagePath.present
        ? coverImagePath.value
        : this.coverImagePath,
    author: author ?? this.author,
    week: week ?? this.week,
    numOfTestQuestions: numOfTestQuestions ?? this.numOfTestQuestions,
  );
  LibrarySubject copyWithCompanion(LibrarySubjectsCompanion data) {
    return LibrarySubject(
      id: data.id.present ? data.id.value : this.id,
      libraryBookId: data.libraryBookId.present
          ? data.libraryBookId.value
          : this.libraryBookId,
      termId: data.termId.present ? data.termId.value : this.termId,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      coverImagePath: data.coverImagePath.present
          ? data.coverImagePath.value
          : this.coverImagePath,
      author: data.author.present ? data.author.value : this.author,
      week: data.week.present ? data.week.value : this.week,
      numOfTestQuestions: data.numOfTestQuestions.present
          ? data.numOfTestQuestions.value
          : this.numOfTestQuestions,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LibrarySubject(')
          ..write('id: $id, ')
          ..write('libraryBookId: $libraryBookId, ')
          ..write('termId: $termId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('coverImagePath: $coverImagePath, ')
          ..write('author: $author, ')
          ..write('week: $week, ')
          ..write('numOfTestQuestions: $numOfTestQuestions')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    libraryBookId,
    termId,
    title,
    description,
    coverImagePath,
    author,
    week,
    numOfTestQuestions,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LibrarySubject &&
          other.id == this.id &&
          other.libraryBookId == this.libraryBookId &&
          other.termId == this.termId &&
          other.title == this.title &&
          other.description == this.description &&
          other.coverImagePath == this.coverImagePath &&
          other.author == this.author &&
          other.week == this.week &&
          other.numOfTestQuestions == this.numOfTestQuestions);
}

class LibrarySubjectsCompanion extends UpdateCompanion<LibrarySubject> {
  final Value<int> id;
  final Value<int> libraryBookId;
  final Value<int> termId;
  final Value<String> title;
  final Value<String?> description;
  final Value<String?> coverImagePath;
  final Value<String> author;
  final Value<int> week;
  final Value<int> numOfTestQuestions;
  const LibrarySubjectsCompanion({
    this.id = const Value.absent(),
    this.libraryBookId = const Value.absent(),
    this.termId = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.coverImagePath = const Value.absent(),
    this.author = const Value.absent(),
    this.week = const Value.absent(),
    this.numOfTestQuestions = const Value.absent(),
  });
  LibrarySubjectsCompanion.insert({
    this.id = const Value.absent(),
    required int libraryBookId,
    required int termId,
    required String title,
    this.description = const Value.absent(),
    this.coverImagePath = const Value.absent(),
    required String author,
    required int week,
    required int numOfTestQuestions,
  }) : libraryBookId = Value(libraryBookId),
       termId = Value(termId),
       title = Value(title),
       author = Value(author),
       week = Value(week),
       numOfTestQuestions = Value(numOfTestQuestions);
  static Insertable<LibrarySubject> custom({
    Expression<int>? id,
    Expression<int>? libraryBookId,
    Expression<int>? termId,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? coverImagePath,
    Expression<String>? author,
    Expression<int>? week,
    Expression<int>? numOfTestQuestions,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (libraryBookId != null) 'library_book_id': libraryBookId,
      if (termId != null) 'term_id': termId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (coverImagePath != null) 'cover_image_path': coverImagePath,
      if (author != null) 'author': author,
      if (week != null) 'week': week,
      if (numOfTestQuestions != null)
        'num_of_test_questions': numOfTestQuestions,
    });
  }

  LibrarySubjectsCompanion copyWith({
    Value<int>? id,
    Value<int>? libraryBookId,
    Value<int>? termId,
    Value<String>? title,
    Value<String?>? description,
    Value<String?>? coverImagePath,
    Value<String>? author,
    Value<int>? week,
    Value<int>? numOfTestQuestions,
  }) {
    return LibrarySubjectsCompanion(
      id: id ?? this.id,
      libraryBookId: libraryBookId ?? this.libraryBookId,
      termId: termId ?? this.termId,
      title: title ?? this.title,
      description: description ?? this.description,
      coverImagePath: coverImagePath ?? this.coverImagePath,
      author: author ?? this.author,
      week: week ?? this.week,
      numOfTestQuestions: numOfTestQuestions ?? this.numOfTestQuestions,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (libraryBookId.present) {
      map['library_book_id'] = Variable<int>(libraryBookId.value);
    }
    if (termId.present) {
      map['term_id'] = Variable<int>(termId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (coverImagePath.present) {
      map['cover_image_path'] = Variable<String>(coverImagePath.value);
    }
    if (author.present) {
      map['author'] = Variable<String>(author.value);
    }
    if (week.present) {
      map['week'] = Variable<int>(week.value);
    }
    if (numOfTestQuestions.present) {
      map['num_of_test_questions'] = Variable<int>(numOfTestQuestions.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LibrarySubjectsCompanion(')
          ..write('id: $id, ')
          ..write('libraryBookId: $libraryBookId, ')
          ..write('termId: $termId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('coverImagePath: $coverImagePath, ')
          ..write('author: $author, ')
          ..write('week: $week, ')
          ..write('numOfTestQuestions: $numOfTestQuestions')
          ..write(')'))
        .toString();
  }
}

class $LibraryContentsTable extends LibraryContents
    with TableInfo<$LibraryContentsTable, LibraryContent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LibraryContentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _librarySubjectIdMeta = const VerificationMeta(
    'librarySubjectId',
  );
  @override
  late final GeneratedColumn<int> librarySubjectId = GeneratedColumn<int>(
    'library_subject_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentHtmlMeta = const VerificationMeta(
    'contentHtml',
  );
  @override
  late final GeneratedColumn<String> contentHtml = GeneratedColumn<String>(
    'content_html',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, librarySubjectId, contentHtml];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'library_contents';
  @override
  VerificationContext validateIntegrity(
    Insertable<LibraryContent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('library_subject_id')) {
      context.handle(
        _librarySubjectIdMeta,
        librarySubjectId.isAcceptableOrUnknown(
          data['library_subject_id']!,
          _librarySubjectIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_librarySubjectIdMeta);
    }
    if (data.containsKey('content_html')) {
      context.handle(
        _contentHtmlMeta,
        contentHtml.isAcceptableOrUnknown(
          data['content_html']!,
          _contentHtmlMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contentHtmlMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LibraryContent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LibraryContent(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      librarySubjectId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}library_subject_id'],
      )!,
      contentHtml: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_html'],
      )!,
    );
  }

  @override
  $LibraryContentsTable createAlias(String alias) {
    return $LibraryContentsTable(attachedDatabase, alias);
  }
}

class LibraryContent extends DataClass implements Insertable<LibraryContent> {
  final int id;
  final int librarySubjectId;
  final String contentHtml;
  const LibraryContent({
    required this.id,
    required this.librarySubjectId,
    required this.contentHtml,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['library_subject_id'] = Variable<int>(librarySubjectId);
    map['content_html'] = Variable<String>(contentHtml);
    return map;
  }

  LibraryContentsCompanion toCompanion(bool nullToAbsent) {
    return LibraryContentsCompanion(
      id: Value(id),
      librarySubjectId: Value(librarySubjectId),
      contentHtml: Value(contentHtml),
    );
  }

  factory LibraryContent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LibraryContent(
      id: serializer.fromJson<int>(json['id']),
      librarySubjectId: serializer.fromJson<int>(json['librarySubjectId']),
      contentHtml: serializer.fromJson<String>(json['contentHtml']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'librarySubjectId': serializer.toJson<int>(librarySubjectId),
      'contentHtml': serializer.toJson<String>(contentHtml),
    };
  }

  LibraryContent copyWith({
    int? id,
    int? librarySubjectId,
    String? contentHtml,
  }) => LibraryContent(
    id: id ?? this.id,
    librarySubjectId: librarySubjectId ?? this.librarySubjectId,
    contentHtml: contentHtml ?? this.contentHtml,
  );
  LibraryContent copyWithCompanion(LibraryContentsCompanion data) {
    return LibraryContent(
      id: data.id.present ? data.id.value : this.id,
      librarySubjectId: data.librarySubjectId.present
          ? data.librarySubjectId.value
          : this.librarySubjectId,
      contentHtml: data.contentHtml.present
          ? data.contentHtml.value
          : this.contentHtml,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LibraryContent(')
          ..write('id: $id, ')
          ..write('librarySubjectId: $librarySubjectId, ')
          ..write('contentHtml: $contentHtml')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, librarySubjectId, contentHtml);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LibraryContent &&
          other.id == this.id &&
          other.librarySubjectId == this.librarySubjectId &&
          other.contentHtml == this.contentHtml);
}

class LibraryContentsCompanion extends UpdateCompanion<LibraryContent> {
  final Value<int> id;
  final Value<int> librarySubjectId;
  final Value<String> contentHtml;
  const LibraryContentsCompanion({
    this.id = const Value.absent(),
    this.librarySubjectId = const Value.absent(),
    this.contentHtml = const Value.absent(),
  });
  LibraryContentsCompanion.insert({
    this.id = const Value.absent(),
    required int librarySubjectId,
    required String contentHtml,
  }) : librarySubjectId = Value(librarySubjectId),
       contentHtml = Value(contentHtml);
  static Insertable<LibraryContent> custom({
    Expression<int>? id,
    Expression<int>? librarySubjectId,
    Expression<String>? contentHtml,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (librarySubjectId != null) 'library_subject_id': librarySubjectId,
      if (contentHtml != null) 'content_html': contentHtml,
    });
  }

  LibraryContentsCompanion copyWith({
    Value<int>? id,
    Value<int>? librarySubjectId,
    Value<String>? contentHtml,
  }) {
    return LibraryContentsCompanion(
      id: id ?? this.id,
      librarySubjectId: librarySubjectId ?? this.librarySubjectId,
      contentHtml: contentHtml ?? this.contentHtml,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (librarySubjectId.present) {
      map['library_subject_id'] = Variable<int>(librarySubjectId.value);
    }
    if (contentHtml.present) {
      map['content_html'] = Variable<String>(contentHtml.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LibraryContentsCompanion(')
          ..write('id: $id, ')
          ..write('librarySubjectId: $librarySubjectId, ')
          ..write('contentHtml: $contentHtml')
          ..write(')'))
        .toString();
  }
}

class $LibraryQuestionsTable extends LibraryQuestions
    with TableInfo<$LibraryQuestionsTable, LibraryQuestion> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LibraryQuestionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _librarySubjectIdMeta = const VerificationMeta(
    'librarySubjectId',
  );
  @override
  late final GeneratedColumn<int> librarySubjectId = GeneratedColumn<int>(
    'library_subject_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
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
    librarySubjectId,
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
  static const String $name = 'library_questions';
  @override
  VerificationContext validateIntegrity(
    Insertable<LibraryQuestion> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('library_subject_id')) {
      context.handle(
        _librarySubjectIdMeta,
        librarySubjectId.isAcceptableOrUnknown(
          data['library_subject_id']!,
          _librarySubjectIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_librarySubjectIdMeta);
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
  LibraryQuestion map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LibraryQuestion(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      librarySubjectId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}library_subject_id'],
      )!,
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
  $LibraryQuestionsTable createAlias(String alias) {
    return $LibraryQuestionsTable(attachedDatabase, alias);
  }
}

class LibraryQuestion extends DataClass implements Insertable<LibraryQuestion> {
  final int id;
  final int librarySubjectId;
  final String questionText;
  final String? imagePath;
  final String optionA;
  final String optionB;
  final String optionC;
  final String optionD;
  final String? optionE;
  final String correctOption;
  final String? explanation;
  const LibraryQuestion({
    required this.id,
    required this.librarySubjectId,
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
    map['library_subject_id'] = Variable<int>(librarySubjectId);
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

  LibraryQuestionsCompanion toCompanion(bool nullToAbsent) {
    return LibraryQuestionsCompanion(
      id: Value(id),
      librarySubjectId: Value(librarySubjectId),
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

  factory LibraryQuestion.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LibraryQuestion(
      id: serializer.fromJson<int>(json['id']),
      librarySubjectId: serializer.fromJson<int>(json['librarySubjectId']),
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
      'librarySubjectId': serializer.toJson<int>(librarySubjectId),
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

  LibraryQuestion copyWith({
    int? id,
    int? librarySubjectId,
    String? questionText,
    Value<String?> imagePath = const Value.absent(),
    String? optionA,
    String? optionB,
    String? optionC,
    String? optionD,
    Value<String?> optionE = const Value.absent(),
    String? correctOption,
    Value<String?> explanation = const Value.absent(),
  }) => LibraryQuestion(
    id: id ?? this.id,
    librarySubjectId: librarySubjectId ?? this.librarySubjectId,
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
  LibraryQuestion copyWithCompanion(LibraryQuestionsCompanion data) {
    return LibraryQuestion(
      id: data.id.present ? data.id.value : this.id,
      librarySubjectId: data.librarySubjectId.present
          ? data.librarySubjectId.value
          : this.librarySubjectId,
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
    return (StringBuffer('LibraryQuestion(')
          ..write('id: $id, ')
          ..write('librarySubjectId: $librarySubjectId, ')
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
    librarySubjectId,
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
      (other is LibraryQuestion &&
          other.id == this.id &&
          other.librarySubjectId == this.librarySubjectId &&
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

class LibraryQuestionsCompanion extends UpdateCompanion<LibraryQuestion> {
  final Value<int> id;
  final Value<int> librarySubjectId;
  final Value<String> questionText;
  final Value<String?> imagePath;
  final Value<String> optionA;
  final Value<String> optionB;
  final Value<String> optionC;
  final Value<String> optionD;
  final Value<String?> optionE;
  final Value<String> correctOption;
  final Value<String?> explanation;
  const LibraryQuestionsCompanion({
    this.id = const Value.absent(),
    this.librarySubjectId = const Value.absent(),
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
  LibraryQuestionsCompanion.insert({
    this.id = const Value.absent(),
    required int librarySubjectId,
    required String questionText,
    this.imagePath = const Value.absent(),
    required String optionA,
    required String optionB,
    required String optionC,
    required String optionD,
    this.optionE = const Value.absent(),
    required String correctOption,
    this.explanation = const Value.absent(),
  }) : librarySubjectId = Value(librarySubjectId),
       questionText = Value(questionText),
       optionA = Value(optionA),
       optionB = Value(optionB),
       optionC = Value(optionC),
       optionD = Value(optionD),
       correctOption = Value(correctOption);
  static Insertable<LibraryQuestion> custom({
    Expression<int>? id,
    Expression<int>? librarySubjectId,
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
      if (librarySubjectId != null) 'library_subject_id': librarySubjectId,
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

  LibraryQuestionsCompanion copyWith({
    Value<int>? id,
    Value<int>? librarySubjectId,
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
    return LibraryQuestionsCompanion(
      id: id ?? this.id,
      librarySubjectId: librarySubjectId ?? this.librarySubjectId,
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
    if (librarySubjectId.present) {
      map['library_subject_id'] = Variable<int>(librarySubjectId.value);
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
    return (StringBuffer('LibraryQuestionsCompanion(')
          ..write('id: $id, ')
          ..write('librarySubjectId: $librarySubjectId, ')
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

class $InstalledStudyPacksTable extends InstalledStudyPacks
    with TableInfo<$InstalledStudyPacksTable, InstalledStudyPack> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InstalledStudyPacksTable(this.attachedDatabase, [this._alias]);
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
  static const String $name = 'installed_study_packs';
  @override
  VerificationContext validateIntegrity(
    Insertable<InstalledStudyPack> instance, {
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
  InstalledStudyPack map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InstalledStudyPack(
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
  $InstalledStudyPacksTable createAlias(String alias) {
    return $InstalledStudyPacksTable(attachedDatabase, alias);
  }
}

class InstalledStudyPack extends DataClass
    implements Insertable<InstalledStudyPack> {
  final int id;
  final String scopeType;
  final int scopeId;
  final String version;
  final String checksum;
  final int sizeBytes;
  final String installedAt;
  const InstalledStudyPack({
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

  InstalledStudyPacksCompanion toCompanion(bool nullToAbsent) {
    return InstalledStudyPacksCompanion(
      id: Value(id),
      scopeType: Value(scopeType),
      scopeId: Value(scopeId),
      version: Value(version),
      checksum: Value(checksum),
      sizeBytes: Value(sizeBytes),
      installedAt: Value(installedAt),
    );
  }

  factory InstalledStudyPack.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InstalledStudyPack(
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

  InstalledStudyPack copyWith({
    int? id,
    String? scopeType,
    int? scopeId,
    String? version,
    String? checksum,
    int? sizeBytes,
    String? installedAt,
  }) => InstalledStudyPack(
    id: id ?? this.id,
    scopeType: scopeType ?? this.scopeType,
    scopeId: scopeId ?? this.scopeId,
    version: version ?? this.version,
    checksum: checksum ?? this.checksum,
    sizeBytes: sizeBytes ?? this.sizeBytes,
    installedAt: installedAt ?? this.installedAt,
  );
  InstalledStudyPack copyWithCompanion(InstalledStudyPacksCompanion data) {
    return InstalledStudyPack(
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
    return (StringBuffer('InstalledStudyPack(')
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
      (other is InstalledStudyPack &&
          other.id == this.id &&
          other.scopeType == this.scopeType &&
          other.scopeId == this.scopeId &&
          other.version == this.version &&
          other.checksum == this.checksum &&
          other.sizeBytes == this.sizeBytes &&
          other.installedAt == this.installedAt);
}

class InstalledStudyPacksCompanion extends UpdateCompanion<InstalledStudyPack> {
  final Value<int> id;
  final Value<String> scopeType;
  final Value<int> scopeId;
  final Value<String> version;
  final Value<String> checksum;
  final Value<int> sizeBytes;
  final Value<String> installedAt;
  const InstalledStudyPacksCompanion({
    this.id = const Value.absent(),
    this.scopeType = const Value.absent(),
    this.scopeId = const Value.absent(),
    this.version = const Value.absent(),
    this.checksum = const Value.absent(),
    this.sizeBytes = const Value.absent(),
    this.installedAt = const Value.absent(),
  });
  InstalledStudyPacksCompanion.insert({
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
  static Insertable<InstalledStudyPack> custom({
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

  InstalledStudyPacksCompanion copyWith({
    Value<int>? id,
    Value<String>? scopeType,
    Value<int>? scopeId,
    Value<String>? version,
    Value<String>? checksum,
    Value<int>? sizeBytes,
    Value<String>? installedAt,
  }) {
    return InstalledStudyPacksCompanion(
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
    return (StringBuffer('InstalledStudyPacksCompanion(')
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

abstract class _$StudyContentDb extends GeneratedDatabase {
  _$StudyContentDb(QueryExecutor e) : super(e);
  $StudyContentDbManager get managers => $StudyContentDbManager(this);
  late final $ClassesTable classes = $ClassesTable(this);
  late final $TermsTable terms = $TermsTable(this);
  late final $LibraryBooksTable libraryBooks = $LibraryBooksTable(this);
  late final $LibrarySubjectsTable librarySubjects = $LibrarySubjectsTable(
    this,
  );
  late final $LibraryContentsTable libraryContents = $LibraryContentsTable(
    this,
  );
  late final $LibraryQuestionsTable libraryQuestions = $LibraryQuestionsTable(
    this,
  );
  late final $InstalledStudyPacksTable installedStudyPacks =
      $InstalledStudyPacksTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    classes,
    terms,
    libraryBooks,
    librarySubjects,
    libraryContents,
    libraryQuestions,
    installedStudyPacks,
  ];
}

typedef $$ClassesTableCreateCompanionBuilder =
    ClassesCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> code,
      required int sortOrder,
      required String category,
    });
typedef $$ClassesTableUpdateCompanionBuilder =
    ClassesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> code,
      Value<int> sortOrder,
      Value<String> category,
    });

class $$ClassesTableFilterComposer
    extends Composer<_$StudyContentDb, $ClassesTable> {
  $$ClassesTableFilterComposer({
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

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ClassesTableOrderingComposer
    extends Composer<_$StudyContentDb, $ClassesTable> {
  $$ClassesTableOrderingComposer({
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

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ClassesTableAnnotationComposer
    extends Composer<_$StudyContentDb, $ClassesTable> {
  $$ClassesTableAnnotationComposer({
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

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);
}

class $$ClassesTableTableManager
    extends
        RootTableManager<
          _$StudyContentDb,
          $ClassesTable,
          LibraryClass,
          $$ClassesTableFilterComposer,
          $$ClassesTableOrderingComposer,
          $$ClassesTableAnnotationComposer,
          $$ClassesTableCreateCompanionBuilder,
          $$ClassesTableUpdateCompanionBuilder,
          (
            LibraryClass,
            BaseReferences<_$StudyContentDb, $ClassesTable, LibraryClass>,
          ),
          LibraryClass,
          PrefetchHooks Function()
        > {
  $$ClassesTableTableManager(_$StudyContentDb db, $ClassesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClassesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClassesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClassesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> code = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<String> category = const Value.absent(),
              }) => ClassesCompanion(
                id: id,
                name: name,
                code: code,
                sortOrder: sortOrder,
                category: category,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> code = const Value.absent(),
                required int sortOrder,
                required String category,
              }) => ClassesCompanion.insert(
                id: id,
                name: name,
                code: code,
                sortOrder: sortOrder,
                category: category,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ClassesTableProcessedTableManager =
    ProcessedTableManager<
      _$StudyContentDb,
      $ClassesTable,
      LibraryClass,
      $$ClassesTableFilterComposer,
      $$ClassesTableOrderingComposer,
      $$ClassesTableAnnotationComposer,
      $$ClassesTableCreateCompanionBuilder,
      $$ClassesTableUpdateCompanionBuilder,
      (
        LibraryClass,
        BaseReferences<_$StudyContentDb, $ClassesTable, LibraryClass>,
      ),
      LibraryClass,
      PrefetchHooks Function()
    >;
typedef $$TermsTableCreateCompanionBuilder =
    TermsCompanion Function({
      Value<int> id,
      required String name,
      required String startDate,
      required String endDate,
    });
typedef $$TermsTableUpdateCompanionBuilder =
    TermsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> startDate,
      Value<String> endDate,
    });

class $$TermsTableFilterComposer
    extends Composer<_$StudyContentDb, $TermsTable> {
  $$TermsTableFilterComposer({
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

  ColumnFilters<String> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TermsTableOrderingComposer
    extends Composer<_$StudyContentDb, $TermsTable> {
  $$TermsTableOrderingComposer({
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

  ColumnOrderings<String> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TermsTableAnnotationComposer
    extends Composer<_$StudyContentDb, $TermsTable> {
  $$TermsTableAnnotationComposer({
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

  GeneratedColumn<String> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<String> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);
}

class $$TermsTableTableManager
    extends
        RootTableManager<
          _$StudyContentDb,
          $TermsTable,
          Term,
          $$TermsTableFilterComposer,
          $$TermsTableOrderingComposer,
          $$TermsTableAnnotationComposer,
          $$TermsTableCreateCompanionBuilder,
          $$TermsTableUpdateCompanionBuilder,
          (Term, BaseReferences<_$StudyContentDb, $TermsTable, Term>),
          Term,
          PrefetchHooks Function()
        > {
  $$TermsTableTableManager(_$StudyContentDb db, $TermsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TermsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TermsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TermsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> startDate = const Value.absent(),
                Value<String> endDate = const Value.absent(),
              }) => TermsCompanion(
                id: id,
                name: name,
                startDate: startDate,
                endDate: endDate,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String startDate,
                required String endDate,
              }) => TermsCompanion.insert(
                id: id,
                name: name,
                startDate: startDate,
                endDate: endDate,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TermsTableProcessedTableManager =
    ProcessedTableManager<
      _$StudyContentDb,
      $TermsTable,
      Term,
      $$TermsTableFilterComposer,
      $$TermsTableOrderingComposer,
      $$TermsTableAnnotationComposer,
      $$TermsTableCreateCompanionBuilder,
      $$TermsTableUpdateCompanionBuilder,
      (Term, BaseReferences<_$StudyContentDb, $TermsTable, Term>),
      Term,
      PrefetchHooks Function()
    >;
typedef $$LibraryBooksTableCreateCompanionBuilder =
    LibraryBooksCompanion Function({
      Value<int> id,
      required int classId,
      required String name,
      Value<String?> imagePath,
      required String color,
    });
typedef $$LibraryBooksTableUpdateCompanionBuilder =
    LibraryBooksCompanion Function({
      Value<int> id,
      Value<int> classId,
      Value<String> name,
      Value<String?> imagePath,
      Value<String> color,
    });

class $$LibraryBooksTableFilterComposer
    extends Composer<_$StudyContentDb, $LibraryBooksTable> {
  $$LibraryBooksTableFilterComposer({
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

  ColumnFilters<int> get classId => $composableBuilder(
    column: $table.classId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LibraryBooksTableOrderingComposer
    extends Composer<_$StudyContentDb, $LibraryBooksTable> {
  $$LibraryBooksTableOrderingComposer({
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

  ColumnOrderings<int> get classId => $composableBuilder(
    column: $table.classId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LibraryBooksTableAnnotationComposer
    extends Composer<_$StudyContentDb, $LibraryBooksTable> {
  $$LibraryBooksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get classId =>
      $composableBuilder(column: $table.classId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);
}

class $$LibraryBooksTableTableManager
    extends
        RootTableManager<
          _$StudyContentDb,
          $LibraryBooksTable,
          LibraryBook,
          $$LibraryBooksTableFilterComposer,
          $$LibraryBooksTableOrderingComposer,
          $$LibraryBooksTableAnnotationComposer,
          $$LibraryBooksTableCreateCompanionBuilder,
          $$LibraryBooksTableUpdateCompanionBuilder,
          (
            LibraryBook,
            BaseReferences<_$StudyContentDb, $LibraryBooksTable, LibraryBook>,
          ),
          LibraryBook,
          PrefetchHooks Function()
        > {
  $$LibraryBooksTableTableManager(_$StudyContentDb db, $LibraryBooksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LibraryBooksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LibraryBooksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LibraryBooksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> classId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                Value<String> color = const Value.absent(),
              }) => LibraryBooksCompanion(
                id: id,
                classId: classId,
                name: name,
                imagePath: imagePath,
                color: color,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int classId,
                required String name,
                Value<String?> imagePath = const Value.absent(),
                required String color,
              }) => LibraryBooksCompanion.insert(
                id: id,
                classId: classId,
                name: name,
                imagePath: imagePath,
                color: color,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LibraryBooksTableProcessedTableManager =
    ProcessedTableManager<
      _$StudyContentDb,
      $LibraryBooksTable,
      LibraryBook,
      $$LibraryBooksTableFilterComposer,
      $$LibraryBooksTableOrderingComposer,
      $$LibraryBooksTableAnnotationComposer,
      $$LibraryBooksTableCreateCompanionBuilder,
      $$LibraryBooksTableUpdateCompanionBuilder,
      (
        LibraryBook,
        BaseReferences<_$StudyContentDb, $LibraryBooksTable, LibraryBook>,
      ),
      LibraryBook,
      PrefetchHooks Function()
    >;
typedef $$LibrarySubjectsTableCreateCompanionBuilder =
    LibrarySubjectsCompanion Function({
      Value<int> id,
      required int libraryBookId,
      required int termId,
      required String title,
      Value<String?> description,
      Value<String?> coverImagePath,
      required String author,
      required int week,
      required int numOfTestQuestions,
    });
typedef $$LibrarySubjectsTableUpdateCompanionBuilder =
    LibrarySubjectsCompanion Function({
      Value<int> id,
      Value<int> libraryBookId,
      Value<int> termId,
      Value<String> title,
      Value<String?> description,
      Value<String?> coverImagePath,
      Value<String> author,
      Value<int> week,
      Value<int> numOfTestQuestions,
    });

class $$LibrarySubjectsTableFilterComposer
    extends Composer<_$StudyContentDb, $LibrarySubjectsTable> {
  $$LibrarySubjectsTableFilterComposer({
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

  ColumnFilters<int> get libraryBookId => $composableBuilder(
    column: $table.libraryBookId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get termId => $composableBuilder(
    column: $table.termId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get coverImagePath => $composableBuilder(
    column: $table.coverImagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get author => $composableBuilder(
    column: $table.author,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get week => $composableBuilder(
    column: $table.week,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get numOfTestQuestions => $composableBuilder(
    column: $table.numOfTestQuestions,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LibrarySubjectsTableOrderingComposer
    extends Composer<_$StudyContentDb, $LibrarySubjectsTable> {
  $$LibrarySubjectsTableOrderingComposer({
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

  ColumnOrderings<int> get libraryBookId => $composableBuilder(
    column: $table.libraryBookId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get termId => $composableBuilder(
    column: $table.termId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get coverImagePath => $composableBuilder(
    column: $table.coverImagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get author => $composableBuilder(
    column: $table.author,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get week => $composableBuilder(
    column: $table.week,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get numOfTestQuestions => $composableBuilder(
    column: $table.numOfTestQuestions,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LibrarySubjectsTableAnnotationComposer
    extends Composer<_$StudyContentDb, $LibrarySubjectsTable> {
  $$LibrarySubjectsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get libraryBookId => $composableBuilder(
    column: $table.libraryBookId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get termId =>
      $composableBuilder(column: $table.termId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get coverImagePath => $composableBuilder(
    column: $table.coverImagePath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get author =>
      $composableBuilder(column: $table.author, builder: (column) => column);

  GeneratedColumn<int> get week =>
      $composableBuilder(column: $table.week, builder: (column) => column);

  GeneratedColumn<int> get numOfTestQuestions => $composableBuilder(
    column: $table.numOfTestQuestions,
    builder: (column) => column,
  );
}

class $$LibrarySubjectsTableTableManager
    extends
        RootTableManager<
          _$StudyContentDb,
          $LibrarySubjectsTable,
          LibrarySubject,
          $$LibrarySubjectsTableFilterComposer,
          $$LibrarySubjectsTableOrderingComposer,
          $$LibrarySubjectsTableAnnotationComposer,
          $$LibrarySubjectsTableCreateCompanionBuilder,
          $$LibrarySubjectsTableUpdateCompanionBuilder,
          (
            LibrarySubject,
            BaseReferences<
              _$StudyContentDb,
              $LibrarySubjectsTable,
              LibrarySubject
            >,
          ),
          LibrarySubject,
          PrefetchHooks Function()
        > {
  $$LibrarySubjectsTableTableManager(
    _$StudyContentDb db,
    $LibrarySubjectsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LibrarySubjectsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LibrarySubjectsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LibrarySubjectsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> libraryBookId = const Value.absent(),
                Value<int> termId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> coverImagePath = const Value.absent(),
                Value<String> author = const Value.absent(),
                Value<int> week = const Value.absent(),
                Value<int> numOfTestQuestions = const Value.absent(),
              }) => LibrarySubjectsCompanion(
                id: id,
                libraryBookId: libraryBookId,
                termId: termId,
                title: title,
                description: description,
                coverImagePath: coverImagePath,
                author: author,
                week: week,
                numOfTestQuestions: numOfTestQuestions,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int libraryBookId,
                required int termId,
                required String title,
                Value<String?> description = const Value.absent(),
                Value<String?> coverImagePath = const Value.absent(),
                required String author,
                required int week,
                required int numOfTestQuestions,
              }) => LibrarySubjectsCompanion.insert(
                id: id,
                libraryBookId: libraryBookId,
                termId: termId,
                title: title,
                description: description,
                coverImagePath: coverImagePath,
                author: author,
                week: week,
                numOfTestQuestions: numOfTestQuestions,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LibrarySubjectsTableProcessedTableManager =
    ProcessedTableManager<
      _$StudyContentDb,
      $LibrarySubjectsTable,
      LibrarySubject,
      $$LibrarySubjectsTableFilterComposer,
      $$LibrarySubjectsTableOrderingComposer,
      $$LibrarySubjectsTableAnnotationComposer,
      $$LibrarySubjectsTableCreateCompanionBuilder,
      $$LibrarySubjectsTableUpdateCompanionBuilder,
      (
        LibrarySubject,
        BaseReferences<_$StudyContentDb, $LibrarySubjectsTable, LibrarySubject>,
      ),
      LibrarySubject,
      PrefetchHooks Function()
    >;
typedef $$LibraryContentsTableCreateCompanionBuilder =
    LibraryContentsCompanion Function({
      Value<int> id,
      required int librarySubjectId,
      required String contentHtml,
    });
typedef $$LibraryContentsTableUpdateCompanionBuilder =
    LibraryContentsCompanion Function({
      Value<int> id,
      Value<int> librarySubjectId,
      Value<String> contentHtml,
    });

class $$LibraryContentsTableFilterComposer
    extends Composer<_$StudyContentDb, $LibraryContentsTable> {
  $$LibraryContentsTableFilterComposer({
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

  ColumnFilters<int> get librarySubjectId => $composableBuilder(
    column: $table.librarySubjectId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contentHtml => $composableBuilder(
    column: $table.contentHtml,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LibraryContentsTableOrderingComposer
    extends Composer<_$StudyContentDb, $LibraryContentsTable> {
  $$LibraryContentsTableOrderingComposer({
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

  ColumnOrderings<int> get librarySubjectId => $composableBuilder(
    column: $table.librarySubjectId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contentHtml => $composableBuilder(
    column: $table.contentHtml,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LibraryContentsTableAnnotationComposer
    extends Composer<_$StudyContentDb, $LibraryContentsTable> {
  $$LibraryContentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get librarySubjectId => $composableBuilder(
    column: $table.librarySubjectId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get contentHtml => $composableBuilder(
    column: $table.contentHtml,
    builder: (column) => column,
  );
}

class $$LibraryContentsTableTableManager
    extends
        RootTableManager<
          _$StudyContentDb,
          $LibraryContentsTable,
          LibraryContent,
          $$LibraryContentsTableFilterComposer,
          $$LibraryContentsTableOrderingComposer,
          $$LibraryContentsTableAnnotationComposer,
          $$LibraryContentsTableCreateCompanionBuilder,
          $$LibraryContentsTableUpdateCompanionBuilder,
          (
            LibraryContent,
            BaseReferences<
              _$StudyContentDb,
              $LibraryContentsTable,
              LibraryContent
            >,
          ),
          LibraryContent,
          PrefetchHooks Function()
        > {
  $$LibraryContentsTableTableManager(
    _$StudyContentDb db,
    $LibraryContentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LibraryContentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LibraryContentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LibraryContentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> librarySubjectId = const Value.absent(),
                Value<String> contentHtml = const Value.absent(),
              }) => LibraryContentsCompanion(
                id: id,
                librarySubjectId: librarySubjectId,
                contentHtml: contentHtml,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int librarySubjectId,
                required String contentHtml,
              }) => LibraryContentsCompanion.insert(
                id: id,
                librarySubjectId: librarySubjectId,
                contentHtml: contentHtml,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LibraryContentsTableProcessedTableManager =
    ProcessedTableManager<
      _$StudyContentDb,
      $LibraryContentsTable,
      LibraryContent,
      $$LibraryContentsTableFilterComposer,
      $$LibraryContentsTableOrderingComposer,
      $$LibraryContentsTableAnnotationComposer,
      $$LibraryContentsTableCreateCompanionBuilder,
      $$LibraryContentsTableUpdateCompanionBuilder,
      (
        LibraryContent,
        BaseReferences<_$StudyContentDb, $LibraryContentsTable, LibraryContent>,
      ),
      LibraryContent,
      PrefetchHooks Function()
    >;
typedef $$LibraryQuestionsTableCreateCompanionBuilder =
    LibraryQuestionsCompanion Function({
      Value<int> id,
      required int librarySubjectId,
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
typedef $$LibraryQuestionsTableUpdateCompanionBuilder =
    LibraryQuestionsCompanion Function({
      Value<int> id,
      Value<int> librarySubjectId,
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

class $$LibraryQuestionsTableFilterComposer
    extends Composer<_$StudyContentDb, $LibraryQuestionsTable> {
  $$LibraryQuestionsTableFilterComposer({
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

  ColumnFilters<int> get librarySubjectId => $composableBuilder(
    column: $table.librarySubjectId,
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

class $$LibraryQuestionsTableOrderingComposer
    extends Composer<_$StudyContentDb, $LibraryQuestionsTable> {
  $$LibraryQuestionsTableOrderingComposer({
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

  ColumnOrderings<int> get librarySubjectId => $composableBuilder(
    column: $table.librarySubjectId,
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

class $$LibraryQuestionsTableAnnotationComposer
    extends Composer<_$StudyContentDb, $LibraryQuestionsTable> {
  $$LibraryQuestionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get librarySubjectId => $composableBuilder(
    column: $table.librarySubjectId,
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

class $$LibraryQuestionsTableTableManager
    extends
        RootTableManager<
          _$StudyContentDb,
          $LibraryQuestionsTable,
          LibraryQuestion,
          $$LibraryQuestionsTableFilterComposer,
          $$LibraryQuestionsTableOrderingComposer,
          $$LibraryQuestionsTableAnnotationComposer,
          $$LibraryQuestionsTableCreateCompanionBuilder,
          $$LibraryQuestionsTableUpdateCompanionBuilder,
          (
            LibraryQuestion,
            BaseReferences<
              _$StudyContentDb,
              $LibraryQuestionsTable,
              LibraryQuestion
            >,
          ),
          LibraryQuestion,
          PrefetchHooks Function()
        > {
  $$LibraryQuestionsTableTableManager(
    _$StudyContentDb db,
    $LibraryQuestionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LibraryQuestionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LibraryQuestionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LibraryQuestionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> librarySubjectId = const Value.absent(),
                Value<String> questionText = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                Value<String> optionA = const Value.absent(),
                Value<String> optionB = const Value.absent(),
                Value<String> optionC = const Value.absent(),
                Value<String> optionD = const Value.absent(),
                Value<String?> optionE = const Value.absent(),
                Value<String> correctOption = const Value.absent(),
                Value<String?> explanation = const Value.absent(),
              }) => LibraryQuestionsCompanion(
                id: id,
                librarySubjectId: librarySubjectId,
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
                required int librarySubjectId,
                required String questionText,
                Value<String?> imagePath = const Value.absent(),
                required String optionA,
                required String optionB,
                required String optionC,
                required String optionD,
                Value<String?> optionE = const Value.absent(),
                required String correctOption,
                Value<String?> explanation = const Value.absent(),
              }) => LibraryQuestionsCompanion.insert(
                id: id,
                librarySubjectId: librarySubjectId,
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

typedef $$LibraryQuestionsTableProcessedTableManager =
    ProcessedTableManager<
      _$StudyContentDb,
      $LibraryQuestionsTable,
      LibraryQuestion,
      $$LibraryQuestionsTableFilterComposer,
      $$LibraryQuestionsTableOrderingComposer,
      $$LibraryQuestionsTableAnnotationComposer,
      $$LibraryQuestionsTableCreateCompanionBuilder,
      $$LibraryQuestionsTableUpdateCompanionBuilder,
      (
        LibraryQuestion,
        BaseReferences<
          _$StudyContentDb,
          $LibraryQuestionsTable,
          LibraryQuestion
        >,
      ),
      LibraryQuestion,
      PrefetchHooks Function()
    >;
typedef $$InstalledStudyPacksTableCreateCompanionBuilder =
    InstalledStudyPacksCompanion Function({
      Value<int> id,
      required String scopeType,
      required int scopeId,
      required String version,
      required String checksum,
      required int sizeBytes,
      required String installedAt,
    });
typedef $$InstalledStudyPacksTableUpdateCompanionBuilder =
    InstalledStudyPacksCompanion Function({
      Value<int> id,
      Value<String> scopeType,
      Value<int> scopeId,
      Value<String> version,
      Value<String> checksum,
      Value<int> sizeBytes,
      Value<String> installedAt,
    });

class $$InstalledStudyPacksTableFilterComposer
    extends Composer<_$StudyContentDb, $InstalledStudyPacksTable> {
  $$InstalledStudyPacksTableFilterComposer({
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

class $$InstalledStudyPacksTableOrderingComposer
    extends Composer<_$StudyContentDb, $InstalledStudyPacksTable> {
  $$InstalledStudyPacksTableOrderingComposer({
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

class $$InstalledStudyPacksTableAnnotationComposer
    extends Composer<_$StudyContentDb, $InstalledStudyPacksTable> {
  $$InstalledStudyPacksTableAnnotationComposer({
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

class $$InstalledStudyPacksTableTableManager
    extends
        RootTableManager<
          _$StudyContentDb,
          $InstalledStudyPacksTable,
          InstalledStudyPack,
          $$InstalledStudyPacksTableFilterComposer,
          $$InstalledStudyPacksTableOrderingComposer,
          $$InstalledStudyPacksTableAnnotationComposer,
          $$InstalledStudyPacksTableCreateCompanionBuilder,
          $$InstalledStudyPacksTableUpdateCompanionBuilder,
          (
            InstalledStudyPack,
            BaseReferences<
              _$StudyContentDb,
              $InstalledStudyPacksTable,
              InstalledStudyPack
            >,
          ),
          InstalledStudyPack,
          PrefetchHooks Function()
        > {
  $$InstalledStudyPacksTableTableManager(
    _$StudyContentDb db,
    $InstalledStudyPacksTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InstalledStudyPacksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InstalledStudyPacksTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$InstalledStudyPacksTableAnnotationComposer(
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
              }) => InstalledStudyPacksCompanion(
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
              }) => InstalledStudyPacksCompanion.insert(
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

typedef $$InstalledStudyPacksTableProcessedTableManager =
    ProcessedTableManager<
      _$StudyContentDb,
      $InstalledStudyPacksTable,
      InstalledStudyPack,
      $$InstalledStudyPacksTableFilterComposer,
      $$InstalledStudyPacksTableOrderingComposer,
      $$InstalledStudyPacksTableAnnotationComposer,
      $$InstalledStudyPacksTableCreateCompanionBuilder,
      $$InstalledStudyPacksTableUpdateCompanionBuilder,
      (
        InstalledStudyPack,
        BaseReferences<
          _$StudyContentDb,
          $InstalledStudyPacksTable,
          InstalledStudyPack
        >,
      ),
      InstalledStudyPack,
      PrefetchHooks Function()
    >;

class $StudyContentDbManager {
  final _$StudyContentDb _db;
  $StudyContentDbManager(this._db);
  $$ClassesTableTableManager get classes =>
      $$ClassesTableTableManager(_db, _db.classes);
  $$TermsTableTableManager get terms =>
      $$TermsTableTableManager(_db, _db.terms);
  $$LibraryBooksTableTableManager get libraryBooks =>
      $$LibraryBooksTableTableManager(_db, _db.libraryBooks);
  $$LibrarySubjectsTableTableManager get librarySubjects =>
      $$LibrarySubjectsTableTableManager(_db, _db.librarySubjects);
  $$LibraryContentsTableTableManager get libraryContents =>
      $$LibraryContentsTableTableManager(_db, _db.libraryContents);
  $$LibraryQuestionsTableTableManager get libraryQuestions =>
      $$LibraryQuestionsTableTableManager(_db, _db.libraryQuestions);
  $$InstalledStudyPacksTableTableManager get installedStudyPacks =>
      $$InstalledStudyPacksTableTableManager(_db, _db.installedStudyPacks);
}
