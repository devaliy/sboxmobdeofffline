// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress_db.dart';

// ignore_for_file: type=lint
class $PracticeAttemptsTable extends PracticeAttempts
    with TableInfo<$PracticeAttemptsTable, PracticeAttempt> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PracticeAttemptsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceTypeMeta = const VerificationMeta(
    'sourceType',
  );
  @override
  late final GeneratedColumn<String> sourceType = GeneratedColumn<String>(
    'source_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
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
  static const VerificationMeta _librarySubjectIdMeta = const VerificationMeta(
    'librarySubjectId',
  );
  @override
  late final GeneratedColumn<int> librarySubjectId = GeneratedColumn<int>(
    'library_subject_id',
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
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<int> score = GeneratedColumn<int>(
    'score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalQuestionsMeta = const VerificationMeta(
    'totalQuestions',
  );
  @override
  late final GeneratedColumn<int> totalQuestions = GeneratedColumn<int>(
    'total_questions',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timeSpentSecondsMeta = const VerificationMeta(
    'timeSpentSeconds',
  );
  @override
  late final GeneratedColumn<int> timeSpentSeconds = GeneratedColumn<int>(
    'time_spent_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<String> startedAt = GeneratedColumn<String>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<String> completedAt = GeneratedColumn<String>(
    'completed_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<String> syncedAt = GeneratedColumn<String>(
    'synced_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _subjectNameMeta = const VerificationMeta(
    'subjectName',
  );
  @override
  late final GeneratedColumn<String> subjectName = GeneratedColumn<String>(
    'subject_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _testTypeLabelMeta = const VerificationMeta(
    'testTypeLabel',
  );
  @override
  late final GeneratedColumn<String> testTypeLabel = GeneratedColumn<String>(
    'test_type_label',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sourceType,
    subjectId,
    librarySubjectId,
    testTypeId,
    score,
    totalQuestions,
    timeSpentSeconds,
    startedAt,
    completedAt,
    syncedAt,
    subjectName,
    testTypeLabel,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'practice_attempts';
  @override
  VerificationContext validateIntegrity(
    Insertable<PracticeAttempt> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('source_type')) {
      context.handle(
        _sourceTypeMeta,
        sourceType.isAcceptableOrUnknown(data['source_type']!, _sourceTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceTypeMeta);
    }
    if (data.containsKey('subject_id')) {
      context.handle(
        _subjectIdMeta,
        subjectId.isAcceptableOrUnknown(data['subject_id']!, _subjectIdMeta),
      );
    }
    if (data.containsKey('library_subject_id')) {
      context.handle(
        _librarySubjectIdMeta,
        librarySubjectId.isAcceptableOrUnknown(
          data['library_subject_id']!,
          _librarySubjectIdMeta,
        ),
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
    if (data.containsKey('score')) {
      context.handle(
        _scoreMeta,
        score.isAcceptableOrUnknown(data['score']!, _scoreMeta),
      );
    } else if (isInserting) {
      context.missing(_scoreMeta);
    }
    if (data.containsKey('total_questions')) {
      context.handle(
        _totalQuestionsMeta,
        totalQuestions.isAcceptableOrUnknown(
          data['total_questions']!,
          _totalQuestionsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalQuestionsMeta);
    }
    if (data.containsKey('time_spent_seconds')) {
      context.handle(
        _timeSpentSecondsMeta,
        timeSpentSeconds.isAcceptableOrUnknown(
          data['time_spent_seconds']!,
          _timeSpentSecondsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_timeSpentSecondsMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_completedAtMeta);
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    if (data.containsKey('subject_name')) {
      context.handle(
        _subjectNameMeta,
        subjectName.isAcceptableOrUnknown(
          data['subject_name']!,
          _subjectNameMeta,
        ),
      );
    }
    if (data.containsKey('test_type_label')) {
      context.handle(
        _testTypeLabelMeta,
        testTypeLabel.isAcceptableOrUnknown(
          data['test_type_label']!,
          _testTypeLabelMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PracticeAttempt map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PracticeAttempt(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sourceType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_type'],
      )!,
      subjectId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}subject_id'],
      ),
      librarySubjectId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}library_subject_id'],
      ),
      testTypeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}test_type_id'],
      ),
      score: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}score'],
      )!,
      totalQuestions: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_questions'],
      )!,
      timeSpentSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}time_spent_seconds'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}started_at'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}completed_at'],
      )!,
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}synced_at'],
      ),
      subjectName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subject_name'],
      ),
      testTypeLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}test_type_label'],
      ),
    );
  }

  @override
  $PracticeAttemptsTable createAlias(String alias) {
    return $PracticeAttemptsTable(attachedDatabase, alias);
  }
}

class PracticeAttempt extends DataClass implements Insertable<PracticeAttempt> {
  final String id;
  final String sourceType;
  final int? subjectId;
  final int? librarySubjectId;
  final int? testTypeId;
  final int score;
  final int totalQuestions;
  final int timeSpentSeconds;
  final String startedAt;
  final String completedAt;
  final String? syncedAt;
  final String? subjectName;
  final String? testTypeLabel;
  const PracticeAttempt({
    required this.id,
    required this.sourceType,
    this.subjectId,
    this.librarySubjectId,
    this.testTypeId,
    required this.score,
    required this.totalQuestions,
    required this.timeSpentSeconds,
    required this.startedAt,
    required this.completedAt,
    this.syncedAt,
    this.subjectName,
    this.testTypeLabel,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['source_type'] = Variable<String>(sourceType);
    if (!nullToAbsent || subjectId != null) {
      map['subject_id'] = Variable<int>(subjectId);
    }
    if (!nullToAbsent || librarySubjectId != null) {
      map['library_subject_id'] = Variable<int>(librarySubjectId);
    }
    if (!nullToAbsent || testTypeId != null) {
      map['test_type_id'] = Variable<int>(testTypeId);
    }
    map['score'] = Variable<int>(score);
    map['total_questions'] = Variable<int>(totalQuestions);
    map['time_spent_seconds'] = Variable<int>(timeSpentSeconds);
    map['started_at'] = Variable<String>(startedAt);
    map['completed_at'] = Variable<String>(completedAt);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<String>(syncedAt);
    }
    if (!nullToAbsent || subjectName != null) {
      map['subject_name'] = Variable<String>(subjectName);
    }
    if (!nullToAbsent || testTypeLabel != null) {
      map['test_type_label'] = Variable<String>(testTypeLabel);
    }
    return map;
  }

  PracticeAttemptsCompanion toCompanion(bool nullToAbsent) {
    return PracticeAttemptsCompanion(
      id: Value(id),
      sourceType: Value(sourceType),
      subjectId: subjectId == null && nullToAbsent
          ? const Value.absent()
          : Value(subjectId),
      librarySubjectId: librarySubjectId == null && nullToAbsent
          ? const Value.absent()
          : Value(librarySubjectId),
      testTypeId: testTypeId == null && nullToAbsent
          ? const Value.absent()
          : Value(testTypeId),
      score: Value(score),
      totalQuestions: Value(totalQuestions),
      timeSpentSeconds: Value(timeSpentSeconds),
      startedAt: Value(startedAt),
      completedAt: Value(completedAt),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
      subjectName: subjectName == null && nullToAbsent
          ? const Value.absent()
          : Value(subjectName),
      testTypeLabel: testTypeLabel == null && nullToAbsent
          ? const Value.absent()
          : Value(testTypeLabel),
    );
  }

  factory PracticeAttempt.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PracticeAttempt(
      id: serializer.fromJson<String>(json['id']),
      sourceType: serializer.fromJson<String>(json['sourceType']),
      subjectId: serializer.fromJson<int?>(json['subjectId']),
      librarySubjectId: serializer.fromJson<int?>(json['librarySubjectId']),
      testTypeId: serializer.fromJson<int?>(json['testTypeId']),
      score: serializer.fromJson<int>(json['score']),
      totalQuestions: serializer.fromJson<int>(json['totalQuestions']),
      timeSpentSeconds: serializer.fromJson<int>(json['timeSpentSeconds']),
      startedAt: serializer.fromJson<String>(json['startedAt']),
      completedAt: serializer.fromJson<String>(json['completedAt']),
      syncedAt: serializer.fromJson<String?>(json['syncedAt']),
      subjectName: serializer.fromJson<String?>(json['subjectName']),
      testTypeLabel: serializer.fromJson<String?>(json['testTypeLabel']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sourceType': serializer.toJson<String>(sourceType),
      'subjectId': serializer.toJson<int?>(subjectId),
      'librarySubjectId': serializer.toJson<int?>(librarySubjectId),
      'testTypeId': serializer.toJson<int?>(testTypeId),
      'score': serializer.toJson<int>(score),
      'totalQuestions': serializer.toJson<int>(totalQuestions),
      'timeSpentSeconds': serializer.toJson<int>(timeSpentSeconds),
      'startedAt': serializer.toJson<String>(startedAt),
      'completedAt': serializer.toJson<String>(completedAt),
      'syncedAt': serializer.toJson<String?>(syncedAt),
      'subjectName': serializer.toJson<String?>(subjectName),
      'testTypeLabel': serializer.toJson<String?>(testTypeLabel),
    };
  }

