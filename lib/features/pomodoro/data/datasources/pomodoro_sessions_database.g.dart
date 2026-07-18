// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pomodoro_sessions_database.dart';

// ignore_for_file: type=lint
mixin _$PomodoroSessionsDaoMixin on DatabaseAccessor<PomodoroSessionsDatabase> {
  $PomodoroSessionRecordsTable get pomodoroSessionRecords =>
      attachedDatabase.pomodoroSessionRecords;
  PomodoroSessionsDaoManager get managers => PomodoroSessionsDaoManager(this);
}

class PomodoroSessionsDaoManager {
  final _$PomodoroSessionsDaoMixin _db;
  PomodoroSessionsDaoManager(this._db);
  $$PomodoroSessionRecordsTableTableManager get pomodoroSessionRecords =>
      $$PomodoroSessionRecordsTableTableManager(
        _db.attachedDatabase,
        _db.pomodoroSessionRecords,
      );
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
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
    'task_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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

abstract class _$PomodoroSessionsDatabase extends GeneratedDatabase {
  _$PomodoroSessionsDatabase(QueryExecutor e) : super(e);
  $PomodoroSessionsDatabaseManager get managers =>
      $PomodoroSessionsDatabaseManager(this);
  late final $PomodoroSessionRecordsTable pomodoroSessionRecords =
      $PomodoroSessionRecordsTable(this);
  late final PomodoroSessionsDao pomodoroSessionsDao = PomodoroSessionsDao(
    this as PomodoroSessionsDatabase,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [pomodoroSessionRecords];
}

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

class $$PomodoroSessionRecordsTableFilterComposer
    extends Composer<_$PomodoroSessionsDatabase, $PomodoroSessionRecordsTable> {
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

  ColumnFilters<String> get goalId => $composableBuilder(
    column: $table.goalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get taskId => $composableBuilder(
    column: $table.taskId,
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
}

class $$PomodoroSessionRecordsTableOrderingComposer
    extends Composer<_$PomodoroSessionsDatabase, $PomodoroSessionRecordsTable> {
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

  ColumnOrderings<String> get goalId => $composableBuilder(
    column: $table.goalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get taskId => $composableBuilder(
    column: $table.taskId,
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
}

class $$PomodoroSessionRecordsTableAnnotationComposer
    extends Composer<_$PomodoroSessionsDatabase, $PomodoroSessionRecordsTable> {
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

  GeneratedColumn<String> get goalId =>
      $composableBuilder(column: $table.goalId, builder: (column) => column);

  GeneratedColumn<String> get taskId =>
      $composableBuilder(column: $table.taskId, builder: (column) => column);

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
}

class $$PomodoroSessionRecordsTableTableManager
    extends
        RootTableManager<
          _$PomodoroSessionsDatabase,
          $PomodoroSessionRecordsTable,
          PomodoroSessionRecord,
          $$PomodoroSessionRecordsTableFilterComposer,
          $$PomodoroSessionRecordsTableOrderingComposer,
          $$PomodoroSessionRecordsTableAnnotationComposer,
          $$PomodoroSessionRecordsTableCreateCompanionBuilder,
          $$PomodoroSessionRecordsTableUpdateCompanionBuilder,
          (
            PomodoroSessionRecord,
            BaseReferences<
              _$PomodoroSessionsDatabase,
              $PomodoroSessionRecordsTable,
              PomodoroSessionRecord
            >,
          ),
          PomodoroSessionRecord,
          PrefetchHooks Function()
        > {
  $$PomodoroSessionRecordsTableTableManager(
    _$PomodoroSessionsDatabase db,
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
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PomodoroSessionRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$PomodoroSessionsDatabase,
      $PomodoroSessionRecordsTable,
      PomodoroSessionRecord,
      $$PomodoroSessionRecordsTableFilterComposer,
      $$PomodoroSessionRecordsTableOrderingComposer,
      $$PomodoroSessionRecordsTableAnnotationComposer,
      $$PomodoroSessionRecordsTableCreateCompanionBuilder,
      $$PomodoroSessionRecordsTableUpdateCompanionBuilder,
      (
        PomodoroSessionRecord,
        BaseReferences<
          _$PomodoroSessionsDatabase,
          $PomodoroSessionRecordsTable,
          PomodoroSessionRecord
        >,
      ),
      PomodoroSessionRecord,
      PrefetchHooks Function()
    >;

class $PomodoroSessionsDatabaseManager {
  final _$PomodoroSessionsDatabase _db;
  $PomodoroSessionsDatabaseManager(this._db);
  $$PomodoroSessionRecordsTableTableManager get pomodoroSessionRecords =>
      $$PomodoroSessionRecordsTableTableManager(
        _db,
        _db.pomodoroSessionRecords,
      );
}
