// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flutter_gen_ai_chat_ui_database.dart';

// ignore_for_file: type=lint
class $FlutterGenAiChatMessagesTable extends FlutterGenAiChatMessages
    with
        TableInfo<
          $FlutterGenAiChatMessagesTable,
          FlutterGenAiChatMessageEntry
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FlutterGenAiChatMessagesTable(this.attachedDatabase, [this._alias]);
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
      maxTextLength: 120,
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
      minTextLength: 0,
      maxTextLength: 12000,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isMarkdownMeta = const VerificationMeta(
    'isMarkdown',
  );
  @override
  late final GeneratedColumn<bool> isMarkdown = GeneratedColumn<bool>(
    'is_markdown',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_markdown" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isLoadingMeta = const VerificationMeta(
    'isLoading',
  );
  @override
  late final GeneratedColumn<bool> isLoading = GeneratedColumn<bool>(
    'is_loading',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_loading" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _loadingKindMeta = const VerificationMeta(
    'loadingKind',
  );
  @override
  late final GeneratedColumn<String> loadingKind = GeneratedColumn<String>(
    'loading_kind',
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
  @override
  List<GeneratedColumn> get $columns => [
    localId,
    messageId,
    authorId,
    body,
    isMarkdown,
    isLoading,
    loadingKind,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'flutter_gen_ai_chat_messages';
  @override
  VerificationContext validateIntegrity(
    Insertable<FlutterGenAiChatMessageEntry> instance, {
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
    if (data.containsKey('is_markdown')) {
      context.handle(
        _isMarkdownMeta,
        isMarkdown.isAcceptableOrUnknown(data['is_markdown']!, _isMarkdownMeta),
      );
    }
    if (data.containsKey('is_loading')) {
      context.handle(
        _isLoadingMeta,
        isLoading.isAcceptableOrUnknown(data['is_loading']!, _isLoadingMeta),
      );
    }
    if (data.containsKey('loading_kind')) {
      context.handle(
        _loadingKindMeta,
        loadingKind.isAcceptableOrUnknown(
          data['loading_kind']!,
          _loadingKindMeta,
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {localId};
  @override
  FlutterGenAiChatMessageEntry map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FlutterGenAiChatMessageEntry(
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
      isMarkdown: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_markdown'],
      )!,
      isLoading: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_loading'],
      )!,
      loadingKind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}loading_kind'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $FlutterGenAiChatMessagesTable createAlias(String alias) {
    return $FlutterGenAiChatMessagesTable(attachedDatabase, alias);
  }
}

class FlutterGenAiChatMessageEntry extends DataClass
    implements Insertable<FlutterGenAiChatMessageEntry> {
  final int localId;
  final String messageId;
  final String authorId;
  final String body;
  final bool isMarkdown;
  final bool isLoading;
  final String? loadingKind;
  final DateTime createdAt;
  const FlutterGenAiChatMessageEntry({
    required this.localId,
    required this.messageId,
    required this.authorId,
    required this.body,
    required this.isMarkdown,
    required this.isLoading,
    this.loadingKind,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['local_id'] = Variable<int>(localId);
    map['message_id'] = Variable<String>(messageId);
    map['author_id'] = Variable<String>(authorId);
    map['body'] = Variable<String>(body);
    map['is_markdown'] = Variable<bool>(isMarkdown);
    map['is_loading'] = Variable<bool>(isLoading);
    if (!nullToAbsent || loadingKind != null) {
      map['loading_kind'] = Variable<String>(loadingKind);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  FlutterGenAiChatMessagesCompanion toCompanion(bool nullToAbsent) {
    return FlutterGenAiChatMessagesCompanion(
      localId: Value(localId),
      messageId: Value(messageId),
      authorId: Value(authorId),
      body: Value(body),
      isMarkdown: Value(isMarkdown),
      isLoading: Value(isLoading),
      loadingKind: loadingKind == null && nullToAbsent
          ? const Value.absent()
          : Value(loadingKind),
      createdAt: Value(createdAt),
    );
  }

  factory FlutterGenAiChatMessageEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FlutterGenAiChatMessageEntry(
      localId: serializer.fromJson<int>(json['localId']),
      messageId: serializer.fromJson<String>(json['messageId']),
      authorId: serializer.fromJson<String>(json['authorId']),
      body: serializer.fromJson<String>(json['body']),
      isMarkdown: serializer.fromJson<bool>(json['isMarkdown']),
      isLoading: serializer.fromJson<bool>(json['isLoading']),
      loadingKind: serializer.fromJson<String?>(json['loadingKind']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
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
      'isMarkdown': serializer.toJson<bool>(isMarkdown),
      'isLoading': serializer.toJson<bool>(isLoading),
      'loadingKind': serializer.toJson<String?>(loadingKind),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  FlutterGenAiChatMessageEntry copyWith({
    int? localId,
    String? messageId,
    String? authorId,
    String? body,
    bool? isMarkdown,
    bool? isLoading,
    Value<String?> loadingKind = const Value.absent(),
    DateTime? createdAt,
  }) => FlutterGenAiChatMessageEntry(
    localId: localId ?? this.localId,
    messageId: messageId ?? this.messageId,
    authorId: authorId ?? this.authorId,
    body: body ?? this.body,
    isMarkdown: isMarkdown ?? this.isMarkdown,
    isLoading: isLoading ?? this.isLoading,
    loadingKind: loadingKind.present ? loadingKind.value : this.loadingKind,
    createdAt: createdAt ?? this.createdAt,
  );
  FlutterGenAiChatMessageEntry copyWithCompanion(
    FlutterGenAiChatMessagesCompanion data,
  ) {
    return FlutterGenAiChatMessageEntry(
      localId: data.localId.present ? data.localId.value : this.localId,
      messageId: data.messageId.present ? data.messageId.value : this.messageId,
      authorId: data.authorId.present ? data.authorId.value : this.authorId,
      body: data.body.present ? data.body.value : this.body,
      isMarkdown: data.isMarkdown.present
          ? data.isMarkdown.value
          : this.isMarkdown,
      isLoading: data.isLoading.present ? data.isLoading.value : this.isLoading,
      loadingKind: data.loadingKind.present
          ? data.loadingKind.value
          : this.loadingKind,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FlutterGenAiChatMessageEntry(')
          ..write('localId: $localId, ')
          ..write('messageId: $messageId, ')
          ..write('authorId: $authorId, ')
          ..write('body: $body, ')
          ..write('isMarkdown: $isMarkdown, ')
          ..write('isLoading: $isLoading, ')
          ..write('loadingKind: $loadingKind, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    localId,
    messageId,
    authorId,
    body,
    isMarkdown,
    isLoading,
    loadingKind,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FlutterGenAiChatMessageEntry &&
          other.localId == this.localId &&
          other.messageId == this.messageId &&
          other.authorId == this.authorId &&
          other.body == this.body &&
          other.isMarkdown == this.isMarkdown &&
          other.isLoading == this.isLoading &&
          other.loadingKind == this.loadingKind &&
          other.createdAt == this.createdAt);
}

class FlutterGenAiChatMessagesCompanion
    extends UpdateCompanion<FlutterGenAiChatMessageEntry> {
  final Value<int> localId;
  final Value<String> messageId;
  final Value<String> authorId;
  final Value<String> body;
  final Value<bool> isMarkdown;
  final Value<bool> isLoading;
  final Value<String?> loadingKind;
  final Value<DateTime> createdAt;
  const FlutterGenAiChatMessagesCompanion({
    this.localId = const Value.absent(),
    this.messageId = const Value.absent(),
    this.authorId = const Value.absent(),
    this.body = const Value.absent(),
    this.isMarkdown = const Value.absent(),
    this.isLoading = const Value.absent(),
    this.loadingKind = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  FlutterGenAiChatMessagesCompanion.insert({
    this.localId = const Value.absent(),
    required String messageId,
    required String authorId,
    required String body,
    this.isMarkdown = const Value.absent(),
    this.isLoading = const Value.absent(),
    this.loadingKind = const Value.absent(),
    required DateTime createdAt,
  }) : messageId = Value(messageId),
       authorId = Value(authorId),
       body = Value(body),
       createdAt = Value(createdAt);
  static Insertable<FlutterGenAiChatMessageEntry> custom({
    Expression<int>? localId,
    Expression<String>? messageId,
    Expression<String>? authorId,
    Expression<String>? body,
    Expression<bool>? isMarkdown,
    Expression<bool>? isLoading,
    Expression<String>? loadingKind,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (localId != null) 'local_id': localId,
      if (messageId != null) 'message_id': messageId,
      if (authorId != null) 'author_id': authorId,
      if (body != null) 'body': body,
      if (isMarkdown != null) 'is_markdown': isMarkdown,
      if (isLoading != null) 'is_loading': isLoading,
      if (loadingKind != null) 'loading_kind': loadingKind,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  FlutterGenAiChatMessagesCompanion copyWith({
    Value<int>? localId,
    Value<String>? messageId,
    Value<String>? authorId,
    Value<String>? body,
    Value<bool>? isMarkdown,
    Value<bool>? isLoading,
    Value<String?>? loadingKind,
    Value<DateTime>? createdAt,
  }) {
    return FlutterGenAiChatMessagesCompanion(
      localId: localId ?? this.localId,
      messageId: messageId ?? this.messageId,
      authorId: authorId ?? this.authorId,
      body: body ?? this.body,
      isMarkdown: isMarkdown ?? this.isMarkdown,
      isLoading: isLoading ?? this.isLoading,
      loadingKind: loadingKind ?? this.loadingKind,
      createdAt: createdAt ?? this.createdAt,
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
    if (isMarkdown.present) {
      map['is_markdown'] = Variable<bool>(isMarkdown.value);
    }
    if (isLoading.present) {
      map['is_loading'] = Variable<bool>(isLoading.value);
    }
    if (loadingKind.present) {
      map['loading_kind'] = Variable<String>(loadingKind.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FlutterGenAiChatMessagesCompanion(')
          ..write('localId: $localId, ')
          ..write('messageId: $messageId, ')
          ..write('authorId: $authorId, ')
          ..write('body: $body, ')
          ..write('isMarkdown: $isMarkdown, ')
          ..write('isLoading: $isLoading, ')
          ..write('loadingKind: $loadingKind, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$FlutterGenAiChatUiDatabase extends GeneratedDatabase {
  _$FlutterGenAiChatUiDatabase(QueryExecutor e) : super(e);
  $FlutterGenAiChatUiDatabaseManager get managers =>
      $FlutterGenAiChatUiDatabaseManager(this);
  late final $FlutterGenAiChatMessagesTable flutterGenAiChatMessages =
      $FlutterGenAiChatMessagesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    flutterGenAiChatMessages,
  ];
}

typedef $$FlutterGenAiChatMessagesTableCreateCompanionBuilder =
    FlutterGenAiChatMessagesCompanion Function({
      Value<int> localId,
      required String messageId,
      required String authorId,
      required String body,
      Value<bool> isMarkdown,
      Value<bool> isLoading,
      Value<String?> loadingKind,
      required DateTime createdAt,
    });
typedef $$FlutterGenAiChatMessagesTableUpdateCompanionBuilder =
    FlutterGenAiChatMessagesCompanion Function({
      Value<int> localId,
      Value<String> messageId,
      Value<String> authorId,
      Value<String> body,
      Value<bool> isMarkdown,
      Value<bool> isLoading,
      Value<String?> loadingKind,
      Value<DateTime> createdAt,
    });

class $$FlutterGenAiChatMessagesTableFilterComposer
    extends
        Composer<_$FlutterGenAiChatUiDatabase, $FlutterGenAiChatMessagesTable> {
  $$FlutterGenAiChatMessagesTableFilterComposer({
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

  ColumnFilters<bool> get isMarkdown => $composableBuilder(
    column: $table.isMarkdown,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isLoading => $composableBuilder(
    column: $table.isLoading,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get loadingKind => $composableBuilder(
    column: $table.loadingKind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FlutterGenAiChatMessagesTableOrderingComposer
    extends
        Composer<_$FlutterGenAiChatUiDatabase, $FlutterGenAiChatMessagesTable> {
  $$FlutterGenAiChatMessagesTableOrderingComposer({
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

  ColumnOrderings<bool> get isMarkdown => $composableBuilder(
    column: $table.isMarkdown,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isLoading => $composableBuilder(
    column: $table.isLoading,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get loadingKind => $composableBuilder(
    column: $table.loadingKind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FlutterGenAiChatMessagesTableAnnotationComposer
    extends
        Composer<_$FlutterGenAiChatUiDatabase, $FlutterGenAiChatMessagesTable> {
  $$FlutterGenAiChatMessagesTableAnnotationComposer({
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

  GeneratedColumn<bool> get isMarkdown => $composableBuilder(
    column: $table.isMarkdown,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isLoading =>
      $composableBuilder(column: $table.isLoading, builder: (column) => column);

  GeneratedColumn<String> get loadingKind => $composableBuilder(
    column: $table.loadingKind,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$FlutterGenAiChatMessagesTableTableManager
    extends
        RootTableManager<
          _$FlutterGenAiChatUiDatabase,
          $FlutterGenAiChatMessagesTable,
          FlutterGenAiChatMessageEntry,
          $$FlutterGenAiChatMessagesTableFilterComposer,
          $$FlutterGenAiChatMessagesTableOrderingComposer,
          $$FlutterGenAiChatMessagesTableAnnotationComposer,
          $$FlutterGenAiChatMessagesTableCreateCompanionBuilder,
          $$FlutterGenAiChatMessagesTableUpdateCompanionBuilder,
          (
            FlutterGenAiChatMessageEntry,
            BaseReferences<
              _$FlutterGenAiChatUiDatabase,
              $FlutterGenAiChatMessagesTable,
              FlutterGenAiChatMessageEntry
            >,
          ),
          FlutterGenAiChatMessageEntry,
          PrefetchHooks Function()
        > {
  $$FlutterGenAiChatMessagesTableTableManager(
    _$FlutterGenAiChatUiDatabase db,
    $FlutterGenAiChatMessagesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FlutterGenAiChatMessagesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$FlutterGenAiChatMessagesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$FlutterGenAiChatMessagesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> localId = const Value.absent(),
                Value<String> messageId = const Value.absent(),
                Value<String> authorId = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<bool> isMarkdown = const Value.absent(),
                Value<bool> isLoading = const Value.absent(),
                Value<String?> loadingKind = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => FlutterGenAiChatMessagesCompanion(
                localId: localId,
                messageId: messageId,
                authorId: authorId,
                body: body,
                isMarkdown: isMarkdown,
                isLoading: isLoading,
                loadingKind: loadingKind,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> localId = const Value.absent(),
                required String messageId,
                required String authorId,
                required String body,
                Value<bool> isMarkdown = const Value.absent(),
                Value<bool> isLoading = const Value.absent(),
                Value<String?> loadingKind = const Value.absent(),
                required DateTime createdAt,
              }) => FlutterGenAiChatMessagesCompanion.insert(
                localId: localId,
                messageId: messageId,
                authorId: authorId,
                body: body,
                isMarkdown: isMarkdown,
                isLoading: isLoading,
                loadingKind: loadingKind,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FlutterGenAiChatMessagesTableProcessedTableManager =
    ProcessedTableManager<
      _$FlutterGenAiChatUiDatabase,
      $FlutterGenAiChatMessagesTable,
      FlutterGenAiChatMessageEntry,
      $$FlutterGenAiChatMessagesTableFilterComposer,
      $$FlutterGenAiChatMessagesTableOrderingComposer,
      $$FlutterGenAiChatMessagesTableAnnotationComposer,
      $$FlutterGenAiChatMessagesTableCreateCompanionBuilder,
      $$FlutterGenAiChatMessagesTableUpdateCompanionBuilder,
      (
        FlutterGenAiChatMessageEntry,
        BaseReferences<
          _$FlutterGenAiChatUiDatabase,
          $FlutterGenAiChatMessagesTable,
          FlutterGenAiChatMessageEntry
        >,
      ),
      FlutterGenAiChatMessageEntry,
      PrefetchHooks Function()
    >;

class $FlutterGenAiChatUiDatabaseManager {
  final _$FlutterGenAiChatUiDatabase _db;
  $FlutterGenAiChatUiDatabaseManager(this._db);
  $$FlutterGenAiChatMessagesTableTableManager get flutterGenAiChatMessages =>
      $$FlutterGenAiChatMessagesTableTableManager(
        _db,
        _db.flutterGenAiChatMessages,
      );
}
