// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_events_database.dart';

// ignore_for_file: type=lint
mixin _$CalendarEventsDaoMixin on DatabaseAccessor<CalendarEventsDatabase> {
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

abstract class _$CalendarEventsDatabase extends GeneratedDatabase {
  _$CalendarEventsDatabase(QueryExecutor e) : super(e);
  $CalendarEventsDatabaseManager get managers =>
      $CalendarEventsDatabaseManager(this);
  late final $CalendarEventRecordsTable calendarEventRecords =
      $CalendarEventRecordsTable(this);
  late final CalendarEventsDao calendarEventsDao = CalendarEventsDao(
    this as CalendarEventsDatabase,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [calendarEventRecords];
}

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
    extends Composer<_$CalendarEventsDatabase, $CalendarEventRecordsTable> {
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
    extends Composer<_$CalendarEventsDatabase, $CalendarEventRecordsTable> {
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
    extends Composer<_$CalendarEventsDatabase, $CalendarEventRecordsTable> {
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
          _$CalendarEventsDatabase,
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
              _$CalendarEventsDatabase,
              $CalendarEventRecordsTable,
              CalendarEventRecord
            >,
          ),
          CalendarEventRecord,
          PrefetchHooks Function()
        > {
  $$CalendarEventRecordsTableTableManager(
    _$CalendarEventsDatabase db,
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
      _$CalendarEventsDatabase,
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
          _$CalendarEventsDatabase,
          $CalendarEventRecordsTable,
          CalendarEventRecord
        >,
      ),
      CalendarEventRecord,
      PrefetchHooks Function()
    >;

class $CalendarEventsDatabaseManager {
  final _$CalendarEventsDatabase _db;
  $CalendarEventsDatabaseManager(this._db);
  $$CalendarEventRecordsTableTableManager get calendarEventRecords =>
      $$CalendarEventRecordsTableTableManager(_db, _db.calendarEventRecords);
}