  PracticeAttempt copyWith({
    String? id,
    String? sourceType,
    Value<int?> subjectId = const Value.absent(),
    Value<int?> librarySubjectId = const Value.absent(),
    Value<int?> testTypeId = const Value.absent(),
    int? score,
    int? totalQuestions,
    int? timeSpentSeconds,
    String? startedAt,
    String? completedAt,
    Value<String?> syncedAt = const Value.absent(),
    Value<String?> subjectName = const Value.absent(),
    Value<String?> testTypeLabel = const Value.absent(),
  }) => PracticeAttempt(
    id: id ?? this.id,
    sourceType: sourceType ?? this.sourceType,
    subjectId: subjectId.present ? subjectId.value : this.subjectId,
    librarySubjectId: librarySubjectId.present
        ? librarySubjectId.value
        : this.librarySubjectId,
    testTypeId: testTypeId.present ? testTypeId.value : this.testTypeId,
    score: score ?? this.score,
    totalQuestions: totalQuestions ?? this.totalQuestions,
    timeSpentSeconds: timeSpentSeconds ?? this.timeSpentSeconds,
    startedAt: startedAt ?? this.startedAt,
    completedAt: completedAt ?? this.completedAt,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
    subjectName: subjectName.present ? subjectName.value : this.subjectName,
    testTypeLabel: testTypeLabel.present
        ? testTypeLabel.value
        : this.testTypeLabel,
  );
  PracticeAttempt copyWithCompanion(PracticeAttemptsCompanion data) {
    return PracticeAttempt(
      id: data.id.present ? data.id.value : this.id,
      sourceType: data.sourceType.present
          ? data.sourceType.value
          : this.sourceType,
      subjectId: data.subjectId.present ? data.subjectId.value : this.subjectId,
      librarySubjectId: data.librarySubjectId.present
          ? data.librarySubjectId.value
          : this.librarySubjectId,
      testTypeId: data.testTypeId.present
          ? data.testTypeId.value
          : this.testTypeId,
      score: data.score.present ? data.score.value : this.score,
      totalQuestions: data.totalQuestions.present
          ? data.totalQuestions.value
          : this.totalQuestions,
      timeSpentSeconds: data.timeSpentSeconds.present
          ? data.timeSpentSeconds.value
          : this.timeSpentSeconds,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
      subjectName: data.subjectName.present
          ? data.subjectName.value
          : this.subjectName,
      testTypeLabel: data.testTypeLabel.present
          ? data.testTypeLabel.value
          : this.testTypeLabel,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PracticeAttempt(')
          ..write('id: $id, ')
          ..write('sourceType: $sourceType, ')
          ..write('subjectId: $subjectId, ')
          ..write('librarySubjectId: $librarySubjectId, ')
          ..write('testTypeId: $testTypeId, ')
          ..write('score: $score, ')
          ..write('totalQuestions: $totalQuestions, ')
          ..write('timeSpentSeconds: $timeSpentSeconds, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('subjectName: $subjectName, ')
          ..write('testTypeLabel: $testTypeLabel')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sourceType,
    subjectId,
    librarySubjectId,
    testTypeId,
    score,
    totalQuestions,
    timeSpentSeconds,
    startedAt,
    completedAt,
    syncedAt,
    subjectName,
    testTypeLabel,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PracticeAttempt &&
          other.id == this.id &&
          other.sourceType == this.sourceType &&
          other.subjectId == this.subjectId &&
          other.librarySubjectId == this.librarySubjectId &&
          other.testTypeId == this.testTypeId &&
          other.score == this.score &&
          other.totalQuestions == this.totalQuestions &&
          other.timeSpentSeconds == this.timeSpentSeconds &&
          other.startedAt == this.startedAt &&
          other.completedAt == this.completedAt &&
          other.syncedAt == this.syncedAt &&
          other.subjectName == this.subjectName &&
          other.testTypeLabel == this.testTypeLabel);
}

class PracticeAttemptsCompanion extends UpdateCompanion<PracticeAttempt> {
  final Value<String> id;
  final Value<String> sourceType;
  final Value<int?> subjectId;
  final Value<int?> librarySubjectId;
  final Value<int?> testTypeId;
  final Value<int> score;
  final Value<int> totalQuestions;
  final Value<int> timeSpentSeconds;
  final Value<String> startedAt;
  final Value<String> completedAt;
  final Value<String?> syncedAt;
  final Value<String?> subjectName;
  final Value<String?> testTypeLabel;
  final Value<int> rowid;
  const PracticeAttemptsCompanion({
    this.id = const Value.absent(),
    this.sourceType = const Value.absent(),
    this.subjectId = const Value.absent(),
    this.librarySubjectId = const Value.absent(),
    this.testTypeId = const Value.absent(),
    this.score = const Value.absent(),
    this.totalQuestions = const Value.absent(),
    this.timeSpentSeconds = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.subjectName = const Value.absent(),
    this.testTypeLabel = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PracticeAttemptsCompanion.insert({
    required String id,
    required String sourceType,
    this.subjectId = const Value.absent(),
    this.librarySubjectId = const Value.absent(),
    this.testTypeId = const Value.absent(),
    required int score,
    required int totalQuestions,
    required int timeSpentSeconds,
    required String startedAt,
    required String completedAt,
    this.syncedAt = const Value.absent(),
    this.subjectName = const Value.absent(),
    this.testTypeLabel = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sourceType = Value(sourceType),
       score = Value(score),
       totalQuestions = Value(totalQuestions),
       timeSpentSeconds = Value(timeSpentSeconds),
       startedAt = Value(startedAt),
       completedAt = Value(completedAt);
  static Insertable<PracticeAttempt> custom({
    Expression<String>? id,
    Expression<String>? sourceType,
    Expression<int>? subjectId,
    Expression<int>? librarySubjectId,
    Expression<int>? testTypeId,
    Expression<int>? score,
    Expression<int>? totalQuestions,
    Expression<int>? timeSpentSeconds,
    Expression<String>? startedAt,
    Expression<String>? completedAt,
    Expression<String>? syncedAt,
    Expression<String>? subjectName,
    Expression<String>? testTypeLabel,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sourceType != null) 'source_type': sourceType,
      if (subjectId != null) 'subject_id': subjectId,
      if (librarySubjectId != null) 'library_subject_id': librarySubjectId,
      if (testTypeId != null) 'test_type_id': testTypeId,
      if (score != null) 'score': score,
      if (totalQuestions != null) 'total_questions': totalQuestions,
      if (timeSpentSeconds != null) 'time_spent_seconds': timeSpentSeconds,
      if (startedAt != null) 'started_at': startedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (subjectName != null) 'subject_name': subjectName,
      if (testTypeLabel != null) 'test_type_label': testTypeLabel,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PracticeAttemptsCompanion copyWith({
    Value<String>? id,
    Value<String>? sourceType,
    Value<int?>? subjectId,
    Value<int?>? librarySubjectId,
    Value<int?>? testTypeId,
    Value<int>? score,
    Value<int>? totalQuestions,
    Value<int>? timeSpentSeconds,
    Value<String>? startedAt,
    Value<String>? completedAt,
    Value<String?>? syncedAt,
    Value<String?>? subjectName,
    Value<String?>? testTypeLabel,
    Value<int>? rowid,
  }) {
    return PracticeAttemptsCompanion(
      id: id ?? this.id,
      sourceType: sourceType ?? this.sourceType,
      subjectId: subjectId ?? this.subjectId,
      librarySubjectId: librarySubjectId ?? this.librarySubjectId,
      testTypeId: testTypeId ?? this.testTypeId,
      score: score ?? this.score,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      timeSpentSeconds: timeSpentSeconds ?? this.timeSpentSeconds,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      syncedAt: syncedAt ?? this.syncedAt,
      subjectName: subjectName ?? this.subjectName,
      testTypeLabel: testTypeLabel ?? this.testTypeLabel,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sourceType.present) {
      map['source_type'] = Variable<String>(sourceType.value);
    }
    if (subjectId.present) {
      map['subject_id'] = Variable<int>(subjectId.value);
    }
    if (librarySubjectId.present) {
      map['library_subject_id'] = Variable<int>(librarySubjectId.value);
    }
    if (testTypeId.present) {
      map['test_type_id'] = Variable<int>(testTypeId.value);
    }
    if (score.present) {
      map['score'] = Variable<int>(score.value);
    }
    if (totalQuestions.present) {
      map['total_questions'] = Variable<int>(totalQuestions.value);
    }
    if (timeSpentSeconds.present) {
      map['time_spent_seconds'] = Variable<int>(timeSpentSeconds.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<String>(startedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<String>(completedAt.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<String>(syncedAt.value);
    }
    if (subjectName.present) {
      map['subject_name'] = Variable<String>(subjectName.value);
    }
    if (testTypeLabel.present) {
      map['test_type_label'] = Variable<String>(testTypeLabel.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PracticeAttemptsCompanion(')
          ..write('id: $id, ')
          ..write('sourceType: $sourceType, ')
          ..write('subjectId: $subjectId, ')
          ..write('librarySubjectId: $librarySubjectId, ')
          ..write('testTypeId: $testTypeId, ')
          ..write('score: $score, ')
          ..write('totalQuestions: $totalQuestions, ')
          ..write('timeSpentSeconds: $timeSpentSeconds, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('subjectName: $subjectName, ')
          ..write('testTypeLabel: $testTypeLabel, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PracticeAnswersTable extends PracticeAnswers
    with TableInfo<$PracticeAnswersTable, PracticeAnswer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PracticeAnswersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _attemptIdMeta = const VerificationMeta(
    'attemptId',
  );
  @override
  late final GeneratedColumn<String> attemptId = GeneratedColumn<String>(
    'attempt_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _questionIdMeta = const VerificationMeta(
    'questionId',
  );
  @override
  late final GeneratedColumn<int> questionId = GeneratedColumn<int>(
    'question_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _questionSourceMeta = const VerificationMeta(
    'questionSource',
  );
  @override
  late final GeneratedColumn<String> questionSource = GeneratedColumn<String>(
    'question_source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _selectedOptionMeta = const VerificationMeta(
    'selectedOption',
  );
  @override
  late final GeneratedColumn<String> selectedOption = GeneratedColumn<String>(
    'selected_option',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isCorrectMeta = const VerificationMeta(
    'isCorrect',
  );
  @override
  late final GeneratedColumn<bool> isCorrect = GeneratedColumn<bool>(
    'is_correct',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_correct" IN (0, 1))',
    ),
  );
  static const VerificationMeta _timeSpentSecondsMeta = const VerificationMeta(
    'timeSpentSeconds',
  );
  @override
  late final GeneratedColumn<int> timeSpentSeconds = GeneratedColumn<int>(
    'time_spent_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    attemptId,
    questionId,
    questionSource,
    selectedOption,
    isCorrect,
    timeSpentSeconds,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'practice_answers';
  @override
  VerificationContext validateIntegrity(
    Insertable<PracticeAnswer> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('attempt_id')) {
      context.handle(
        _attemptIdMeta,
        attemptId.isAcceptableOrUnknown(data['attempt_id']!, _attemptIdMeta),
      );
    } else if (isInserting) {
      context.missing(_attemptIdMeta);
    }
    if (data.containsKey('question_id')) {
      context.handle(
        _questionIdMeta,
        questionId.isAcceptableOrUnknown(data['question_id']!, _questionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_questionIdMeta);
    }
    if (data.containsKey('question_source')) {
      context.handle(
        _questionSourceMeta,
        questionSource.isAcceptableOrUnknown(
          data['question_source']!,
          _questionSourceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_questionSourceMeta);
    }
    if (data.containsKey('selected_option')) {
      context.handle(
        _selectedOptionMeta,
        selectedOption.isAcceptableOrUnknown(
          data['selected_option']!,
          _selectedOptionMeta,
        ),
      );
    }
    if (data.containsKey('is_correct')) {
      context.handle(
        _isCorrectMeta,
        isCorrect.isAcceptableOrUnknown(data['is_correct']!, _isCorrectMeta),
      );
    } else if (isInserting) {
      context.missing(_isCorrectMeta);
    }
    if (data.containsKey('time_spent_seconds')) {
      context.handle(
        _timeSpentSecondsMeta,
        timeSpentSeconds.isAcceptableOrUnknown(
          data['time_spent_seconds']!,
          _timeSpentSecondsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_timeSpentSecondsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PracticeAnswer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PracticeAnswer(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      attemptId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}attempt_id'],
      )!,
      questionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}question_id'],
      )!,
      questionSource: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}question_source'],
      )!,
      selectedOption: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}selected_option'],
      ),
      isCorrect: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_correct'],
      )!,
      timeSpentSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}time_spent_seconds'],
      )!,
    );
  }

  @override
  $PracticeAnswersTable createAlias(String alias) {
    return $PracticeAnswersTable(attachedDatabase, alias);
  }
}

class PracticeAnswer extends DataClass implements Insertable<PracticeAnswer> {
  final String id;
  final String attemptId;
  final int questionId;
  final String questionSource;
  final String? selectedOption;
  final bool isCorrect;
  final int timeSpentSeconds;
  const PracticeAnswer({
    required this.id,
    required this.attemptId,
    required this.questionId,
    required this.questionSource,
    this.selectedOption,
    required this.isCorrect,
    required this.timeSpentSeconds,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['attempt_id'] = Variable<String>(attemptId);
    map['question_id'] = Variable<int>(questionId);
    map['question_source'] = Variable<String>(questionSource);
    if (!nullToAbsent || selectedOption != null) {
      map['selected_option'] = Variable<String>(selectedOption);
    }
    map['is_correct'] = Variable<bool>(isCorrect);
    map['time_spent_seconds'] = Variable<int>(timeSpentSeconds);
    return map;
  }

  PracticeAnswersCompanion toCompanion(bool nullToAbsent) {
    return PracticeAnswersCompanion(
      id: Value(id),
      attemptId: Value(attemptId),
      questionId: Value(questionId),
      questionSource: Value(questionSource),
      selectedOption: selectedOption == null && nullToAbsent
          ? const Value.absent()
          : Value(selectedOption),
      isCorrect: Value(isCorrect),
      timeSpentSeconds: Value(timeSpentSeconds),
    );
  }

  factory PracticeAnswer.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PracticeAnswer(
      id: serializer.fromJson<String>(json['id']),
      attemptId: serializer.fromJson<String>(json['attemptId']),
      questionId: serializer.fromJson<int>(json['questionId']),
      questionSource: serializer.fromJson<String>(json['questionSource']),
      selectedOption: serializer.fromJson<String?>(json['selectedOption']),
      isCorrect: serializer.fromJson<bool>(json['isCorrect']),
      timeSpentSeconds: serializer.fromJson<int>(json['timeSpentSeconds']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'attemptId': serializer.toJson<String>(attemptId),
      'questionId': serializer.toJson<int>(questionId),
      'questionSource': serializer.toJson<String>(questionSource),
      'selectedOption': serializer.toJson<String?>(selectedOption),
      'isCorrect': serializer.toJson<bool>(isCorrect),
      'timeSpentSeconds': serializer.toJson<int>(timeSpentSeconds),
    };
  }

  PracticeAnswer copyWith({
    String? id,
    String? attemptId,
    int? questionId,
    String? questionSource,
    Value<String?> selectedOption = const Value.absent(),
    bool? isCorrect,
    int? timeSpentSeconds,
  }) => PracticeAnswer(
    id: id ?? this.id,
    attemptId: attemptId ?? this.attemptId,
    questionId: questionId ?? this.questionId,
    questionSource: questionSource ?? this.questionSource,
    selectedOption: selectedOption.present
        ? selectedOption.value
        : this.selectedOption,
    isCorrect: isCorrect ?? this.isCorrect,
    timeSpentSeconds: timeSpentSeconds ?? this.timeSpentSeconds,
  );
  PracticeAnswer copyWithCompanion(PracticeAnswersCompanion data) {
    return PracticeAnswer(
      id: data.id.present ? data.id.value : this.id,
      attemptId: data.attemptId.present ? data.attemptId.value : this.attemptId,
      questionId: data.questionId.present
          ? data.questionId.value
          : this.questionId,
      questionSource: data.questionSource.present
          ? data.questionSource.value
          : this.questionSource,
      selectedOption: data.selectedOption.present
          ? data.selectedOption.value
          : this.selectedOption,
      isCorrect: data.isCorrect.present ? data.isCorrect.value : this.isCorrect,
      timeSpentSeconds: data.timeSpentSeconds.present
          ? data.timeSpentSeconds.value
          : this.timeSpentSeconds,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PracticeAnswer(')
          ..write('id: $id, ')
          ..write('attemptId: $attemptId, ')
          ..write('questionId: $questionId, ')
          ..write('questionSource: $questionSource, ')
          ..write('selectedOption: $selectedOption, ')
          ..write('isCorrect: $isCorrect, ')
          ..write('timeSpentSeconds: $timeSpentSeconds')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    attemptId,
    questionId,
    questionSource,
    selectedOption,
    isCorrect,
    timeSpentSeconds,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PracticeAnswer &&
          other.id == this.id &&
          other.attemptId == this.attemptId &&
          other.questionId == this.questionId &&
          other.questionSource == this.questionSource &&
          other.selectedOption == this.selectedOption &&
          other.isCorrect == this.isCorrect &&
          other.timeSpentSeconds == this.timeSpentSeconds);
}

class PracticeAnswersCompanion extends UpdateCompanion<PracticeAnswer> {
  final Value<String> id;
  final Value<String> attemptId;
  final Value<int> questionId;
  final Value<String> questionSource;
  final Value<String?> selectedOption;
  final Value<bool> isCorrect;
  final Value<int> timeSpentSeconds;
  final Value<int> rowid;
  const PracticeAnswersCompanion({
    this.id = const Value.absent(),
    this.attemptId = const Value.absent(),
    this.questionId = const Value.absent(),
    this.questionSource = const Value.absent(),
    this.selectedOption = const Value.absent(),
    this.isCorrect = const Value.absent(),
    this.timeSpentSeconds = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PracticeAnswersCompanion.insert({
    required String id,
    required String attemptId,
    required int questionId,
    required String questionSource,
    this.selectedOption = const Value.absent(),
    required bool isCorrect,
    required int timeSpentSeconds,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       attemptId = Value(attemptId),
       questionId = Value(questionId),
       questionSource = Value(questionSource),
       isCorrect = Value(isCorrect),
       timeSpentSeconds = Value(timeSpentSeconds);
  static Insertable<PracticeAnswer> custom({
    Expression<String>? id,
    Expression<String>? attemptId,
    Expression<int>? questionId,
    Expression<String>? questionSource,
    Expression<String>? selectedOption,
    Expression<bool>? isCorrect,
    Expression<int>? timeSpentSeconds,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (attemptId != null) 'attempt_id': attemptId,
      if (questionId != null) 'question_id': questionId,
      if (questionSource != null) 'question_source': questionSource,
      if (selectedOption != null) 'selected_option': selectedOption,
      if (isCorrect != null) 'is_correct': isCorrect,
      if (timeSpentSeconds != null) 'time_spent_seconds': timeSpentSeconds,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PracticeAnswersCompanion copyWith({
    Value<String>? id,
    Value<String>? attemptId,
    Value<int>? questionId,
    Value<String>? questionSource,
    Value<String?>? selectedOption,
    Value<bool>? isCorrect,
    Value<int>? timeSpentSeconds,
    Value<int>? rowid,
  }) {
    return PracticeAnswersCompanion(
      id: id ?? this.id,
      attemptId: attemptId ?? this.attemptId,
      questionId: questionId ?? this.questionId,
      questionSource: questionSource ?? this.questionSource,
      selectedOption: selectedOption ?? this.selectedOption,
      isCorrect: isCorrect ?? this.isCorrect,
      timeSpentSeconds: timeSpentSeconds ?? this.timeSpentSeconds,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (attemptId.present) {
      map['attempt_id'] = Variable<String>(attemptId.value);
    }
    if (questionId.present) {
      map['question_id'] = Variable<int>(questionId.value);
    }
    if (questionSource.present) {
      map['question_source'] = Variable<String>(questionSource.value);
    }
    if (selectedOption.present) {
      map['selected_option'] = Variable<String>(selectedOption.value);
    }
    if (isCorrect.present) {
      map['is_correct'] = Variable<bool>(isCorrect.value);
    }
    if (timeSpentSeconds.present) {
      map['time_spent_seconds'] = Variable<int>(timeSpentSeconds.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PracticeAnswersCompanion(')
          ..write('id: $id, ')
          ..write('attemptId: $attemptId, ')
          ..write('questionId: $questionId, ')
          ..write('questionSource: $questionSource, ')
          ..write('selectedOption: $selectedOption, ')
          ..write('isCorrect: $isCorrect, ')
          ..write('timeSpentSeconds: $timeSpentSeconds, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReadingProgressTable extends ReadingProgress
    with TableInfo<$ReadingProgressTable, ReadingProgressData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReadingProgressTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _lastPositionMeta = const VerificationMeta(
    'lastPosition',
  );
  @override
  late final GeneratedColumn<String> lastPosition = GeneratedColumn<String>(
    'last_position',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _percentCompleteMeta = const VerificationMeta(
    'percentComplete',
  );
  @override
  late final GeneratedColumn<int> percentComplete = GeneratedColumn<int>(
    'percent_complete',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastOpenedAtMeta = const VerificationMeta(
    'lastOpenedAt',
  );
  @override
  late final GeneratedColumn<String> lastOpenedAt = GeneratedColumn<String>(
    'last_opened_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<String> syncedAt = GeneratedColumn<String>(
    'synced_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    librarySubjectId,
    lastPosition,
    percentComplete,
    lastOpenedAt,
    syncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reading_progress';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReadingProgressData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
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
    if (data.containsKey('last_position')) {
      context.handle(
        _lastPositionMeta,
        lastPosition.isAcceptableOrUnknown(
          data['last_position']!,
          _lastPositionMeta,
        ),
      );
    }
    if (data.containsKey('percent_complete')) {
      context.handle(
        _percentCompleteMeta,
        percentComplete.isAcceptableOrUnknown(
          data['percent_complete']!,
          _percentCompleteMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_percentCompleteMeta);
    }
    if (data.containsKey('last_opened_at')) {
      context.handle(
        _lastOpenedAtMeta,
        lastOpenedAt.isAcceptableOrUnknown(
          data['last_opened_at']!,
          _lastOpenedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastOpenedAtMeta);
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReadingProgressData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReadingProgressData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      librarySubjectId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}library_subject_id'],
      )!,
      lastPosition: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_position'],
      ),
      percentComplete: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}percent_complete'],
      )!,
      lastOpenedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_opened_at'],
      )!,
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}synced_at'],
      ),
    );
  }

  @override
  $ReadingProgressTable createAlias(String alias) {
    return $ReadingProgressTable(attachedDatabase, alias);
  }
}

class ReadingProgressData extends DataClass
    implements Insertable<ReadingProgressData> {
  final String id;
  final int librarySubjectId;
  final String? lastPosition;
  final int percentComplete;
  final String lastOpenedAt;
  final String? syncedAt;
  const ReadingProgressData({
    required this.id,
    required this.librarySubjectId,
    this.lastPosition,
    required this.percentComplete,
    required this.lastOpenedAt,
    this.syncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['library_subject_id'] = Variable<int>(librarySubjectId);
    if (!nullToAbsent || lastPosition != null) {
      map['last_position'] = Variable<String>(lastPosition);
    }
    map['percent_complete'] = Variable<int>(percentComplete);
    map['last_opened_at'] = Variable<String>(lastOpenedAt);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<String>(syncedAt);
    }
    return map;
  }

  ReadingProgressCompanion toCompanion(bool nullToAbsent) {
    return ReadingProgressCompanion(
      id: Value(id),
      librarySubjectId: Value(librarySubjectId),
      lastPosition: lastPosition == null && nullToAbsent
          ? const Value.absent()
          : Value(lastPosition),
      percentComplete: Value(percentComplete),
      lastOpenedAt: Value(lastOpenedAt),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory ReadingProgressData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReadingProgressData(
      id: serializer.fromJson<String>(json['id']),
      librarySubjectId: serializer.fromJson<int>(json['librarySubjectId']),
      lastPosition: serializer.fromJson<String?>(json['lastPosition']),
      percentComplete: serializer.fromJson<int>(json['percentComplete']),
      lastOpenedAt: serializer.fromJson<String>(json['lastOpenedAt']),
      syncedAt: serializer.fromJson<String?>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'librarySubjectId': serializer.toJson<int>(librarySubjectId),
      'lastPosition': serializer.toJson<String?>(lastPosition),
      'percentComplete': serializer.toJson<int>(percentComplete),
      'lastOpenedAt': serializer.toJson<String>(lastOpenedAt),
      'syncedAt': serializer.toJson<String?>(syncedAt),
    };
  }

  ReadingProgressData copyWith({
    String? id,
    int? librarySubjectId,
    Value<String?> lastPosition = const Value.absent(),
    int? percentComplete,
    String? lastOpenedAt,
    Value<String?> syncedAt = const Value.absent(),
  }) => ReadingProgressData(
    id: id ?? this.id,
    librarySubjectId: librarySubjectId ?? this.librarySubjectId,
    lastPosition: lastPosition.present ? lastPosition.value : this.lastPosition,
    percentComplete: percentComplete ?? this.percentComplete,
    lastOpenedAt: lastOpenedAt ?? this.lastOpenedAt,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
  );
  ReadingProgressData copyWithCompanion(ReadingProgressCompanion data) {
    return ReadingProgressData(
      id: data.id.present ? data.id.value : this.id,
      librarySubjectId: data.librarySubjectId.present
          ? data.librarySubjectId.value
          : this.librarySubjectId,
      lastPosition: data.lastPosition.present
          ? data.lastPosition.value
          : this.lastPosition,
      percentComplete: data.percentComplete.present
          ? data.percentComplete.value
          : this.percentComplete,
      lastOpenedAt: data.lastOpenedAt.present
          ? data.lastOpenedAt.value
          : this.lastOpenedAt,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReadingProgressData(')
          ..write('id: $id, ')
          ..write('librarySubjectId: $librarySubjectId, ')
          ..write('lastPosition: $lastPosition, ')
          ..write('percentComplete: $percentComplete, ')
          ..write('lastOpenedAt: $lastOpenedAt, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    librarySubjectId,
    lastPosition,
    percentComplete,
    lastOpenedAt,
    syncedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReadingProgressData &&
          other.id == this.id &&
          other.librarySubjectId == this.librarySubjectId &&
          other.lastPosition == this.lastPosition &&
          other.percentComplete == this.percentComplete &&
          other.lastOpenedAt == this.lastOpenedAt &&
          other.syncedAt == this.syncedAt);
}

class ReadingProgressCompanion extends UpdateCompanion<ReadingProgressData> {
  final Value<String> id;
  final Value<int> librarySubjectId;
  final Value<String?> lastPosition;
  final Value<int> percentComplete;
  final Value<String> lastOpenedAt;
  final Value<String?> syncedAt;
  final Value<int> rowid;
  const ReadingProgressCompanion({
    this.id = const Value.absent(),
    this.librarySubjectId = const Value.absent(),
    this.lastPosition = const Value.absent(),
    this.percentComplete = const Value.absent(),
    this.lastOpenedAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReadingProgressCompanion.insert({
    required String id,
    required int librarySubjectId,
    this.lastPosition = const Value.absent(),
    required int percentComplete,
    required String lastOpenedAt,
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       librarySubjectId = Value(librarySubjectId),
       percentComplete = Value(percentComplete),
       lastOpenedAt = Value(lastOpenedAt);
  static Insertable<ReadingProgressData> custom({
    Expression<String>? id,
    Expression<int>? librarySubjectId,
    Expression<String>? lastPosition,
    Expression<int>? percentComplete,
    Expression<String>? lastOpenedAt,
    Expression<String>? syncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (librarySubjectId != null) 'library_subject_id': librarySubjectId,
      if (lastPosition != null) 'last_position': lastPosition,
      if (percentComplete != null) 'percent_complete': percentComplete,
      if (lastOpenedAt != null) 'last_opened_at': lastOpenedAt,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReadingProgressCompanion copyWith({
    Value<String>? id,
    Value<int>? librarySubjectId,
    Value<String?>? lastPosition,
    Value<int>? percentComplete,
    Value<String>? lastOpenedAt,
    Value<String?>? syncedAt,
    Value<int>? rowid,
  }) {
    return ReadingProgressCompanion(
      id: id ?? this.id,
      librarySubjectId: librarySubjectId ?? this.librarySubjectId,
      lastPosition: lastPosition ?? this.lastPosition,
      percentComplete: percentComplete ?? this.percentComplete,
      lastOpenedAt: lastOpenedAt ?? this.lastOpenedAt,
      syncedAt: syncedAt ?? this.syncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (librarySubjectId.present) {
      map['library_subject_id'] = Variable<int>(librarySubjectId.value);
    }
    if (lastPosition.present) {
      map['last_position'] = Variable<String>(lastPosition.value);
    }
    if (percentComplete.present) {
      map['percent_complete'] = Variable<int>(percentComplete.value);
    }
    if (lastOpenedAt.present) {
      map['last_opened_at'] = Variable<String>(lastOpenedAt.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<String>(syncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReadingProgressCompanion(')
          ..write('id: $id, ')
          ..write('librarySubjectId: $librarySubjectId, ')
          ..write('lastPosition: $lastPosition, ')
          ..write('percentComplete: $percentComplete, ')
          ..write('lastOpenedAt: $lastOpenedAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalStatsTable extends LocalStats
    with TableInfo<$LocalStatsTable, LocalStat> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalStatsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _totalPointsMeta = const VerificationMeta(
    'totalPoints',
  );
  @override
  late final GeneratedColumn<int> totalPoints = GeneratedColumn<int>(
    'total_points',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _currentStreakDaysMeta = const VerificationMeta(
    'currentStreakDays',
  );
  @override
  late final GeneratedColumn<int> currentStreakDays = GeneratedColumn<int>(
    'current_streak_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _longestStreakDaysMeta = const VerificationMeta(
    'longestStreakDays',
  );
  @override
  late final GeneratedColumn<int> longestStreakDays = GeneratedColumn<int>(
    'longest_streak_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastActiveDateMeta = const VerificationMeta(
    'lastActiveDate',
  );
  @override
  late final GeneratedColumn<String> lastActiveDate = GeneratedColumn<String>(
    'last_active_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    totalPoints,
    currentStreakDays,
    longestStreakDays,
    lastActiveDate,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_stats';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalStat> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('total_points')) {
      context.handle(
        _totalPointsMeta,
        totalPoints.isAcceptableOrUnknown(
          data['total_points']!,
          _totalPointsMeta,
        ),
      );
    }
    if (data.containsKey('current_streak_days')) {
      context.handle(
        _currentStreakDaysMeta,
        currentStreakDays.isAcceptableOrUnknown(
          data['current_streak_days']!,
          _currentStreakDaysMeta,
        ),
      );
    }
    if (data.containsKey('longest_streak_days')) {
      context.handle(
        _longestStreakDaysMeta,
        longestStreakDays.isAcceptableOrUnknown(
          data['longest_streak_days']!,
          _longestStreakDaysMeta,
        ),
      );
    }
    if (data.containsKey('last_active_date')) {
      context.handle(
        _lastActiveDateMeta,
        lastActiveDate.isAcceptableOrUnknown(
          data['last_active_date']!,
          _lastActiveDateMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalStat map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalStat(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      totalPoints: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_points'],
      )!,
      currentStreakDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_streak_days'],
      )!,
      longestStreakDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}longest_streak_days'],
      )!,
      lastActiveDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_active_date'],
      ),
    );
  }

  @override
  $LocalStatsTable createAlias(String alias) {
    return $LocalStatsTable(attachedDatabase, alias);
  }
}

class LocalStat extends DataClass implements Insertable<LocalStat> {
  final int id;
  final int totalPoints;
  final int currentStreakDays;
  final int longestStreakDays;
  final String? lastActiveDate;
  const LocalStat({
    required this.id,
    required this.totalPoints,
    required this.currentStreakDays,
    required this.longestStreakDays,
    this.lastActiveDate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['total_points'] = Variable<int>(totalPoints);
    map['current_streak_days'] = Variable<int>(currentStreakDays);
    map['longest_streak_days'] = Variable<int>(longestStreakDays);
    if (!nullToAbsent || lastActiveDate != null) {
      map['last_active_date'] = Variable<String>(lastActiveDate);
    }
    return map;
  }

  LocalStatsCompanion toCompanion(bool nullToAbsent) {
    return LocalStatsCompanion(
      id: Value(id),
      totalPoints: Value(totalPoints),
      currentStreakDays: Value(currentStreakDays),
      longestStreakDays: Value(longestStreakDays),
      lastActiveDate: lastActiveDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastActiveDate),
    );
  }

  factory LocalStat.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalStat(
      id: serializer.fromJson<int>(json['id']),
      totalPoints: serializer.fromJson<int>(json['totalPoints']),
      currentStreakDays: serializer.fromJson<int>(json['currentStreakDays']),
      longestStreakDays: serializer.fromJson<int>(json['longestStreakDays']),
      lastActiveDate: serializer.fromJson<String?>(json['lastActiveDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'totalPoints': serializer.toJson<int>(totalPoints),
      'currentStreakDays': serializer.toJson<int>(currentStreakDays),
      'longestStreakDays': serializer.toJson<int>(longestStreakDays),
      'lastActiveDate': serializer.toJson<String?>(lastActiveDate),
    };
  }

  LocalStat copyWith({
    int? id,
    int? totalPoints,
    int? currentStreakDays,
    int? longestStreakDays,
    Value<String?> lastActiveDate = const Value.absent(),
  }) => LocalStat(
    id: id ?? this.id,
    totalPoints: totalPoints ?? this.totalPoints,
    currentStreakDays: currentStreakDays ?? this.currentStreakDays,
    longestStreakDays: longestStreakDays ?? this.longestStreakDays,
    lastActiveDate: lastActiveDate.present
        ? lastActiveDate.value
        : this.lastActiveDate,
  );
  LocalStat copyWithCompanion(LocalStatsCompanion data) {
    return LocalStat(
      id: data.id.present ? data.id.value : this.id,
      totalPoints: data.totalPoints.present
          ? data.totalPoints.value
          : this.totalPoints,
      currentStreakDays: data.currentStreakDays.present
          ? data.currentStreakDays.value
          : this.currentStreakDays,
      longestStreakDays: data.longestStreakDays.present
          ? data.longestStreakDays.value
          : this.longestStreakDays,
      lastActiveDate: data.lastActiveDate.present
          ? data.lastActiveDate.value
          : this.lastActiveDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalStat(')
          ..write('id: $id, ')
          ..write('totalPoints: $totalPoints, ')
          ..write('currentStreakDays: $currentStreakDays, ')
          ..write('longestStreakDays: $longestStreakDays, ')
          ..write('lastActiveDate: $lastActiveDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    totalPoints,
    currentStreakDays,
    longestStreakDays,
    lastActiveDate,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalStat &&
          other.id == this.id &&
          other.totalPoints == this.totalPoints &&
          other.currentStreakDays == this.currentStreakDays &&
          other.longestStreakDays == this.longestStreakDays &&
          other.lastActiveDate == this.lastActiveDate);
}

class LocalStatsCompanion extends UpdateCompanion<LocalStat> {
  final Value<int> id;
  final Value<int> totalPoints;
  final Value<int> currentStreakDays;
  final Value<int> longestStreakDays;
  final Value<String?> lastActiveDate;
  const LocalStatsCompanion({
    this.id = const Value.absent(),
    this.totalPoints = const Value.absent(),
    this.currentStreakDays = const Value.absent(),
    this.longestStreakDays = const Value.absent(),
    this.lastActiveDate = const Value.absent(),
  });
  LocalStatsCompanion.insert({
    this.id = const Value.absent(),
    this.totalPoints = const Value.absent(),
    this.currentStreakDays = const Value.absent(),
    this.longestStreakDays = const Value.absent(),
    this.lastActiveDate = const Value.absent(),
  });
  static Insertable<LocalStat> custom({
    Expression<int>? id,
    Expression<int>? totalPoints,
    Expression<int>? currentStreakDays,
    Expression<int>? longestStreakDays,
    Expression<String>? lastActiveDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (totalPoints != null) 'total_points': totalPoints,
      if (currentStreakDays != null) 'current_streak_days': currentStreakDays,
      if (longestStreakDays != null) 'longest_streak_days': longestStreakDays,
      if (lastActiveDate != null) 'last_active_date': lastActiveDate,
    });
  }

  LocalStatsCompanion copyWith({
    Value<int>? id,
    Value<int>? totalPoints,
    Value<int>? currentStreakDays,
    Value<int>? longestStreakDays,
    Value<String?>? lastActiveDate,
  }) {
    return LocalStatsCompanion(
      id: id ?? this.id,
      totalPoints: totalPoints ?? this.totalPoints,
      currentStreakDays: currentStreakDays ?? this.currentStreakDays,
      longestStreakDays: longestStreakDays ?? this.longestStreakDays,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (totalPoints.present) {
      map['total_points'] = Variable<int>(totalPoints.value);
    }
    if (currentStreakDays.present) {
      map['current_streak_days'] = Variable<int>(currentStreakDays.value);
    }
    if (longestStreakDays.present) {
      map['longest_streak_days'] = Variable<int>(longestStreakDays.value);
    }
    if (lastActiveDate.present) {
      map['last_active_date'] = Variable<String>(lastActiveDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalStatsCompanion(')
          ..write('id: $id, ')
          ..write('totalPoints: $totalPoints, ')
          ..write('currentStreakDays: $currentStreakDays, ')
          ..write('longestStreakDays: $longestStreakDays, ')
          ..write('lastActiveDate: $lastActiveDate')
          ..write(')'))
        .toString();
  }
}

class $SyncOutboxTable extends SyncOutbox
    with TableInfo<$SyncOutboxTable, SyncOutboxData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncOutboxTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _attemptCountMeta = const VerificationMeta(
    'attemptCount',
  );
  @override
  late final GeneratedColumn<int> attemptCount = GeneratedColumn<int>(
    'attempt_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastAttemptedAtMeta = const VerificationMeta(
    'lastAttemptedAt',
  );
  @override
  late final GeneratedColumn<String> lastAttemptedAt = GeneratedColumn<String>(
    'last_attempted_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    entityType,
    entityId,
    payloadJson,
    createdAt,
    attemptCount,
    lastAttemptedAt,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_outbox';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncOutboxData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('attempt_count')) {
      context.handle(
        _attemptCountMeta,
        attemptCount.isAcceptableOrUnknown(
          data['attempt_count']!,
          _attemptCountMeta,
        ),
      );
    }
    if (data.containsKey('last_attempted_at')) {
      context.handle(
        _lastAttemptedAtMeta,
        lastAttemptedAt.isAcceptableOrUnknown(
          data['last_attempted_at']!,
          _lastAttemptedAtMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncOutboxData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncOutboxData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      attemptCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempt_count'],
      )!,
      lastAttemptedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_attempted_at'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
    );
  }

  @override
  $SyncOutboxTable createAlias(String alias) {
    return $SyncOutboxTable(attachedDatabase, alias);
  }
}

class SyncOutboxData extends DataClass implements Insertable<SyncOutboxData> {
  final String id;
  final String entityType;
  final String entityId;
  final String payloadJson;
  final String createdAt;
  final int attemptCount;
  final String? lastAttemptedAt;
  final String status;
  const SyncOutboxData({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.payloadJson,
    required this.createdAt,
    required this.attemptCount,
    this.lastAttemptedAt,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    map['payload_json'] = Variable<String>(payloadJson);
    map['created_at'] = Variable<String>(createdAt);
    map['attempt_count'] = Variable<int>(attemptCount);
    if (!nullToAbsent || lastAttemptedAt != null) {
      map['last_attempted_at'] = Variable<String>(lastAttemptedAt);
    }
    map['status'] = Variable<String>(status);
    return map;
  }

  SyncOutboxCompanion toCompanion(bool nullToAbsent) {
    return SyncOutboxCompanion(
      id: Value(id),
      entityType: Value(entityType),
      entityId: Value(entityId),
      payloadJson: Value(payloadJson),
      createdAt: Value(createdAt),
      attemptCount: Value(attemptCount),
      lastAttemptedAt: lastAttemptedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastAttemptedAt),
      status: Value(status),
    );
  }

  factory SyncOutboxData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncOutboxData(
      id: serializer.fromJson<String>(json['id']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      attemptCount: serializer.fromJson<int>(json['attemptCount']),
      lastAttemptedAt: serializer.fromJson<String?>(json['lastAttemptedAt']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'createdAt': serializer.toJson<String>(createdAt),
      'attemptCount': serializer.toJson<int>(attemptCount),
      'lastAttemptedAt': serializer.toJson<String?>(lastAttemptedAt),
      'status': serializer.toJson<String>(status),
    };
  }

  SyncOutboxData copyWith({
    String? id,
    String? entityType,
    String? entityId,
    String? payloadJson,
    String? createdAt,
    int? attemptCount,
    Value<String?> lastAttemptedAt = const Value.absent(),
    String? status,
  }) => SyncOutboxData(
    id: id ?? this.id,
    entityType: entityType ?? this.entityType,
    entityId: entityId ?? this.entityId,
    payloadJson: payloadJson ?? this.payloadJson,
    createdAt: createdAt ?? this.createdAt,
    attemptCount: attemptCount ?? this.attemptCount,
    lastAttemptedAt: lastAttemptedAt.present
        ? lastAttemptedAt.value
        : this.lastAttemptedAt,
    status: status ?? this.status,
  );
  SyncOutboxData copyWithCompanion(SyncOutboxCompanion data) {
    return SyncOutboxData(
      id: data.id.present ? data.id.value : this.id,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      attemptCount: data.attemptCount.present
          ? data.attemptCount.value
          : this.attemptCount,
      lastAttemptedAt: data.lastAttemptedAt.present
          ? data.lastAttemptedAt.value
          : this.lastAttemptedAt,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncOutboxData(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('attemptCount: $attemptCount, ')
          ..write('lastAttemptedAt: $lastAttemptedAt, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    entityType,
    entityId,
    payloadJson,
    createdAt,
    attemptCount,
    lastAttemptedAt,
    status,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncOutboxData &&
          other.id == this.id &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.payloadJson == this.payloadJson &&
          other.createdAt == this.createdAt &&
          other.attemptCount == this.attemptCount &&
          other.lastAttemptedAt == this.lastAttemptedAt &&
          other.status == this.status);
}

class SyncOutboxCompanion extends UpdateCompanion<SyncOutboxData> {
  final Value<String> id;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String> payloadJson;
  final Value<String> createdAt;
  final Value<int> attemptCount;
  final Value<String?> lastAttemptedAt;
  final Value<String> status;
  final Value<int> rowid;
  const SyncOutboxCompanion({
    this.id = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.attemptCount = const Value.absent(),
    this.lastAttemptedAt = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncOutboxCompanion.insert({
    required String id,
    required String entityType,
    required String entityId,
    required String payloadJson,
    required String createdAt,
    this.attemptCount = const Value.absent(),
    this.lastAttemptedAt = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       entityType = Value(entityType),
       entityId = Value(entityId),
       payloadJson = Value(payloadJson),
       createdAt = Value(createdAt);
  static Insertable<SyncOutboxData> custom({
    Expression<String>? id,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? payloadJson,
    Expression<String>? createdAt,
    Expression<int>? attemptCount,
    Expression<String>? lastAttemptedAt,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (createdAt != null) 'created_at': createdAt,
      if (attemptCount != null) 'attempt_count': attemptCount,
      if (lastAttemptedAt != null) 'last_attempted_at': lastAttemptedAt,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncOutboxCompanion copyWith({
    Value<String>? id,
    Value<String>? entityType,
    Value<String>? entityId,
    Value<String>? payloadJson,
    Value<String>? createdAt,
    Value<int>? attemptCount,
    Value<String?>? lastAttemptedAt,
    Value<String>? status,
    Value<int>? rowid,
  }) {
    return SyncOutboxCompanion(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      payloadJson: payloadJson ?? this.payloadJson,
      createdAt: createdAt ?? this.createdAt,
      attemptCount: attemptCount ?? this.attemptCount,
      lastAttemptedAt: lastAttemptedAt ?? this.lastAttemptedAt,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (attemptCount.present) {
      map['attempt_count'] = Variable<int>(attemptCount.value);
    }
    if (lastAttemptedAt.present) {
      map['last_attempted_at'] = Variable<String>(lastAttemptedAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncOutboxCompanion(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('attemptCount: $attemptCount, ')
          ..write('lastAttemptedAt: $lastAttemptedAt, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AiConversationsCacheTable extends AiConversationsCache
    with TableInfo<$AiConversationsCacheTable, AiConversationsCacheData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AiConversationsCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
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
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastMessageMeta = const VerificationMeta(
    'lastMessage',
  );
  @override
  late final GeneratedColumn<String> lastMessage = GeneratedColumn<String>(
    'last_message',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cachedAtMeta = const VerificationMeta(
    'cachedAt',
  );
  @override
  late final GeneratedColumn<String> cachedAt = GeneratedColumn<String>(
    'cached_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    updatedAt,
    lastMessage,
    cachedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ai_conversations_cache';
  @override
  VerificationContext validateIntegrity(
    Insertable<AiConversationsCacheData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('last_message')) {
      context.handle(
        _lastMessageMeta,
        lastMessage.isAcceptableOrUnknown(
          data['last_message']!,
          _lastMessageMeta,
        ),
      );
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_cachedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AiConversationsCacheData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AiConversationsCacheData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
      lastMessage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_message'],
      ),
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $AiConversationsCacheTable createAlias(String alias) {
    return $AiConversationsCacheTable(attachedDatabase, alias);
  }
}

class AiConversationsCacheData extends DataClass
    implements Insertable<AiConversationsCacheData> {
  final String id;
  final String title;
  final String updatedAt;
  final String? lastMessage;
  final String cachedAt;
  const AiConversationsCacheData({
    required this.id,
    required this.title,
    required this.updatedAt,
    this.lastMessage,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['updated_at'] = Variable<String>(updatedAt);
    if (!nullToAbsent || lastMessage != null) {
      map['last_message'] = Variable<String>(lastMessage);
    }
    map['cached_at'] = Variable<String>(cachedAt);
    return map;
  }

  AiConversationsCacheCompanion toCompanion(bool nullToAbsent) {
    return AiConversationsCacheCompanion(
      id: Value(id),
      title: Value(title),
      updatedAt: Value(updatedAt),
      lastMessage: lastMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(lastMessage),
      cachedAt: Value(cachedAt),
    );
  }

  factory AiConversationsCacheData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AiConversationsCacheData(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
      lastMessage: serializer.fromJson<String?>(json['lastMessage']),
      cachedAt: serializer.fromJson<String>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'lastMessage': serializer.toJson<String?>(lastMessage),
      'cachedAt': serializer.toJson<String>(cachedAt),
    };
  }

  AiConversationsCacheData copyWith({
    String? id,
    String? title,
    String? updatedAt,
    Value<String?> lastMessage = const Value.absent(),
    String? cachedAt,
  }) => AiConversationsCacheData(
    id: id ?? this.id,
    title: title ?? this.title,
    updatedAt: updatedAt ?? this.updatedAt,
    lastMessage: lastMessage.present ? lastMessage.value : this.lastMessage,
    cachedAt: cachedAt ?? this.cachedAt,
  );
  AiConversationsCacheData copyWithCompanion(
    AiConversationsCacheCompanion data,
  ) {
    return AiConversationsCacheData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      lastMessage: data.lastMessage.present
          ? data.lastMessage.value
          : this.lastMessage,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AiConversationsCacheData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastMessage: $lastMessage, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, updatedAt, lastMessage, cachedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AiConversationsCacheData &&
          other.id == this.id &&
          other.title == this.title &&
          other.updatedAt == this.updatedAt &&
          other.lastMessage == this.lastMessage &&
          other.cachedAt == this.cachedAt);
}

class AiConversationsCacheCompanion
    extends UpdateCompanion<AiConversationsCacheData> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> updatedAt;
  final Value<String?> lastMessage;
  final Value<String> cachedAt;
  final Value<int> rowid;
  const AiConversationsCacheCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.lastMessage = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AiConversationsCacheCompanion.insert({
    required String id,
    required String title,
    required String updatedAt,
    this.lastMessage = const Value.absent(),
    required String cachedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       updatedAt = Value(updatedAt),
       cachedAt = Value(cachedAt);
  static Insertable<AiConversationsCacheData> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? updatedAt,
    Expression<String>? lastMessage,
    Expression<String>? cachedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (lastMessage != null) 'last_message': lastMessage,
      if (cachedAt != null) 'cached_at': cachedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AiConversationsCacheCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? updatedAt,
    Value<String?>? lastMessage,
    Value<String>? cachedAt,
    Value<int>? rowid,
  }) {
    return AiConversationsCacheCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      updatedAt: updatedAt ?? this.updatedAt,
      lastMessage: lastMessage ?? this.lastMessage,
      cachedAt: cachedAt ?? this.cachedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (lastMessage.present) {
      map['last_message'] = Variable<String>(lastMessage.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<String>(cachedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AiConversationsCacheCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastMessage: $lastMessage, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AiMessagesCacheTable extends AiMessagesCache
    with TableInfo<$AiMessagesCacheTable, AiMessagesCacheData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AiMessagesCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _conversationIdMeta = const VerificationMeta(
    'conversationId',
  );
  @override
  late final GeneratedColumn<String> conversationId = GeneratedColumn<String>(
    'conversation_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isAiMeta = const VerificationMeta('isAi');
  @override
  late final GeneratedColumn<bool> isAi = GeneratedColumn<bool>(
    'is_ai',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_ai" IN (0, 1))',
    ),
  );
  static const VerificationMeta _senderMeta = const VerificationMeta('sender');
  @override
  late final GeneratedColumn<String> sender = GeneratedColumn<String>(
    'sender',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cachedAtMeta = const VerificationMeta(
    'cachedAt',
  );
  @override
  late final GeneratedColumn<String> cachedAt = GeneratedColumn<String>(
    'cached_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    conversationId,
    content,
    isAi,
    sender,
    createdAt,
    cachedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ai_messages_cache';
  @override
  VerificationContext validateIntegrity(
    Insertable<AiMessagesCacheData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('conversation_id')) {
      context.handle(
        _conversationIdMeta,
        conversationId.isAcceptableOrUnknown(
          data['conversation_id']!,
          _conversationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_conversationIdMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('is_ai')) {
      context.handle(
        _isAiMeta,
        isAi.isAcceptableOrUnknown(data['is_ai']!, _isAiMeta),
      );
    } else if (isInserting) {
      context.missing(_isAiMeta);
    }
    if (data.containsKey('sender')) {
      context.handle(
        _senderMeta,
        sender.isAcceptableOrUnknown(data['sender']!, _senderMeta),
      );
    } else if (isInserting) {
      context.missing(_senderMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_cachedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AiMessagesCacheData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AiMessagesCacheData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      conversationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}conversation_id'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      isAi: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_ai'],
      )!,
      sender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sender'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $AiMessagesCacheTable createAlias(String alias) {
    return $AiMessagesCacheTable(attachedDatabase, alias);
  }
}

class AiMessagesCacheData extends DataClass
    implements Insertable<AiMessagesCacheData> {
  final String id;
  final String conversationId;
  final String content;
  final bool isAi;
  final String sender;
  final String createdAt;
  final String cachedAt;
  const AiMessagesCacheData({
    required this.id,
    required this.conversationId,
    required this.content,
    required this.isAi,
    required this.sender,
    required this.createdAt,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['conversation_id'] = Variable<String>(conversationId);
    map['content'] = Variable<String>(content);
    map['is_ai'] = Variable<bool>(isAi);
    map['sender'] = Variable<String>(sender);
    map['created_at'] = Variable<String>(createdAt);
    map['cached_at'] = Variable<String>(cachedAt);
    return map;
  }

  AiMessagesCacheCompanion toCompanion(bool nullToAbsent) {
    return AiMessagesCacheCompanion(
      id: Value(id),
      conversationId: Value(conversationId),
      content: Value(content),
      isAi: Value(isAi),
      sender: Value(sender),
      createdAt: Value(createdAt),
      cachedAt: Value(cachedAt),
    );
  }

  factory AiMessagesCacheData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AiMessagesCacheData(
      id: serializer.fromJson<String>(json['id']),
      conversationId: serializer.fromJson<String>(json['conversationId']),
      content: serializer.fromJson<String>(json['content']),
      isAi: serializer.fromJson<bool>(json['isAi']),
      sender: serializer.fromJson<String>(json['sender']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      cachedAt: serializer.fromJson<String>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'conversationId': serializer.toJson<String>(conversationId),
      'content': serializer.toJson<String>(content),
      'isAi': serializer.toJson<bool>(isAi),
      'sender': serializer.toJson<String>(sender),
      'createdAt': serializer.toJson<String>(createdAt),
      'cachedAt': serializer.toJson<String>(cachedAt),
    };
  }

  AiMessagesCacheData copyWith({
    String? id,
    String? conversationId,
    String? content,
    bool? isAi,
    String? sender,
    String? createdAt,
    String? cachedAt,
  }) => AiMessagesCacheData(
    id: id ?? this.id,
    conversationId: conversationId ?? this.conversationId,
    content: content ?? this.content,
    isAi: isAi ?? this.isAi,
    sender: sender ?? this.sender,
    createdAt: createdAt ?? this.createdAt,
    cachedAt: cachedAt ?? this.cachedAt,
  );
  AiMessagesCacheData copyWithCompanion(AiMessagesCacheCompanion data) {
    return AiMessagesCacheData(
      id: data.id.present ? data.id.value : this.id,
      conversationId: data.conversationId.present
          ? data.conversationId.value
          : this.conversationId,
      content: data.content.present ? data.content.value : this.content,
      isAi: data.isAi.present ? data.isAi.value : this.isAi,
      sender: data.sender.present ? data.sender.value : this.sender,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AiMessagesCacheData(')
          ..write('id: $id, ')
          ..write('conversationId: $conversationId, ')
          ..write('content: $content, ')
          ..write('isAi: $isAi, ')
          ..write('sender: $sender, ')
          ..write('createdAt: $createdAt, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    conversationId,
    content,
    isAi,
    sender,
    createdAt,
    cachedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AiMessagesCacheData &&
          other.id == this.id &&
          other.conversationId == this.conversationId &&
          other.content == this.content &&
          other.isAi == this.isAi &&
          other.sender == this.sender &&
          other.createdAt == this.createdAt &&
          other.cachedAt == this.cachedAt);
}

class AiMessagesCacheCompanion extends UpdateCompanion<AiMessagesCacheData> {
  final Value<String> id;
  final Value<String> conversationId;
  final Value<String> content;
  final Value<bool> isAi;
  final Value<String> sender;
  final Value<String> createdAt;
  final Value<String> cachedAt;
  final Value<int> rowid;
  const AiMessagesCacheCompanion({
    this.id = const Value.absent(),
    this.conversationId = const Value.absent(),
    this.content = const Value.absent(),
    this.isAi = const Value.absent(),
    this.sender = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AiMessagesCacheCompanion.insert({
    required String id,
    required String conversationId,
    required String content,
    required bool isAi,
    required String sender,
    required String createdAt,
    required String cachedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       conversationId = Value(conversationId),
       content = Value(content),
       isAi = Value(isAi),
       sender = Value(sender),
       createdAt = Value(createdAt),
       cachedAt = Value(cachedAt);
  static Insertable<AiMessagesCacheData> custom({
    Expression<String>? id,
    Expression<String>? conversationId,
    Expression<String>? content,
    Expression<bool>? isAi,
    Expression<String>? sender,
    Expression<String>? createdAt,
    Expression<String>? cachedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (conversationId != null) 'conversation_id': conversationId,
      if (content != null) 'content': content,
      if (isAi != null) 'is_ai': isAi,
      if (sender != null) 'sender': sender,
      if (createdAt != null) 'created_at': createdAt,
      if (cachedAt != null) 'cached_at': cachedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AiMessagesCacheCompanion copyWith({
    Value<String>? id,
    Value<String>? conversationId,
    Value<String>? content,
    Value<bool>? isAi,
    Value<String>? sender,
    Value<String>? createdAt,
    Value<String>? cachedAt,
    Value<int>? rowid,
  }) {
    return AiMessagesCacheCompanion(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      content: content ?? this.content,
      isAi: isAi ?? this.isAi,
      sender: sender ?? this.sender,
      createdAt: createdAt ?? this.createdAt,
      cachedAt: cachedAt ?? this.cachedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (conversationId.present) {
      map['conversation_id'] = Variable<String>(conversationId.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (isAi.present) {
      map['is_ai'] = Variable<bool>(isAi.value);
    }
    if (sender.present) {
      map['sender'] = Variable<String>(sender.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<String>(cachedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AiMessagesCacheCompanion(')
          ..write('id: $id, ')
          ..write('conversationId: $conversationId, ')
          ..write('content: $content, ')
          ..write('isAi: $isAi, ')
          ..write('sender: $sender, ')
          ..write('createdAt: $createdAt, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalNotificationsTable extends LocalNotifications
    with TableInfo<$LocalNotificationsTable, LocalNotification> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalNotificationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
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
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _readAtMeta = const VerificationMeta('readAt');
  @override
  late final GeneratedColumn<String> readAt = GeneratedColumn<String>(
    'read_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    type,
    title,
    body,
    createdAt,
    readAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_notifications';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalNotification> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('read_at')) {
      context.handle(
        _readAtMeta,
        readAt.isAcceptableOrUnknown(data['read_at']!, _readAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalNotification map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalNotification(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      readAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}read_at'],
      ),
    );
  }

  @override
  $LocalNotificationsTable createAlias(String alias) {
    return $LocalNotificationsTable(attachedDatabase, alias);
  }
}

class LocalNotification extends DataClass
    implements Insertable<LocalNotification> {
  final String id;
  final String type;
  final String title;
  final String body;
  final String createdAt;
  final String? readAt;
  const LocalNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.createdAt,
    this.readAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['type'] = Variable<String>(type);
    map['title'] = Variable<String>(title);
    map['body'] = Variable<String>(body);
    map['created_at'] = Variable<String>(createdAt);
    if (!nullToAbsent || readAt != null) {
      map['read_at'] = Variable<String>(readAt);
    }
    return map;
  }

  LocalNotificationsCompanion toCompanion(bool nullToAbsent) {
    return LocalNotificationsCompanion(
      id: Value(id),
      type: Value(type),
      title: Value(title),
      body: Value(body),
      createdAt: Value(createdAt),
      readAt: readAt == null && nullToAbsent
          ? const Value.absent()
          : Value(readAt),
    );
  }

  factory LocalNotification.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalNotification(
      id: serializer.fromJson<String>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      title: serializer.fromJson<String>(json['title']),
      body: serializer.fromJson<String>(json['body']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      readAt: serializer.fromJson<String?>(json['readAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'type': serializer.toJson<String>(type),
      'title': serializer.toJson<String>(title),
      'body': serializer.toJson<String>(body),
      'createdAt': serializer.toJson<String>(createdAt),
      'readAt': serializer.toJson<String?>(readAt),
    };
  }

  LocalNotification copyWith({
    String? id,
    String? type,
    String? title,
    String? body,
    String? createdAt,
    Value<String?> readAt = const Value.absent(),
  }) => LocalNotification(
    id: id ?? this.id,
    type: type ?? this.type,
    title: title ?? this.title,
    body: body ?? this.body,
    createdAt: createdAt ?? this.createdAt,
    readAt: readAt.present ? readAt.value : this.readAt,
  );
  LocalNotification copyWithCompanion(LocalNotificationsCompanion data) {
    return LocalNotification(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      title: data.title.present ? data.title.value : this.title,
      body: data.body.present ? data.body.value : this.body,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      readAt: data.readAt.present ? data.readAt.value : this.readAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalNotification(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('createdAt: $createdAt, ')
          ..write('readAt: $readAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, type, title, body, createdAt, readAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalNotification &&
          other.id == this.id &&
          other.type == this.type &&
          other.title == this.title &&
          other.body == this.body &&
          other.createdAt == this.createdAt &&
          other.readAt == this.readAt);
}

class LocalNotificationsCompanion extends UpdateCompanion<LocalNotification> {
  final Value<String> id;
  final Value<String> type;
  final Value<String> title;
  final Value<String> body;
  final Value<String> createdAt;
  final Value<String?> readAt;
  final Value<int> rowid;
  const LocalNotificationsCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.readAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalNotificationsCompanion.insert({
    required String id,
    required String type,
    required String title,
    required String body,
    required String createdAt,
    this.readAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       type = Value(type),
       title = Value(title),
       body = Value(body),
       createdAt = Value(createdAt);
  static Insertable<LocalNotification> custom({
    Expression<String>? id,
    Expression<String>? type,
    Expression<String>? title,
    Expression<String>? body,
    Expression<String>? createdAt,
    Expression<String>? readAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (createdAt != null) 'created_at': createdAt,
      if (readAt != null) 'read_at': readAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalNotificationsCompanion copyWith({
    Value<String>? id,
    Value<String>? type,
    Value<String>? title,
    Value<String>? body,
    Value<String>? createdAt,
    Value<String?>? readAt,
    Value<int>? rowid,
  }) {
    return LocalNotificationsCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
      readAt: readAt ?? this.readAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (readAt.present) {
      map['read_at'] = Variable<String>(readAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalNotificationsCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('createdAt: $createdAt, ')
          ..write('readAt: $readAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$ProgressDb extends GeneratedDatabase {
  _$ProgressDb(QueryExecutor e) : super(e);
  $ProgressDbManager get managers => $ProgressDbManager(this);
  late final $PracticeAttemptsTable practiceAttempts = $PracticeAttemptsTable(
    this,
  );
  late final $PracticeAnswersTable practiceAnswers = $PracticeAnswersTable(
    this,
  );
  late final $ReadingProgressTable readingProgress = $ReadingProgressTable(
    this,
  );
  late final $LocalStatsTable localStats = $LocalStatsTable(this);
  late final $SyncOutboxTable syncOutbox = $SyncOutboxTable(this);
  late final $AiConversationsCacheTable aiConversationsCache =
      $AiConversationsCacheTable(this);
  late final $AiMessagesCacheTable aiMessagesCache = $AiMessagesCacheTable(
    this,
  );
  late final $LocalNotificationsTable localNotifications =
      $LocalNotificationsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    practiceAttempts,
    practiceAnswers,
    readingProgress,
    localStats,
    syncOutbox,
    aiConversationsCache,
    aiMessagesCache,
    localNotifications,
  ];
}

typedef $$PracticeAttemptsTableCreateCompanionBuilder =
    PracticeAttemptsCompanion Function({
      required String id,
      required String sourceType,
      Value<int?> subjectId,
      Value<int?> librarySubjectId,
      Value<int?> testTypeId,
      required int score,
      required int totalQuestions,
      required int timeSpentSeconds,
      required String startedAt,
      required String completedAt,
      Value<String?> syncedAt,
      Value<String?> subjectName,
      Value<String?> testTypeLabel,
      Value<int> rowid,
    });
typedef $$PracticeAttemptsTableUpdateCompanionBuilder =
    PracticeAttemptsCompanion Function({
      Value<String> id,
      Value<String> sourceType,
      Value<int?> subjectId,
      Value<int?> librarySubjectId,
      Value<int?> testTypeId,
      Value<int> score,
      Value<int> totalQuestions,
      Value<int> timeSpentSeconds,
      Value<String> startedAt,
      Value<String> completedAt,
      Value<String?> syncedAt,
      Value<String?> subjectName,
      Value<String?> testTypeLabel,
      Value<int> rowid,
    });

class $$PracticeAttemptsTableFilterComposer
    extends Composer<_$ProgressDb, $PracticeAttemptsTable> {
  $$PracticeAttemptsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get subjectId => $composableBuilder(
    column: $table.subjectId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get librarySubjectId => $composableBuilder(
    column: $table.librarySubjectId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get testTypeId => $composableBuilder(
    column: $table.testTypeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalQuestions => $composableBuilder(
    column: $table.totalQuestions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timeSpentSeconds => $composableBuilder(
    column: $table.timeSpentSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subjectName => $composableBuilder(
    column: $table.subjectName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get testTypeLabel => $composableBuilder(
    column: $table.testTypeLabel,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PracticeAttemptsTableOrderingComposer
    extends Composer<_$ProgressDb, $PracticeAttemptsTable> {
  $$PracticeAttemptsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get subjectId => $composableBuilder(
    column: $table.subjectId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get librarySubjectId => $composableBuilder(
    column: $table.librarySubjectId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get testTypeId => $composableBuilder(
    column: $table.testTypeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalQuestions => $composableBuilder(
    column: $table.totalQuestions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timeSpentSeconds => $composableBuilder(
    column: $table.timeSpentSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subjectName => $composableBuilder(
    column: $table.subjectName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get testTypeLabel => $composableBuilder(
    column: $table.testTypeLabel,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PracticeAttemptsTableAnnotationComposer
    extends Composer<_$ProgressDb, $PracticeAttemptsTable> {
  $$PracticeAttemptsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get subjectId =>
      $composableBuilder(column: $table.subjectId, builder: (column) => column);

  GeneratedColumn<int> get librarySubjectId => $composableBuilder(
    column: $table.librarySubjectId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get testTypeId => $composableBuilder(
    column: $table.testTypeId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<int> get totalQuestions => $composableBuilder(
    column: $table.totalQuestions,
    builder: (column) => column,
  );

  GeneratedColumn<int> get timeSpentSeconds => $composableBuilder(
    column: $table.timeSpentSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<String> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<String> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);

  GeneratedColumn<String> get subjectName => $composableBuilder(
    column: $table.subjectName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get testTypeLabel => $composableBuilder(
    column: $table.testTypeLabel,
    builder: (column) => column,
  );
}

class $$PracticeAttemptsTableTableManager
    extends
        RootTableManager<
          _$ProgressDb,
          $PracticeAttemptsTable,
          PracticeAttempt,
          $$PracticeAttemptsTableFilterComposer,
          $$PracticeAttemptsTableOrderingComposer,
          $$PracticeAttemptsTableAnnotationComposer,
          $$PracticeAttemptsTableCreateCompanionBuilder,
          $$PracticeAttemptsTableUpdateCompanionBuilder,
          (
            PracticeAttempt,
            BaseReferences<
              _$ProgressDb,
              $PracticeAttemptsTable,
              PracticeAttempt
            >,
          ),
          PracticeAttempt,
          PrefetchHooks Function()
        > {
  $$PracticeAttemptsTableTableManager(
    _$ProgressDb db,
    $PracticeAttemptsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PracticeAttemptsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PracticeAttemptsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PracticeAttemptsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sourceType = const Value.absent(),
                Value<int?> subjectId = const Value.absent(),
                Value<int?> librarySubjectId = const Value.absent(),
                Value<int?> testTypeId = const Value.absent(),
                Value<int> score = const Value.absent(),
                Value<int> totalQuestions = const Value.absent(),
                Value<int> timeSpentSeconds = const Value.absent(),
                Value<String> startedAt = const Value.absent(),
                Value<String> completedAt = const Value.absent(),
                Value<String?> syncedAt = const Value.absent(),
                Value<String?> subjectName = const Value.absent(),
                Value<String?> testTypeLabel = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PracticeAttemptsCompanion(
                id: id,
                sourceType: sourceType,
                subjectId: subjectId,
                librarySubjectId: librarySubjectId,
                testTypeId: testTypeId,
                score: score,
                totalQuestions: totalQuestions,
                timeSpentSeconds: timeSpentSeconds,
                startedAt: startedAt,
                completedAt: completedAt,
                syncedAt: syncedAt,
                subjectName: subjectName,
                testTypeLabel: testTypeLabel,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sourceType,
                Value<int?> subjectId = const Value.absent(),
                Value<int?> librarySubjectId = const Value.absent(),
                Value<int?> testTypeId = const Value.absent(),
                required int score,
                required int totalQuestions,
                required int timeSpentSeconds,
                required String startedAt,
                required String completedAt,
                Value<String?> syncedAt = const Value.absent(),
                Value<String?> subjectName = const Value.absent(),
                Value<String?> testTypeLabel = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PracticeAttemptsCompanion.insert(
                id: id,
                sourceType: sourceType,
                subjectId: subjectId,
                librarySubjectId: librarySubjectId,
                testTypeId: testTypeId,
                score: score,
                totalQuestions: totalQuestions,
                timeSpentSeconds: timeSpentSeconds,
                startedAt: startedAt,
                completedAt: completedAt,
                syncedAt: syncedAt,
                subjectName: subjectName,
                testTypeLabel: testTypeLabel,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PracticeAttemptsTableProcessedTableManager =
    ProcessedTableManager<
      _$ProgressDb,
      $PracticeAttemptsTable,
      PracticeAttempt,
      $$PracticeAttemptsTableFilterComposer,
      $$PracticeAttemptsTableOrderingComposer,
      $$PracticeAttemptsTableAnnotationComposer,
      $$PracticeAttemptsTableCreateCompanionBuilder,
      $$PracticeAttemptsTableUpdateCompanionBuilder,
      (
        PracticeAttempt,
        BaseReferences<_$ProgressDb, $PracticeAttemptsTable, PracticeAttempt>,
      ),
      PracticeAttempt,
      PrefetchHooks Function()
    >;
typedef $$PracticeAnswersTableCreateCompanionBuilder =
    PracticeAnswersCompanion Function({
      required String id,
      required String attemptId,
      required int questionId,
      required String questionSource,
      Value<String?> selectedOption,
      required bool isCorrect,
      required int timeSpentSeconds,
      Value<int> rowid,
    });
typedef $$PracticeAnswersTableUpdateCompanionBuilder =
    PracticeAnswersCompanion Function({
      Value<String> id,
      Value<String> attemptId,
      Value<int> questionId,
      Value<String> questionSource,
      Value<String?> selectedOption,
      Value<bool> isCorrect,
      Value<int> timeSpentSeconds,
      Value<int> rowid,
    });

class $$PracticeAnswersTableFilterComposer
    extends Composer<_$ProgressDb, $PracticeAnswersTable> {
  $$PracticeAnswersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get attemptId => $composableBuilder(
    column: $table.attemptId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get questionId => $composableBuilder(
    column: $table.questionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get questionSource => $composableBuilder(
    column: $table.questionSource,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get selectedOption => $composableBuilder(
    column: $table.selectedOption,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCorrect => $composableBuilder(
    column: $table.isCorrect,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timeSpentSeconds => $composableBuilder(
    column: $table.timeSpentSeconds,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PracticeAnswersTableOrderingComposer
    extends Composer<_$ProgressDb, $PracticeAnswersTable> {
  $$PracticeAnswersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get attemptId => $composableBuilder(
    column: $table.attemptId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get questionId => $composableBuilder(
    column: $table.questionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get questionSource => $composableBuilder(
    column: $table.questionSource,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get selectedOption => $composableBuilder(
    column: $table.selectedOption,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCorrect => $composableBuilder(
    column: $table.isCorrect,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timeSpentSeconds => $composableBuilder(
    column: $table.timeSpentSeconds,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PracticeAnswersTableAnnotationComposer
    extends Composer<_$ProgressDb, $PracticeAnswersTable> {
  $$PracticeAnswersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get attemptId =>
      $composableBuilder(column: $table.attemptId, builder: (column) => column);

  GeneratedColumn<int> get questionId => $composableBuilder(
    column: $table.questionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get questionSource => $composableBuilder(
    column: $table.questionSource,
    builder: (column) => column,
  );

  GeneratedColumn<String> get selectedOption => $composableBuilder(
    column: $table.selectedOption,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCorrect =>
      $composableBuilder(column: $table.isCorrect, builder: (column) => column);

  GeneratedColumn<int> get timeSpentSeconds => $composableBuilder(
    column: $table.timeSpentSeconds,
    builder: (column) => column,
  );
}

class $$PracticeAnswersTableTableManager
    extends
        RootTableManager<
          _$ProgressDb,
          $PracticeAnswersTable,
          PracticeAnswer,
          $$PracticeAnswersTableFilterComposer,
          $$PracticeAnswersTableOrderingComposer,
          $$PracticeAnswersTableAnnotationComposer,
          $$PracticeAnswersTableCreateCompanionBuilder,
          $$PracticeAnswersTableUpdateCompanionBuilder,
          (
            PracticeAnswer,
            BaseReferences<_$ProgressDb, $PracticeAnswersTable, PracticeAnswer>,
          ),
          PracticeAnswer,
          PrefetchHooks Function()
        > {
  $$PracticeAnswersTableTableManager(
    _$ProgressDb db,
    $PracticeAnswersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PracticeAnswersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PracticeAnswersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PracticeAnswersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> attemptId = const Value.absent(),
                Value<int> questionId = const Value.absent(),
                Value<String> questionSource = const Value.absent(),
                Value<String?> selectedOption = const Value.absent(),
                Value<bool> isCorrect = const Value.absent(),
                Value<int> timeSpentSeconds = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PracticeAnswersCompanion(
                id: id,
                attemptId: attemptId,
                questionId: questionId,
                questionSource: questionSource,
                selectedOption: selectedOption,
                isCorrect: isCorrect,
                timeSpentSeconds: timeSpentSeconds,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String attemptId,
                required int questionId,
                required String questionSource,
                Value<String?> selectedOption = const Value.absent(),
                required bool isCorrect,
                required int timeSpentSeconds,
                Value<int> rowid = const Value.absent(),
              }) => PracticeAnswersCompanion.insert(
                id: id,
                attemptId: attemptId,
                questionId: questionId,
                questionSource: questionSource,
                selectedOption: selectedOption,
                isCorrect: isCorrect,
                timeSpentSeconds: timeSpentSeconds,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PracticeAnswersTableProcessedTableManager =
    ProcessedTableManager<
      _$ProgressDb,
      $PracticeAnswersTable,
      PracticeAnswer,
      $$PracticeAnswersTableFilterComposer,
      $$PracticeAnswersTableOrderingComposer,
      $$PracticeAnswersTableAnnotationComposer,
      $$PracticeAnswersTableCreateCompanionBuilder,
      $$PracticeAnswersTableUpdateCompanionBuilder,
      (
        PracticeAnswer,
        BaseReferences<_$ProgressDb, $PracticeAnswersTable, PracticeAnswer>,
      ),
      PracticeAnswer,
      PrefetchHooks Function()
    >;
typedef $$ReadingProgressTableCreateCompanionBuilder =
    ReadingProgressCompanion Function({
      required String id,
      required int librarySubjectId,
      Value<String?> lastPosition,
      required int percentComplete,
      required String lastOpenedAt,
      Value<String?> syncedAt,
      Value<int> rowid,
    });
typedef $$ReadingProgressTableUpdateCompanionBuilder =
    ReadingProgressCompanion Function({
      Value<String> id,
      Value<int> librarySubjectId,
      Value<String?> lastPosition,
      Value<int> percentComplete,
      Value<String> lastOpenedAt,
      Value<String?> syncedAt,
      Value<int> rowid,
    });

class $$ReadingProgressTableFilterComposer
    extends Composer<_$ProgressDb, $ReadingProgressTable> {
  $$ReadingProgressTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get librarySubjectId => $composableBuilder(
    column: $table.librarySubjectId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastPosition => $composableBuilder(
    column: $table.lastPosition,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get percentComplete => $composableBuilder(
    column: $table.percentComplete,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastOpenedAt => $composableBuilder(
    column: $table.lastOpenedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ReadingProgressTableOrderingComposer
    extends Composer<_$ProgressDb, $ReadingProgressTable> {
  $$ReadingProgressTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get librarySubjectId => $composableBuilder(
    column: $table.librarySubjectId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastPosition => $composableBuilder(
    column: $table.lastPosition,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get percentComplete => $composableBuilder(
    column: $table.percentComplete,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastOpenedAt => $composableBuilder(
    column: $table.lastOpenedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ReadingProgressTableAnnotationComposer
    extends Composer<_$ProgressDb, $ReadingProgressTable> {
  $$ReadingProgressTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get librarySubjectId => $composableBuilder(
    column: $table.librarySubjectId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastPosition => $composableBuilder(
    column: $table.lastPosition,
    builder: (column) => column,
  );

  GeneratedColumn<int> get percentComplete => $composableBuilder(
    column: $table.percentComplete,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastOpenedAt => $composableBuilder(
    column: $table.lastOpenedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$ReadingProgressTableTableManager
    extends
        RootTableManager<
          _$ProgressDb,
          $ReadingProgressTable,
          ReadingProgressData,
          $$ReadingProgressTableFilterComposer,
          $$ReadingProgressTableOrderingComposer,
          $$ReadingProgressTableAnnotationComposer,
          $$ReadingProgressTableCreateCompanionBuilder,
          $$ReadingProgressTableUpdateCompanionBuilder,
          (
            ReadingProgressData,
            BaseReferences<
              _$ProgressDb,
              $ReadingProgressTable,
              ReadingProgressData
            >,
          ),
          ReadingProgressData,
          PrefetchHooks Function()
        > {
  $$ReadingProgressTableTableManager(
    _$ProgressDb db,
    $ReadingProgressTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReadingProgressTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReadingProgressTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReadingProgressTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> librarySubjectId = const Value.absent(),
                Value<String?> lastPosition = const Value.absent(),
                Value<int> percentComplete = const Value.absent(),
                Value<String> lastOpenedAt = const Value.absent(),
                Value<String?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReadingProgressCompanion(
                id: id,
                librarySubjectId: librarySubjectId,
                lastPosition: lastPosition,
                percentComplete: percentComplete,
                lastOpenedAt: lastOpenedAt,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int librarySubjectId,
                Value<String?> lastPosition = const Value.absent(),
                required int percentComplete,
                required String lastOpenedAt,
                Value<String?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReadingProgressCompanion.insert(
                id: id,
                librarySubjectId: librarySubjectId,
                lastPosition: lastPosition,
                percentComplete: percentComplete,
                lastOpenedAt: lastOpenedAt,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ReadingProgressTableProcessedTableManager =
    ProcessedTableManager<
      _$ProgressDb,
      $ReadingProgressTable,
      ReadingProgressData,
      $$ReadingProgressTableFilterComposer,
      $$ReadingProgressTableOrderingComposer,
      $$ReadingProgressTableAnnotationComposer,
      $$ReadingProgressTableCreateCompanionBuilder,
      $$ReadingProgressTableUpdateCompanionBuilder,
      (
        ReadingProgressData,
        BaseReferences<
          _$ProgressDb,
          $ReadingProgressTable,
          ReadingProgressData
        >,
      ),
      ReadingProgressData,
      PrefetchHooks Function()
    >;
typedef $$LocalStatsTableCreateCompanionBuilder =
    LocalStatsCompanion Function({
      Value<int> id,
      Value<int> totalPoints,
      Value<int> currentStreakDays,
      Value<int> longestStreakDays,
      Value<String?> lastActiveDate,
    });
typedef $$LocalStatsTableUpdateCompanionBuilder =
    LocalStatsCompanion Function({
      Value<int> id,
      Value<int> totalPoints,
      Value<int> currentStreakDays,
      Value<int> longestStreakDays,
      Value<String?> lastActiveDate,
    });

class $$LocalStatsTableFilterComposer
    extends Composer<_$ProgressDb, $LocalStatsTable> {
  $$LocalStatsTableFilterComposer({
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

  ColumnFilters<int> get totalPoints => $composableBuilder(
    column: $table.totalPoints,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentStreakDays => $composableBuilder(
    column: $table.currentStreakDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get longestStreakDays => $composableBuilder(
    column: $table.longestStreakDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastActiveDate => $composableBuilder(
    column: $table.lastActiveDate,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalStatsTableOrderingComposer
    extends Composer<_$ProgressDb, $LocalStatsTable> {
  $$LocalStatsTableOrderingComposer({
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

  ColumnOrderings<int> get totalPoints => $composableBuilder(
    column: $table.totalPoints,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentStreakDays => $composableBuilder(
    column: $table.currentStreakDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get longestStreakDays => $composableBuilder(
    column: $table.longestStreakDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastActiveDate => $composableBuilder(
    column: $table.lastActiveDate,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalStatsTableAnnotationComposer
    extends Composer<_$ProgressDb, $LocalStatsTable> {
  $$LocalStatsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get totalPoints => $composableBuilder(
    column: $table.totalPoints,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentStreakDays => $composableBuilder(
    column: $table.currentStreakDays,
    builder: (column) => column,
  );

  GeneratedColumn<int> get longestStreakDays => $composableBuilder(
    column: $table.longestStreakDays,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastActiveDate => $composableBuilder(
    column: $table.lastActiveDate,
    builder: (column) => column,
  );
}

class $$LocalStatsTableTableManager
    extends
        RootTableManager<
          _$ProgressDb,
          $LocalStatsTable,
          LocalStat,
          $$LocalStatsTableFilterComposer,
          $$LocalStatsTableOrderingComposer,
          $$LocalStatsTableAnnotationComposer,
          $$LocalStatsTableCreateCompanionBuilder,
          $$LocalStatsTableUpdateCompanionBuilder,
          (
            LocalStat,
            BaseReferences<_$ProgressDb, $LocalStatsTable, LocalStat>,
          ),
          LocalStat,
          PrefetchHooks Function()
        > {
  $$LocalStatsTableTableManager(_$ProgressDb db, $LocalStatsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalStatsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalStatsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalStatsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> totalPoints = const Value.absent(),
                Value<int> currentStreakDays = const Value.absent(),
                Value<int> longestStreakDays = const Value.absent(),
                Value<String?> lastActiveDate = const Value.absent(),
              }) => LocalStatsCompanion(
                id: id,
                totalPoints: totalPoints,
                currentStreakDays: currentStreakDays,
                longestStreakDays: longestStreakDays,
                lastActiveDate: lastActiveDate,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> totalPoints = const Value.absent(),
                Value<int> currentStreakDays = const Value.absent(),
                Value<int> longestStreakDays = const Value.absent(),
                Value<String?> lastActiveDate = const Value.absent(),
              }) => LocalStatsCompanion.insert(
                id: id,
                totalPoints: totalPoints,
                currentStreakDays: currentStreakDays,
                longestStreakDays: longestStreakDays,
                lastActiveDate: lastActiveDate,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalStatsTableProcessedTableManager =
    ProcessedTableManager<
      _$ProgressDb,
      $LocalStatsTable,
      LocalStat,
      $$LocalStatsTableFilterComposer,
      $$LocalStatsTableOrderingComposer,
      $$LocalStatsTableAnnotationComposer,
      $$LocalStatsTableCreateCompanionBuilder,
      $$LocalStatsTableUpdateCompanionBuilder,
      (LocalStat, BaseReferences<_$ProgressDb, $LocalStatsTable, LocalStat>),
      LocalStat,
      PrefetchHooks Function()
    >;
typedef $$SyncOutboxTableCreateCompanionBuilder =
    SyncOutboxCompanion Function({
      required String id,
      required String entityType,
      required String entityId,
      required String payloadJson,
      required String createdAt,
      Value<int> attemptCount,
      Value<String?> lastAttemptedAt,
      Value<String> status,
      Value<int> rowid,
    });
typedef $$SyncOutboxTableUpdateCompanionBuilder =
    SyncOutboxCompanion Function({
      Value<String> id,
      Value<String> entityType,
      Value<String> entityId,
      Value<String> payloadJson,
      Value<String> createdAt,
      Value<int> attemptCount,
      Value<String?> lastAttemptedAt,
      Value<String> status,
      Value<int> rowid,
    });

class $$SyncOutboxTableFilterComposer
    extends Composer<_$ProgressDb, $SyncOutboxTable> {
  $$SyncOutboxTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastAttemptedAt => $composableBuilder(
    column: $table.lastAttemptedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncOutboxTableOrderingComposer
    extends Composer<_$ProgressDb, $SyncOutboxTable> {
  $$SyncOutboxTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastAttemptedAt => $composableBuilder(
    column: $table.lastAttemptedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncOutboxTableAnnotationComposer
    extends Composer<_$ProgressDb, $SyncOutboxTable> {
  $$SyncOutboxTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastAttemptedAt => $composableBuilder(
    column: $table.lastAttemptedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$SyncOutboxTableTableManager
    extends
        RootTableManager<
          _$ProgressDb,
          $SyncOutboxTable,
          SyncOutboxData,
          $$SyncOutboxTableFilterComposer,
          $$SyncOutboxTableOrderingComposer,
          $$SyncOutboxTableAnnotationComposer,
          $$SyncOutboxTableCreateCompanionBuilder,
          $$SyncOutboxTableUpdateCompanionBuilder,
          (
            SyncOutboxData,
            BaseReferences<_$ProgressDb, $SyncOutboxTable, SyncOutboxData>,
          ),
          SyncOutboxData,
          PrefetchHooks Function()
        > {
  $$SyncOutboxTableTableManager(_$ProgressDb db, $SyncOutboxTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncOutboxTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncOutboxTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncOutboxTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<int> attemptCount = const Value.absent(),
                Value<String?> lastAttemptedAt = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncOutboxCompanion(
                id: id,
                entityType: entityType,
                entityId: entityId,
                payloadJson: payloadJson,
                createdAt: createdAt,
                attemptCount: attemptCount,
                lastAttemptedAt: lastAttemptedAt,
                status: status,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String entityType,
                required String entityId,
                required String payloadJson,
                required String createdAt,
                Value<int> attemptCount = const Value.absent(),
                Value<String?> lastAttemptedAt = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncOutboxCompanion.insert(
                id: id,
                entityType: entityType,
                entityId: entityId,
                payloadJson: payloadJson,
                createdAt: createdAt,
                attemptCount: attemptCount,
                lastAttemptedAt: lastAttemptedAt,
                status: status,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncOutboxTableProcessedTableManager =
    ProcessedTableManager<
      _$ProgressDb,
      $SyncOutboxTable,
      SyncOutboxData,
      $$SyncOutboxTableFilterComposer,
      $$SyncOutboxTableOrderingComposer,
      $$SyncOutboxTableAnnotationComposer,
      $$SyncOutboxTableCreateCompanionBuilder,
      $$SyncOutboxTableUpdateCompanionBuilder,
      (
        SyncOutboxData,
        BaseReferences<_$ProgressDb, $SyncOutboxTable, SyncOutboxData>,
      ),
      SyncOutboxData,
      PrefetchHooks Function()
    >;
typedef $$AiConversationsCacheTableCreateCompanionBuilder =
    AiConversationsCacheCompanion Function({
      required String id,
      required String title,
      required String updatedAt,
      Value<String?> lastMessage,
      required String cachedAt,
      Value<int> rowid,
    });
typedef $$AiConversationsCacheTableUpdateCompanionBuilder =
    AiConversationsCacheCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> updatedAt,
      Value<String?> lastMessage,
      Value<String> cachedAt,
      Value<int> rowid,
    });

class $$AiConversationsCacheTableFilterComposer
    extends Composer<_$ProgressDb, $AiConversationsCacheTable> {
  $$AiConversationsCacheTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastMessage => $composableBuilder(
    column: $table.lastMessage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AiConversationsCacheTableOrderingComposer
    extends Composer<_$ProgressDb, $AiConversationsCacheTable> {
  $$AiConversationsCacheTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastMessage => $composableBuilder(
    column: $table.lastMessage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AiConversationsCacheTableAnnotationComposer
    extends Composer<_$ProgressDb, $AiConversationsCacheTable> {
  $$AiConversationsCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get lastMessage => $composableBuilder(
    column: $table.lastMessage,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$AiConversationsCacheTableTableManager
    extends
        RootTableManager<
          _$ProgressDb,
          $AiConversationsCacheTable,
          AiConversationsCacheData,
          $$AiConversationsCacheTableFilterComposer,
          $$AiConversationsCacheTableOrderingComposer,
          $$AiConversationsCacheTableAnnotationComposer,
          $$AiConversationsCacheTableCreateCompanionBuilder,
          $$AiConversationsCacheTableUpdateCompanionBuilder,
          (
            AiConversationsCacheData,
            BaseReferences<
              _$ProgressDb,
              $AiConversationsCacheTable,
              AiConversationsCacheData
            >,
          ),
          AiConversationsCacheData,
          PrefetchHooks Function()
        > {
  $$AiConversationsCacheTableTableManager(
    _$ProgressDb db,
    $AiConversationsCacheTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AiConversationsCacheTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AiConversationsCacheTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$AiConversationsCacheTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<String?> lastMessage = const Value.absent(),
                Value<String> cachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AiConversationsCacheCompanion(
                id: id,
                title: title,
                updatedAt: updatedAt,
                lastMessage: lastMessage,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required String updatedAt,
                Value<String?> lastMessage = const Value.absent(),
                required String cachedAt,
                Value<int> rowid = const Value.absent(),
              }) => AiConversationsCacheCompanion.insert(
                id: id,
                title: title,
                updatedAt: updatedAt,
                lastMessage: lastMessage,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AiConversationsCacheTableProcessedTableManager =
    ProcessedTableManager<
      _$ProgressDb,
      $AiConversationsCacheTable,
      AiConversationsCacheData,
      $$AiConversationsCacheTableFilterComposer,
      $$AiConversationsCacheTableOrderingComposer,
      $$AiConversationsCacheTableAnnotationComposer,
      $$AiConversationsCacheTableCreateCompanionBuilder,
      $$AiConversationsCacheTableUpdateCompanionBuilder,
      (
        AiConversationsCacheData,
        BaseReferences<
          _$ProgressDb,
          $AiConversationsCacheTable,
          AiConversationsCacheData
        >,
      ),
      AiConversationsCacheData,
      PrefetchHooks Function()
    >;
typedef $$AiMessagesCacheTableCreateCompanionBuilder =
    AiMessagesCacheCompanion Function({
      required String id,
      required String conversationId,
      required String content,
      required bool isAi,
      required String sender,
      required String createdAt,
      required String cachedAt,
      Value<int> rowid,
    });
typedef $$AiMessagesCacheTableUpdateCompanionBuilder =
    AiMessagesCacheCompanion Function({
      Value<String> id,
      Value<String> conversationId,
      Value<String> content,
      Value<bool> isAi,
      Value<String> sender,
      Value<String> createdAt,
      Value<String> cachedAt,
      Value<int> rowid,
    });

class $$AiMessagesCacheTableFilterComposer
    extends Composer<_$ProgressDb, $AiMessagesCacheTable> {
  $$AiMessagesCacheTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isAi => $composableBuilder(
    column: $table.isAi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sender => $composableBuilder(
    column: $table.sender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AiMessagesCacheTableOrderingComposer
    extends Composer<_$ProgressDb, $AiMessagesCacheTable> {
  $$AiMessagesCacheTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isAi => $composableBuilder(
    column: $table.isAi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sender => $composableBuilder(
    column: $table.sender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AiMessagesCacheTableAnnotationComposer
    extends Composer<_$ProgressDb, $AiMessagesCacheTable> {
  $$AiMessagesCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<bool> get isAi =>
      $composableBuilder(column: $table.isAi, builder: (column) => column);

  GeneratedColumn<String> get sender =>
      $composableBuilder(column: $table.sender, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$AiMessagesCacheTableTableManager
    extends
        RootTableManager<
          _$ProgressDb,
          $AiMessagesCacheTable,
          AiMessagesCacheData,
          $$AiMessagesCacheTableFilterComposer,
          $$AiMessagesCacheTableOrderingComposer,
          $$AiMessagesCacheTableAnnotationComposer,
          $$AiMessagesCacheTableCreateCompanionBuilder,
          $$AiMessagesCacheTableUpdateCompanionBuilder,
          (
            AiMessagesCacheData,
            BaseReferences<
              _$ProgressDb,
              $AiMessagesCacheTable,
              AiMessagesCacheData
            >,
          ),
          AiMessagesCacheData,
          PrefetchHooks Function()
        > {
  $$AiMessagesCacheTableTableManager(
    _$ProgressDb db,
    $AiMessagesCacheTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AiMessagesCacheTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AiMessagesCacheTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AiMessagesCacheTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> conversationId = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<bool> isAi = const Value.absent(),
                Value<String> sender = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> cachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AiMessagesCacheCompanion(
                id: id,
                conversationId: conversationId,
                content: content,
                isAi: isAi,
                sender: sender,
                createdAt: createdAt,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String conversationId,
                required String content,
                required bool isAi,
                required String sender,
                required String createdAt,
                required String cachedAt,
                Value<int> rowid = const Value.absent(),
              }) => AiMessagesCacheCompanion.insert(
                id: id,
                conversationId: conversationId,
                content: content,
                isAi: isAi,
                sender: sender,
                createdAt: createdAt,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AiMessagesCacheTableProcessedTableManager =
    ProcessedTableManager<
      _$ProgressDb,
      $AiMessagesCacheTable,
      AiMessagesCacheData,
      $$AiMessagesCacheTableFilterComposer,
      $$AiMessagesCacheTableOrderingComposer,
      $$AiMessagesCacheTableAnnotationComposer,
      $$AiMessagesCacheTableCreateCompanionBuilder,
      $$AiMessagesCacheTableUpdateCompanionBuilder,
      (
        AiMessagesCacheData,
        BaseReferences<
          _$ProgressDb,
          $AiMessagesCacheTable,
          AiMessagesCacheData
        >,
      ),
      AiMessagesCacheData,
      PrefetchHooks Function()
    >;
typedef $$LocalNotificationsTableCreateCompanionBuilder =
    LocalNotificationsCompanion Function({
      required String id,
      required String type,
      required String title,
      required String body,
      required String createdAt,
      Value<String?> readAt,
      Value<int> rowid,
    });
typedef $$LocalNotificationsTableUpdateCompanionBuilder =
    LocalNotificationsCompanion Function({
      Value<String> id,
      Value<String> type,
      Value<String> title,
      Value<String> body,
      Value<String> createdAt,
      Value<String?> readAt,
      Value<int> rowid,
    });

class $$LocalNotificationsTableFilterComposer
    extends Composer<_$ProgressDb, $LocalNotificationsTable> {
  $$LocalNotificationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get readAt => $composableBuilder(
    column: $table.readAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalNotificationsTableOrderingComposer
    extends Composer<_$ProgressDb, $LocalNotificationsTable> {
  $$LocalNotificationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get readAt => $composableBuilder(
    column: $table.readAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalNotificationsTableAnnotationComposer
    extends Composer<_$ProgressDb, $LocalNotificationsTable> {
  $$LocalNotificationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get readAt =>
      $composableBuilder(column: $table.readAt, builder: (column) => column);
}

class $$LocalNotificationsTableTableManager
    extends
        RootTableManager<
          _$ProgressDb,
          $LocalNotificationsTable,
          LocalNotification,
          $$LocalNotificationsTableFilterComposer,
          $$LocalNotificationsTableOrderingComposer,
          $$LocalNotificationsTableAnnotationComposer,
          $$LocalNotificationsTableCreateCompanionBuilder,
          $$LocalNotificationsTableUpdateCompanionBuilder,
          (
            LocalNotification,
            BaseReferences<
              _$ProgressDb,
              $LocalNotificationsTable,
              LocalNotification
            >,
          ),
          LocalNotification,
          PrefetchHooks Function()
        > {
  $$LocalNotificationsTableTableManager(
    _$ProgressDb db,
    $LocalNotificationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalNotificationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalNotificationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalNotificationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String?> readAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalNotificationsCompanion(
                id: id,
                type: type,
                title: title,
                body: body,
                createdAt: createdAt,
                readAt: readAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String type,
                required String title,
                required String body,
                required String createdAt,
                Value<String?> readAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalNotificationsCompanion.insert(
                id: id,
                type: type,
                title: title,
                body: body,
                createdAt: createdAt,
                readAt: readAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalNotificationsTableProcessedTableManager =
    ProcessedTableManager<
      _$ProgressDb,
      $LocalNotificationsTable,
      LocalNotification,
      $$LocalNotificationsTableFilterComposer,
      $$LocalNotificationsTableOrderingComposer,
      $$LocalNotificationsTableAnnotationComposer,
      $$LocalNotificationsTableCreateCompanionBuilder,
      $$LocalNotificationsTableUpdateCompanionBuilder,
      (
        LocalNotification,
        BaseReferences<
          _$ProgressDb,
          $LocalNotificationsTable,
          LocalNotification
        >,
      ),
      LocalNotification,
      PrefetchHooks Function()
    >;

class $ProgressDbManager {
  final _$ProgressDb _db;
  $ProgressDbManager(this._db);
  $$PracticeAttemptsTableTableManager get practiceAttempts =>
      $$PracticeAttemptsTableTableManager(_db, _db.practiceAttempts);
  $$PracticeAnswersTableTableManager get practiceAnswers =>
      $$PracticeAnswersTableTableManager(_db, _db.practiceAnswers);
  $$ReadingProgressTableTableManager get readingProgress =>
      $$ReadingProgressTableTableManager(_db, _db.readingProgress);
  $$LocalStatsTableTableManager get localStats =>
      $$LocalStatsTableTableManager(_db, _db.localStats);
  $$SyncOutboxTableTableManager get syncOutbox =>
      $$SyncOutboxTableTableManager(_db, _db.syncOutbox);
  $$AiConversationsCacheTableTableManager get aiConversationsCache =>
      $$AiConversationsCacheTableTableManager(_db, _db.aiConversationsCache);
  $$AiMessagesCacheTableTableManager get aiMessagesCache =>
      $$AiMessagesCacheTableTableManager(_db, _db.aiMessagesCache);
  $$LocalNotificationsTableTableManager get localNotifications =>
      $$LocalNotificationsTableTableManager(_db, _db.localNotifications);
}
