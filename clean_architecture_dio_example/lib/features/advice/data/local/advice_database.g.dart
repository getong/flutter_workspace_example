// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'advice_database.dart';

// ignore_for_file: type=lint
class $AdviceEntriesTable extends AdviceEntries
    with TableInfo<$AdviceEntriesTable, AdviceEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AdviceEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _entryIdMeta = const VerificationMeta(
    'entryId',
  );
  @override
  late final GeneratedColumn<int> entryId = GeneratedColumn<int>(
    'entry_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _adviceIdMeta = const VerificationMeta(
    'adviceId',
  );
  @override
  late final GeneratedColumn<int> adviceId = GeneratedColumn<int>(
    'advice_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
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
    entryId,
    adviceId,
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
    if (data.containsKey('entry_id')) {
      context.handle(
        _entryIdMeta,
        entryId.isAcceptableOrUnknown(data['entry_id']!, _entryIdMeta),
      );
    }
    if (data.containsKey('advice_id')) {
      context.handle(
        _adviceIdMeta,
        adviceId.isAcceptableOrUnknown(data['advice_id']!, _adviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_adviceIdMeta);
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
  Set<GeneratedColumn> get $primaryKey => {entryId};
  @override
  AdviceEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AdviceEntry(
      entryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}entry_id'],
      )!,
      adviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}advice_id'],
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
  final int entryId;
  final int adviceId;
  final String message;
  final String source;
  final String? author;
  final DateTime updatedAt;
  const AdviceEntry({
    required this.entryId,
    required this.adviceId,
    required this.message,
    required this.source,
    this.author,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['entry_id'] = Variable<int>(entryId);
    map['advice_id'] = Variable<int>(adviceId);
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
      entryId: Value(entryId),
      adviceId: Value(adviceId),
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
      entryId: serializer.fromJson<int>(json['entryId']),
      adviceId: serializer.fromJson<int>(json['adviceId']),
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
      'entryId': serializer.toJson<int>(entryId),
      'adviceId': serializer.toJson<int>(adviceId),
      'message': serializer.toJson<String>(message),
      'source': serializer.toJson<String>(source),
      'author': serializer.toJson<String?>(author),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AdviceEntry copyWith({
    int? entryId,
    int? adviceId,
    String? message,
    String? source,
    Value<String?> author = const Value.absent(),
    DateTime? updatedAt,
  }) => AdviceEntry(
    entryId: entryId ?? this.entryId,
    adviceId: adviceId ?? this.adviceId,
    message: message ?? this.message,
    source: source ?? this.source,
    author: author.present ? author.value : this.author,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  AdviceEntry copyWithCompanion(AdviceEntriesCompanion data) {
    return AdviceEntry(
      entryId: data.entryId.present ? data.entryId.value : this.entryId,
      adviceId: data.adviceId.present ? data.adviceId.value : this.adviceId,
      message: data.message.present ? data.message.value : this.message,
      source: data.source.present ? data.source.value : this.source,
      author: data.author.present ? data.author.value : this.author,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AdviceEntry(')
          ..write('entryId: $entryId, ')
          ..write('adviceId: $adviceId, ')
          ..write('message: $message, ')
          ..write('source: $source, ')
          ..write('author: $author, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(entryId, adviceId, message, source, author, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AdviceEntry &&
          other.entryId == this.entryId &&
          other.adviceId == this.adviceId &&
          other.message == this.message &&
          other.source == this.source &&
          other.author == this.author &&
          other.updatedAt == this.updatedAt);
}

class AdviceEntriesCompanion extends UpdateCompanion<AdviceEntry> {
  final Value<int> entryId;
  final Value<int> adviceId;
  final Value<String> message;
  final Value<String> source;
  final Value<String?> author;
  final Value<DateTime> updatedAt;
  const AdviceEntriesCompanion({
    this.entryId = const Value.absent(),
    this.adviceId = const Value.absent(),
    this.message = const Value.absent(),
    this.source = const Value.absent(),
    this.author = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  AdviceEntriesCompanion.insert({
    this.entryId = const Value.absent(),
    required int adviceId,
    required String message,
    required String source,
    this.author = const Value.absent(),
    required DateTime updatedAt,
  }) : adviceId = Value(adviceId),
       message = Value(message),
       source = Value(source),
       updatedAt = Value(updatedAt);
  static Insertable<AdviceEntry> custom({
    Expression<int>? entryId,
    Expression<int>? adviceId,
    Expression<String>? message,
    Expression<String>? source,
    Expression<String>? author,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (entryId != null) 'entry_id': entryId,
      if (adviceId != null) 'advice_id': adviceId,
      if (message != null) 'message': message,
      if (source != null) 'source': source,
      if (author != null) 'author': author,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  AdviceEntriesCompanion copyWith({
    Value<int>? entryId,
    Value<int>? adviceId,
    Value<String>? message,
    Value<String>? source,
    Value<String?>? author,
    Value<DateTime>? updatedAt,
  }) {
    return AdviceEntriesCompanion(
      entryId: entryId ?? this.entryId,
      adviceId: adviceId ?? this.adviceId,
      message: message ?? this.message,
      source: source ?? this.source,
      author: author ?? this.author,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (entryId.present) {
      map['entry_id'] = Variable<int>(entryId.value);
    }
    if (adviceId.present) {
      map['advice_id'] = Variable<int>(adviceId.value);
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
          ..write('entryId: $entryId, ')
          ..write('adviceId: $adviceId, ')
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
      Value<int> entryId,
      required int adviceId,
      required String message,
      required String source,
      Value<String?> author,
      required DateTime updatedAt,
    });
typedef $$AdviceEntriesTableUpdateCompanionBuilder =
    AdviceEntriesCompanion Function({
      Value<int> entryId,
      Value<int> adviceId,
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
  ColumnFilters<int> get entryId => $composableBuilder(
    column: $table.entryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get adviceId => $composableBuilder(
    column: $table.adviceId,
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
  ColumnOrderings<int> get entryId => $composableBuilder(
    column: $table.entryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get adviceId => $composableBuilder(
    column: $table.adviceId,
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
  GeneratedColumn<int> get entryId =>
      $composableBuilder(column: $table.entryId, builder: (column) => column);

  GeneratedColumn<int> get adviceId =>
      $composableBuilder(column: $table.adviceId, builder: (column) => column);

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
                Value<int> entryId = const Value.absent(),
                Value<int> adviceId = const Value.absent(),
                Value<String> message = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String?> author = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => AdviceEntriesCompanion(
                entryId: entryId,
                adviceId: adviceId,
                message: message,
                source: source,
                author: author,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> entryId = const Value.absent(),
                required int adviceId,
                required String message,
                required String source,
                Value<String?> author = const Value.absent(),
                required DateTime updatedAt,
              }) => AdviceEntriesCompanion.insert(
                entryId: entryId,
                adviceId: adviceId,
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
