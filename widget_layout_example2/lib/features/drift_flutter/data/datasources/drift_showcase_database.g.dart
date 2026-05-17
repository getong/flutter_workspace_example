// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drift_showcase_database.dart';

// ignore_for_file: type=lint
class $DriftTodosTable extends DriftTodos
    with TableInfo<$DriftTodosTable, DriftTodoEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DriftTodosTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
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
    requiredDuringInsert: false,
    defaultValue: const Constant('General'),
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<int> priority = GeneratedColumn<int>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(3),
  );
  static const VerificationMeta _completedMeta = const VerificationMeta(
    'completed',
  );
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
    'completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<UuidValue, String> uuidV7 =
      GeneratedColumn<String>(
        'uuid_v7',
        aliasedName,
        false,
        additionalChecks: GeneratedColumn.checkTextLength(
          minTextLength: 36,
          maxTextLength: 36,
        ),
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        clientDefault: _generateUuidV7Sql,
      ).withConverter<UuidValue>($DriftTodosTable.$converteruuidV7);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  @override
  late final GeneratedColumnWithTypeConverter<OffsetDateTimeValue, String>
  createdAtWithTimezone =
      GeneratedColumn<String>(
        'created_at_with_timezone',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        clientDefault: _generateOffsetDateTimeSql,
      ).withConverter<OffsetDateTimeValue>(
        $DriftTodosTable.$convertercreatedAtWithTimezone,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    category,
    priority,
    completed,
    notes,
    uuidV7,
    createdAt,
    createdAtWithTimezone,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'drift_todos';
  @override
  VerificationContext validateIntegrity(
    Insertable<DriftTodoEntry> instance, {
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
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    }
    if (data.containsKey('completed')) {
      context.handle(
        _completedMeta,
        completed.isAcceptableOrUnknown(data['completed']!, _completedMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DriftTodoEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DriftTodoEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}priority'],
      )!,
      completed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}completed'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      uuidV7: $DriftTodosTable.$converteruuidV7.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}uuid_v7'],
        )!,
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      createdAtWithTimezone: $DriftTodosTable.$convertercreatedAtWithTimezone
          .fromSql(
            attachedDatabase.typeMapping.read(
              DriftSqlType.string,
              data['${effectivePrefix}created_at_with_timezone'],
            )!,
          ),
    );
  }

  @override
  $DriftTodosTable createAlias(String alias) {
    return $DriftTodosTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<UuidValue, String, String> $converteruuidV7 =
      const UuidV7ValueConverter();
  static JsonTypeConverter2<OffsetDateTimeValue, String, String>
  $convertercreatedAtWithTimezone = const OffsetDateTimeValueConverter();
}

