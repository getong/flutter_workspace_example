// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flutter_chat_ui_database.dart';

// ignore_for_file: type=lint
class $FlutterChatMessagesTable extends FlutterChatMessages
    with TableInfo<$FlutterChatMessagesTable, FlutterChatMessageEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FlutterChatMessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _localIdMeta = const VerificationMeta(
    'localId',
  );
  @override
  late final GeneratedColumn<int> localId = GeneratedColumn<int>(
    'local_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _messageIdMeta = const VerificationMeta(
    'messageId',
  );
  @override
  late final GeneratedColumn<String> messageId = GeneratedColumn<String>(
    'message_id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 80,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'UNIQUE NOT NULL',
  );
  static const VerificationMeta _authorIdMeta = const VerificationMeta(
    'authorId',
  );
  @override
  late final GeneratedColumn<String> authorId = GeneratedColumn<String>(
    'author_id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 80,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 4000,
    ),
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
  static const VerificationMeta _sentAtMeta = const VerificationMeta('sentAt');
  @override
  late final GeneratedColumn<DateTime> sentAt = GeneratedColumn<DateTime>(
    'sent_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    localId,
    messageId,
    authorId,
    body,
    createdAt,
    sentAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'flutter_chat_messages';
  @override
  VerificationContext validateIntegrity(
    Insertable<FlutterChatMessageEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('local_id')) {
      context.handle(
        _localIdMeta,
        localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta),
      );
    }
    if (data.containsKey('message_id')) {
      context.handle(
        _messageIdMeta,
        messageId.isAcceptableOrUnknown(data['message_id']!, _messageIdMeta),
      );
    } else if (isInserting) {
      context.missing(_messageIdMeta);
    }
    if (data.containsKey('author_id')) {
      context.handle(
        _authorIdMeta,
        authorId.isAcceptableOrUnknown(data['author_id']!, _authorIdMeta),
      );
    } else if (isInserting) {
      context.missing(_authorIdMeta);
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
    if (data.containsKey('sent_at')) {
      context.handle(
        _sentAtMeta,
        sentAt.isAcceptableOrUnknown(data['sent_at']!, _sentAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {localId};
  @override
  FlutterChatMessageEntry map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FlutterChatMessageEntry(
      localId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}local_id'],
      )!,
      messageId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}message_id'],
      )!,
      authorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author_id'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      sentAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}sent_at'],
      ),
    );
  }

  @override
  $FlutterChatMessagesTable createAlias(String alias) {
    return $FlutterChatMessagesTable(attachedDatabase, alias);
  }
}

