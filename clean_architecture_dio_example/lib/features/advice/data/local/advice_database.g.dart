// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'advice_database.dart';

// ignore_for_file: type=lint
class $AdviceEntriesTable extends AdviceEntries
    with TableInfo<$AdviceEntriesTable, AdviceEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AdviceEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _messageMeta = const VerificationMeta(
    'message',
  );
  @override
  late final GeneratedColumn<String> message = GeneratedColumn<String>(
    'message',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _authorMeta = const VerificationMeta('author');
  @override
  late final GeneratedColumn<String> author = GeneratedColumn<String>(
    'author',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
    message,
    source,
    author,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'advice_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<AdviceEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('message')) {
      context.handle(
        _messageMeta,
        message.isAcceptableOrUnknown(data['message']!, _messageMeta),
      );
    } else if (isInserting) {
      context.missing(_messageMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('author')) {
      context.handle(
        _authorMeta,
        author.isAcceptableOrUnknown(data['author']!, _authorMeta),
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
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AdviceEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AdviceEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      message: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}message'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      author: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AdviceEntriesTable createAlias(String alias) {
    return $AdviceEntriesTable(attachedDatabase, alias);
  }
}

class AdviceEntry extends DataClass implements Insertable<AdviceEntry> {
  final int id;
  final String message;
  final String source;
  final String? author;
  final DateTime updatedAt;
  const AdviceEntry({
    required this.id,
    required this.message,
    required this.source,
    this.author,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['message'] = Variable<String>(message);
    map['source'] = Variable<String>(source);
    if (!nullToAbsent || author != null) {
      map['author'] = Variable<String>(author);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AdviceEntriesCompanion toCompanion(bool nullToAbsent) {
    return AdviceEntriesCompanion(
      id: Value(id),
      message: Value(message),
      source: Value(source),
      author: author == null && nullToAbsent
          ? const Value.absent()
          : Value(author),
      updatedAt: Value(updatedAt),
    );
  }

  factory AdviceEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AdviceEntry(
      id: serializer.fromJson<int>(json['id']),
      message: serializer.fromJson<String>(json['message']),
      source: serializer.fromJson<String>(json['source']),
      author: serializer.fromJson<String?>(json['author']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'message': serializer.toJson<String>(message),
      'source': serializer.toJson<String>(source),
      'author': serializer.toJson<String?>(author),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AdviceEntry copyWith({
    int? id,
    String? message,
    String? source,
    Value<String?> author = const Value.absent(),
    DateTime? updatedAt,
  }) => AdviceEntry(
    id: id ?? this.id,
    message: message ?? this.message,
    source: source ?? this.source,
    author: author.present ? author.value : this.author,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  AdviceEntry copyWithCompanion(AdviceEntriesCompanion data) {
    return AdviceEntry(
      id: data.id.present ? data.id.value : this.id,
      message: data.message.present ? data.message.value : this.message,
      source: data.source.present ? data.source.value : this.source,
      author: data.author.present ? data.author.value : this.author,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AdviceEntry(')
          ..write('id: $id, ')
          ..write('message: $message, ')
          ..write('source: $source, ')
          ..write('author: $author, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, message, source, author, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AdviceEntry &&
          other.id == this.id &&
          other.message == this.message &&
          other.source == this.source &&
          other.author == this.author &&
          other.updatedAt == this.updatedAt);
}

class AdviceEntriesCompanion extends UpdateCompanion<AdviceEntry> {
  final Value<int> id;
  final Value<String> message;
  final Value<String> source;
  final Value<String?> author;
  final Value<DateTime> updatedAt;
  const AdviceEntriesCompanion({
    this.id = const Value.absent(),
    this.message = const Value.absent(),
    this.source = const Value.absent(),
    this.author = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  AdviceEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String message,
    required String source,
    this.author = const Value.absent(),
    required DateTime updatedAt,
  }) : message = Value(message),
       source = Value(source),
       updatedAt = Value(updatedAt);
  static Insertable<AdviceEntry> custom({
    Expression<int>? id,
    Expression<String>? message,
    Expression<String>? source,
    Expression<String>? author,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (message != null) 'message': message,
      if (source != null) 'source': source,
      if (author != null) 'author': author,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  AdviceEntriesCompanion copyWith({
    Value<int>? id,
    Value<String>? message,
    Value<String>? source,
    Value<String?>? author,
    Value<DateTime>? updatedAt,
  }) {
    return AdviceEntriesCompanion(
      id: id ?? this.id,
      message: message ?? this.message,
      source: source ?? this.source,
      author: author ?? this.author,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (message.present) {
      map['message'] = Variable<String>(message.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (author.present) {
      map['author'] = Variable<String>(author.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AdviceEntriesCompanion(')
          ..write('id: $id, ')
          ..write('message: $message, ')
          ..write('source: $source, ')
          ..write('author: $author, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AdviceDatabase extends GeneratedDatabase {
  _$AdviceDatabase(QueryExecutor e) : super(e);
  $AdviceDatabaseManager get managers => $AdviceDatabaseManager(this);
  late final $AdviceEntriesTable adviceEntries = $AdviceEntriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [adviceEntries];
}

typedef $$AdviceEntriesTableCreateCompanionBuilder =
    AdviceEntriesCompanion Function({
      Value<int> id,
      required String message,
      required String source,
      Value<String?> author,
      required DateTime updatedAt,
    });
typedef $$AdviceEntriesTableUpdateCompanionBuilder =
    AdviceEntriesCompanion Function({
      Value<int> id,
      Value<String> message,
      Value<String> source,
      Value<String?> author,
      Value<DateTime> updatedAt,
    });

class $$AdviceEntriesTableFilterComposer
    extends Composer<_$AdviceDatabase, $AdviceEntriesTable> {
  $$AdviceEntriesTableFilterComposer({
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

  ColumnFilters<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get author => $composableBuilder(
    column: $table.author,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AdviceEntriesTableOrderingComposer
    extends Composer<_$AdviceDatabase, $AdviceEntriesTable> {
  $$AdviceEntriesTableOrderingComposer({
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

  ColumnOrderings<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get author => $composableBuilder(
    column: $table.author,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AdviceEntriesTableAnnotationComposer
    extends Composer<_$AdviceDatabase, $AdviceEntriesTable> {
  $$AdviceEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get message =>
      $composableBuilder(column: $table.message, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get author =>
      $composableBuilder(column: $table.author, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AdviceEntriesTableTableManager
    extends
        RootTableManager<
          _$AdviceDatabase,
          $AdviceEntriesTable,
          AdviceEntry,
          $$AdviceEntriesTableFilterComposer,
          $$AdviceEntriesTableOrderingComposer,
          $$AdviceEntriesTableAnnotationComposer,
          $$AdviceEntriesTableCreateCompanionBuilder,
          $$AdviceEntriesTableUpdateCompanionBuilder,
          (
            AdviceEntry,
            BaseReferences<_$AdviceDatabase, $AdviceEntriesTable, AdviceEntry>,
          ),
          AdviceEntry,
          PrefetchHooks Function()
        > {
  $$AdviceEntriesTableTableManager(
    _$AdviceDatabase db,
    $AdviceEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AdviceEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AdviceEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AdviceEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> message = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String?> author = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => AdviceEntriesCompanion(
                id: id,
                message: message,
                source: source,
                author: author,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String message,
                required String source,
                Value<String?> author = const Value.absent(),
                required DateTime updatedAt,
              }) => AdviceEntriesCompanion.insert(
                id: id,
                message: message,
                source: source,
                author: author,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AdviceEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AdviceDatabase,
      $AdviceEntriesTable,
      AdviceEntry,
      $$AdviceEntriesTableFilterComposer,
      $$AdviceEntriesTableOrderingComposer,
      $$AdviceEntriesTableAnnotationComposer,
      $$AdviceEntriesTableCreateCompanionBuilder,
      $$AdviceEntriesTableUpdateCompanionBuilder,
      (
        AdviceEntry,
        BaseReferences<_$AdviceDatabase, $AdviceEntriesTable, AdviceEntry>,
      ),
      AdviceEntry,
      PrefetchHooks Function()
    >;

class $AdviceDatabaseManager {
  final _$AdviceDatabase _db;
  $AdviceDatabaseManager(this._db);
  $$AdviceEntriesTableTableManager get adviceEntries =>
      $$AdviceEntriesTableTableManager(_db, _db.adviceEntries);
}