class DriftTodoEntry extends DataClass implements Insertable<DriftTodoEntry> {
  final int id;
  final String title;
  final String category;
  final int priority;
  final bool completed;
  final String? notes;
  final UuidValue uuidV7;
  final DateTime createdAt;
  final OffsetDateTimeValue createdAtWithTimezone;
  const DriftTodoEntry({
    required this.id,
    required this.title,
    required this.category,
    required this.priority,
    required this.completed,
    this.notes,
    required this.uuidV7,
    required this.createdAt,
    required this.createdAtWithTimezone,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['category'] = Variable<String>(category);
    map['priority'] = Variable<int>(priority);
    map['completed'] = Variable<bool>(completed);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    {
      map['uuid_v7'] = Variable<String>(
        $DriftTodosTable.$converteruuidV7.toSql(uuidV7),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    {
      map['created_at_with_timezone'] = Variable<String>(
        $DriftTodosTable.$convertercreatedAtWithTimezone.toSql(
          createdAtWithTimezone,
        ),
      );
    }
    return map;
  }

  DriftTodosCompanion toCompanion(bool nullToAbsent) {
    return DriftTodosCompanion(
      id: Value(id),
      title: Value(title),
      category: Value(category),
      priority: Value(priority),
      completed: Value(completed),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      uuidV7: Value(uuidV7),
      createdAt: Value(createdAt),
      createdAtWithTimezone: Value(createdAtWithTimezone),
    );
  }

  factory DriftTodoEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DriftTodoEntry(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      category: serializer.fromJson<String>(json['category']),
      priority: serializer.fromJson<int>(json['priority']),
      completed: serializer.fromJson<bool>(json['completed']),
      notes: serializer.fromJson<String?>(json['notes']),
      uuidV7: $DriftTodosTable.$converteruuidV7.fromJson(
        serializer.fromJson<String>(json['uuidV7']),
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      createdAtWithTimezone: $DriftTodosTable.$convertercreatedAtWithTimezone
          .fromJson(serializer.fromJson<String>(json['createdAtWithTimezone'])),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'category': serializer.toJson<String>(category),
      'priority': serializer.toJson<int>(priority),
      'completed': serializer.toJson<bool>(completed),
      'notes': serializer.toJson<String?>(notes),
      'uuidV7': serializer.toJson<String>(
        $DriftTodosTable.$converteruuidV7.toJson(uuidV7),
      ),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'createdAtWithTimezone': serializer.toJson<String>(
        $DriftTodosTable.$convertercreatedAtWithTimezone.toJson(
          createdAtWithTimezone,
        ),
      ),
    };
  }

  DriftTodoEntry copyWith({
    int? id,
    String? title,
    String? category,
    int? priority,
    bool? completed,
    Value<String?> notes = const Value.absent(),
    UuidValue? uuidV7,
    DateTime? createdAt,
    OffsetDateTimeValue? createdAtWithTimezone,
  }) => DriftTodoEntry(
    id: id ?? this.id,
    title: title ?? this.title,
    category: category ?? this.category,
    priority: priority ?? this.priority,
    completed: completed ?? this.completed,
    notes: notes.present ? notes.value : this.notes,
    uuidV7: uuidV7 ?? this.uuidV7,
    createdAt: createdAt ?? this.createdAt,
    createdAtWithTimezone: createdAtWithTimezone ?? this.createdAtWithTimezone,
  );
  DriftTodoEntry copyWithCompanion(DriftTodosCompanion data) {
    return DriftTodoEntry(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      category: data.category.present ? data.category.value : this.category,
      priority: data.priority.present ? data.priority.value : this.priority,
      completed: data.completed.present ? data.completed.value : this.completed,
      notes: data.notes.present ? data.notes.value : this.notes,
      uuidV7: data.uuidV7.present ? data.uuidV7.value : this.uuidV7,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      createdAtWithTimezone: data.createdAtWithTimezone.present
          ? data.createdAtWithTimezone.value
          : this.createdAtWithTimezone,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DriftTodoEntry(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('category: $category, ')
          ..write('priority: $priority, ')
          ..write('completed: $completed, ')
          ..write('notes: $notes, ')
          ..write('uuidV7: $uuidV7, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdAtWithTimezone: $createdAtWithTimezone')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    category,
    priority,
    completed,
    notes,
    uuidV7,
    createdAt,
    createdAtWithTimezone,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DriftTodoEntry &&
          other.id == this.id &&
          other.title == this.title &&
          other.category == this.category &&
          other.priority == this.priority &&
          other.completed == this.completed &&
          other.notes == this.notes &&
          other.uuidV7 == this.uuidV7 &&
          other.createdAt == this.createdAt &&
          other.createdAtWithTimezone == this.createdAtWithTimezone);
}

class DriftTodosCompanion extends UpdateCompanion<DriftTodoEntry> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> category;
  final Value<int> priority;
  final Value<bool> completed;
  final Value<String?> notes;
  final Value<UuidValue> uuidV7;
  final Value<DateTime> createdAt;
  final Value<OffsetDateTimeValue> createdAtWithTimezone;
  const DriftTodosCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.category = const Value.absent(),
    this.priority = const Value.absent(),
    this.completed = const Value.absent(),
    this.notes = const Value.absent(),
    this.uuidV7 = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.createdAtWithTimezone = const Value.absent(),
  });
  DriftTodosCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    this.category = const Value.absent(),
    this.priority = const Value.absent(),
    this.completed = const Value.absent(),
    this.notes = const Value.absent(),
    this.uuidV7 = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.createdAtWithTimezone = const Value.absent(),
  }) : title = Value(title);
  static Insertable<DriftTodoEntry> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? category,
    Expression<int>? priority,
    Expression<bool>? completed,
    Expression<String>? notes,
    Expression<String>? uuidV7,
    Expression<DateTime>? createdAt,
    Expression<String>? createdAtWithTimezone,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (category != null) 'category': category,
      if (priority != null) 'priority': priority,
      if (completed != null) 'completed': completed,
      if (notes != null) 'notes': notes,
      if (uuidV7 != null) 'uuid_v7': uuidV7,
      if (createdAt != null) 'created_at': createdAt,
      if (createdAtWithTimezone != null)
        'created_at_with_timezone': createdAtWithTimezone,
    });
  }

  DriftTodosCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String>? category,
    Value<int>? priority,
    Value<bool>? completed,
    Value<String?>? notes,
    Value<UuidValue>? uuidV7,
    Value<DateTime>? createdAt,
    Value<OffsetDateTimeValue>? createdAtWithTimezone,
  }) {
    return DriftTodosCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      completed: completed ?? this.completed,
      notes: notes ?? this.notes,
      uuidV7: uuidV7 ?? this.uuidV7,
      createdAt: createdAt ?? this.createdAt,
      createdAtWithTimezone:
          createdAtWithTimezone ?? this.createdAtWithTimezone,
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
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (uuidV7.present) {
      map['uuid_v7'] = Variable<String>(
        $DriftTodosTable.$converteruuidV7.toSql(uuidV7.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (createdAtWithTimezone.present) {
      map['created_at_with_timezone'] = Variable<String>(
        $DriftTodosTable.$convertercreatedAtWithTimezone.toSql(
          createdAtWithTimezone.value,
        ),
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DriftTodosCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('category: $category, ')
          ..write('priority: $priority, ')
          ..write('completed: $completed, ')
          ..write('notes: $notes, ')
          ..write('uuidV7: $uuidV7, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdAtWithTimezone: $createdAtWithTimezone')
          ..write(')'))
        .toString();
  }
}

abstract class _$DriftShowcaseDatabase extends GeneratedDatabase {
  _$DriftShowcaseDatabase(QueryExecutor e) : super(e);
  $DriftShowcaseDatabaseManager get managers =>
      $DriftShowcaseDatabaseManager(this);
  late final $DriftTodosTable driftTodos = $DriftTodosTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [driftTodos];
}

typedef $$DriftTodosTableCreateCompanionBuilder =
    DriftTodosCompanion Function({
      Value<int> id,
      required String title,
      Value<String> category,
      Value<int> priority,
      Value<bool> completed,
      Value<String?> notes,
      Value<UuidValue> uuidV7,
      Value<DateTime> createdAt,
      Value<OffsetDateTimeValue> createdAtWithTimezone,
    });
typedef $$DriftTodosTableUpdateCompanionBuilder =
    DriftTodosCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<String> category,
      Value<int> priority,
      Value<bool> completed,
      Value<String?> notes,
      Value<UuidValue> uuidV7,
      Value<DateTime> createdAt,
      Value<OffsetDateTimeValue> createdAtWithTimezone,
    });

class $$DriftTodosTableFilterComposer
    extends Composer<_$DriftShowcaseDatabase, $DriftTodosTable> {
  $$DriftTodosTableFilterComposer({
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

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<UuidValue, UuidValue, String> get uuidV7 =>
      $composableBuilder(
        column: $table.uuidV7,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    OffsetDateTimeValue,
    OffsetDateTimeValue,
    String
  >
  get createdAtWithTimezone => $composableBuilder(
    column: $table.createdAtWithTimezone,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );
}

class $$DriftTodosTableOrderingComposer
    extends Composer<_$DriftShowcaseDatabase, $DriftTodosTable> {
  $$DriftTodosTableOrderingComposer({
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

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uuidV7 => $composableBuilder(
    column: $table.uuidV7,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAtWithTimezone => $composableBuilder(
    column: $table.createdAtWithTimezone,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DriftTodosTableAnnotationComposer
    extends Composer<_$DriftShowcaseDatabase, $DriftTodosTable> {
  $$DriftTodosTableAnnotationComposer({
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

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumnWithTypeConverter<UuidValue, String> get uuidV7 =>
      $composableBuilder(column: $table.uuidV7, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<OffsetDateTimeValue, String>
  get createdAtWithTimezone => $composableBuilder(
    column: $table.createdAtWithTimezone,
    builder: (column) => column,
  );
}

class $$DriftTodosTableTableManager
    extends
        RootTableManager<
          _$DriftShowcaseDatabase,
          $DriftTodosTable,
          DriftTodoEntry,
          $$DriftTodosTableFilterComposer,
          $$DriftTodosTableOrderingComposer,
          $$DriftTodosTableAnnotationComposer,
          $$DriftTodosTableCreateCompanionBuilder,
          $$DriftTodosTableUpdateCompanionBuilder,
          (
            DriftTodoEntry,
            BaseReferences<
              _$DriftShowcaseDatabase,
              $DriftTodosTable,
              DriftTodoEntry
            >,
          ),
          DriftTodoEntry,
          PrefetchHooks Function()
        > {
  $$DriftTodosTableTableManager(
    _$DriftShowcaseDatabase db,
    $DriftTodosTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DriftTodosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DriftTodosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DriftTodosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<int> priority = const Value.absent(),
                Value<bool> completed = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<UuidValue> uuidV7 = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<OffsetDateTimeValue> createdAtWithTimezone =
                    const Value.absent(),
              }) => DriftTodosCompanion(
                id: id,
                title: title,
                category: category,
                priority: priority,
                completed: completed,
                notes: notes,
                uuidV7: uuidV7,
                createdAt: createdAt,
                createdAtWithTimezone: createdAtWithTimezone,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                Value<String> category = const Value.absent(),
                Value<int> priority = const Value.absent(),
                Value<bool> completed = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<UuidValue> uuidV7 = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<OffsetDateTimeValue> createdAtWithTimezone =
                    const Value.absent(),
              }) => DriftTodosCompanion.insert(
                id: id,
                title: title,
                category: category,
                priority: priority,
                completed: completed,
                notes: notes,
                uuidV7: uuidV7,
                createdAt: createdAt,
                createdAtWithTimezone: createdAtWithTimezone,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DriftTodosTableProcessedTableManager =
    ProcessedTableManager<
      _$DriftShowcaseDatabase,
      $DriftTodosTable,
      DriftTodoEntry,
      $$DriftTodosTableFilterComposer,
      $$DriftTodosTableOrderingComposer,
      $$DriftTodosTableAnnotationComposer,
      $$DriftTodosTableCreateCompanionBuilder,
      $$DriftTodosTableUpdateCompanionBuilder,
      (
        DriftTodoEntry,
        BaseReferences<
          _$DriftShowcaseDatabase,
          $DriftTodosTable,
          DriftTodoEntry
        >,
      ),
      DriftTodoEntry,
      PrefetchHooks Function()
    >;

class $DriftShowcaseDatabaseManager {
  final _$DriftShowcaseDatabase _db;
  $DriftShowcaseDatabaseManager(this._db);
  $$DriftTodosTableTableManager get driftTodos =>
      $$DriftTodosTableTableManager(_db, _db.driftTodos);
}
