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

mixin _$RoutinesDaoMixin on DatabaseAccessor<MichiFocusDatabase> {
  $RoutineRecordsTable get routineRecords => attachedDatabase.routineRecords;
  $RoutineDayRecordsTable get routineDayRecords =>
      attachedDatabase.routineDayRecords;
  $GoalRecordsTable get goalRecords => attachedDatabase.goalRecords;
  $RoutineItemRecordsTable get routineItemRecords =>
      attachedDatabase.routineItemRecords;
  $RoutineRunRecordsTable get routineRunRecords =>
      attachedDatabase.routineRunRecords;
  $TaskRecordsTable get taskRecords => attachedDatabase.taskRecords;
  $RoutineItemRunRecordsTable get routineItemRunRecords =>
      attachedDatabase.routineItemRunRecords;
  $PomodoroRuntimeRecordsTable get pomodoroRuntimeRecords =>
      attachedDatabase.pomodoroRuntimeRecords;
  RoutinesDaoManager get managers => RoutinesDaoManager(this);
}

class RoutinesDaoManager {
  final _$RoutinesDaoMixin _db;
  RoutinesDaoManager(this._db);
  $$RoutineRecordsTableTableManager get routineRecords =>
      $$RoutineRecordsTableTableManager(
        _db.attachedDatabase,
        _db.routineRecords,
      );
  $$RoutineDayRecordsTableTableManager get routineDayRecords =>
      $$RoutineDayRecordsTableTableManager(
        _db.attachedDatabase,
        _db.routineDayRecords,
      );
  $$GoalRecordsTableTableManager get goalRecords =>
      $$GoalRecordsTableTableManager(_db.attachedDatabase, _db.goalRecords);
  $$RoutineItemRecordsTableTableManager get routineItemRecords =>
      $$RoutineItemRecordsTableTableManager(
        _db.attachedDatabase,
        _db.routineItemRecords,
      );
  $$RoutineRunRecordsTableTableManager get routineRunRecords =>
      $$RoutineRunRecordsTableTableManager(
        _db.attachedDatabase,
        _db.routineRunRecords,
      );
  $$TaskRecordsTableTableManager get taskRecords =>
      $$TaskRecordsTableTableManager(_db.attachedDatabase, _db.taskRecords);
  $$RoutineItemRunRecordsTableTableManager get routineItemRunRecords =>
      $$RoutineItemRunRecordsTableTableManager(
        _db.attachedDatabase,
        _db.routineItemRunRecords,
      );
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

mixin _$QuickNotesDaoMixin on DatabaseAccessor<MichiFocusDatabase> {
  $QuickNoteRecordsTable get quickNoteRecords =>
      attachedDatabase.quickNoteRecords;
  QuickNotesDaoManager get managers => QuickNotesDaoManager(this);
}

class QuickNotesDaoManager {
  final _$QuickNotesDaoMixin _db;
  QuickNotesDaoManager(this._db);
  $$QuickNoteRecordsTableTableManager get quickNoteRecords =>
      $$QuickNoteRecordsTableTableManager(
        _db.attachedDatabase,
        _db.quickNoteRecords,
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
  $RoutineRecordsTable get routineRecords => attachedDatabase.routineRecords;
  $RoutineRunRecordsTable get routineRunRecords =>
      attachedDatabase.routineRunRecords;
  $RoutineItemRecordsTable get routineItemRecords =>
      attachedDatabase.routineItemRecords;
  $RoutineItemRunRecordsTable get routineItemRunRecords =>
      attachedDatabase.routineItemRunRecords;
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
  $$RoutineRecordsTableTableManager get routineRecords =>
      $$RoutineRecordsTableTableManager(
        _db.attachedDatabase,
        _db.routineRecords,
      );
  $$RoutineRunRecordsTableTableManager get routineRunRecords =>
      $$RoutineRunRecordsTableTableManager(
        _db.attachedDatabase,
        _db.routineRunRecords,
      );
  $$RoutineItemRecordsTableTableManager get routineItemRecords =>
      $$RoutineItemRecordsTableTableManager(
        _db.attachedDatabase,
        _db.routineItemRecords,
      );
  $$RoutineItemRunRecordsTableTableManager get routineItemRunRecords =>
      $$RoutineItemRunRecordsTableTableManager(
        _db.attachedDatabase,
        _db.routineItemRunRecords,
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
  static const VerificationMeta _moodPromptPendingMeta = const VerificationMeta(
    'moodPromptPending',
  );
  @override
  late final GeneratedColumn<bool> moodPromptPending = GeneratedColumn<bool>(
    'mood_prompt_pending',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("mood_prompt_pending" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
    moodPromptPending,
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
    if (data.containsKey('mood_prompt_pending')) {
      context.handle(
        _moodPromptPendingMeta,
        moodPromptPending.isAcceptableOrUnknown(
          data['mood_prompt_pending']!,
          _moodPromptPendingMeta,
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
      moodPromptPending: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}mood_prompt_pending'],
      )!,
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
  final bool moodPromptPending;
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
    required this.moodPromptPending,
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
    map['mood_prompt_pending'] = Variable<bool>(moodPromptPending);
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
      moodPromptPending: Value(moodPromptPending),
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
      moodPromptPending: serializer.fromJson<bool>(json['moodPromptPending']),
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
      'moodPromptPending': serializer.toJson<bool>(moodPromptPending),
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
    bool? moodPromptPending,
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
    moodPromptPending: moodPromptPending ?? this.moodPromptPending,
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
      moodPromptPending: data.moodPromptPending.present
          ? data.moodPromptPending.value
          : this.moodPromptPending,
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
          ..write('moodPromptPending: $moodPromptPending, ')
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
    moodPromptPending,
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
          other.moodPromptPending == this.moodPromptPending &&
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
  final Value<bool> moodPromptPending;
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
    this.moodPromptPending = const Value.absent(),
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
    this.moodPromptPending = const Value.absent(),
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
    Expression<bool>? moodPromptPending,
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
      if (moodPromptPending != null) 'mood_prompt_pending': moodPromptPending,
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
    Value<bool>? moodPromptPending,
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
      moodPromptPending: moodPromptPending ?? this.moodPromptPending,
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
    if (moodPromptPending.present) {
      map['mood_prompt_pending'] = Variable<bool>(moodPromptPending.value);
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
          ..write('moodPromptPending: $moodPromptPending, ')
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

class $RoutineRecordsTable extends RoutineRecords
    with TableInfo<$RoutineRecordsTable, RoutineRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoutineRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
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
  static const VerificationMeta _iconKeyMeta = const VerificationMeta(
    'iconKey',
  );
  @override
  late final GeneratedColumn<String> iconKey = GeneratedColumn<String>(
    'icon_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('routine'),
  );
  static const VerificationMeta _colorKeyMeta = const VerificationMeta(
    'colorKey',
  );
  @override
  late final GeneratedColumn<String> colorKey = GeneratedColumn<String>(
    'color_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('primary'),
  );
  static const VerificationMeta _customColorArgbMeta = const VerificationMeta(
    'customColorArgb',
  );
  @override
  late final GeneratedColumn<int> customColorArgb = GeneratedColumn<int>(
    'custom_color_argb',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _validFromLocalDateMeta =
      const VerificationMeta('validFromLocalDate');
  @override
  late final GeneratedColumn<String> validFromLocalDate =
      GeneratedColumn<String>(
        'valid_from_local_date',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _validUntilLocalDateMeta =
      const VerificationMeta('validUntilLocalDate');
  @override
  late final GeneratedColumn<String> validUntilLocalDate =
      GeneratedColumn<String>(
        'valid_until_local_date',
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
    defaultValue: const Constant('active'),
  );
  static const VerificationMeta _pausedUntilLocalDateMeta =
      const VerificationMeta('pausedUntilLocalDate');
  @override
  late final GeneratedColumn<String> pausedUntilLocalDate =
      GeneratedColumn<String>(
        'paused_until_local_date',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
    'archived_at',
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
    name,
    description,
    iconKey,
    colorKey,
    customColorArgb,
    validFromLocalDate,
    validUntilLocalDate,
    status,
    pausedUntilLocalDate,
    archivedAt,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'routines';
  @override
  VerificationContext validateIntegrity(
    Insertable<RoutineRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
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
    if (data.containsKey('icon_key')) {
      context.handle(
        _iconKeyMeta,
        iconKey.isAcceptableOrUnknown(data['icon_key']!, _iconKeyMeta),
      );
    }
    if (data.containsKey('color_key')) {
      context.handle(
        _colorKeyMeta,
        colorKey.isAcceptableOrUnknown(data['color_key']!, _colorKeyMeta),
      );
    }
    if (data.containsKey('custom_color_argb')) {
      context.handle(
        _customColorArgbMeta,
        customColorArgb.isAcceptableOrUnknown(
          data['custom_color_argb']!,
          _customColorArgbMeta,
        ),
      );
    }
    if (data.containsKey('valid_from_local_date')) {
      context.handle(
        _validFromLocalDateMeta,
        validFromLocalDate.isAcceptableOrUnknown(
          data['valid_from_local_date']!,
          _validFromLocalDateMeta,
        ),
      );
    }
    if (data.containsKey('valid_until_local_date')) {
      context.handle(
        _validUntilLocalDateMeta,
        validUntilLocalDate.isAcceptableOrUnknown(
          data['valid_until_local_date']!,
          _validUntilLocalDateMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('paused_until_local_date')) {
      context.handle(
        _pausedUntilLocalDateMeta,
        pausedUntilLocalDate.isAcceptableOrUnknown(
          data['paused_until_local_date']!,
          _pausedUntilLocalDateMeta,
        ),
      );
    }
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
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
  RoutineRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RoutineRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      iconKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_key'],
      )!,
      colorKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color_key'],
      )!,
      customColorArgb: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}custom_color_argb'],
      ),
      validFromLocalDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}valid_from_local_date'],
      ),
      validUntilLocalDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}valid_until_local_date'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      pausedUntilLocalDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}paused_until_local_date'],
      ),
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archived_at'],
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
  $RoutineRecordsTable createAlias(String alias) {
    return $RoutineRecordsTable(attachedDatabase, alias);
  }
}

class RoutineRecord extends DataClass implements Insertable<RoutineRecord> {
  final String id;
  final String name;
  final String? description;
  final String iconKey;
  final String colorKey;
  final int? customColorArgb;
  final String? validFromLocalDate;
  final String? validUntilLocalDate;
  final String status;
  final String? pausedUntilLocalDate;
  final DateTime? archivedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const RoutineRecord({
    required this.id,
    required this.name,
    this.description,
    required this.iconKey,
    required this.colorKey,
    this.customColorArgb,
    this.validFromLocalDate,
    this.validUntilLocalDate,
    required this.status,
    this.pausedUntilLocalDate,
    this.archivedAt,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['icon_key'] = Variable<String>(iconKey);
    map['color_key'] = Variable<String>(colorKey);
    if (!nullToAbsent || customColorArgb != null) {
      map['custom_color_argb'] = Variable<int>(customColorArgb);
    }
    if (!nullToAbsent || validFromLocalDate != null) {
      map['valid_from_local_date'] = Variable<String>(validFromLocalDate);
    }
    if (!nullToAbsent || validUntilLocalDate != null) {
      map['valid_until_local_date'] = Variable<String>(validUntilLocalDate);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || pausedUntilLocalDate != null) {
      map['paused_until_local_date'] = Variable<String>(pausedUntilLocalDate);
    }
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  RoutineRecordsCompanion toCompanion(bool nullToAbsent) {
    return RoutineRecordsCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      iconKey: Value(iconKey),
      colorKey: Value(colorKey),
      customColorArgb: customColorArgb == null && nullToAbsent
          ? const Value.absent()
          : Value(customColorArgb),
      validFromLocalDate: validFromLocalDate == null && nullToAbsent
          ? const Value.absent()
          : Value(validFromLocalDate),
      validUntilLocalDate: validUntilLocalDate == null && nullToAbsent
          ? const Value.absent()
          : Value(validUntilLocalDate),
      status: Value(status),
      pausedUntilLocalDate: pausedUntilLocalDate == null && nullToAbsent
          ? const Value.absent()
          : Value(pausedUntilLocalDate),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory RoutineRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RoutineRecord(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      iconKey: serializer.fromJson<String>(json['iconKey']),
      colorKey: serializer.fromJson<String>(json['colorKey']),
      customColorArgb: serializer.fromJson<int?>(json['customColorArgb']),
      validFromLocalDate: serializer.fromJson<String?>(
        json['validFromLocalDate'],
      ),
      validUntilLocalDate: serializer.fromJson<String?>(
        json['validUntilLocalDate'],
      ),
      status: serializer.fromJson<String>(json['status']),
      pausedUntilLocalDate: serializer.fromJson<String?>(
        json['pausedUntilLocalDate'],
      ),
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'iconKey': serializer.toJson<String>(iconKey),
      'colorKey': serializer.toJson<String>(colorKey),
      'customColorArgb': serializer.toJson<int?>(customColorArgb),
      'validFromLocalDate': serializer.toJson<String?>(validFromLocalDate),
      'validUntilLocalDate': serializer.toJson<String?>(validUntilLocalDate),
      'status': serializer.toJson<String>(status),
      'pausedUntilLocalDate': serializer.toJson<String?>(pausedUntilLocalDate),
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  RoutineRecord copyWith({
    String? id,
    String? name,
    Value<String?> description = const Value.absent(),
    String? iconKey,
    String? colorKey,
    Value<int?> customColorArgb = const Value.absent(),
    Value<String?> validFromLocalDate = const Value.absent(),
    Value<String?> validUntilLocalDate = const Value.absent(),
    String? status,
    Value<String?> pausedUntilLocalDate = const Value.absent(),
    Value<DateTime?> archivedAt = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => RoutineRecord(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    iconKey: iconKey ?? this.iconKey,
    colorKey: colorKey ?? this.colorKey,
    customColorArgb: customColorArgb.present
        ? customColorArgb.value
        : this.customColorArgb,
    validFromLocalDate: validFromLocalDate.present
        ? validFromLocalDate.value
        : this.validFromLocalDate,
    validUntilLocalDate: validUntilLocalDate.present
        ? validUntilLocalDate.value
        : this.validUntilLocalDate,
    status: status ?? this.status,
    pausedUntilLocalDate: pausedUntilLocalDate.present
        ? pausedUntilLocalDate.value
        : this.pausedUntilLocalDate,
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  RoutineRecord copyWithCompanion(RoutineRecordsCompanion data) {
    return RoutineRecord(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      iconKey: data.iconKey.present ? data.iconKey.value : this.iconKey,
      colorKey: data.colorKey.present ? data.colorKey.value : this.colorKey,
      customColorArgb: data.customColorArgb.present
          ? data.customColorArgb.value
          : this.customColorArgb,
      validFromLocalDate: data.validFromLocalDate.present
          ? data.validFromLocalDate.value
          : this.validFromLocalDate,
      validUntilLocalDate: data.validUntilLocalDate.present
          ? data.validUntilLocalDate.value
          : this.validUntilLocalDate,
      status: data.status.present ? data.status.value : this.status,
      pausedUntilLocalDate: data.pausedUntilLocalDate.present
          ? data.pausedUntilLocalDate.value
          : this.pausedUntilLocalDate,
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RoutineRecord(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('iconKey: $iconKey, ')
          ..write('colorKey: $colorKey, ')
          ..write('customColorArgb: $customColorArgb, ')
          ..write('validFromLocalDate: $validFromLocalDate, ')
          ..write('validUntilLocalDate: $validUntilLocalDate, ')
          ..write('status: $status, ')
          ..write('pausedUntilLocalDate: $pausedUntilLocalDate, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    description,
    iconKey,
    colorKey,
    customColorArgb,
    validFromLocalDate,
    validUntilLocalDate,
    status,
    pausedUntilLocalDate,
    archivedAt,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RoutineRecord &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.iconKey == this.iconKey &&
          other.colorKey == this.colorKey &&
          other.customColorArgb == this.customColorArgb &&
          other.validFromLocalDate == this.validFromLocalDate &&
          other.validUntilLocalDate == this.validUntilLocalDate &&
          other.status == this.status &&
          other.pausedUntilLocalDate == this.pausedUntilLocalDate &&
          other.archivedAt == this.archivedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RoutineRecordsCompanion extends UpdateCompanion<RoutineRecord> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<String> iconKey;
  final Value<String> colorKey;
  final Value<int?> customColorArgb;
  final Value<String?> validFromLocalDate;
  final Value<String?> validUntilLocalDate;
  final Value<String> status;
  final Value<String?> pausedUntilLocalDate;
  final Value<DateTime?> archivedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const RoutineRecordsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.iconKey = const Value.absent(),
    this.colorKey = const Value.absent(),
    this.customColorArgb = const Value.absent(),
    this.validFromLocalDate = const Value.absent(),
    this.validUntilLocalDate = const Value.absent(),
    this.status = const Value.absent(),
    this.pausedUntilLocalDate = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RoutineRecordsCompanion.insert({
    required String id,
    required String name,
    this.description = const Value.absent(),
    this.iconKey = const Value.absent(),
    this.colorKey = const Value.absent(),
    this.customColorArgb = const Value.absent(),
    this.validFromLocalDate = const Value.absent(),
    this.validUntilLocalDate = const Value.absent(),
    this.status = const Value.absent(),
    this.pausedUntilLocalDate = const Value.absent(),
    this.archivedAt = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<RoutineRecord> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? iconKey,
    Expression<String>? colorKey,
    Expression<int>? customColorArgb,
    Expression<String>? validFromLocalDate,
    Expression<String>? validUntilLocalDate,
    Expression<String>? status,
    Expression<String>? pausedUntilLocalDate,
    Expression<DateTime>? archivedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (iconKey != null) 'icon_key': iconKey,
      if (colorKey != null) 'color_key': colorKey,
      if (customColorArgb != null) 'custom_color_argb': customColorArgb,
      if (validFromLocalDate != null)
        'valid_from_local_date': validFromLocalDate,
      if (validUntilLocalDate != null)
        'valid_until_local_date': validUntilLocalDate,
      if (status != null) 'status': status,
      if (pausedUntilLocalDate != null)
        'paused_until_local_date': pausedUntilLocalDate,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RoutineRecordsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? description,
    Value<String>? iconKey,
    Value<String>? colorKey,
    Value<int?>? customColorArgb,
    Value<String?>? validFromLocalDate,
    Value<String?>? validUntilLocalDate,
    Value<String>? status,
    Value<String?>? pausedUntilLocalDate,
    Value<DateTime?>? archivedAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return RoutineRecordsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      iconKey: iconKey ?? this.iconKey,
      colorKey: colorKey ?? this.colorKey,
      customColorArgb: customColorArgb ?? this.customColorArgb,
      validFromLocalDate: validFromLocalDate ?? this.validFromLocalDate,
      validUntilLocalDate: validUntilLocalDate ?? this.validUntilLocalDate,
      status: status ?? this.status,
      pausedUntilLocalDate: pausedUntilLocalDate ?? this.pausedUntilLocalDate,
      archivedAt: archivedAt ?? this.archivedAt,
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
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (iconKey.present) {
      map['icon_key'] = Variable<String>(iconKey.value);
    }
    if (colorKey.present) {
      map['color_key'] = Variable<String>(colorKey.value);
    }
    if (customColorArgb.present) {
      map['custom_color_argb'] = Variable<int>(customColorArgb.value);
    }
    if (validFromLocalDate.present) {
      map['valid_from_local_date'] = Variable<String>(validFromLocalDate.value);
    }
    if (validUntilLocalDate.present) {
      map['valid_until_local_date'] = Variable<String>(
        validUntilLocalDate.value,
      );
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (pausedUntilLocalDate.present) {
      map['paused_until_local_date'] = Variable<String>(
        pausedUntilLocalDate.value,
      );
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
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
    return (StringBuffer('RoutineRecordsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('iconKey: $iconKey, ')
          ..write('colorKey: $colorKey, ')
          ..write('customColorArgb: $customColorArgb, ')
          ..write('validFromLocalDate: $validFromLocalDate, ')
          ..write('validUntilLocalDate: $validUntilLocalDate, ')
          ..write('status: $status, ')
          ..write('pausedUntilLocalDate: $pausedUntilLocalDate, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RoutineDayRecordsTable extends RoutineDayRecords
    with TableInfo<$RoutineDayRecordsTable, RoutineDayRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoutineDayRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _routineIdMeta = const VerificationMeta(
    'routineId',
  );
  @override
  late final GeneratedColumn<String> routineId = GeneratedColumn<String>(
    'routine_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES routines (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _weekdayMeta = const VerificationMeta(
    'weekday',
  );
  @override
  late final GeneratedColumn<int> weekday = GeneratedColumn<int>(
    'weekday',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [routineId, weekday];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'routine_days';
  @override
  VerificationContext validateIntegrity(
    Insertable<RoutineDayRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('routine_id')) {
      context.handle(
        _routineIdMeta,
        routineId.isAcceptableOrUnknown(data['routine_id']!, _routineIdMeta),
      );
    } else if (isInserting) {
      context.missing(_routineIdMeta);
    }
    if (data.containsKey('weekday')) {
      context.handle(
        _weekdayMeta,
        weekday.isAcceptableOrUnknown(data['weekday']!, _weekdayMeta),
      );
    } else if (isInserting) {
      context.missing(_weekdayMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {routineId, weekday};
  @override
  RoutineDayRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RoutineDayRecord(
      routineId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}routine_id'],
      )!,
      weekday: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weekday'],
      )!,
    );
  }

  @override
  $RoutineDayRecordsTable createAlias(String alias) {
    return $RoutineDayRecordsTable(attachedDatabase, alias);
  }
}

class RoutineDayRecord extends DataClass
    implements Insertable<RoutineDayRecord> {
  final String routineId;
  final int weekday;
  const RoutineDayRecord({required this.routineId, required this.weekday});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['routine_id'] = Variable<String>(routineId);
    map['weekday'] = Variable<int>(weekday);
    return map;
  }

  RoutineDayRecordsCompanion toCompanion(bool nullToAbsent) {
    return RoutineDayRecordsCompanion(
      routineId: Value(routineId),
      weekday: Value(weekday),
    );
  }

  factory RoutineDayRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RoutineDayRecord(
      routineId: serializer.fromJson<String>(json['routineId']),
      weekday: serializer.fromJson<int>(json['weekday']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'routineId': serializer.toJson<String>(routineId),
      'weekday': serializer.toJson<int>(weekday),
    };
  }

  RoutineDayRecord copyWith({String? routineId, int? weekday}) =>
      RoutineDayRecord(
        routineId: routineId ?? this.routineId,
        weekday: weekday ?? this.weekday,
      );
  RoutineDayRecord copyWithCompanion(RoutineDayRecordsCompanion data) {
    return RoutineDayRecord(
      routineId: data.routineId.present ? data.routineId.value : this.routineId,
      weekday: data.weekday.present ? data.weekday.value : this.weekday,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RoutineDayRecord(')
          ..write('routineId: $routineId, ')
          ..write('weekday: $weekday')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(routineId, weekday);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RoutineDayRecord &&
          other.routineId == this.routineId &&
          other.weekday == this.weekday);
}

class RoutineDayRecordsCompanion extends UpdateCompanion<RoutineDayRecord> {
  final Value<String> routineId;
  final Value<int> weekday;
  final Value<int> rowid;
  const RoutineDayRecordsCompanion({
    this.routineId = const Value.absent(),
    this.weekday = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RoutineDayRecordsCompanion.insert({
    required String routineId,
    required int weekday,
    this.rowid = const Value.absent(),
  }) : routineId = Value(routineId),
       weekday = Value(weekday);
  static Insertable<RoutineDayRecord> custom({
    Expression<String>? routineId,
    Expression<int>? weekday,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (routineId != null) 'routine_id': routineId,
      if (weekday != null) 'weekday': weekday,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RoutineDayRecordsCompanion copyWith({
    Value<String>? routineId,
    Value<int>? weekday,
    Value<int>? rowid,
  }) {
    return RoutineDayRecordsCompanion(
      routineId: routineId ?? this.routineId,
      weekday: weekday ?? this.weekday,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (routineId.present) {
      map['routine_id'] = Variable<String>(routineId.value);
    }
    if (weekday.present) {
      map['weekday'] = Variable<int>(weekday.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoutineDayRecordsCompanion(')
          ..write('routineId: $routineId, ')
          ..write('weekday: $weekday, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RoutineItemRecordsTable extends RoutineItemRecords
    with TableInfo<$RoutineItemRecordsTable, RoutineItemRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoutineItemRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _routineIdMeta = const VerificationMeta(
    'routineId',
  );
  @override
  late final GeneratedColumn<String> routineId = GeneratedColumn<String>(
    'routine_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES routines (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
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
  static const VerificationMeta _scheduledMinuteMeta = const VerificationMeta(
    'scheduledMinute',
  );
  @override
  late final GeneratedColumn<int> scheduledMinute = GeneratedColumn<int>(
    'scheduled_minute',
    aliasedName,
    false,
    type: DriftSqlType.int,
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
  static const VerificationMeta _isOptionalMeta = const VerificationMeta(
    'isOptional',
  );
  @override
  late final GeneratedColumn<bool> isOptional = GeneratedColumn<bool>(
    'is_optional',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_optional" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _reminderMinutesBeforeMeta =
      const VerificationMeta('reminderMinutesBefore');
  @override
  late final GeneratedColumn<int> reminderMinutesBefore = GeneratedColumn<int>(
    'reminder_minutes_before',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pomodoroModeMeta = const VerificationMeta(
    'pomodoroMode',
  );
  @override
  late final GeneratedColumn<String> pomodoroMode = GeneratedColumn<String>(
    'pomodoro_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('none'),
  );
  static const VerificationMeta _customFocusMinutesMeta =
      const VerificationMeta('customFocusMinutes');
  @override
  late final GeneratedColumn<int> customFocusMinutes = GeneratedColumn<int>(
    'custom_focus_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _customBreakMinutesMeta =
      const VerificationMeta('customBreakMinutes');
  @override
  late final GeneratedColumn<int> customBreakMinutes = GeneratedColumn<int>(
    'custom_break_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
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
    routineId,
    position,
    title,
    scheduledMinute,
    durationMinutes,
    goalId,
    isOptional,
    reminderMinutesBefore,
    pomodoroMode,
    customFocusMinutes,
    customBreakMinutes,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'routine_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<RoutineItemRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('routine_id')) {
      context.handle(
        _routineIdMeta,
        routineId.isAcceptableOrUnknown(data['routine_id']!, _routineIdMeta),
      );
    } else if (isInserting) {
      context.missing(_routineIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('scheduled_minute')) {
      context.handle(
        _scheduledMinuteMeta,
        scheduledMinute.isAcceptableOrUnknown(
          data['scheduled_minute']!,
          _scheduledMinuteMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scheduledMinuteMeta);
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
    if (data.containsKey('goal_id')) {
      context.handle(
        _goalIdMeta,
        goalId.isAcceptableOrUnknown(data['goal_id']!, _goalIdMeta),
      );
    }
    if (data.containsKey('is_optional')) {
      context.handle(
        _isOptionalMeta,
        isOptional.isAcceptableOrUnknown(data['is_optional']!, _isOptionalMeta),
      );
    }
    if (data.containsKey('reminder_minutes_before')) {
      context.handle(
        _reminderMinutesBeforeMeta,
        reminderMinutesBefore.isAcceptableOrUnknown(
          data['reminder_minutes_before']!,
          _reminderMinutesBeforeMeta,
        ),
      );
    }
    if (data.containsKey('pomodoro_mode')) {
      context.handle(
        _pomodoroModeMeta,
        pomodoroMode.isAcceptableOrUnknown(
          data['pomodoro_mode']!,
          _pomodoroModeMeta,
        ),
      );
    }
    if (data.containsKey('custom_focus_minutes')) {
      context.handle(
        _customFocusMinutesMeta,
        customFocusMinutes.isAcceptableOrUnknown(
          data['custom_focus_minutes']!,
          _customFocusMinutesMeta,
        ),
      );
    }
    if (data.containsKey('custom_break_minutes')) {
      context.handle(
        _customBreakMinutesMeta,
        customBreakMinutes.isAcceptableOrUnknown(
          data['custom_break_minutes']!,
          _customBreakMinutesMeta,
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
  RoutineItemRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RoutineItemRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      routineId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}routine_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      scheduledMinute: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}scheduled_minute'],
      )!,
      durationMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_minutes'],
      )!,
      goalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}goal_id'],
      ),
      isOptional: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_optional'],
      )!,
      reminderMinutesBefore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reminder_minutes_before'],
      ),
      pomodoroMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pomodoro_mode'],
      )!,
      customFocusMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}custom_focus_minutes'],
      ),
      customBreakMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}custom_break_minutes'],
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
  $RoutineItemRecordsTable createAlias(String alias) {
    return $RoutineItemRecordsTable(attachedDatabase, alias);
  }
}

class RoutineItemRecord extends DataClass
    implements Insertable<RoutineItemRecord> {
  final String id;
  final String routineId;
  final int position;
  final String title;
  final int scheduledMinute;
  final int durationMinutes;
  final String? goalId;
  final bool isOptional;
  final int? reminderMinutesBefore;
  final String pomodoroMode;
  final int? customFocusMinutes;
  final int? customBreakMinutes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const RoutineItemRecord({
    required this.id,
    required this.routineId,
    required this.position,
    required this.title,
    required this.scheduledMinute,
    required this.durationMinutes,
    this.goalId,
    required this.isOptional,
    this.reminderMinutesBefore,
    required this.pomodoroMode,
    this.customFocusMinutes,
    this.customBreakMinutes,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['routine_id'] = Variable<String>(routineId);
    map['position'] = Variable<int>(position);
    map['title'] = Variable<String>(title);
    map['scheduled_minute'] = Variable<int>(scheduledMinute);
    map['duration_minutes'] = Variable<int>(durationMinutes);
    if (!nullToAbsent || goalId != null) {
      map['goal_id'] = Variable<String>(goalId);
    }
    map['is_optional'] = Variable<bool>(isOptional);
    if (!nullToAbsent || reminderMinutesBefore != null) {
      map['reminder_minutes_before'] = Variable<int>(reminderMinutesBefore);
    }
    map['pomodoro_mode'] = Variable<String>(pomodoroMode);
    if (!nullToAbsent || customFocusMinutes != null) {
      map['custom_focus_minutes'] = Variable<int>(customFocusMinutes);
    }
    if (!nullToAbsent || customBreakMinutes != null) {
      map['custom_break_minutes'] = Variable<int>(customBreakMinutes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  RoutineItemRecordsCompanion toCompanion(bool nullToAbsent) {
    return RoutineItemRecordsCompanion(
      id: Value(id),
      routineId: Value(routineId),
      position: Value(position),
      title: Value(title),
      scheduledMinute: Value(scheduledMinute),
      durationMinutes: Value(durationMinutes),
      goalId: goalId == null && nullToAbsent
          ? const Value.absent()
          : Value(goalId),
      isOptional: Value(isOptional),
      reminderMinutesBefore: reminderMinutesBefore == null && nullToAbsent
          ? const Value.absent()
          : Value(reminderMinutesBefore),
      pomodoroMode: Value(pomodoroMode),
      customFocusMinutes: customFocusMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(customFocusMinutes),
      customBreakMinutes: customBreakMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(customBreakMinutes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory RoutineItemRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RoutineItemRecord(
      id: serializer.fromJson<String>(json['id']),
      routineId: serializer.fromJson<String>(json['routineId']),
      position: serializer.fromJson<int>(json['position']),
      title: serializer.fromJson<String>(json['title']),
      scheduledMinute: serializer.fromJson<int>(json['scheduledMinute']),
      durationMinutes: serializer.fromJson<int>(json['durationMinutes']),
      goalId: serializer.fromJson<String?>(json['goalId']),
      isOptional: serializer.fromJson<bool>(json['isOptional']),
      reminderMinutesBefore: serializer.fromJson<int?>(
        json['reminderMinutesBefore'],
      ),
      pomodoroMode: serializer.fromJson<String>(json['pomodoroMode']),
      customFocusMinutes: serializer.fromJson<int?>(json['customFocusMinutes']),
      customBreakMinutes: serializer.fromJson<int?>(json['customBreakMinutes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'routineId': serializer.toJson<String>(routineId),
      'position': serializer.toJson<int>(position),
      'title': serializer.toJson<String>(title),
      'scheduledMinute': serializer.toJson<int>(scheduledMinute),
      'durationMinutes': serializer.toJson<int>(durationMinutes),
      'goalId': serializer.toJson<String?>(goalId),
      'isOptional': serializer.toJson<bool>(isOptional),
      'reminderMinutesBefore': serializer.toJson<int?>(reminderMinutesBefore),
      'pomodoroMode': serializer.toJson<String>(pomodoroMode),
      'customFocusMinutes': serializer.toJson<int?>(customFocusMinutes),
      'customBreakMinutes': serializer.toJson<int?>(customBreakMinutes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  RoutineItemRecord copyWith({
    String? id,
    String? routineId,
    int? position,
    String? title,
    int? scheduledMinute,
    int? durationMinutes,
    Value<String?> goalId = const Value.absent(),
    bool? isOptional,
    Value<int?> reminderMinutesBefore = const Value.absent(),
    String? pomodoroMode,
    Value<int?> customFocusMinutes = const Value.absent(),
    Value<int?> customBreakMinutes = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => RoutineItemRecord(
    id: id ?? this.id,
    routineId: routineId ?? this.routineId,
    position: position ?? this.position,
    title: title ?? this.title,
    scheduledMinute: scheduledMinute ?? this.scheduledMinute,
    durationMinutes: durationMinutes ?? this.durationMinutes,
    goalId: goalId.present ? goalId.value : this.goalId,
    isOptional: isOptional ?? this.isOptional,
    reminderMinutesBefore: reminderMinutesBefore.present
        ? reminderMinutesBefore.value
        : this.reminderMinutesBefore,
    pomodoroMode: pomodoroMode ?? this.pomodoroMode,
    customFocusMinutes: customFocusMinutes.present
        ? customFocusMinutes.value
        : this.customFocusMinutes,
    customBreakMinutes: customBreakMinutes.present
        ? customBreakMinutes.value
        : this.customBreakMinutes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  RoutineItemRecord copyWithCompanion(RoutineItemRecordsCompanion data) {
    return RoutineItemRecord(
      id: data.id.present ? data.id.value : this.id,
      routineId: data.routineId.present ? data.routineId.value : this.routineId,
      position: data.position.present ? data.position.value : this.position,
      title: data.title.present ? data.title.value : this.title,
      scheduledMinute: data.scheduledMinute.present
          ? data.scheduledMinute.value
          : this.scheduledMinute,
      durationMinutes: data.durationMinutes.present
          ? data.durationMinutes.value
          : this.durationMinutes,
      goalId: data.goalId.present ? data.goalId.value : this.goalId,
      isOptional: data.isOptional.present
          ? data.isOptional.value
          : this.isOptional,
      reminderMinutesBefore: data.reminderMinutesBefore.present
          ? data.reminderMinutesBefore.value
          : this.reminderMinutesBefore,
      pomodoroMode: data.pomodoroMode.present
          ? data.pomodoroMode.value
          : this.pomodoroMode,
      customFocusMinutes: data.customFocusMinutes.present
          ? data.customFocusMinutes.value
          : this.customFocusMinutes,
      customBreakMinutes: data.customBreakMinutes.present
          ? data.customBreakMinutes.value
          : this.customBreakMinutes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RoutineItemRecord(')
          ..write('id: $id, ')
          ..write('routineId: $routineId, ')
          ..write('position: $position, ')
          ..write('title: $title, ')
          ..write('scheduledMinute: $scheduledMinute, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('goalId: $goalId, ')
          ..write('isOptional: $isOptional, ')
          ..write('reminderMinutesBefore: $reminderMinutesBefore, ')
          ..write('pomodoroMode: $pomodoroMode, ')
          ..write('customFocusMinutes: $customFocusMinutes, ')
          ..write('customBreakMinutes: $customBreakMinutes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    routineId,
    position,
    title,
    scheduledMinute,
    durationMinutes,
    goalId,
    isOptional,
    reminderMinutesBefore,
    pomodoroMode,
    customFocusMinutes,
    customBreakMinutes,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RoutineItemRecord &&
          other.id == this.id &&
          other.routineId == this.routineId &&
          other.position == this.position &&
          other.title == this.title &&
          other.scheduledMinute == this.scheduledMinute &&
          other.durationMinutes == this.durationMinutes &&
          other.goalId == this.goalId &&
          other.isOptional == this.isOptional &&
          other.reminderMinutesBefore == this.reminderMinutesBefore &&
          other.pomodoroMode == this.pomodoroMode &&
          other.customFocusMinutes == this.customFocusMinutes &&
          other.customBreakMinutes == this.customBreakMinutes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RoutineItemRecordsCompanion extends UpdateCompanion<RoutineItemRecord> {
  final Value<String> id;
  final Value<String> routineId;
  final Value<int> position;
  final Value<String> title;
  final Value<int> scheduledMinute;
  final Value<int> durationMinutes;
  final Value<String?> goalId;
  final Value<bool> isOptional;
  final Value<int?> reminderMinutesBefore;
  final Value<String> pomodoroMode;
  final Value<int?> customFocusMinutes;
  final Value<int?> customBreakMinutes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const RoutineItemRecordsCompanion({
    this.id = const Value.absent(),
    this.routineId = const Value.absent(),
    this.position = const Value.absent(),
    this.title = const Value.absent(),
    this.scheduledMinute = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    this.goalId = const Value.absent(),
    this.isOptional = const Value.absent(),
    this.reminderMinutesBefore = const Value.absent(),
    this.pomodoroMode = const Value.absent(),
    this.customFocusMinutes = const Value.absent(),
    this.customBreakMinutes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RoutineItemRecordsCompanion.insert({
    required String id,
    required String routineId,
    required int position,
    required String title,
    required int scheduledMinute,
    required int durationMinutes,
    this.goalId = const Value.absent(),
    this.isOptional = const Value.absent(),
    this.reminderMinutesBefore = const Value.absent(),
    this.pomodoroMode = const Value.absent(),
    this.customFocusMinutes = const Value.absent(),
    this.customBreakMinutes = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       routineId = Value(routineId),
       position = Value(position),
       title = Value(title),
       scheduledMinute = Value(scheduledMinute),
       durationMinutes = Value(durationMinutes),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<RoutineItemRecord> custom({
    Expression<String>? id,
    Expression<String>? routineId,
    Expression<int>? position,
    Expression<String>? title,
    Expression<int>? scheduledMinute,
    Expression<int>? durationMinutes,
    Expression<String>? goalId,
    Expression<bool>? isOptional,
    Expression<int>? reminderMinutesBefore,
    Expression<String>? pomodoroMode,
    Expression<int>? customFocusMinutes,
    Expression<int>? customBreakMinutes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (routineId != null) 'routine_id': routineId,
      if (position != null) 'position': position,
      if (title != null) 'title': title,
      if (scheduledMinute != null) 'scheduled_minute': scheduledMinute,
      if (durationMinutes != null) 'duration_minutes': durationMinutes,
      if (goalId != null) 'goal_id': goalId,
      if (isOptional != null) 'is_optional': isOptional,
      if (reminderMinutesBefore != null)
        'reminder_minutes_before': reminderMinutesBefore,
      if (pomodoroMode != null) 'pomodoro_mode': pomodoroMode,
      if (customFocusMinutes != null)
        'custom_focus_minutes': customFocusMinutes,
      if (customBreakMinutes != null)
        'custom_break_minutes': customBreakMinutes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RoutineItemRecordsCompanion copyWith({
    Value<String>? id,
    Value<String>? routineId,
    Value<int>? position,
    Value<String>? title,
    Value<int>? scheduledMinute,
    Value<int>? durationMinutes,
    Value<String?>? goalId,
    Value<bool>? isOptional,
    Value<int?>? reminderMinutesBefore,
    Value<String>? pomodoroMode,
    Value<int?>? customFocusMinutes,
    Value<int?>? customBreakMinutes,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return RoutineItemRecordsCompanion(
      id: id ?? this.id,
      routineId: routineId ?? this.routineId,
      position: position ?? this.position,
      title: title ?? this.title,
      scheduledMinute: scheduledMinute ?? this.scheduledMinute,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      goalId: goalId ?? this.goalId,
      isOptional: isOptional ?? this.isOptional,
      reminderMinutesBefore:
          reminderMinutesBefore ?? this.reminderMinutesBefore,
      pomodoroMode: pomodoroMode ?? this.pomodoroMode,
      customFocusMinutes: customFocusMinutes ?? this.customFocusMinutes,
      customBreakMinutes: customBreakMinutes ?? this.customBreakMinutes,
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
    if (routineId.present) {
      map['routine_id'] = Variable<String>(routineId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (scheduledMinute.present) {
      map['scheduled_minute'] = Variable<int>(scheduledMinute.value);
    }
    if (durationMinutes.present) {
      map['duration_minutes'] = Variable<int>(durationMinutes.value);
    }
    if (goalId.present) {
      map['goal_id'] = Variable<String>(goalId.value);
    }
    if (isOptional.present) {
      map['is_optional'] = Variable<bool>(isOptional.value);
    }
    if (reminderMinutesBefore.present) {
      map['reminder_minutes_before'] = Variable<int>(
        reminderMinutesBefore.value,
      );
    }
    if (pomodoroMode.present) {
      map['pomodoro_mode'] = Variable<String>(pomodoroMode.value);
    }
    if (customFocusMinutes.present) {
      map['custom_focus_minutes'] = Variable<int>(customFocusMinutes.value);
    }
    if (customBreakMinutes.present) {
      map['custom_break_minutes'] = Variable<int>(customBreakMinutes.value);
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
    return (StringBuffer('RoutineItemRecordsCompanion(')
          ..write('id: $id, ')
          ..write('routineId: $routineId, ')
          ..write('position: $position, ')
          ..write('title: $title, ')
          ..write('scheduledMinute: $scheduledMinute, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('goalId: $goalId, ')
          ..write('isOptional: $isOptional, ')
          ..write('reminderMinutesBefore: $reminderMinutesBefore, ')
          ..write('pomodoroMode: $pomodoroMode, ')
          ..write('customFocusMinutes: $customFocusMinutes, ')
          ..write('customBreakMinutes: $customBreakMinutes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RoutineRunRecordsTable extends RoutineRunRecords
    with TableInfo<$RoutineRunRecordsTable, RoutineRunRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoutineRunRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _routineIdMeta = const VerificationMeta(
    'routineId',
  );
  @override
  late final GeneratedColumn<String> routineId = GeneratedColumn<String>(
    'routine_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES routines (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _sourceRoutineIdMeta = const VerificationMeta(
    'sourceRoutineId',
  );
  @override
  late final GeneratedColumn<String> sourceRoutineId = GeneratedColumn<String>(
    'source_routine_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localDateMeta = const VerificationMeta(
    'localDate',
  );
  @override
  late final GeneratedColumn<String> localDate = GeneratedColumn<String>(
    'local_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('scheduled'),
  );
  static const VerificationMeta _nameSnapshotMeta = const VerificationMeta(
    'nameSnapshot',
  );
  @override
  late final GeneratedColumn<String> nameSnapshot = GeneratedColumn<String>(
    'name_snapshot',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconKeySnapshotMeta = const VerificationMeta(
    'iconKeySnapshot',
  );
  @override
  late final GeneratedColumn<String> iconKeySnapshot = GeneratedColumn<String>(
    'icon_key_snapshot',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorKeySnapshotMeta = const VerificationMeta(
    'colorKeySnapshot',
  );
  @override
  late final GeneratedColumn<String> colorKeySnapshot = GeneratedColumn<String>(
    'color_key_snapshot',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customColorArgbSnapshotMeta =
      const VerificationMeta('customColorArgbSnapshot');
  @override
  late final GeneratedColumn<int> customColorArgbSnapshot =
      GeneratedColumn<int>(
        'custom_color_argb_snapshot',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _scheduledStartMinuteSnapshotMeta =
      const VerificationMeta('scheduledStartMinuteSnapshot');
  @override
  late final GeneratedColumn<int> scheduledStartMinuteSnapshot =
      GeneratedColumn<int>(
        'scheduled_start_minute_snapshot',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _skippedAtMeta = const VerificationMeta(
    'skippedAt',
  );
  @override
  late final GeneratedColumn<DateTime> skippedAt = GeneratedColumn<DateTime>(
    'skipped_at',
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
    routineId,
    sourceRoutineId,
    localDate,
    status,
    nameSnapshot,
    iconKeySnapshot,
    colorKeySnapshot,
    customColorArgbSnapshot,
    scheduledStartMinuteSnapshot,
    startedAt,
    completedAt,
    skippedAt,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'routine_runs';
  @override
  VerificationContext validateIntegrity(
    Insertable<RoutineRunRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('routine_id')) {
      context.handle(
        _routineIdMeta,
        routineId.isAcceptableOrUnknown(data['routine_id']!, _routineIdMeta),
      );
    }
    if (data.containsKey('source_routine_id')) {
      context.handle(
        _sourceRoutineIdMeta,
        sourceRoutineId.isAcceptableOrUnknown(
          data['source_routine_id']!,
          _sourceRoutineIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceRoutineIdMeta);
    }
    if (data.containsKey('local_date')) {
      context.handle(
        _localDateMeta,
        localDate.isAcceptableOrUnknown(data['local_date']!, _localDateMeta),
      );
    } else if (isInserting) {
      context.missing(_localDateMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('name_snapshot')) {
      context.handle(
        _nameSnapshotMeta,
        nameSnapshot.isAcceptableOrUnknown(
          data['name_snapshot']!,
          _nameSnapshotMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nameSnapshotMeta);
    }
    if (data.containsKey('icon_key_snapshot')) {
      context.handle(
        _iconKeySnapshotMeta,
        iconKeySnapshot.isAcceptableOrUnknown(
          data['icon_key_snapshot']!,
          _iconKeySnapshotMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_iconKeySnapshotMeta);
    }
    if (data.containsKey('color_key_snapshot')) {
      context.handle(
        _colorKeySnapshotMeta,
        colorKeySnapshot.isAcceptableOrUnknown(
          data['color_key_snapshot']!,
          _colorKeySnapshotMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_colorKeySnapshotMeta);
    }
    if (data.containsKey('custom_color_argb_snapshot')) {
      context.handle(
        _customColorArgbSnapshotMeta,
        customColorArgbSnapshot.isAcceptableOrUnknown(
          data['custom_color_argb_snapshot']!,
          _customColorArgbSnapshotMeta,
        ),
      );
    }
    if (data.containsKey('scheduled_start_minute_snapshot')) {
      context.handle(
        _scheduledStartMinuteSnapshotMeta,
        scheduledStartMinuteSnapshot.isAcceptableOrUnknown(
          data['scheduled_start_minute_snapshot']!,
          _scheduledStartMinuteSnapshotMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scheduledStartMinuteSnapshotMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('skipped_at')) {
      context.handle(
        _skippedAtMeta,
        skippedAt.isAcceptableOrUnknown(data['skipped_at']!, _skippedAtMeta),
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
  RoutineRunRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RoutineRunRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      routineId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}routine_id'],
      ),
      sourceRoutineId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_routine_id'],
      )!,
      localDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_date'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      nameSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_snapshot'],
      )!,
      iconKeySnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_key_snapshot'],
      )!,
      colorKeySnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color_key_snapshot'],
      )!,
      customColorArgbSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}custom_color_argb_snapshot'],
      ),
      scheduledStartMinuteSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}scheduled_start_minute_snapshot'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      ),
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      skippedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}skipped_at'],
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
  $RoutineRunRecordsTable createAlias(String alias) {
    return $RoutineRunRecordsTable(attachedDatabase, alias);
  }
}

class RoutineRunRecord extends DataClass
    implements Insertable<RoutineRunRecord> {
  final String id;
  final String? routineId;
  final String sourceRoutineId;
  final String localDate;
  final String status;
  final String nameSnapshot;
  final String iconKeySnapshot;
  final String colorKeySnapshot;
  final int? customColorArgbSnapshot;
  final int scheduledStartMinuteSnapshot;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final DateTime? skippedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const RoutineRunRecord({
    required this.id,
    this.routineId,
    required this.sourceRoutineId,
    required this.localDate,
    required this.status,
    required this.nameSnapshot,
    required this.iconKeySnapshot,
    required this.colorKeySnapshot,
    this.customColorArgbSnapshot,
    required this.scheduledStartMinuteSnapshot,
    this.startedAt,
    this.completedAt,
    this.skippedAt,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || routineId != null) {
      map['routine_id'] = Variable<String>(routineId);
    }
    map['source_routine_id'] = Variable<String>(sourceRoutineId);
    map['local_date'] = Variable<String>(localDate);
    map['status'] = Variable<String>(status);
    map['name_snapshot'] = Variable<String>(nameSnapshot);
    map['icon_key_snapshot'] = Variable<String>(iconKeySnapshot);
    map['color_key_snapshot'] = Variable<String>(colorKeySnapshot);
    if (!nullToAbsent || customColorArgbSnapshot != null) {
      map['custom_color_argb_snapshot'] = Variable<int>(
        customColorArgbSnapshot,
      );
    }
    map['scheduled_start_minute_snapshot'] = Variable<int>(
      scheduledStartMinuteSnapshot,
    );
    if (!nullToAbsent || startedAt != null) {
      map['started_at'] = Variable<DateTime>(startedAt);
    }
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    if (!nullToAbsent || skippedAt != null) {
      map['skipped_at'] = Variable<DateTime>(skippedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  RoutineRunRecordsCompanion toCompanion(bool nullToAbsent) {
    return RoutineRunRecordsCompanion(
      id: Value(id),
      routineId: routineId == null && nullToAbsent
          ? const Value.absent()
          : Value(routineId),
      sourceRoutineId: Value(sourceRoutineId),
      localDate: Value(localDate),
      status: Value(status),
      nameSnapshot: Value(nameSnapshot),
      iconKeySnapshot: Value(iconKeySnapshot),
      colorKeySnapshot: Value(colorKeySnapshot),
      customColorArgbSnapshot: customColorArgbSnapshot == null && nullToAbsent
          ? const Value.absent()
          : Value(customColorArgbSnapshot),
      scheduledStartMinuteSnapshot: Value(scheduledStartMinuteSnapshot),
      startedAt: startedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(startedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      skippedAt: skippedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(skippedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory RoutineRunRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RoutineRunRecord(
      id: serializer.fromJson<String>(json['id']),
      routineId: serializer.fromJson<String?>(json['routineId']),
      sourceRoutineId: serializer.fromJson<String>(json['sourceRoutineId']),
      localDate: serializer.fromJson<String>(json['localDate']),
      status: serializer.fromJson<String>(json['status']),
      nameSnapshot: serializer.fromJson<String>(json['nameSnapshot']),
      iconKeySnapshot: serializer.fromJson<String>(json['iconKeySnapshot']),
      colorKeySnapshot: serializer.fromJson<String>(json['colorKeySnapshot']),
      customColorArgbSnapshot: serializer.fromJson<int?>(
        json['customColorArgbSnapshot'],
      ),
      scheduledStartMinuteSnapshot: serializer.fromJson<int>(
        json['scheduledStartMinuteSnapshot'],
      ),
      startedAt: serializer.fromJson<DateTime?>(json['startedAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      skippedAt: serializer.fromJson<DateTime?>(json['skippedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'routineId': serializer.toJson<String?>(routineId),
      'sourceRoutineId': serializer.toJson<String>(sourceRoutineId),
      'localDate': serializer.toJson<String>(localDate),
      'status': serializer.toJson<String>(status),
      'nameSnapshot': serializer.toJson<String>(nameSnapshot),
      'iconKeySnapshot': serializer.toJson<String>(iconKeySnapshot),
      'colorKeySnapshot': serializer.toJson<String>(colorKeySnapshot),
      'customColorArgbSnapshot': serializer.toJson<int?>(
        customColorArgbSnapshot,
      ),
      'scheduledStartMinuteSnapshot': serializer.toJson<int>(
        scheduledStartMinuteSnapshot,
      ),
      'startedAt': serializer.toJson<DateTime?>(startedAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'skippedAt': serializer.toJson<DateTime?>(skippedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  RoutineRunRecord copyWith({
    String? id,
    Value<String?> routineId = const Value.absent(),
    String? sourceRoutineId,
    String? localDate,
    String? status,
    String? nameSnapshot,
    String? iconKeySnapshot,
    String? colorKeySnapshot,
    Value<int?> customColorArgbSnapshot = const Value.absent(),
    int? scheduledStartMinuteSnapshot,
    Value<DateTime?> startedAt = const Value.absent(),
    Value<DateTime?> completedAt = const Value.absent(),
    Value<DateTime?> skippedAt = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => RoutineRunRecord(
    id: id ?? this.id,
    routineId: routineId.present ? routineId.value : this.routineId,
    sourceRoutineId: sourceRoutineId ?? this.sourceRoutineId,
    localDate: localDate ?? this.localDate,
    status: status ?? this.status,
    nameSnapshot: nameSnapshot ?? this.nameSnapshot,
    iconKeySnapshot: iconKeySnapshot ?? this.iconKeySnapshot,
    colorKeySnapshot: colorKeySnapshot ?? this.colorKeySnapshot,
    customColorArgbSnapshot: customColorArgbSnapshot.present
        ? customColorArgbSnapshot.value
        : this.customColorArgbSnapshot,
    scheduledStartMinuteSnapshot:
        scheduledStartMinuteSnapshot ?? this.scheduledStartMinuteSnapshot,
    startedAt: startedAt.present ? startedAt.value : this.startedAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    skippedAt: skippedAt.present ? skippedAt.value : this.skippedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  RoutineRunRecord copyWithCompanion(RoutineRunRecordsCompanion data) {
    return RoutineRunRecord(
      id: data.id.present ? data.id.value : this.id,
      routineId: data.routineId.present ? data.routineId.value : this.routineId,
      sourceRoutineId: data.sourceRoutineId.present
          ? data.sourceRoutineId.value
          : this.sourceRoutineId,
      localDate: data.localDate.present ? data.localDate.value : this.localDate,
      status: data.status.present ? data.status.value : this.status,
      nameSnapshot: data.nameSnapshot.present
          ? data.nameSnapshot.value
          : this.nameSnapshot,
      iconKeySnapshot: data.iconKeySnapshot.present
          ? data.iconKeySnapshot.value
          : this.iconKeySnapshot,
      colorKeySnapshot: data.colorKeySnapshot.present
          ? data.colorKeySnapshot.value
          : this.colorKeySnapshot,
      customColorArgbSnapshot: data.customColorArgbSnapshot.present
          ? data.customColorArgbSnapshot.value
          : this.customColorArgbSnapshot,
      scheduledStartMinuteSnapshot: data.scheduledStartMinuteSnapshot.present
          ? data.scheduledStartMinuteSnapshot.value
          : this.scheduledStartMinuteSnapshot,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      skippedAt: data.skippedAt.present ? data.skippedAt.value : this.skippedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RoutineRunRecord(')
          ..write('id: $id, ')
          ..write('routineId: $routineId, ')
          ..write('sourceRoutineId: $sourceRoutineId, ')
          ..write('localDate: $localDate, ')
          ..write('status: $status, ')
          ..write('nameSnapshot: $nameSnapshot, ')
          ..write('iconKeySnapshot: $iconKeySnapshot, ')
          ..write('colorKeySnapshot: $colorKeySnapshot, ')
          ..write('customColorArgbSnapshot: $customColorArgbSnapshot, ')
          ..write(
            'scheduledStartMinuteSnapshot: $scheduledStartMinuteSnapshot, ',
          )
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('skippedAt: $skippedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    routineId,
    sourceRoutineId,
    localDate,
    status,
    nameSnapshot,
    iconKeySnapshot,
    colorKeySnapshot,
    customColorArgbSnapshot,
    scheduledStartMinuteSnapshot,
    startedAt,
    completedAt,
    skippedAt,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RoutineRunRecord &&
          other.id == this.id &&
          other.routineId == this.routineId &&
          other.sourceRoutineId == this.sourceRoutineId &&
          other.localDate == this.localDate &&
          other.status == this.status &&
          other.nameSnapshot == this.nameSnapshot &&
          other.iconKeySnapshot == this.iconKeySnapshot &&
          other.colorKeySnapshot == this.colorKeySnapshot &&
          other.customColorArgbSnapshot == this.customColorArgbSnapshot &&
          other.scheduledStartMinuteSnapshot ==
              this.scheduledStartMinuteSnapshot &&
          other.startedAt == this.startedAt &&
          other.completedAt == this.completedAt &&
          other.skippedAt == this.skippedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RoutineRunRecordsCompanion extends UpdateCompanion<RoutineRunRecord> {
  final Value<String> id;
  final Value<String?> routineId;
  final Value<String> sourceRoutineId;
  final Value<String> localDate;
  final Value<String> status;
  final Value<String> nameSnapshot;
  final Value<String> iconKeySnapshot;
  final Value<String> colorKeySnapshot;
  final Value<int?> customColorArgbSnapshot;
  final Value<int> scheduledStartMinuteSnapshot;
  final Value<DateTime?> startedAt;
  final Value<DateTime?> completedAt;
  final Value<DateTime?> skippedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const RoutineRunRecordsCompanion({
    this.id = const Value.absent(),
    this.routineId = const Value.absent(),
    this.sourceRoutineId = const Value.absent(),
    this.localDate = const Value.absent(),
    this.status = const Value.absent(),
    this.nameSnapshot = const Value.absent(),
    this.iconKeySnapshot = const Value.absent(),
    this.colorKeySnapshot = const Value.absent(),
    this.customColorArgbSnapshot = const Value.absent(),
    this.scheduledStartMinuteSnapshot = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.skippedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RoutineRunRecordsCompanion.insert({
    required String id,
    this.routineId = const Value.absent(),
    required String sourceRoutineId,
    required String localDate,
    this.status = const Value.absent(),
    required String nameSnapshot,
    required String iconKeySnapshot,
    required String colorKeySnapshot,
    this.customColorArgbSnapshot = const Value.absent(),
    required int scheduledStartMinuteSnapshot,
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.skippedAt = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sourceRoutineId = Value(sourceRoutineId),
       localDate = Value(localDate),
       nameSnapshot = Value(nameSnapshot),
       iconKeySnapshot = Value(iconKeySnapshot),
       colorKeySnapshot = Value(colorKeySnapshot),
       scheduledStartMinuteSnapshot = Value(scheduledStartMinuteSnapshot),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<RoutineRunRecord> custom({
    Expression<String>? id,
    Expression<String>? routineId,
    Expression<String>? sourceRoutineId,
    Expression<String>? localDate,
    Expression<String>? status,
    Expression<String>? nameSnapshot,
    Expression<String>? iconKeySnapshot,
    Expression<String>? colorKeySnapshot,
    Expression<int>? customColorArgbSnapshot,
    Expression<int>? scheduledStartMinuteSnapshot,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? completedAt,
    Expression<DateTime>? skippedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (routineId != null) 'routine_id': routineId,
      if (sourceRoutineId != null) 'source_routine_id': sourceRoutineId,
      if (localDate != null) 'local_date': localDate,
      if (status != null) 'status': status,
      if (nameSnapshot != null) 'name_snapshot': nameSnapshot,
      if (iconKeySnapshot != null) 'icon_key_snapshot': iconKeySnapshot,
      if (colorKeySnapshot != null) 'color_key_snapshot': colorKeySnapshot,
      if (customColorArgbSnapshot != null)
        'custom_color_argb_snapshot': customColorArgbSnapshot,
      if (scheduledStartMinuteSnapshot != null)
        'scheduled_start_minute_snapshot': scheduledStartMinuteSnapshot,
      if (startedAt != null) 'started_at': startedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (skippedAt != null) 'skipped_at': skippedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RoutineRunRecordsCompanion copyWith({
    Value<String>? id,
    Value<String?>? routineId,
    Value<String>? sourceRoutineId,
    Value<String>? localDate,
    Value<String>? status,
    Value<String>? nameSnapshot,
    Value<String>? iconKeySnapshot,
    Value<String>? colorKeySnapshot,
    Value<int?>? customColorArgbSnapshot,
    Value<int>? scheduledStartMinuteSnapshot,
    Value<DateTime?>? startedAt,
    Value<DateTime?>? completedAt,
    Value<DateTime?>? skippedAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return RoutineRunRecordsCompanion(
      id: id ?? this.id,
      routineId: routineId ?? this.routineId,
      sourceRoutineId: sourceRoutineId ?? this.sourceRoutineId,
      localDate: localDate ?? this.localDate,
      status: status ?? this.status,
      nameSnapshot: nameSnapshot ?? this.nameSnapshot,
      iconKeySnapshot: iconKeySnapshot ?? this.iconKeySnapshot,
      colorKeySnapshot: colorKeySnapshot ?? this.colorKeySnapshot,
      customColorArgbSnapshot:
          customColorArgbSnapshot ?? this.customColorArgbSnapshot,
      scheduledStartMinuteSnapshot:
          scheduledStartMinuteSnapshot ?? this.scheduledStartMinuteSnapshot,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      skippedAt: skippedAt ?? this.skippedAt,
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
    if (routineId.present) {
      map['routine_id'] = Variable<String>(routineId.value);
    }
    if (sourceRoutineId.present) {
      map['source_routine_id'] = Variable<String>(sourceRoutineId.value);
    }
    if (localDate.present) {
      map['local_date'] = Variable<String>(localDate.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (nameSnapshot.present) {
      map['name_snapshot'] = Variable<String>(nameSnapshot.value);
    }
    if (iconKeySnapshot.present) {
      map['icon_key_snapshot'] = Variable<String>(iconKeySnapshot.value);
    }
    if (colorKeySnapshot.present) {
      map['color_key_snapshot'] = Variable<String>(colorKeySnapshot.value);
    }
    if (customColorArgbSnapshot.present) {
      map['custom_color_argb_snapshot'] = Variable<int>(
        customColorArgbSnapshot.value,
      );
    }
    if (scheduledStartMinuteSnapshot.present) {
      map['scheduled_start_minute_snapshot'] = Variable<int>(
        scheduledStartMinuteSnapshot.value,
      );
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (skippedAt.present) {
      map['skipped_at'] = Variable<DateTime>(skippedAt.value);
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
    return (StringBuffer('RoutineRunRecordsCompanion(')
          ..write('id: $id, ')
          ..write('routineId: $routineId, ')
          ..write('sourceRoutineId: $sourceRoutineId, ')
          ..write('localDate: $localDate, ')
          ..write('status: $status, ')
          ..write('nameSnapshot: $nameSnapshot, ')
          ..write('iconKeySnapshot: $iconKeySnapshot, ')
          ..write('colorKeySnapshot: $colorKeySnapshot, ')
          ..write('customColorArgbSnapshot: $customColorArgbSnapshot, ')
          ..write(
            'scheduledStartMinuteSnapshot: $scheduledStartMinuteSnapshot, ',
          )
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('skippedAt: $skippedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RoutineItemRunRecordsTable extends RoutineItemRunRecords
    with TableInfo<$RoutineItemRunRecordsTable, RoutineItemRunRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoutineItemRunRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _routineRunIdMeta = const VerificationMeta(
    'routineRunId',
  );
  @override
  late final GeneratedColumn<String> routineRunId = GeneratedColumn<String>(
    'routine_run_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES routine_runs (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _routineItemIdMeta = const VerificationMeta(
    'routineItemId',
  );
  @override
  late final GeneratedColumn<String> routineItemId = GeneratedColumn<String>(
    'routine_item_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES routine_items (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _sourceItemIdMeta = const VerificationMeta(
    'sourceItemId',
  );
  @override
  late final GeneratedColumn<String> sourceItemId = GeneratedColumn<String>(
    'source_item_id',
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
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _positionSnapshotMeta = const VerificationMeta(
    'positionSnapshot',
  );
  @override
  late final GeneratedColumn<int> positionSnapshot = GeneratedColumn<int>(
    'position_snapshot',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleSnapshotMeta = const VerificationMeta(
    'titleSnapshot',
  );
  @override
  late final GeneratedColumn<String> titleSnapshot = GeneratedColumn<String>(
    'title_snapshot',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scheduledAtSnapshotMeta =
      const VerificationMeta('scheduledAtSnapshot');
  @override
  late final GeneratedColumn<DateTime> scheduledAtSnapshot =
      GeneratedColumn<DateTime>(
        'scheduled_at_snapshot',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _durationMinutesSnapshotMeta =
      const VerificationMeta('durationMinutesSnapshot');
  @override
  late final GeneratedColumn<int> durationMinutesSnapshot =
      GeneratedColumn<int>(
        'duration_minutes_snapshot',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _goalTitleSnapshotMeta = const VerificationMeta(
    'goalTitleSnapshot',
  );
  @override
  late final GeneratedColumn<String> goalTitleSnapshot =
      GeneratedColumn<String>(
        'goal_title_snapshot',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _isOptionalSnapshotMeta =
      const VerificationMeta('isOptionalSnapshot');
  @override
  late final GeneratedColumn<bool> isOptionalSnapshot = GeneratedColumn<bool>(
    'is_optional_snapshot',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_optional_snapshot" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _reminderMinutesSnapshotMeta =
      const VerificationMeta('reminderMinutesSnapshot');
  @override
  late final GeneratedColumn<int> reminderMinutesSnapshot =
      GeneratedColumn<int>(
        'reminder_minutes_snapshot',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _pomodoroModeSnapshotMeta =
      const VerificationMeta('pomodoroModeSnapshot');
  @override
  late final GeneratedColumn<String> pomodoroModeSnapshot =
      GeneratedColumn<String>(
        'pomodoro_mode_snapshot',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _customFocusMinutesSnapshotMeta =
      const VerificationMeta('customFocusMinutesSnapshot');
  @override
  late final GeneratedColumn<int> customFocusMinutesSnapshot =
      GeneratedColumn<int>(
        'custom_focus_minutes_snapshot',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _customBreakMinutesSnapshotMeta =
      const VerificationMeta('customBreakMinutesSnapshot');
  @override
  late final GeneratedColumn<int> customBreakMinutesSnapshot =
      GeneratedColumn<int>(
        'custom_break_minutes_snapshot',
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
    requiredDuringInsert: false,
    defaultValue: const Constant('scheduled'),
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _skippedAtMeta = const VerificationMeta(
    'skippedAt',
  );
  @override
  late final GeneratedColumn<DateTime> skippedAt = GeneratedColumn<DateTime>(
    'skipped_at',
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
    routineRunId,
    routineItemId,
    sourceItemId,
    taskId,
    taskIdSnapshot,
    positionSnapshot,
    titleSnapshot,
    scheduledAtSnapshot,
    durationMinutesSnapshot,
    goalTitleSnapshot,
    isOptionalSnapshot,
    reminderMinutesSnapshot,
    pomodoroModeSnapshot,
    customFocusMinutesSnapshot,
    customBreakMinutesSnapshot,
    status,
    startedAt,
    completedAt,
    skippedAt,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'routine_item_runs';
  @override
  VerificationContext validateIntegrity(
    Insertable<RoutineItemRunRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('routine_run_id')) {
      context.handle(
        _routineRunIdMeta,
        routineRunId.isAcceptableOrUnknown(
          data['routine_run_id']!,
          _routineRunIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_routineRunIdMeta);
    }
    if (data.containsKey('routine_item_id')) {
      context.handle(
        _routineItemIdMeta,
        routineItemId.isAcceptableOrUnknown(
          data['routine_item_id']!,
          _routineItemIdMeta,
        ),
      );
    }
    if (data.containsKey('source_item_id')) {
      context.handle(
        _sourceItemIdMeta,
        sourceItemId.isAcceptableOrUnknown(
          data['source_item_id']!,
          _sourceItemIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceItemIdMeta);
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
    }
    if (data.containsKey('position_snapshot')) {
      context.handle(
        _positionSnapshotMeta,
        positionSnapshot.isAcceptableOrUnknown(
          data['position_snapshot']!,
          _positionSnapshotMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_positionSnapshotMeta);
    }
    if (data.containsKey('title_snapshot')) {
      context.handle(
        _titleSnapshotMeta,
        titleSnapshot.isAcceptableOrUnknown(
          data['title_snapshot']!,
          _titleSnapshotMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_titleSnapshotMeta);
    }
    if (data.containsKey('scheduled_at_snapshot')) {
      context.handle(
        _scheduledAtSnapshotMeta,
        scheduledAtSnapshot.isAcceptableOrUnknown(
          data['scheduled_at_snapshot']!,
          _scheduledAtSnapshotMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scheduledAtSnapshotMeta);
    }
    if (data.containsKey('duration_minutes_snapshot')) {
      context.handle(
        _durationMinutesSnapshotMeta,
        durationMinutesSnapshot.isAcceptableOrUnknown(
          data['duration_minutes_snapshot']!,
          _durationMinutesSnapshotMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_durationMinutesSnapshotMeta);
    }
    if (data.containsKey('goal_title_snapshot')) {
      context.handle(
        _goalTitleSnapshotMeta,
        goalTitleSnapshot.isAcceptableOrUnknown(
          data['goal_title_snapshot']!,
          _goalTitleSnapshotMeta,
        ),
      );
    }
    if (data.containsKey('is_optional_snapshot')) {
      context.handle(
        _isOptionalSnapshotMeta,
        isOptionalSnapshot.isAcceptableOrUnknown(
          data['is_optional_snapshot']!,
          _isOptionalSnapshotMeta,
        ),
      );
    }
    if (data.containsKey('reminder_minutes_snapshot')) {
      context.handle(
        _reminderMinutesSnapshotMeta,
        reminderMinutesSnapshot.isAcceptableOrUnknown(
          data['reminder_minutes_snapshot']!,
          _reminderMinutesSnapshotMeta,
        ),
      );
    }
    if (data.containsKey('pomodoro_mode_snapshot')) {
      context.handle(
        _pomodoroModeSnapshotMeta,
        pomodoroModeSnapshot.isAcceptableOrUnknown(
          data['pomodoro_mode_snapshot']!,
          _pomodoroModeSnapshotMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_pomodoroModeSnapshotMeta);
    }
    if (data.containsKey('custom_focus_minutes_snapshot')) {
      context.handle(
        _customFocusMinutesSnapshotMeta,
        customFocusMinutesSnapshot.isAcceptableOrUnknown(
          data['custom_focus_minutes_snapshot']!,
          _customFocusMinutesSnapshotMeta,
        ),
      );
    }
    if (data.containsKey('custom_break_minutes_snapshot')) {
      context.handle(
        _customBreakMinutesSnapshotMeta,
        customBreakMinutesSnapshot.isAcceptableOrUnknown(
          data['custom_break_minutes_snapshot']!,
          _customBreakMinutesSnapshotMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('skipped_at')) {
      context.handle(
        _skippedAtMeta,
        skippedAt.isAcceptableOrUnknown(data['skipped_at']!, _skippedAtMeta),
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
  RoutineItemRunRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RoutineItemRunRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      routineRunId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}routine_run_id'],
      )!,
      routineItemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}routine_item_id'],
      ),
      sourceItemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_item_id'],
      )!,
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_id'],
      ),
      taskIdSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_id_snapshot'],
      ),
      positionSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position_snapshot'],
      )!,
      titleSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title_snapshot'],
      )!,
      scheduledAtSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}scheduled_at_snapshot'],
      )!,
      durationMinutesSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_minutes_snapshot'],
      )!,
      goalTitleSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}goal_title_snapshot'],
      ),
      isOptionalSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_optional_snapshot'],
      )!,
      reminderMinutesSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reminder_minutes_snapshot'],
      ),
      pomodoroModeSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pomodoro_mode_snapshot'],
      )!,
      customFocusMinutesSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}custom_focus_minutes_snapshot'],
      ),
      customBreakMinutesSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}custom_break_minutes_snapshot'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      ),
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      skippedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}skipped_at'],
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
  $RoutineItemRunRecordsTable createAlias(String alias) {
    return $RoutineItemRunRecordsTable(attachedDatabase, alias);
  }
}

class RoutineItemRunRecord extends DataClass
    implements Insertable<RoutineItemRunRecord> {
  final String id;
  final String routineRunId;
  final String? routineItemId;
  final String sourceItemId;
  final String? taskId;
  final String? taskIdSnapshot;
  final int positionSnapshot;
  final String titleSnapshot;
  final DateTime scheduledAtSnapshot;
  final int durationMinutesSnapshot;
  final String? goalTitleSnapshot;
  final bool isOptionalSnapshot;
  final int? reminderMinutesSnapshot;
  final String pomodoroModeSnapshot;
  final int? customFocusMinutesSnapshot;
  final int? customBreakMinutesSnapshot;
  final String status;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final DateTime? skippedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const RoutineItemRunRecord({
    required this.id,
    required this.routineRunId,
    this.routineItemId,
    required this.sourceItemId,
    this.taskId,
    this.taskIdSnapshot,
    required this.positionSnapshot,
    required this.titleSnapshot,
    required this.scheduledAtSnapshot,
    required this.durationMinutesSnapshot,
    this.goalTitleSnapshot,
    required this.isOptionalSnapshot,
    this.reminderMinutesSnapshot,
    required this.pomodoroModeSnapshot,
    this.customFocusMinutesSnapshot,
    this.customBreakMinutesSnapshot,
    required this.status,
    this.startedAt,
    this.completedAt,
    this.skippedAt,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['routine_run_id'] = Variable<String>(routineRunId);
    if (!nullToAbsent || routineItemId != null) {
      map['routine_item_id'] = Variable<String>(routineItemId);
    }
    map['source_item_id'] = Variable<String>(sourceItemId);
    if (!nullToAbsent || taskId != null) {
      map['task_id'] = Variable<String>(taskId);
    }
    if (!nullToAbsent || taskIdSnapshot != null) {
      map['task_id_snapshot'] = Variable<String>(taskIdSnapshot);
    }
    map['position_snapshot'] = Variable<int>(positionSnapshot);
    map['title_snapshot'] = Variable<String>(titleSnapshot);
    map['scheduled_at_snapshot'] = Variable<DateTime>(scheduledAtSnapshot);
    map['duration_minutes_snapshot'] = Variable<int>(durationMinutesSnapshot);
    if (!nullToAbsent || goalTitleSnapshot != null) {
      map['goal_title_snapshot'] = Variable<String>(goalTitleSnapshot);
    }
    map['is_optional_snapshot'] = Variable<bool>(isOptionalSnapshot);
    if (!nullToAbsent || reminderMinutesSnapshot != null) {
      map['reminder_minutes_snapshot'] = Variable<int>(reminderMinutesSnapshot);
    }
    map['pomodoro_mode_snapshot'] = Variable<String>(pomodoroModeSnapshot);
    if (!nullToAbsent || customFocusMinutesSnapshot != null) {
      map['custom_focus_minutes_snapshot'] = Variable<int>(
        customFocusMinutesSnapshot,
      );
    }
    if (!nullToAbsent || customBreakMinutesSnapshot != null) {
      map['custom_break_minutes_snapshot'] = Variable<int>(
        customBreakMinutesSnapshot,
      );
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || startedAt != null) {
      map['started_at'] = Variable<DateTime>(startedAt);
    }
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    if (!nullToAbsent || skippedAt != null) {
      map['skipped_at'] = Variable<DateTime>(skippedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  RoutineItemRunRecordsCompanion toCompanion(bool nullToAbsent) {
    return RoutineItemRunRecordsCompanion(
      id: Value(id),
      routineRunId: Value(routineRunId),
      routineItemId: routineItemId == null && nullToAbsent
          ? const Value.absent()
          : Value(routineItemId),
      sourceItemId: Value(sourceItemId),
      taskId: taskId == null && nullToAbsent
          ? const Value.absent()
          : Value(taskId),
      taskIdSnapshot: taskIdSnapshot == null && nullToAbsent
          ? const Value.absent()
          : Value(taskIdSnapshot),
      positionSnapshot: Value(positionSnapshot),
      titleSnapshot: Value(titleSnapshot),
      scheduledAtSnapshot: Value(scheduledAtSnapshot),
      durationMinutesSnapshot: Value(durationMinutesSnapshot),
      goalTitleSnapshot: goalTitleSnapshot == null && nullToAbsent
          ? const Value.absent()
          : Value(goalTitleSnapshot),
      isOptionalSnapshot: Value(isOptionalSnapshot),
      reminderMinutesSnapshot: reminderMinutesSnapshot == null && nullToAbsent
          ? const Value.absent()
          : Value(reminderMinutesSnapshot),
      pomodoroModeSnapshot: Value(pomodoroModeSnapshot),
      customFocusMinutesSnapshot:
          customFocusMinutesSnapshot == null && nullToAbsent
          ? const Value.absent()
          : Value(customFocusMinutesSnapshot),
      customBreakMinutesSnapshot:
          customBreakMinutesSnapshot == null && nullToAbsent
          ? const Value.absent()
          : Value(customBreakMinutesSnapshot),
      status: Value(status),
      startedAt: startedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(startedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      skippedAt: skippedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(skippedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory RoutineItemRunRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RoutineItemRunRecord(
      id: serializer.fromJson<String>(json['id']),
      routineRunId: serializer.fromJson<String>(json['routineRunId']),
      routineItemId: serializer.fromJson<String?>(json['routineItemId']),
      sourceItemId: serializer.fromJson<String>(json['sourceItemId']),
      taskId: serializer.fromJson<String?>(json['taskId']),
      taskIdSnapshot: serializer.fromJson<String?>(json['taskIdSnapshot']),
      positionSnapshot: serializer.fromJson<int>(json['positionSnapshot']),
      titleSnapshot: serializer.fromJson<String>(json['titleSnapshot']),
      scheduledAtSnapshot: serializer.fromJson<DateTime>(
        json['scheduledAtSnapshot'],
      ),
      durationMinutesSnapshot: serializer.fromJson<int>(
        json['durationMinutesSnapshot'],
      ),
      goalTitleSnapshot: serializer.fromJson<String?>(
        json['goalTitleSnapshot'],
      ),
      isOptionalSnapshot: serializer.fromJson<bool>(json['isOptionalSnapshot']),
      reminderMinutesSnapshot: serializer.fromJson<int?>(
        json['reminderMinutesSnapshot'],
      ),
      pomodoroModeSnapshot: serializer.fromJson<String>(
        json['pomodoroModeSnapshot'],
      ),
      customFocusMinutesSnapshot: serializer.fromJson<int?>(
        json['customFocusMinutesSnapshot'],
      ),
      customBreakMinutesSnapshot: serializer.fromJson<int?>(
        json['customBreakMinutesSnapshot'],
      ),
      status: serializer.fromJson<String>(json['status']),
      startedAt: serializer.fromJson<DateTime?>(json['startedAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      skippedAt: serializer.fromJson<DateTime?>(json['skippedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'routineRunId': serializer.toJson<String>(routineRunId),
      'routineItemId': serializer.toJson<String?>(routineItemId),
      'sourceItemId': serializer.toJson<String>(sourceItemId),
      'taskId': serializer.toJson<String?>(taskId),
      'taskIdSnapshot': serializer.toJson<String?>(taskIdSnapshot),
      'positionSnapshot': serializer.toJson<int>(positionSnapshot),
      'titleSnapshot': serializer.toJson<String>(titleSnapshot),
      'scheduledAtSnapshot': serializer.toJson<DateTime>(scheduledAtSnapshot),
      'durationMinutesSnapshot': serializer.toJson<int>(
        durationMinutesSnapshot,
      ),
      'goalTitleSnapshot': serializer.toJson<String?>(goalTitleSnapshot),
      'isOptionalSnapshot': serializer.toJson<bool>(isOptionalSnapshot),
      'reminderMinutesSnapshot': serializer.toJson<int?>(
        reminderMinutesSnapshot,
      ),
      'pomodoroModeSnapshot': serializer.toJson<String>(pomodoroModeSnapshot),
      'customFocusMinutesSnapshot': serializer.toJson<int?>(
        customFocusMinutesSnapshot,
      ),
      'customBreakMinutesSnapshot': serializer.toJson<int?>(
        customBreakMinutesSnapshot,
      ),
      'status': serializer.toJson<String>(status),
      'startedAt': serializer.toJson<DateTime?>(startedAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'skippedAt': serializer.toJson<DateTime?>(skippedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  RoutineItemRunRecord copyWith({
    String? id,
    String? routineRunId,
    Value<String?> routineItemId = const Value.absent(),
    String? sourceItemId,
    Value<String?> taskId = const Value.absent(),
    Value<String?> taskIdSnapshot = const Value.absent(),
    int? positionSnapshot,
    String? titleSnapshot,
    DateTime? scheduledAtSnapshot,
    int? durationMinutesSnapshot,
    Value<String?> goalTitleSnapshot = const Value.absent(),
    bool? isOptionalSnapshot,
    Value<int?> reminderMinutesSnapshot = const Value.absent(),
    String? pomodoroModeSnapshot,
    Value<int?> customFocusMinutesSnapshot = const Value.absent(),
    Value<int?> customBreakMinutesSnapshot = const Value.absent(),
    String? status,
    Value<DateTime?> startedAt = const Value.absent(),
    Value<DateTime?> completedAt = const Value.absent(),
    Value<DateTime?> skippedAt = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => RoutineItemRunRecord(
    id: id ?? this.id,
    routineRunId: routineRunId ?? this.routineRunId,
    routineItemId: routineItemId.present
        ? routineItemId.value
        : this.routineItemId,
    sourceItemId: sourceItemId ?? this.sourceItemId,
    taskId: taskId.present ? taskId.value : this.taskId,
    taskIdSnapshot: taskIdSnapshot.present
        ? taskIdSnapshot.value
        : this.taskIdSnapshot,
    positionSnapshot: positionSnapshot ?? this.positionSnapshot,
    titleSnapshot: titleSnapshot ?? this.titleSnapshot,
    scheduledAtSnapshot: scheduledAtSnapshot ?? this.scheduledAtSnapshot,
    durationMinutesSnapshot:
        durationMinutesSnapshot ?? this.durationMinutesSnapshot,
    goalTitleSnapshot: goalTitleSnapshot.present
        ? goalTitleSnapshot.value
        : this.goalTitleSnapshot,
    isOptionalSnapshot: isOptionalSnapshot ?? this.isOptionalSnapshot,
    reminderMinutesSnapshot: reminderMinutesSnapshot.present
        ? reminderMinutesSnapshot.value
        : this.reminderMinutesSnapshot,
    pomodoroModeSnapshot: pomodoroModeSnapshot ?? this.pomodoroModeSnapshot,
    customFocusMinutesSnapshot: customFocusMinutesSnapshot.present
        ? customFocusMinutesSnapshot.value
        : this.customFocusMinutesSnapshot,
    customBreakMinutesSnapshot: customBreakMinutesSnapshot.present
        ? customBreakMinutesSnapshot.value
        : this.customBreakMinutesSnapshot,
    status: status ?? this.status,
    startedAt: startedAt.present ? startedAt.value : this.startedAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    skippedAt: skippedAt.present ? skippedAt.value : this.skippedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  RoutineItemRunRecord copyWithCompanion(RoutineItemRunRecordsCompanion data) {
    return RoutineItemRunRecord(
      id: data.id.present ? data.id.value : this.id,
      routineRunId: data.routineRunId.present
          ? data.routineRunId.value
          : this.routineRunId,
      routineItemId: data.routineItemId.present
          ? data.routineItemId.value
          : this.routineItemId,
      sourceItemId: data.sourceItemId.present
          ? data.sourceItemId.value
          : this.sourceItemId,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      taskIdSnapshot: data.taskIdSnapshot.present
          ? data.taskIdSnapshot.value
          : this.taskIdSnapshot,
      positionSnapshot: data.positionSnapshot.present
          ? data.positionSnapshot.value
          : this.positionSnapshot,
      titleSnapshot: data.titleSnapshot.present
          ? data.titleSnapshot.value
          : this.titleSnapshot,
      scheduledAtSnapshot: data.scheduledAtSnapshot.present
          ? data.scheduledAtSnapshot.value
          : this.scheduledAtSnapshot,
      durationMinutesSnapshot: data.durationMinutesSnapshot.present
          ? data.durationMinutesSnapshot.value
          : this.durationMinutesSnapshot,
      goalTitleSnapshot: data.goalTitleSnapshot.present
          ? data.goalTitleSnapshot.value
          : this.goalTitleSnapshot,
      isOptionalSnapshot: data.isOptionalSnapshot.present
          ? data.isOptionalSnapshot.value
          : this.isOptionalSnapshot,
      reminderMinutesSnapshot: data.reminderMinutesSnapshot.present
          ? data.reminderMinutesSnapshot.value
          : this.reminderMinutesSnapshot,
      pomodoroModeSnapshot: data.pomodoroModeSnapshot.present
          ? data.pomodoroModeSnapshot.value
          : this.pomodoroModeSnapshot,
      customFocusMinutesSnapshot: data.customFocusMinutesSnapshot.present
          ? data.customFocusMinutesSnapshot.value
          : this.customFocusMinutesSnapshot,
      customBreakMinutesSnapshot: data.customBreakMinutesSnapshot.present
          ? data.customBreakMinutesSnapshot.value
          : this.customBreakMinutesSnapshot,
      status: data.status.present ? data.status.value : this.status,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      skippedAt: data.skippedAt.present ? data.skippedAt.value : this.skippedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RoutineItemRunRecord(')
          ..write('id: $id, ')
          ..write('routineRunId: $routineRunId, ')
          ..write('routineItemId: $routineItemId, ')
          ..write('sourceItemId: $sourceItemId, ')
          ..write('taskId: $taskId, ')
          ..write('taskIdSnapshot: $taskIdSnapshot, ')
          ..write('positionSnapshot: $positionSnapshot, ')
          ..write('titleSnapshot: $titleSnapshot, ')
          ..write('scheduledAtSnapshot: $scheduledAtSnapshot, ')
          ..write('durationMinutesSnapshot: $durationMinutesSnapshot, ')
          ..write('goalTitleSnapshot: $goalTitleSnapshot, ')
          ..write('isOptionalSnapshot: $isOptionalSnapshot, ')
          ..write('reminderMinutesSnapshot: $reminderMinutesSnapshot, ')
          ..write('pomodoroModeSnapshot: $pomodoroModeSnapshot, ')
          ..write('customFocusMinutesSnapshot: $customFocusMinutesSnapshot, ')
          ..write('customBreakMinutesSnapshot: $customBreakMinutesSnapshot, ')
          ..write('status: $status, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('skippedAt: $skippedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    routineRunId,
    routineItemId,
    sourceItemId,
    taskId,
    taskIdSnapshot,
    positionSnapshot,
    titleSnapshot,
    scheduledAtSnapshot,
    durationMinutesSnapshot,
    goalTitleSnapshot,
    isOptionalSnapshot,
    reminderMinutesSnapshot,
    pomodoroModeSnapshot,
    customFocusMinutesSnapshot,
    customBreakMinutesSnapshot,
    status,
    startedAt,
    completedAt,
    skippedAt,
    createdAt,
    updatedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RoutineItemRunRecord &&
          other.id == this.id &&
          other.routineRunId == this.routineRunId &&
          other.routineItemId == this.routineItemId &&
          other.sourceItemId == this.sourceItemId &&
          other.taskId == this.taskId &&
          other.taskIdSnapshot == this.taskIdSnapshot &&
          other.positionSnapshot == this.positionSnapshot &&
          other.titleSnapshot == this.titleSnapshot &&
          other.scheduledAtSnapshot == this.scheduledAtSnapshot &&
          other.durationMinutesSnapshot == this.durationMinutesSnapshot &&
          other.goalTitleSnapshot == this.goalTitleSnapshot &&
          other.isOptionalSnapshot == this.isOptionalSnapshot &&
          other.reminderMinutesSnapshot == this.reminderMinutesSnapshot &&
          other.pomodoroModeSnapshot == this.pomodoroModeSnapshot &&
          other.customFocusMinutesSnapshot == this.customFocusMinutesSnapshot &&
          other.customBreakMinutesSnapshot == this.customBreakMinutesSnapshot &&
          other.status == this.status &&
          other.startedAt == this.startedAt &&
          other.completedAt == this.completedAt &&
          other.skippedAt == this.skippedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RoutineItemRunRecordsCompanion
    extends UpdateCompanion<RoutineItemRunRecord> {
  final Value<String> id;
  final Value<String> routineRunId;
  final Value<String?> routineItemId;
  final Value<String> sourceItemId;
  final Value<String?> taskId;
  final Value<String?> taskIdSnapshot;
  final Value<int> positionSnapshot;
  final Value<String> titleSnapshot;
  final Value<DateTime> scheduledAtSnapshot;
  final Value<int> durationMinutesSnapshot;
  final Value<String?> goalTitleSnapshot;
  final Value<bool> isOptionalSnapshot;
  final Value<int?> reminderMinutesSnapshot;
  final Value<String> pomodoroModeSnapshot;
  final Value<int?> customFocusMinutesSnapshot;
  final Value<int?> customBreakMinutesSnapshot;
  final Value<String> status;
  final Value<DateTime?> startedAt;
  final Value<DateTime?> completedAt;
  final Value<DateTime?> skippedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const RoutineItemRunRecordsCompanion({
    this.id = const Value.absent(),
    this.routineRunId = const Value.absent(),
    this.routineItemId = const Value.absent(),
    this.sourceItemId = const Value.absent(),
    this.taskId = const Value.absent(),
    this.taskIdSnapshot = const Value.absent(),
    this.positionSnapshot = const Value.absent(),
    this.titleSnapshot = const Value.absent(),
    this.scheduledAtSnapshot = const Value.absent(),
    this.durationMinutesSnapshot = const Value.absent(),
    this.goalTitleSnapshot = const Value.absent(),
    this.isOptionalSnapshot = const Value.absent(),
    this.reminderMinutesSnapshot = const Value.absent(),
    this.pomodoroModeSnapshot = const Value.absent(),
    this.customFocusMinutesSnapshot = const Value.absent(),
    this.customBreakMinutesSnapshot = const Value.absent(),
    this.status = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.skippedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RoutineItemRunRecordsCompanion.insert({
    required String id,
    required String routineRunId,
    this.routineItemId = const Value.absent(),
    required String sourceItemId,
    this.taskId = const Value.absent(),
    this.taskIdSnapshot = const Value.absent(),
    required int positionSnapshot,
    required String titleSnapshot,
    required DateTime scheduledAtSnapshot,
    required int durationMinutesSnapshot,
    this.goalTitleSnapshot = const Value.absent(),
    this.isOptionalSnapshot = const Value.absent(),
    this.reminderMinutesSnapshot = const Value.absent(),
    required String pomodoroModeSnapshot,
    this.customFocusMinutesSnapshot = const Value.absent(),
    this.customBreakMinutesSnapshot = const Value.absent(),
    this.status = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.skippedAt = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       routineRunId = Value(routineRunId),
       sourceItemId = Value(sourceItemId),
       positionSnapshot = Value(positionSnapshot),
       titleSnapshot = Value(titleSnapshot),
       scheduledAtSnapshot = Value(scheduledAtSnapshot),
       durationMinutesSnapshot = Value(durationMinutesSnapshot),
       pomodoroModeSnapshot = Value(pomodoroModeSnapshot),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<RoutineItemRunRecord> custom({
    Expression<String>? id,
    Expression<String>? routineRunId,
    Expression<String>? routineItemId,
    Expression<String>? sourceItemId,
    Expression<String>? taskId,
    Expression<String>? taskIdSnapshot,
    Expression<int>? positionSnapshot,
    Expression<String>? titleSnapshot,
    Expression<DateTime>? scheduledAtSnapshot,
    Expression<int>? durationMinutesSnapshot,
    Expression<String>? goalTitleSnapshot,
    Expression<bool>? isOptionalSnapshot,
    Expression<int>? reminderMinutesSnapshot,
    Expression<String>? pomodoroModeSnapshot,
    Expression<int>? customFocusMinutesSnapshot,
    Expression<int>? customBreakMinutesSnapshot,
    Expression<String>? status,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? completedAt,
    Expression<DateTime>? skippedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (routineRunId != null) 'routine_run_id': routineRunId,
      if (routineItemId != null) 'routine_item_id': routineItemId,
      if (sourceItemId != null) 'source_item_id': sourceItemId,
      if (taskId != null) 'task_id': taskId,
      if (taskIdSnapshot != null) 'task_id_snapshot': taskIdSnapshot,
      if (positionSnapshot != null) 'position_snapshot': positionSnapshot,
      if (titleSnapshot != null) 'title_snapshot': titleSnapshot,
      if (scheduledAtSnapshot != null)
        'scheduled_at_snapshot': scheduledAtSnapshot,
      if (durationMinutesSnapshot != null)
        'duration_minutes_snapshot': durationMinutesSnapshot,
      if (goalTitleSnapshot != null) 'goal_title_snapshot': goalTitleSnapshot,
      if (isOptionalSnapshot != null)
        'is_optional_snapshot': isOptionalSnapshot,
      if (reminderMinutesSnapshot != null)
        'reminder_minutes_snapshot': reminderMinutesSnapshot,
      if (pomodoroModeSnapshot != null)
        'pomodoro_mode_snapshot': pomodoroModeSnapshot,
      if (customFocusMinutesSnapshot != null)
        'custom_focus_minutes_snapshot': customFocusMinutesSnapshot,
      if (customBreakMinutesSnapshot != null)
        'custom_break_minutes_snapshot': customBreakMinutesSnapshot,
      if (status != null) 'status': status,
      if (startedAt != null) 'started_at': startedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (skippedAt != null) 'skipped_at': skippedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RoutineItemRunRecordsCompanion copyWith({
    Value<String>? id,
    Value<String>? routineRunId,
    Value<String?>? routineItemId,
    Value<String>? sourceItemId,
    Value<String?>? taskId,
    Value<String?>? taskIdSnapshot,
    Value<int>? positionSnapshot,
    Value<String>? titleSnapshot,
    Value<DateTime>? scheduledAtSnapshot,
    Value<int>? durationMinutesSnapshot,
    Value<String?>? goalTitleSnapshot,
    Value<bool>? isOptionalSnapshot,
    Value<int?>? reminderMinutesSnapshot,
    Value<String>? pomodoroModeSnapshot,
    Value<int?>? customFocusMinutesSnapshot,
    Value<int?>? customBreakMinutesSnapshot,
    Value<String>? status,
    Value<DateTime?>? startedAt,
    Value<DateTime?>? completedAt,
    Value<DateTime?>? skippedAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return RoutineItemRunRecordsCompanion(
      id: id ?? this.id,
      routineRunId: routineRunId ?? this.routineRunId,
      routineItemId: routineItemId ?? this.routineItemId,
      sourceItemId: sourceItemId ?? this.sourceItemId,
      taskId: taskId ?? this.taskId,
      taskIdSnapshot: taskIdSnapshot ?? this.taskIdSnapshot,
      positionSnapshot: positionSnapshot ?? this.positionSnapshot,
      titleSnapshot: titleSnapshot ?? this.titleSnapshot,
      scheduledAtSnapshot: scheduledAtSnapshot ?? this.scheduledAtSnapshot,
      durationMinutesSnapshot:
          durationMinutesSnapshot ?? this.durationMinutesSnapshot,
      goalTitleSnapshot: goalTitleSnapshot ?? this.goalTitleSnapshot,
      isOptionalSnapshot: isOptionalSnapshot ?? this.isOptionalSnapshot,
      reminderMinutesSnapshot:
          reminderMinutesSnapshot ?? this.reminderMinutesSnapshot,
      pomodoroModeSnapshot: pomodoroModeSnapshot ?? this.pomodoroModeSnapshot,
      customFocusMinutesSnapshot:
          customFocusMinutesSnapshot ?? this.customFocusMinutesSnapshot,
      customBreakMinutesSnapshot:
          customBreakMinutesSnapshot ?? this.customBreakMinutesSnapshot,
      status: status ?? this.status,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      skippedAt: skippedAt ?? this.skippedAt,
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
    if (routineRunId.present) {
      map['routine_run_id'] = Variable<String>(routineRunId.value);
    }
    if (routineItemId.present) {
      map['routine_item_id'] = Variable<String>(routineItemId.value);
    }
    if (sourceItemId.present) {
      map['source_item_id'] = Variable<String>(sourceItemId.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (taskIdSnapshot.present) {
      map['task_id_snapshot'] = Variable<String>(taskIdSnapshot.value);
    }
    if (positionSnapshot.present) {
      map['position_snapshot'] = Variable<int>(positionSnapshot.value);
    }
    if (titleSnapshot.present) {
      map['title_snapshot'] = Variable<String>(titleSnapshot.value);
    }
    if (scheduledAtSnapshot.present) {
      map['scheduled_at_snapshot'] = Variable<DateTime>(
        scheduledAtSnapshot.value,
      );
    }
    if (durationMinutesSnapshot.present) {
      map['duration_minutes_snapshot'] = Variable<int>(
        durationMinutesSnapshot.value,
      );
    }
    if (goalTitleSnapshot.present) {
      map['goal_title_snapshot'] = Variable<String>(goalTitleSnapshot.value);
    }
    if (isOptionalSnapshot.present) {
      map['is_optional_snapshot'] = Variable<bool>(isOptionalSnapshot.value);
    }
    if (reminderMinutesSnapshot.present) {
      map['reminder_minutes_snapshot'] = Variable<int>(
        reminderMinutesSnapshot.value,
      );
    }
    if (pomodoroModeSnapshot.present) {
      map['pomodoro_mode_snapshot'] = Variable<String>(
        pomodoroModeSnapshot.value,
      );
    }
    if (customFocusMinutesSnapshot.present) {
      map['custom_focus_minutes_snapshot'] = Variable<int>(
        customFocusMinutesSnapshot.value,
      );
    }
    if (customBreakMinutesSnapshot.present) {
      map['custom_break_minutes_snapshot'] = Variable<int>(
        customBreakMinutesSnapshot.value,
      );
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (skippedAt.present) {
      map['skipped_at'] = Variable<DateTime>(skippedAt.value);
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
    return (StringBuffer('RoutineItemRunRecordsCompanion(')
          ..write('id: $id, ')
          ..write('routineRunId: $routineRunId, ')
          ..write('routineItemId: $routineItemId, ')
          ..write('sourceItemId: $sourceItemId, ')
          ..write('taskId: $taskId, ')
          ..write('taskIdSnapshot: $taskIdSnapshot, ')
          ..write('positionSnapshot: $positionSnapshot, ')
          ..write('titleSnapshot: $titleSnapshot, ')
          ..write('scheduledAtSnapshot: $scheduledAtSnapshot, ')
          ..write('durationMinutesSnapshot: $durationMinutesSnapshot, ')
          ..write('goalTitleSnapshot: $goalTitleSnapshot, ')
          ..write('isOptionalSnapshot: $isOptionalSnapshot, ')
          ..write('reminderMinutesSnapshot: $reminderMinutesSnapshot, ')
          ..write('pomodoroModeSnapshot: $pomodoroModeSnapshot, ')
          ..write('customFocusMinutesSnapshot: $customFocusMinutesSnapshot, ')
          ..write('customBreakMinutesSnapshot: $customBreakMinutesSnapshot, ')
          ..write('status: $status, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('skippedAt: $skippedAt, ')
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

class $QuickNoteRecordsTable extends QuickNoteRecords
    with TableInfo<$QuickNoteRecordsTable, QuickNoteRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuickNoteRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _textContentMeta = const VerificationMeta(
    'textContent',
  );
  @override
  late final GeneratedColumn<String> textContent = GeneratedColumn<String>(
    'text_content',
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
  static const VerificationMeta _colorArgbMeta = const VerificationMeta(
    'colorArgb',
  );
  @override
  late final GeneratedColumn<int> colorArgb = GeneratedColumn<int>(
    'color_argb',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localDateMeta = const VerificationMeta(
    'localDate',
  );
  @override
  late final GeneratedColumn<String> localDate = GeneratedColumn<String>(
    'local_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<String> priority = GeneratedColumn<String>(
    'priority',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
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
    textContent,
    isCompleted,
    colorArgb,
    localDate,
    priority,
    position,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quick_notes';
  @override
  VerificationContext validateIntegrity(
    Insertable<QuickNoteRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('text_content')) {
      context.handle(
        _textContentMeta,
        textContent.isAcceptableOrUnknown(
          data['text_content']!,
          _textContentMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_textContentMeta);
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
    if (data.containsKey('color_argb')) {
      context.handle(
        _colorArgbMeta,
        colorArgb.isAcceptableOrUnknown(data['color_argb']!, _colorArgbMeta),
      );
    } else if (isInserting) {
      context.missing(_colorArgbMeta);
    }
    if (data.containsKey('local_date')) {
      context.handle(
        _localDateMeta,
        localDate.isAcceptableOrUnknown(data['local_date']!, _localDateMeta),
      );
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
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
  QuickNoteRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuickNoteRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      textContent: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text_content'],
      )!,
      isCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_completed'],
      )!,
      colorArgb: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color_argb'],
      )!,
      localDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_date'],
      ),
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}priority'],
      ),
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
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
  $QuickNoteRecordsTable createAlias(String alias) {
    return $QuickNoteRecordsTable(attachedDatabase, alias);
  }
}

class QuickNoteRecord extends DataClass implements Insertable<QuickNoteRecord> {
  final String id;
  final String textContent;
  final bool isCompleted;
  final int colorArgb;
  final String? localDate;
  final String? priority;
  final int position;
  final DateTime createdAt;
  final DateTime updatedAt;
  const QuickNoteRecord({
    required this.id,
    required this.textContent,
    required this.isCompleted,
    required this.colorArgb,
    this.localDate,
    this.priority,
    required this.position,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['text_content'] = Variable<String>(textContent);
    map['is_completed'] = Variable<bool>(isCompleted);
    map['color_argb'] = Variable<int>(colorArgb);
    if (!nullToAbsent || localDate != null) {
      map['local_date'] = Variable<String>(localDate);
    }
    if (!nullToAbsent || priority != null) {
      map['priority'] = Variable<String>(priority);
    }
    map['position'] = Variable<int>(position);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  QuickNoteRecordsCompanion toCompanion(bool nullToAbsent) {
    return QuickNoteRecordsCompanion(
      id: Value(id),
      textContent: Value(textContent),
      isCompleted: Value(isCompleted),
      colorArgb: Value(colorArgb),
      localDate: localDate == null && nullToAbsent
          ? const Value.absent()
          : Value(localDate),
      priority: priority == null && nullToAbsent
          ? const Value.absent()
          : Value(priority),
      position: Value(position),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory QuickNoteRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuickNoteRecord(
      id: serializer.fromJson<String>(json['id']),
      textContent: serializer.fromJson<String>(json['textContent']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      colorArgb: serializer.fromJson<int>(json['colorArgb']),
      localDate: serializer.fromJson<String?>(json['localDate']),
      priority: serializer.fromJson<String?>(json['priority']),
      position: serializer.fromJson<int>(json['position']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'textContent': serializer.toJson<String>(textContent),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'colorArgb': serializer.toJson<int>(colorArgb),
      'localDate': serializer.toJson<String?>(localDate),
      'priority': serializer.toJson<String?>(priority),
      'position': serializer.toJson<int>(position),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  QuickNoteRecord copyWith({
    String? id,
    String? textContent,
    bool? isCompleted,
    int? colorArgb,
    Value<String?> localDate = const Value.absent(),
    Value<String?> priority = const Value.absent(),
    int? position,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => QuickNoteRecord(
    id: id ?? this.id,
    textContent: textContent ?? this.textContent,
    isCompleted: isCompleted ?? this.isCompleted,
    colorArgb: colorArgb ?? this.colorArgb,
    localDate: localDate.present ? localDate.value : this.localDate,
    priority: priority.present ? priority.value : this.priority,
    position: position ?? this.position,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  QuickNoteRecord copyWithCompanion(QuickNoteRecordsCompanion data) {
    return QuickNoteRecord(
      id: data.id.present ? data.id.value : this.id,
      textContent: data.textContent.present
          ? data.textContent.value
          : this.textContent,
      isCompleted: data.isCompleted.present
          ? data.isCompleted.value
          : this.isCompleted,
      colorArgb: data.colorArgb.present ? data.colorArgb.value : this.colorArgb,
      localDate: data.localDate.present ? data.localDate.value : this.localDate,
      priority: data.priority.present ? data.priority.value : this.priority,
      position: data.position.present ? data.position.value : this.position,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuickNoteRecord(')
          ..write('id: $id, ')
          ..write('textContent: $textContent, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('colorArgb: $colorArgb, ')
          ..write('localDate: $localDate, ')
          ..write('priority: $priority, ')
          ..write('position: $position, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    textContent,
    isCompleted,
    colorArgb,
    localDate,
    priority,
    position,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuickNoteRecord &&
          other.id == this.id &&
          other.textContent == this.textContent &&
          other.isCompleted == this.isCompleted &&
          other.colorArgb == this.colorArgb &&
          other.localDate == this.localDate &&
          other.priority == this.priority &&
          other.position == this.position &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class QuickNoteRecordsCompanion extends UpdateCompanion<QuickNoteRecord> {
  final Value<String> id;
  final Value<String> textContent;
  final Value<bool> isCompleted;
  final Value<int> colorArgb;
  final Value<String?> localDate;
  final Value<String?> priority;
  final Value<int> position;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const QuickNoteRecordsCompanion({
    this.id = const Value.absent(),
    this.textContent = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.colorArgb = const Value.absent(),
    this.localDate = const Value.absent(),
    this.priority = const Value.absent(),
    this.position = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  QuickNoteRecordsCompanion.insert({
    required String id,
    required String textContent,
    this.isCompleted = const Value.absent(),
    required int colorArgb,
    this.localDate = const Value.absent(),
    this.priority = const Value.absent(),
    required int position,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       textContent = Value(textContent),
       colorArgb = Value(colorArgb),
       position = Value(position),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<QuickNoteRecord> custom({
    Expression<String>? id,
    Expression<String>? textContent,
    Expression<bool>? isCompleted,
    Expression<int>? colorArgb,
    Expression<String>? localDate,
    Expression<String>? priority,
    Expression<int>? position,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (textContent != null) 'text_content': textContent,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (colorArgb != null) 'color_argb': colorArgb,
      if (localDate != null) 'local_date': localDate,
      if (priority != null) 'priority': priority,
      if (position != null) 'position': position,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  QuickNoteRecordsCompanion copyWith({
    Value<String>? id,
    Value<String>? textContent,
    Value<bool>? isCompleted,
    Value<int>? colorArgb,
    Value<String?>? localDate,
    Value<String?>? priority,
    Value<int>? position,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return QuickNoteRecordsCompanion(
      id: id ?? this.id,
      textContent: textContent ?? this.textContent,
      isCompleted: isCompleted ?? this.isCompleted,
      colorArgb: colorArgb ?? this.colorArgb,
      localDate: localDate ?? this.localDate,
      priority: priority ?? this.priority,
      position: position ?? this.position,
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
    if (textContent.present) {
      map['text_content'] = Variable<String>(textContent.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (colorArgb.present) {
      map['color_argb'] = Variable<int>(colorArgb.value);
    }
    if (localDate.present) {
      map['local_date'] = Variable<String>(localDate.value);
    }
    if (priority.present) {
      map['priority'] = Variable<String>(priority.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
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
    return (StringBuffer('QuickNoteRecordsCompanion(')
          ..write('id: $id, ')
          ..write('textContent: $textContent, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('colorArgb: $colorArgb, ')
          ..write('localDate: $localDate, ')
          ..write('priority: $priority, ')
          ..write('position: $position, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncLocalStateRecordsTable extends SyncLocalStateRecords
    with TableInfo<$SyncLocalStateRecordsTable, SyncLocalStateRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncLocalStateRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _groupIdMeta = const VerificationMeta(
    'groupId',
  );
  @override
  late final GeneratedColumn<String> groupId = GeneratedColumn<String>(
    'group_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _installationIdMeta = const VerificationMeta(
    'installationId',
  );
  @override
  late final GeneratedColumn<String> installationId = GeneratedColumn<String>(
    'installation_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _protocolVersionMeta = const VerificationMeta(
    'protocolVersion',
  );
  @override
  late final GeneratedColumn<int> protocolVersion = GeneratedColumn<int>(
    'protocol_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _logicalCounterMeta = const VerificationMeta(
    'logicalCounter',
  );
  @override
  late final GeneratedColumn<int> logicalCounter = GeneratedColumn<int>(
    'logical_counter',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
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
    groupId,
    installationId,
    protocolVersion,
    logicalCounter,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_local_state';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncLocalStateRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('group_id')) {
      context.handle(
        _groupIdMeta,
        groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta),
      );
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('installation_id')) {
      context.handle(
        _installationIdMeta,
        installationId.isAcceptableOrUnknown(
          data['installation_id']!,
          _installationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_installationIdMeta);
    }
    if (data.containsKey('protocol_version')) {
      context.handle(
        _protocolVersionMeta,
        protocolVersion.isAcceptableOrUnknown(
          data['protocol_version']!,
          _protocolVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_protocolVersionMeta);
    }
    if (data.containsKey('logical_counter')) {
      context.handle(
        _logicalCounterMeta,
        logicalCounter.isAcceptableOrUnknown(
          data['logical_counter']!,
          _logicalCounterMeta,
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
  Set<GeneratedColumn> get $primaryKey => {groupId};
  @override
  SyncLocalStateRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncLocalStateRecord(
      groupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_id'],
      )!,
      installationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}installation_id'],
      )!,
      protocolVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}protocol_version'],
      )!,
      logicalCounter: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}logical_counter'],
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
  $SyncLocalStateRecordsTable createAlias(String alias) {
    return $SyncLocalStateRecordsTable(attachedDatabase, alias);
  }
}

class SyncLocalStateRecord extends DataClass
    implements Insertable<SyncLocalStateRecord> {
  final String groupId;
  final String installationId;
  final int protocolVersion;
  final int logicalCounter;
  final DateTime createdAt;
  final DateTime updatedAt;
  const SyncLocalStateRecord({
    required this.groupId,
    required this.installationId,
    required this.protocolVersion,
    required this.logicalCounter,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['group_id'] = Variable<String>(groupId);
    map['installation_id'] = Variable<String>(installationId);
    map['protocol_version'] = Variable<int>(protocolVersion);
    map['logical_counter'] = Variable<int>(logicalCounter);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SyncLocalStateRecordsCompanion toCompanion(bool nullToAbsent) {
    return SyncLocalStateRecordsCompanion(
      groupId: Value(groupId),
      installationId: Value(installationId),
      protocolVersion: Value(protocolVersion),
      logicalCounter: Value(logicalCounter),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory SyncLocalStateRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncLocalStateRecord(
      groupId: serializer.fromJson<String>(json['groupId']),
      installationId: serializer.fromJson<String>(json['installationId']),
      protocolVersion: serializer.fromJson<int>(json['protocolVersion']),
      logicalCounter: serializer.fromJson<int>(json['logicalCounter']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'groupId': serializer.toJson<String>(groupId),
      'installationId': serializer.toJson<String>(installationId),
      'protocolVersion': serializer.toJson<int>(protocolVersion),
      'logicalCounter': serializer.toJson<int>(logicalCounter),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SyncLocalStateRecord copyWith({
    String? groupId,
    String? installationId,
    int? protocolVersion,
    int? logicalCounter,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => SyncLocalStateRecord(
    groupId: groupId ?? this.groupId,
    installationId: installationId ?? this.installationId,
    protocolVersion: protocolVersion ?? this.protocolVersion,
    logicalCounter: logicalCounter ?? this.logicalCounter,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  SyncLocalStateRecord copyWithCompanion(SyncLocalStateRecordsCompanion data) {
    return SyncLocalStateRecord(
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      installationId: data.installationId.present
          ? data.installationId.value
          : this.installationId,
      protocolVersion: data.protocolVersion.present
          ? data.protocolVersion.value
          : this.protocolVersion,
      logicalCounter: data.logicalCounter.present
          ? data.logicalCounter.value
          : this.logicalCounter,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncLocalStateRecord(')
          ..write('groupId: $groupId, ')
          ..write('installationId: $installationId, ')
          ..write('protocolVersion: $protocolVersion, ')
          ..write('logicalCounter: $logicalCounter, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    groupId,
    installationId,
    protocolVersion,
    logicalCounter,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncLocalStateRecord &&
          other.groupId == this.groupId &&
          other.installationId == this.installationId &&
          other.protocolVersion == this.protocolVersion &&
          other.logicalCounter == this.logicalCounter &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SyncLocalStateRecordsCompanion
    extends UpdateCompanion<SyncLocalStateRecord> {
  final Value<String> groupId;
  final Value<String> installationId;
  final Value<int> protocolVersion;
  final Value<int> logicalCounter;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SyncLocalStateRecordsCompanion({
    this.groupId = const Value.absent(),
    this.installationId = const Value.absent(),
    this.protocolVersion = const Value.absent(),
    this.logicalCounter = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncLocalStateRecordsCompanion.insert({
    required String groupId,
    required String installationId,
    required int protocolVersion,
    this.logicalCounter = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : groupId = Value(groupId),
       installationId = Value(installationId),
       protocolVersion = Value(protocolVersion),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<SyncLocalStateRecord> custom({
    Expression<String>? groupId,
    Expression<String>? installationId,
    Expression<int>? protocolVersion,
    Expression<int>? logicalCounter,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (groupId != null) 'group_id': groupId,
      if (installationId != null) 'installation_id': installationId,
      if (protocolVersion != null) 'protocol_version': protocolVersion,
      if (logicalCounter != null) 'logical_counter': logicalCounter,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncLocalStateRecordsCompanion copyWith({
    Value<String>? groupId,
    Value<String>? installationId,
    Value<int>? protocolVersion,
    Value<int>? logicalCounter,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return SyncLocalStateRecordsCompanion(
      groupId: groupId ?? this.groupId,
      installationId: installationId ?? this.installationId,
      protocolVersion: protocolVersion ?? this.protocolVersion,
      logicalCounter: logicalCounter ?? this.logicalCounter,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (groupId.present) {
      map['group_id'] = Variable<String>(groupId.value);
    }
    if (installationId.present) {
      map['installation_id'] = Variable<String>(installationId.value);
    }
    if (protocolVersion.present) {
      map['protocol_version'] = Variable<int>(protocolVersion.value);
    }
    if (logicalCounter.present) {
      map['logical_counter'] = Variable<int>(logicalCounter.value);
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
    return (StringBuffer('SyncLocalStateRecordsCompanion(')
          ..write('groupId: $groupId, ')
          ..write('installationId: $installationId, ')
          ..write('protocolVersion: $protocolVersion, ')
          ..write('logicalCounter: $logicalCounter, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncOutboxRecordsTable extends SyncOutboxRecords
    with TableInfo<$SyncOutboxRecordsTable, SyncOutboxRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncOutboxRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _operationIdMeta = const VerificationMeta(
    'operationId',
  );
  @override
  late final GeneratedColumn<String> operationId = GeneratedColumn<String>(
    'operation_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _groupIdMeta = const VerificationMeta(
    'groupId',
  );
  @override
  late final GeneratedColumn<String> groupId = GeneratedColumn<String>(
    'group_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originDeviceIdMeta = const VerificationMeta(
    'originDeviceId',
  );
  @override
  late final GeneratedColumn<String> originDeviceId = GeneratedColumn<String>(
    'origin_device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originCounterMeta = const VerificationMeta(
    'originCounter',
  );
  @override
  late final GeneratedColumn<int> originCounter = GeneratedColumn<int>(
    'origin_counter',
    aliasedName,
    false,
    type: DriftSqlType.int,
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
  static const VerificationMeta _parentVersionJsonMeta = const VerificationMeta(
    'parentVersionJson',
  );
  @override
  late final GeneratedColumn<String> parentVersionJson =
      GeneratedColumn<String>(
        'parent_version_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _changedFieldsJsonMeta = const VerificationMeta(
    'changedFieldsJson',
  );
  @override
  late final GeneratedColumn<String> changedFieldsJson =
      GeneratedColumn<String>(
        'changed_fields_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _originDeviceNameMeta = const VerificationMeta(
    'originDeviceName',
  );
  @override
  late final GeneratedColumn<String> originDeviceName = GeneratedColumn<String>(
    'origin_device_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _entitySnapshotJsonMeta =
      const VerificationMeta('entitySnapshotJson');
  @override
  late final GeneratedColumn<String> entitySnapshotJson =
      GeneratedColumn<String>(
        'entity_snapshot_json',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _operationKindMeta = const VerificationMeta(
    'operationKind',
  );
  @override
  late final GeneratedColumn<String> operationKind = GeneratedColumn<String>(
    'operation_kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _protocolVersionMeta = const VerificationMeta(
    'protocolVersion',
  );
  @override
  late final GeneratedColumn<int> protocolVersion = GeneratedColumn<int>(
    'protocol_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadSha256Meta = const VerificationMeta(
    'payloadSha256',
  );
  @override
  late final GeneratedColumn<String> payloadSha256 = GeneratedColumn<String>(
    'payload_sha256',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _publicationStateMeta = const VerificationMeta(
    'publicationState',
  );
  @override
  late final GeneratedColumn<String> publicationState = GeneratedColumn<String>(
    'publication_state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _publicationAttemptsMeta =
      const VerificationMeta('publicationAttempts');
  @override
  late final GeneratedColumn<int> publicationAttempts = GeneratedColumn<int>(
    'publication_attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
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
  static const VerificationMeta _publishedAtMeta = const VerificationMeta(
    'publishedAt',
  );
  @override
  late final GeneratedColumn<DateTime> publishedAt = GeneratedColumn<DateTime>(
    'published_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    operationId,
    groupId,
    originDeviceId,
    originCounter,
    entityType,
    entityId,
    parentVersionJson,
    changedFieldsJson,
    originDeviceName,
    entitySnapshotJson,
    operationKind,
    protocolVersion,
    payloadSha256,
    publicationState,
    publicationAttempts,
    createdAt,
    publishedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_outbox';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncOutboxRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('operation_id')) {
      context.handle(
        _operationIdMeta,
        operationId.isAcceptableOrUnknown(
          data['operation_id']!,
          _operationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_operationIdMeta);
    }
    if (data.containsKey('group_id')) {
      context.handle(
        _groupIdMeta,
        groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta),
      );
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('origin_device_id')) {
      context.handle(
        _originDeviceIdMeta,
        originDeviceId.isAcceptableOrUnknown(
          data['origin_device_id']!,
          _originDeviceIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_originDeviceIdMeta);
    }
    if (data.containsKey('origin_counter')) {
      context.handle(
        _originCounterMeta,
        originCounter.isAcceptableOrUnknown(
          data['origin_counter']!,
          _originCounterMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_originCounterMeta);
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
    if (data.containsKey('parent_version_json')) {
      context.handle(
        _parentVersionJsonMeta,
        parentVersionJson.isAcceptableOrUnknown(
          data['parent_version_json']!,
          _parentVersionJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_parentVersionJsonMeta);
    }
    if (data.containsKey('changed_fields_json')) {
      context.handle(
        _changedFieldsJsonMeta,
        changedFieldsJson.isAcceptableOrUnknown(
          data['changed_fields_json']!,
          _changedFieldsJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_changedFieldsJsonMeta);
    }
    if (data.containsKey('origin_device_name')) {
      context.handle(
        _originDeviceNameMeta,
        originDeviceName.isAcceptableOrUnknown(
          data['origin_device_name']!,
          _originDeviceNameMeta,
        ),
      );
    }
    if (data.containsKey('entity_snapshot_json')) {
      context.handle(
        _entitySnapshotJsonMeta,
        entitySnapshotJson.isAcceptableOrUnknown(
          data['entity_snapshot_json']!,
          _entitySnapshotJsonMeta,
        ),
      );
    }
    if (data.containsKey('operation_kind')) {
      context.handle(
        _operationKindMeta,
        operationKind.isAcceptableOrUnknown(
          data['operation_kind']!,
          _operationKindMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_operationKindMeta);
    }
    if (data.containsKey('protocol_version')) {
      context.handle(
        _protocolVersionMeta,
        protocolVersion.isAcceptableOrUnknown(
          data['protocol_version']!,
          _protocolVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_protocolVersionMeta);
    }
    if (data.containsKey('payload_sha256')) {
      context.handle(
        _payloadSha256Meta,
        payloadSha256.isAcceptableOrUnknown(
          data['payload_sha256']!,
          _payloadSha256Meta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadSha256Meta);
    }
    if (data.containsKey('publication_state')) {
      context.handle(
        _publicationStateMeta,
        publicationState.isAcceptableOrUnknown(
          data['publication_state']!,
          _publicationStateMeta,
        ),
      );
    }
    if (data.containsKey('publication_attempts')) {
      context.handle(
        _publicationAttemptsMeta,
        publicationAttempts.isAcceptableOrUnknown(
          data['publication_attempts']!,
          _publicationAttemptsMeta,
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
    if (data.containsKey('published_at')) {
      context.handle(
        _publishedAtMeta,
        publishedAt.isAcceptableOrUnknown(
          data['published_at']!,
          _publishedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {operationId};
  @override
  SyncOutboxRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncOutboxRecord(
      operationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation_id'],
      )!,
      groupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_id'],
      )!,
      originDeviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}origin_device_id'],
      )!,
      originCounter: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}origin_counter'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      parentVersionJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_version_json'],
      )!,
      changedFieldsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}changed_fields_json'],
      )!,
      originDeviceName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}origin_device_name'],
      )!,
      entitySnapshotJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_snapshot_json'],
      ),
      operationKind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation_kind'],
      )!,
      protocolVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}protocol_version'],
      )!,
      payloadSha256: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_sha256'],
      )!,
      publicationState: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}publication_state'],
      )!,
      publicationAttempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}publication_attempts'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      publishedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}published_at'],
      ),
    );
  }

  @override
  $SyncOutboxRecordsTable createAlias(String alias) {
    return $SyncOutboxRecordsTable(attachedDatabase, alias);
  }
}

class SyncOutboxRecord extends DataClass
    implements Insertable<SyncOutboxRecord> {
  final String operationId;
  final String groupId;
  final String originDeviceId;
  final int originCounter;
  final String entityType;
  final String entityId;
  final String parentVersionJson;
  final String changedFieldsJson;
  final String originDeviceName;
  final String? entitySnapshotJson;
  final String operationKind;
  final int protocolVersion;
  final String payloadSha256;
  final String publicationState;
  final int publicationAttempts;
  final DateTime createdAt;
  final DateTime? publishedAt;
  const SyncOutboxRecord({
    required this.operationId,
    required this.groupId,
    required this.originDeviceId,
    required this.originCounter,
    required this.entityType,
    required this.entityId,
    required this.parentVersionJson,
    required this.changedFieldsJson,
    required this.originDeviceName,
    this.entitySnapshotJson,
    required this.operationKind,
    required this.protocolVersion,
    required this.payloadSha256,
    required this.publicationState,
    required this.publicationAttempts,
    required this.createdAt,
    this.publishedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['operation_id'] = Variable<String>(operationId);
    map['group_id'] = Variable<String>(groupId);
    map['origin_device_id'] = Variable<String>(originDeviceId);
    map['origin_counter'] = Variable<int>(originCounter);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    map['parent_version_json'] = Variable<String>(parentVersionJson);
    map['changed_fields_json'] = Variable<String>(changedFieldsJson);
    map['origin_device_name'] = Variable<String>(originDeviceName);
    if (!nullToAbsent || entitySnapshotJson != null) {
      map['entity_snapshot_json'] = Variable<String>(entitySnapshotJson);
    }
    map['operation_kind'] = Variable<String>(operationKind);
    map['protocol_version'] = Variable<int>(protocolVersion);
    map['payload_sha256'] = Variable<String>(payloadSha256);
    map['publication_state'] = Variable<String>(publicationState);
    map['publication_attempts'] = Variable<int>(publicationAttempts);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || publishedAt != null) {
      map['published_at'] = Variable<DateTime>(publishedAt);
    }
    return map;
  }

  SyncOutboxRecordsCompanion toCompanion(bool nullToAbsent) {
    return SyncOutboxRecordsCompanion(
      operationId: Value(operationId),
      groupId: Value(groupId),
      originDeviceId: Value(originDeviceId),
      originCounter: Value(originCounter),
      entityType: Value(entityType),
      entityId: Value(entityId),
      parentVersionJson: Value(parentVersionJson),
      changedFieldsJson: Value(changedFieldsJson),
      originDeviceName: Value(originDeviceName),
      entitySnapshotJson: entitySnapshotJson == null && nullToAbsent
          ? const Value.absent()
          : Value(entitySnapshotJson),
      operationKind: Value(operationKind),
      protocolVersion: Value(protocolVersion),
      payloadSha256: Value(payloadSha256),
      publicationState: Value(publicationState),
      publicationAttempts: Value(publicationAttempts),
      createdAt: Value(createdAt),
      publishedAt: publishedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(publishedAt),
    );
  }

  factory SyncOutboxRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncOutboxRecord(
      operationId: serializer.fromJson<String>(json['operationId']),
      groupId: serializer.fromJson<String>(json['groupId']),
      originDeviceId: serializer.fromJson<String>(json['originDeviceId']),
      originCounter: serializer.fromJson<int>(json['originCounter']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      parentVersionJson: serializer.fromJson<String>(json['parentVersionJson']),
      changedFieldsJson: serializer.fromJson<String>(json['changedFieldsJson']),
      originDeviceName: serializer.fromJson<String>(json['originDeviceName']),
      entitySnapshotJson: serializer.fromJson<String?>(
        json['entitySnapshotJson'],
      ),
      operationKind: serializer.fromJson<String>(json['operationKind']),
      protocolVersion: serializer.fromJson<int>(json['protocolVersion']),
      payloadSha256: serializer.fromJson<String>(json['payloadSha256']),
      publicationState: serializer.fromJson<String>(json['publicationState']),
      publicationAttempts: serializer.fromJson<int>(
        json['publicationAttempts'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      publishedAt: serializer.fromJson<DateTime?>(json['publishedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'operationId': serializer.toJson<String>(operationId),
      'groupId': serializer.toJson<String>(groupId),
      'originDeviceId': serializer.toJson<String>(originDeviceId),
      'originCounter': serializer.toJson<int>(originCounter),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'parentVersionJson': serializer.toJson<String>(parentVersionJson),
      'changedFieldsJson': serializer.toJson<String>(changedFieldsJson),
      'originDeviceName': serializer.toJson<String>(originDeviceName),
      'entitySnapshotJson': serializer.toJson<String?>(entitySnapshotJson),
      'operationKind': serializer.toJson<String>(operationKind),
      'protocolVersion': serializer.toJson<int>(protocolVersion),
      'payloadSha256': serializer.toJson<String>(payloadSha256),
      'publicationState': serializer.toJson<String>(publicationState),
      'publicationAttempts': serializer.toJson<int>(publicationAttempts),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'publishedAt': serializer.toJson<DateTime?>(publishedAt),
    };
  }

  SyncOutboxRecord copyWith({
    String? operationId,
    String? groupId,
    String? originDeviceId,
    int? originCounter,
    String? entityType,
    String? entityId,
    String? parentVersionJson,
    String? changedFieldsJson,
    String? originDeviceName,
    Value<String?> entitySnapshotJson = const Value.absent(),
    String? operationKind,
    int? protocolVersion,
    String? payloadSha256,
    String? publicationState,
    int? publicationAttempts,
    DateTime? createdAt,
    Value<DateTime?> publishedAt = const Value.absent(),
  }) => SyncOutboxRecord(
    operationId: operationId ?? this.operationId,
    groupId: groupId ?? this.groupId,
    originDeviceId: originDeviceId ?? this.originDeviceId,
    originCounter: originCounter ?? this.originCounter,
    entityType: entityType ?? this.entityType,
    entityId: entityId ?? this.entityId,
    parentVersionJson: parentVersionJson ?? this.parentVersionJson,
    changedFieldsJson: changedFieldsJson ?? this.changedFieldsJson,
    originDeviceName: originDeviceName ?? this.originDeviceName,
    entitySnapshotJson: entitySnapshotJson.present
        ? entitySnapshotJson.value
        : this.entitySnapshotJson,
    operationKind: operationKind ?? this.operationKind,
    protocolVersion: protocolVersion ?? this.protocolVersion,
    payloadSha256: payloadSha256 ?? this.payloadSha256,
    publicationState: publicationState ?? this.publicationState,
    publicationAttempts: publicationAttempts ?? this.publicationAttempts,
    createdAt: createdAt ?? this.createdAt,
    publishedAt: publishedAt.present ? publishedAt.value : this.publishedAt,
  );
  SyncOutboxRecord copyWithCompanion(SyncOutboxRecordsCompanion data) {
    return SyncOutboxRecord(
      operationId: data.operationId.present
          ? data.operationId.value
          : this.operationId,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      originDeviceId: data.originDeviceId.present
          ? data.originDeviceId.value
          : this.originDeviceId,
      originCounter: data.originCounter.present
          ? data.originCounter.value
          : this.originCounter,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      parentVersionJson: data.parentVersionJson.present
          ? data.parentVersionJson.value
          : this.parentVersionJson,
      changedFieldsJson: data.changedFieldsJson.present
          ? data.changedFieldsJson.value
          : this.changedFieldsJson,
      originDeviceName: data.originDeviceName.present
          ? data.originDeviceName.value
          : this.originDeviceName,
      entitySnapshotJson: data.entitySnapshotJson.present
          ? data.entitySnapshotJson.value
          : this.entitySnapshotJson,
      operationKind: data.operationKind.present
          ? data.operationKind.value
          : this.operationKind,
      protocolVersion: data.protocolVersion.present
          ? data.protocolVersion.value
          : this.protocolVersion,
      payloadSha256: data.payloadSha256.present
          ? data.payloadSha256.value
          : this.payloadSha256,
      publicationState: data.publicationState.present
          ? data.publicationState.value
          : this.publicationState,
      publicationAttempts: data.publicationAttempts.present
          ? data.publicationAttempts.value
          : this.publicationAttempts,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      publishedAt: data.publishedAt.present
          ? data.publishedAt.value
          : this.publishedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncOutboxRecord(')
          ..write('operationId: $operationId, ')
          ..write('groupId: $groupId, ')
          ..write('originDeviceId: $originDeviceId, ')
          ..write('originCounter: $originCounter, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('parentVersionJson: $parentVersionJson, ')
          ..write('changedFieldsJson: $changedFieldsJson, ')
          ..write('originDeviceName: $originDeviceName, ')
          ..write('entitySnapshotJson: $entitySnapshotJson, ')
          ..write('operationKind: $operationKind, ')
          ..write('protocolVersion: $protocolVersion, ')
          ..write('payloadSha256: $payloadSha256, ')
          ..write('publicationState: $publicationState, ')
          ..write('publicationAttempts: $publicationAttempts, ')
          ..write('createdAt: $createdAt, ')
          ..write('publishedAt: $publishedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    operationId,
    groupId,
    originDeviceId,
    originCounter,
    entityType,
    entityId,
    parentVersionJson,
    changedFieldsJson,
    originDeviceName,
    entitySnapshotJson,
    operationKind,
    protocolVersion,
    payloadSha256,
    publicationState,
    publicationAttempts,
    createdAt,
    publishedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncOutboxRecord &&
          other.operationId == this.operationId &&
          other.groupId == this.groupId &&
          other.originDeviceId == this.originDeviceId &&
          other.originCounter == this.originCounter &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.parentVersionJson == this.parentVersionJson &&
          other.changedFieldsJson == this.changedFieldsJson &&
          other.originDeviceName == this.originDeviceName &&
          other.entitySnapshotJson == this.entitySnapshotJson &&
          other.operationKind == this.operationKind &&
          other.protocolVersion == this.protocolVersion &&
          other.payloadSha256 == this.payloadSha256 &&
          other.publicationState == this.publicationState &&
          other.publicationAttempts == this.publicationAttempts &&
          other.createdAt == this.createdAt &&
          other.publishedAt == this.publishedAt);
}

class SyncOutboxRecordsCompanion extends UpdateCompanion<SyncOutboxRecord> {
  final Value<String> operationId;
  final Value<String> groupId;
  final Value<String> originDeviceId;
  final Value<int> originCounter;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String> parentVersionJson;
  final Value<String> changedFieldsJson;
  final Value<String> originDeviceName;
  final Value<String?> entitySnapshotJson;
  final Value<String> operationKind;
  final Value<int> protocolVersion;
  final Value<String> payloadSha256;
  final Value<String> publicationState;
  final Value<int> publicationAttempts;
  final Value<DateTime> createdAt;
  final Value<DateTime?> publishedAt;
  final Value<int> rowid;
  const SyncOutboxRecordsCompanion({
    this.operationId = const Value.absent(),
    this.groupId = const Value.absent(),
    this.originDeviceId = const Value.absent(),
    this.originCounter = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.parentVersionJson = const Value.absent(),
    this.changedFieldsJson = const Value.absent(),
    this.originDeviceName = const Value.absent(),
    this.entitySnapshotJson = const Value.absent(),
    this.operationKind = const Value.absent(),
    this.protocolVersion = const Value.absent(),
    this.payloadSha256 = const Value.absent(),
    this.publicationState = const Value.absent(),
    this.publicationAttempts = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.publishedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncOutboxRecordsCompanion.insert({
    required String operationId,
    required String groupId,
    required String originDeviceId,
    required int originCounter,
    required String entityType,
    required String entityId,
    required String parentVersionJson,
    required String changedFieldsJson,
    this.originDeviceName = const Value.absent(),
    this.entitySnapshotJson = const Value.absent(),
    required String operationKind,
    required int protocolVersion,
    required String payloadSha256,
    this.publicationState = const Value.absent(),
    this.publicationAttempts = const Value.absent(),
    required DateTime createdAt,
    this.publishedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : operationId = Value(operationId),
       groupId = Value(groupId),
       originDeviceId = Value(originDeviceId),
       originCounter = Value(originCounter),
       entityType = Value(entityType),
       entityId = Value(entityId),
       parentVersionJson = Value(parentVersionJson),
       changedFieldsJson = Value(changedFieldsJson),
       operationKind = Value(operationKind),
       protocolVersion = Value(protocolVersion),
       payloadSha256 = Value(payloadSha256),
       createdAt = Value(createdAt);
  static Insertable<SyncOutboxRecord> custom({
    Expression<String>? operationId,
    Expression<String>? groupId,
    Expression<String>? originDeviceId,
    Expression<int>? originCounter,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? parentVersionJson,
    Expression<String>? changedFieldsJson,
    Expression<String>? originDeviceName,
    Expression<String>? entitySnapshotJson,
    Expression<String>? operationKind,
    Expression<int>? protocolVersion,
    Expression<String>? payloadSha256,
    Expression<String>? publicationState,
    Expression<int>? publicationAttempts,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? publishedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (operationId != null) 'operation_id': operationId,
      if (groupId != null) 'group_id': groupId,
      if (originDeviceId != null) 'origin_device_id': originDeviceId,
      if (originCounter != null) 'origin_counter': originCounter,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (parentVersionJson != null) 'parent_version_json': parentVersionJson,
      if (changedFieldsJson != null) 'changed_fields_json': changedFieldsJson,
      if (originDeviceName != null) 'origin_device_name': originDeviceName,
      if (entitySnapshotJson != null)
        'entity_snapshot_json': entitySnapshotJson,
      if (operationKind != null) 'operation_kind': operationKind,
      if (protocolVersion != null) 'protocol_version': protocolVersion,
      if (payloadSha256 != null) 'payload_sha256': payloadSha256,
      if (publicationState != null) 'publication_state': publicationState,
      if (publicationAttempts != null)
        'publication_attempts': publicationAttempts,
      if (createdAt != null) 'created_at': createdAt,
      if (publishedAt != null) 'published_at': publishedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncOutboxRecordsCompanion copyWith({
    Value<String>? operationId,
    Value<String>? groupId,
    Value<String>? originDeviceId,
    Value<int>? originCounter,
    Value<String>? entityType,
    Value<String>? entityId,
    Value<String>? parentVersionJson,
    Value<String>? changedFieldsJson,
    Value<String>? originDeviceName,
    Value<String?>? entitySnapshotJson,
    Value<String>? operationKind,
    Value<int>? protocolVersion,
    Value<String>? payloadSha256,
    Value<String>? publicationState,
    Value<int>? publicationAttempts,
    Value<DateTime>? createdAt,
    Value<DateTime?>? publishedAt,
    Value<int>? rowid,
  }) {
    return SyncOutboxRecordsCompanion(
      operationId: operationId ?? this.operationId,
      groupId: groupId ?? this.groupId,
      originDeviceId: originDeviceId ?? this.originDeviceId,
      originCounter: originCounter ?? this.originCounter,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      parentVersionJson: parentVersionJson ?? this.parentVersionJson,
      changedFieldsJson: changedFieldsJson ?? this.changedFieldsJson,
      originDeviceName: originDeviceName ?? this.originDeviceName,
      entitySnapshotJson: entitySnapshotJson ?? this.entitySnapshotJson,
      operationKind: operationKind ?? this.operationKind,
      protocolVersion: protocolVersion ?? this.protocolVersion,
      payloadSha256: payloadSha256 ?? this.payloadSha256,
      publicationState: publicationState ?? this.publicationState,
      publicationAttempts: publicationAttempts ?? this.publicationAttempts,
      createdAt: createdAt ?? this.createdAt,
      publishedAt: publishedAt ?? this.publishedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (operationId.present) {
      map['operation_id'] = Variable<String>(operationId.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<String>(groupId.value);
    }
    if (originDeviceId.present) {
      map['origin_device_id'] = Variable<String>(originDeviceId.value);
    }
    if (originCounter.present) {
      map['origin_counter'] = Variable<int>(originCounter.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (parentVersionJson.present) {
      map['parent_version_json'] = Variable<String>(parentVersionJson.value);
    }
    if (changedFieldsJson.present) {
      map['changed_fields_json'] = Variable<String>(changedFieldsJson.value);
    }
    if (originDeviceName.present) {
      map['origin_device_name'] = Variable<String>(originDeviceName.value);
    }
    if (entitySnapshotJson.present) {
      map['entity_snapshot_json'] = Variable<String>(entitySnapshotJson.value);
    }
    if (operationKind.present) {
      map['operation_kind'] = Variable<String>(operationKind.value);
    }
    if (protocolVersion.present) {
      map['protocol_version'] = Variable<int>(protocolVersion.value);
    }
    if (payloadSha256.present) {
      map['payload_sha256'] = Variable<String>(payloadSha256.value);
    }
    if (publicationState.present) {
      map['publication_state'] = Variable<String>(publicationState.value);
    }
    if (publicationAttempts.present) {
      map['publication_attempts'] = Variable<int>(publicationAttempts.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (publishedAt.present) {
      map['published_at'] = Variable<DateTime>(publishedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncOutboxRecordsCompanion(')
          ..write('operationId: $operationId, ')
          ..write('groupId: $groupId, ')
          ..write('originDeviceId: $originDeviceId, ')
          ..write('originCounter: $originCounter, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('parentVersionJson: $parentVersionJson, ')
          ..write('changedFieldsJson: $changedFieldsJson, ')
          ..write('originDeviceName: $originDeviceName, ')
          ..write('entitySnapshotJson: $entitySnapshotJson, ')
          ..write('operationKind: $operationKind, ')
          ..write('protocolVersion: $protocolVersion, ')
          ..write('payloadSha256: $payloadSha256, ')
          ..write('publicationState: $publicationState, ')
          ..write('publicationAttempts: $publicationAttempts, ')
          ..write('createdAt: $createdAt, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncAppliedOperationRecordsTable extends SyncAppliedOperationRecords
    with
        TableInfo<
          $SyncAppliedOperationRecordsTable,
          SyncAppliedOperationRecord
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncAppliedOperationRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _operationIdMeta = const VerificationMeta(
    'operationId',
  );
  @override
  late final GeneratedColumn<String> operationId = GeneratedColumn<String>(
    'operation_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _groupIdMeta = const VerificationMeta(
    'groupId',
  );
  @override
  late final GeneratedColumn<String> groupId = GeneratedColumn<String>(
    'group_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originDeviceIdMeta = const VerificationMeta(
    'originDeviceId',
  );
  @override
  late final GeneratedColumn<String> originDeviceId = GeneratedColumn<String>(
    'origin_device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originCounterMeta = const VerificationMeta(
    'originCounter',
  );
  @override
  late final GeneratedColumn<int> originCounter = GeneratedColumn<int>(
    'origin_counter',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadSha256Meta = const VerificationMeta(
    'payloadSha256',
  );
  @override
  late final GeneratedColumn<String> payloadSha256 = GeneratedColumn<String>(
    'payload_sha256',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _appliedAtMeta = const VerificationMeta(
    'appliedAt',
  );
  @override
  late final GeneratedColumn<DateTime> appliedAt = GeneratedColumn<DateTime>(
    'applied_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    operationId,
    groupId,
    originDeviceId,
    originCounter,
    payloadSha256,
    appliedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_applied_operations';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncAppliedOperationRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('operation_id')) {
      context.handle(
        _operationIdMeta,
        operationId.isAcceptableOrUnknown(
          data['operation_id']!,
          _operationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_operationIdMeta);
    }
    if (data.containsKey('group_id')) {
      context.handle(
        _groupIdMeta,
        groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta),
      );
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('origin_device_id')) {
      context.handle(
        _originDeviceIdMeta,
        originDeviceId.isAcceptableOrUnknown(
          data['origin_device_id']!,
          _originDeviceIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_originDeviceIdMeta);
    }
    if (data.containsKey('origin_counter')) {
      context.handle(
        _originCounterMeta,
        originCounter.isAcceptableOrUnknown(
          data['origin_counter']!,
          _originCounterMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_originCounterMeta);
    }
    if (data.containsKey('payload_sha256')) {
      context.handle(
        _payloadSha256Meta,
        payloadSha256.isAcceptableOrUnknown(
          data['payload_sha256']!,
          _payloadSha256Meta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadSha256Meta);
    }
    if (data.containsKey('applied_at')) {
      context.handle(
        _appliedAtMeta,
        appliedAt.isAcceptableOrUnknown(data['applied_at']!, _appliedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_appliedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {operationId};
  @override
  SyncAppliedOperationRecord map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncAppliedOperationRecord(
      operationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation_id'],
      )!,
      groupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_id'],
      )!,
      originDeviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}origin_device_id'],
      )!,
      originCounter: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}origin_counter'],
      )!,
      payloadSha256: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_sha256'],
      )!,
      appliedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}applied_at'],
      )!,
    );
  }

  @override
  $SyncAppliedOperationRecordsTable createAlias(String alias) {
    return $SyncAppliedOperationRecordsTable(attachedDatabase, alias);
  }
}

class SyncAppliedOperationRecord extends DataClass
    implements Insertable<SyncAppliedOperationRecord> {
  final String operationId;
  final String groupId;
  final String originDeviceId;
  final int originCounter;
  final String payloadSha256;
  final DateTime appliedAt;
  const SyncAppliedOperationRecord({
    required this.operationId,
    required this.groupId,
    required this.originDeviceId,
    required this.originCounter,
    required this.payloadSha256,
    required this.appliedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['operation_id'] = Variable<String>(operationId);
    map['group_id'] = Variable<String>(groupId);
    map['origin_device_id'] = Variable<String>(originDeviceId);
    map['origin_counter'] = Variable<int>(originCounter);
    map['payload_sha256'] = Variable<String>(payloadSha256);
    map['applied_at'] = Variable<DateTime>(appliedAt);
    return map;
  }

  SyncAppliedOperationRecordsCompanion toCompanion(bool nullToAbsent) {
    return SyncAppliedOperationRecordsCompanion(
      operationId: Value(operationId),
      groupId: Value(groupId),
      originDeviceId: Value(originDeviceId),
      originCounter: Value(originCounter),
      payloadSha256: Value(payloadSha256),
      appliedAt: Value(appliedAt),
    );
  }

  factory SyncAppliedOperationRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncAppliedOperationRecord(
      operationId: serializer.fromJson<String>(json['operationId']),
      groupId: serializer.fromJson<String>(json['groupId']),
      originDeviceId: serializer.fromJson<String>(json['originDeviceId']),
      originCounter: serializer.fromJson<int>(json['originCounter']),
      payloadSha256: serializer.fromJson<String>(json['payloadSha256']),
      appliedAt: serializer.fromJson<DateTime>(json['appliedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'operationId': serializer.toJson<String>(operationId),
      'groupId': serializer.toJson<String>(groupId),
      'originDeviceId': serializer.toJson<String>(originDeviceId),
      'originCounter': serializer.toJson<int>(originCounter),
      'payloadSha256': serializer.toJson<String>(payloadSha256),
      'appliedAt': serializer.toJson<DateTime>(appliedAt),
    };
  }

  SyncAppliedOperationRecord copyWith({
    String? operationId,
    String? groupId,
    String? originDeviceId,
    int? originCounter,
    String? payloadSha256,
    DateTime? appliedAt,
  }) => SyncAppliedOperationRecord(
    operationId: operationId ?? this.operationId,
    groupId: groupId ?? this.groupId,
    originDeviceId: originDeviceId ?? this.originDeviceId,
    originCounter: originCounter ?? this.originCounter,
    payloadSha256: payloadSha256 ?? this.payloadSha256,
    appliedAt: appliedAt ?? this.appliedAt,
  );
  SyncAppliedOperationRecord copyWithCompanion(
    SyncAppliedOperationRecordsCompanion data,
  ) {
    return SyncAppliedOperationRecord(
      operationId: data.operationId.present
          ? data.operationId.value
          : this.operationId,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      originDeviceId: data.originDeviceId.present
          ? data.originDeviceId.value
          : this.originDeviceId,
      originCounter: data.originCounter.present
          ? data.originCounter.value
          : this.originCounter,
      payloadSha256: data.payloadSha256.present
          ? data.payloadSha256.value
          : this.payloadSha256,
      appliedAt: data.appliedAt.present ? data.appliedAt.value : this.appliedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncAppliedOperationRecord(')
          ..write('operationId: $operationId, ')
          ..write('groupId: $groupId, ')
          ..write('originDeviceId: $originDeviceId, ')
          ..write('originCounter: $originCounter, ')
          ..write('payloadSha256: $payloadSha256, ')
          ..write('appliedAt: $appliedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    operationId,
    groupId,
    originDeviceId,
    originCounter,
    payloadSha256,
    appliedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncAppliedOperationRecord &&
          other.operationId == this.operationId &&
          other.groupId == this.groupId &&
          other.originDeviceId == this.originDeviceId &&
          other.originCounter == this.originCounter &&
          other.payloadSha256 == this.payloadSha256 &&
          other.appliedAt == this.appliedAt);
}

class SyncAppliedOperationRecordsCompanion
    extends UpdateCompanion<SyncAppliedOperationRecord> {
  final Value<String> operationId;
  final Value<String> groupId;
  final Value<String> originDeviceId;
  final Value<int> originCounter;
  final Value<String> payloadSha256;
  final Value<DateTime> appliedAt;
  final Value<int> rowid;
  const SyncAppliedOperationRecordsCompanion({
    this.operationId = const Value.absent(),
    this.groupId = const Value.absent(),
    this.originDeviceId = const Value.absent(),
    this.originCounter = const Value.absent(),
    this.payloadSha256 = const Value.absent(),
    this.appliedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncAppliedOperationRecordsCompanion.insert({
    required String operationId,
    required String groupId,
    required String originDeviceId,
    required int originCounter,
    required String payloadSha256,
    required DateTime appliedAt,
    this.rowid = const Value.absent(),
  }) : operationId = Value(operationId),
       groupId = Value(groupId),
       originDeviceId = Value(originDeviceId),
       originCounter = Value(originCounter),
       payloadSha256 = Value(payloadSha256),
       appliedAt = Value(appliedAt);
  static Insertable<SyncAppliedOperationRecord> custom({
    Expression<String>? operationId,
    Expression<String>? groupId,
    Expression<String>? originDeviceId,
    Expression<int>? originCounter,
    Expression<String>? payloadSha256,
    Expression<DateTime>? appliedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (operationId != null) 'operation_id': operationId,
      if (groupId != null) 'group_id': groupId,
      if (originDeviceId != null) 'origin_device_id': originDeviceId,
      if (originCounter != null) 'origin_counter': originCounter,
      if (payloadSha256 != null) 'payload_sha256': payloadSha256,
      if (appliedAt != null) 'applied_at': appliedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncAppliedOperationRecordsCompanion copyWith({
    Value<String>? operationId,
    Value<String>? groupId,
    Value<String>? originDeviceId,
    Value<int>? originCounter,
    Value<String>? payloadSha256,
    Value<DateTime>? appliedAt,
    Value<int>? rowid,
  }) {
    return SyncAppliedOperationRecordsCompanion(
      operationId: operationId ?? this.operationId,
      groupId: groupId ?? this.groupId,
      originDeviceId: originDeviceId ?? this.originDeviceId,
      originCounter: originCounter ?? this.originCounter,
      payloadSha256: payloadSha256 ?? this.payloadSha256,
      appliedAt: appliedAt ?? this.appliedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (operationId.present) {
      map['operation_id'] = Variable<String>(operationId.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<String>(groupId.value);
    }
    if (originDeviceId.present) {
      map['origin_device_id'] = Variable<String>(originDeviceId.value);
    }
    if (originCounter.present) {
      map['origin_counter'] = Variable<int>(originCounter.value);
    }
    if (payloadSha256.present) {
      map['payload_sha256'] = Variable<String>(payloadSha256.value);
    }
    if (appliedAt.present) {
      map['applied_at'] = Variable<DateTime>(appliedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncAppliedOperationRecordsCompanion(')
          ..write('operationId: $operationId, ')
          ..write('groupId: $groupId, ')
          ..write('originDeviceId: $originDeviceId, ')
          ..write('originCounter: $originCounter, ')
          ..write('payloadSha256: $payloadSha256, ')
          ..write('appliedAt: $appliedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncEntityVersionRecordsTable extends SyncEntityVersionRecords
    with TableInfo<$SyncEntityVersionRecordsTable, SyncEntityVersionRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncEntityVersionRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _groupIdMeta = const VerificationMeta(
    'groupId',
  );
  @override
  late final GeneratedColumn<String> groupId = GeneratedColumn<String>(
    'group_id',
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
  static const VerificationMeta _fieldNameMeta = const VerificationMeta(
    'fieldName',
  );
  @override
  late final GeneratedColumn<String> fieldName = GeneratedColumn<String>(
    'field_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _causalVersionJsonMeta = const VerificationMeta(
    'causalVersionJson',
  );
  @override
  late final GeneratedColumn<String> causalVersionJson =
      GeneratedColumn<String>(
        'causal_version_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _operationIdMeta = const VerificationMeta(
    'operationId',
  );
  @override
  late final GeneratedColumn<String> operationId = GeneratedColumn<String>(
    'operation_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originDeviceIdMeta = const VerificationMeta(
    'originDeviceId',
  );
  @override
  late final GeneratedColumn<String> originDeviceId = GeneratedColumn<String>(
    'origin_device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originDeviceNameMeta = const VerificationMeta(
    'originDeviceName',
  );
  @override
  late final GeneratedColumn<String> originDeviceName = GeneratedColumn<String>(
    'origin_device_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
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
    groupId,
    entityType,
    entityId,
    fieldName,
    causalVersionJson,
    operationId,
    originDeviceId,
    originDeviceName,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_entity_versions';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncEntityVersionRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('group_id')) {
      context.handle(
        _groupIdMeta,
        groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta),
      );
    } else if (isInserting) {
      context.missing(_groupIdMeta);
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
    if (data.containsKey('field_name')) {
      context.handle(
        _fieldNameMeta,
        fieldName.isAcceptableOrUnknown(data['field_name']!, _fieldNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fieldNameMeta);
    }
    if (data.containsKey('causal_version_json')) {
      context.handle(
        _causalVersionJsonMeta,
        causalVersionJson.isAcceptableOrUnknown(
          data['causal_version_json']!,
          _causalVersionJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_causalVersionJsonMeta);
    }
    if (data.containsKey('operation_id')) {
      context.handle(
        _operationIdMeta,
        operationId.isAcceptableOrUnknown(
          data['operation_id']!,
          _operationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_operationIdMeta);
    }
    if (data.containsKey('origin_device_id')) {
      context.handle(
        _originDeviceIdMeta,
        originDeviceId.isAcceptableOrUnknown(
          data['origin_device_id']!,
          _originDeviceIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_originDeviceIdMeta);
    }
    if (data.containsKey('origin_device_name')) {
      context.handle(
        _originDeviceNameMeta,
        originDeviceName.isAcceptableOrUnknown(
          data['origin_device_name']!,
          _originDeviceNameMeta,
        ),
      );
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
  Set<GeneratedColumn> get $primaryKey => {
    groupId,
    entityType,
    entityId,
    fieldName,
  };
  @override
  SyncEntityVersionRecord map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncEntityVersionRecord(
      groupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_id'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      fieldName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}field_name'],
      )!,
      causalVersionJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}causal_version_json'],
      )!,
      operationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation_id'],
      )!,
      originDeviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}origin_device_id'],
      )!,
      originDeviceName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}origin_device_name'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SyncEntityVersionRecordsTable createAlias(String alias) {
    return $SyncEntityVersionRecordsTable(attachedDatabase, alias);
  }
}

class SyncEntityVersionRecord extends DataClass
    implements Insertable<SyncEntityVersionRecord> {
  final String groupId;
  final String entityType;
  final String entityId;
  final String fieldName;
  final String causalVersionJson;
  final String operationId;
  final String originDeviceId;
  final String originDeviceName;
  final DateTime updatedAt;
  const SyncEntityVersionRecord({
    required this.groupId,
    required this.entityType,
    required this.entityId,
    required this.fieldName,
    required this.causalVersionJson,
    required this.operationId,
    required this.originDeviceId,
    required this.originDeviceName,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['group_id'] = Variable<String>(groupId);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    map['field_name'] = Variable<String>(fieldName);
    map['causal_version_json'] = Variable<String>(causalVersionJson);
    map['operation_id'] = Variable<String>(operationId);
    map['origin_device_id'] = Variable<String>(originDeviceId);
    map['origin_device_name'] = Variable<String>(originDeviceName);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SyncEntityVersionRecordsCompanion toCompanion(bool nullToAbsent) {
    return SyncEntityVersionRecordsCompanion(
      groupId: Value(groupId),
      entityType: Value(entityType),
      entityId: Value(entityId),
      fieldName: Value(fieldName),
      causalVersionJson: Value(causalVersionJson),
      operationId: Value(operationId),
      originDeviceId: Value(originDeviceId),
      originDeviceName: Value(originDeviceName),
      updatedAt: Value(updatedAt),
    );
  }

  factory SyncEntityVersionRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncEntityVersionRecord(
      groupId: serializer.fromJson<String>(json['groupId']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      fieldName: serializer.fromJson<String>(json['fieldName']),
      causalVersionJson: serializer.fromJson<String>(json['causalVersionJson']),
      operationId: serializer.fromJson<String>(json['operationId']),
      originDeviceId: serializer.fromJson<String>(json['originDeviceId']),
      originDeviceName: serializer.fromJson<String>(json['originDeviceName']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'groupId': serializer.toJson<String>(groupId),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'fieldName': serializer.toJson<String>(fieldName),
      'causalVersionJson': serializer.toJson<String>(causalVersionJson),
      'operationId': serializer.toJson<String>(operationId),
      'originDeviceId': serializer.toJson<String>(originDeviceId),
      'originDeviceName': serializer.toJson<String>(originDeviceName),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SyncEntityVersionRecord copyWith({
    String? groupId,
    String? entityType,
    String? entityId,
    String? fieldName,
    String? causalVersionJson,
    String? operationId,
    String? originDeviceId,
    String? originDeviceName,
    DateTime? updatedAt,
  }) => SyncEntityVersionRecord(
    groupId: groupId ?? this.groupId,
    entityType: entityType ?? this.entityType,
    entityId: entityId ?? this.entityId,
    fieldName: fieldName ?? this.fieldName,
    causalVersionJson: causalVersionJson ?? this.causalVersionJson,
    operationId: operationId ?? this.operationId,
    originDeviceId: originDeviceId ?? this.originDeviceId,
    originDeviceName: originDeviceName ?? this.originDeviceName,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  SyncEntityVersionRecord copyWithCompanion(
    SyncEntityVersionRecordsCompanion data,
  ) {
    return SyncEntityVersionRecord(
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      fieldName: data.fieldName.present ? data.fieldName.value : this.fieldName,
      causalVersionJson: data.causalVersionJson.present
          ? data.causalVersionJson.value
          : this.causalVersionJson,
      operationId: data.operationId.present
          ? data.operationId.value
          : this.operationId,
      originDeviceId: data.originDeviceId.present
          ? data.originDeviceId.value
          : this.originDeviceId,
      originDeviceName: data.originDeviceName.present
          ? data.originDeviceName.value
          : this.originDeviceName,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncEntityVersionRecord(')
          ..write('groupId: $groupId, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('fieldName: $fieldName, ')
          ..write('causalVersionJson: $causalVersionJson, ')
          ..write('operationId: $operationId, ')
          ..write('originDeviceId: $originDeviceId, ')
          ..write('originDeviceName: $originDeviceName, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    groupId,
    entityType,
    entityId,
    fieldName,
    causalVersionJson,
    operationId,
    originDeviceId,
    originDeviceName,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncEntityVersionRecord &&
          other.groupId == this.groupId &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.fieldName == this.fieldName &&
          other.causalVersionJson == this.causalVersionJson &&
          other.operationId == this.operationId &&
          other.originDeviceId == this.originDeviceId &&
          other.originDeviceName == this.originDeviceName &&
          other.updatedAt == this.updatedAt);
}

class SyncEntityVersionRecordsCompanion
    extends UpdateCompanion<SyncEntityVersionRecord> {
  final Value<String> groupId;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String> fieldName;
  final Value<String> causalVersionJson;
  final Value<String> operationId;
  final Value<String> originDeviceId;
  final Value<String> originDeviceName;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SyncEntityVersionRecordsCompanion({
    this.groupId = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.fieldName = const Value.absent(),
    this.causalVersionJson = const Value.absent(),
    this.operationId = const Value.absent(),
    this.originDeviceId = const Value.absent(),
    this.originDeviceName = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncEntityVersionRecordsCompanion.insert({
    required String groupId,
    required String entityType,
    required String entityId,
    required String fieldName,
    required String causalVersionJson,
    required String operationId,
    required String originDeviceId,
    this.originDeviceName = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : groupId = Value(groupId),
       entityType = Value(entityType),
       entityId = Value(entityId),
       fieldName = Value(fieldName),
       causalVersionJson = Value(causalVersionJson),
       operationId = Value(operationId),
       originDeviceId = Value(originDeviceId),
       updatedAt = Value(updatedAt);
  static Insertable<SyncEntityVersionRecord> custom({
    Expression<String>? groupId,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? fieldName,
    Expression<String>? causalVersionJson,
    Expression<String>? operationId,
    Expression<String>? originDeviceId,
    Expression<String>? originDeviceName,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (groupId != null) 'group_id': groupId,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (fieldName != null) 'field_name': fieldName,
      if (causalVersionJson != null) 'causal_version_json': causalVersionJson,
      if (operationId != null) 'operation_id': operationId,
      if (originDeviceId != null) 'origin_device_id': originDeviceId,
      if (originDeviceName != null) 'origin_device_name': originDeviceName,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncEntityVersionRecordsCompanion copyWith({
    Value<String>? groupId,
    Value<String>? entityType,
    Value<String>? entityId,
    Value<String>? fieldName,
    Value<String>? causalVersionJson,
    Value<String>? operationId,
    Value<String>? originDeviceId,
    Value<String>? originDeviceName,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return SyncEntityVersionRecordsCompanion(
      groupId: groupId ?? this.groupId,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      fieldName: fieldName ?? this.fieldName,
      causalVersionJson: causalVersionJson ?? this.causalVersionJson,
      operationId: operationId ?? this.operationId,
      originDeviceId: originDeviceId ?? this.originDeviceId,
      originDeviceName: originDeviceName ?? this.originDeviceName,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (groupId.present) {
      map['group_id'] = Variable<String>(groupId.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (fieldName.present) {
      map['field_name'] = Variable<String>(fieldName.value);
    }
    if (causalVersionJson.present) {
      map['causal_version_json'] = Variable<String>(causalVersionJson.value);
    }
    if (operationId.present) {
      map['operation_id'] = Variable<String>(operationId.value);
    }
    if (originDeviceId.present) {
      map['origin_device_id'] = Variable<String>(originDeviceId.value);
    }
    if (originDeviceName.present) {
      map['origin_device_name'] = Variable<String>(originDeviceName.value);
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
    return (StringBuffer('SyncEntityVersionRecordsCompanion(')
          ..write('groupId: $groupId, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('fieldName: $fieldName, ')
          ..write('causalVersionJson: $causalVersionJson, ')
          ..write('operationId: $operationId, ')
          ..write('originDeviceId: $originDeviceId, ')
          ..write('originDeviceName: $originDeviceName, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncTombstoneRecordsTable extends SyncTombstoneRecords
    with TableInfo<$SyncTombstoneRecordsTable, SyncTombstoneRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncTombstoneRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _groupIdMeta = const VerificationMeta(
    'groupId',
  );
  @override
  late final GeneratedColumn<String> groupId = GeneratedColumn<String>(
    'group_id',
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
  static const VerificationMeta _causalVersionJsonMeta = const VerificationMeta(
    'causalVersionJson',
  );
  @override
  late final GeneratedColumn<String> causalVersionJson =
      GeneratedColumn<String>(
        'causal_version_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _operationIdMeta = const VerificationMeta(
    'operationId',
  );
  @override
  late final GeneratedColumn<String> operationId = GeneratedColumn<String>(
    'operation_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originDeviceIdMeta = const VerificationMeta(
    'originDeviceId',
  );
  @override
  late final GeneratedColumn<String> originDeviceId = GeneratedColumn<String>(
    'origin_device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originDeviceNameMeta = const VerificationMeta(
    'originDeviceName',
  );
  @override
  late final GeneratedColumn<String> originDeviceName = GeneratedColumn<String>(
    'origin_device_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _entitySnapshotJsonMeta =
      const VerificationMeta('entitySnapshotJson');
  @override
  late final GeneratedColumn<String> entitySnapshotJson =
      GeneratedColumn<String>(
        'entity_snapshot_json',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    groupId,
    entityType,
    entityId,
    causalVersionJson,
    operationId,
    originDeviceId,
    originDeviceName,
    entitySnapshotJson,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_tombstones';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncTombstoneRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('group_id')) {
      context.handle(
        _groupIdMeta,
        groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta),
      );
    } else if (isInserting) {
      context.missing(_groupIdMeta);
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
    if (data.containsKey('causal_version_json')) {
      context.handle(
        _causalVersionJsonMeta,
        causalVersionJson.isAcceptableOrUnknown(
          data['causal_version_json']!,
          _causalVersionJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_causalVersionJsonMeta);
    }
    if (data.containsKey('operation_id')) {
      context.handle(
        _operationIdMeta,
        operationId.isAcceptableOrUnknown(
          data['operation_id']!,
          _operationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_operationIdMeta);
    }
    if (data.containsKey('origin_device_id')) {
      context.handle(
        _originDeviceIdMeta,
        originDeviceId.isAcceptableOrUnknown(
          data['origin_device_id']!,
          _originDeviceIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_originDeviceIdMeta);
    }
    if (data.containsKey('origin_device_name')) {
      context.handle(
        _originDeviceNameMeta,
        originDeviceName.isAcceptableOrUnknown(
          data['origin_device_name']!,
          _originDeviceNameMeta,
        ),
      );
    }
    if (data.containsKey('entity_snapshot_json')) {
      context.handle(
        _entitySnapshotJsonMeta,
        entitySnapshotJson.isAcceptableOrUnknown(
          data['entity_snapshot_json']!,
          _entitySnapshotJsonMeta,
        ),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_deletedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {groupId, entityType, entityId};
  @override
  SyncTombstoneRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncTombstoneRecord(
      groupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_id'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      causalVersionJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}causal_version_json'],
      )!,
      operationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation_id'],
      )!,
      originDeviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}origin_device_id'],
      )!,
      originDeviceName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}origin_device_name'],
      )!,
      entitySnapshotJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_snapshot_json'],
      ),
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      )!,
    );
  }

  @override
  $SyncTombstoneRecordsTable createAlias(String alias) {
    return $SyncTombstoneRecordsTable(attachedDatabase, alias);
  }
}

class SyncTombstoneRecord extends DataClass
    implements Insertable<SyncTombstoneRecord> {
  final String groupId;
  final String entityType;
  final String entityId;
  final String causalVersionJson;
  final String operationId;
  final String originDeviceId;
  final String originDeviceName;
  final String? entitySnapshotJson;
  final DateTime deletedAt;
  const SyncTombstoneRecord({
    required this.groupId,
    required this.entityType,
    required this.entityId,
    required this.causalVersionJson,
    required this.operationId,
    required this.originDeviceId,
    required this.originDeviceName,
    this.entitySnapshotJson,
    required this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['group_id'] = Variable<String>(groupId);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    map['causal_version_json'] = Variable<String>(causalVersionJson);
    map['operation_id'] = Variable<String>(operationId);
    map['origin_device_id'] = Variable<String>(originDeviceId);
    map['origin_device_name'] = Variable<String>(originDeviceName);
    if (!nullToAbsent || entitySnapshotJson != null) {
      map['entity_snapshot_json'] = Variable<String>(entitySnapshotJson);
    }
    map['deleted_at'] = Variable<DateTime>(deletedAt);
    return map;
  }

  SyncTombstoneRecordsCompanion toCompanion(bool nullToAbsent) {
    return SyncTombstoneRecordsCompanion(
      groupId: Value(groupId),
      entityType: Value(entityType),
      entityId: Value(entityId),
      causalVersionJson: Value(causalVersionJson),
      operationId: Value(operationId),
      originDeviceId: Value(originDeviceId),
      originDeviceName: Value(originDeviceName),
      entitySnapshotJson: entitySnapshotJson == null && nullToAbsent
          ? const Value.absent()
          : Value(entitySnapshotJson),
      deletedAt: Value(deletedAt),
    );
  }

  factory SyncTombstoneRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncTombstoneRecord(
      groupId: serializer.fromJson<String>(json['groupId']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      causalVersionJson: serializer.fromJson<String>(json['causalVersionJson']),
      operationId: serializer.fromJson<String>(json['operationId']),
      originDeviceId: serializer.fromJson<String>(json['originDeviceId']),
      originDeviceName: serializer.fromJson<String>(json['originDeviceName']),
      entitySnapshotJson: serializer.fromJson<String?>(
        json['entitySnapshotJson'],
      ),
      deletedAt: serializer.fromJson<DateTime>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'groupId': serializer.toJson<String>(groupId),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'causalVersionJson': serializer.toJson<String>(causalVersionJson),
      'operationId': serializer.toJson<String>(operationId),
      'originDeviceId': serializer.toJson<String>(originDeviceId),
      'originDeviceName': serializer.toJson<String>(originDeviceName),
      'entitySnapshotJson': serializer.toJson<String?>(entitySnapshotJson),
      'deletedAt': serializer.toJson<DateTime>(deletedAt),
    };
  }

  SyncTombstoneRecord copyWith({
    String? groupId,
    String? entityType,
    String? entityId,
    String? causalVersionJson,
    String? operationId,
    String? originDeviceId,
    String? originDeviceName,
    Value<String?> entitySnapshotJson = const Value.absent(),
    DateTime? deletedAt,
  }) => SyncTombstoneRecord(
    groupId: groupId ?? this.groupId,
    entityType: entityType ?? this.entityType,
    entityId: entityId ?? this.entityId,
    causalVersionJson: causalVersionJson ?? this.causalVersionJson,
    operationId: operationId ?? this.operationId,
    originDeviceId: originDeviceId ?? this.originDeviceId,
    originDeviceName: originDeviceName ?? this.originDeviceName,
    entitySnapshotJson: entitySnapshotJson.present
        ? entitySnapshotJson.value
        : this.entitySnapshotJson,
    deletedAt: deletedAt ?? this.deletedAt,
  );
  SyncTombstoneRecord copyWithCompanion(SyncTombstoneRecordsCompanion data) {
    return SyncTombstoneRecord(
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      causalVersionJson: data.causalVersionJson.present
          ? data.causalVersionJson.value
          : this.causalVersionJson,
      operationId: data.operationId.present
          ? data.operationId.value
          : this.operationId,
      originDeviceId: data.originDeviceId.present
          ? data.originDeviceId.value
          : this.originDeviceId,
      originDeviceName: data.originDeviceName.present
          ? data.originDeviceName.value
          : this.originDeviceName,
      entitySnapshotJson: data.entitySnapshotJson.present
          ? data.entitySnapshotJson.value
          : this.entitySnapshotJson,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncTombstoneRecord(')
          ..write('groupId: $groupId, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('causalVersionJson: $causalVersionJson, ')
          ..write('operationId: $operationId, ')
          ..write('originDeviceId: $originDeviceId, ')
          ..write('originDeviceName: $originDeviceName, ')
          ..write('entitySnapshotJson: $entitySnapshotJson, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    groupId,
    entityType,
    entityId,
    causalVersionJson,
    operationId,
    originDeviceId,
    originDeviceName,
    entitySnapshotJson,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncTombstoneRecord &&
          other.groupId == this.groupId &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.causalVersionJson == this.causalVersionJson &&
          other.operationId == this.operationId &&
          other.originDeviceId == this.originDeviceId &&
          other.originDeviceName == this.originDeviceName &&
          other.entitySnapshotJson == this.entitySnapshotJson &&
          other.deletedAt == this.deletedAt);
}

class SyncTombstoneRecordsCompanion
    extends UpdateCompanion<SyncTombstoneRecord> {
  final Value<String> groupId;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String> causalVersionJson;
  final Value<String> operationId;
  final Value<String> originDeviceId;
  final Value<String> originDeviceName;
  final Value<String?> entitySnapshotJson;
  final Value<DateTime> deletedAt;
  final Value<int> rowid;
  const SyncTombstoneRecordsCompanion({
    this.groupId = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.causalVersionJson = const Value.absent(),
    this.operationId = const Value.absent(),
    this.originDeviceId = const Value.absent(),
    this.originDeviceName = const Value.absent(),
    this.entitySnapshotJson = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncTombstoneRecordsCompanion.insert({
    required String groupId,
    required String entityType,
    required String entityId,
    required String causalVersionJson,
    required String operationId,
    required String originDeviceId,
    this.originDeviceName = const Value.absent(),
    this.entitySnapshotJson = const Value.absent(),
    required DateTime deletedAt,
    this.rowid = const Value.absent(),
  }) : groupId = Value(groupId),
       entityType = Value(entityType),
       entityId = Value(entityId),
       causalVersionJson = Value(causalVersionJson),
       operationId = Value(operationId),
       originDeviceId = Value(originDeviceId),
       deletedAt = Value(deletedAt);
  static Insertable<SyncTombstoneRecord> custom({
    Expression<String>? groupId,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? causalVersionJson,
    Expression<String>? operationId,
    Expression<String>? originDeviceId,
    Expression<String>? originDeviceName,
    Expression<String>? entitySnapshotJson,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (groupId != null) 'group_id': groupId,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (causalVersionJson != null) 'causal_version_json': causalVersionJson,
      if (operationId != null) 'operation_id': operationId,
      if (originDeviceId != null) 'origin_device_id': originDeviceId,
      if (originDeviceName != null) 'origin_device_name': originDeviceName,
      if (entitySnapshotJson != null)
        'entity_snapshot_json': entitySnapshotJson,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncTombstoneRecordsCompanion copyWith({
    Value<String>? groupId,
    Value<String>? entityType,
    Value<String>? entityId,
    Value<String>? causalVersionJson,
    Value<String>? operationId,
    Value<String>? originDeviceId,
    Value<String>? originDeviceName,
    Value<String?>? entitySnapshotJson,
    Value<DateTime>? deletedAt,
    Value<int>? rowid,
  }) {
    return SyncTombstoneRecordsCompanion(
      groupId: groupId ?? this.groupId,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      causalVersionJson: causalVersionJson ?? this.causalVersionJson,
      operationId: operationId ?? this.operationId,
      originDeviceId: originDeviceId ?? this.originDeviceId,
      originDeviceName: originDeviceName ?? this.originDeviceName,
      entitySnapshotJson: entitySnapshotJson ?? this.entitySnapshotJson,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (groupId.present) {
      map['group_id'] = Variable<String>(groupId.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (causalVersionJson.present) {
      map['causal_version_json'] = Variable<String>(causalVersionJson.value);
    }
    if (operationId.present) {
      map['operation_id'] = Variable<String>(operationId.value);
    }
    if (originDeviceId.present) {
      map['origin_device_id'] = Variable<String>(originDeviceId.value);
    }
    if (originDeviceName.present) {
      map['origin_device_name'] = Variable<String>(originDeviceName.value);
    }
    if (entitySnapshotJson.present) {
      map['entity_snapshot_json'] = Variable<String>(entitySnapshotJson.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncTombstoneRecordsCompanion(')
          ..write('groupId: $groupId, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('causalVersionJson: $causalVersionJson, ')
          ..write('operationId: $operationId, ')
          ..write('originDeviceId: $originDeviceId, ')
          ..write('originDeviceName: $originDeviceName, ')
          ..write('entitySnapshotJson: $entitySnapshotJson, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncConflictRecordsTable extends SyncConflictRecords
    with TableInfo<$SyncConflictRecordsTable, SyncConflictRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncConflictRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _groupIdMeta = const VerificationMeta(
    'groupId',
  );
  @override
  late final GeneratedColumn<String> groupId = GeneratedColumn<String>(
    'group_id',
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
  static const VerificationMeta _fieldNameMeta = const VerificationMeta(
    'fieldName',
  );
  @override
  late final GeneratedColumn<String> fieldName = GeneratedColumn<String>(
    'field_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _candidatesJsonMeta = const VerificationMeta(
    'candidatesJson',
  );
  @override
  late final GeneratedColumn<String> candidatesJson = GeneratedColumn<String>(
    'candidates_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('open'),
  );
  static const VerificationMeta _resolutionOperationIdMeta =
      const VerificationMeta('resolutionOperationId');
  @override
  late final GeneratedColumn<String> resolutionOperationId =
      GeneratedColumn<String>(
        'resolution_operation_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
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
  static const VerificationMeta _resolvedAtMeta = const VerificationMeta(
    'resolvedAt',
  );
  @override
  late final GeneratedColumn<DateTime> resolvedAt = GeneratedColumn<DateTime>(
    'resolved_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    groupId,
    entityType,
    entityId,
    fieldName,
    candidatesJson,
    status,
    resolutionOperationId,
    createdAt,
    resolvedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_conflicts';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncConflictRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('group_id')) {
      context.handle(
        _groupIdMeta,
        groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta),
      );
    } else if (isInserting) {
      context.missing(_groupIdMeta);
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
    if (data.containsKey('field_name')) {
      context.handle(
        _fieldNameMeta,
        fieldName.isAcceptableOrUnknown(data['field_name']!, _fieldNameMeta),
      );
    }
    if (data.containsKey('candidates_json')) {
      context.handle(
        _candidatesJsonMeta,
        candidatesJson.isAcceptableOrUnknown(
          data['candidates_json']!,
          _candidatesJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_candidatesJsonMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('resolution_operation_id')) {
      context.handle(
        _resolutionOperationIdMeta,
        resolutionOperationId.isAcceptableOrUnknown(
          data['resolution_operation_id']!,
          _resolutionOperationIdMeta,
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
    if (data.containsKey('resolved_at')) {
      context.handle(
        _resolvedAtMeta,
        resolvedAt.isAcceptableOrUnknown(data['resolved_at']!, _resolvedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncConflictRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncConflictRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      groupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_id'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      fieldName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}field_name'],
      ),
      candidatesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}candidates_json'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      resolutionOperationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}resolution_operation_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      resolvedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}resolved_at'],
      ),
    );
  }

  @override
  $SyncConflictRecordsTable createAlias(String alias) {
    return $SyncConflictRecordsTable(attachedDatabase, alias);
  }
}

class SyncConflictRecord extends DataClass
    implements Insertable<SyncConflictRecord> {
  final String id;
  final String groupId;
  final String entityType;
  final String entityId;
  final String? fieldName;
  final String candidatesJson;
  final String status;
  final String? resolutionOperationId;
  final DateTime createdAt;
  final DateTime? resolvedAt;
  const SyncConflictRecord({
    required this.id,
    required this.groupId,
    required this.entityType,
    required this.entityId,
    this.fieldName,
    required this.candidatesJson,
    required this.status,
    this.resolutionOperationId,
    required this.createdAt,
    this.resolvedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['group_id'] = Variable<String>(groupId);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    if (!nullToAbsent || fieldName != null) {
      map['field_name'] = Variable<String>(fieldName);
    }
    map['candidates_json'] = Variable<String>(candidatesJson);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || resolutionOperationId != null) {
      map['resolution_operation_id'] = Variable<String>(resolutionOperationId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || resolvedAt != null) {
      map['resolved_at'] = Variable<DateTime>(resolvedAt);
    }
    return map;
  }

  SyncConflictRecordsCompanion toCompanion(bool nullToAbsent) {
    return SyncConflictRecordsCompanion(
      id: Value(id),
      groupId: Value(groupId),
      entityType: Value(entityType),
      entityId: Value(entityId),
      fieldName: fieldName == null && nullToAbsent
          ? const Value.absent()
          : Value(fieldName),
      candidatesJson: Value(candidatesJson),
      status: Value(status),
      resolutionOperationId: resolutionOperationId == null && nullToAbsent
          ? const Value.absent()
          : Value(resolutionOperationId),
      createdAt: Value(createdAt),
      resolvedAt: resolvedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(resolvedAt),
    );
  }

  factory SyncConflictRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncConflictRecord(
      id: serializer.fromJson<String>(json['id']),
      groupId: serializer.fromJson<String>(json['groupId']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      fieldName: serializer.fromJson<String?>(json['fieldName']),
      candidatesJson: serializer.fromJson<String>(json['candidatesJson']),
      status: serializer.fromJson<String>(json['status']),
      resolutionOperationId: serializer.fromJson<String?>(
        json['resolutionOperationId'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      resolvedAt: serializer.fromJson<DateTime?>(json['resolvedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'groupId': serializer.toJson<String>(groupId),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'fieldName': serializer.toJson<String?>(fieldName),
      'candidatesJson': serializer.toJson<String>(candidatesJson),
      'status': serializer.toJson<String>(status),
      'resolutionOperationId': serializer.toJson<String?>(
        resolutionOperationId,
      ),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'resolvedAt': serializer.toJson<DateTime?>(resolvedAt),
    };
  }

  SyncConflictRecord copyWith({
    String? id,
    String? groupId,
    String? entityType,
    String? entityId,
    Value<String?> fieldName = const Value.absent(),
    String? candidatesJson,
    String? status,
    Value<String?> resolutionOperationId = const Value.absent(),
    DateTime? createdAt,
    Value<DateTime?> resolvedAt = const Value.absent(),
  }) => SyncConflictRecord(
    id: id ?? this.id,
    groupId: groupId ?? this.groupId,
    entityType: entityType ?? this.entityType,
    entityId: entityId ?? this.entityId,
    fieldName: fieldName.present ? fieldName.value : this.fieldName,
    candidatesJson: candidatesJson ?? this.candidatesJson,
    status: status ?? this.status,
    resolutionOperationId: resolutionOperationId.present
        ? resolutionOperationId.value
        : this.resolutionOperationId,
    createdAt: createdAt ?? this.createdAt,
    resolvedAt: resolvedAt.present ? resolvedAt.value : this.resolvedAt,
  );
  SyncConflictRecord copyWithCompanion(SyncConflictRecordsCompanion data) {
    return SyncConflictRecord(
      id: data.id.present ? data.id.value : this.id,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      fieldName: data.fieldName.present ? data.fieldName.value : this.fieldName,
      candidatesJson: data.candidatesJson.present
          ? data.candidatesJson.value
          : this.candidatesJson,
      status: data.status.present ? data.status.value : this.status,
      resolutionOperationId: data.resolutionOperationId.present
          ? data.resolutionOperationId.value
          : this.resolutionOperationId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      resolvedAt: data.resolvedAt.present
          ? data.resolvedAt.value
          : this.resolvedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncConflictRecord(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('fieldName: $fieldName, ')
          ..write('candidatesJson: $candidatesJson, ')
          ..write('status: $status, ')
          ..write('resolutionOperationId: $resolutionOperationId, ')
          ..write('createdAt: $createdAt, ')
          ..write('resolvedAt: $resolvedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    groupId,
    entityType,
    entityId,
    fieldName,
    candidatesJson,
    status,
    resolutionOperationId,
    createdAt,
    resolvedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncConflictRecord &&
          other.id == this.id &&
          other.groupId == this.groupId &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.fieldName == this.fieldName &&
          other.candidatesJson == this.candidatesJson &&
          other.status == this.status &&
          other.resolutionOperationId == this.resolutionOperationId &&
          other.createdAt == this.createdAt &&
          other.resolvedAt == this.resolvedAt);
}

class SyncConflictRecordsCompanion extends UpdateCompanion<SyncConflictRecord> {
  final Value<String> id;
  final Value<String> groupId;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String?> fieldName;
  final Value<String> candidatesJson;
  final Value<String> status;
  final Value<String?> resolutionOperationId;
  final Value<DateTime> createdAt;
  final Value<DateTime?> resolvedAt;
  final Value<int> rowid;
  const SyncConflictRecordsCompanion({
    this.id = const Value.absent(),
    this.groupId = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.fieldName = const Value.absent(),
    this.candidatesJson = const Value.absent(),
    this.status = const Value.absent(),
    this.resolutionOperationId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.resolvedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncConflictRecordsCompanion.insert({
    required String id,
    required String groupId,
    required String entityType,
    required String entityId,
    this.fieldName = const Value.absent(),
    required String candidatesJson,
    this.status = const Value.absent(),
    this.resolutionOperationId = const Value.absent(),
    required DateTime createdAt,
    this.resolvedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       groupId = Value(groupId),
       entityType = Value(entityType),
       entityId = Value(entityId),
       candidatesJson = Value(candidatesJson),
       createdAt = Value(createdAt);
  static Insertable<SyncConflictRecord> custom({
    Expression<String>? id,
    Expression<String>? groupId,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? fieldName,
    Expression<String>? candidatesJson,
    Expression<String>? status,
    Expression<String>? resolutionOperationId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? resolvedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (groupId != null) 'group_id': groupId,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (fieldName != null) 'field_name': fieldName,
      if (candidatesJson != null) 'candidates_json': candidatesJson,
      if (status != null) 'status': status,
      if (resolutionOperationId != null)
        'resolution_operation_id': resolutionOperationId,
      if (createdAt != null) 'created_at': createdAt,
      if (resolvedAt != null) 'resolved_at': resolvedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncConflictRecordsCompanion copyWith({
    Value<String>? id,
    Value<String>? groupId,
    Value<String>? entityType,
    Value<String>? entityId,
    Value<String?>? fieldName,
    Value<String>? candidatesJson,
    Value<String>? status,
    Value<String?>? resolutionOperationId,
    Value<DateTime>? createdAt,
    Value<DateTime?>? resolvedAt,
    Value<int>? rowid,
  }) {
    return SyncConflictRecordsCompanion(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      fieldName: fieldName ?? this.fieldName,
      candidatesJson: candidatesJson ?? this.candidatesJson,
      status: status ?? this.status,
      resolutionOperationId:
          resolutionOperationId ?? this.resolutionOperationId,
      createdAt: createdAt ?? this.createdAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<String>(groupId.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (fieldName.present) {
      map['field_name'] = Variable<String>(fieldName.value);
    }
    if (candidatesJson.present) {
      map['candidates_json'] = Variable<String>(candidatesJson.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (resolutionOperationId.present) {
      map['resolution_operation_id'] = Variable<String>(
        resolutionOperationId.value,
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (resolvedAt.present) {
      map['resolved_at'] = Variable<DateTime>(resolvedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncConflictRecordsCompanion(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('fieldName: $fieldName, ')
          ..write('candidatesJson: $candidatesJson, ')
          ..write('status: $status, ')
          ..write('resolutionOperationId: $resolutionOperationId, ')
          ..write('createdAt: $createdAt, ')
          ..write('resolvedAt: $resolvedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncAcknowledgementRecordsTable extends SyncAcknowledgementRecords
    with
        TableInfo<$SyncAcknowledgementRecordsTable, SyncAcknowledgementRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncAcknowledgementRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _groupIdMeta = const VerificationMeta(
    'groupId',
  );
  @override
  late final GeneratedColumn<String> groupId = GeneratedColumn<String>(
    'group_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _observerDeviceIdMeta = const VerificationMeta(
    'observerDeviceId',
  );
  @override
  late final GeneratedColumn<String> observerDeviceId = GeneratedColumn<String>(
    'observer_device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originDeviceIdMeta = const VerificationMeta(
    'originDeviceId',
  );
  @override
  late final GeneratedColumn<String> originDeviceId = GeneratedColumn<String>(
    'origin_device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _acknowledgedCounterMeta =
      const VerificationMeta('acknowledgedCounter');
  @override
  late final GeneratedColumn<int> acknowledgedCounter = GeneratedColumn<int>(
    'acknowledged_counter',
    aliasedName,
    false,
    type: DriftSqlType.int,
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
    groupId,
    observerDeviceId,
    originDeviceId,
    acknowledgedCounter,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_acknowledgements';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncAcknowledgementRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('group_id')) {
      context.handle(
        _groupIdMeta,
        groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta),
      );
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('observer_device_id')) {
      context.handle(
        _observerDeviceIdMeta,
        observerDeviceId.isAcceptableOrUnknown(
          data['observer_device_id']!,
          _observerDeviceIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_observerDeviceIdMeta);
    }
    if (data.containsKey('origin_device_id')) {
      context.handle(
        _originDeviceIdMeta,
        originDeviceId.isAcceptableOrUnknown(
          data['origin_device_id']!,
          _originDeviceIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_originDeviceIdMeta);
    }
    if (data.containsKey('acknowledged_counter')) {
      context.handle(
        _acknowledgedCounterMeta,
        acknowledgedCounter.isAcceptableOrUnknown(
          data['acknowledged_counter']!,
          _acknowledgedCounterMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_acknowledgedCounterMeta);
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
  Set<GeneratedColumn> get $primaryKey => {
    groupId,
    observerDeviceId,
    originDeviceId,
  };
  @override
  SyncAcknowledgementRecord map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncAcknowledgementRecord(
      groupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_id'],
      )!,
      observerDeviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}observer_device_id'],
      )!,
      originDeviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}origin_device_id'],
      )!,
      acknowledgedCounter: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}acknowledged_counter'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SyncAcknowledgementRecordsTable createAlias(String alias) {
    return $SyncAcknowledgementRecordsTable(attachedDatabase, alias);
  }
}

class SyncAcknowledgementRecord extends DataClass
    implements Insertable<SyncAcknowledgementRecord> {
  final String groupId;
  final String observerDeviceId;
  final String originDeviceId;
  final int acknowledgedCounter;
  final DateTime updatedAt;
  const SyncAcknowledgementRecord({
    required this.groupId,
    required this.observerDeviceId,
    required this.originDeviceId,
    required this.acknowledgedCounter,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['group_id'] = Variable<String>(groupId);
    map['observer_device_id'] = Variable<String>(observerDeviceId);
    map['origin_device_id'] = Variable<String>(originDeviceId);
    map['acknowledged_counter'] = Variable<int>(acknowledgedCounter);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SyncAcknowledgementRecordsCompanion toCompanion(bool nullToAbsent) {
    return SyncAcknowledgementRecordsCompanion(
      groupId: Value(groupId),
      observerDeviceId: Value(observerDeviceId),
      originDeviceId: Value(originDeviceId),
      acknowledgedCounter: Value(acknowledgedCounter),
      updatedAt: Value(updatedAt),
    );
  }

  factory SyncAcknowledgementRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncAcknowledgementRecord(
      groupId: serializer.fromJson<String>(json['groupId']),
      observerDeviceId: serializer.fromJson<String>(json['observerDeviceId']),
      originDeviceId: serializer.fromJson<String>(json['originDeviceId']),
      acknowledgedCounter: serializer.fromJson<int>(
        json['acknowledgedCounter'],
      ),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'groupId': serializer.toJson<String>(groupId),
      'observerDeviceId': serializer.toJson<String>(observerDeviceId),
      'originDeviceId': serializer.toJson<String>(originDeviceId),
      'acknowledgedCounter': serializer.toJson<int>(acknowledgedCounter),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SyncAcknowledgementRecord copyWith({
    String? groupId,
    String? observerDeviceId,
    String? originDeviceId,
    int? acknowledgedCounter,
    DateTime? updatedAt,
  }) => SyncAcknowledgementRecord(
    groupId: groupId ?? this.groupId,
    observerDeviceId: observerDeviceId ?? this.observerDeviceId,
    originDeviceId: originDeviceId ?? this.originDeviceId,
    acknowledgedCounter: acknowledgedCounter ?? this.acknowledgedCounter,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  SyncAcknowledgementRecord copyWithCompanion(
    SyncAcknowledgementRecordsCompanion data,
  ) {
    return SyncAcknowledgementRecord(
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      observerDeviceId: data.observerDeviceId.present
          ? data.observerDeviceId.value
          : this.observerDeviceId,
      originDeviceId: data.originDeviceId.present
          ? data.originDeviceId.value
          : this.originDeviceId,
      acknowledgedCounter: data.acknowledgedCounter.present
          ? data.acknowledgedCounter.value
          : this.acknowledgedCounter,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncAcknowledgementRecord(')
          ..write('groupId: $groupId, ')
          ..write('observerDeviceId: $observerDeviceId, ')
          ..write('originDeviceId: $originDeviceId, ')
          ..write('acknowledgedCounter: $acknowledgedCounter, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    groupId,
    observerDeviceId,
    originDeviceId,
    acknowledgedCounter,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncAcknowledgementRecord &&
          other.groupId == this.groupId &&
          other.observerDeviceId == this.observerDeviceId &&
          other.originDeviceId == this.originDeviceId &&
          other.acknowledgedCounter == this.acknowledgedCounter &&
          other.updatedAt == this.updatedAt);
}

class SyncAcknowledgementRecordsCompanion
    extends UpdateCompanion<SyncAcknowledgementRecord> {
  final Value<String> groupId;
  final Value<String> observerDeviceId;
  final Value<String> originDeviceId;
  final Value<int> acknowledgedCounter;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SyncAcknowledgementRecordsCompanion({
    this.groupId = const Value.absent(),
    this.observerDeviceId = const Value.absent(),
    this.originDeviceId = const Value.absent(),
    this.acknowledgedCounter = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncAcknowledgementRecordsCompanion.insert({
    required String groupId,
    required String observerDeviceId,
    required String originDeviceId,
    required int acknowledgedCounter,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : groupId = Value(groupId),
       observerDeviceId = Value(observerDeviceId),
       originDeviceId = Value(originDeviceId),
       acknowledgedCounter = Value(acknowledgedCounter),
       updatedAt = Value(updatedAt);
  static Insertable<SyncAcknowledgementRecord> custom({
    Expression<String>? groupId,
    Expression<String>? observerDeviceId,
    Expression<String>? originDeviceId,
    Expression<int>? acknowledgedCounter,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (groupId != null) 'group_id': groupId,
      if (observerDeviceId != null) 'observer_device_id': observerDeviceId,
      if (originDeviceId != null) 'origin_device_id': originDeviceId,
      if (acknowledgedCounter != null)
        'acknowledged_counter': acknowledgedCounter,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncAcknowledgementRecordsCompanion copyWith({
    Value<String>? groupId,
    Value<String>? observerDeviceId,
    Value<String>? originDeviceId,
    Value<int>? acknowledgedCounter,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return SyncAcknowledgementRecordsCompanion(
      groupId: groupId ?? this.groupId,
      observerDeviceId: observerDeviceId ?? this.observerDeviceId,
      originDeviceId: originDeviceId ?? this.originDeviceId,
      acknowledgedCounter: acknowledgedCounter ?? this.acknowledgedCounter,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (groupId.present) {
      map['group_id'] = Variable<String>(groupId.value);
    }
    if (observerDeviceId.present) {
      map['observer_device_id'] = Variable<String>(observerDeviceId.value);
    }
    if (originDeviceId.present) {
      map['origin_device_id'] = Variable<String>(originDeviceId.value);
    }
    if (acknowledgedCounter.present) {
      map['acknowledged_counter'] = Variable<int>(acknowledgedCounter.value);
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
    return (StringBuffer('SyncAcknowledgementRecordsCompanion(')
          ..write('groupId: $groupId, ')
          ..write('observerDeviceId: $observerDeviceId, ')
          ..write('originDeviceId: $originDeviceId, ')
          ..write('acknowledgedCounter: $acknowledgedCounter, ')
          ..write('updatedAt: $updatedAt, ')
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
  late final $RoutineRecordsTable routineRecords = $RoutineRecordsTable(this);
  late final $RoutineDayRecordsTable routineDayRecords =
      $RoutineDayRecordsTable(this);
  late final $RoutineItemRecordsTable routineItemRecords =
      $RoutineItemRecordsTable(this);
  late final $RoutineRunRecordsTable routineRunRecords =
      $RoutineRunRecordsTable(this);
  late final $RoutineItemRunRecordsTable routineItemRunRecords =
      $RoutineItemRunRecordsTable(this);
  late final $CalendarEventRecordsTable calendarEventRecords =
      $CalendarEventRecordsTable(this);
  late final $QuickNoteRecordsTable quickNoteRecords = $QuickNoteRecordsTable(
    this,
  );
  late final $SyncLocalStateRecordsTable syncLocalStateRecords =
      $SyncLocalStateRecordsTable(this);
  late final $SyncOutboxRecordsTable syncOutboxRecords =
      $SyncOutboxRecordsTable(this);
  late final $SyncAppliedOperationRecordsTable syncAppliedOperationRecords =
      $SyncAppliedOperationRecordsTable(this);
  late final $SyncEntityVersionRecordsTable syncEntityVersionRecords =
      $SyncEntityVersionRecordsTable(this);
  late final $SyncTombstoneRecordsTable syncTombstoneRecords =
      $SyncTombstoneRecordsTable(this);
  late final $SyncConflictRecordsTable syncConflictRecords =
      $SyncConflictRecordsTable(this);
  late final $SyncAcknowledgementRecordsTable syncAcknowledgementRecords =
      $SyncAcknowledgementRecordsTable(this);
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
  late final Index routinesStatusIdx = Index(
    'routines_status_idx',
    'CREATE INDEX routines_status_idx ON routines (status)',
  );
  late final Index routinesUpdatedAtIdx = Index(
    'routines_updated_at_idx',
    'CREATE INDEX routines_updated_at_idx ON routines (updated_at)',
  );
  late final Index routineDaysWeekdayRoutineIdx = Index(
    'routine_days_weekday_routine_idx',
    'CREATE INDEX routine_days_weekday_routine_idx ON routine_days (weekday, routine_id)',
  );
  late final Index routineItemsRoutinePositionUq = Index(
    'routine_items_routine_position_uq',
    'CREATE UNIQUE INDEX routine_items_routine_position_uq ON routine_items (routine_id, position)',
  );
  late final Index routineItemsRoutineTimeIdx = Index(
    'routine_items_routine_time_idx',
    'CREATE INDEX routine_items_routine_time_idx ON routine_items (routine_id, scheduled_minute)',
  );
  late final Index routineItemsGoalIdIdx = Index(
    'routine_items_goal_id_idx',
    'CREATE INDEX routine_items_goal_id_idx ON routine_items (goal_id)',
  );
  late final Index routineRunsOccurrenceUq = Index(
    'routine_runs_occurrence_uq',
    'CREATE UNIQUE INDEX routine_runs_occurrence_uq ON routine_runs (source_routine_id, local_date)',
  );
  late final Index routineRunsDateStatusIdx = Index(
    'routine_runs_date_status_idx',
    'CREATE INDEX routine_runs_date_status_idx ON routine_runs (local_date, status)',
  );
  late final Index routineRunsRoutineDateIdx = Index(
    'routine_runs_routine_date_idx',
    'CREATE INDEX routine_runs_routine_date_idx ON routine_runs (routine_id, local_date)',
  );
  late final Index routineItemRunsMaterializationUq = Index(
    'routine_item_runs_materialization_uq',
    'CREATE UNIQUE INDEX routine_item_runs_materialization_uq ON routine_item_runs (routine_run_id, source_item_id)',
  );
  late final Index routineItemRunsTaskIdUq = Index(
    'routine_item_runs_task_id_uq',
    'CREATE UNIQUE INDEX routine_item_runs_task_id_uq ON routine_item_runs (task_id)',
  );
  late final Index routineItemRunsRoutineItemIdIdx = Index(
    'routine_item_runs_routine_item_id_idx',
    'CREATE INDEX routine_item_runs_routine_item_id_idx ON routine_item_runs (routine_item_id)',
  );
  late final Index routineItemRunsScheduleStatusIdx = Index(
    'routine_item_runs_schedule_status_idx',
    'CREATE INDEX routine_item_runs_schedule_status_idx ON routine_item_runs (scheduled_at_snapshot, status)',
  );
  late final Index routineItemRunsRunPositionIdx = Index(
    'routine_item_runs_run_position_idx',
    'CREATE INDEX routine_item_runs_run_position_idx ON routine_item_runs (routine_run_id, position_snapshot)',
  );
  late final Index calendarEventsScheduledAtIdx = Index(
    'calendar_events_scheduled_at_idx',
    'CREATE INDEX calendar_events_scheduled_at_idx ON calendar_events (scheduled_at)',
  );
  late final Index quickNotesPositionIdx = Index(
    'quick_notes_position_idx',
    'CREATE INDEX quick_notes_position_idx ON quick_notes (position)',
  );
  late final Index quickNotesLocalDateIdx = Index(
    'quick_notes_local_date_idx',
    'CREATE INDEX quick_notes_local_date_idx ON quick_notes (local_date)',
  );
  late final Index quickNotesUpdatedAtIdx = Index(
    'quick_notes_updated_at_idx',
    'CREATE INDEX quick_notes_updated_at_idx ON quick_notes (updated_at)',
  );
  late final Index syncOutboxOriginCounterUq = Index(
    'sync_outbox_origin_counter_uq',
    'CREATE UNIQUE INDEX sync_outbox_origin_counter_uq ON sync_outbox (group_id, origin_device_id, origin_counter)',
  );
  late final Index syncOutboxStateCreatedIdx = Index(
    'sync_outbox_state_created_idx',
    'CREATE INDEX sync_outbox_state_created_idx ON sync_outbox (publication_state, created_at)',
  );
  late final Index syncAppliedOriginCounterUq = Index(
    'sync_applied_origin_counter_uq',
    'CREATE UNIQUE INDEX sync_applied_origin_counter_uq ON sync_applied_operations (group_id, origin_device_id, origin_counter)',
  );
  late final Index syncConflictsEntityStatusIdx = Index(
    'sync_conflicts_entity_status_idx',
    'CREATE INDEX sync_conflicts_entity_status_idx ON sync_conflicts (group_id, entity_type, entity_id, status)',
  );
  late final GoalsDao goalsDao = GoalsDao(this as MichiFocusDatabase);
  late final TasksDao tasksDao = TasksDao(this as MichiFocusDatabase);
  late final PomodoroSessionsDao pomodoroSessionsDao = PomodoroSessionsDao(
    this as MichiFocusDatabase,
  );
  late final PomodoroRuntimeDao pomodoroRuntimeDao = PomodoroRuntimeDao(
    this as MichiFocusDatabase,
  );
  late final RoutinesDao routinesDao = RoutinesDao(this as MichiFocusDatabase);
  late final CalendarEventsDao calendarEventsDao = CalendarEventsDao(
    this as MichiFocusDatabase,
  );
  late final QuickNotesDao quickNotesDao = QuickNotesDao(
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
    routineRecords,
    routineDayRecords,
    routineItemRecords,
    routineRunRecords,
    routineItemRunRecords,
    calendarEventRecords,
    quickNoteRecords,
    syncLocalStateRecords,
    syncOutboxRecords,
    syncAppliedOperationRecords,
    syncEntityVersionRecords,
    syncTombstoneRecords,
    syncConflictRecords,
    syncAcknowledgementRecords,
    tasksGoalIdIdx,
    tasksScheduledDateIdx,
    tasksCreatedAtIdx,
    taskCompletionEventsCompletedAtIdx,
    taskCompletionEventsTaskCompletedIdx,
    pomodoroSessionsGoalIdIdx,
    pomodoroSessionsTaskIdIdx,
    pomodoroSessionsStartedAtIdx,
    pomodoroSessionsEndedAtIdx,
    routinesStatusIdx,
    routinesUpdatedAtIdx,
    routineDaysWeekdayRoutineIdx,
    routineItemsRoutinePositionUq,
    routineItemsRoutineTimeIdx,
    routineItemsGoalIdIdx,
    routineRunsOccurrenceUq,
    routineRunsDateStatusIdx,
    routineRunsRoutineDateIdx,
    routineItemRunsMaterializationUq,
    routineItemRunsTaskIdUq,
    routineItemRunsRoutineItemIdIdx,
    routineItemRunsScheduleStatusIdx,
    routineItemRunsRunPositionIdx,
    calendarEventsScheduledAtIdx,
    quickNotesPositionIdx,
    quickNotesLocalDateIdx,
    quickNotesUpdatedAtIdx,
    syncOutboxOriginCounterUq,
    syncOutboxStateCreatedIdx,
    syncAppliedOriginCounterUq,
    syncConflictsEntityStatusIdx,
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
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'routines',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('routine_days', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'routines',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('routine_items', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'goals',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('routine_items', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'routines',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('routine_runs', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'routine_runs',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('routine_item_runs', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'routine_items',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('routine_item_runs', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'tasks',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('routine_item_runs', kind: UpdateKind.update)],
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

  static MultiTypedResultKey<$RoutineItemRecordsTable, List<RoutineItemRecord>>
  _routineItemRecordsRefsTable(_$MichiFocusDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.routineItemRecords,
        aliasName: $_aliasNameGenerator(
          db.goalRecords.id,
          db.routineItemRecords.goalId,
        ),
      );

  $$RoutineItemRecordsTableProcessedTableManager get routineItemRecordsRefs {
    final manager = $$RoutineItemRecordsTableTableManager(
      $_db,
      $_db.routineItemRecords,
    ).filter((f) => f.goalId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _routineItemRecordsRefsTable($_db),
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

  Expression<bool> routineItemRecordsRefs(
    Expression<bool> Function($$RoutineItemRecordsTableFilterComposer f) f,
  ) {
    final $$RoutineItemRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.routineItemRecords,
      getReferencedColumn: (t) => t.goalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutineItemRecordsTableFilterComposer(
            $db: $db,
            $table: $db.routineItemRecords,
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

  Expression<T> routineItemRecordsRefs<T extends Object>(
    Expression<T> Function($$RoutineItemRecordsTableAnnotationComposer a) f,
  ) {
    final $$RoutineItemRecordsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.routineItemRecords,
          getReferencedColumn: (t) => t.goalId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RoutineItemRecordsTableAnnotationComposer(
                $db: $db,
                $table: $db.routineItemRecords,
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
            bool routineItemRecordsRefs,
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
                routineItemRecordsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (taskRecordsRefs) db.taskRecords,
                    if (pomodoroSessionRecordsRefs) db.pomodoroSessionRecords,
                    if (pomodoroRuntimeRecordsRefs) db.pomodoroRuntimeRecords,
                    if (routineItemRecordsRefs) db.routineItemRecords,
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
                      if (routineItemRecordsRefs)
                        await $_getPrefetchedData<
                          GoalRecord,
                          $GoalRecordsTable,
                          RoutineItemRecord
                        >(
                          currentTable: table,
                          referencedTable: $$GoalRecordsTableReferences
                              ._routineItemRecordsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GoalRecordsTableReferences(
                                db,
                                table,
                                p0,
                              ).routineItemRecordsRefs,
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
        bool routineItemRecordsRefs,
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

  static MultiTypedResultKey<
    $RoutineItemRunRecordsTable,
    List<RoutineItemRunRecord>
  >
  _routineItemRunRecordsRefsTable(_$MichiFocusDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.routineItemRunRecords,
        aliasName: $_aliasNameGenerator(
          db.taskRecords.id,
          db.routineItemRunRecords.taskId,
        ),
      );

  $$RoutineItemRunRecordsTableProcessedTableManager
  get routineItemRunRecordsRefs {
    final manager = $$RoutineItemRunRecordsTableTableManager(
      $_db,
      $_db.routineItemRunRecords,
    ).filter((f) => f.taskId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _routineItemRunRecordsRefsTable($_db),
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

  Expression<bool> routineItemRunRecordsRefs(
    Expression<bool> Function($$RoutineItemRunRecordsTableFilterComposer f) f,
  ) {
    final $$RoutineItemRunRecordsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.routineItemRunRecords,
          getReferencedColumn: (t) => t.taskId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RoutineItemRunRecordsTableFilterComposer(
                $db: $db,
                $table: $db.routineItemRunRecords,
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

  Expression<T> routineItemRunRecordsRefs<T extends Object>(
    Expression<T> Function($$RoutineItemRunRecordsTableAnnotationComposer a) f,
  ) {
    final $$RoutineItemRunRecordsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.routineItemRunRecords,
          getReferencedColumn: (t) => t.taskId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RoutineItemRunRecordsTableAnnotationComposer(
                $db: $db,
                $table: $db.routineItemRunRecords,
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
            bool routineItemRunRecordsRefs,
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
                routineItemRunRecordsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (taskCompletionEventRecordsRefs)
                      db.taskCompletionEventRecords,
                    if (pomodoroSessionRecordsRefs) db.pomodoroSessionRecords,
                    if (pomodoroRuntimeRecordsRefs) db.pomodoroRuntimeRecords,
                    if (routineItemRunRecordsRefs) db.routineItemRunRecords,
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
                      if (routineItemRunRecordsRefs)
                        await $_getPrefetchedData<
                          TaskRecord,
                          $TaskRecordsTable,
                          RoutineItemRunRecord
                        >(
                          currentTable: table,
                          referencedTable: $$TaskRecordsTableReferences
                              ._routineItemRunRecordsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TaskRecordsTableReferences(
                                db,
                                table,
                                p0,
                              ).routineItemRunRecordsRefs,
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
        bool routineItemRunRecordsRefs,
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
      Value<bool> moodPromptPending,
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
      Value<bool> moodPromptPending,
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

  ColumnFilters<bool> get moodPromptPending => $composableBuilder(
    column: $table.moodPromptPending,
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

  ColumnOrderings<bool> get moodPromptPending => $composableBuilder(
    column: $table.moodPromptPending,
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

  GeneratedColumn<bool> get moodPromptPending => $composableBuilder(
    column: $table.moodPromptPending,
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
                Value<bool> moodPromptPending = const Value.absent(),
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
                moodPromptPending: moodPromptPending,
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
                Value<bool> moodPromptPending = const Value.absent(),
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
                moodPromptPending: moodPromptPending,
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
typedef $$RoutineRecordsTableCreateCompanionBuilder =
    RoutineRecordsCompanion Function({
      required String id,
      required String name,
      Value<String?> description,
      Value<String> iconKey,
      Value<String> colorKey,
      Value<int?> customColorArgb,
      Value<String?> validFromLocalDate,
      Value<String?> validUntilLocalDate,
      Value<String> status,
      Value<String?> pausedUntilLocalDate,
      Value<DateTime?> archivedAt,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$RoutineRecordsTableUpdateCompanionBuilder =
    RoutineRecordsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> description,
      Value<String> iconKey,
      Value<String> colorKey,
      Value<int?> customColorArgb,
      Value<String?> validFromLocalDate,
      Value<String?> validUntilLocalDate,
      Value<String> status,
      Value<String?> pausedUntilLocalDate,
      Value<DateTime?> archivedAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$RoutineRecordsTableReferences
    extends
        BaseReferences<
          _$MichiFocusDatabase,
          $RoutineRecordsTable,
          RoutineRecord
        > {
  $$RoutineRecordsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$RoutineDayRecordsTable, List<RoutineDayRecord>>
  _routineDayRecordsRefsTable(_$MichiFocusDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.routineDayRecords,
        aliasName: $_aliasNameGenerator(
          db.routineRecords.id,
          db.routineDayRecords.routineId,
        ),
      );

  $$RoutineDayRecordsTableProcessedTableManager get routineDayRecordsRefs {
    final manager = $$RoutineDayRecordsTableTableManager(
      $_db,
      $_db.routineDayRecords,
    ).filter((f) => f.routineId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _routineDayRecordsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RoutineItemRecordsTable, List<RoutineItemRecord>>
  _routineItemRecordsRefsTable(_$MichiFocusDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.routineItemRecords,
        aliasName: $_aliasNameGenerator(
          db.routineRecords.id,
          db.routineItemRecords.routineId,
        ),
      );

  $$RoutineItemRecordsTableProcessedTableManager get routineItemRecordsRefs {
    final manager = $$RoutineItemRecordsTableTableManager(
      $_db,
      $_db.routineItemRecords,
    ).filter((f) => f.routineId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _routineItemRecordsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RoutineRunRecordsTable, List<RoutineRunRecord>>
  _routineRunRecordsRefsTable(_$MichiFocusDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.routineRunRecords,
        aliasName: $_aliasNameGenerator(
          db.routineRecords.id,
          db.routineRunRecords.routineId,
        ),
      );

  $$RoutineRunRecordsTableProcessedTableManager get routineRunRecordsRefs {
    final manager = $$RoutineRunRecordsTableTableManager(
      $_db,
      $_db.routineRunRecords,
    ).filter((f) => f.routineId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _routineRunRecordsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RoutineRecordsTableFilterComposer
    extends Composer<_$MichiFocusDatabase, $RoutineRecordsTable> {
  $$RoutineRecordsTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get iconKey => $composableBuilder(
    column: $table.iconKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get colorKey => $composableBuilder(
    column: $table.colorKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get customColorArgb => $composableBuilder(
    column: $table.customColorArgb,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get validFromLocalDate => $composableBuilder(
    column: $table.validFromLocalDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get validUntilLocalDate => $composableBuilder(
    column: $table.validUntilLocalDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pausedUntilLocalDate => $composableBuilder(
    column: $table.pausedUntilLocalDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
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

  Expression<bool> routineDayRecordsRefs(
    Expression<bool> Function($$RoutineDayRecordsTableFilterComposer f) f,
  ) {
    final $$RoutineDayRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.routineDayRecords,
      getReferencedColumn: (t) => t.routineId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutineDayRecordsTableFilterComposer(
            $db: $db,
            $table: $db.routineDayRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> routineItemRecordsRefs(
    Expression<bool> Function($$RoutineItemRecordsTableFilterComposer f) f,
  ) {
    final $$RoutineItemRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.routineItemRecords,
      getReferencedColumn: (t) => t.routineId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutineItemRecordsTableFilterComposer(
            $db: $db,
            $table: $db.routineItemRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> routineRunRecordsRefs(
    Expression<bool> Function($$RoutineRunRecordsTableFilterComposer f) f,
  ) {
    final $$RoutineRunRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.routineRunRecords,
      getReferencedColumn: (t) => t.routineId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutineRunRecordsTableFilterComposer(
            $db: $db,
            $table: $db.routineRunRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RoutineRecordsTableOrderingComposer
    extends Composer<_$MichiFocusDatabase, $RoutineRecordsTable> {
  $$RoutineRecordsTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iconKey => $composableBuilder(
    column: $table.iconKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get colorKey => $composableBuilder(
    column: $table.colorKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get customColorArgb => $composableBuilder(
    column: $table.customColorArgb,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get validFromLocalDate => $composableBuilder(
    column: $table.validFromLocalDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get validUntilLocalDate => $composableBuilder(
    column: $table.validUntilLocalDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pausedUntilLocalDate => $composableBuilder(
    column: $table.pausedUntilLocalDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
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

class $$RoutineRecordsTableAnnotationComposer
    extends Composer<_$MichiFocusDatabase, $RoutineRecordsTable> {
  $$RoutineRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get iconKey =>
      $composableBuilder(column: $table.iconKey, builder: (column) => column);

  GeneratedColumn<String> get colorKey =>
      $composableBuilder(column: $table.colorKey, builder: (column) => column);

  GeneratedColumn<int> get customColorArgb => $composableBuilder(
    column: $table.customColorArgb,
    builder: (column) => column,
  );

  GeneratedColumn<String> get validFromLocalDate => $composableBuilder(
    column: $table.validFromLocalDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get validUntilLocalDate => $composableBuilder(
    column: $table.validUntilLocalDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get pausedUntilLocalDate => $composableBuilder(
    column: $table.pausedUntilLocalDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> routineDayRecordsRefs<T extends Object>(
    Expression<T> Function($$RoutineDayRecordsTableAnnotationComposer a) f,
  ) {
    final $$RoutineDayRecordsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.routineDayRecords,
          getReferencedColumn: (t) => t.routineId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RoutineDayRecordsTableAnnotationComposer(
                $db: $db,
                $table: $db.routineDayRecords,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> routineItemRecordsRefs<T extends Object>(
    Expression<T> Function($$RoutineItemRecordsTableAnnotationComposer a) f,
  ) {
    final $$RoutineItemRecordsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.routineItemRecords,
          getReferencedColumn: (t) => t.routineId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RoutineItemRecordsTableAnnotationComposer(
                $db: $db,
                $table: $db.routineItemRecords,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> routineRunRecordsRefs<T extends Object>(
    Expression<T> Function($$RoutineRunRecordsTableAnnotationComposer a) f,
  ) {
    final $$RoutineRunRecordsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.routineRunRecords,
          getReferencedColumn: (t) => t.routineId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RoutineRunRecordsTableAnnotationComposer(
                $db: $db,
                $table: $db.routineRunRecords,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$RoutineRecordsTableTableManager
    extends
        RootTableManager<
          _$MichiFocusDatabase,
          $RoutineRecordsTable,
          RoutineRecord,
          $$RoutineRecordsTableFilterComposer,
          $$RoutineRecordsTableOrderingComposer,
          $$RoutineRecordsTableAnnotationComposer,
          $$RoutineRecordsTableCreateCompanionBuilder,
          $$RoutineRecordsTableUpdateCompanionBuilder,
          (RoutineRecord, $$RoutineRecordsTableReferences),
          RoutineRecord,
          PrefetchHooks Function({
            bool routineDayRecordsRefs,
            bool routineItemRecordsRefs,
            bool routineRunRecordsRefs,
          })
        > {
  $$RoutineRecordsTableTableManager(
    _$MichiFocusDatabase db,
    $RoutineRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoutineRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoutineRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoutineRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String> iconKey = const Value.absent(),
                Value<String> colorKey = const Value.absent(),
                Value<int?> customColorArgb = const Value.absent(),
                Value<String?> validFromLocalDate = const Value.absent(),
                Value<String?> validUntilLocalDate = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> pausedUntilLocalDate = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RoutineRecordsCompanion(
                id: id,
                name: name,
                description: description,
                iconKey: iconKey,
                colorKey: colorKey,
                customColorArgb: customColorArgb,
                validFromLocalDate: validFromLocalDate,
                validUntilLocalDate: validUntilLocalDate,
                status: status,
                pausedUntilLocalDate: pausedUntilLocalDate,
                archivedAt: archivedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> description = const Value.absent(),
                Value<String> iconKey = const Value.absent(),
                Value<String> colorKey = const Value.absent(),
                Value<int?> customColorArgb = const Value.absent(),
                Value<String?> validFromLocalDate = const Value.absent(),
                Value<String?> validUntilLocalDate = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> pausedUntilLocalDate = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => RoutineRecordsCompanion.insert(
                id: id,
                name: name,
                description: description,
                iconKey: iconKey,
                colorKey: colorKey,
                customColorArgb: customColorArgb,
                validFromLocalDate: validFromLocalDate,
                validUntilLocalDate: validUntilLocalDate,
                status: status,
                pausedUntilLocalDate: pausedUntilLocalDate,
                archivedAt: archivedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RoutineRecordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                routineDayRecordsRefs = false,
                routineItemRecordsRefs = false,
                routineRunRecordsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (routineDayRecordsRefs) db.routineDayRecords,
                    if (routineItemRecordsRefs) db.routineItemRecords,
                    if (routineRunRecordsRefs) db.routineRunRecords,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (routineDayRecordsRefs)
                        await $_getPrefetchedData<
                          RoutineRecord,
                          $RoutineRecordsTable,
                          RoutineDayRecord
                        >(
                          currentTable: table,
                          referencedTable: $$RoutineRecordsTableReferences
                              ._routineDayRecordsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RoutineRecordsTableReferences(
                                db,
                                table,
                                p0,
                              ).routineDayRecordsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.routineId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (routineItemRecordsRefs)
                        await $_getPrefetchedData<
                          RoutineRecord,
                          $RoutineRecordsTable,
                          RoutineItemRecord
                        >(
                          currentTable: table,
                          referencedTable: $$RoutineRecordsTableReferences
                              ._routineItemRecordsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RoutineRecordsTableReferences(
                                db,
                                table,
                                p0,
                              ).routineItemRecordsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.routineId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (routineRunRecordsRefs)
                        await $_getPrefetchedData<
                          RoutineRecord,
                          $RoutineRecordsTable,
                          RoutineRunRecord
                        >(
                          currentTable: table,
                          referencedTable: $$RoutineRecordsTableReferences
                              ._routineRunRecordsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RoutineRecordsTableReferences(
                                db,
                                table,
                                p0,
                              ).routineRunRecordsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.routineId == item.id,
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

typedef $$RoutineRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$MichiFocusDatabase,
      $RoutineRecordsTable,
      RoutineRecord,
      $$RoutineRecordsTableFilterComposer,
      $$RoutineRecordsTableOrderingComposer,
      $$RoutineRecordsTableAnnotationComposer,
      $$RoutineRecordsTableCreateCompanionBuilder,
      $$RoutineRecordsTableUpdateCompanionBuilder,
      (RoutineRecord, $$RoutineRecordsTableReferences),
      RoutineRecord,
      PrefetchHooks Function({
        bool routineDayRecordsRefs,
        bool routineItemRecordsRefs,
        bool routineRunRecordsRefs,
      })
    >;
typedef $$RoutineDayRecordsTableCreateCompanionBuilder =
    RoutineDayRecordsCompanion Function({
      required String routineId,
      required int weekday,
      Value<int> rowid,
    });
typedef $$RoutineDayRecordsTableUpdateCompanionBuilder =
    RoutineDayRecordsCompanion Function({
      Value<String> routineId,
      Value<int> weekday,
      Value<int> rowid,
    });

final class $$RoutineDayRecordsTableReferences
    extends
        BaseReferences<
          _$MichiFocusDatabase,
          $RoutineDayRecordsTable,
          RoutineDayRecord
        > {
  $$RoutineDayRecordsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $RoutineRecordsTable _routineIdTable(_$MichiFocusDatabase db) =>
      db.routineRecords.createAlias(
        $_aliasNameGenerator(
          db.routineDayRecords.routineId,
          db.routineRecords.id,
        ),
      );

  $$RoutineRecordsTableProcessedTableManager get routineId {
    final $_column = $_itemColumn<String>('routine_id')!;

    final manager = $$RoutineRecordsTableTableManager(
      $_db,
      $_db.routineRecords,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_routineIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RoutineDayRecordsTableFilterComposer
    extends Composer<_$MichiFocusDatabase, $RoutineDayRecordsTable> {
  $$RoutineDayRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get weekday => $composableBuilder(
    column: $table.weekday,
    builder: (column) => ColumnFilters(column),
  );

  $$RoutineRecordsTableFilterComposer get routineId {
    final $$RoutineRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineId,
      referencedTable: $db.routineRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutineRecordsTableFilterComposer(
            $db: $db,
            $table: $db.routineRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RoutineDayRecordsTableOrderingComposer
    extends Composer<_$MichiFocusDatabase, $RoutineDayRecordsTable> {
  $$RoutineDayRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get weekday => $composableBuilder(
    column: $table.weekday,
    builder: (column) => ColumnOrderings(column),
  );

  $$RoutineRecordsTableOrderingComposer get routineId {
    final $$RoutineRecordsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineId,
      referencedTable: $db.routineRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutineRecordsTableOrderingComposer(
            $db: $db,
            $table: $db.routineRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RoutineDayRecordsTableAnnotationComposer
    extends Composer<_$MichiFocusDatabase, $RoutineDayRecordsTable> {
  $$RoutineDayRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get weekday =>
      $composableBuilder(column: $table.weekday, builder: (column) => column);

  $$RoutineRecordsTableAnnotationComposer get routineId {
    final $$RoutineRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineId,
      referencedTable: $db.routineRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutineRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.routineRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RoutineDayRecordsTableTableManager
    extends
        RootTableManager<
          _$MichiFocusDatabase,
          $RoutineDayRecordsTable,
          RoutineDayRecord,
          $$RoutineDayRecordsTableFilterComposer,
          $$RoutineDayRecordsTableOrderingComposer,
          $$RoutineDayRecordsTableAnnotationComposer,
          $$RoutineDayRecordsTableCreateCompanionBuilder,
          $$RoutineDayRecordsTableUpdateCompanionBuilder,
          (RoutineDayRecord, $$RoutineDayRecordsTableReferences),
          RoutineDayRecord,
          PrefetchHooks Function({bool routineId})
        > {
  $$RoutineDayRecordsTableTableManager(
    _$MichiFocusDatabase db,
    $RoutineDayRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoutineDayRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoutineDayRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoutineDayRecordsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> routineId = const Value.absent(),
                Value<int> weekday = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RoutineDayRecordsCompanion(
                routineId: routineId,
                weekday: weekday,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String routineId,
                required int weekday,
                Value<int> rowid = const Value.absent(),
              }) => RoutineDayRecordsCompanion.insert(
                routineId: routineId,
                weekday: weekday,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RoutineDayRecordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({routineId = false}) {
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
                    if (routineId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.routineId,
                                referencedTable:
                                    $$RoutineDayRecordsTableReferences
                                        ._routineIdTable(db),
                                referencedColumn:
                                    $$RoutineDayRecordsTableReferences
                                        ._routineIdTable(db)
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

typedef $$RoutineDayRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$MichiFocusDatabase,
      $RoutineDayRecordsTable,
      RoutineDayRecord,
      $$RoutineDayRecordsTableFilterComposer,
      $$RoutineDayRecordsTableOrderingComposer,
      $$RoutineDayRecordsTableAnnotationComposer,
      $$RoutineDayRecordsTableCreateCompanionBuilder,
      $$RoutineDayRecordsTableUpdateCompanionBuilder,
      (RoutineDayRecord, $$RoutineDayRecordsTableReferences),
      RoutineDayRecord,
      PrefetchHooks Function({bool routineId})
    >;
typedef $$RoutineItemRecordsTableCreateCompanionBuilder =
    RoutineItemRecordsCompanion Function({
      required String id,
      required String routineId,
      required int position,
      required String title,
      required int scheduledMinute,
      required int durationMinutes,
      Value<String?> goalId,
      Value<bool> isOptional,
      Value<int?> reminderMinutesBefore,
      Value<String> pomodoroMode,
      Value<int?> customFocusMinutes,
      Value<int?> customBreakMinutes,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$RoutineItemRecordsTableUpdateCompanionBuilder =
    RoutineItemRecordsCompanion Function({
      Value<String> id,
      Value<String> routineId,
      Value<int> position,
      Value<String> title,
      Value<int> scheduledMinute,
      Value<int> durationMinutes,
      Value<String?> goalId,
      Value<bool> isOptional,
      Value<int?> reminderMinutesBefore,
      Value<String> pomodoroMode,
      Value<int?> customFocusMinutes,
      Value<int?> customBreakMinutes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$RoutineItemRecordsTableReferences
    extends
        BaseReferences<
          _$MichiFocusDatabase,
          $RoutineItemRecordsTable,
          RoutineItemRecord
        > {
  $$RoutineItemRecordsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $RoutineRecordsTable _routineIdTable(_$MichiFocusDatabase db) =>
      db.routineRecords.createAlias(
        $_aliasNameGenerator(
          db.routineItemRecords.routineId,
          db.routineRecords.id,
        ),
      );

  $$RoutineRecordsTableProcessedTableManager get routineId {
    final $_column = $_itemColumn<String>('routine_id')!;

    final manager = $$RoutineRecordsTableTableManager(
      $_db,
      $_db.routineRecords,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_routineIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $GoalRecordsTable _goalIdTable(_$MichiFocusDatabase db) =>
      db.goalRecords.createAlias(
        $_aliasNameGenerator(db.routineItemRecords.goalId, db.goalRecords.id),
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
    $RoutineItemRunRecordsTable,
    List<RoutineItemRunRecord>
  >
  _routineItemRunRecordsRefsTable(_$MichiFocusDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.routineItemRunRecords,
        aliasName: $_aliasNameGenerator(
          db.routineItemRecords.id,
          db.routineItemRunRecords.routineItemId,
        ),
      );

  $$RoutineItemRunRecordsTableProcessedTableManager
  get routineItemRunRecordsRefs {
    final manager = $$RoutineItemRunRecordsTableTableManager(
      $_db,
      $_db.routineItemRunRecords,
    ).filter((f) => f.routineItemId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _routineItemRunRecordsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RoutineItemRecordsTableFilterComposer
    extends Composer<_$MichiFocusDatabase, $RoutineItemRecordsTable> {
  $$RoutineItemRecordsTableFilterComposer({
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

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get scheduledMinute => $composableBuilder(
    column: $table.scheduledMinute,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isOptional => $composableBuilder(
    column: $table.isOptional,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reminderMinutesBefore => $composableBuilder(
    column: $table.reminderMinutesBefore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pomodoroMode => $composableBuilder(
    column: $table.pomodoroMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get customFocusMinutes => $composableBuilder(
    column: $table.customFocusMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get customBreakMinutes => $composableBuilder(
    column: $table.customBreakMinutes,
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

  $$RoutineRecordsTableFilterComposer get routineId {
    final $$RoutineRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineId,
      referencedTable: $db.routineRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutineRecordsTableFilterComposer(
            $db: $db,
            $table: $db.routineRecords,
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

  Expression<bool> routineItemRunRecordsRefs(
    Expression<bool> Function($$RoutineItemRunRecordsTableFilterComposer f) f,
  ) {
    final $$RoutineItemRunRecordsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.routineItemRunRecords,
          getReferencedColumn: (t) => t.routineItemId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RoutineItemRunRecordsTableFilterComposer(
                $db: $db,
                $table: $db.routineItemRunRecords,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$RoutineItemRecordsTableOrderingComposer
    extends Composer<_$MichiFocusDatabase, $RoutineItemRecordsTable> {
  $$RoutineItemRecordsTableOrderingComposer({
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

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get scheduledMinute => $composableBuilder(
    column: $table.scheduledMinute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isOptional => $composableBuilder(
    column: $table.isOptional,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reminderMinutesBefore => $composableBuilder(
    column: $table.reminderMinutesBefore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pomodoroMode => $composableBuilder(
    column: $table.pomodoroMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get customFocusMinutes => $composableBuilder(
    column: $table.customFocusMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get customBreakMinutes => $composableBuilder(
    column: $table.customBreakMinutes,
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

  $$RoutineRecordsTableOrderingComposer get routineId {
    final $$RoutineRecordsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineId,
      referencedTable: $db.routineRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutineRecordsTableOrderingComposer(
            $db: $db,
            $table: $db.routineRecords,
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

class $$RoutineItemRecordsTableAnnotationComposer
    extends Composer<_$MichiFocusDatabase, $RoutineItemRecordsTable> {
  $$RoutineItemRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get scheduledMinute => $composableBuilder(
    column: $table.scheduledMinute,
    builder: (column) => column,
  );

  GeneratedColumn<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isOptional => $composableBuilder(
    column: $table.isOptional,
    builder: (column) => column,
  );

  GeneratedColumn<int> get reminderMinutesBefore => $composableBuilder(
    column: $table.reminderMinutesBefore,
    builder: (column) => column,
  );

  GeneratedColumn<String> get pomodoroMode => $composableBuilder(
    column: $table.pomodoroMode,
    builder: (column) => column,
  );

  GeneratedColumn<int> get customFocusMinutes => $composableBuilder(
    column: $table.customFocusMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get customBreakMinutes => $composableBuilder(
    column: $table.customBreakMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$RoutineRecordsTableAnnotationComposer get routineId {
    final $$RoutineRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineId,
      referencedTable: $db.routineRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutineRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.routineRecords,
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

  Expression<T> routineItemRunRecordsRefs<T extends Object>(
    Expression<T> Function($$RoutineItemRunRecordsTableAnnotationComposer a) f,
  ) {
    final $$RoutineItemRunRecordsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.routineItemRunRecords,
          getReferencedColumn: (t) => t.routineItemId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RoutineItemRunRecordsTableAnnotationComposer(
                $db: $db,
                $table: $db.routineItemRunRecords,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$RoutineItemRecordsTableTableManager
    extends
        RootTableManager<
          _$MichiFocusDatabase,
          $RoutineItemRecordsTable,
          RoutineItemRecord,
          $$RoutineItemRecordsTableFilterComposer,
          $$RoutineItemRecordsTableOrderingComposer,
          $$RoutineItemRecordsTableAnnotationComposer,
          $$RoutineItemRecordsTableCreateCompanionBuilder,
          $$RoutineItemRecordsTableUpdateCompanionBuilder,
          (RoutineItemRecord, $$RoutineItemRecordsTableReferences),
          RoutineItemRecord,
          PrefetchHooks Function({
            bool routineId,
            bool goalId,
            bool routineItemRunRecordsRefs,
          })
        > {
  $$RoutineItemRecordsTableTableManager(
    _$MichiFocusDatabase db,
    $RoutineItemRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoutineItemRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoutineItemRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoutineItemRecordsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> routineId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int> scheduledMinute = const Value.absent(),
                Value<int> durationMinutes = const Value.absent(),
                Value<String?> goalId = const Value.absent(),
                Value<bool> isOptional = const Value.absent(),
                Value<int?> reminderMinutesBefore = const Value.absent(),
                Value<String> pomodoroMode = const Value.absent(),
                Value<int?> customFocusMinutes = const Value.absent(),
                Value<int?> customBreakMinutes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RoutineItemRecordsCompanion(
                id: id,
                routineId: routineId,
                position: position,
                title: title,
                scheduledMinute: scheduledMinute,
                durationMinutes: durationMinutes,
                goalId: goalId,
                isOptional: isOptional,
                reminderMinutesBefore: reminderMinutesBefore,
                pomodoroMode: pomodoroMode,
                customFocusMinutes: customFocusMinutes,
                customBreakMinutes: customBreakMinutes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String routineId,
                required int position,
                required String title,
                required int scheduledMinute,
                required int durationMinutes,
                Value<String?> goalId = const Value.absent(),
                Value<bool> isOptional = const Value.absent(),
                Value<int?> reminderMinutesBefore = const Value.absent(),
                Value<String> pomodoroMode = const Value.absent(),
                Value<int?> customFocusMinutes = const Value.absent(),
                Value<int?> customBreakMinutes = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => RoutineItemRecordsCompanion.insert(
                id: id,
                routineId: routineId,
                position: position,
                title: title,
                scheduledMinute: scheduledMinute,
                durationMinutes: durationMinutes,
                goalId: goalId,
                isOptional: isOptional,
                reminderMinutesBefore: reminderMinutesBefore,
                pomodoroMode: pomodoroMode,
                customFocusMinutes: customFocusMinutes,
                customBreakMinutes: customBreakMinutes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RoutineItemRecordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                routineId = false,
                goalId = false,
                routineItemRunRecordsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (routineItemRunRecordsRefs) db.routineItemRunRecords,
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
                        if (routineId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.routineId,
                                    referencedTable:
                                        $$RoutineItemRecordsTableReferences
                                            ._routineIdTable(db),
                                    referencedColumn:
                                        $$RoutineItemRecordsTableReferences
                                            ._routineIdTable(db)
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
                                        $$RoutineItemRecordsTableReferences
                                            ._goalIdTable(db),
                                    referencedColumn:
                                        $$RoutineItemRecordsTableReferences
                                            ._goalIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (routineItemRunRecordsRefs)
                        await $_getPrefetchedData<
                          RoutineItemRecord,
                          $RoutineItemRecordsTable,
                          RoutineItemRunRecord
                        >(
                          currentTable: table,
                          referencedTable: $$RoutineItemRecordsTableReferences
                              ._routineItemRunRecordsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RoutineItemRecordsTableReferences(
                                db,
                                table,
                                p0,
                              ).routineItemRunRecordsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.routineItemId == item.id,
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

typedef $$RoutineItemRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$MichiFocusDatabase,
      $RoutineItemRecordsTable,
      RoutineItemRecord,
      $$RoutineItemRecordsTableFilterComposer,
      $$RoutineItemRecordsTableOrderingComposer,
      $$RoutineItemRecordsTableAnnotationComposer,
      $$RoutineItemRecordsTableCreateCompanionBuilder,
      $$RoutineItemRecordsTableUpdateCompanionBuilder,
      (RoutineItemRecord, $$RoutineItemRecordsTableReferences),
      RoutineItemRecord,
      PrefetchHooks Function({
        bool routineId,
        bool goalId,
        bool routineItemRunRecordsRefs,
      })
    >;
typedef $$RoutineRunRecordsTableCreateCompanionBuilder =
    RoutineRunRecordsCompanion Function({
      required String id,
      Value<String?> routineId,
      required String sourceRoutineId,
      required String localDate,
      Value<String> status,
      required String nameSnapshot,
      required String iconKeySnapshot,
      required String colorKeySnapshot,
      Value<int?> customColorArgbSnapshot,
      required int scheduledStartMinuteSnapshot,
      Value<DateTime?> startedAt,
      Value<DateTime?> completedAt,
      Value<DateTime?> skippedAt,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$RoutineRunRecordsTableUpdateCompanionBuilder =
    RoutineRunRecordsCompanion Function({
      Value<String> id,
      Value<String?> routineId,
      Value<String> sourceRoutineId,
      Value<String> localDate,
      Value<String> status,
      Value<String> nameSnapshot,
      Value<String> iconKeySnapshot,
      Value<String> colorKeySnapshot,
      Value<int?> customColorArgbSnapshot,
      Value<int> scheduledStartMinuteSnapshot,
      Value<DateTime?> startedAt,
      Value<DateTime?> completedAt,
      Value<DateTime?> skippedAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$RoutineRunRecordsTableReferences
    extends
        BaseReferences<
          _$MichiFocusDatabase,
          $RoutineRunRecordsTable,
          RoutineRunRecord
        > {
  $$RoutineRunRecordsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $RoutineRecordsTable _routineIdTable(_$MichiFocusDatabase db) =>
      db.routineRecords.createAlias(
        $_aliasNameGenerator(
          db.routineRunRecords.routineId,
          db.routineRecords.id,
        ),
      );

  $$RoutineRecordsTableProcessedTableManager? get routineId {
    final $_column = $_itemColumn<String>('routine_id');
    if ($_column == null) return null;
    final manager = $$RoutineRecordsTableTableManager(
      $_db,
      $_db.routineRecords,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_routineIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $RoutineItemRunRecordsTable,
    List<RoutineItemRunRecord>
  >
  _routineItemRunRecordsRefsTable(_$MichiFocusDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.routineItemRunRecords,
        aliasName: $_aliasNameGenerator(
          db.routineRunRecords.id,
          db.routineItemRunRecords.routineRunId,
        ),
      );

  $$RoutineItemRunRecordsTableProcessedTableManager
  get routineItemRunRecordsRefs {
    final manager = $$RoutineItemRunRecordsTableTableManager(
      $_db,
      $_db.routineItemRunRecords,
    ).filter((f) => f.routineRunId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _routineItemRunRecordsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RoutineRunRecordsTableFilterComposer
    extends Composer<_$MichiFocusDatabase, $RoutineRunRecordsTable> {
  $$RoutineRunRecordsTableFilterComposer({
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

  ColumnFilters<String> get sourceRoutineId => $composableBuilder(
    column: $table.sourceRoutineId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localDate => $composableBuilder(
    column: $table.localDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameSnapshot => $composableBuilder(
    column: $table.nameSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get iconKeySnapshot => $composableBuilder(
    column: $table.iconKeySnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get colorKeySnapshot => $composableBuilder(
    column: $table.colorKeySnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get customColorArgbSnapshot => $composableBuilder(
    column: $table.customColorArgbSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get scheduledStartMinuteSnapshot => $composableBuilder(
    column: $table.scheduledStartMinuteSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get skippedAt => $composableBuilder(
    column: $table.skippedAt,
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

  $$RoutineRecordsTableFilterComposer get routineId {
    final $$RoutineRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineId,
      referencedTable: $db.routineRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutineRecordsTableFilterComposer(
            $db: $db,
            $table: $db.routineRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> routineItemRunRecordsRefs(
    Expression<bool> Function($$RoutineItemRunRecordsTableFilterComposer f) f,
  ) {
    final $$RoutineItemRunRecordsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.routineItemRunRecords,
          getReferencedColumn: (t) => t.routineRunId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RoutineItemRunRecordsTableFilterComposer(
                $db: $db,
                $table: $db.routineItemRunRecords,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$RoutineRunRecordsTableOrderingComposer
    extends Composer<_$MichiFocusDatabase, $RoutineRunRecordsTable> {
  $$RoutineRunRecordsTableOrderingComposer({
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

  ColumnOrderings<String> get sourceRoutineId => $composableBuilder(
    column: $table.sourceRoutineId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localDate => $composableBuilder(
    column: $table.localDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameSnapshot => $composableBuilder(
    column: $table.nameSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iconKeySnapshot => $composableBuilder(
    column: $table.iconKeySnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get colorKeySnapshot => $composableBuilder(
    column: $table.colorKeySnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get customColorArgbSnapshot => $composableBuilder(
    column: $table.customColorArgbSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get scheduledStartMinuteSnapshot => $composableBuilder(
    column: $table.scheduledStartMinuteSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get skippedAt => $composableBuilder(
    column: $table.skippedAt,
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

  $$RoutineRecordsTableOrderingComposer get routineId {
    final $$RoutineRecordsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineId,
      referencedTable: $db.routineRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutineRecordsTableOrderingComposer(
            $db: $db,
            $table: $db.routineRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RoutineRunRecordsTableAnnotationComposer
    extends Composer<_$MichiFocusDatabase, $RoutineRunRecordsTable> {
  $$RoutineRunRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sourceRoutineId => $composableBuilder(
    column: $table.sourceRoutineId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get localDate =>
      $composableBuilder(column: $table.localDate, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get nameSnapshot => $composableBuilder(
    column: $table.nameSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<String> get iconKeySnapshot => $composableBuilder(
    column: $table.iconKeySnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<String> get colorKeySnapshot => $composableBuilder(
    column: $table.colorKeySnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<int> get customColorArgbSnapshot => $composableBuilder(
    column: $table.customColorArgbSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<int> get scheduledStartMinuteSnapshot => $composableBuilder(
    column: $table.scheduledStartMinuteSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get skippedAt =>
      $composableBuilder(column: $table.skippedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$RoutineRecordsTableAnnotationComposer get routineId {
    final $$RoutineRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineId,
      referencedTable: $db.routineRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutineRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.routineRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> routineItemRunRecordsRefs<T extends Object>(
    Expression<T> Function($$RoutineItemRunRecordsTableAnnotationComposer a) f,
  ) {
    final $$RoutineItemRunRecordsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.routineItemRunRecords,
          getReferencedColumn: (t) => t.routineRunId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RoutineItemRunRecordsTableAnnotationComposer(
                $db: $db,
                $table: $db.routineItemRunRecords,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$RoutineRunRecordsTableTableManager
    extends
        RootTableManager<
          _$MichiFocusDatabase,
          $RoutineRunRecordsTable,
          RoutineRunRecord,
          $$RoutineRunRecordsTableFilterComposer,
          $$RoutineRunRecordsTableOrderingComposer,
          $$RoutineRunRecordsTableAnnotationComposer,
          $$RoutineRunRecordsTableCreateCompanionBuilder,
          $$RoutineRunRecordsTableUpdateCompanionBuilder,
          (RoutineRunRecord, $$RoutineRunRecordsTableReferences),
          RoutineRunRecord,
          PrefetchHooks Function({
            bool routineId,
            bool routineItemRunRecordsRefs,
          })
        > {
  $$RoutineRunRecordsTableTableManager(
    _$MichiFocusDatabase db,
    $RoutineRunRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoutineRunRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoutineRunRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoutineRunRecordsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> routineId = const Value.absent(),
                Value<String> sourceRoutineId = const Value.absent(),
                Value<String> localDate = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> nameSnapshot = const Value.absent(),
                Value<String> iconKeySnapshot = const Value.absent(),
                Value<String> colorKeySnapshot = const Value.absent(),
                Value<int?> customColorArgbSnapshot = const Value.absent(),
                Value<int> scheduledStartMinuteSnapshot = const Value.absent(),
                Value<DateTime?> startedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<DateTime?> skippedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RoutineRunRecordsCompanion(
                id: id,
                routineId: routineId,
                sourceRoutineId: sourceRoutineId,
                localDate: localDate,
                status: status,
                nameSnapshot: nameSnapshot,
                iconKeySnapshot: iconKeySnapshot,
                colorKeySnapshot: colorKeySnapshot,
                customColorArgbSnapshot: customColorArgbSnapshot,
                scheduledStartMinuteSnapshot: scheduledStartMinuteSnapshot,
                startedAt: startedAt,
                completedAt: completedAt,
                skippedAt: skippedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> routineId = const Value.absent(),
                required String sourceRoutineId,
                required String localDate,
                Value<String> status = const Value.absent(),
                required String nameSnapshot,
                required String iconKeySnapshot,
                required String colorKeySnapshot,
                Value<int?> customColorArgbSnapshot = const Value.absent(),
                required int scheduledStartMinuteSnapshot,
                Value<DateTime?> startedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<DateTime?> skippedAt = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => RoutineRunRecordsCompanion.insert(
                id: id,
                routineId: routineId,
                sourceRoutineId: sourceRoutineId,
                localDate: localDate,
                status: status,
                nameSnapshot: nameSnapshot,
                iconKeySnapshot: iconKeySnapshot,
                colorKeySnapshot: colorKeySnapshot,
                customColorArgbSnapshot: customColorArgbSnapshot,
                scheduledStartMinuteSnapshot: scheduledStartMinuteSnapshot,
                startedAt: startedAt,
                completedAt: completedAt,
                skippedAt: skippedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RoutineRunRecordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({routineId = false, routineItemRunRecordsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (routineItemRunRecordsRefs) db.routineItemRunRecords,
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
                        if (routineId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.routineId,
                                    referencedTable:
                                        $$RoutineRunRecordsTableReferences
                                            ._routineIdTable(db),
                                    referencedColumn:
                                        $$RoutineRunRecordsTableReferences
                                            ._routineIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (routineItemRunRecordsRefs)
                        await $_getPrefetchedData<
                          RoutineRunRecord,
                          $RoutineRunRecordsTable,
                          RoutineItemRunRecord
                        >(
                          currentTable: table,
                          referencedTable: $$RoutineRunRecordsTableReferences
                              ._routineItemRunRecordsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RoutineRunRecordsTableReferences(
                                db,
                                table,
                                p0,
                              ).routineItemRunRecordsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.routineRunId == item.id,
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

typedef $$RoutineRunRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$MichiFocusDatabase,
      $RoutineRunRecordsTable,
      RoutineRunRecord,
      $$RoutineRunRecordsTableFilterComposer,
      $$RoutineRunRecordsTableOrderingComposer,
      $$RoutineRunRecordsTableAnnotationComposer,
      $$RoutineRunRecordsTableCreateCompanionBuilder,
      $$RoutineRunRecordsTableUpdateCompanionBuilder,
      (RoutineRunRecord, $$RoutineRunRecordsTableReferences),
      RoutineRunRecord,
      PrefetchHooks Function({bool routineId, bool routineItemRunRecordsRefs})
    >;
typedef $$RoutineItemRunRecordsTableCreateCompanionBuilder =
    RoutineItemRunRecordsCompanion Function({
      required String id,
      required String routineRunId,
      Value<String?> routineItemId,
      required String sourceItemId,
      Value<String?> taskId,
      Value<String?> taskIdSnapshot,
      required int positionSnapshot,
      required String titleSnapshot,
      required DateTime scheduledAtSnapshot,
      required int durationMinutesSnapshot,
      Value<String?> goalTitleSnapshot,
      Value<bool> isOptionalSnapshot,
      Value<int?> reminderMinutesSnapshot,
      required String pomodoroModeSnapshot,
      Value<int?> customFocusMinutesSnapshot,
      Value<int?> customBreakMinutesSnapshot,
      Value<String> status,
      Value<DateTime?> startedAt,
      Value<DateTime?> completedAt,
      Value<DateTime?> skippedAt,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$RoutineItemRunRecordsTableUpdateCompanionBuilder =
    RoutineItemRunRecordsCompanion Function({
      Value<String> id,
      Value<String> routineRunId,
      Value<String?> routineItemId,
      Value<String> sourceItemId,
      Value<String?> taskId,
      Value<String?> taskIdSnapshot,
      Value<int> positionSnapshot,
      Value<String> titleSnapshot,
      Value<DateTime> scheduledAtSnapshot,
      Value<int> durationMinutesSnapshot,
      Value<String?> goalTitleSnapshot,
      Value<bool> isOptionalSnapshot,
      Value<int?> reminderMinutesSnapshot,
      Value<String> pomodoroModeSnapshot,
      Value<int?> customFocusMinutesSnapshot,
      Value<int?> customBreakMinutesSnapshot,
      Value<String> status,
      Value<DateTime?> startedAt,
      Value<DateTime?> completedAt,
      Value<DateTime?> skippedAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$RoutineItemRunRecordsTableReferences
    extends
        BaseReferences<
          _$MichiFocusDatabase,
          $RoutineItemRunRecordsTable,
          RoutineItemRunRecord
        > {
  $$RoutineItemRunRecordsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $RoutineRunRecordsTable _routineRunIdTable(_$MichiFocusDatabase db) =>
      db.routineRunRecords.createAlias(
        $_aliasNameGenerator(
          db.routineItemRunRecords.routineRunId,
          db.routineRunRecords.id,
        ),
      );

  $$RoutineRunRecordsTableProcessedTableManager get routineRunId {
    final $_column = $_itemColumn<String>('routine_run_id')!;

    final manager = $$RoutineRunRecordsTableTableManager(
      $_db,
      $_db.routineRunRecords,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_routineRunIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $RoutineItemRecordsTable _routineItemIdTable(
    _$MichiFocusDatabase db,
  ) => db.routineItemRecords.createAlias(
    $_aliasNameGenerator(
      db.routineItemRunRecords.routineItemId,
      db.routineItemRecords.id,
    ),
  );

  $$RoutineItemRecordsTableProcessedTableManager? get routineItemId {
    final $_column = $_itemColumn<String>('routine_item_id');
    if ($_column == null) return null;
    final manager = $$RoutineItemRecordsTableTableManager(
      $_db,
      $_db.routineItemRecords,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_routineItemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TaskRecordsTable _taskIdTable(_$MichiFocusDatabase db) =>
      db.taskRecords.createAlias(
        $_aliasNameGenerator(
          db.routineItemRunRecords.taskId,
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

class $$RoutineItemRunRecordsTableFilterComposer
    extends Composer<_$MichiFocusDatabase, $RoutineItemRunRecordsTable> {
  $$RoutineItemRunRecordsTableFilterComposer({
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

  ColumnFilters<String> get sourceItemId => $composableBuilder(
    column: $table.sourceItemId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get taskIdSnapshot => $composableBuilder(
    column: $table.taskIdSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get positionSnapshot => $composableBuilder(
    column: $table.positionSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get titleSnapshot => $composableBuilder(
    column: $table.titleSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get scheduledAtSnapshot => $composableBuilder(
    column: $table.scheduledAtSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMinutesSnapshot => $composableBuilder(
    column: $table.durationMinutesSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get goalTitleSnapshot => $composableBuilder(
    column: $table.goalTitleSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isOptionalSnapshot => $composableBuilder(
    column: $table.isOptionalSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reminderMinutesSnapshot => $composableBuilder(
    column: $table.reminderMinutesSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pomodoroModeSnapshot => $composableBuilder(
    column: $table.pomodoroModeSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get customFocusMinutesSnapshot => $composableBuilder(
    column: $table.customFocusMinutesSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get customBreakMinutesSnapshot => $composableBuilder(
    column: $table.customBreakMinutesSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get skippedAt => $composableBuilder(
    column: $table.skippedAt,
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

  $$RoutineRunRecordsTableFilterComposer get routineRunId {
    final $$RoutineRunRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineRunId,
      referencedTable: $db.routineRunRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutineRunRecordsTableFilterComposer(
            $db: $db,
            $table: $db.routineRunRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RoutineItemRecordsTableFilterComposer get routineItemId {
    final $$RoutineItemRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineItemId,
      referencedTable: $db.routineItemRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutineItemRecordsTableFilterComposer(
            $db: $db,
            $table: $db.routineItemRecords,
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

class $$RoutineItemRunRecordsTableOrderingComposer
    extends Composer<_$MichiFocusDatabase, $RoutineItemRunRecordsTable> {
  $$RoutineItemRunRecordsTableOrderingComposer({
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

  ColumnOrderings<String> get sourceItemId => $composableBuilder(
    column: $table.sourceItemId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get taskIdSnapshot => $composableBuilder(
    column: $table.taskIdSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get positionSnapshot => $composableBuilder(
    column: $table.positionSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titleSnapshot => $composableBuilder(
    column: $table.titleSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get scheduledAtSnapshot => $composableBuilder(
    column: $table.scheduledAtSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMinutesSnapshot => $composableBuilder(
    column: $table.durationMinutesSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get goalTitleSnapshot => $composableBuilder(
    column: $table.goalTitleSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isOptionalSnapshot => $composableBuilder(
    column: $table.isOptionalSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reminderMinutesSnapshot => $composableBuilder(
    column: $table.reminderMinutesSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pomodoroModeSnapshot => $composableBuilder(
    column: $table.pomodoroModeSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get customFocusMinutesSnapshot => $composableBuilder(
    column: $table.customFocusMinutesSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get customBreakMinutesSnapshot => $composableBuilder(
    column: $table.customBreakMinutesSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get skippedAt => $composableBuilder(
    column: $table.skippedAt,
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

  $$RoutineRunRecordsTableOrderingComposer get routineRunId {
    final $$RoutineRunRecordsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineRunId,
      referencedTable: $db.routineRunRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutineRunRecordsTableOrderingComposer(
            $db: $db,
            $table: $db.routineRunRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RoutineItemRecordsTableOrderingComposer get routineItemId {
    final $$RoutineItemRecordsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineItemId,
      referencedTable: $db.routineItemRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutineItemRecordsTableOrderingComposer(
            $db: $db,
            $table: $db.routineItemRecords,
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

class $$RoutineItemRunRecordsTableAnnotationComposer
    extends Composer<_$MichiFocusDatabase, $RoutineItemRunRecordsTable> {
  $$RoutineItemRunRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sourceItemId => $composableBuilder(
    column: $table.sourceItemId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get taskIdSnapshot => $composableBuilder(
    column: $table.taskIdSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<int> get positionSnapshot => $composableBuilder(
    column: $table.positionSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<String> get titleSnapshot => $composableBuilder(
    column: $table.titleSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get scheduledAtSnapshot => $composableBuilder(
    column: $table.scheduledAtSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<int> get durationMinutesSnapshot => $composableBuilder(
    column: $table.durationMinutesSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<String> get goalTitleSnapshot => $composableBuilder(
    column: $table.goalTitleSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isOptionalSnapshot => $composableBuilder(
    column: $table.isOptionalSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<int> get reminderMinutesSnapshot => $composableBuilder(
    column: $table.reminderMinutesSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<String> get pomodoroModeSnapshot => $composableBuilder(
    column: $table.pomodoroModeSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<int> get customFocusMinutesSnapshot => $composableBuilder(
    column: $table.customFocusMinutesSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<int> get customBreakMinutesSnapshot => $composableBuilder(
    column: $table.customBreakMinutesSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get skippedAt =>
      $composableBuilder(column: $table.skippedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$RoutineRunRecordsTableAnnotationComposer get routineRunId {
    final $$RoutineRunRecordsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.routineRunId,
          referencedTable: $db.routineRunRecords,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RoutineRunRecordsTableAnnotationComposer(
                $db: $db,
                $table: $db.routineRunRecords,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$RoutineItemRecordsTableAnnotationComposer get routineItemId {
    final $$RoutineItemRecordsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.routineItemId,
          referencedTable: $db.routineItemRecords,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RoutineItemRecordsTableAnnotationComposer(
                $db: $db,
                $table: $db.routineItemRecords,
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

class $$RoutineItemRunRecordsTableTableManager
    extends
        RootTableManager<
          _$MichiFocusDatabase,
          $RoutineItemRunRecordsTable,
          RoutineItemRunRecord,
          $$RoutineItemRunRecordsTableFilterComposer,
          $$RoutineItemRunRecordsTableOrderingComposer,
          $$RoutineItemRunRecordsTableAnnotationComposer,
          $$RoutineItemRunRecordsTableCreateCompanionBuilder,
          $$RoutineItemRunRecordsTableUpdateCompanionBuilder,
          (RoutineItemRunRecord, $$RoutineItemRunRecordsTableReferences),
          RoutineItemRunRecord,
          PrefetchHooks Function({
            bool routineRunId,
            bool routineItemId,
            bool taskId,
          })
        > {
  $$RoutineItemRunRecordsTableTableManager(
    _$MichiFocusDatabase db,
    $RoutineItemRunRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoutineItemRunRecordsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$RoutineItemRunRecordsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$RoutineItemRunRecordsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> routineRunId = const Value.absent(),
                Value<String?> routineItemId = const Value.absent(),
                Value<String> sourceItemId = const Value.absent(),
                Value<String?> taskId = const Value.absent(),
                Value<String?> taskIdSnapshot = const Value.absent(),
                Value<int> positionSnapshot = const Value.absent(),
                Value<String> titleSnapshot = const Value.absent(),
                Value<DateTime> scheduledAtSnapshot = const Value.absent(),
                Value<int> durationMinutesSnapshot = const Value.absent(),
                Value<String?> goalTitleSnapshot = const Value.absent(),
                Value<bool> isOptionalSnapshot = const Value.absent(),
                Value<int?> reminderMinutesSnapshot = const Value.absent(),
                Value<String> pomodoroModeSnapshot = const Value.absent(),
                Value<int?> customFocusMinutesSnapshot = const Value.absent(),
                Value<int?> customBreakMinutesSnapshot = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime?> startedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<DateTime?> skippedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RoutineItemRunRecordsCompanion(
                id: id,
                routineRunId: routineRunId,
                routineItemId: routineItemId,
                sourceItemId: sourceItemId,
                taskId: taskId,
                taskIdSnapshot: taskIdSnapshot,
                positionSnapshot: positionSnapshot,
                titleSnapshot: titleSnapshot,
                scheduledAtSnapshot: scheduledAtSnapshot,
                durationMinutesSnapshot: durationMinutesSnapshot,
                goalTitleSnapshot: goalTitleSnapshot,
                isOptionalSnapshot: isOptionalSnapshot,
                reminderMinutesSnapshot: reminderMinutesSnapshot,
                pomodoroModeSnapshot: pomodoroModeSnapshot,
                customFocusMinutesSnapshot: customFocusMinutesSnapshot,
                customBreakMinutesSnapshot: customBreakMinutesSnapshot,
                status: status,
                startedAt: startedAt,
                completedAt: completedAt,
                skippedAt: skippedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String routineRunId,
                Value<String?> routineItemId = const Value.absent(),
                required String sourceItemId,
                Value<String?> taskId = const Value.absent(),
                Value<String?> taskIdSnapshot = const Value.absent(),
                required int positionSnapshot,
                required String titleSnapshot,
                required DateTime scheduledAtSnapshot,
                required int durationMinutesSnapshot,
                Value<String?> goalTitleSnapshot = const Value.absent(),
                Value<bool> isOptionalSnapshot = const Value.absent(),
                Value<int?> reminderMinutesSnapshot = const Value.absent(),
                required String pomodoroModeSnapshot,
                Value<int?> customFocusMinutesSnapshot = const Value.absent(),
                Value<int?> customBreakMinutesSnapshot = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime?> startedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<DateTime?> skippedAt = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => RoutineItemRunRecordsCompanion.insert(
                id: id,
                routineRunId: routineRunId,
                routineItemId: routineItemId,
                sourceItemId: sourceItemId,
                taskId: taskId,
                taskIdSnapshot: taskIdSnapshot,
                positionSnapshot: positionSnapshot,
                titleSnapshot: titleSnapshot,
                scheduledAtSnapshot: scheduledAtSnapshot,
                durationMinutesSnapshot: durationMinutesSnapshot,
                goalTitleSnapshot: goalTitleSnapshot,
                isOptionalSnapshot: isOptionalSnapshot,
                reminderMinutesSnapshot: reminderMinutesSnapshot,
                pomodoroModeSnapshot: pomodoroModeSnapshot,
                customFocusMinutesSnapshot: customFocusMinutesSnapshot,
                customBreakMinutesSnapshot: customBreakMinutesSnapshot,
                status: status,
                startedAt: startedAt,
                completedAt: completedAt,
                skippedAt: skippedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RoutineItemRunRecordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({routineRunId = false, routineItemId = false, taskId = false}) {
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
                        if (routineRunId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.routineRunId,
                                    referencedTable:
                                        $$RoutineItemRunRecordsTableReferences
                                            ._routineRunIdTable(db),
                                    referencedColumn:
                                        $$RoutineItemRunRecordsTableReferences
                                            ._routineRunIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (routineItemId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.routineItemId,
                                    referencedTable:
                                        $$RoutineItemRunRecordsTableReferences
                                            ._routineItemIdTable(db),
                                    referencedColumn:
                                        $$RoutineItemRunRecordsTableReferences
                                            ._routineItemIdTable(db)
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
                                        $$RoutineItemRunRecordsTableReferences
                                            ._taskIdTable(db),
                                    referencedColumn:
                                        $$RoutineItemRunRecordsTableReferences
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

typedef $$RoutineItemRunRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$MichiFocusDatabase,
      $RoutineItemRunRecordsTable,
      RoutineItemRunRecord,
      $$RoutineItemRunRecordsTableFilterComposer,
      $$RoutineItemRunRecordsTableOrderingComposer,
      $$RoutineItemRunRecordsTableAnnotationComposer,
      $$RoutineItemRunRecordsTableCreateCompanionBuilder,
      $$RoutineItemRunRecordsTableUpdateCompanionBuilder,
      (RoutineItemRunRecord, $$RoutineItemRunRecordsTableReferences),
      RoutineItemRunRecord,
      PrefetchHooks Function({
        bool routineRunId,
        bool routineItemId,
        bool taskId,
      })
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
typedef $$QuickNoteRecordsTableCreateCompanionBuilder =
    QuickNoteRecordsCompanion Function({
      required String id,
      required String textContent,
      Value<bool> isCompleted,
      required int colorArgb,
      Value<String?> localDate,
      Value<String?> priority,
      required int position,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$QuickNoteRecordsTableUpdateCompanionBuilder =
    QuickNoteRecordsCompanion Function({
      Value<String> id,
      Value<String> textContent,
      Value<bool> isCompleted,
      Value<int> colorArgb,
      Value<String?> localDate,
      Value<String?> priority,
      Value<int> position,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$QuickNoteRecordsTableFilterComposer
    extends Composer<_$MichiFocusDatabase, $QuickNoteRecordsTable> {
  $$QuickNoteRecordsTableFilterComposer({
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

  ColumnFilters<String> get textContent => $composableBuilder(
    column: $table.textContent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get colorArgb => $composableBuilder(
    column: $table.colorArgb,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localDate => $composableBuilder(
    column: $table.localDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
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
}

class $$QuickNoteRecordsTableOrderingComposer
    extends Composer<_$MichiFocusDatabase, $QuickNoteRecordsTable> {
  $$QuickNoteRecordsTableOrderingComposer({
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

  ColumnOrderings<String> get textContent => $composableBuilder(
    column: $table.textContent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get colorArgb => $composableBuilder(
    column: $table.colorArgb,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localDate => $composableBuilder(
    column: $table.localDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
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

class $$QuickNoteRecordsTableAnnotationComposer
    extends Composer<_$MichiFocusDatabase, $QuickNoteRecordsTable> {
  $$QuickNoteRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get textContent => $composableBuilder(
    column: $table.textContent,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<int> get colorArgb =>
      $composableBuilder(column: $table.colorArgb, builder: (column) => column);

  GeneratedColumn<String> get localDate =>
      $composableBuilder(column: $table.localDate, builder: (column) => column);

  GeneratedColumn<String> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$QuickNoteRecordsTableTableManager
    extends
        RootTableManager<
          _$MichiFocusDatabase,
          $QuickNoteRecordsTable,
          QuickNoteRecord,
          $$QuickNoteRecordsTableFilterComposer,
          $$QuickNoteRecordsTableOrderingComposer,
          $$QuickNoteRecordsTableAnnotationComposer,
          $$QuickNoteRecordsTableCreateCompanionBuilder,
          $$QuickNoteRecordsTableUpdateCompanionBuilder,
          (
            QuickNoteRecord,
            BaseReferences<
              _$MichiFocusDatabase,
              $QuickNoteRecordsTable,
              QuickNoteRecord
            >,
          ),
          QuickNoteRecord,
          PrefetchHooks Function()
        > {
  $$QuickNoteRecordsTableTableManager(
    _$MichiFocusDatabase db,
    $QuickNoteRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuickNoteRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuickNoteRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuickNoteRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> textContent = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<int> colorArgb = const Value.absent(),
                Value<String?> localDate = const Value.absent(),
                Value<String?> priority = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuickNoteRecordsCompanion(
                id: id,
                textContent: textContent,
                isCompleted: isCompleted,
                colorArgb: colorArgb,
                localDate: localDate,
                priority: priority,
                position: position,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String textContent,
                Value<bool> isCompleted = const Value.absent(),
                required int colorArgb,
                Value<String?> localDate = const Value.absent(),
                Value<String?> priority = const Value.absent(),
                required int position,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => QuickNoteRecordsCompanion.insert(
                id: id,
                textContent: textContent,
                isCompleted: isCompleted,
                colorArgb: colorArgb,
                localDate: localDate,
                priority: priority,
                position: position,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$QuickNoteRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$MichiFocusDatabase,
      $QuickNoteRecordsTable,
      QuickNoteRecord,
      $$QuickNoteRecordsTableFilterComposer,
      $$QuickNoteRecordsTableOrderingComposer,
      $$QuickNoteRecordsTableAnnotationComposer,
      $$QuickNoteRecordsTableCreateCompanionBuilder,
      $$QuickNoteRecordsTableUpdateCompanionBuilder,
      (
        QuickNoteRecord,
        BaseReferences<
          _$MichiFocusDatabase,
          $QuickNoteRecordsTable,
          QuickNoteRecord
        >,
      ),
      QuickNoteRecord,
      PrefetchHooks Function()
    >;
typedef $$SyncLocalStateRecordsTableCreateCompanionBuilder =
    SyncLocalStateRecordsCompanion Function({
      required String groupId,
      required String installationId,
      required int protocolVersion,
      Value<int> logicalCounter,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$SyncLocalStateRecordsTableUpdateCompanionBuilder =
    SyncLocalStateRecordsCompanion Function({
      Value<String> groupId,
      Value<String> installationId,
      Value<int> protocolVersion,
      Value<int> logicalCounter,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$SyncLocalStateRecordsTableFilterComposer
    extends Composer<_$MichiFocusDatabase, $SyncLocalStateRecordsTable> {
  $$SyncLocalStateRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get groupId => $composableBuilder(
    column: $table.groupId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get installationId => $composableBuilder(
    column: $table.installationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get protocolVersion => $composableBuilder(
    column: $table.protocolVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get logicalCounter => $composableBuilder(
    column: $table.logicalCounter,
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
}

class $$SyncLocalStateRecordsTableOrderingComposer
    extends Composer<_$MichiFocusDatabase, $SyncLocalStateRecordsTable> {
  $$SyncLocalStateRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get groupId => $composableBuilder(
    column: $table.groupId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get installationId => $composableBuilder(
    column: $table.installationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get protocolVersion => $composableBuilder(
    column: $table.protocolVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get logicalCounter => $composableBuilder(
    column: $table.logicalCounter,
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

class $$SyncLocalStateRecordsTableAnnotationComposer
    extends Composer<_$MichiFocusDatabase, $SyncLocalStateRecordsTable> {
  $$SyncLocalStateRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get groupId =>
      $composableBuilder(column: $table.groupId, builder: (column) => column);

  GeneratedColumn<String> get installationId => $composableBuilder(
    column: $table.installationId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get protocolVersion => $composableBuilder(
    column: $table.protocolVersion,
    builder: (column) => column,
  );

  GeneratedColumn<int> get logicalCounter => $composableBuilder(
    column: $table.logicalCounter,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SyncLocalStateRecordsTableTableManager
    extends
        RootTableManager<
          _$MichiFocusDatabase,
          $SyncLocalStateRecordsTable,
          SyncLocalStateRecord,
          $$SyncLocalStateRecordsTableFilterComposer,
          $$SyncLocalStateRecordsTableOrderingComposer,
          $$SyncLocalStateRecordsTableAnnotationComposer,
          $$SyncLocalStateRecordsTableCreateCompanionBuilder,
          $$SyncLocalStateRecordsTableUpdateCompanionBuilder,
          (
            SyncLocalStateRecord,
            BaseReferences<
              _$MichiFocusDatabase,
              $SyncLocalStateRecordsTable,
              SyncLocalStateRecord
            >,
          ),
          SyncLocalStateRecord,
          PrefetchHooks Function()
        > {
  $$SyncLocalStateRecordsTableTableManager(
    _$MichiFocusDatabase db,
    $SyncLocalStateRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncLocalStateRecordsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$SyncLocalStateRecordsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$SyncLocalStateRecordsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> groupId = const Value.absent(),
                Value<String> installationId = const Value.absent(),
                Value<int> protocolVersion = const Value.absent(),
                Value<int> logicalCounter = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncLocalStateRecordsCompanion(
                groupId: groupId,
                installationId: installationId,
                protocolVersion: protocolVersion,
                logicalCounter: logicalCounter,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String groupId,
                required String installationId,
                required int protocolVersion,
                Value<int> logicalCounter = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => SyncLocalStateRecordsCompanion.insert(
                groupId: groupId,
                installationId: installationId,
                protocolVersion: protocolVersion,
                logicalCounter: logicalCounter,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncLocalStateRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$MichiFocusDatabase,
      $SyncLocalStateRecordsTable,
      SyncLocalStateRecord,
      $$SyncLocalStateRecordsTableFilterComposer,
      $$SyncLocalStateRecordsTableOrderingComposer,
      $$SyncLocalStateRecordsTableAnnotationComposer,
      $$SyncLocalStateRecordsTableCreateCompanionBuilder,
      $$SyncLocalStateRecordsTableUpdateCompanionBuilder,
      (
        SyncLocalStateRecord,
        BaseReferences<
          _$MichiFocusDatabase,
          $SyncLocalStateRecordsTable,
          SyncLocalStateRecord
        >,
      ),
      SyncLocalStateRecord,
      PrefetchHooks Function()
    >;
typedef $$SyncOutboxRecordsTableCreateCompanionBuilder =
    SyncOutboxRecordsCompanion Function({
      required String operationId,
      required String groupId,
      required String originDeviceId,
      required int originCounter,
      required String entityType,
      required String entityId,
      required String parentVersionJson,
      required String changedFieldsJson,
      Value<String> originDeviceName,
      Value<String?> entitySnapshotJson,
      required String operationKind,
      required int protocolVersion,
      required String payloadSha256,
      Value<String> publicationState,
      Value<int> publicationAttempts,
      required DateTime createdAt,
      Value<DateTime?> publishedAt,
      Value<int> rowid,
    });
typedef $$SyncOutboxRecordsTableUpdateCompanionBuilder =
    SyncOutboxRecordsCompanion Function({
      Value<String> operationId,
      Value<String> groupId,
      Value<String> originDeviceId,
      Value<int> originCounter,
      Value<String> entityType,
      Value<String> entityId,
      Value<String> parentVersionJson,
      Value<String> changedFieldsJson,
      Value<String> originDeviceName,
      Value<String?> entitySnapshotJson,
      Value<String> operationKind,
      Value<int> protocolVersion,
      Value<String> payloadSha256,
      Value<String> publicationState,
      Value<int> publicationAttempts,
      Value<DateTime> createdAt,
      Value<DateTime?> publishedAt,
      Value<int> rowid,
    });

class $$SyncOutboxRecordsTableFilterComposer
    extends Composer<_$MichiFocusDatabase, $SyncOutboxRecordsTable> {
  $$SyncOutboxRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get operationId => $composableBuilder(
    column: $table.operationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get groupId => $composableBuilder(
    column: $table.groupId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originDeviceId => $composableBuilder(
    column: $table.originDeviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get originCounter => $composableBuilder(
    column: $table.originCounter,
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

  ColumnFilters<String> get parentVersionJson => $composableBuilder(
    column: $table.parentVersionJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get changedFieldsJson => $composableBuilder(
    column: $table.changedFieldsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originDeviceName => $composableBuilder(
    column: $table.originDeviceName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entitySnapshotJson => $composableBuilder(
    column: $table.entitySnapshotJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operationKind => $composableBuilder(
    column: $table.operationKind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get protocolVersion => $composableBuilder(
    column: $table.protocolVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadSha256 => $composableBuilder(
    column: $table.payloadSha256,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get publicationState => $composableBuilder(
    column: $table.publicationState,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get publicationAttempts => $composableBuilder(
    column: $table.publicationAttempts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get publishedAt => $composableBuilder(
    column: $table.publishedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncOutboxRecordsTableOrderingComposer
    extends Composer<_$MichiFocusDatabase, $SyncOutboxRecordsTable> {
  $$SyncOutboxRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get operationId => $composableBuilder(
    column: $table.operationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get groupId => $composableBuilder(
    column: $table.groupId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originDeviceId => $composableBuilder(
    column: $table.originDeviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get originCounter => $composableBuilder(
    column: $table.originCounter,
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

  ColumnOrderings<String> get parentVersionJson => $composableBuilder(
    column: $table.parentVersionJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get changedFieldsJson => $composableBuilder(
    column: $table.changedFieldsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originDeviceName => $composableBuilder(
    column: $table.originDeviceName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entitySnapshotJson => $composableBuilder(
    column: $table.entitySnapshotJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operationKind => $composableBuilder(
    column: $table.operationKind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get protocolVersion => $composableBuilder(
    column: $table.protocolVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadSha256 => $composableBuilder(
    column: $table.payloadSha256,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get publicationState => $composableBuilder(
    column: $table.publicationState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get publicationAttempts => $composableBuilder(
    column: $table.publicationAttempts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get publishedAt => $composableBuilder(
    column: $table.publishedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncOutboxRecordsTableAnnotationComposer
    extends Composer<_$MichiFocusDatabase, $SyncOutboxRecordsTable> {
  $$SyncOutboxRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get operationId => $composableBuilder(
    column: $table.operationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get groupId =>
      $composableBuilder(column: $table.groupId, builder: (column) => column);

  GeneratedColumn<String> get originDeviceId => $composableBuilder(
    column: $table.originDeviceId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get originCounter => $composableBuilder(
    column: $table.originCounter,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get parentVersionJson => $composableBuilder(
    column: $table.parentVersionJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get changedFieldsJson => $composableBuilder(
    column: $table.changedFieldsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get originDeviceName => $composableBuilder(
    column: $table.originDeviceName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entitySnapshotJson => $composableBuilder(
    column: $table.entitySnapshotJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get operationKind => $composableBuilder(
    column: $table.operationKind,
    builder: (column) => column,
  );

  GeneratedColumn<int> get protocolVersion => $composableBuilder(
    column: $table.protocolVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payloadSha256 => $composableBuilder(
    column: $table.payloadSha256,
    builder: (column) => column,
  );

  GeneratedColumn<String> get publicationState => $composableBuilder(
    column: $table.publicationState,
    builder: (column) => column,
  );

  GeneratedColumn<int> get publicationAttempts => $composableBuilder(
    column: $table.publicationAttempts,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get publishedAt => $composableBuilder(
    column: $table.publishedAt,
    builder: (column) => column,
  );
}

class $$SyncOutboxRecordsTableTableManager
    extends
        RootTableManager<
          _$MichiFocusDatabase,
          $SyncOutboxRecordsTable,
          SyncOutboxRecord,
          $$SyncOutboxRecordsTableFilterComposer,
          $$SyncOutboxRecordsTableOrderingComposer,
          $$SyncOutboxRecordsTableAnnotationComposer,
          $$SyncOutboxRecordsTableCreateCompanionBuilder,
          $$SyncOutboxRecordsTableUpdateCompanionBuilder,
          (
            SyncOutboxRecord,
            BaseReferences<
              _$MichiFocusDatabase,
              $SyncOutboxRecordsTable,
              SyncOutboxRecord
            >,
          ),
          SyncOutboxRecord,
          PrefetchHooks Function()
        > {
  $$SyncOutboxRecordsTableTableManager(
    _$MichiFocusDatabase db,
    $SyncOutboxRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncOutboxRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncOutboxRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncOutboxRecordsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> operationId = const Value.absent(),
                Value<String> groupId = const Value.absent(),
                Value<String> originDeviceId = const Value.absent(),
                Value<int> originCounter = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String> parentVersionJson = const Value.absent(),
                Value<String> changedFieldsJson = const Value.absent(),
                Value<String> originDeviceName = const Value.absent(),
                Value<String?> entitySnapshotJson = const Value.absent(),
                Value<String> operationKind = const Value.absent(),
                Value<int> protocolVersion = const Value.absent(),
                Value<String> payloadSha256 = const Value.absent(),
                Value<String> publicationState = const Value.absent(),
                Value<int> publicationAttempts = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> publishedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncOutboxRecordsCompanion(
                operationId: operationId,
                groupId: groupId,
                originDeviceId: originDeviceId,
                originCounter: originCounter,
                entityType: entityType,
                entityId: entityId,
                parentVersionJson: parentVersionJson,
                changedFieldsJson: changedFieldsJson,
                originDeviceName: originDeviceName,
                entitySnapshotJson: entitySnapshotJson,
                operationKind: operationKind,
                protocolVersion: protocolVersion,
                payloadSha256: payloadSha256,
                publicationState: publicationState,
                publicationAttempts: publicationAttempts,
                createdAt: createdAt,
                publishedAt: publishedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String operationId,
                required String groupId,
                required String originDeviceId,
                required int originCounter,
                required String entityType,
                required String entityId,
                required String parentVersionJson,
                required String changedFieldsJson,
                Value<String> originDeviceName = const Value.absent(),
                Value<String?> entitySnapshotJson = const Value.absent(),
                required String operationKind,
                required int protocolVersion,
                required String payloadSha256,
                Value<String> publicationState = const Value.absent(),
                Value<int> publicationAttempts = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime?> publishedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncOutboxRecordsCompanion.insert(
                operationId: operationId,
                groupId: groupId,
                originDeviceId: originDeviceId,
                originCounter: originCounter,
                entityType: entityType,
                entityId: entityId,
                parentVersionJson: parentVersionJson,
                changedFieldsJson: changedFieldsJson,
                originDeviceName: originDeviceName,
                entitySnapshotJson: entitySnapshotJson,
                operationKind: operationKind,
                protocolVersion: protocolVersion,
                payloadSha256: payloadSha256,
                publicationState: publicationState,
                publicationAttempts: publicationAttempts,
                createdAt: createdAt,
                publishedAt: publishedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncOutboxRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$MichiFocusDatabase,
      $SyncOutboxRecordsTable,
      SyncOutboxRecord,
      $$SyncOutboxRecordsTableFilterComposer,
      $$SyncOutboxRecordsTableOrderingComposer,
      $$SyncOutboxRecordsTableAnnotationComposer,
      $$SyncOutboxRecordsTableCreateCompanionBuilder,
      $$SyncOutboxRecordsTableUpdateCompanionBuilder,
      (
        SyncOutboxRecord,
        BaseReferences<
          _$MichiFocusDatabase,
          $SyncOutboxRecordsTable,
          SyncOutboxRecord
        >,
      ),
      SyncOutboxRecord,
      PrefetchHooks Function()
    >;
typedef $$SyncAppliedOperationRecordsTableCreateCompanionBuilder =
    SyncAppliedOperationRecordsCompanion Function({
      required String operationId,
      required String groupId,
      required String originDeviceId,
      required int originCounter,
      required String payloadSha256,
      required DateTime appliedAt,
      Value<int> rowid,
    });
typedef $$SyncAppliedOperationRecordsTableUpdateCompanionBuilder =
    SyncAppliedOperationRecordsCompanion Function({
      Value<String> operationId,
      Value<String> groupId,
      Value<String> originDeviceId,
      Value<int> originCounter,
      Value<String> payloadSha256,
      Value<DateTime> appliedAt,
      Value<int> rowid,
    });

class $$SyncAppliedOperationRecordsTableFilterComposer
    extends Composer<_$MichiFocusDatabase, $SyncAppliedOperationRecordsTable> {
  $$SyncAppliedOperationRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get operationId => $composableBuilder(
    column: $table.operationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get groupId => $composableBuilder(
    column: $table.groupId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originDeviceId => $composableBuilder(
    column: $table.originDeviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get originCounter => $composableBuilder(
    column: $table.originCounter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadSha256 => $composableBuilder(
    column: $table.payloadSha256,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get appliedAt => $composableBuilder(
    column: $table.appliedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncAppliedOperationRecordsTableOrderingComposer
    extends Composer<_$MichiFocusDatabase, $SyncAppliedOperationRecordsTable> {
  $$SyncAppliedOperationRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get operationId => $composableBuilder(
    column: $table.operationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get groupId => $composableBuilder(
    column: $table.groupId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originDeviceId => $composableBuilder(
    column: $table.originDeviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get originCounter => $composableBuilder(
    column: $table.originCounter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadSha256 => $composableBuilder(
    column: $table.payloadSha256,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get appliedAt => $composableBuilder(
    column: $table.appliedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncAppliedOperationRecordsTableAnnotationComposer
    extends Composer<_$MichiFocusDatabase, $SyncAppliedOperationRecordsTable> {
  $$SyncAppliedOperationRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get operationId => $composableBuilder(
    column: $table.operationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get groupId =>
      $composableBuilder(column: $table.groupId, builder: (column) => column);

  GeneratedColumn<String> get originDeviceId => $composableBuilder(
    column: $table.originDeviceId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get originCounter => $composableBuilder(
    column: $table.originCounter,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payloadSha256 => $composableBuilder(
    column: $table.payloadSha256,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get appliedAt =>
      $composableBuilder(column: $table.appliedAt, builder: (column) => column);
}

class $$SyncAppliedOperationRecordsTableTableManager
    extends
        RootTableManager<
          _$MichiFocusDatabase,
          $SyncAppliedOperationRecordsTable,
          SyncAppliedOperationRecord,
          $$SyncAppliedOperationRecordsTableFilterComposer,
          $$SyncAppliedOperationRecordsTableOrderingComposer,
          $$SyncAppliedOperationRecordsTableAnnotationComposer,
          $$SyncAppliedOperationRecordsTableCreateCompanionBuilder,
          $$SyncAppliedOperationRecordsTableUpdateCompanionBuilder,
          (
            SyncAppliedOperationRecord,
            BaseReferences<
              _$MichiFocusDatabase,
              $SyncAppliedOperationRecordsTable,
              SyncAppliedOperationRecord
            >,
          ),
          SyncAppliedOperationRecord,
          PrefetchHooks Function()
        > {
  $$SyncAppliedOperationRecordsTableTableManager(
    _$MichiFocusDatabase db,
    $SyncAppliedOperationRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncAppliedOperationRecordsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$SyncAppliedOperationRecordsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$SyncAppliedOperationRecordsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> operationId = const Value.absent(),
                Value<String> groupId = const Value.absent(),
                Value<String> originDeviceId = const Value.absent(),
                Value<int> originCounter = const Value.absent(),
                Value<String> payloadSha256 = const Value.absent(),
                Value<DateTime> appliedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncAppliedOperationRecordsCompanion(
                operationId: operationId,
                groupId: groupId,
                originDeviceId: originDeviceId,
                originCounter: originCounter,
                payloadSha256: payloadSha256,
                appliedAt: appliedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String operationId,
                required String groupId,
                required String originDeviceId,
                required int originCounter,
                required String payloadSha256,
                required DateTime appliedAt,
                Value<int> rowid = const Value.absent(),
              }) => SyncAppliedOperationRecordsCompanion.insert(
                operationId: operationId,
                groupId: groupId,
                originDeviceId: originDeviceId,
                originCounter: originCounter,
                payloadSha256: payloadSha256,
                appliedAt: appliedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncAppliedOperationRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$MichiFocusDatabase,
      $SyncAppliedOperationRecordsTable,
      SyncAppliedOperationRecord,
      $$SyncAppliedOperationRecordsTableFilterComposer,
      $$SyncAppliedOperationRecordsTableOrderingComposer,
      $$SyncAppliedOperationRecordsTableAnnotationComposer,
      $$SyncAppliedOperationRecordsTableCreateCompanionBuilder,
      $$SyncAppliedOperationRecordsTableUpdateCompanionBuilder,
      (
        SyncAppliedOperationRecord,
        BaseReferences<
          _$MichiFocusDatabase,
          $SyncAppliedOperationRecordsTable,
          SyncAppliedOperationRecord
        >,
      ),
      SyncAppliedOperationRecord,
      PrefetchHooks Function()
    >;
typedef $$SyncEntityVersionRecordsTableCreateCompanionBuilder =
    SyncEntityVersionRecordsCompanion Function({
      required String groupId,
      required String entityType,
      required String entityId,
      required String fieldName,
      required String causalVersionJson,
      required String operationId,
      required String originDeviceId,
      Value<String> originDeviceName,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$SyncEntityVersionRecordsTableUpdateCompanionBuilder =
    SyncEntityVersionRecordsCompanion Function({
      Value<String> groupId,
      Value<String> entityType,
      Value<String> entityId,
      Value<String> fieldName,
      Value<String> causalVersionJson,
      Value<String> operationId,
      Value<String> originDeviceId,
      Value<String> originDeviceName,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$SyncEntityVersionRecordsTableFilterComposer
    extends Composer<_$MichiFocusDatabase, $SyncEntityVersionRecordsTable> {
  $$SyncEntityVersionRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get groupId => $composableBuilder(
    column: $table.groupId,
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

  ColumnFilters<String> get fieldName => $composableBuilder(
    column: $table.fieldName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get causalVersionJson => $composableBuilder(
    column: $table.causalVersionJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operationId => $composableBuilder(
    column: $table.operationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originDeviceId => $composableBuilder(
    column: $table.originDeviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originDeviceName => $composableBuilder(
    column: $table.originDeviceName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncEntityVersionRecordsTableOrderingComposer
    extends Composer<_$MichiFocusDatabase, $SyncEntityVersionRecordsTable> {
  $$SyncEntityVersionRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get groupId => $composableBuilder(
    column: $table.groupId,
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

  ColumnOrderings<String> get fieldName => $composableBuilder(
    column: $table.fieldName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get causalVersionJson => $composableBuilder(
    column: $table.causalVersionJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operationId => $composableBuilder(
    column: $table.operationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originDeviceId => $composableBuilder(
    column: $table.originDeviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originDeviceName => $composableBuilder(
    column: $table.originDeviceName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncEntityVersionRecordsTableAnnotationComposer
    extends Composer<_$MichiFocusDatabase, $SyncEntityVersionRecordsTable> {
  $$SyncEntityVersionRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get groupId =>
      $composableBuilder(column: $table.groupId, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get fieldName =>
      $composableBuilder(column: $table.fieldName, builder: (column) => column);

  GeneratedColumn<String> get causalVersionJson => $composableBuilder(
    column: $table.causalVersionJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get operationId => $composableBuilder(
    column: $table.operationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get originDeviceId => $composableBuilder(
    column: $table.originDeviceId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get originDeviceName => $composableBuilder(
    column: $table.originDeviceName,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SyncEntityVersionRecordsTableTableManager
    extends
        RootTableManager<
          _$MichiFocusDatabase,
          $SyncEntityVersionRecordsTable,
          SyncEntityVersionRecord,
          $$SyncEntityVersionRecordsTableFilterComposer,
          $$SyncEntityVersionRecordsTableOrderingComposer,
          $$SyncEntityVersionRecordsTableAnnotationComposer,
          $$SyncEntityVersionRecordsTableCreateCompanionBuilder,
          $$SyncEntityVersionRecordsTableUpdateCompanionBuilder,
          (
            SyncEntityVersionRecord,
            BaseReferences<
              _$MichiFocusDatabase,
              $SyncEntityVersionRecordsTable,
              SyncEntityVersionRecord
            >,
          ),
          SyncEntityVersionRecord,
          PrefetchHooks Function()
        > {
  $$SyncEntityVersionRecordsTableTableManager(
    _$MichiFocusDatabase db,
    $SyncEntityVersionRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncEntityVersionRecordsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$SyncEntityVersionRecordsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$SyncEntityVersionRecordsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> groupId = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String> fieldName = const Value.absent(),
                Value<String> causalVersionJson = const Value.absent(),
                Value<String> operationId = const Value.absent(),
                Value<String> originDeviceId = const Value.absent(),
                Value<String> originDeviceName = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncEntityVersionRecordsCompanion(
                groupId: groupId,
                entityType: entityType,
                entityId: entityId,
                fieldName: fieldName,
                causalVersionJson: causalVersionJson,
                operationId: operationId,
                originDeviceId: originDeviceId,
                originDeviceName: originDeviceName,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String groupId,
                required String entityType,
                required String entityId,
                required String fieldName,
                required String causalVersionJson,
                required String operationId,
                required String originDeviceId,
                Value<String> originDeviceName = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => SyncEntityVersionRecordsCompanion.insert(
                groupId: groupId,
                entityType: entityType,
                entityId: entityId,
                fieldName: fieldName,
                causalVersionJson: causalVersionJson,
                operationId: operationId,
                originDeviceId: originDeviceId,
                originDeviceName: originDeviceName,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncEntityVersionRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$MichiFocusDatabase,
      $SyncEntityVersionRecordsTable,
      SyncEntityVersionRecord,
      $$SyncEntityVersionRecordsTableFilterComposer,
      $$SyncEntityVersionRecordsTableOrderingComposer,
      $$SyncEntityVersionRecordsTableAnnotationComposer,
      $$SyncEntityVersionRecordsTableCreateCompanionBuilder,
      $$SyncEntityVersionRecordsTableUpdateCompanionBuilder,
      (
        SyncEntityVersionRecord,
        BaseReferences<
          _$MichiFocusDatabase,
          $SyncEntityVersionRecordsTable,
          SyncEntityVersionRecord
        >,
      ),
      SyncEntityVersionRecord,
      PrefetchHooks Function()
    >;
typedef $$SyncTombstoneRecordsTableCreateCompanionBuilder =
    SyncTombstoneRecordsCompanion Function({
      required String groupId,
      required String entityType,
      required String entityId,
      required String causalVersionJson,
      required String operationId,
      required String originDeviceId,
      Value<String> originDeviceName,
      Value<String?> entitySnapshotJson,
      required DateTime deletedAt,
      Value<int> rowid,
    });
typedef $$SyncTombstoneRecordsTableUpdateCompanionBuilder =
    SyncTombstoneRecordsCompanion Function({
      Value<String> groupId,
      Value<String> entityType,
      Value<String> entityId,
      Value<String> causalVersionJson,
      Value<String> operationId,
      Value<String> originDeviceId,
      Value<String> originDeviceName,
      Value<String?> entitySnapshotJson,
      Value<DateTime> deletedAt,
      Value<int> rowid,
    });

class $$SyncTombstoneRecordsTableFilterComposer
    extends Composer<_$MichiFocusDatabase, $SyncTombstoneRecordsTable> {
  $$SyncTombstoneRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get groupId => $composableBuilder(
    column: $table.groupId,
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

  ColumnFilters<String> get causalVersionJson => $composableBuilder(
    column: $table.causalVersionJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operationId => $composableBuilder(
    column: $table.operationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originDeviceId => $composableBuilder(
    column: $table.originDeviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originDeviceName => $composableBuilder(
    column: $table.originDeviceName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entitySnapshotJson => $composableBuilder(
    column: $table.entitySnapshotJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncTombstoneRecordsTableOrderingComposer
    extends Composer<_$MichiFocusDatabase, $SyncTombstoneRecordsTable> {
  $$SyncTombstoneRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get groupId => $composableBuilder(
    column: $table.groupId,
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

  ColumnOrderings<String> get causalVersionJson => $composableBuilder(
    column: $table.causalVersionJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operationId => $composableBuilder(
    column: $table.operationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originDeviceId => $composableBuilder(
    column: $table.originDeviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originDeviceName => $composableBuilder(
    column: $table.originDeviceName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entitySnapshotJson => $composableBuilder(
    column: $table.entitySnapshotJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncTombstoneRecordsTableAnnotationComposer
    extends Composer<_$MichiFocusDatabase, $SyncTombstoneRecordsTable> {
  $$SyncTombstoneRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get groupId =>
      $composableBuilder(column: $table.groupId, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get causalVersionJson => $composableBuilder(
    column: $table.causalVersionJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get operationId => $composableBuilder(
    column: $table.operationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get originDeviceId => $composableBuilder(
    column: $table.originDeviceId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get originDeviceName => $composableBuilder(
    column: $table.originDeviceName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entitySnapshotJson => $composableBuilder(
    column: $table.entitySnapshotJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$SyncTombstoneRecordsTableTableManager
    extends
        RootTableManager<
          _$MichiFocusDatabase,
          $SyncTombstoneRecordsTable,
          SyncTombstoneRecord,
          $$SyncTombstoneRecordsTableFilterComposer,
          $$SyncTombstoneRecordsTableOrderingComposer,
          $$SyncTombstoneRecordsTableAnnotationComposer,
          $$SyncTombstoneRecordsTableCreateCompanionBuilder,
          $$SyncTombstoneRecordsTableUpdateCompanionBuilder,
          (
            SyncTombstoneRecord,
            BaseReferences<
              _$MichiFocusDatabase,
              $SyncTombstoneRecordsTable,
              SyncTombstoneRecord
            >,
          ),
          SyncTombstoneRecord,
          PrefetchHooks Function()
        > {
  $$SyncTombstoneRecordsTableTableManager(
    _$MichiFocusDatabase db,
    $SyncTombstoneRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncTombstoneRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncTombstoneRecordsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$SyncTombstoneRecordsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> groupId = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String> causalVersionJson = const Value.absent(),
                Value<String> operationId = const Value.absent(),
                Value<String> originDeviceId = const Value.absent(),
                Value<String> originDeviceName = const Value.absent(),
                Value<String?> entitySnapshotJson = const Value.absent(),
                Value<DateTime> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncTombstoneRecordsCompanion(
                groupId: groupId,
                entityType: entityType,
                entityId: entityId,
                causalVersionJson: causalVersionJson,
                operationId: operationId,
                originDeviceId: originDeviceId,
                originDeviceName: originDeviceName,
                entitySnapshotJson: entitySnapshotJson,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String groupId,
                required String entityType,
                required String entityId,
                required String causalVersionJson,
                required String operationId,
                required String originDeviceId,
                Value<String> originDeviceName = const Value.absent(),
                Value<String?> entitySnapshotJson = const Value.absent(),
                required DateTime deletedAt,
                Value<int> rowid = const Value.absent(),
              }) => SyncTombstoneRecordsCompanion.insert(
                groupId: groupId,
                entityType: entityType,
                entityId: entityId,
                causalVersionJson: causalVersionJson,
                operationId: operationId,
                originDeviceId: originDeviceId,
                originDeviceName: originDeviceName,
                entitySnapshotJson: entitySnapshotJson,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncTombstoneRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$MichiFocusDatabase,
      $SyncTombstoneRecordsTable,
      SyncTombstoneRecord,
      $$SyncTombstoneRecordsTableFilterComposer,
      $$SyncTombstoneRecordsTableOrderingComposer,
      $$SyncTombstoneRecordsTableAnnotationComposer,
      $$SyncTombstoneRecordsTableCreateCompanionBuilder,
      $$SyncTombstoneRecordsTableUpdateCompanionBuilder,
      (
        SyncTombstoneRecord,
        BaseReferences<
          _$MichiFocusDatabase,
          $SyncTombstoneRecordsTable,
          SyncTombstoneRecord
        >,
      ),
      SyncTombstoneRecord,
      PrefetchHooks Function()
    >;
typedef $$SyncConflictRecordsTableCreateCompanionBuilder =
    SyncConflictRecordsCompanion Function({
      required String id,
      required String groupId,
      required String entityType,
      required String entityId,
      Value<String?> fieldName,
      required String candidatesJson,
      Value<String> status,
      Value<String?> resolutionOperationId,
      required DateTime createdAt,
      Value<DateTime?> resolvedAt,
      Value<int> rowid,
    });
typedef $$SyncConflictRecordsTableUpdateCompanionBuilder =
    SyncConflictRecordsCompanion Function({
      Value<String> id,
      Value<String> groupId,
      Value<String> entityType,
      Value<String> entityId,
      Value<String?> fieldName,
      Value<String> candidatesJson,
      Value<String> status,
      Value<String?> resolutionOperationId,
      Value<DateTime> createdAt,
      Value<DateTime?> resolvedAt,
      Value<int> rowid,
    });

class $$SyncConflictRecordsTableFilterComposer
    extends Composer<_$MichiFocusDatabase, $SyncConflictRecordsTable> {
  $$SyncConflictRecordsTableFilterComposer({
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

  ColumnFilters<String> get groupId => $composableBuilder(
    column: $table.groupId,
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

  ColumnFilters<String> get fieldName => $composableBuilder(
    column: $table.fieldName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get candidatesJson => $composableBuilder(
    column: $table.candidatesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get resolutionOperationId => $composableBuilder(
    column: $table.resolutionOperationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get resolvedAt => $composableBuilder(
    column: $table.resolvedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncConflictRecordsTableOrderingComposer
    extends Composer<_$MichiFocusDatabase, $SyncConflictRecordsTable> {
  $$SyncConflictRecordsTableOrderingComposer({
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

  ColumnOrderings<String> get groupId => $composableBuilder(
    column: $table.groupId,
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

  ColumnOrderings<String> get fieldName => $composableBuilder(
    column: $table.fieldName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get candidatesJson => $composableBuilder(
    column: $table.candidatesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get resolutionOperationId => $composableBuilder(
    column: $table.resolutionOperationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get resolvedAt => $composableBuilder(
    column: $table.resolvedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncConflictRecordsTableAnnotationComposer
    extends Composer<_$MichiFocusDatabase, $SyncConflictRecordsTable> {
  $$SyncConflictRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get groupId =>
      $composableBuilder(column: $table.groupId, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get fieldName =>
      $composableBuilder(column: $table.fieldName, builder: (column) => column);

  GeneratedColumn<String> get candidatesJson => $composableBuilder(
    column: $table.candidatesJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get resolutionOperationId => $composableBuilder(
    column: $table.resolutionOperationId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get resolvedAt => $composableBuilder(
    column: $table.resolvedAt,
    builder: (column) => column,
  );
}

class $$SyncConflictRecordsTableTableManager
    extends
        RootTableManager<
          _$MichiFocusDatabase,
          $SyncConflictRecordsTable,
          SyncConflictRecord,
          $$SyncConflictRecordsTableFilterComposer,
          $$SyncConflictRecordsTableOrderingComposer,
          $$SyncConflictRecordsTableAnnotationComposer,
          $$SyncConflictRecordsTableCreateCompanionBuilder,
          $$SyncConflictRecordsTableUpdateCompanionBuilder,
          (
            SyncConflictRecord,
            BaseReferences<
              _$MichiFocusDatabase,
              $SyncConflictRecordsTable,
              SyncConflictRecord
            >,
          ),
          SyncConflictRecord,
          PrefetchHooks Function()
        > {
  $$SyncConflictRecordsTableTableManager(
    _$MichiFocusDatabase db,
    $SyncConflictRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncConflictRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncConflictRecordsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$SyncConflictRecordsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> groupId = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String?> fieldName = const Value.absent(),
                Value<String> candidatesJson = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> resolutionOperationId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> resolvedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncConflictRecordsCompanion(
                id: id,
                groupId: groupId,
                entityType: entityType,
                entityId: entityId,
                fieldName: fieldName,
                candidatesJson: candidatesJson,
                status: status,
                resolutionOperationId: resolutionOperationId,
                createdAt: createdAt,
                resolvedAt: resolvedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String groupId,
                required String entityType,
                required String entityId,
                Value<String?> fieldName = const Value.absent(),
                required String candidatesJson,
                Value<String> status = const Value.absent(),
                Value<String?> resolutionOperationId = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime?> resolvedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncConflictRecordsCompanion.insert(
                id: id,
                groupId: groupId,
                entityType: entityType,
                entityId: entityId,
                fieldName: fieldName,
                candidatesJson: candidatesJson,
                status: status,
                resolutionOperationId: resolutionOperationId,
                createdAt: createdAt,
                resolvedAt: resolvedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncConflictRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$MichiFocusDatabase,
      $SyncConflictRecordsTable,
      SyncConflictRecord,
      $$SyncConflictRecordsTableFilterComposer,
      $$SyncConflictRecordsTableOrderingComposer,
      $$SyncConflictRecordsTableAnnotationComposer,
      $$SyncConflictRecordsTableCreateCompanionBuilder,
      $$SyncConflictRecordsTableUpdateCompanionBuilder,
      (
        SyncConflictRecord,
        BaseReferences<
          _$MichiFocusDatabase,
          $SyncConflictRecordsTable,
          SyncConflictRecord
        >,
      ),
      SyncConflictRecord,
      PrefetchHooks Function()
    >;
typedef $$SyncAcknowledgementRecordsTableCreateCompanionBuilder =
    SyncAcknowledgementRecordsCompanion Function({
      required String groupId,
      required String observerDeviceId,
      required String originDeviceId,
      required int acknowledgedCounter,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$SyncAcknowledgementRecordsTableUpdateCompanionBuilder =
    SyncAcknowledgementRecordsCompanion Function({
      Value<String> groupId,
      Value<String> observerDeviceId,
      Value<String> originDeviceId,
      Value<int> acknowledgedCounter,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$SyncAcknowledgementRecordsTableFilterComposer
    extends Composer<_$MichiFocusDatabase, $SyncAcknowledgementRecordsTable> {
  $$SyncAcknowledgementRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get groupId => $composableBuilder(
    column: $table.groupId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get observerDeviceId => $composableBuilder(
    column: $table.observerDeviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originDeviceId => $composableBuilder(
    column: $table.originDeviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get acknowledgedCounter => $composableBuilder(
    column: $table.acknowledgedCounter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncAcknowledgementRecordsTableOrderingComposer
    extends Composer<_$MichiFocusDatabase, $SyncAcknowledgementRecordsTable> {
  $$SyncAcknowledgementRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get groupId => $composableBuilder(
    column: $table.groupId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get observerDeviceId => $composableBuilder(
    column: $table.observerDeviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originDeviceId => $composableBuilder(
    column: $table.originDeviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get acknowledgedCounter => $composableBuilder(
    column: $table.acknowledgedCounter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncAcknowledgementRecordsTableAnnotationComposer
    extends Composer<_$MichiFocusDatabase, $SyncAcknowledgementRecordsTable> {
  $$SyncAcknowledgementRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get groupId =>
      $composableBuilder(column: $table.groupId, builder: (column) => column);

  GeneratedColumn<String> get observerDeviceId => $composableBuilder(
    column: $table.observerDeviceId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get originDeviceId => $composableBuilder(
    column: $table.originDeviceId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get acknowledgedCounter => $composableBuilder(
    column: $table.acknowledgedCounter,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SyncAcknowledgementRecordsTableTableManager
    extends
        RootTableManager<
          _$MichiFocusDatabase,
          $SyncAcknowledgementRecordsTable,
          SyncAcknowledgementRecord,
          $$SyncAcknowledgementRecordsTableFilterComposer,
          $$SyncAcknowledgementRecordsTableOrderingComposer,
          $$SyncAcknowledgementRecordsTableAnnotationComposer,
          $$SyncAcknowledgementRecordsTableCreateCompanionBuilder,
          $$SyncAcknowledgementRecordsTableUpdateCompanionBuilder,
          (
            SyncAcknowledgementRecord,
            BaseReferences<
              _$MichiFocusDatabase,
              $SyncAcknowledgementRecordsTable,
              SyncAcknowledgementRecord
            >,
          ),
          SyncAcknowledgementRecord,
          PrefetchHooks Function()
        > {
  $$SyncAcknowledgementRecordsTableTableManager(
    _$MichiFocusDatabase db,
    $SyncAcknowledgementRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncAcknowledgementRecordsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$SyncAcknowledgementRecordsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$SyncAcknowledgementRecordsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> groupId = const Value.absent(),
                Value<String> observerDeviceId = const Value.absent(),
                Value<String> originDeviceId = const Value.absent(),
                Value<int> acknowledgedCounter = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncAcknowledgementRecordsCompanion(
                groupId: groupId,
                observerDeviceId: observerDeviceId,
                originDeviceId: originDeviceId,
                acknowledgedCounter: acknowledgedCounter,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String groupId,
                required String observerDeviceId,
                required String originDeviceId,
                required int acknowledgedCounter,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => SyncAcknowledgementRecordsCompanion.insert(
                groupId: groupId,
                observerDeviceId: observerDeviceId,
                originDeviceId: originDeviceId,
                acknowledgedCounter: acknowledgedCounter,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncAcknowledgementRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$MichiFocusDatabase,
      $SyncAcknowledgementRecordsTable,
      SyncAcknowledgementRecord,
      $$SyncAcknowledgementRecordsTableFilterComposer,
      $$SyncAcknowledgementRecordsTableOrderingComposer,
      $$SyncAcknowledgementRecordsTableAnnotationComposer,
      $$SyncAcknowledgementRecordsTableCreateCompanionBuilder,
      $$SyncAcknowledgementRecordsTableUpdateCompanionBuilder,
      (
        SyncAcknowledgementRecord,
        BaseReferences<
          _$MichiFocusDatabase,
          $SyncAcknowledgementRecordsTable,
          SyncAcknowledgementRecord
        >,
      ),
      SyncAcknowledgementRecord,
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
  $$RoutineRecordsTableTableManager get routineRecords =>
      $$RoutineRecordsTableTableManager(_db, _db.routineRecords);
  $$RoutineDayRecordsTableTableManager get routineDayRecords =>
      $$RoutineDayRecordsTableTableManager(_db, _db.routineDayRecords);
  $$RoutineItemRecordsTableTableManager get routineItemRecords =>
      $$RoutineItemRecordsTableTableManager(_db, _db.routineItemRecords);
  $$RoutineRunRecordsTableTableManager get routineRunRecords =>
      $$RoutineRunRecordsTableTableManager(_db, _db.routineRunRecords);
  $$RoutineItemRunRecordsTableTableManager get routineItemRunRecords =>
      $$RoutineItemRunRecordsTableTableManager(_db, _db.routineItemRunRecords);
  $$CalendarEventRecordsTableTableManager get calendarEventRecords =>
      $$CalendarEventRecordsTableTableManager(_db, _db.calendarEventRecords);
  $$QuickNoteRecordsTableTableManager get quickNoteRecords =>
      $$QuickNoteRecordsTableTableManager(_db, _db.quickNoteRecords);
  $$SyncLocalStateRecordsTableTableManager get syncLocalStateRecords =>
      $$SyncLocalStateRecordsTableTableManager(_db, _db.syncLocalStateRecords);
  $$SyncOutboxRecordsTableTableManager get syncOutboxRecords =>
      $$SyncOutboxRecordsTableTableManager(_db, _db.syncOutboxRecords);
  $$SyncAppliedOperationRecordsTableTableManager
  get syncAppliedOperationRecords =>
      $$SyncAppliedOperationRecordsTableTableManager(
        _db,
        _db.syncAppliedOperationRecords,
      );
  $$SyncEntityVersionRecordsTableTableManager get syncEntityVersionRecords =>
      $$SyncEntityVersionRecordsTableTableManager(
        _db,
        _db.syncEntityVersionRecords,
      );
  $$SyncTombstoneRecordsTableTableManager get syncTombstoneRecords =>
      $$SyncTombstoneRecordsTableTableManager(_db, _db.syncTombstoneRecords);
  $$SyncConflictRecordsTableTableManager get syncConflictRecords =>
      $$SyncConflictRecordsTableTableManager(_db, _db.syncConflictRecords);
  $$SyncAcknowledgementRecordsTableTableManager
  get syncAcknowledgementRecords =>
      $$SyncAcknowledgementRecordsTableTableManager(
        _db,
        _db.syncAcknowledgementRecords,
      );
}