class FlutterChatMessageEntry extends DataClass
    implements Insertable<FlutterChatMessageEntry> {
  final int localId;
  final String messageId;
  final String authorId;
  final String body;
  final DateTime createdAt;
  final DateTime? sentAt;
  const FlutterChatMessageEntry({
    required this.localId,
    required this.messageId,
    required this.authorId,
    required this.body,
    required this.createdAt,
    this.sentAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['local_id'] = Variable<int>(localId);
    map['message_id'] = Variable<String>(messageId);
    map['author_id'] = Variable<String>(authorId);
    map['body'] = Variable<String>(body);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || sentAt != null) {
      map['sent_at'] = Variable<DateTime>(sentAt);
    }
    return map;
  }

  FlutterChatMessagesCompanion toCompanion(bool nullToAbsent) {
    return FlutterChatMessagesCompanion(
      localId: Value(localId),
      messageId: Value(messageId),
      authorId: Value(authorId),
      body: Value(body),
      createdAt: Value(createdAt),
      sentAt: sentAt == null && nullToAbsent
          ? const Value.absent()
          : Value(sentAt),
    );
  }

  factory FlutterChatMessageEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FlutterChatMessageEntry(
      localId: serializer.fromJson<int>(json['localId']),
      messageId: serializer.fromJson<String>(json['messageId']),
      authorId: serializer.fromJson<String>(json['authorId']),
      body: serializer.fromJson<String>(json['body']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      sentAt: serializer.fromJson<DateTime?>(json['sentAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'localId': serializer.toJson<int>(localId),
      'messageId': serializer.toJson<String>(messageId),
      'authorId': serializer.toJson<String>(authorId),
      'body': serializer.toJson<String>(body),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'sentAt': serializer.toJson<DateTime?>(sentAt),
    };
  }

  FlutterChatMessageEntry copyWith({
    int? localId,
    String? messageId,
    String? authorId,
    String? body,
    DateTime? createdAt,
    Value<DateTime?> sentAt = const Value.absent(),
  }) => FlutterChatMessageEntry(
    localId: localId ?? this.localId,
    messageId: messageId ?? this.messageId,
    authorId: authorId ?? this.authorId,
    body: body ?? this.body,
    createdAt: createdAt ?? this.createdAt,
    sentAt: sentAt.present ? sentAt.value : this.sentAt,
  );
  FlutterChatMessageEntry copyWithCompanion(FlutterChatMessagesCompanion data) {
    return FlutterChatMessageEntry(
      localId: data.localId.present ? data.localId.value : this.localId,
      messageId: data.messageId.present ? data.messageId.value : this.messageId,
      authorId: data.authorId.present ? data.authorId.value : this.authorId,
      body: data.body.present ? data.body.value : this.body,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      sentAt: data.sentAt.present ? data.sentAt.value : this.sentAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FlutterChatMessageEntry(')
          ..write('localId: $localId, ')
          ..write('messageId: $messageId, ')
          ..write('authorId: $authorId, ')
          ..write('body: $body, ')
          ..write('createdAt: $createdAt, ')
          ..write('sentAt: $sentAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(localId, messageId, authorId, body, createdAt, sentAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FlutterChatMessageEntry &&
          other.localId == this.localId &&
          other.messageId == this.messageId &&
          other.authorId == this.authorId &&
          other.body == this.body &&
          other.createdAt == this.createdAt &&
          other.sentAt == this.sentAt);
}

class FlutterChatMessagesCompanion
    extends UpdateCompanion<FlutterChatMessageEntry> {
  final Value<int> localId;
  final Value<String> messageId;
  final Value<String> authorId;
  final Value<String> body;
  final Value<DateTime> createdAt;
  final Value<DateTime?> sentAt;
  const FlutterChatMessagesCompanion({
    this.localId = const Value.absent(),
    this.messageId = const Value.absent(),
    this.authorId = const Value.absent(),
    this.body = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.sentAt = const Value.absent(),
  });
  FlutterChatMessagesCompanion.insert({
    this.localId = const Value.absent(),
    required String messageId,
    required String authorId,
    required String body,
    required DateTime createdAt,
    this.sentAt = const Value.absent(),
  }) : messageId = Value(messageId),
       authorId = Value(authorId),
       body = Value(body),
       createdAt = Value(createdAt);
  static Insertable<FlutterChatMessageEntry> custom({
    Expression<int>? localId,
    Expression<String>? messageId,
    Expression<String>? authorId,
    Expression<String>? body,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? sentAt,
  }) {
    return RawValuesInsertable({
      if (localId != null) 'local_id': localId,
      if (messageId != null) 'message_id': messageId,
      if (authorId != null) 'author_id': authorId,
      if (body != null) 'body': body,
      if (createdAt != null) 'created_at': createdAt,
      if (sentAt != null) 'sent_at': sentAt,
    });
  }

  FlutterChatMessagesCompanion copyWith({
    Value<int>? localId,
    Value<String>? messageId,
    Value<String>? authorId,
    Value<String>? body,
    Value<DateTime>? createdAt,
    Value<DateTime?>? sentAt,
  }) {
    return FlutterChatMessagesCompanion(
      localId: localId ?? this.localId,
      messageId: messageId ?? this.messageId,
      authorId: authorId ?? this.authorId,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
      sentAt: sentAt ?? this.sentAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (localId.present) {
      map['local_id'] = Variable<int>(localId.value);
    }
    if (messageId.present) {
      map['message_id'] = Variable<String>(messageId.value);
    }
    if (authorId.present) {
      map['author_id'] = Variable<String>(authorId.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (sentAt.present) {
      map['sent_at'] = Variable<DateTime>(sentAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FlutterChatMessagesCompanion(')
          ..write('localId: $localId, ')
          ..write('messageId: $messageId, ')
          ..write('authorId: $authorId, ')
          ..write('body: $body, ')
          ..write('createdAt: $createdAt, ')
          ..write('sentAt: $sentAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$FlutterChatUiDatabase extends GeneratedDatabase {
  _$FlutterChatUiDatabase(QueryExecutor e) : super(e);
  $FlutterChatUiDatabaseManager get managers =>
      $FlutterChatUiDatabaseManager(this);
  late final $FlutterChatMessagesTable flutterChatMessages =
      $FlutterChatMessagesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [flutterChatMessages];
}

typedef $$FlutterChatMessagesTableCreateCompanionBuilder =
    FlutterChatMessagesCompanion Function({
      Value<int> localId,
      required String messageId,
      required String authorId,
      required String body,
      required DateTime createdAt,
      Value<DateTime?> sentAt,
    });
typedef $$FlutterChatMessagesTableUpdateCompanionBuilder =
    FlutterChatMessagesCompanion Function({
      Value<int> localId,
      Value<String> messageId,
      Value<String> authorId,
      Value<String> body,
      Value<DateTime> createdAt,
      Value<DateTime?> sentAt,
    });

class $$FlutterChatMessagesTableFilterComposer
    extends Composer<_$FlutterChatUiDatabase, $FlutterChatMessagesTable> {
  $$FlutterChatMessagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get messageId => $composableBuilder(
    column: $table.messageId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get authorId => $composableBuilder(
    column: $table.authorId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get sentAt => $composableBuilder(
    column: $table.sentAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FlutterChatMessagesTableOrderingComposer
    extends Composer<_$FlutterChatUiDatabase, $FlutterChatMessagesTable> {
  $$FlutterChatMessagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get messageId => $composableBuilder(
    column: $table.messageId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get authorId => $composableBuilder(
    column: $table.authorId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get sentAt => $composableBuilder(
    column: $table.sentAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FlutterChatMessagesTableAnnotationComposer
    extends Composer<_$FlutterChatUiDatabase, $FlutterChatMessagesTable> {
  $$FlutterChatMessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get localId =>
      $composableBuilder(column: $table.localId, builder: (column) => column);

  GeneratedColumn<String> get messageId =>
      $composableBuilder(column: $table.messageId, builder: (column) => column);

  GeneratedColumn<String> get authorId =>
      $composableBuilder(column: $table.authorId, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get sentAt =>
      $composableBuilder(column: $table.sentAt, builder: (column) => column);
}

class $$FlutterChatMessagesTableTableManager
    extends
        RootTableManager<
          _$FlutterChatUiDatabase,
          $FlutterChatMessagesTable,
          FlutterChatMessageEntry,
          $$FlutterChatMessagesTableFilterComposer,
          $$FlutterChatMessagesTableOrderingComposer,
          $$FlutterChatMessagesTableAnnotationComposer,
          $$FlutterChatMessagesTableCreateCompanionBuilder,
          $$FlutterChatMessagesTableUpdateCompanionBuilder,
          (
            FlutterChatMessageEntry,
            BaseReferences<
              _$FlutterChatUiDatabase,
              $FlutterChatMessagesTable,
              FlutterChatMessageEntry
            >,
          ),
          FlutterChatMessageEntry,
          PrefetchHooks Function()
        > {
  $$FlutterChatMessagesTableTableManager(
    _$FlutterChatUiDatabase db,
    $FlutterChatMessagesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FlutterChatMessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FlutterChatMessagesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$FlutterChatMessagesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> localId = const Value.absent(),
                Value<String> messageId = const Value.absent(),
                Value<String> authorId = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> sentAt = const Value.absent(),
              }) => FlutterChatMessagesCompanion(
                localId: localId,
                messageId: messageId,
                authorId: authorId,
                body: body,
                createdAt: createdAt,
                sentAt: sentAt,
              ),
          createCompanionCallback:
              ({
                Value<int> localId = const Value.absent(),
                required String messageId,
                required String authorId,
                required String body,
                required DateTime createdAt,
                Value<DateTime?> sentAt = const Value.absent(),
              }) => FlutterChatMessagesCompanion.insert(
                localId: localId,
                messageId: messageId,
                authorId: authorId,
                body: body,
                createdAt: createdAt,
                sentAt: sentAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FlutterChatMessagesTableProcessedTableManager =
    ProcessedTableManager<
      _$FlutterChatUiDatabase,
      $FlutterChatMessagesTable,
      FlutterChatMessageEntry,
      $$FlutterChatMessagesTableFilterComposer,
      $$FlutterChatMessagesTableOrderingComposer,
      $$FlutterChatMessagesTableAnnotationComposer,
      $$FlutterChatMessagesTableCreateCompanionBuilder,
      $$FlutterChatMessagesTableUpdateCompanionBuilder,
      (
        FlutterChatMessageEntry,
        BaseReferences<
          _$FlutterChatUiDatabase,
          $FlutterChatMessagesTable,
          FlutterChatMessageEntry
        >,
      ),
      FlutterChatMessageEntry,
      PrefetchHooks Function()
    >;

class $FlutterChatUiDatabaseManager {
  final _$FlutterChatUiDatabase _db;
  $FlutterChatUiDatabaseManager(this._db);
  $$FlutterChatMessagesTableTableManager get flutterChatMessages =>
      $$FlutterChatMessagesTableTableManager(_db, _db.flutterChatMessages);
}
