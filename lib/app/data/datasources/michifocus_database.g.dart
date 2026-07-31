// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'michifocus_database.dart';

// ignore_for_file: type=lint
mixin _$GoalsDaoMixin on DatabaseAccessor<MichiFocusDatabase> {
  $GoalRecordsTable get goalRecords => attachedDatabase.goalRecords;
  GoalsDaoManager get managers => GoalsDaoManager(this);
}

class GoalsDaoManager {
  final _$GoalsDaoMixin _db;
  GoalsDaoManager(this._db);
  $$GoalRecordsTableTableManager get goalRecords =>
      $$GoalRecordsTableTableManager(_db.attachedDatabase, _db.goalRecords);
}

mixin _$TasksDaoMixin on DatabaseAccessor<MichiFocusDatabase> {
  $GoalRecordsTable get goalRecords => attachedDatabase.goalRecords;
  $TaskRecordsTable get taskRecords => attachedDatabase.taskRecords;
  $TaskCompletionEventRecordsTable get taskCompletionEventRecords =>
      attachedDatabase.taskCompletionEventRecords;
  TasksDaoManager get managers => TasksDaoManager(this);
}

class TasksDaoManager {
  final _$TasksDaoMixin _db;
  TasksDaoManager(this._db);
  $$GoalRecordsTableTableManager get goalRecords =>
      $$GoalRecordsTableTableManager(_db.attachedDatabase, _db.goalRecords);
  $$TaskRecordsTableTableManager get taskRecords =>
      $$TaskRecordsTableTableManager(_db.attachedDatabase, _db.taskRecords);
  $$TaskCompletionEventRecordsTableTableManager
  get taskCompletionEventRecords =>
      $$TaskCompletionEventRecordsTableTableManager(
        _db.attachedDatabase,
        _db.taskCompletionEventRecords,
      );
}

mixin _$PomodoroSessionsDaoMixin on DatabaseAccessor<MichiFocusDatabase> {
  $GoalRecordsTable get goalRecords => attachedDatabase.goalRecords;
  $TaskRecordsTable get taskRecords => attachedDatabase.taskRecords;
  $PomodoroSessionRecordsTable get pomodoroSessionRecords =>
      attachedDatabase.pomodoroSessionRecords;
  PomodoroSessionsDaoManager get managers => PomodoroSessionsDaoManager(this);
}

class PomodoroSessionsDaoManager {
  final _$PomodoroSessionsDaoMixin _db;
  PomodoroSessionsDaoManager(this._db);
  $$GoalRecordsTableTableManager get goalRecords =>
      $$GoalRecordsTableTableManager(_db.attachedDatabase, _db.goalRecords);
  $$TaskRecordsTableTableManager get taskRecords =>
      $$TaskRecordsTableTableManager(_db.attachedDatabase, _db.taskRecords);
  $$PomodoroSessionRecordsTableTableManager get pomodoroSessionRecords =>
      $$PomodoroSessionRecordsTableTableManager(
        _db.attachedDatabase,
        _db.pomodoroSessionRecords,
      );
}

mixin _$PomodoroRuntimeDaoMixin on DatabaseAccessor<MichiFocusDatabase> {
  $GoalRecordsTable get goalRecords => attachedDatabase.goalRecords;
  $TaskRecordsTable get taskRecords => attachedDatabase.taskRecords;
  $PomodoroRuntimeRecordsTable get pomodoroRuntimeRecords =>
      attachedDatabase.pomodoroRuntimeRecords;
  PomodoroRuntimeDaoManager get managers => PomodoroRuntimeDaoManager(this);
}

class PomodoroRuntimeDaoManager {
  final _$PomodoroRuntimeDaoMixin _db;
  PomodoroRuntimeDaoManager(this._db);
  $$GoalRecordsTableTableManager get goalRecords =>
      $$GoalRecordsTableTableManager(_db.attachedDatabase, _db.goalRecords);
  $$TaskRecordsTableTableManager get taskRecords =>
      $$TaskRecordsTableTableManager(_db.attachedDatabase, _db.taskRecords);
  $$PomodoroRuntimeRecordsTableTableManager get pomodoroRuntimeRecords =>
      $$PomodoroRuntimeRecordsTableTableManager(
        _db.attachedDatabase,
        _db.pomodoroRuntimeRecords,
      );
}

mixin _$CalendarEventsDaoMixin on DatabaseAccessor<MichiFocusDatabase> {
  $CalendarEventRecordsTable get calendarEventRecords =>
      attachedDatabase.calendarEventRecords;
  CalendarEventsDaoManager get managers => CalendarEventsDaoManager(this);
}

class CalendarEventsDaoManager {
  final _$CalendarEventsDaoMixin _db;
  CalendarEventsDaoManager(this._db);
  $$CalendarEventRecordsTableTableManager get calendarEventRecords =>
      $$CalendarEventRecordsTableTableManager(
        _db.attachedDatabase,
        _db.calendarEventRecords,
      );
}

mixin _$ReportsDaoMixin on DatabaseAccessor<MichiFocusDatabase> {
  $GoalRecordsTable get goalRecords => attachedDatabase.goalRecords;
  $TaskRecordsTable get taskRecords => attachedDatabase.taskRecords;
  $TaskCompletionEventRecordsTable get taskCompletionEventRecords =>
      attachedDatabase.taskCompletionEventRecords;
  $ReportingMetadataRecordsTable get reportingMetadataRecords =>
      attachedDatabase.reportingMetadataRecords;
  $PomodoroSessionRecordsTable get pomodoroSessionRecords =>
      attachedDatabase.pomodoroSessionRecords;
  ReportsDaoManager get managers => ReportsDaoManager(this);
}

class ReportsDaoManager {
  final _$ReportsDaoMixin _db;
  ReportsDaoManager(this._db);
  $$GoalRecordsTableTableManager get goalRecords =>
      $$GoalRecordsTableTableManager(_db.attachedDatabase, _db.goalRecords);
  $$TaskRecordsTableTableManager get taskRecords =>
      $$TaskRecordsTableTableManager(_db.attachedDatabase, _db.taskRecords);
  $$TaskCompletionEventRecordsTableTableManager
  get taskCompletionEventRecords =>
      $$TaskCompletionEventRecordsTableTableManager(
        _db.attachedDatabase,
        _db.taskCompletionEventRecords,
      );
  $$ReportingMetadataRecordsTableTableManager get reportingMetadataRecords =>
      $$ReportingMetadataRecordsTableTableManager(
        _db.attachedDatabase,
        _db.reportingMetadataRecords,
      );
  $$PomodoroSessionRecordsTableTableManager get pomodoroSessionRecords =>
      $$PomodoroSessionRecordsTableTableManager(
        _db.attachedDatabase,
        _db.pomodoroSessionRecords,
      );
}

