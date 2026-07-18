// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goals_database.dart';

// ignore_for_file: type=lint
mixin _$GoalsDaoMixin on DatabaseAccessor<GoalsDatabase> {
  $GoalRecordsTable get goalRecords => attachedDatabase.goalRecords;
  GoalsDaoManager get managers => GoalsDaoManager(this);
}

class GoalsDaoManager {
  final _$GoalsDaoMixin _db;
  GoalsDaoManager(this._db);
  $$GoalRecordsTableTableManager get goalRecords =>
      $$GoalRecordsTableTableManager(_db.attachedDatabase, _db.goalRecords);
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

abstract class _$GoalsDatabase extends GeneratedDatabase {
  _$GoalsDatabase(QueryExecutor e) : super(e);
  $GoalsDatabaseManager get managers => $GoalsDatabaseManager(this);
  late final $GoalRecordsTable goalRecords = $GoalRecordsTable(this);
  late final GoalsDao goalsDao = GoalsDao(this as GoalsDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [goalRecords];
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

class $$GoalRecordsTableFilterComposer
    extends Composer<_$GoalsDatabase, $GoalRecordsTable> {
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
}

class $$GoalRecordsTableOrderingComposer
    extends Composer<_$GoalsDatabase, $GoalRecordsTable> {
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
    extends Composer<_$GoalsDatabase, $GoalRecordsTable> {
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
}

class $$GoalRecordsTableTableManager
    extends
        RootTableManager<
          _$GoalsDatabase,
          $GoalRecordsTable,
          GoalRecord,
          $$GoalRecordsTableFilterComposer,
          $$GoalRecordsTableOrderingComposer,
          $$GoalRecordsTableAnnotationComposer,
          $$GoalRecordsTableCreateCompanionBuilder,
          $$GoalRecordsTableUpdateCompanionBuilder,
          (
            GoalRecord,
            BaseReferences<_$GoalsDatabase, $GoalRecordsTable, GoalRecord>,
          ),
          GoalRecord,
          PrefetchHooks Function()
        > {
  $$GoalRecordsTableTableManager(_$GoalsDatabase db, $GoalRecordsTable table)
    : super(
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
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GoalRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$GoalsDatabase,
      $GoalRecordsTable,
      GoalRecord,
      $$GoalRecordsTableFilterComposer,
      $$GoalRecordsTableOrderingComposer,
      $$GoalRecordsTableAnnotationComposer,
      $$GoalRecordsTableCreateCompanionBuilder,
      $$GoalRecordsTableUpdateCompanionBuilder,
      (
        GoalRecord,
        BaseReferences<_$GoalsDatabase, $GoalRecordsTable, GoalRecord>,
      ),
      GoalRecord,
      PrefetchHooks Function()
    >;

class $GoalsDatabaseManager {
  final _$GoalsDatabase _db;
  $GoalsDatabaseManager(this._db);
  $$GoalRecordsTableTableManager get goalRecords =>
      $$GoalRecordsTableTableManager(_db, _db.goalRecords);
}