class $GoalRecordsTable extends GoalRecords
    with TableInfo<$GoalRecordsTable, GoalRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoalRecordsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _targetSessionsMeta = const VerificationMeta(
    'targetSessions',
  );
  @override
  late final GeneratedColumn<int> targetSessions = GeneratedColumn<int>(
    'target_sessions',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedSessionsMeta = const VerificationMeta(
    'completedSessions',
  );
  @override
  late final GeneratedColumn<int> completedSessions = GeneratedColumn<int>(
    'completed_sessions',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _targetDateMeta = const VerificationMeta(
    'targetDate',
  );
  @override
  late final GeneratedColumn<DateTime> targetDate = GeneratedColumn<DateTime>(
    'target_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    targetSessions,
    completedSessions,
    targetDate,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'goals';
  @override
  VerificationContext validateIntegrity(
    Insertable<GoalRecord> instance, {
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
    if (data.containsKey('target_sessions')) {
      context.handle(
        _targetSessionsMeta,
        targetSessions.isAcceptableOrUnknown(
          data['target_sessions']!,
          _targetSessionsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetSessionsMeta);
    }
    if (data.containsKey('completed_sessions')) {
      context.handle(
        _completedSessionsMeta,
        completedSessions.isAcceptableOrUnknown(
          data['completed_sessions']!,
          _completedSessionsMeta,
        ),
      );
    }
    if (data.containsKey('target_date')) {
      context.handle(
        _targetDateMeta,
        targetDate.isAcceptableOrUnknown(data['target_date']!, _targetDateMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GoalRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GoalRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      targetSessions: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_sessions'],
      )!,
      completedSessions: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}completed_sessions'],
      )!,
      targetDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}target_date'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $GoalRecordsTable createAlias(String alias) {
    return $GoalRecordsTable(attachedDatabase, alias);
  }
}

class GoalRecord extends DataClass implements Insertable<GoalRecord> {
  final String id;
  final String title;
  final int targetSessions;
  final int completedSessions;
  final DateTime? targetDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  const GoalRecord({
    required this.id,
    required this.title,
    required this.targetSessions,
    required this.completedSessions,
    this.targetDate,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['target_sessions'] = Variable<int>(targetSessions);
    map['completed_sessions'] = Variable<int>(completedSessions);
    if (!nullToAbsent || targetDate != null) {
      map['target_date'] = Variable<DateTime>(targetDate);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  GoalRecordsCompanion toCompanion(bool nullToAbsent) {
    return GoalRecordsCompanion(
      id: Value(id),
      title: Value(title),
      targetSessions: Value(targetSessions),
      completedSessions: Value(completedSessions),
      targetDate: targetDate == null && nullToAbsent
          ? const Value.absent()
          : Value(targetDate),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory GoalRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GoalRecord(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      targetSessions: serializer.fromJson<int>(json['targetSessions']),
      completedSessions: serializer.fromJson<int>(json['completedSessions']),
      targetDate: serializer.fromJson<DateTime?>(json['targetDate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'targetSessions': serializer.toJson<int>(targetSessions),
      'completedSessions': serializer.toJson<int>(completedSessions),
      'targetDate': serializer.toJson<DateTime?>(targetDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  GoalRecord copyWith({
    String? id,
    String? title,
    int? targetSessions,
    int? completedSessions,
    Value<DateTime?> targetDate = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => GoalRecord(
    id: id ?? this.id,
    title: title ?? this.title,
    targetSessions: targetSessions ?? this.targetSessions,
    completedSessions: completedSessions ?? this.completedSessions,
    targetDate: targetDate.present ? targetDate.value : this.targetDate,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  GoalRecord copyWithCompanion(GoalRecordsCompanion data) {
    return GoalRecord(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      targetSessions: data.targetSessions.present
          ? data.targetSessions.value
          : this.targetSessions,
      completedSessions: data.completedSessions.present
          ? data.completedSessions.value
          : this.completedSessions,
      targetDate: data.targetDate.present
          ? data.targetDate.value
          : this.targetDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GoalRecord(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('targetSessions: $targetSessions, ')
          ..write('completedSessions: $completedSessions, ')
          ..write('targetDate: $targetDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    targetSessions,
    completedSessions,
    targetDate,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GoalRecord &&
          other.id == this.id &&
          other.title == this.title &&
          other.targetSessions == this.targetSessions &&
          other.completedSessions == this.completedSessions &&
          other.targetDate == this.targetDate &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class GoalRecordsCompanion extends UpdateCompanion<GoalRecord> {
  final Value<String> id;
  final Value<String> title;
  final Value<int> targetSessions;
  final Value<int> completedSessions;
  final Value<DateTime?> targetDate;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const GoalRecordsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.targetSessions = const Value.absent(),
    this.completedSessions = const Value.absent(),
    this.targetDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GoalRecordsCompanion.insert({
    required String id,
    required String title,
    required int targetSessions,
    this.completedSessions = const Value.absent(),
    this.targetDate = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       targetSessions = Value(targetSessions),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<GoalRecord> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<int>? targetSessions,
    Expression<int>? completedSessions,
    Expression<DateTime>? targetDate,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (targetSessions != null) 'target_sessions': targetSessions,
      if (completedSessions != null) 'completed_sessions': completedSessions,
      if (targetDate != null) 'target_date': targetDate,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GoalRecordsCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<int>? targetSessions,
    Value<int>? completedSessions,
    Value<DateTime?>? targetDate,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return GoalRecordsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      targetSessions: targetSessions ?? this.targetSessions,
      completedSessions: completedSessions ?? this.completedSessions,
      targetDate: targetDate ?? this.targetDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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
    if (targetSessions.present) {
      map['target_sessions'] = Variable<int>(targetSessions.value);
    }
    if (completedSessions.present) {
      map['completed_sessions'] = Variable<int>(completedSessions.value);
    }
    if (targetDate.present) {
      map['target_date'] = Variable<DateTime>(targetDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GoalRecordsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('targetSessions: $targetSessions, ')
          ..write('completedSessions: $completedSessions, ')
          ..write('targetDate: $targetDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TaskRecordsTable extends TaskRecords
    with TableInfo<$TaskRecordsTable, TaskRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskRecordsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _isCompletedMeta = const VerificationMeta(
    'isCompleted',
  );
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
    'is_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('listed'),
  );
  static const VerificationMeta _scheduledDateMeta = const VerificationMeta(
    'scheduledDate',
  );
  @override
  late final GeneratedColumn<DateTime> scheduledDate =
      GeneratedColumn<DateTime>(
        'scheduled_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _goalIdMeta = const VerificationMeta('goalId');
  @override
  late final GeneratedColumn<String> goalId = GeneratedColumn<String>(
    'goal_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES goals (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _durationMinutesMeta = const VerificationMeta(
    'durationMinutes',
  );
  @override
  late final GeneratedColumn<int> durationMinutes = GeneratedColumn<int>(
    'duration_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _legacyCompletionUnknownMeta =
      const VerificationMeta('legacyCompletionUnknown');
  @override
  late final GeneratedColumn<bool> legacyCompletionUnknown =
      GeneratedColumn<bool>(
        'legacy_completion_unknown',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("legacy_completion_unknown" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    isCompleted,
    status,
    scheduledDate,
    goalId,
    durationMinutes,
    legacyCompletionUnknown,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tasks';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskRecord> instance, {
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
    if (data.containsKey('is_completed')) {
      context.handle(
        _isCompletedMeta,
        isCompleted.isAcceptableOrUnknown(
          data['is_completed']!,
          _isCompletedMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('scheduled_date')) {
      context.handle(
        _scheduledDateMeta,
        scheduledDate.isAcceptableOrUnknown(
          data['scheduled_date']!,
          _scheduledDateMeta,
        ),
      );
    }
    if (data.containsKey('goal_id')) {
      context.handle(
        _goalIdMeta,
        goalId.isAcceptableOrUnknown(data['goal_id']!, _goalIdMeta),
      );
    }
    if (data.containsKey('duration_minutes')) {
      context.handle(
        _durationMinutesMeta,
        durationMinutes.isAcceptableOrUnknown(
          data['duration_minutes']!,
          _durationMinutesMeta,
        ),
      );
    }
    if (data.containsKey('legacy_completion_unknown')) {
      context.handle(
        _legacyCompletionUnknownMeta,
        legacyCompletionUnknown.isAcceptableOrUnknown(
          data['legacy_completion_unknown']!,
          _legacyCompletionUnknownMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      isCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_completed'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      scheduledDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}scheduled_date'],
      ),
      goalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}goal_id'],
      ),
      durationMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_minutes'],
      ),
      legacyCompletionUnknown: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}legacy_completion_unknown'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $TaskRecordsTable createAlias(String alias) {
    return $TaskRecordsTable(attachedDatabase, alias);
  }
}

class TaskRecord extends DataClass implements Insertable<TaskRecord> {
  final String id;
  final String title;
  final bool isCompleted;
  final String status;
  final DateTime? scheduledDate;
  final String? goalId;
  final int? durationMinutes;
  final bool legacyCompletionUnknown;
  final DateTime createdAt;
  final DateTime updatedAt;
  const TaskRecord({
    required this.id,
    required this.title,
    required this.isCompleted,
    required this.status,
    this.scheduledDate,
    this.goalId,
    this.durationMinutes,
    required this.legacyCompletionUnknown,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['is_completed'] = Variable<bool>(isCompleted);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || scheduledDate != null) {
      map['scheduled_date'] = Variable<DateTime>(scheduledDate);
    }
    if (!nullToAbsent || goalId != null) {
      map['goal_id'] = Variable<String>(goalId);
    }
    if (!nullToAbsent || durationMinutes != null) {
      map['duration_minutes'] = Variable<int>(durationMinutes);
    }
    map['legacy_completion_unknown'] = Variable<bool>(legacyCompletionUnknown);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TaskRecordsCompanion toCompanion(bool nullToAbsent) {
    return TaskRecordsCompanion(
      id: Value(id),
      title: Value(title),
      isCompleted: Value(isCompleted),
      status: Value(status),
      scheduledDate: scheduledDate == null && nullToAbsent
          ? const Value.absent()
          : Value(scheduledDate),
      goalId: goalId == null && nullToAbsent
          ? const Value.absent()
          : Value(goalId),
      durationMinutes: durationMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(durationMinutes),
      legacyCompletionUnknown: Value(legacyCompletionUnknown),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory TaskRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskRecord(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      status: serializer.fromJson<String>(json['status']),
      scheduledDate: serializer.fromJson<DateTime?>(json['scheduledDate']),
      goalId: serializer.fromJson<String?>(json['goalId']),
      durationMinutes: serializer.fromJson<int?>(json['durationMinutes']),
      legacyCompletionUnknown: serializer.fromJson<bool>(
        json['legacyCompletionUnknown'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'status': serializer.toJson<String>(status),
      'scheduledDate': serializer.toJson<DateTime?>(scheduledDate),
      'goalId': serializer.toJson<String?>(goalId),
      'durationMinutes': serializer.toJson<int?>(durationMinutes),
      'legacyCompletionUnknown': serializer.toJson<bool>(
        legacyCompletionUnknown,
      ),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TaskRecord copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    String? status,
    Value<DateTime?> scheduledDate = const Value.absent(),
    Value<String?> goalId = const Value.absent(),
    Value<int?> durationMinutes = const Value.absent(),
    bool? legacyCompletionUnknown,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => TaskRecord(
    id: id ?? this.id,
    title: title ?? this.title,
    isCompleted: isCompleted ?? this.isCompleted,
    status: status ?? this.status,
    scheduledDate: scheduledDate.present
        ? scheduledDate.value
        : this.scheduledDate,
    goalId: goalId.present ? goalId.value : this.goalId,
    durationMinutes: durationMinutes.present
        ? durationMinutes.value
        : this.durationMinutes,
    legacyCompletionUnknown:
        legacyCompletionUnknown ?? this.legacyCompletionUnknown,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  TaskRecord copyWithCompanion(TaskRecordsCompanion data) {
    return TaskRecord(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      isCompleted: data.isCompleted.present
          ? data.isCompleted.value
          : this.isCompleted,
      status: data.status.present ? data.status.value : this.status,
      scheduledDate: data.scheduledDate.present
          ? data.scheduledDate.value
          : this.scheduledDate,
      goalId: data.goalId.present ? data.goalId.value : this.goalId,
      durationMinutes: data.durationMinutes.present
          ? data.durationMinutes.value
          : this.durationMinutes,
      legacyCompletionUnknown: data.legacyCompletionUnknown.present
          ? data.legacyCompletionUnknown.value
          : this.legacyCompletionUnknown,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskRecord(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('status: $status, ')
          ..write('scheduledDate: $scheduledDate, ')
          ..write('goalId: $goalId, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('legacyCompletionUnknown: $legacyCompletionUnknown, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    isCompleted,
    status,
    scheduledDate,
    goalId,
    durationMinutes,
    legacyCompletionUnknown,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskRecord &&
          other.id == this.id &&
          other.title == this.title &&
          other.isCompleted == this.isCompleted &&
          other.status == this.status &&
          other.scheduledDate == this.scheduledDate &&
          other.goalId == this.goalId &&
          other.durationMinutes == this.durationMinutes &&
          other.legacyCompletionUnknown == this.legacyCompletionUnknown &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TaskRecordsCompanion extends UpdateCompanion<TaskRecord> {
  final Value<String> id;
  final Value<String> title;
  final Value<bool> isCompleted;
  final Value<String> status;
  final Value<DateTime?> scheduledDate;
  final Value<String?> goalId;
  final Value<int?> durationMinutes;
  final Value<bool> legacyCompletionUnknown;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const TaskRecordsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.status = const Value.absent(),
    this.scheduledDate = const Value.absent(),
    this.goalId = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    this.legacyCompletionUnknown = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TaskRecordsCompanion.insert({
    required String id,
    required String title,
    this.isCompleted = const Value.absent(),
    this.status = const Value.absent(),
    this.scheduledDate = const Value.absent(),
    this.goalId = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    this.legacyCompletionUnknown = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<TaskRecord> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<bool>? isCompleted,
    Expression<String>? status,
    Expression<DateTime>? scheduledDate,
    Expression<String>? goalId,
    Expression<int>? durationMinutes,
    Expression<bool>? legacyCompletionUnknown,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (status != null) 'status': status,
      if (scheduledDate != null) 'scheduled_date': scheduledDate,
      if (goalId != null) 'goal_id': goalId,
      if (durationMinutes != null) 'duration_minutes': durationMinutes,
      if (legacyCompletionUnknown != null)
        'legacy_completion_unknown': legacyCompletionUnknown,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TaskRecordsCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<bool>? isCompleted,
    Value<String>? status,
    Value<DateTime?>? scheduledDate,
    Value<String?>? goalId,
    Value<int?>? durationMinutes,
    Value<bool>? legacyCompletionUnknown,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return TaskRecordsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      status: status ?? this.status,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      goalId: goalId ?? this.goalId,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      legacyCompletionUnknown:
          legacyCompletionUnknown ?? this.legacyCompletionUnknown,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (scheduledDate.present) {
      map['scheduled_date'] = Variable<DateTime>(scheduledDate.value);
    }
    if (goalId.present) {
      map['goal_id'] = Variable<String>(goalId.value);
    }
    if (durationMinutes.present) {
      map['duration_minutes'] = Variable<int>(durationMinutes.value);
    }
    if (legacyCompletionUnknown.present) {
      map['legacy_completion_unknown'] = Variable<bool>(
        legacyCompletionUnknown.value,
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskRecordsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('status: $status, ')
          ..write('scheduledDate: $scheduledDate, ')
          ..write('goalId: $goalId, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('legacyCompletionUnknown: $legacyCompletionUnknown, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TaskCompletionEventRecordsTable extends TaskCompletionEventRecords
    with
        TableInfo<$TaskCompletionEventRecordsTable, TaskCompletionEventRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskCompletionEventRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
    'task_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tasks (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _taskIdSnapshotMeta = const VerificationMeta(
    'taskIdSnapshot',
  );
  @override
  late final GeneratedColumn<String> taskIdSnapshot = GeneratedColumn<String>(
    'task_id_snapshot',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scheduledDateSnapshotMeta =
      const VerificationMeta('scheduledDateSnapshot');
  @override
  late final GeneratedColumn<DateTime> scheduledDateSnapshot =
      GeneratedColumn<DateTime>(
        'scheduled_date_snapshot',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    taskId,
    taskIdSnapshot,
    completedAt,
    scheduledDateSnapshot,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_completion_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskCompletionEventRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    }
    if (data.containsKey('task_id_snapshot')) {
      context.handle(
        _taskIdSnapshotMeta,
        taskIdSnapshot.isAcceptableOrUnknown(
          data['task_id_snapshot']!,
          _taskIdSnapshotMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_taskIdSnapshotMeta);
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
    if (data.containsKey('scheduled_date_snapshot')) {
      context.handle(
        _scheduledDateSnapshotMeta,
        scheduledDateSnapshot.isAcceptableOrUnknown(
          data['scheduled_date_snapshot']!,
          _scheduledDateSnapshotMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskCompletionEventRecord map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskCompletionEventRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_id'],
      ),
      taskIdSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_id_snapshot'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      )!,
      scheduledDateSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}scheduled_date_snapshot'],
      ),
    );
  }

  @override
  $TaskCompletionEventRecordsTable createAlias(String alias) {
    return $TaskCompletionEventRecordsTable(attachedDatabase, alias);
  }
}

class TaskCompletionEventRecord extends DataClass
    implements Insertable<TaskCompletionEventRecord> {
  final String id;
  final String? taskId;
  final String taskIdSnapshot;
  final DateTime completedAt;
  final DateTime? scheduledDateSnapshot;
  const TaskCompletionEventRecord({
    required this.id,
    this.taskId,
    required this.taskIdSnapshot,
    required this.completedAt,
    this.scheduledDateSnapshot,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || taskId != null) {
      map['task_id'] = Variable<String>(taskId);
    }
    map['task_id_snapshot'] = Variable<String>(taskIdSnapshot);
    map['completed_at'] = Variable<DateTime>(completedAt);
    if (!nullToAbsent || scheduledDateSnapshot != null) {
      map['scheduled_date_snapshot'] = Variable<DateTime>(
        scheduledDateSnapshot,
      );
    }
    return map;
  }

  TaskCompletionEventRecordsCompanion toCompanion(bool nullToAbsent) {
    return TaskCompletionEventRecordsCompanion(
      id: Value(id),
      taskId: taskId == null && nullToAbsent
          ? const Value.absent()
          : Value(taskId),
      taskIdSnapshot: Value(taskIdSnapshot),
      completedAt: Value(completedAt),
      scheduledDateSnapshot: scheduledDateSnapshot == null && nullToAbsent
          ? const Value.absent()
          : Value(scheduledDateSnapshot),
    );
  }

  factory TaskCompletionEventRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskCompletionEventRecord(
      id: serializer.fromJson<String>(json['id']),
      taskId: serializer.fromJson<String?>(json['taskId']),
      taskIdSnapshot: serializer.fromJson<String>(json['taskIdSnapshot']),
      completedAt: serializer.fromJson<DateTime>(json['completedAt']),
      scheduledDateSnapshot: serializer.fromJson<DateTime?>(
        json['scheduledDateSnapshot'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'taskId': serializer.toJson<String?>(taskId),
      'taskIdSnapshot': serializer.toJson<String>(taskIdSnapshot),
      'completedAt': serializer.toJson<DateTime>(completedAt),
      'scheduledDateSnapshot': serializer.toJson<DateTime?>(
        scheduledDateSnapshot,
      ),
    };
  }

  TaskCompletionEventRecord copyWith({
    String? id,
    Value<String?> taskId = const Value.absent(),
    String? taskIdSnapshot,
    DateTime? completedAt,
    Value<DateTime?> scheduledDateSnapshot = const Value.absent(),
  }) => TaskCompletionEventRecord(
    id: id ?? this.id,
    taskId: taskId.present ? taskId.value : this.taskId,
    taskIdSnapshot: taskIdSnapshot ?? this.taskIdSnapshot,
    completedAt: completedAt ?? this.completedAt,
    scheduledDateSnapshot: scheduledDateSnapshot.present
        ? scheduledDateSnapshot.value
        : this.scheduledDateSnapshot,
  );
  TaskCompletionEventRecord copyWithCompanion(
    TaskCompletionEventRecordsCompanion data,
  ) {
    return TaskCompletionEventRecord(
      id: data.id.present ? data.id.value : this.id,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      taskIdSnapshot: data.taskIdSnapshot.present
          ? data.taskIdSnapshot.value
          : this.taskIdSnapshot,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      scheduledDateSnapshot: data.scheduledDateSnapshot.present
          ? data.scheduledDateSnapshot.value
          : this.scheduledDateSnapshot,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskCompletionEventRecord(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('taskIdSnapshot: $taskIdSnapshot, ')
          ..write('completedAt: $completedAt, ')
          ..write('scheduledDateSnapshot: $scheduledDateSnapshot')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    taskId,
    taskIdSnapshot,
    completedAt,
    scheduledDateSnapshot,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskCompletionEventRecord &&
          other.id == this.id &&
          other.taskId == this.taskId &&
          other.taskIdSnapshot == this.taskIdSnapshot &&
          other.completedAt == this.completedAt &&
          other.scheduledDateSnapshot == this.scheduledDateSnapshot);
}

class TaskCompletionEventRecordsCompanion
    extends UpdateCompanion<TaskCompletionEventRecord> {
  final Value<String> id;
  final Value<String?> taskId;
  final Value<String> taskIdSnapshot;
  final Value<DateTime> completedAt;
  final Value<DateTime?> scheduledDateSnapshot;
  final Value<int> rowid;
  const TaskCompletionEventRecordsCompanion({
    this.id = const Value.absent(),
    this.taskId = const Value.absent(),
    this.taskIdSnapshot = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.scheduledDateSnapshot = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TaskCompletionEventRecordsCompanion.insert({
    required String id,
    this.taskId = const Value.absent(),
    required String taskIdSnapshot,
    required DateTime completedAt,
    this.scheduledDateSnapshot = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       taskIdSnapshot = Value(taskIdSnapshot),
       completedAt = Value(completedAt);
  static Insertable<TaskCompletionEventRecord> custom({
    Expression<String>? id,
    Expression<String>? taskId,
    Expression<String>? taskIdSnapshot,
    Expression<DateTime>? completedAt,
    Expression<DateTime>? scheduledDateSnapshot,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (taskId != null) 'task_id': taskId,
      if (taskIdSnapshot != null) 'task_id_snapshot': taskIdSnapshot,
      if (completedAt != null) 'completed_at': completedAt,
      if (scheduledDateSnapshot != null)
        'scheduled_date_snapshot': scheduledDateSnapshot,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TaskCompletionEventRecordsCompanion copyWith({
    Value<String>? id,
    Value<String?>? taskId,
    Value<String>? taskIdSnapshot,
    Value<DateTime>? completedAt,
    Value<DateTime?>? scheduledDateSnapshot,
    Value<int>? rowid,
  }) {
    return TaskCompletionEventRecordsCompanion(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      taskIdSnapshot: taskIdSnapshot ?? this.taskIdSnapshot,
      completedAt: completedAt ?? this.completedAt,
      scheduledDateSnapshot:
          scheduledDateSnapshot ?? this.scheduledDateSnapshot,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (taskIdSnapshot.present) {
      map['task_id_snapshot'] = Variable<String>(taskIdSnapshot.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (scheduledDateSnapshot.present) {
      map['scheduled_date_snapshot'] = Variable<DateTime>(
        scheduledDateSnapshot.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskCompletionEventRecordsCompanion(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('taskIdSnapshot: $taskIdSnapshot, ')
          ..write('completedAt: $completedAt, ')
          ..write('scheduledDateSnapshot: $scheduledDateSnapshot, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReportingMetadataRecordsTable extends ReportingMetadataRecords
    with TableInfo<$ReportingMetadataRecordsTable, ReportingMetadataRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReportingMetadataRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completionTrackingStartedAtMeta =
      const VerificationMeta('completionTrackingStartedAt');
  @override
  late final GeneratedColumn<DateTime> completionTrackingStartedAt =
      GeneratedColumn<DateTime>(
        'completion_tracking_started_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [id, completionTrackingStartedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reporting_metadata';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReportingMetadataRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('completion_tracking_started_at')) {
      context.handle(
        _completionTrackingStartedAtMeta,
        completionTrackingStartedAt.isAcceptableOrUnknown(
          data['completion_tracking_started_at']!,
          _completionTrackingStartedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_completionTrackingStartedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReportingMetadataRecord map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReportingMetadataRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      completionTrackingStartedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completion_tracking_started_at'],
      )!,
    );
  }

  @override
  $ReportingMetadataRecordsTable createAlias(String alias) {
    return $ReportingMetadataRecordsTable(attachedDatabase, alias);
  }
}

class ReportingMetadataRecord extends DataClass
    implements Insertable<ReportingMetadataRecord> {
  final String id;
  final DateTime completionTrackingStartedAt;
  const ReportingMetadataRecord({
    required this.id,
    required this.completionTrackingStartedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['completion_tracking_started_at'] = Variable<DateTime>(
      completionTrackingStartedAt,
    );
    return map;
  }

  ReportingMetadataRecordsCompanion toCompanion(bool nullToAbsent) {
    return ReportingMetadataRecordsCompanion(
      id: Value(id),
      completionTrackingStartedAt: Value(completionTrackingStartedAt),
    );
  }

  factory ReportingMetadataRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReportingMetadataRecord(
      id: serializer.fromJson<String>(json['id']),
      completionTrackingStartedAt: serializer.fromJson<DateTime>(
        json['completionTrackingStartedAt'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'completionTrackingStartedAt': serializer.toJson<DateTime>(
        completionTrackingStartedAt,
      ),
    };
  }

  ReportingMetadataRecord copyWith({
    String? id,
    DateTime? completionTrackingStartedAt,
  }) => ReportingMetadataRecord(
    id: id ?? this.id,
    completionTrackingStartedAt:
        completionTrackingStartedAt ?? this.completionTrackingStartedAt,
  );
  ReportingMetadataRecord copyWithCompanion(
    ReportingMetadataRecordsCompanion data,
  ) {
    return ReportingMetadataRecord(
      id: data.id.present ? data.id.value : this.id,
      completionTrackingStartedAt: data.completionTrackingStartedAt.present
          ? data.completionTrackingStartedAt.value
          : this.completionTrackingStartedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReportingMetadataRecord(')
          ..write('id: $id, ')
          ..write('completionTrackingStartedAt: $completionTrackingStartedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, completionTrackingStartedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReportingMetadataRecord &&
          other.id == this.id &&
          other.completionTrackingStartedAt ==
              this.completionTrackingStartedAt);
}

class ReportingMetadataRecordsCompanion
    extends UpdateCompanion<ReportingMetadataRecord> {
  final Value<String> id;
  final Value<DateTime> completionTrackingStartedAt;
  final Value<int> rowid;
  const ReportingMetadataRecordsCompanion({
    this.id = const Value.absent(),
    this.completionTrackingStartedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReportingMetadataRecordsCompanion.insert({
    required String id,
    required DateTime completionTrackingStartedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       completionTrackingStartedAt = Value(completionTrackingStartedAt);
  static Insertable<ReportingMetadataRecord> custom({
    Expression<String>? id,
    Expression<DateTime>? completionTrackingStartedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (completionTrackingStartedAt != null)
        'completion_tracking_started_at': completionTrackingStartedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReportingMetadataRecordsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? completionTrackingStartedAt,
    Value<int>? rowid,
  }) {
    return ReportingMetadataRecordsCompanion(
      id: id ?? this.id,
      completionTrackingStartedAt:
          completionTrackingStartedAt ?? this.completionTrackingStartedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (completionTrackingStartedAt.present) {
      map['completion_tracking_started_at'] = Variable<DateTime>(
        completionTrackingStartedAt.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReportingMetadataRecordsCompanion(')
          ..write('id: $id, ')
          ..write('completionTrackingStartedAt: $completionTrackingStartedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PomodoroSessionRecordsTable extends PomodoroSessionRecords
    with TableInfo<$PomodoroSessionRecordsTable, PomodoroSessionRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PomodoroSessionRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endedAtMeta = const VerificationMeta(
    'endedAt',
  );
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
    'ended_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _plannedSecondsMeta = const VerificationMeta(
    'plannedSeconds',
  );
  @override
  late final GeneratedColumn<int> plannedSeconds = GeneratedColumn<int>(
    'planned_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _focusedSecondsMeta = const VerificationMeta(
    'focusedSeconds',
  );
  @override
  late final GeneratedColumn<int> focusedSeconds = GeneratedColumn<int>(
    'focused_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _goalIdMeta = const VerificationMeta('goalId');
  @override
  late final GeneratedColumn<String> goalId = GeneratedColumn<String>(
    'goal_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES goals (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
    'task_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tasks (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _startMoodScoreMeta = const VerificationMeta(
    'startMoodScore',
  );
  @override
  late final GeneratedColumn<int> startMoodScore = GeneratedColumn<int>(
    'start_mood_score',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endMoodScoreMeta = const VerificationMeta(
    'endMoodScore',
  );
  @override
  late final GeneratedColumn<int> endMoodScore = GeneratedColumn<int>(
    'end_mood_score',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _wasDistractedMeta = const VerificationMeta(
    'wasDistracted',
  );
  @override
  late final GeneratedColumn<bool> wasDistracted = GeneratedColumn<bool>(
    'was_distracted',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("was_distracted" IN (0, 1))',
    ),
  );
  static const VerificationMeta _distractionMinutesMeta =
      const VerificationMeta('distractionMinutes');
  @override
  late final GeneratedColumn<int> distractionMinutes = GeneratedColumn<int>(
    'distraction_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    startedAt,
    endedAt,
    plannedSeconds,
    focusedSeconds,
    goalId,
    taskId,
    startMoodScore,
    endMoodScore,
    wasDistracted,
    distractionMinutes,
    status,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pomodoro_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<PomodoroSessionRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_endedAtMeta);
    }
    if (data.containsKey('planned_seconds')) {
      context.handle(
        _plannedSecondsMeta,
        plannedSeconds.isAcceptableOrUnknown(
          data['planned_seconds']!,
          _plannedSecondsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_plannedSecondsMeta);
    }
    if (data.containsKey('focused_seconds')) {
      context.handle(
        _focusedSecondsMeta,
        focusedSeconds.isAcceptableOrUnknown(
          data['focused_seconds']!,
          _focusedSecondsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_focusedSecondsMeta);
    }
    if (data.containsKey('goal_id')) {
      context.handle(
        _goalIdMeta,
        goalId.isAcceptableOrUnknown(data['goal_id']!, _goalIdMeta),
      );
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    }
    if (data.containsKey('start_mood_score')) {
      context.handle(
        _startMoodScoreMeta,
        startMoodScore.isAcceptableOrUnknown(
          data['start_mood_score']!,
          _startMoodScoreMeta,
        ),
      );
    }
    if (data.containsKey('end_mood_score')) {
      context.handle(
        _endMoodScoreMeta,
        endMoodScore.isAcceptableOrUnknown(
          data['end_mood_score']!,
          _endMoodScoreMeta,
        ),
      );
    }
    if (data.containsKey('was_distracted')) {
      context.handle(
        _wasDistractedMeta,
        wasDistracted.isAcceptableOrUnknown(
          data['was_distracted']!,
          _wasDistractedMeta,
        ),
      );
    }
    if (data.containsKey('distraction_minutes')) {
      context.handle(
        _distractionMinutesMeta,
        distractionMinutes.isAcceptableOrUnknown(
          data['distraction_minutes']!,
          _distractionMinutesMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PomodoroSessionRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PomodoroSessionRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ended_at'],
      )!,
      plannedSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}planned_seconds'],
      )!,
      focusedSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}focused_seconds'],
      )!,
      goalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}goal_id'],
      ),
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_id'],
      ),
      startMoodScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_mood_score'],
      ),
      endMoodScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_mood_score'],
      ),
      wasDistracted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}was_distracted'],
      ),
      distractionMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}distraction_minutes'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PomodoroSessionRecordsTable createAlias(String alias) {
    return $PomodoroSessionRecordsTable(attachedDatabase, alias);
  }
}

class PomodoroSessionRecord extends DataClass
    implements Insertable<PomodoroSessionRecord> {
  final String id;
  final DateTime startedAt;
  final DateTime endedAt;
  final int plannedSeconds;
  final int focusedSeconds;
  final String? goalId;
  final String? taskId;
  final int? startMoodScore;
  final int? endMoodScore;
  final bool? wasDistracted;
  final int? distractionMinutes;
  final String status;
  final DateTime createdAt;
  const PomodoroSessionRecord({
    required this.id,
    required this.startedAt,
    required this.endedAt,
    required this.plannedSeconds,
    required this.focusedSeconds,
    this.goalId,
    this.taskId,
    this.startMoodScore,
    this.endMoodScore,
    this.wasDistracted,
    this.distractionMinutes,
    required this.status,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['started_at'] = Variable<DateTime>(startedAt);
    map['ended_at'] = Variable<DateTime>(endedAt);
    map['planned_seconds'] = Variable<int>(plannedSeconds);
    map['focused_seconds'] = Variable<int>(focusedSeconds);
    if (!nullToAbsent || goalId != null) {
      map['goal_id'] = Variable<String>(goalId);
    }
    if (!nullToAbsent || taskId != null) {
      map['task_id'] = Variable<String>(taskId);
    }
    if (!nullToAbsent || startMoodScore != null) {
      map['start_mood_score'] = Variable<int>(startMoodScore);
    }
    if (!nullToAbsent || endMoodScore != null) {
      map['end_mood_score'] = Variable<int>(endMoodScore);
    }
    if (!nullToAbsent || wasDistracted != null) {
      map['was_distracted'] = Variable<bool>(wasDistracted);
    }
    if (!nullToAbsent || distractionMinutes != null) {
      map['distraction_minutes'] = Variable<int>(distractionMinutes);
    }
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PomodoroSessionRecordsCompanion toCompanion(bool nullToAbsent) {
    return PomodoroSessionRecordsCompanion(
      id: Value(id),
      startedAt: Value(startedAt),
      endedAt: Value(endedAt),
      plannedSeconds: Value(plannedSeconds),
      focusedSeconds: Value(focusedSeconds),
      goalId: goalId == null && nullToAbsent
          ? const Value.absent()
          : Value(goalId),
      taskId: taskId == null && nullToAbsent
          ? const Value.absent()
          : Value(taskId),
      startMoodScore: startMoodScore == null && nullToAbsent
          ? const Value.absent()
          : Value(startMoodScore),
      endMoodScore: endMoodScore == null && nullToAbsent
          ? const Value.absent()
          : Value(endMoodScore),
      wasDistracted: wasDistracted == null && nullToAbsent
          ? const Value.absent()
          : Value(wasDistracted),
      distractionMinutes: distractionMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(distractionMinutes),
      status: Value(status),
      createdAt: Value(createdAt),
    );
  }

  factory PomodoroSessionRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PomodoroSessionRecord(
      id: serializer.fromJson<String>(json['id']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime>(json['endedAt']),
      plannedSeconds: serializer.fromJson<int>(json['plannedSeconds']),
      focusedSeconds: serializer.fromJson<int>(json['focusedSeconds']),
      goalId: serializer.fromJson<String?>(json['goalId']),
      taskId: serializer.fromJson<String?>(json['taskId']),
      startMoodScore: serializer.fromJson<int?>(json['startMoodScore']),
      endMoodScore: serializer.fromJson<int?>(json['endMoodScore']),
      wasDistracted: serializer.fromJson<bool?>(json['wasDistracted']),
      distractionMinutes: serializer.fromJson<int?>(json['distractionMinutes']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'endedAt': serializer.toJson<DateTime>(endedAt),
      'plannedSeconds': serializer.toJson<int>(plannedSeconds),
      'focusedSeconds': serializer.toJson<int>(focusedSeconds),
      'goalId': serializer.toJson<String?>(goalId),
      'taskId': serializer.toJson<String?>(taskId),
      'startMoodScore': serializer.toJson<int?>(startMoodScore),
      'endMoodScore': serializer.toJson<int?>(endMoodScore),
      'wasDistracted': serializer.toJson<bool?>(wasDistracted),
      'distractionMinutes': serializer.toJson<int?>(distractionMinutes),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PomodoroSessionRecord copyWith({
    String? id,
    DateTime? startedAt,
    DateTime? endedAt,
    int? plannedSeconds,
    int? focusedSeconds,
    Value<String?> goalId = const Value.absent(),
    Value<String?> taskId = const Value.absent(),
    Value<int?> startMoodScore = const Value.absent(),
    Value<int?> endMoodScore = const Value.absent(),
    Value<bool?> wasDistracted = const Value.absent(),
    Value<int?> distractionMinutes = const Value.absent(),
    String? status,
    DateTime? createdAt,
  }) => PomodoroSessionRecord(
    id: id ?? this.id,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt ?? this.endedAt,
    plannedSeconds: plannedSeconds ?? this.plannedSeconds,
    focusedSeconds: focusedSeconds ?? this.focusedSeconds,
    goalId: goalId.present ? goalId.value : this.goalId,
    taskId: taskId.present ? taskId.value : this.taskId,
    startMoodScore: startMoodScore.present
        ? startMoodScore.value
        : this.startMoodScore,
    endMoodScore: endMoodScore.present ? endMoodScore.value : this.endMoodScore,
    wasDistracted: wasDistracted.present
        ? wasDistracted.value
        : this.wasDistracted,
    distractionMinutes: distractionMinutes.present
        ? distractionMinutes.value
        : this.distractionMinutes,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
  );
  PomodoroSessionRecord copyWithCompanion(
    PomodoroSessionRecordsCompanion data,
  ) {
    return PomodoroSessionRecord(
      id: data.id.present ? data.id.value : this.id,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      plannedSeconds: data.plannedSeconds.present
          ? data.plannedSeconds.value
          : this.plannedSeconds,
      focusedSeconds: data.focusedSeconds.present
          ? data.focusedSeconds.value
          : this.focusedSeconds,
      goalId: data.goalId.present ? data.goalId.value : this.goalId,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      startMoodScore: data.startMoodScore.present
          ? data.startMoodScore.value
          : this.startMoodScore,
      endMoodScore: data.endMoodScore.present
          ? data.endMoodScore.value
          : this.endMoodScore,
      wasDistracted: data.wasDistracted.present
          ? data.wasDistracted.value
          : this.wasDistracted,
      distractionMinutes: data.distractionMinutes.present
          ? data.distractionMinutes.value
          : this.distractionMinutes,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PomodoroSessionRecord(')
          ..write('id: $id, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('plannedSeconds: $plannedSeconds, ')
          ..write('focusedSeconds: $focusedSeconds, ')
          ..write('goalId: $goalId, ')
          ..write('taskId: $taskId, ')
          ..write('startMoodScore: $startMoodScore, ')
          ..write('endMoodScore: $endMoodScore, ')
          ..write('wasDistracted: $wasDistracted, ')
          ..write('distractionMinutes: $distractionMinutes, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    startedAt,
    endedAt,
    plannedSeconds,
    focusedSeconds,
    goalId,
    taskId,
    startMoodScore,
    endMoodScore,
    wasDistracted,
    distractionMinutes,
    status,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PomodoroSessionRecord &&
          other.id == this.id &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.plannedSeconds == this.plannedSeconds &&
          other.focusedSeconds == this.focusedSeconds &&
          other.goalId == this.goalId &&
          other.taskId == this.taskId &&
          other.startMoodScore == this.startMoodScore &&
          other.endMoodScore == this.endMoodScore &&
          other.wasDistracted == this.wasDistracted &&
          other.distractionMinutes == this.distractionMinutes &&
          other.status == this.status &&
          other.createdAt == this.createdAt);
}

class PomodoroSessionRecordsCompanion
    extends UpdateCompanion<PomodoroSessionRecord> {
  final Value<String> id;
  final Value<DateTime> startedAt;
  final Value<DateTime> endedAt;
  final Value<int> plannedSeconds;
  final Value<int> focusedSeconds;
  final Value<String?> goalId;
  final Value<String?> taskId;
  final Value<int?> startMoodScore;
  final Value<int?> endMoodScore;
  final Value<bool?> wasDistracted;
  final Value<int?> distractionMinutes;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const PomodoroSessionRecordsCompanion({
    this.id = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.plannedSeconds = const Value.absent(),
    this.focusedSeconds = const Value.absent(),
    this.goalId = const Value.absent(),
    this.taskId = const Value.absent(),
    this.startMoodScore = const Value.absent(),
    this.endMoodScore = const Value.absent(),
    this.wasDistracted = const Value.absent(),
    this.distractionMinutes = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PomodoroSessionRecordsCompanion.insert({
    required String id,
    required DateTime startedAt,
    required DateTime endedAt,
    required int plannedSeconds,
    required int focusedSeconds,
    this.goalId = const Value.absent(),
    this.taskId = const Value.absent(),
    this.startMoodScore = const Value.absent(),
    this.endMoodScore = const Value.absent(),
    this.wasDistracted = const Value.absent(),
    this.distractionMinutes = const Value.absent(),
    required String status,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       startedAt = Value(startedAt),
       endedAt = Value(endedAt),
       plannedSeconds = Value(plannedSeconds),
       focusedSeconds = Value(focusedSeconds),
       status = Value(status),
       createdAt = Value(createdAt);
  static Insertable<PomodoroSessionRecord> custom({
    Expression<String>? id,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<int>? plannedSeconds,
    Expression<int>? focusedSeconds,
    Expression<String>? goalId,
    Expression<String>? taskId,
    Expression<int>? startMoodScore,
    Expression<int>? endMoodScore,
    Expression<bool>? wasDistracted,
    Expression<int>? distractionMinutes,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (plannedSeconds != null) 'planned_seconds': plannedSeconds,
      if (focusedSeconds != null) 'focused_seconds': focusedSeconds,
      if (goalId != null) 'goal_id': goalId,
      if (taskId != null) 'task_id': taskId,
      if (startMoodScore != null) 'start_mood_score': startMoodScore,
      if (endMoodScore != null) 'end_mood_score': endMoodScore,
      if (wasDistracted != null) 'was_distracted': wasDistracted,
      if (distractionMinutes != null) 'distraction_minutes': distractionMinutes,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PomodoroSessionRecordsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? startedAt,
    Value<DateTime>? endedAt,
    Value<int>? plannedSeconds,
    Value<int>? focusedSeconds,
    Value<String?>? goalId,
    Value<String?>? taskId,
    Value<int?>? startMoodScore,
    Value<int?>? endMoodScore,
    Value<bool?>? wasDistracted,
    Value<int?>? distractionMinutes,
    Value<String>? status,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return PomodoroSessionRecordsCompanion(
      id: id ?? this.id,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      plannedSeconds: plannedSeconds ?? this.plannedSeconds,
      focusedSeconds: focusedSeconds ?? this.focusedSeconds,
      goalId: goalId ?? this.goalId,
      taskId: taskId ?? this.taskId,
      startMoodScore: startMoodScore ?? this.startMoodScore,
      endMoodScore: endMoodScore ?? this.endMoodScore,
      wasDistracted: wasDistracted ?? this.wasDistracted,
      distractionMinutes: distractionMinutes ?? this.distractionMinutes,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (plannedSeconds.present) {
      map['planned_seconds'] = Variable<int>(plannedSeconds.value);
    }
    if (focusedSeconds.present) {
      map['focused_seconds'] = Variable<int>(focusedSeconds.value);
    }
    if (goalId.present) {
      map['goal_id'] = Variable<String>(goalId.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (startMoodScore.present) {
      map['start_mood_score'] = Variable<int>(startMoodScore.value);
    }
    if (endMoodScore.present) {
      map['end_mood_score'] = Variable<int>(endMoodScore.value);
    }
    if (wasDistracted.present) {
      map['was_distracted'] = Variable<bool>(wasDistracted.value);
    }
    if (distractionMinutes.present) {
      map['distraction_minutes'] = Variable<int>(distractionMinutes.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PomodoroSessionRecordsCompanion(')
          ..write('id: $id, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('plannedSeconds: $plannedSeconds, ')
          ..write('focusedSeconds: $focusedSeconds, ')
          ..write('goalId: $goalId, ')
          ..write('taskId: $taskId, ')
          ..write('startMoodScore: $startMoodScore, ')
          ..write('endMoodScore: $endMoodScore, ')
          ..write('wasDistracted: $wasDistracted, ')
          ..write('distractionMinutes: $distractionMinutes, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PomodoroRuntimeRecordsTable extends PomodoroRuntimeRecords
    with TableInfo<$PomodoroRuntimeRecordsTable, PomodoroRuntimeRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PomodoroRuntimeRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
    'task_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tasks (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _taskTitleMeta = const VerificationMeta(
    'taskTitle',
  );
  @override
  late final GeneratedColumn<String> taskTitle = GeneratedColumn<String>(
    'task_title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _goalIdMeta = const VerificationMeta('goalId');
  @override
  late final GeneratedColumn<String> goalId = GeneratedColumn<String>(
    'goal_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES goals (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _taskEstimatedMinutesMeta =
      const VerificationMeta('taskEstimatedMinutes');
  @override
  late final GeneratedColumn<int> taskEstimatedMinutes = GeneratedColumn<int>(
    'task_estimated_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phaseMeta = const VerificationMeta('phase');
  @override
  late final GeneratedColumn<String> phase = GeneratedColumn<String>(
    'phase',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isRunningMeta = const VerificationMeta(
    'isRunning',
  );
  @override
  late final GeneratedColumn<bool> isRunning = GeneratedColumn<bool>(
    'is_running',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_running" IN (0, 1))',
    ),
  );
  static const VerificationMeta _remainingSecondsMeta = const VerificationMeta(
    'remainingSeconds',
  );
  @override
  late final GeneratedColumn<int> remainingSeconds = GeneratedColumn<int>(
    'remaining_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phaseTotalSecondsMeta = const VerificationMeta(
    'phaseTotalSeconds',
  );
  @override
  late final GeneratedColumn<int> phaseTotalSeconds = GeneratedColumn<int>(
    'phase_total_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cadenceFocusMinutesMeta =
      const VerificationMeta('cadenceFocusMinutes');
  @override
  late final GeneratedColumn<int> cadenceFocusMinutes = GeneratedColumn<int>(
    'cadence_focus_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cadenceBreakMinutesMeta =
      const VerificationMeta('cadenceBreakMinutes');
  @override
  late final GeneratedColumn<int> cadenceBreakMinutes = GeneratedColumn<int>(
    'cadence_break_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _longBreakMinutesMeta = const VerificationMeta(
    'longBreakMinutes',
  );
  @override
  late final GeneratedColumn<int> longBreakMinutes = GeneratedColumn<int>(
    'long_break_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _longBreakFrequencyMeta =
      const VerificationMeta('longBreakFrequency');
  @override
  late final GeneratedColumn<int> longBreakFrequency = GeneratedColumn<int>(
    'long_break_frequency',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _autoStartBreakMeta = const VerificationMeta(
    'autoStartBreak',
  );
  @override
  late final GeneratedColumn<bool> autoStartBreak = GeneratedColumn<bool>(
    'auto_start_break',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("auto_start_break" IN (0, 1))',
    ),
  );
  static const VerificationMeta _autoStartFocusMeta = const VerificationMeta(
    'autoStartFocus',
  );
  @override
  late final GeneratedColumn<bool> autoStartFocus = GeneratedColumn<bool>(
    'auto_start_focus',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("auto_start_focus" IN (0, 1))',
    ),
  );
  static const VerificationMeta _planModeMeta = const VerificationMeta(
    'planMode',
  );
  @override
  late final GeneratedColumn<String> planMode = GeneratedColumn<String>(
    'plan_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _blockIndexMeta = const VerificationMeta(
    'blockIndex',
  );
  @override
  late final GeneratedColumn<int> blockIndex = GeneratedColumn<int>(
    'block_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _blockCountMeta = const VerificationMeta(
    'blockCount',
  );
  @override
  late final GeneratedColumn<int> blockCount = GeneratedColumn<int>(
    'block_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taskFocusedSecondsAtStartMeta =
      const VerificationMeta('taskFocusedSecondsAtStart');
  @override
  late final GeneratedColumn<int> taskFocusedSecondsAtStart =
      GeneratedColumn<int>(
        'task_focused_seconds_at_start',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _focusStartedAtMeta = const VerificationMeta(
    'focusStartedAt',
  );
  @override
  late final GeneratedColumn<DateTime> focusStartedAt =
      GeneratedColumn<DateTime>(
        'focus_started_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _lastTickAtMeta = const VerificationMeta(
    'lastTickAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastTickAt = GeneratedColumn<DateTime>(
    'last_tick_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    taskId,
    taskTitle,
    goalId,
    taskEstimatedMinutes,
    phase,
    isRunning,
    remainingSeconds,
    phaseTotalSeconds,
    cadenceFocusMinutes,
    cadenceBreakMinutes,
    longBreakMinutes,
    longBreakFrequency,
    autoStartBreak,
    autoStartFocus,
    planMode,
    blockIndex,
    blockCount,
    taskFocusedSecondsAtStart,
    focusStartedAt,
    lastTickAt,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pomodoro_runtime';
  @override
  VerificationContext validateIntegrity(
    Insertable<PomodoroRuntimeRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    }
    if (data.containsKey('task_title')) {
      context.handle(
        _taskTitleMeta,
        taskTitle.isAcceptableOrUnknown(data['task_title']!, _taskTitleMeta),
      );
    }
    if (data.containsKey('goal_id')) {
      context.handle(
        _goalIdMeta,
        goalId.isAcceptableOrUnknown(data['goal_id']!, _goalIdMeta),
      );
    }
    if (data.containsKey('task_estimated_minutes')) {
      context.handle(
        _taskEstimatedMinutesMeta,
        taskEstimatedMinutes.isAcceptableOrUnknown(
          data['task_estimated_minutes']!,
          _taskEstimatedMinutesMeta,
        ),
      );
    }
    if (data.containsKey('phase')) {
      context.handle(
        _phaseMeta,
        phase.isAcceptableOrUnknown(data['phase']!, _phaseMeta),
      );
    } else if (isInserting) {
      context.missing(_phaseMeta);
    }
    if (data.containsKey('is_running')) {
      context.handle(
        _isRunningMeta,
        isRunning.isAcceptableOrUnknown(data['is_running']!, _isRunningMeta),
      );
    } else if (isInserting) {
      context.missing(_isRunningMeta);
    }
    if (data.containsKey('remaining_seconds')) {
      context.handle(
        _remainingSecondsMeta,
        remainingSeconds.isAcceptableOrUnknown(
          data['remaining_seconds']!,
          _remainingSecondsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_remainingSecondsMeta);
    }
    if (data.containsKey('phase_total_seconds')) {
      context.handle(
        _phaseTotalSecondsMeta,
        phaseTotalSeconds.isAcceptableOrUnknown(
          data['phase_total_seconds']!,
          _phaseTotalSecondsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_phaseTotalSecondsMeta);
    }
    if (data.containsKey('cadence_focus_minutes')) {
      context.handle(
        _cadenceFocusMinutesMeta,
        cadenceFocusMinutes.isAcceptableOrUnknown(
          data['cadence_focus_minutes']!,
          _cadenceFocusMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_cadenceFocusMinutesMeta);
    }
    if (data.containsKey('cadence_break_minutes')) {
      context.handle(
        _cadenceBreakMinutesMeta,
        cadenceBreakMinutes.isAcceptableOrUnknown(
          data['cadence_break_minutes']!,
          _cadenceBreakMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_cadenceBreakMinutesMeta);
    }
    if (data.containsKey('long_break_minutes')) {
      context.handle(
        _longBreakMinutesMeta,
        longBreakMinutes.isAcceptableOrUnknown(
          data['long_break_minutes']!,
          _longBreakMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_longBreakMinutesMeta);
    }
    if (data.containsKey('long_break_frequency')) {
      context.handle(
        _longBreakFrequencyMeta,
        longBreakFrequency.isAcceptableOrUnknown(
          data['long_break_frequency']!,
          _longBreakFrequencyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_longBreakFrequencyMeta);
    }
    if (data.containsKey('auto_start_break')) {
      context.handle(
        _autoStartBreakMeta,
        autoStartBreak.isAcceptableOrUnknown(
          data['auto_start_break']!,
          _autoStartBreakMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_autoStartBreakMeta);
    }
    if (data.containsKey('auto_start_focus')) {
      context.handle(
        _autoStartFocusMeta,
        autoStartFocus.isAcceptableOrUnknown(
          data['auto_start_focus']!,
          _autoStartFocusMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_autoStartFocusMeta);
    }
    if (data.containsKey('plan_mode')) {
      context.handle(
        _planModeMeta,
        planMode.isAcceptableOrUnknown(data['plan_mode']!, _planModeMeta),
      );
    } else if (isInserting) {
      context.missing(_planModeMeta);
    }
    if (data.containsKey('block_index')) {
      context.handle(
        _blockIndexMeta,
        blockIndex.isAcceptableOrUnknown(data['block_index']!, _blockIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_blockIndexMeta);
    }
    if (data.containsKey('block_count')) {
      context.handle(
        _blockCountMeta,
        blockCount.isAcceptableOrUnknown(data['block_count']!, _blockCountMeta),
      );
    } else if (isInserting) {
      context.missing(_blockCountMeta);
    }
    if (data.containsKey('task_focused_seconds_at_start')) {
      context.handle(
        _taskFocusedSecondsAtStartMeta,
        taskFocusedSecondsAtStart.isAcceptableOrUnknown(
          data['task_focused_seconds_at_start']!,
          _taskFocusedSecondsAtStartMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_taskFocusedSecondsAtStartMeta);
    }
    if (data.containsKey('focus_started_at')) {
      context.handle(
        _focusStartedAtMeta,
        focusStartedAt.isAcceptableOrUnknown(
          data['focus_started_at']!,
          _focusStartedAtMeta,
        ),
      );
    }
    if (data.containsKey('last_tick_at')) {
      context.handle(
        _lastTickAtMeta,
        lastTickAt.isAcceptableOrUnknown(
          data['last_tick_at']!,
          _lastTickAtMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PomodoroRuntimeRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PomodoroRuntimeRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_id'],
      ),
      taskTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_title'],
      ),
      goalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}goal_id'],
      ),
      taskEstimatedMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}task_estimated_minutes'],
      ),
      phase: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phase'],
      )!,
      isRunning: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_running'],
      )!,
      remainingSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}remaining_seconds'],
      )!,
      phaseTotalSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}phase_total_seconds'],
      )!,
      cadenceFocusMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cadence_focus_minutes'],
      )!,
      cadenceBreakMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cadence_break_minutes'],
      )!,
      longBreakMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}long_break_minutes'],
      )!,
      longBreakFrequency: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}long_break_frequency'],
      )!,
      autoStartBreak: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}auto_start_break'],
      )!,
      autoStartFocus: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}auto_start_focus'],
      )!,
      planMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plan_mode'],
      )!,
      blockIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}block_index'],
      )!,
      blockCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}block_count'],
      )!,
      taskFocusedSecondsAtStart: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}task_focused_seconds_at_start'],
      )!,
      focusStartedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}focus_started_at'],
      ),
      lastTickAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_tick_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PomodoroRuntimeRecordsTable createAlias(String alias) {
    return $PomodoroRuntimeRecordsTable(attachedDatabase, alias);
  }
}

class PomodoroRuntimeRecord extends DataClass
    implements Insertable<PomodoroRuntimeRecord> {
  final String id;
  final String? taskId;
  final String? taskTitle;
  final String? goalId;
  final int? taskEstimatedMinutes;
  final String phase;
  final bool isRunning;
  final int remainingSeconds;
  final int phaseTotalSeconds;
  final int cadenceFocusMinutes;
  final int cadenceBreakMinutes;
  final int longBreakMinutes;
  final int longBreakFrequency;
  final bool autoStartBreak;
  final bool autoStartFocus;
  final String planMode;
  final int blockIndex;
  final int blockCount;
  final int taskFocusedSecondsAtStart;
  final DateTime? focusStartedAt;
  final DateTime? lastTickAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const PomodoroRuntimeRecord({
    required this.id,
    this.taskId,
    this.taskTitle,
    this.goalId,
    this.taskEstimatedMinutes,
    required this.phase,
    required this.isRunning,
    required this.remainingSeconds,
    required this.phaseTotalSeconds,
    required this.cadenceFocusMinutes,
    required this.cadenceBreakMinutes,
    required this.longBreakMinutes,
    required this.longBreakFrequency,
    required this.autoStartBreak,
    required this.autoStartFocus,
    required this.planMode,
    required this.blockIndex,
    required this.blockCount,
    required this.taskFocusedSecondsAtStart,
    this.focusStartedAt,
    this.lastTickAt,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || taskId != null) {
      map['task_id'] = Variable<String>(taskId);
    }
    if (!nullToAbsent || taskTitle != null) {
      map['task_title'] = Variable<String>(taskTitle);
    }
    if (!nullToAbsent || goalId != null) {
      map['goal_id'] = Variable<String>(goalId);
    }
    if (!nullToAbsent || taskEstimatedMinutes != null) {
      map['task_estimated_minutes'] = Variable<int>(taskEstimatedMinutes);
    }
    map['phase'] = Variable<String>(phase);
    map['is_running'] = Variable<bool>(isRunning);
    map['remaining_seconds'] = Variable<int>(remainingSeconds);
    map['phase_total_seconds'] = Variable<int>(phaseTotalSeconds);
    map['cadence_focus_minutes'] = Variable<int>(cadenceFocusMinutes);
    map['cadence_break_minutes'] = Variable<int>(cadenceBreakMinutes);
    map['long_break_minutes'] = Variable<int>(longBreakMinutes);
    map['long_break_frequency'] = Variable<int>(longBreakFrequency);
    map['auto_start_break'] = Variable<bool>(autoStartBreak);
    map['auto_start_focus'] = Variable<bool>(autoStartFocus);
    map['plan_mode'] = Variable<String>(planMode);
    map['block_index'] = Variable<int>(blockIndex);
    map['block_count'] = Variable<int>(blockCount);
    map['task_focused_seconds_at_start'] = Variable<int>(
      taskFocusedSecondsAtStart,
    );
    if (!nullToAbsent || focusStartedAt != null) {
      map['focus_started_at'] = Variable<DateTime>(focusStartedAt);
    }
    if (!nullToAbsent || lastTickAt != null) {
      map['last_tick_at'] = Variable<DateTime>(lastTickAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PomodoroRuntimeRecordsCompanion toCompanion(bool nullToAbsent) {
    return PomodoroRuntimeRecordsCompanion(
      id: Value(id),
      taskId: taskId == null && nullToAbsent
          ? const Value.absent()
          : Value(taskId),
      taskTitle: taskTitle == null && nullToAbsent
          ? const Value.absent()
          : Value(taskTitle),
      goalId: goalId == null && nullToAbsent
          ? const Value.absent()
          : Value(goalId),
      taskEstimatedMinutes: taskEstimatedMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(taskEstimatedMinutes),
      phase: Value(phase),
      isRunning: Value(isRunning),
      remainingSeconds: Value(remainingSeconds),
      phaseTotalSeconds: Value(phaseTotalSeconds),
      cadenceFocusMinutes: Value(cadenceFocusMinutes),
      cadenceBreakMinutes: Value(cadenceBreakMinutes),
      longBreakMinutes: Value(longBreakMinutes),
      longBreakFrequency: Value(longBreakFrequency),
      autoStartBreak: Value(autoStartBreak),
      autoStartFocus: Value(autoStartFocus),
      planMode: Value(planMode),
      blockIndex: Value(blockIndex),
      blockCount: Value(blockCount),
      taskFocusedSecondsAtStart: Value(taskFocusedSecondsAtStart),
      focusStartedAt: focusStartedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(focusStartedAt),
      lastTickAt: lastTickAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastTickAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory PomodoroRuntimeRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PomodoroRuntimeRecord(
      id: serializer.fromJson<String>(json['id']),
      taskId: serializer.fromJson<String?>(json['taskId']),
      taskTitle: serializer.fromJson<String?>(json['taskTitle']),
      goalId: serializer.fromJson<String?>(json['goalId']),
      taskEstimatedMinutes: serializer.fromJson<int?>(
        json['taskEstimatedMinutes'],
      ),
      phase: serializer.fromJson<String>(json['phase']),
      isRunning: serializer.fromJson<bool>(json['isRunning']),
      remainingSeconds: serializer.fromJson<int>(json['remainingSeconds']),
      phaseTotalSeconds: serializer.fromJson<int>(json['phaseTotalSeconds']),
      cadenceFocusMinutes: serializer.fromJson<int>(
        json['cadenceFocusMinutes'],
      ),
      cadenceBreakMinutes: serializer.fromJson<int>(
        json['cadenceBreakMinutes'],
      ),
      longBreakMinutes: serializer.fromJson<int>(json['longBreakMinutes']),
      longBreakFrequency: serializer.fromJson<int>(json['longBreakFrequency']),
      autoStartBreak: serializer.fromJson<bool>(json['autoStartBreak']),
      autoStartFocus: serializer.fromJson<bool>(json['autoStartFocus']),
      planMode: serializer.fromJson<String>(json['planMode']),
      blockIndex: serializer.fromJson<int>(json['blockIndex']),
      blockCount: serializer.fromJson<int>(json['blockCount']),
      taskFocusedSecondsAtStart: serializer.fromJson<int>(
        json['taskFocusedSecondsAtStart'],
      ),
      focusStartedAt: serializer.fromJson<DateTime?>(json['focusStartedAt']),
      lastTickAt: serializer.fromJson<DateTime?>(json['lastTickAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'taskId': serializer.toJson<String?>(taskId),
      'taskTitle': serializer.toJson<String?>(taskTitle),
      'goalId': serializer.toJson<String?>(goalId),
      'taskEstimatedMinutes': serializer.toJson<int?>(taskEstimatedMinutes),
      'phase': serializer.toJson<String>(phase),
      'isRunning': serializer.toJson<bool>(isRunning),
      'remainingSeconds': serializer.toJson<int>(remainingSeconds),
      'phaseTotalSeconds': serializer.toJson<int>(phaseTotalSeconds),
      'cadenceFocusMinutes': serializer.toJson<int>(cadenceFocusMinutes),
      'cadenceBreakMinutes': serializer.toJson<int>(cadenceBreakMinutes),
      'longBreakMinutes': serializer.toJson<int>(longBreakMinutes),
      'longBreakFrequency': serializer.toJson<int>(longBreakFrequency),
      'autoStartBreak': serializer.toJson<bool>(autoStartBreak),
      'autoStartFocus': serializer.toJson<bool>(autoStartFocus),
      'planMode': serializer.toJson<String>(planMode),
      'blockIndex': serializer.toJson<int>(blockIndex),
      'blockCount': serializer.toJson<int>(blockCount),
      'taskFocusedSecondsAtStart': serializer.toJson<int>(
        taskFocusedSecondsAtStart,
      ),
      'focusStartedAt': serializer.toJson<DateTime?>(focusStartedAt),
      'lastTickAt': serializer.toJson<DateTime?>(lastTickAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PomodoroRuntimeRecord copyWith({
    String? id,
    Value<String?> taskId = const Value.absent(),
    Value<String?> taskTitle = const Value.absent(),
    Value<String?> goalId = const Value.absent(),
    Value<int?> taskEstimatedMinutes = const Value.absent(),
    String? phase,
    bool? isRunning,
    int? remainingSeconds,
    int? phaseTotalSeconds,
    int? cadenceFocusMinutes,
    int? cadenceBreakMinutes,
    int? longBreakMinutes,
    int? longBreakFrequency,
    bool? autoStartBreak,
    bool? autoStartFocus,
    String? planMode,
    int? blockIndex,
    int? blockCount,
    int? taskFocusedSecondsAtStart,
    Value<DateTime?> focusStartedAt = const Value.absent(),
    Value<DateTime?> lastTickAt = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => PomodoroRuntimeRecord(
    id: id ?? this.id,
    taskId: taskId.present ? taskId.value : this.taskId,
    taskTitle: taskTitle.present ? taskTitle.value : this.taskTitle,
    goalId: goalId.present ? goalId.value : this.goalId,
    taskEstimatedMinutes: taskEstimatedMinutes.present
        ? taskEstimatedMinutes.value
        : this.taskEstimatedMinutes,
    phase: phase ?? this.phase,
    isRunning: isRunning ?? this.isRunning,
    remainingSeconds: remainingSeconds ?? this.remainingSeconds,
    phaseTotalSeconds: phaseTotalSeconds ?? this.phaseTotalSeconds,
    cadenceFocusMinutes: cadenceFocusMinutes ?? this.cadenceFocusMinutes,
    cadenceBreakMinutes: cadenceBreakMinutes ?? this.cadenceBreakMinutes,
    longBreakMinutes: longBreakMinutes ?? this.longBreakMinutes,
    longBreakFrequency: longBreakFrequency ?? this.longBreakFrequency,
    autoStartBreak: autoStartBreak ?? this.autoStartBreak,
    autoStartFocus: autoStartFocus ?? this.autoStartFocus,
    planMode: planMode ?? this.planMode,
    blockIndex: blockIndex ?? this.blockIndex,
    blockCount: blockCount ?? this.blockCount,
    taskFocusedSecondsAtStart:
        taskFocusedSecondsAtStart ?? this.taskFocusedSecondsAtStart,
    focusStartedAt: focusStartedAt.present
        ? focusStartedAt.value
        : this.focusStartedAt,
    lastTickAt: lastTickAt.present ? lastTickAt.value : this.lastTickAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  PomodoroRuntimeRecord copyWithCompanion(
    PomodoroRuntimeRecordsCompanion data,
  ) {
    return PomodoroRuntimeRecord(
      id: data.id.present ? data.id.value : this.id,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      taskTitle: data.taskTitle.present ? data.taskTitle.value : this.taskTitle,
      goalId: data.goalId.present ? data.goalId.value : this.goalId,
      taskEstimatedMinutes: data.taskEstimatedMinutes.present
          ? data.taskEstimatedMinutes.value
          : this.taskEstimatedMinutes,
      phase: data.phase.present ? data.phase.value : this.phase,
      isRunning: data.isRunning.present ? data.isRunning.value : this.isRunning,
      remainingSeconds: data.remainingSeconds.present
          ? data.remainingSeconds.value
          : this.remainingSeconds,
      phaseTotalSeconds: data.phaseTotalSeconds.present
          ? data.phaseTotalSeconds.value
          : this.phaseTotalSeconds,
      cadenceFocusMinutes: data.cadenceFocusMinutes.present
          ? data.cadenceFocusMinutes.value
          : this.cadenceFocusMinutes,
      cadenceBreakMinutes: data.cadenceBreakMinutes.present
          ? data.cadenceBreakMinutes.value
          : this.cadenceBreakMinutes,
      longBreakMinutes: data.longBreakMinutes.present
          ? data.longBreakMinutes.value
          : this.longBreakMinutes,
      longBreakFrequency: data.longBreakFrequency.present
          ? data.longBreakFrequency.value
          : this.longBreakFrequency,
      autoStartBreak: data.autoStartBreak.present
          ? data.autoStartBreak.value
          : this.autoStartBreak,
      autoStartFocus: data.autoStartFocus.present
          ? data.autoStartFocus.value
          : this.autoStartFocus,
      planMode: data.planMode.present ? data.planMode.value : this.planMode,
      blockIndex: data.blockIndex.present
          ? data.blockIndex.value
          : this.blockIndex,
      blockCount: data.blockCount.present
          ? data.blockCount.value
          : this.blockCount,
      taskFocusedSecondsAtStart: data.taskFocusedSecondsAtStart.present
          ? data.taskFocusedSecondsAtStart.value
          : this.taskFocusedSecondsAtStart,
      focusStartedAt: data.focusStartedAt.present
          ? data.focusStartedAt.value
          : this.focusStartedAt,
      lastTickAt: data.lastTickAt.present
          ? data.lastTickAt.value
          : this.lastTickAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PomodoroRuntimeRecord(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('taskTitle: $taskTitle, ')
          ..write('goalId: $goalId, ')
          ..write('taskEstimatedMinutes: $taskEstimatedMinutes, ')
          ..write('phase: $phase, ')
          ..write('isRunning: $isRunning, ')
          ..write('remainingSeconds: $remainingSeconds, ')
          ..write('phaseTotalSeconds: $phaseTotalSeconds, ')
          ..write('cadenceFocusMinutes: $cadenceFocusMinutes, ')
          ..write('cadenceBreakMinutes: $cadenceBreakMinutes, ')
          ..write('longBreakMinutes: $longBreakMinutes, ')
          ..write('longBreakFrequency: $longBreakFrequency, ')
          ..write('autoStartBreak: $autoStartBreak, ')
          ..write('autoStartFocus: $autoStartFocus, ')
          ..write('planMode: $planMode, ')
          ..write('blockIndex: $blockIndex, ')
          ..write('blockCount: $blockCount, ')
          ..write('taskFocusedSecondsAtStart: $taskFocusedSecondsAtStart, ')
          ..write('focusStartedAt: $focusStartedAt, ')
          ..write('lastTickAt: $lastTickAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    taskId,
    taskTitle,
    goalId,
    taskEstimatedMinutes,
    phase,
    isRunning,
    remainingSeconds,
    phaseTotalSeconds,
    cadenceFocusMinutes,
    cadenceBreakMinutes,
    longBreakMinutes,
    longBreakFrequency,
    autoStartBreak,
    autoStartFocus,
    planMode,
    blockIndex,
    blockCount,
    taskFocusedSecondsAtStart,
    focusStartedAt,
    lastTickAt,
    createdAt,
    updatedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PomodoroRuntimeRecord &&
          other.id == this.id &&
          other.taskId == this.taskId &&
          other.taskTitle == this.taskTitle &&
          other.goalId == this.goalId &&
          other.taskEstimatedMinutes == this.taskEstimatedMinutes &&
          other.phase == this.phase &&
          other.isRunning == this.isRunning &&
          other.remainingSeconds == this.remainingSeconds &&
          other.phaseTotalSeconds == this.phaseTotalSeconds &&
          other.cadenceFocusMinutes == this.cadenceFocusMinutes &&
          other.cadenceBreakMinutes == this.cadenceBreakMinutes &&
          other.longBreakMinutes == this.longBreakMinutes &&
          other.longBreakFrequency == this.longBreakFrequency &&
          other.autoStartBreak == this.autoStartBreak &&
          other.autoStartFocus == this.autoStartFocus &&
          other.planMode == this.planMode &&
          other.blockIndex == this.blockIndex &&
          other.blockCount == this.blockCount &&
          other.taskFocusedSecondsAtStart == this.taskFocusedSecondsAtStart &&
          other.focusStartedAt == this.focusStartedAt &&
          other.lastTickAt == this.lastTickAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PomodoroRuntimeRecordsCompanion
    extends UpdateCompanion<PomodoroRuntimeRecord> {
  final Value<String> id;
  final Value<String?> taskId;
  final Value<String?> taskTitle;
  final Value<String?> goalId;
  final Value<int?> taskEstimatedMinutes;
  final Value<String> phase;
  final Value<bool> isRunning;
  final Value<int> remainingSeconds;
  final Value<int> phaseTotalSeconds;
  final Value<int> cadenceFocusMinutes;
  final Value<int> cadenceBreakMinutes;
  final Value<int> longBreakMinutes;
  final Value<int> longBreakFrequency;
  final Value<bool> autoStartBreak;
  final Value<bool> autoStartFocus;
  final Value<String> planMode;
  final Value<int> blockIndex;
  final Value<int> blockCount;
  final Value<int> taskFocusedSecondsAtStart;
  final Value<DateTime?> focusStartedAt;
  final Value<DateTime?> lastTickAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const PomodoroRuntimeRecordsCompanion({
    this.id = const Value.absent(),
    this.taskId = const Value.absent(),
    this.taskTitle = const Value.absent(),
    this.goalId = const Value.absent(),
    this.taskEstimatedMinutes = const Value.absent(),
    this.phase = const Value.absent(),
    this.isRunning = const Value.absent(),
    this.remainingSeconds = const Value.absent(),
    this.phaseTotalSeconds = const Value.absent(),
    this.cadenceFocusMinutes = const Value.absent(),
    this.cadenceBreakMinutes = const Value.absent(),
    this.longBreakMinutes = const Value.absent(),
    this.longBreakFrequency = const Value.absent(),
    this.autoStartBreak = const Value.absent(),
    this.autoStartFocus = const Value.absent(),
    this.planMode = const Value.absent(),
    this.blockIndex = const Value.absent(),
    this.blockCount = const Value.absent(),
    this.taskFocusedSecondsAtStart = const Value.absent(),
    this.focusStartedAt = const Value.absent(),
    this.lastTickAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PomodoroRuntimeRecordsCompanion.insert({
    required String id,
    this.taskId = const Value.absent(),
    this.taskTitle = const Value.absent(),
    this.goalId = const Value.absent(),
    this.taskEstimatedMinutes = const Value.absent(),
    required String phase,
    required bool isRunning,
    required int remainingSeconds,
    required int phaseTotalSeconds,
    required int cadenceFocusMinutes,
    required int cadenceBreakMinutes,
    required int longBreakMinutes,
    required int longBreakFrequency,
    required bool autoStartBreak,
    required bool autoStartFocus,
    required String planMode,
    required int blockIndex,
    required int blockCount,
    required int taskFocusedSecondsAtStart,
    this.focusStartedAt = const Value.absent(),
    this.lastTickAt = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       phase = Value(phase),
       isRunning = Value(isRunning),
       remainingSeconds = Value(remainingSeconds),
       phaseTotalSeconds = Value(phaseTotalSeconds),
       cadenceFocusMinutes = Value(cadenceFocusMinutes),
       cadenceBreakMinutes = Value(cadenceBreakMinutes),
       longBreakMinutes = Value(longBreakMinutes),
       longBreakFrequency = Value(longBreakFrequency),
       autoStartBreak = Value(autoStartBreak),
       autoStartFocus = Value(autoStartFocus),
       planMode = Value(planMode),
       blockIndex = Value(blockIndex),
       blockCount = Value(blockCount),
       taskFocusedSecondsAtStart = Value(taskFocusedSecondsAtStart),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<PomodoroRuntimeRecord> custom({
    Expression<String>? id,
    Expression<String>? taskId,
    Expression<String>? taskTitle,
    Expression<String>? goalId,
    Expression<int>? taskEstimatedMinutes,
    Expression<String>? phase,
    Expression<bool>? isRunning,
    Expression<int>? remainingSeconds,
    Expression<int>? phaseTotalSeconds,
    Expression<int>? cadenceFocusMinutes,
    Expression<int>? cadenceBreakMinutes,
    Expression<int>? longBreakMinutes,
    Expression<int>? longBreakFrequency,
    Expression<bool>? autoStartBreak,
    Expression<bool>? autoStartFocus,
    Expression<String>? planMode,
    Expression<int>? blockIndex,
    Expression<int>? blockCount,
    Expression<int>? taskFocusedSecondsAtStart,
    Expression<DateTime>? focusStartedAt,
    Expression<DateTime>? lastTickAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (taskId != null) 'task_id': taskId,
      if (taskTitle != null) 'task_title': taskTitle,
      if (goalId != null) 'goal_id': goalId,
      if (taskEstimatedMinutes != null)
        'task_estimated_minutes': taskEstimatedMinutes,
      if (phase != null) 'phase': phase,
      if (isRunning != null) 'is_running': isRunning,
      if (remainingSeconds != null) 'remaining_seconds': remainingSeconds,
      if (phaseTotalSeconds != null) 'phase_total_seconds': phaseTotalSeconds,
      if (cadenceFocusMinutes != null)
        'cadence_focus_minutes': cadenceFocusMinutes,
      if (cadenceBreakMinutes != null)
        'cadence_break_minutes': cadenceBreakMinutes,
      if (longBreakMinutes != null) 'long_break_minutes': longBreakMinutes,
      if (longBreakFrequency != null)
        'long_break_frequency': longBreakFrequency,
      if (autoStartBreak != null) 'auto_start_break': autoStartBreak,
      if (autoStartFocus != null) 'auto_start_focus': autoStartFocus,
      if (planMode != null) 'plan_mode': planMode,
      if (blockIndex != null) 'block_index': blockIndex,
      if (blockCount != null) 'block_count': blockCount,
      if (taskFocusedSecondsAtStart != null)
        'task_focused_seconds_at_start': taskFocusedSecondsAtStart,
      if (focusStartedAt != null) 'focus_started_at': focusStartedAt,
      if (lastTickAt != null) 'last_tick_at': lastTickAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PomodoroRuntimeRecordsCompanion copyWith({
    Value<String>? id,
    Value<String?>? taskId,
    Value<String?>? taskTitle,
    Value<String?>? goalId,
    Value<int?>? taskEstimatedMinutes,
    Value<String>? phase,
    Value<bool>? isRunning,
    Value<int>? remainingSeconds,
    Value<int>? phaseTotalSeconds,
    Value<int>? cadenceFocusMinutes,
    Value<int>? cadenceBreakMinutes,
    Value<int>? longBreakMinutes,
    Value<int>? longBreakFrequency,
    Value<bool>? autoStartBreak,
    Value<bool>? autoStartFocus,
    Value<String>? planMode,
    Value<int>? blockIndex,
    Value<int>? blockCount,
    Value<int>? taskFocusedSecondsAtStart,
    Value<DateTime?>? focusStartedAt,
    Value<DateTime?>? lastTickAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return PomodoroRuntimeRecordsCompanion(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      taskTitle: taskTitle ?? this.taskTitle,
      goalId: goalId ?? this.goalId,
      taskEstimatedMinutes: taskEstimatedMinutes ?? this.taskEstimatedMinutes,
      phase: phase ?? this.phase,
      isRunning: isRunning ?? this.isRunning,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      phaseTotalSeconds: phaseTotalSeconds ?? this.phaseTotalSeconds,
      cadenceFocusMinutes: cadenceFocusMinutes ?? this.cadenceFocusMinutes,
      cadenceBreakMinutes: cadenceBreakMinutes ?? this.cadenceBreakMinutes,
      longBreakMinutes: longBreakMinutes ?? this.longBreakMinutes,
      longBreakFrequency: longBreakFrequency ?? this.longBreakFrequency,
      autoStartBreak: autoStartBreak ?? this.autoStartBreak,
      autoStartFocus: autoStartFocus ?? this.autoStartFocus,
      planMode: planMode ?? this.planMode,
      blockIndex: blockIndex ?? this.blockIndex,
      blockCount: blockCount ?? this.blockCount,
      taskFocusedSecondsAtStart:
          taskFocusedSecondsAtStart ?? this.taskFocusedSecondsAtStart,
      focusStartedAt: focusStartedAt ?? this.focusStartedAt,
      lastTickAt: lastTickAt ?? this.lastTickAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (taskTitle.present) {
      map['task_title'] = Variable<String>(taskTitle.value);
    }
    if (goalId.present) {
      map['goal_id'] = Variable<String>(goalId.value);
    }
    if (taskEstimatedMinutes.present) {
      map['task_estimated_minutes'] = Variable<int>(taskEstimatedMinutes.value);
    }
    if (phase.present) {
      map['phase'] = Variable<String>(phase.value);
    }
    if (isRunning.present) {
      map['is_running'] = Variable<bool>(isRunning.value);
    }
    if (remainingSeconds.present) {
      map['remaining_seconds'] = Variable<int>(remainingSeconds.value);
    }
    if (phaseTotalSeconds.present) {
      map['phase_total_seconds'] = Variable<int>(phaseTotalSeconds.value);
    }
    if (cadenceFocusMinutes.present) {
      map['cadence_focus_minutes'] = Variable<int>(cadenceFocusMinutes.value);
    }
    if (cadenceBreakMinutes.present) {
      map['cadence_break_minutes'] = Variable<int>(cadenceBreakMinutes.value);
    }
    if (longBreakMinutes.present) {
      map['long_break_minutes'] = Variable<int>(longBreakMinutes.value);
    }
    if (longBreakFrequency.present) {
      map['long_break_frequency'] = Variable<int>(longBreakFrequency.value);
    }
    if (autoStartBreak.present) {
      map['auto_start_break'] = Variable<bool>(autoStartBreak.value);
    }
    if (autoStartFocus.present) {
      map['auto_start_focus'] = Variable<bool>(autoStartFocus.value);
    }
    if (planMode.present) {
      map['plan_mode'] = Variable<String>(planMode.value);
    }
    if (blockIndex.present) {
      map['block_index'] = Variable<int>(blockIndex.value);
    }
    if (blockCount.present) {
      map['block_count'] = Variable<int>(blockCount.value);
    }
    if (taskFocusedSecondsAtStart.present) {
      map['task_focused_seconds_at_start'] = Variable<int>(
        taskFocusedSecondsAtStart.value,
      );
    }
    if (focusStartedAt.present) {
      map['focus_started_at'] = Variable<DateTime>(focusStartedAt.value);
    }
    if (lastTickAt.present) {
      map['last_tick_at'] = Variable<DateTime>(lastTickAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PomodoroRuntimeRecordsCompanion(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('taskTitle: $taskTitle, ')
          ..write('goalId: $goalId, ')
          ..write('taskEstimatedMinutes: $taskEstimatedMinutes, ')
          ..write('phase: $phase, ')
          ..write('isRunning: $isRunning, ')
          ..write('remainingSeconds: $remainingSeconds, ')
          ..write('phaseTotalSeconds: $phaseTotalSeconds, ')
          ..write('cadenceFocusMinutes: $cadenceFocusMinutes, ')
          ..write('cadenceBreakMinutes: $cadenceBreakMinutes, ')
          ..write('longBreakMinutes: $longBreakMinutes, ')
          ..write('longBreakFrequency: $longBreakFrequency, ')
          ..write('autoStartBreak: $autoStartBreak, ')
          ..write('autoStartFocus: $autoStartFocus, ')
          ..write('planMode: $planMode, ')
          ..write('blockIndex: $blockIndex, ')
          ..write('blockCount: $blockCount, ')
          ..write('taskFocusedSecondsAtStart: $taskFocusedSecondsAtStart, ')
          ..write('focusStartedAt: $focusStartedAt, ')
          ..write('lastTickAt: $lastTickAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CalendarEventRecordsTable extends CalendarEventRecords
    with TableInfo<$CalendarEventRecordsTable, CalendarEventRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CalendarEventRecordsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _scheduledAtMeta = const VerificationMeta(
    'scheduledAt',
  );
  @override
  late final GeneratedColumn<DateTime> scheduledAt = GeneratedColumn<DateTime>(
    'scheduled_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
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
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    scheduledAt,
    durationMinutes,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'calendar_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<CalendarEventRecord> instance, {
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
    if (data.containsKey('scheduled_at')) {
      context.handle(
        _scheduledAtMeta,
        scheduledAt.isAcceptableOrUnknown(
          data['scheduled_at']!,
          _scheduledAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scheduledAtMeta);
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
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CalendarEventRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CalendarEventRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      scheduledAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}scheduled_at'],
      )!,
      durationMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_minutes'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CalendarEventRecordsTable createAlias(String alias) {
    return $CalendarEventRecordsTable(attachedDatabase, alias);
  }
}

class CalendarEventRecord extends DataClass
    implements Insertable<CalendarEventRecord> {
  final String id;
  final String title;
  final DateTime scheduledAt;
  final int durationMinutes;
  final DateTime createdAt;
  const CalendarEventRecord({
    required this.id,
    required this.title,
    required this.scheduledAt,
    required this.durationMinutes,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['scheduled_at'] = Variable<DateTime>(scheduledAt);
    map['duration_minutes'] = Variable<int>(durationMinutes);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CalendarEventRecordsCompanion toCompanion(bool nullToAbsent) {
    return CalendarEventRecordsCompanion(
      id: Value(id),
      title: Value(title),
      scheduledAt: Value(scheduledAt),
      durationMinutes: Value(durationMinutes),
      createdAt: Value(createdAt),
    );
  }

  factory CalendarEventRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CalendarEventRecord(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      scheduledAt: serializer.fromJson<DateTime>(json['scheduledAt']),
      durationMinutes: serializer.fromJson<int>(json['durationMinutes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'scheduledAt': serializer.toJson<DateTime>(scheduledAt),
      'durationMinutes': serializer.toJson<int>(durationMinutes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CalendarEventRecord copyWith({
    String? id,
    String? title,
    DateTime? scheduledAt,
    int? durationMinutes,
    DateTime? createdAt,
  }) => CalendarEventRecord(
    id: id ?? this.id,
    title: title ?? this.title,
    scheduledAt: scheduledAt ?? this.scheduledAt,
    durationMinutes: durationMinutes ?? this.durationMinutes,
    createdAt: createdAt ?? this.createdAt,
  );
  CalendarEventRecord copyWithCompanion(CalendarEventRecordsCompanion data) {
    return CalendarEventRecord(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      scheduledAt: data.scheduledAt.present
          ? data.scheduledAt.value
          : this.scheduledAt,
      durationMinutes: data.durationMinutes.present
          ? data.durationMinutes.value
          : this.durationMinutes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CalendarEventRecord(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, scheduledAt, durationMinutes, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CalendarEventRecord &&
          other.id == this.id &&
          other.title == this.title &&
          other.scheduledAt == this.scheduledAt &&
          other.durationMinutes == this.durationMinutes &&
          other.createdAt == this.createdAt);
}

class CalendarEventRecordsCompanion
    extends UpdateCompanion<CalendarEventRecord> {
  final Value<String> id;
  final Value<String> title;
  final Value<DateTime> scheduledAt;
  final Value<int> durationMinutes;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const CalendarEventRecordsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.scheduledAt = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CalendarEventRecordsCompanion.insert({
    required String id,
    required String title,
    required DateTime scheduledAt,
    required int durationMinutes,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       scheduledAt = Value(scheduledAt),
       durationMinutes = Value(durationMinutes),
       createdAt = Value(createdAt);
  static Insertable<CalendarEventRecord> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<DateTime>? scheduledAt,
    Expression<int>? durationMinutes,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (scheduledAt != null) 'scheduled_at': scheduledAt,
      if (durationMinutes != null) 'duration_minutes': durationMinutes,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CalendarEventRecordsCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<DateTime>? scheduledAt,
    Value<int>? durationMinutes,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return CalendarEventRecordsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      createdAt: createdAt ?? this.createdAt,
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
    if (scheduledAt.present) {
      map['scheduled_at'] = Variable<DateTime>(scheduledAt.value);
    }
    if (durationMinutes.present) {
      map['duration_minutes'] = Variable<int>(durationMinutes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CalendarEventRecordsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$MichiFocusDatabase extends GeneratedDatabase {
  _$MichiFocusDatabase(QueryExecutor e) : super(e);
  $MichiFocusDatabaseManager get managers => $MichiFocusDatabaseManager(this);
  late final $GoalRecordsTable goalRecords = $GoalRecordsTable(this);
  late final $TaskRecordsTable taskRecords = $TaskRecordsTable(this);
  late final $TaskCompletionEventRecordsTable taskCompletionEventRecords =
      $TaskCompletionEventRecordsTable(this);
  late final $ReportingMetadataRecordsTable reportingMetadataRecords =
      $ReportingMetadataRecordsTable(this);
  late final $PomodoroSessionRecordsTable pomodoroSessionRecords =
      $PomodoroSessionRecordsTable(this);
  late final $PomodoroRuntimeRecordsTable pomodoroRuntimeRecords =
      $PomodoroRuntimeRecordsTable(this);
  late final $CalendarEventRecordsTable calendarEventRecords =
      $CalendarEventRecordsTable(this);
  late final Index tasksGoalIdIdx = Index(
    'tasks_goal_id_idx',
    'CREATE INDEX tasks_goal_id_idx ON tasks (goal_id)',
  );
  late final Index tasksScheduledDateIdx = Index(
    'tasks_scheduled_date_idx',
    'CREATE INDEX tasks_scheduled_date_idx ON tasks (scheduled_date)',
  );
  late final Index tasksCreatedAtIdx = Index(
    'tasks_created_at_idx',
    'CREATE INDEX tasks_created_at_idx ON tasks (created_at)',
  );
  late final Index taskCompletionEventsCompletedAtIdx = Index(
    'task_completion_events_completed_at_idx',
    'CREATE INDEX task_completion_events_completed_at_idx ON task_completion_events (completed_at)',
  );
  late final Index taskCompletionEventsTaskCompletedIdx = Index(
    'task_completion_events_task_completed_idx',
    'CREATE INDEX task_completion_events_task_completed_idx ON task_completion_events (task_id, completed_at)',
  );
  late final Index pomodoroSessionsGoalIdIdx = Index(
    'pomodoro_sessions_goal_id_idx',
    'CREATE INDEX pomodoro_sessions_goal_id_idx ON pomodoro_sessions (goal_id)',
  );
  late final Index pomodoroSessionsTaskIdIdx = Index(
    'pomodoro_sessions_task_id_idx',
    'CREATE INDEX pomodoro_sessions_task_id_idx ON pomodoro_sessions (task_id)',
  );
  late final Index pomodoroSessionsStartedAtIdx = Index(
    'pomodoro_sessions_started_at_idx',
    'CREATE INDEX pomodoro_sessions_started_at_idx ON pomodoro_sessions (started_at)',
  );
  late final Index pomodoroSessionsEndedAtIdx = Index(
    'pomodoro_sessions_ended_at_idx',
    'CREATE INDEX pomodoro_sessions_ended_at_idx ON pomodoro_sessions (ended_at)',
  );
  late final Index calendarEventsScheduledAtIdx = Index(
    'calendar_events_scheduled_at_idx',
    'CREATE INDEX calendar_events_scheduled_at_idx ON calendar_events (scheduled_at)',
  );
  late final GoalsDao goalsDao = GoalsDao(this as MichiFocusDatabase);
  late final TasksDao tasksDao = TasksDao(this as MichiFocusDatabase);
  late final PomodoroSessionsDao pomodoroSessionsDao = PomodoroSessionsDao(
    this as MichiFocusDatabase,
  );
  late final PomodoroRuntimeDao pomodoroRuntimeDao = PomodoroRuntimeDao(
    this as MichiFocusDatabase,
  );
  late final CalendarEventsDao calendarEventsDao = CalendarEventsDao(
    this as MichiFocusDatabase,
  );
  late final ReportsDao reportsDao = ReportsDao(this as MichiFocusDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    goalRecords,
    taskRecords,
    taskCompletionEventRecords,
    reportingMetadataRecords,
    pomodoroSessionRecords,
    pomodoroRuntimeRecords,
    calendarEventRecords,
    tasksGoalIdIdx,
    tasksScheduledDateIdx,
    tasksCreatedAtIdx,
    taskCompletionEventsCompletedAtIdx,
    taskCompletionEventsTaskCompletedIdx,
    pomodoroSessionsGoalIdIdx,
    pomodoroSessionsTaskIdIdx,
    pomodoroSessionsStartedAtIdx,
    pomodoroSessionsEndedAtIdx,
    calendarEventsScheduledAtIdx,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'goals',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('tasks', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'tasks',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('task_completion_events', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'goals',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('pomodoro_sessions', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'tasks',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('pomodoro_sessions', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'goals',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('pomodoro_runtime', kind: UpdateKind.update)],
    ),
  ]);
}

typedef $$GoalRecordsTableCreateCompanionBuilder =
    GoalRecordsCompanion Function({
      required String id,
      required String title,
      required int targetSessions,
      Value<int> completedSessions,
      Value<DateTime?> targetDate,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$GoalRecordsTableUpdateCompanionBuilder =
    GoalRecordsCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<int> targetSessions,
      Value<int> completedSessions,
      Value<DateTime?> targetDate,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$GoalRecordsTableReferences
    extends
        BaseReferences<_$MichiFocusDatabase, $GoalRecordsTable, GoalRecord> {
  $$GoalRecordsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TaskRecordsTable, List<TaskRecord>>
  _taskRecordsRefsTable(_$MichiFocusDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.taskRecords,
        aliasName: $_aliasNameGenerator(
          db.goalRecords.id,
          db.taskRecords.goalId,
        ),
      );

  $$TaskRecordsTableProcessedTableManager get taskRecordsRefs {
    final manager = $$TaskRecordsTableTableManager(
      $_db,
      $_db.taskRecords,
    ).filter((f) => f.goalId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_taskRecordsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $PomodoroSessionRecordsTable,
    List<PomodoroSessionRecord>
  >
  _pomodoroSessionRecordsRefsTable(_$MichiFocusDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.pomodoroSessionRecords,
        aliasName: $_aliasNameGenerator(
          db.goalRecords.id,
          db.pomodoroSessionRecords.goalId,
        ),
      );

  $$PomodoroSessionRecordsTableProcessedTableManager
  get pomodoroSessionRecordsRefs {
    final manager = $$PomodoroSessionRecordsTableTableManager(
      $_db,
      $_db.pomodoroSessionRecords,
    ).filter((f) => f.goalId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _pomodoroSessionRecordsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $PomodoroRuntimeRecordsTable,
    List<PomodoroRuntimeRecord>
  >
  _pomodoroRuntimeRecordsRefsTable(_$MichiFocusDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.pomodoroRuntimeRecords,
        aliasName: $_aliasNameGenerator(
          db.goalRecords.id,
          db.pomodoroRuntimeRecords.goalId,
        ),
      );

  $$PomodoroRuntimeRecordsTableProcessedTableManager
  get pomodoroRuntimeRecordsRefs {
    final manager = $$PomodoroRuntimeRecordsTableTableManager(
      $_db,
      $_db.pomodoroRuntimeRecords,
    ).filter((f) => f.goalId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _pomodoroRuntimeRecordsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$GoalRecordsTableFilterComposer
    extends Composer<_$MichiFocusDatabase, $GoalRecordsTable> {
  $$GoalRecordsTableFilterComposer({
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

  ColumnFilters<int> get targetSessions => $composableBuilder(
    column: $table.targetSessions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get completedSessions => $composableBuilder(
    column: $table.completedSessions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> taskRecordsRefs(
    Expression<bool> Function($$TaskRecordsTableFilterComposer f) f,
  ) {
    final $$TaskRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskRecords,
      getReferencedColumn: (t) => t.goalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskRecordsTableFilterComposer(
            $db: $db,
            $table: $db.taskRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> pomodoroSessionRecordsRefs(
    Expression<bool> Function($$PomodoroSessionRecordsTableFilterComposer f) f,
  ) {
    final $$PomodoroSessionRecordsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.pomodoroSessionRecords,
          getReferencedColumn: (t) => t.goalId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PomodoroSessionRecordsTableFilterComposer(
                $db: $db,
                $table: $db.pomodoroSessionRecords,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> pomodoroRuntimeRecordsRefs(
    Expression<bool> Function($$PomodoroRuntimeRecordsTableFilterComposer f) f,
  ) {
    final $$PomodoroRuntimeRecordsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.pomodoroRuntimeRecords,
          getReferencedColumn: (t) => t.goalId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PomodoroRuntimeRecordsTableFilterComposer(
                $db: $db,
                $table: $db.pomodoroRuntimeRecords,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$GoalRecordsTableOrderingComposer
    extends Composer<_$MichiFocusDatabase, $GoalRecordsTable> {
  $$GoalRecordsTableOrderingComposer({
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

  ColumnOrderings<int> get targetSessions => $composableBuilder(
    column: $table.targetSessions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get completedSessions => $composableBuilder(
    column: $table.completedSessions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GoalRecordsTableAnnotationComposer
    extends Composer<_$MichiFocusDatabase, $GoalRecordsTable> {
  $$GoalRecordsTableAnnotationComposer({
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

  GeneratedColumn<int> get targetSessions => $composableBuilder(
    column: $table.targetSessions,
    builder: (column) => column,
  );

  GeneratedColumn<int> get completedSessions => $composableBuilder(
    column: $table.completedSessions,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> taskRecordsRefs<T extends Object>(
    Expression<T> Function($$TaskRecordsTableAnnotationComposer a) f,
  ) {
    final $$TaskRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskRecords,
      getReferencedColumn: (t) => t.goalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.taskRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> pomodoroSessionRecordsRefs<T extends Object>(
    Expression<T> Function($$PomodoroSessionRecordsTableAnnotationComposer a) f,
  ) {
    final $$PomodoroSessionRecordsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.pomodoroSessionRecords,
          getReferencedColumn: (t) => t.goalId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PomodoroSessionRecordsTableAnnotationComposer(
                $db: $db,
                $table: $db.pomodoroSessionRecords,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> pomodoroRuntimeRecordsRefs<T extends Object>(
    Expression<T> Function($$PomodoroRuntimeRecordsTableAnnotationComposer a) f,
  ) {
    final $$PomodoroRuntimeRecordsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.pomodoroRuntimeRecords,
          getReferencedColumn: (t) => t.goalId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PomodoroRuntimeRecordsTableAnnotationComposer(
                $db: $db,
                $table: $db.pomodoroRuntimeRecords,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$GoalRecordsTableTableManager
    extends
        RootTableManager<
          _$MichiFocusDatabase,
          $GoalRecordsTable,
          GoalRecord,
          $$GoalRecordsTableFilterComposer,
          $$GoalRecordsTableOrderingComposer,
          $$GoalRecordsTableAnnotationComposer,
          $$GoalRecordsTableCreateCompanionBuilder,
          $$GoalRecordsTableUpdateCompanionBuilder,
          (GoalRecord, $$GoalRecordsTableReferences),
          GoalRecord,
          PrefetchHooks Function({
            bool taskRecordsRefs,
            bool pomodoroSessionRecordsRefs,
            bool pomodoroRuntimeRecordsRefs,
          })
        > {
  $$GoalRecordsTableTableManager(
    _$MichiFocusDatabase db,
    $GoalRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GoalRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GoalRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GoalRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int> targetSessions = const Value.absent(),
                Value<int> completedSessions = const Value.absent(),
                Value<DateTime?> targetDate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GoalRecordsCompanion(
                id: id,
                title: title,
                targetSessions: targetSessions,
                completedSessions: completedSessions,
                targetDate: targetDate,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required int targetSessions,
                Value<int> completedSessions = const Value.absent(),
                Value<DateTime?> targetDate = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => GoalRecordsCompanion.insert(
                id: id,
                title: title,
                targetSessions: targetSessions,
                completedSessions: completedSessions,
                targetDate: targetDate,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$GoalRecordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                taskRecordsRefs = false,
                pomodoroSessionRecordsRefs = false,
                pomodoroRuntimeRecordsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (taskRecordsRefs) db.taskRecords,
                    if (pomodoroSessionRecordsRefs) db.pomodoroSessionRecords,
                    if (pomodoroRuntimeRecordsRefs) db.pomodoroRuntimeRecords,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (taskRecordsRefs)
                        await $_getPrefetchedData<
                          GoalRecord,
                          $GoalRecordsTable,
                          TaskRecord
                        >(
                          currentTable: table,
                          referencedTable: $$GoalRecordsTableReferences
                              ._taskRecordsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GoalRecordsTableReferences(
                                db,
                                table,
                                p0,
                              ).taskRecordsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.goalId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (pomodoroSessionRecordsRefs)
                        await $_getPrefetchedData<
                          GoalRecord,
                          $GoalRecordsTable,
                          PomodoroSessionRecord
                        >(
                          currentTable: table,
                          referencedTable: $$GoalRecordsTableReferences
                              ._pomodoroSessionRecordsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GoalRecordsTableReferences(
                                db,
                                table,
                                p0,
                              ).pomodoroSessionRecordsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.goalId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (pomodoroRuntimeRecordsRefs)
                        await $_getPrefetchedData<
                          GoalRecord,
                          $GoalRecordsTable,
                          PomodoroRuntimeRecord
                        >(
                          currentTable: table,
                          referencedTable: $$GoalRecordsTableReferences
                              ._pomodoroRuntimeRecordsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GoalRecordsTableReferences(
                                db,
                                table,
                                p0,
                              ).pomodoroRuntimeRecordsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.goalId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$GoalRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$MichiFocusDatabase,
      $GoalRecordsTable,
      GoalRecord,
      $$GoalRecordsTableFilterComposer,
      $$GoalRecordsTableOrderingComposer,
      $$GoalRecordsTableAnnotationComposer,
      $$GoalRecordsTableCreateCompanionBuilder,
      $$GoalRecordsTableUpdateCompanionBuilder,
      (GoalRecord, $$GoalRecordsTableReferences),
      GoalRecord,
      PrefetchHooks Function({
        bool taskRecordsRefs,
        bool pomodoroSessionRecordsRefs,
        bool pomodoroRuntimeRecordsRefs,
      })
    >;
typedef $$TaskRecordsTableCreateCompanionBuilder =
    TaskRecordsCompanion Function({
      required String id,
      required String title,
      Value<bool> isCompleted,
      Value<String> status,
      Value<DateTime?> scheduledDate,
      Value<String?> goalId,
      Value<int?> durationMinutes,
      Value<bool> legacyCompletionUnknown,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$TaskRecordsTableUpdateCompanionBuilder =
    TaskRecordsCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<bool> isCompleted,
      Value<String> status,
      Value<DateTime?> scheduledDate,
      Value<String?> goalId,
      Value<int?> durationMinutes,
      Value<bool> legacyCompletionUnknown,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$TaskRecordsTableReferences
    extends
        BaseReferences<_$MichiFocusDatabase, $TaskRecordsTable, TaskRecord> {
  $$TaskRecordsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GoalRecordsTable _goalIdTable(_$MichiFocusDatabase db) =>
      db.goalRecords.createAlias(
        $_aliasNameGenerator(db.taskRecords.goalId, db.goalRecords.id),
      );

  $$GoalRecordsTableProcessedTableManager? get goalId {
    final $_column = $_itemColumn<String>('goal_id');
    if ($_column == null) return null;
    final manager = $$GoalRecordsTableTableManager(
      $_db,
      $_db.goalRecords,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_goalIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $TaskCompletionEventRecordsTable,
    List<TaskCompletionEventRecord>
  >
  _taskCompletionEventRecordsRefsTable(_$MichiFocusDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.taskCompletionEventRecords,
        aliasName: $_aliasNameGenerator(
          db.taskRecords.id,
          db.taskCompletionEventRecords.taskId,
        ),
      );

  $$TaskCompletionEventRecordsTableProcessedTableManager
  get taskCompletionEventRecordsRefs {
    final manager = $$TaskCompletionEventRecordsTableTableManager(
      $_db,
      $_db.taskCompletionEventRecords,
    ).filter((f) => f.taskId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _taskCompletionEventRecordsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $PomodoroSessionRecordsTable,
    List<PomodoroSessionRecord>
  >
  _pomodoroSessionRecordsRefsTable(_$MichiFocusDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.pomodoroSessionRecords,
        aliasName: $_aliasNameGenerator(
          db.taskRecords.id,
          db.pomodoroSessionRecords.taskId,
        ),
      );

  $$PomodoroSessionRecordsTableProcessedTableManager
  get pomodoroSessionRecordsRefs {
    final manager = $$PomodoroSessionRecordsTableTableManager(
      $_db,
      $_db.pomodoroSessionRecords,
    ).filter((f) => f.taskId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _pomodoroSessionRecordsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $PomodoroRuntimeRecordsTable,
    List<PomodoroRuntimeRecord>
  >
  _pomodoroRuntimeRecordsRefsTable(_$MichiFocusDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.pomodoroRuntimeRecords,
        aliasName: $_aliasNameGenerator(
          db.taskRecords.id,
          db.pomodoroRuntimeRecords.taskId,
        ),
      );

  $$PomodoroRuntimeRecordsTableProcessedTableManager
  get pomodoroRuntimeRecordsRefs {
    final manager = $$PomodoroRuntimeRecordsTableTableManager(
      $_db,
      $_db.pomodoroRuntimeRecords,
    ).filter((f) => f.taskId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _pomodoroRuntimeRecordsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TaskRecordsTableFilterComposer
    extends Composer<_$MichiFocusDatabase, $TaskRecordsTable> {
  $$TaskRecordsTableFilterComposer({
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

  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get scheduledDate => $composableBuilder(
    column: $table.scheduledDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get legacyCompletionUnknown => $composableBuilder(
    column: $table.legacyCompletionUnknown,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$GoalRecordsTableFilterComposer get goalId {
    final $$GoalRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.goalId,
      referencedTable: $db.goalRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalRecordsTableFilterComposer(
            $db: $db,
            $table: $db.goalRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> taskCompletionEventRecordsRefs(
    Expression<bool> Function($$TaskCompletionEventRecordsTableFilterComposer f)
    f,
  ) {
    final $$TaskCompletionEventRecordsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.taskCompletionEventRecords,
          getReferencedColumn: (t) => t.taskId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TaskCompletionEventRecordsTableFilterComposer(
                $db: $db,
                $table: $db.taskCompletionEventRecords,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> pomodoroSessionRecordsRefs(
    Expression<bool> Function($$PomodoroSessionRecordsTableFilterComposer f) f,
  ) {
    final $$PomodoroSessionRecordsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.pomodoroSessionRecords,
          getReferencedColumn: (t) => t.taskId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PomodoroSessionRecordsTableFilterComposer(
                $db: $db,
                $table: $db.pomodoroSessionRecords,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> pomodoroRuntimeRecordsRefs(
    Expression<bool> Function($$PomodoroRuntimeRecordsTableFilterComposer f) f,
  ) {
    final $$PomodoroRuntimeRecordsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.pomodoroRuntimeRecords,
          getReferencedColumn: (t) => t.taskId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PomodoroRuntimeRecordsTableFilterComposer(
                $db: $db,
                $table: $db.pomodoroRuntimeRecords,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$TaskRecordsTableOrderingComposer
    extends Composer<_$MichiFocusDatabase, $TaskRecordsTable> {
  $$TaskRecordsTableOrderingComposer({
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

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get scheduledDate => $composableBuilder(
    column: $table.scheduledDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get legacyCompletionUnknown => $composableBuilder(
    column: $table.legacyCompletionUnknown,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$GoalRecordsTableOrderingComposer get goalId {
    final $$GoalRecordsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.goalId,
      referencedTable: $db.goalRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalRecordsTableOrderingComposer(
            $db: $db,
            $table: $db.goalRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskRecordsTableAnnotationComposer
    extends Composer<_$MichiFocusDatabase, $TaskRecordsTable> {
  $$TaskRecordsTableAnnotationComposer({
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

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get scheduledDate => $composableBuilder(
    column: $table.scheduledDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get legacyCompletionUnknown => $composableBuilder(
    column: $table.legacyCompletionUnknown,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$GoalRecordsTableAnnotationComposer get goalId {
    final $$GoalRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.goalId,
      referencedTable: $db.goalRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.goalRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> taskCompletionEventRecordsRefs<T extends Object>(
    Expression<T> Function(
      $$TaskCompletionEventRecordsTableAnnotationComposer a,
    )
    f,
  ) {
    final $$TaskCompletionEventRecordsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.taskCompletionEventRecords,
          getReferencedColumn: (t) => t.taskId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TaskCompletionEventRecordsTableAnnotationComposer(
                $db: $db,
                $table: $db.taskCompletionEventRecords,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> pomodoroSessionRecordsRefs<T extends Object>(
    Expression<T> Function($$PomodoroSessionRecordsTableAnnotationComposer a) f,
  ) {
    final $$PomodoroSessionRecordsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.pomodoroSessionRecords,
          getReferencedColumn: (t) => t.taskId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PomodoroSessionRecordsTableAnnotationComposer(
                $db: $db,
                $table: $db.pomodoroSessionRecords,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> pomodoroRuntimeRecordsRefs<T extends Object>(
    Expression<T> Function($$PomodoroRuntimeRecordsTableAnnotationComposer a) f,
  ) {
    final $$PomodoroRuntimeRecordsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.pomodoroRuntimeRecords,
          getReferencedColumn: (t) => t.taskId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PomodoroRuntimeRecordsTableAnnotationComposer(
                $db: $db,
                $table: $db.pomodoroRuntimeRecords,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$TaskRecordsTableTableManager
    extends
        RootTableManager<
          _$MichiFocusDatabase,
          $TaskRecordsTable,
          TaskRecord,
          $$TaskRecordsTableFilterComposer,
          $$TaskRecordsTableOrderingComposer,
          $$TaskRecordsTableAnnotationComposer,
          $$TaskRecordsTableCreateCompanionBuilder,
          $$TaskRecordsTableUpdateCompanionBuilder,
          (TaskRecord, $$TaskRecordsTableReferences),
          TaskRecord,
          PrefetchHooks Function({
            bool goalId,
            bool taskCompletionEventRecordsRefs,
            bool pomodoroSessionRecordsRefs,
            bool pomodoroRuntimeRecordsRefs,
          })
        > {
  $$TaskRecordsTableTableManager(
    _$MichiFocusDatabase db,
    $TaskRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaskRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaskRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaskRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime?> scheduledDate = const Value.absent(),
                Value<String?> goalId = const Value.absent(),
                Value<int?> durationMinutes = const Value.absent(),
                Value<bool> legacyCompletionUnknown = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TaskRecordsCompanion(
                id: id,
                title: title,
                isCompleted: isCompleted,
                status: status,
                scheduledDate: scheduledDate,
                goalId: goalId,
                durationMinutes: durationMinutes,
                legacyCompletionUnknown: legacyCompletionUnknown,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                Value<bool> isCompleted = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime?> scheduledDate = const Value.absent(),
                Value<String?> goalId = const Value.absent(),
                Value<int?> durationMinutes = const Value.absent(),
                Value<bool> legacyCompletionUnknown = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => TaskRecordsCompanion.insert(
                id: id,
                title: title,
                isCompleted: isCompleted,
                status: status,
                scheduledDate: scheduledDate,
                goalId: goalId,
                durationMinutes: durationMinutes,
                legacyCompletionUnknown: legacyCompletionUnknown,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TaskRecordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                goalId = false,
                taskCompletionEventRecordsRefs = false,
                pomodoroSessionRecordsRefs = false,
                pomodoroRuntimeRecordsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (taskCompletionEventRecordsRefs)
                      db.taskCompletionEventRecords,
                    if (pomodoroSessionRecordsRefs) db.pomodoroSessionRecords,
                    if (pomodoroRuntimeRecordsRefs) db.pomodoroRuntimeRecords,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (goalId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.goalId,
                                    referencedTable:
                                        $$TaskRecordsTableReferences
                                            ._goalIdTable(db),
                                    referencedColumn:
                                        $$TaskRecordsTableReferences
                                            ._goalIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (taskCompletionEventRecordsRefs)
                        await $_getPrefetchedData<
                          TaskRecord,
                          $TaskRecordsTable,
                          TaskCompletionEventRecord
                        >(
                          currentTable: table,
                          referencedTable: $$TaskRecordsTableReferences
                              ._taskCompletionEventRecordsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TaskRecordsTableReferences(
                                db,
                                table,
                                p0,
                              ).taskCompletionEventRecordsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.taskId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (pomodoroSessionRecordsRefs)
                        await $_getPrefetchedData<
                          TaskRecord,
                          $TaskRecordsTable,
                          PomodoroSessionRecord
                        >(
                          currentTable: table,
                          referencedTable: $$TaskRecordsTableReferences
                              ._pomodoroSessionRecordsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TaskRecordsTableReferences(
                                db,
                                table,
                                p0,
                              ).pomodoroSessionRecordsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.taskId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (pomodoroRuntimeRecordsRefs)
                        await $_getPrefetchedData<
                          TaskRecord,
                          $TaskRecordsTable,
                          PomodoroRuntimeRecord
                        >(
                          currentTable: table,
                          referencedTable: $$TaskRecordsTableReferences
                              ._pomodoroRuntimeRecordsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TaskRecordsTableReferences(
                                db,
                                table,
                                p0,
                              ).pomodoroRuntimeRecordsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.taskId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TaskRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$MichiFocusDatabase,
      $TaskRecordsTable,
      TaskRecord,
      $$TaskRecordsTableFilterComposer,
      $$TaskRecordsTableOrderingComposer,
      $$TaskRecordsTableAnnotationComposer,
      $$TaskRecordsTableCreateCompanionBuilder,
      $$TaskRecordsTableUpdateCompanionBuilder,
      (TaskRecord, $$TaskRecordsTableReferences),
      TaskRecord,
      PrefetchHooks Function({
        bool goalId,
        bool taskCompletionEventRecordsRefs,
        bool pomodoroSessionRecordsRefs,
        bool pomodoroRuntimeRecordsRefs,
      })
    >;
typedef $$TaskCompletionEventRecordsTableCreateCompanionBuilder =
    TaskCompletionEventRecordsCompanion Function({
      required String id,
      Value<String?> taskId,
      required String taskIdSnapshot,
      required DateTime completedAt,
      Value<DateTime?> scheduledDateSnapshot,
      Value<int> rowid,
    });
typedef $$TaskCompletionEventRecordsTableUpdateCompanionBuilder =
    TaskCompletionEventRecordsCompanion Function({
      Value<String> id,
      Value<String?> taskId,
      Value<String> taskIdSnapshot,
      Value<DateTime> completedAt,
      Value<DateTime?> scheduledDateSnapshot,
      Value<int> rowid,
    });

final class $$TaskCompletionEventRecordsTableReferences
    extends
        BaseReferences<
          _$MichiFocusDatabase,
          $TaskCompletionEventRecordsTable,
          TaskCompletionEventRecord
        > {
  $$TaskCompletionEventRecordsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TaskRecordsTable _taskIdTable(_$MichiFocusDatabase db) =>
      db.taskRecords.createAlias(
        $_aliasNameGenerator(
          db.taskCompletionEventRecords.taskId,
          db.taskRecords.id,
        ),
      );

  $$TaskRecordsTableProcessedTableManager? get taskId {
    final $_column = $_itemColumn<String>('task_id');
    if ($_column == null) return null;
    final manager = $$TaskRecordsTableTableManager(
      $_db,
      $_db.taskRecords,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_taskIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TaskCompletionEventRecordsTableFilterComposer
    extends Composer<_$MichiFocusDatabase, $TaskCompletionEventRecordsTable> {
  $$TaskCompletionEventRecordsTableFilterComposer({
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

  ColumnFilters<String> get taskIdSnapshot => $composableBuilder(
    column: $table.taskIdSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get scheduledDateSnapshot => $composableBuilder(
    column: $table.scheduledDateSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  $$TaskRecordsTableFilterComposer get taskId {
    final $$TaskRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.taskRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskRecordsTableFilterComposer(
            $db: $db,
            $table: $db.taskRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskCompletionEventRecordsTableOrderingComposer
    extends Composer<_$MichiFocusDatabase, $TaskCompletionEventRecordsTable> {
  $$TaskCompletionEventRecordsTableOrderingComposer({
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

  ColumnOrderings<String> get taskIdSnapshot => $composableBuilder(
    column: $table.taskIdSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get scheduledDateSnapshot => $composableBuilder(
    column: $table.scheduledDateSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  $$TaskRecordsTableOrderingComposer get taskId {
    final $$TaskRecordsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.taskRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskRecordsTableOrderingComposer(
            $db: $db,
            $table: $db.taskRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskCompletionEventRecordsTableAnnotationComposer
    extends Composer<_$MichiFocusDatabase, $TaskCompletionEventRecordsTable> {
  $$TaskCompletionEventRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get taskIdSnapshot => $composableBuilder(
    column: $table.taskIdSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get scheduledDateSnapshot => $composableBuilder(
    column: $table.scheduledDateSnapshot,
    builder: (column) => column,
  );

  $$TaskRecordsTableAnnotationComposer get taskId {
    final $$TaskRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.taskRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.taskRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskCompletionEventRecordsTableTableManager
    extends
        RootTableManager<
          _$MichiFocusDatabase,
          $TaskCompletionEventRecordsTable,
          TaskCompletionEventRecord,
          $$TaskCompletionEventRecordsTableFilterComposer,
          $$TaskCompletionEventRecordsTableOrderingComposer,
          $$TaskCompletionEventRecordsTableAnnotationComposer,
          $$TaskCompletionEventRecordsTableCreateCompanionBuilder,
          $$TaskCompletionEventRecordsTableUpdateCompanionBuilder,
          (
            TaskCompletionEventRecord,
            $$TaskCompletionEventRecordsTableReferences,
          ),
          TaskCompletionEventRecord,
          PrefetchHooks Function({bool taskId})
        > {
  $$TaskCompletionEventRecordsTableTableManager(
    _$MichiFocusDatabase db,
    $TaskCompletionEventRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaskCompletionEventRecordsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$TaskCompletionEventRecordsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$TaskCompletionEventRecordsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> taskId = const Value.absent(),
                Value<String> taskIdSnapshot = const Value.absent(),
                Value<DateTime> completedAt = const Value.absent(),
                Value<DateTime?> scheduledDateSnapshot = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TaskCompletionEventRecordsCompanion(
                id: id,
                taskId: taskId,
                taskIdSnapshot: taskIdSnapshot,
                completedAt: completedAt,
                scheduledDateSnapshot: scheduledDateSnapshot,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> taskId = const Value.absent(),
                required String taskIdSnapshot,
                required DateTime completedAt,
                Value<DateTime?> scheduledDateSnapshot = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TaskCompletionEventRecordsCompanion.insert(
                id: id,
                taskId: taskId,
                taskIdSnapshot: taskIdSnapshot,
                completedAt: completedAt,
                scheduledDateSnapshot: scheduledDateSnapshot,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TaskCompletionEventRecordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({taskId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (taskId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.taskId,
                                referencedTable:
                                    $$TaskCompletionEventRecordsTableReferences
                                        ._taskIdTable(db),
                                referencedColumn:
                                    $$TaskCompletionEventRecordsTableReferences
                                        ._taskIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TaskCompletionEventRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$MichiFocusDatabase,
      $TaskCompletionEventRecordsTable,
      TaskCompletionEventRecord,
      $$TaskCompletionEventRecordsTableFilterComposer,
      $$TaskCompletionEventRecordsTableOrderingComposer,
      $$TaskCompletionEventRecordsTableAnnotationComposer,
      $$TaskCompletionEventRecordsTableCreateCompanionBuilder,
      $$TaskCompletionEventRecordsTableUpdateCompanionBuilder,
      (TaskCompletionEventRecord, $$TaskCompletionEventRecordsTableReferences),
      TaskCompletionEventRecord,
      PrefetchHooks Function({bool taskId})
    >;
typedef $$ReportingMetadataRecordsTableCreateCompanionBuilder =
    ReportingMetadataRecordsCompanion Function({
      required String id,
      required DateTime completionTrackingStartedAt,
      Value<int> rowid,
    });
typedef $$ReportingMetadataRecordsTableUpdateCompanionBuilder =
    ReportingMetadataRecordsCompanion Function({
      Value<String> id,
      Value<DateTime> completionTrackingStartedAt,
      Value<int> rowid,
    });

class $$ReportingMetadataRecordsTableFilterComposer
    extends Composer<_$MichiFocusDatabase, $ReportingMetadataRecordsTable> {
  $$ReportingMetadataRecordsTableFilterComposer({
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

  ColumnFilters<DateTime> get completionTrackingStartedAt => $composableBuilder(
    column: $table.completionTrackingStartedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ReportingMetadataRecordsTableOrderingComposer
    extends Composer<_$MichiFocusDatabase, $ReportingMetadataRecordsTable> {
  $$ReportingMetadataRecordsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get completionTrackingStartedAt =>
      $composableBuilder(
        column: $table.completionTrackingStartedAt,
        builder: (column) => ColumnOrderings(column),
      );
}

class $$ReportingMetadataRecordsTableAnnotationComposer
    extends Composer<_$MichiFocusDatabase, $ReportingMetadataRecordsTable> {
  $$ReportingMetadataRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get completionTrackingStartedAt =>
      $composableBuilder(
        column: $table.completionTrackingStartedAt,
        builder: (column) => column,
      );
}

class $$ReportingMetadataRecordsTableTableManager
    extends
        RootTableManager<
          _$MichiFocusDatabase,
          $ReportingMetadataRecordsTable,
          ReportingMetadataRecord,
          $$ReportingMetadataRecordsTableFilterComposer,
          $$ReportingMetadataRecordsTableOrderingComposer,
          $$ReportingMetadataRecordsTableAnnotationComposer,
          $$ReportingMetadataRecordsTableCreateCompanionBuilder,
          $$ReportingMetadataRecordsTableUpdateCompanionBuilder,
          (
            ReportingMetadataRecord,
            BaseReferences<
              _$MichiFocusDatabase,
              $ReportingMetadataRecordsTable,
              ReportingMetadataRecord
            >,
          ),
          ReportingMetadataRecord,
          PrefetchHooks Function()
        > {
  $$ReportingMetadataRecordsTableTableManager(
    _$MichiFocusDatabase db,
    $ReportingMetadataRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReportingMetadataRecordsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$ReportingMetadataRecordsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ReportingMetadataRecordsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> completionTrackingStartedAt =
                    const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReportingMetadataRecordsCompanion(
                id: id,
                completionTrackingStartedAt: completionTrackingStartedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime completionTrackingStartedAt,
                Value<int> rowid = const Value.absent(),
              }) => ReportingMetadataRecordsCompanion.insert(
                id: id,
                completionTrackingStartedAt: completionTrackingStartedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ReportingMetadataRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$MichiFocusDatabase,
      $ReportingMetadataRecordsTable,
      ReportingMetadataRecord,
      $$ReportingMetadataRecordsTableFilterComposer,
      $$ReportingMetadataRecordsTableOrderingComposer,
      $$ReportingMetadataRecordsTableAnnotationComposer,
      $$ReportingMetadataRecordsTableCreateCompanionBuilder,
      $$ReportingMetadataRecordsTableUpdateCompanionBuilder,
      (
        ReportingMetadataRecord,
        BaseReferences<
          _$MichiFocusDatabase,
          $ReportingMetadataRecordsTable,
          ReportingMetadataRecord
        >,
      ),
      ReportingMetadataRecord,
      PrefetchHooks Function()
    >;
typedef $$PomodoroSessionRecordsTableCreateCompanionBuilder =
    PomodoroSessionRecordsCompanion Function({
      required String id,
      required DateTime startedAt,
      required DateTime endedAt,
      required int plannedSeconds,
      required int focusedSeconds,
      Value<String?> goalId,
      Value<String?> taskId,
      Value<int?> startMoodScore,
      Value<int?> endMoodScore,
      Value<bool?> wasDistracted,
      Value<int?> distractionMinutes,
      required String status,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$PomodoroSessionRecordsTableUpdateCompanionBuilder =
    PomodoroSessionRecordsCompanion Function({
      Value<String> id,
      Value<DateTime> startedAt,
      Value<DateTime> endedAt,
      Value<int> plannedSeconds,
      Value<int> focusedSeconds,
      Value<String?> goalId,
      Value<String?> taskId,
      Value<int?> startMoodScore,
      Value<int?> endMoodScore,
      Value<bool?> wasDistracted,
      Value<int?> distractionMinutes,
      Value<String> status,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$PomodoroSessionRecordsTableReferences
    extends
        BaseReferences<
          _$MichiFocusDatabase,
          $PomodoroSessionRecordsTable,
          PomodoroSessionRecord
        > {
  $$PomodoroSessionRecordsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $GoalRecordsTable _goalIdTable(_$MichiFocusDatabase db) =>
      db.goalRecords.createAlias(
        $_aliasNameGenerator(
          db.pomodoroSessionRecords.goalId,
          db.goalRecords.id,
        ),
      );

  $$GoalRecordsTableProcessedTableManager? get goalId {
    final $_column = $_itemColumn<String>('goal_id');
    if ($_column == null) return null;
    final manager = $$GoalRecordsTableTableManager(
      $_db,
      $_db.goalRecords,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_goalIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TaskRecordsTable _taskIdTable(_$MichiFocusDatabase db) =>
      db.taskRecords.createAlias(
        $_aliasNameGenerator(
          db.pomodoroSessionRecords.taskId,
          db.taskRecords.id,
        ),
      );

  $$TaskRecordsTableProcessedTableManager? get taskId {
    final $_column = $_itemColumn<String>('task_id');
    if ($_column == null) return null;
    final manager = $$TaskRecordsTableTableManager(
      $_db,
      $_db.taskRecords,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_taskIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PomodoroSessionRecordsTableFilterComposer
    extends Composer<_$MichiFocusDatabase, $PomodoroSessionRecordsTable> {
  $$PomodoroSessionRecordsTableFilterComposer({
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

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get plannedSeconds => $composableBuilder(
    column: $table.plannedSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get focusedSeconds => $composableBuilder(
    column: $table.focusedSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startMoodScore => $composableBuilder(
    column: $table.startMoodScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endMoodScore => $composableBuilder(
    column: $table.endMoodScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get wasDistracted => $composableBuilder(
    column: $table.wasDistracted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get distractionMinutes => $composableBuilder(
    column: $table.distractionMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$GoalRecordsTableFilterComposer get goalId {
    final $$GoalRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.goalId,
      referencedTable: $db.goalRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalRecordsTableFilterComposer(
            $db: $db,
            $table: $db.goalRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TaskRecordsTableFilterComposer get taskId {
    final $$TaskRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.taskRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskRecordsTableFilterComposer(
            $db: $db,
            $table: $db.taskRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PomodoroSessionRecordsTableOrderingComposer
    extends Composer<_$MichiFocusDatabase, $PomodoroSessionRecordsTable> {
  $$PomodoroSessionRecordsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get plannedSeconds => $composableBuilder(
    column: $table.plannedSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get focusedSeconds => $composableBuilder(
    column: $table.focusedSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startMoodScore => $composableBuilder(
    column: $table.startMoodScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endMoodScore => $composableBuilder(
    column: $table.endMoodScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get wasDistracted => $composableBuilder(
    column: $table.wasDistracted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get distractionMinutes => $composableBuilder(
    column: $table.distractionMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$GoalRecordsTableOrderingComposer get goalId {
    final $$GoalRecordsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.goalId,
      referencedTable: $db.goalRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalRecordsTableOrderingComposer(
            $db: $db,
            $table: $db.goalRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TaskRecordsTableOrderingComposer get taskId {
    final $$TaskRecordsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.taskRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskRecordsTableOrderingComposer(
            $db: $db,
            $table: $db.taskRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PomodoroSessionRecordsTableAnnotationComposer
    extends Composer<_$MichiFocusDatabase, $PomodoroSessionRecordsTable> {
  $$PomodoroSessionRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<int> get plannedSeconds => $composableBuilder(
    column: $table.plannedSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<int> get focusedSeconds => $composableBuilder(
    column: $table.focusedSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<int> get startMoodScore => $composableBuilder(
    column: $table.startMoodScore,
    builder: (column) => column,
  );

  GeneratedColumn<int> get endMoodScore => $composableBuilder(
    column: $table.endMoodScore,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get wasDistracted => $composableBuilder(
    column: $table.wasDistracted,
    builder: (column) => column,
  );

  GeneratedColumn<int> get distractionMinutes => $composableBuilder(
    column: $table.distractionMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$GoalRecordsTableAnnotationComposer get goalId {
    final $$GoalRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.goalId,
      referencedTable: $db.goalRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.goalRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TaskRecordsTableAnnotationComposer get taskId {
    final $$TaskRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.taskRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.taskRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PomodoroSessionRecordsTableTableManager
    extends
        RootTableManager<
          _$MichiFocusDatabase,
          $PomodoroSessionRecordsTable,
          PomodoroSessionRecord,
          $$PomodoroSessionRecordsTableFilterComposer,
          $$PomodoroSessionRecordsTableOrderingComposer,
          $$PomodoroSessionRecordsTableAnnotationComposer,
          $$PomodoroSessionRecordsTableCreateCompanionBuilder,
          $$PomodoroSessionRecordsTableUpdateCompanionBuilder,
          (PomodoroSessionRecord, $$PomodoroSessionRecordsTableReferences),
          PomodoroSessionRecord,
          PrefetchHooks Function({bool goalId, bool taskId})
        > {
  $$PomodoroSessionRecordsTableTableManager(
    _$MichiFocusDatabase db,
    $PomodoroSessionRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PomodoroSessionRecordsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$PomodoroSessionRecordsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PomodoroSessionRecordsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime> endedAt = const Value.absent(),
                Value<int> plannedSeconds = const Value.absent(),
                Value<int> focusedSeconds = const Value.absent(),
                Value<String?> goalId = const Value.absent(),
                Value<String?> taskId = const Value.absent(),
                Value<int?> startMoodScore = const Value.absent(),
                Value<int?> endMoodScore = const Value.absent(),
                Value<bool?> wasDistracted = const Value.absent(),
                Value<int?> distractionMinutes = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PomodoroSessionRecordsCompanion(
                id: id,
                startedAt: startedAt,
                endedAt: endedAt,
                plannedSeconds: plannedSeconds,
                focusedSeconds: focusedSeconds,
                goalId: goalId,
                taskId: taskId,
                startMoodScore: startMoodScore,
                endMoodScore: endMoodScore,
                wasDistracted: wasDistracted,
                distractionMinutes: distractionMinutes,
                status: status,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime startedAt,
                required DateTime endedAt,
                required int plannedSeconds,
                required int focusedSeconds,
                Value<String?> goalId = const Value.absent(),
                Value<String?> taskId = const Value.absent(),
                Value<int?> startMoodScore = const Value.absent(),
                Value<int?> endMoodScore = const Value.absent(),
                Value<bool?> wasDistracted = const Value.absent(),
                Value<int?> distractionMinutes = const Value.absent(),
                required String status,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => PomodoroSessionRecordsCompanion.insert(
                id: id,
                startedAt: startedAt,
                endedAt: endedAt,
                plannedSeconds: plannedSeconds,
                focusedSeconds: focusedSeconds,
                goalId: goalId,
                taskId: taskId,
                startMoodScore: startMoodScore,
                endMoodScore: endMoodScore,
                wasDistracted: wasDistracted,
                distractionMinutes: distractionMinutes,
                status: status,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PomodoroSessionRecordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({goalId = false, taskId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (goalId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.goalId,
                                referencedTable:
                                    $$PomodoroSessionRecordsTableReferences
                                        ._goalIdTable(db),
                                referencedColumn:
                                    $$PomodoroSessionRecordsTableReferences
                                        ._goalIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (taskId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.taskId,
                                referencedTable:
                                    $$PomodoroSessionRecordsTableReferences
                                        ._taskIdTable(db),
                                referencedColumn:
                                    $$PomodoroSessionRecordsTableReferences
                                        ._taskIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PomodoroSessionRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$MichiFocusDatabase,
      $PomodoroSessionRecordsTable,
      PomodoroSessionRecord,
      $$PomodoroSessionRecordsTableFilterComposer,
      $$PomodoroSessionRecordsTableOrderingComposer,
      $$PomodoroSessionRecordsTableAnnotationComposer,
      $$PomodoroSessionRecordsTableCreateCompanionBuilder,
      $$PomodoroSessionRecordsTableUpdateCompanionBuilder,
      (PomodoroSessionRecord, $$PomodoroSessionRecordsTableReferences),
      PomodoroSessionRecord,
      PrefetchHooks Function({bool goalId, bool taskId})
    >;
typedef $$PomodoroRuntimeRecordsTableCreateCompanionBuilder =
    PomodoroRuntimeRecordsCompanion Function({
      required String id,
      Value<String?> taskId,
      Value<String?> taskTitle,
      Value<String?> goalId,
      Value<int?> taskEstimatedMinutes,
      required String phase,
      required bool isRunning,
      required int remainingSeconds,
      required int phaseTotalSeconds,
      required int cadenceFocusMinutes,
      required int cadenceBreakMinutes,
      required int longBreakMinutes,
      required int longBreakFrequency,
      required bool autoStartBreak,
      required bool autoStartFocus,
      required String planMode,
      required int blockIndex,
      required int blockCount,
      required int taskFocusedSecondsAtStart,
      Value<DateTime?> focusStartedAt,
      Value<DateTime?> lastTickAt,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$PomodoroRuntimeRecordsTableUpdateCompanionBuilder =
    PomodoroRuntimeRecordsCompanion Function({
      Value<String> id,
      Value<String?> taskId,
      Value<String?> taskTitle,
      Value<String?> goalId,
      Value<int?> taskEstimatedMinutes,
      Value<String> phase,
      Value<bool> isRunning,
      Value<int> remainingSeconds,
      Value<int> phaseTotalSeconds,
      Value<int> cadenceFocusMinutes,
      Value<int> cadenceBreakMinutes,
      Value<int> longBreakMinutes,
      Value<int> longBreakFrequency,
      Value<bool> autoStartBreak,
      Value<bool> autoStartFocus,
      Value<String> planMode,
      Value<int> blockIndex,
      Value<int> blockCount,
      Value<int> taskFocusedSecondsAtStart,
      Value<DateTime?> focusStartedAt,
      Value<DateTime?> lastTickAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$PomodoroRuntimeRecordsTableReferences
    extends
        BaseReferences<
          _$MichiFocusDatabase,
          $PomodoroRuntimeRecordsTable,
          PomodoroRuntimeRecord
        > {
  $$PomodoroRuntimeRecordsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TaskRecordsTable _taskIdTable(_$MichiFocusDatabase db) =>
      db.taskRecords.createAlias(
        $_aliasNameGenerator(
          db.pomodoroRuntimeRecords.taskId,
          db.taskRecords.id,
        ),
      );

  $$TaskRecordsTableProcessedTableManager? get taskId {
    final $_column = $_itemColumn<String>('task_id');
    if ($_column == null) return null;
    final manager = $$TaskRecordsTableTableManager(
      $_db,
      $_db.taskRecords,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_taskIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $GoalRecordsTable _goalIdTable(_$MichiFocusDatabase db) =>
      db.goalRecords.createAlias(
        $_aliasNameGenerator(
          db.pomodoroRuntimeRecords.goalId,
          db.goalRecords.id,
        ),
      );

  $$GoalRecordsTableProcessedTableManager? get goalId {
    final $_column = $_itemColumn<String>('goal_id');
    if ($_column == null) return null;
    final manager = $$GoalRecordsTableTableManager(
      $_db,
      $_db.goalRecords,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_goalIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PomodoroRuntimeRecordsTableFilterComposer
    extends Composer<_$MichiFocusDatabase, $PomodoroRuntimeRecordsTable> {
  $$PomodoroRuntimeRecordsTableFilterComposer({
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

  ColumnFilters<String> get taskTitle => $composableBuilder(
    column: $table.taskTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get taskEstimatedMinutes => $composableBuilder(
    column: $table.taskEstimatedMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phase => $composableBuilder(
    column: $table.phase,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isRunning => $composableBuilder(
    column: $table.isRunning,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get remainingSeconds => $composableBuilder(
    column: $table.remainingSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get phaseTotalSeconds => $composableBuilder(
    column: $table.phaseTotalSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cadenceFocusMinutes => $composableBuilder(
    column: $table.cadenceFocusMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cadenceBreakMinutes => $composableBuilder(
    column: $table.cadenceBreakMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get longBreakMinutes => $composableBuilder(
    column: $table.longBreakMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get longBreakFrequency => $composableBuilder(
    column: $table.longBreakFrequency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get autoStartBreak => $composableBuilder(
    column: $table.autoStartBreak,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get autoStartFocus => $composableBuilder(
    column: $table.autoStartFocus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get planMode => $composableBuilder(
    column: $table.planMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get blockIndex => $composableBuilder(
    column: $table.blockIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get blockCount => $composableBuilder(
    column: $table.blockCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get taskFocusedSecondsAtStart => $composableBuilder(
    column: $table.taskFocusedSecondsAtStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get focusStartedAt => $composableBuilder(
    column: $table.focusStartedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastTickAt => $composableBuilder(
    column: $table.lastTickAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$TaskRecordsTableFilterComposer get taskId {
    final $$TaskRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.taskRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskRecordsTableFilterComposer(
            $db: $db,
            $table: $db.taskRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$GoalRecordsTableFilterComposer get goalId {
    final $$GoalRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.goalId,
      referencedTable: $db.goalRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalRecordsTableFilterComposer(
            $db: $db,
            $table: $db.goalRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PomodoroRuntimeRecordsTableOrderingComposer
    extends Composer<_$MichiFocusDatabase, $PomodoroRuntimeRecordsTable> {
  $$PomodoroRuntimeRecordsTableOrderingComposer({
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

  ColumnOrderings<String> get taskTitle => $composableBuilder(
    column: $table.taskTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get taskEstimatedMinutes => $composableBuilder(
    column: $table.taskEstimatedMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phase => $composableBuilder(
    column: $table.phase,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isRunning => $composableBuilder(
    column: $table.isRunning,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get remainingSeconds => $composableBuilder(
    column: $table.remainingSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get phaseTotalSeconds => $composableBuilder(
    column: $table.phaseTotalSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cadenceFocusMinutes => $composableBuilder(
    column: $table.cadenceFocusMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cadenceBreakMinutes => $composableBuilder(
    column: $table.cadenceBreakMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get longBreakMinutes => $composableBuilder(
    column: $table.longBreakMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get longBreakFrequency => $composableBuilder(
    column: $table.longBreakFrequency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get autoStartBreak => $composableBuilder(
    column: $table.autoStartBreak,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get autoStartFocus => $composableBuilder(
    column: $table.autoStartFocus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get planMode => $composableBuilder(
    column: $table.planMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get blockIndex => $composableBuilder(
    column: $table.blockIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get blockCount => $composableBuilder(
    column: $table.blockCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get taskFocusedSecondsAtStart => $composableBuilder(
    column: $table.taskFocusedSecondsAtStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get focusStartedAt => $composableBuilder(
    column: $table.focusStartedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastTickAt => $composableBuilder(
    column: $table.lastTickAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$TaskRecordsTableOrderingComposer get taskId {
    final $$TaskRecordsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.taskRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskRecordsTableOrderingComposer(
            $db: $db,
            $table: $db.taskRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$GoalRecordsTableOrderingComposer get goalId {
    final $$GoalRecordsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.goalId,
      referencedTable: $db.goalRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalRecordsTableOrderingComposer(
            $db: $db,
            $table: $db.goalRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PomodoroRuntimeRecordsTableAnnotationComposer
    extends Composer<_$MichiFocusDatabase, $PomodoroRuntimeRecordsTable> {
  $$PomodoroRuntimeRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get taskTitle =>
      $composableBuilder(column: $table.taskTitle, builder: (column) => column);

  GeneratedColumn<int> get taskEstimatedMinutes => $composableBuilder(
    column: $table.taskEstimatedMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get phase =>
      $composableBuilder(column: $table.phase, builder: (column) => column);

  GeneratedColumn<bool> get isRunning =>
      $composableBuilder(column: $table.isRunning, builder: (column) => column);

  GeneratedColumn<int> get remainingSeconds => $composableBuilder(
    column: $table.remainingSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<int> get phaseTotalSeconds => $composableBuilder(
    column: $table.phaseTotalSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cadenceFocusMinutes => $composableBuilder(
    column: $table.cadenceFocusMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cadenceBreakMinutes => $composableBuilder(
    column: $table.cadenceBreakMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get longBreakMinutes => $composableBuilder(
    column: $table.longBreakMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get longBreakFrequency => $composableBuilder(
    column: $table.longBreakFrequency,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get autoStartBreak => $composableBuilder(
    column: $table.autoStartBreak,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get autoStartFocus => $composableBuilder(
    column: $table.autoStartFocus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get planMode =>
      $composableBuilder(column: $table.planMode, builder: (column) => column);

  GeneratedColumn<int> get blockIndex => $composableBuilder(
    column: $table.blockIndex,
    builder: (column) => column,
  );

  GeneratedColumn<int> get blockCount => $composableBuilder(
    column: $table.blockCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get taskFocusedSecondsAtStart => $composableBuilder(
    column: $table.taskFocusedSecondsAtStart,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get focusStartedAt => $composableBuilder(
    column: $table.focusStartedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastTickAt => $composableBuilder(
    column: $table.lastTickAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$TaskRecordsTableAnnotationComposer get taskId {
    final $$TaskRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.taskRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.taskRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$GoalRecordsTableAnnotationComposer get goalId {
    final $$GoalRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.goalId,
      referencedTable: $db.goalRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.goalRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PomodoroRuntimeRecordsTableTableManager
    extends
        RootTableManager<
          _$MichiFocusDatabase,
          $PomodoroRuntimeRecordsTable,
          PomodoroRuntimeRecord,
          $$PomodoroRuntimeRecordsTableFilterComposer,
          $$PomodoroRuntimeRecordsTableOrderingComposer,
          $$PomodoroRuntimeRecordsTableAnnotationComposer,
          $$PomodoroRuntimeRecordsTableCreateCompanionBuilder,
          $$PomodoroRuntimeRecordsTableUpdateCompanionBuilder,
          (PomodoroRuntimeRecord, $$PomodoroRuntimeRecordsTableReferences),
          PomodoroRuntimeRecord,
          PrefetchHooks Function({bool taskId, bool goalId})
        > {
  $$PomodoroRuntimeRecordsTableTableManager(
    _$MichiFocusDatabase db,
    $PomodoroRuntimeRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PomodoroRuntimeRecordsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$PomodoroRuntimeRecordsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PomodoroRuntimeRecordsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> taskId = const Value.absent(),
                Value<String?> taskTitle = const Value.absent(),
                Value<String?> goalId = const Value.absent(),
                Value<int?> taskEstimatedMinutes = const Value.absent(),
                Value<String> phase = const Value.absent(),
                Value<bool> isRunning = const Value.absent(),
                Value<int> remainingSeconds = const Value.absent(),
                Value<int> phaseTotalSeconds = const Value.absent(),
                Value<int> cadenceFocusMinutes = const Value.absent(),
                Value<int> cadenceBreakMinutes = const Value.absent(),
                Value<int> longBreakMinutes = const Value.absent(),
                Value<int> longBreakFrequency = const Value.absent(),
                Value<bool> autoStartBreak = const Value.absent(),
                Value<bool> autoStartFocus = const Value.absent(),
                Value<String> planMode = const Value.absent(),
                Value<int> blockIndex = const Value.absent(),
                Value<int> blockCount = const Value.absent(),
                Value<int> taskFocusedSecondsAtStart = const Value.absent(),
                Value<DateTime?> focusStartedAt = const Value.absent(),
                Value<DateTime?> lastTickAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PomodoroRuntimeRecordsCompanion(
                id: id,
                taskId: taskId,
                taskTitle: taskTitle,
                goalId: goalId,
                taskEstimatedMinutes: taskEstimatedMinutes,
                phase: phase,
                isRunning: isRunning,
                remainingSeconds: remainingSeconds,
                phaseTotalSeconds: phaseTotalSeconds,
                cadenceFocusMinutes: cadenceFocusMinutes,
                cadenceBreakMinutes: cadenceBreakMinutes,
                longBreakMinutes: longBreakMinutes,
                longBreakFrequency: longBreakFrequency,
                autoStartBreak: autoStartBreak,
                autoStartFocus: autoStartFocus,
                planMode: planMode,
                blockIndex: blockIndex,
                blockCount: blockCount,
                taskFocusedSecondsAtStart: taskFocusedSecondsAtStart,
                focusStartedAt: focusStartedAt,
                lastTickAt: lastTickAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> taskId = const Value.absent(),
                Value<String?> taskTitle = const Value.absent(),
                Value<String?> goalId = const Value.absent(),
                Value<int?> taskEstimatedMinutes = const Value.absent(),
                required String phase,
                required bool isRunning,
                required int remainingSeconds,
                required int phaseTotalSeconds,
                required int cadenceFocusMinutes,
                required int cadenceBreakMinutes,
                required int longBreakMinutes,
                required int longBreakFrequency,
                required bool autoStartBreak,
                required bool autoStartFocus,
                required String planMode,
                required int blockIndex,
                required int blockCount,
                required int taskFocusedSecondsAtStart,
                Value<DateTime?> focusStartedAt = const Value.absent(),
                Value<DateTime?> lastTickAt = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => PomodoroRuntimeRecordsCompanion.insert(
                id: id,
                taskId: taskId,
                taskTitle: taskTitle,
                goalId: goalId,
                taskEstimatedMinutes: taskEstimatedMinutes,
                phase: phase,
                isRunning: isRunning,
                remainingSeconds: remainingSeconds,
                phaseTotalSeconds: phaseTotalSeconds,
                cadenceFocusMinutes: cadenceFocusMinutes,
                cadenceBreakMinutes: cadenceBreakMinutes,
                longBreakMinutes: longBreakMinutes,
                longBreakFrequency: longBreakFrequency,
                autoStartBreak: autoStartBreak,
                autoStartFocus: autoStartFocus,
                planMode: planMode,
                blockIndex: blockIndex,
                blockCount: blockCount,
                taskFocusedSecondsAtStart: taskFocusedSecondsAtStart,
                focusStartedAt: focusStartedAt,
                lastTickAt: lastTickAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PomodoroRuntimeRecordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({taskId = false, goalId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (taskId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.taskId,
                                referencedTable:
                                    $$PomodoroRuntimeRecordsTableReferences
                                        ._taskIdTable(db),
                                referencedColumn:
                                    $$PomodoroRuntimeRecordsTableReferences
                                        ._taskIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (goalId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.goalId,
                                referencedTable:
                                    $$PomodoroRuntimeRecordsTableReferences
                                        ._goalIdTable(db),
                                referencedColumn:
                                    $$PomodoroRuntimeRecordsTableReferences
                                        ._goalIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PomodoroRuntimeRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$MichiFocusDatabase,
      $PomodoroRuntimeRecordsTable,
      PomodoroRuntimeRecord,
      $$PomodoroRuntimeRecordsTableFilterComposer,
      $$PomodoroRuntimeRecordsTableOrderingComposer,
      $$PomodoroRuntimeRecordsTableAnnotationComposer,
      $$PomodoroRuntimeRecordsTableCreateCompanionBuilder,
      $$PomodoroRuntimeRecordsTableUpdateCompanionBuilder,
      (PomodoroRuntimeRecord, $$PomodoroRuntimeRecordsTableReferences),
      PomodoroRuntimeRecord,
      PrefetchHooks Function({bool taskId, bool goalId})
    >;
typedef $$CalendarEventRecordsTableCreateCompanionBuilder =
    CalendarEventRecordsCompanion Function({
      required String id,
      required String title,
      required DateTime scheduledAt,
      required int durationMinutes,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$CalendarEventRecordsTableUpdateCompanionBuilder =
    CalendarEventRecordsCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<DateTime> scheduledAt,
      Value<int> durationMinutes,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$CalendarEventRecordsTableFilterComposer
    extends Composer<_$MichiFocusDatabase, $CalendarEventRecordsTable> {
  $$CalendarEventRecordsTableFilterComposer({
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

  ColumnFilters<DateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CalendarEventRecordsTableOrderingComposer
    extends Composer<_$MichiFocusDatabase, $CalendarEventRecordsTable> {
  $$CalendarEventRecordsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CalendarEventRecordsTableAnnotationComposer
    extends Composer<_$MichiFocusDatabase, $CalendarEventRecordsTable> {
  $$CalendarEventRecordsTableAnnotationComposer({
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

  GeneratedColumn<DateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$CalendarEventRecordsTableTableManager
    extends
        RootTableManager<
          _$MichiFocusDatabase,
          $CalendarEventRecordsTable,
          CalendarEventRecord,
          $$CalendarEventRecordsTableFilterComposer,
          $$CalendarEventRecordsTableOrderingComposer,
          $$CalendarEventRecordsTableAnnotationComposer,
          $$CalendarEventRecordsTableCreateCompanionBuilder,
          $$CalendarEventRecordsTableUpdateCompanionBuilder,
          (
            CalendarEventRecord,
            BaseReferences<
              _$MichiFocusDatabase,
              $CalendarEventRecordsTable,
              CalendarEventRecord
            >,
          ),
          CalendarEventRecord,
          PrefetchHooks Function()
        > {
  $$CalendarEventRecordsTableTableManager(
    _$MichiFocusDatabase db,
    $CalendarEventRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CalendarEventRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CalendarEventRecordsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CalendarEventRecordsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<DateTime> scheduledAt = const Value.absent(),
                Value<int> durationMinutes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CalendarEventRecordsCompanion(
                id: id,
                title: title,
                scheduledAt: scheduledAt,
                durationMinutes: durationMinutes,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required DateTime scheduledAt,
                required int durationMinutes,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => CalendarEventRecordsCompanion.insert(
                id: id,
                title: title,
                scheduledAt: scheduledAt,
                durationMinutes: durationMinutes,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CalendarEventRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$MichiFocusDatabase,
      $CalendarEventRecordsTable,
      CalendarEventRecord,
      $$CalendarEventRecordsTableFilterComposer,
      $$CalendarEventRecordsTableOrderingComposer,
      $$CalendarEventRecordsTableAnnotationComposer,
      $$CalendarEventRecordsTableCreateCompanionBuilder,
      $$CalendarEventRecordsTableUpdateCompanionBuilder,
      (
        CalendarEventRecord,
        BaseReferences<
          _$MichiFocusDatabase,
          $CalendarEventRecordsTable,
          CalendarEventRecord
        >,
      ),
      CalendarEventRecord,
      PrefetchHooks Function()
    >;

class $MichiFocusDatabaseManager {
  final _$MichiFocusDatabase _db;
  $MichiFocusDatabaseManager(this._db);
  $$GoalRecordsTableTableManager get goalRecords =>
      $$GoalRecordsTableTableManager(_db, _db.goalRecords);
  $$TaskRecordsTableTableManager get taskRecords =>
      $$TaskRecordsTableTableManager(_db, _db.taskRecords);
  $$TaskCompletionEventRecordsTableTableManager
  get taskCompletionEventRecords =>
      $$TaskCompletionEventRecordsTableTableManager(
        _db,
        _db.taskCompletionEventRecords,
      );
  $$ReportingMetadataRecordsTableTableManager get reportingMetadataRecords =>
      $$ReportingMetadataRecordsTableTableManager(
        _db,
        _db.reportingMetadataRecords,
      );
  $$PomodoroSessionRecordsTableTableManager get pomodoroSessionRecords =>
      $$PomodoroSessionRecordsTableTableManager(
        _db,
        _db.pomodoroSessionRecords,
      );
  $$PomodoroRuntimeRecordsTableTableManager get pomodoroRuntimeRecords =>
      $$PomodoroRuntimeRecordsTableTableManager(
        _db,
        _db.pomodoroRuntimeRecords,
      );
  $$CalendarEventRecordsTableTableManager get calendarEventRecords =>
      $$CalendarEventRecordsTableTableManager(_db, _db.calendarEventRecords);
}
