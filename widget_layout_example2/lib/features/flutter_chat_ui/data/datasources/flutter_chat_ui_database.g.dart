// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flutter_chat_ui_database.dart';

// ignore_for_file: type=lint
class $FlutterChatSessionsTable extends FlutterChatSessions
    with TableInfo<$FlutterChatSessionsTable, FlutterChatSessionEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FlutterChatSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
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
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 160,
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
    sessionId,
    title,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'flutter_chat_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<FlutterChatSessionEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
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
  Set<GeneratedColumn> get $primaryKey => {sessionId};
  @override
  FlutterChatSessionEntry map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FlutterChatSessionEntry(
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
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
  $FlutterChatSessionsTable createAlias(String alias) {
    return $FlutterChatSessionsTable(attachedDatabase, alias);
  }
}

class FlutterChatSessionEntry extends DataClass
    implements Insertable<FlutterChatSessionEntry> {
  final String sessionId;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;
  const FlutterChatSessionEntry({
    required this.sessionId,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['session_id'] = Variable<String>(sessionId);
    map['title'] = Variable<String>(title);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  FlutterChatSessionsCompanion toCompanion(bool nullToAbsent) {
    return FlutterChatSessionsCompanion(
      sessionId: Value(sessionId),
      title: Value(title),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory FlutterChatSessionEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FlutterChatSessionEntry(
      sessionId: serializer.fromJson<String>(json['sessionId']),
      title: serializer.fromJson<String>(json['title']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'sessionId': serializer.toJson<String>(sessionId),
      'title': serializer.toJson<String>(title),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  FlutterChatSessionEntry copyWith({
    String? sessionId,
    String? title,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => FlutterChatSessionEntry(
    sessionId: sessionId ?? this.sessionId,
    title: title ?? this.title,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  FlutterChatSessionEntry copyWithCompanion(FlutterChatSessionsCompanion data) {
    return FlutterChatSessionEntry(
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      title: data.title.present ? data.title.value : this.title,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FlutterChatSessionEntry(')
          ..write('sessionId: $sessionId, ')
          ..write('title: $title, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(sessionId, title, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FlutterChatSessionEntry &&
          other.sessionId == this.sessionId &&
          other.title == this.title &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class FlutterChatSessionsCompanion
    extends UpdateCompanion<FlutterChatSessionEntry> {
  final Value<String> sessionId;
  final Value<String> title;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const FlutterChatSessionsCompanion({
    this.sessionId = const Value.absent(),
    this.title = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FlutterChatSessionsCompanion.insert({
    required String sessionId,
    required String title,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : sessionId = Value(sessionId),
       title = Value(title),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<FlutterChatSessionEntry> custom({
    Expression<String>? sessionId,
    Expression<String>? title,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (sessionId != null) 'session_id': sessionId,
      if (title != null) 'title': title,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FlutterChatSessionsCompanion copyWith({
    Value<String>? sessionId,
    Value<String>? title,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return FlutterChatSessionsCompanion(
      sessionId: sessionId ?? this.sessionId,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
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
    return (StringBuffer('FlutterChatSessionsCompanion(')
          ..write('sessionId: $sessionId, ')
          ..write('title: $title, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

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
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES flutter_chat_sessions (session_id)',
    ),
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
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    localId,
    messageId,
    sessionId,
    authorId,
    body,
    createdAt,
    sentAt,
    updatedAt,
    payloadJson,
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
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
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
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
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
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
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
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
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
  final String sessionId;
  final String authorId;
  final String body;
  final DateTime createdAt;
  final DateTime? sentAt;
  final DateTime? updatedAt;
  final String? payloadJson;
  const FlutterChatMessageEntry({
    required this.localId,
    required this.messageId,
    required this.sessionId,
    required this.authorId,
    required this.body,
    required this.createdAt,
    this.sentAt,
    this.updatedAt,
    this.payloadJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['local_id'] = Variable<int>(localId);
    map['message_id'] = Variable<String>(messageId);
    map['session_id'] = Variable<String>(sessionId);
    map['author_id'] = Variable<String>(authorId);
    map['body'] = Variable<String>(body);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || sentAt != null) {
      map['sent_at'] = Variable<DateTime>(sentAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    if (!nullToAbsent || payloadJson != null) {
      map['payload_json'] = Variable<String>(payloadJson);
    }
    return map;
  }

  FlutterChatMessagesCompanion toCompanion(bool nullToAbsent) {
    return FlutterChatMessagesCompanion(
      localId: Value(localId),
      messageId: Value(messageId),
      sessionId: Value(sessionId),
      authorId: Value(authorId),
      body: Value(body),
      createdAt: Value(createdAt),
      sentAt: sentAt == null && nullToAbsent
          ? const Value.absent()
          : Value(sentAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      payloadJson: payloadJson == null && nullToAbsent
          ? const Value.absent()
          : Value(payloadJson),
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
      sessionId: serializer.fromJson<String>(json['sessionId']),
      authorId: serializer.fromJson<String>(json['authorId']),
      body: serializer.fromJson<String>(json['body']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      sentAt: serializer.fromJson<DateTime?>(json['sentAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      payloadJson: serializer.fromJson<String?>(json['payloadJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'localId': serializer.toJson<int>(localId),
      'messageId': serializer.toJson<String>(messageId),
      'sessionId': serializer.toJson<String>(sessionId),
      'authorId': serializer.toJson<String>(authorId),
      'body': serializer.toJson<String>(body),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'sentAt': serializer.toJson<DateTime?>(sentAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'payloadJson': serializer.toJson<String?>(payloadJson),
    };
  }

  FlutterChatMessageEntry copyWith({
    int? localId,
    String? messageId,
    String? sessionId,
    String? authorId,
    String? body,
    DateTime? createdAt,
    Value<DateTime?> sentAt = const Value.absent(),
    Value<DateTime?> updatedAt = const Value.absent(),
    Value<String?> payloadJson = const Value.absent(),
  }) => FlutterChatMessageEntry(
    localId: localId ?? this.localId,
    messageId: messageId ?? this.messageId,
    sessionId: sessionId ?? this.sessionId,
    authorId: authorId ?? this.authorId,
    body: body ?? this.body,
    createdAt: createdAt ?? this.createdAt,
    sentAt: sentAt.present ? sentAt.value : this.sentAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
    payloadJson: payloadJson.present ? payloadJson.value : this.payloadJson,
  );
  FlutterChatMessageEntry copyWithCompanion(FlutterChatMessagesCompanion data) {
    return FlutterChatMessageEntry(
      localId: data.localId.present ? data.localId.value : this.localId,
      messageId: data.messageId.present ? data.messageId.value : this.messageId,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      authorId: data.authorId.present ? data.authorId.value : this.authorId,
      body: data.body.present ? data.body.value : this.body,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      sentAt: data.sentAt.present ? data.sentAt.value : this.sentAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FlutterChatMessageEntry(')
          ..write('localId: $localId, ')
          ..write('messageId: $messageId, ')
          ..write('sessionId: $sessionId, ')
          ..write('authorId: $authorId, ')
          ..write('body: $body, ')
          ..write('createdAt: $createdAt, ')
          ..write('sentAt: $sentAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('payloadJson: $payloadJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    localId,
    messageId,
    sessionId,
    authorId,
    body,
    createdAt,
    sentAt,
    updatedAt,
    payloadJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FlutterChatMessageEntry &&
          other.localId == this.localId &&
          other.messageId == this.messageId &&
          other.sessionId == this.sessionId &&
          other.authorId == this.authorId &&
          other.body == this.body &&
          other.createdAt == this.createdAt &&
          other.sentAt == this.sentAt &&
          other.updatedAt == this.updatedAt &&
          other.payloadJson == this.payloadJson);
}

class FlutterChatMessagesCompanion
    extends UpdateCompanion<FlutterChatMessageEntry> {
  final Value<int> localId;
  final Value<String> messageId;
  final Value<String> sessionId;
  final Value<String> authorId;
  final Value<String> body;
  final Value<DateTime> createdAt;
  final Value<DateTime?> sentAt;
  final Value<DateTime?> updatedAt;
  final Value<String?> payloadJson;
  const FlutterChatMessagesCompanion({
    this.localId = const Value.absent(),
    this.messageId = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.authorId = const Value.absent(),
    this.body = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.sentAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.payloadJson = const Value.absent(),
  });
  FlutterChatMessagesCompanion.insert({
    this.localId = const Value.absent(),
    required String messageId,
    required String sessionId,
    required String authorId,
    required String body,
    required DateTime createdAt,
    this.sentAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.payloadJson = const Value.absent(),
  }) : messageId = Value(messageId),
       sessionId = Value(sessionId),
       authorId = Value(authorId),
       body = Value(body),
       createdAt = Value(createdAt);
  static Insertable<FlutterChatMessageEntry> custom({
    Expression<int>? localId,
    Expression<String>? messageId,
    Expression<String>? sessionId,
    Expression<String>? authorId,
    Expression<String>? body,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? sentAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? payloadJson,
  }) {
    return RawValuesInsertable({
      if (localId != null) 'local_id': localId,
      if (messageId != null) 'message_id': messageId,
      if (sessionId != null) 'session_id': sessionId,
      if (authorId != null) 'author_id': authorId,
      if (body != null) 'body': body,
      if (createdAt != null) 'created_at': createdAt,
      if (sentAt != null) 'sent_at': sentAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (payloadJson != null) 'payload_json': payloadJson,
    });
  }

  FlutterChatMessagesCompanion copyWith({
    Value<int>? localId,
    Value<String>? messageId,
    Value<String>? sessionId,
    Value<String>? authorId,
    Value<String>? body,
    Value<DateTime>? createdAt,
    Value<DateTime?>? sentAt,
    Value<DateTime?>? updatedAt,
    Value<String?>? payloadJson,
  }) {
    return FlutterChatMessagesCompanion(
      localId: localId ?? this.localId,
      messageId: messageId ?? this.messageId,
      sessionId: sessionId ?? this.sessionId,
      authorId: authorId ?? this.authorId,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
      sentAt: sentAt ?? this.sentAt,
      updatedAt: updatedAt ?? this.updatedAt,
      payloadJson: payloadJson ?? this.payloadJson,
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
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
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
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FlutterChatMessagesCompanion(')
          ..write('localId: $localId, ')
          ..write('messageId: $messageId, ')
          ..write('sessionId: $sessionId, ')
          ..write('authorId: $authorId, ')
          ..write('body: $body, ')
          ..write('createdAt: $createdAt, ')
          ..write('sentAt: $sentAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('payloadJson: $payloadJson')
          ..write(')'))
        .toString();
  }
}

abstract class _$FlutterChatUiDatabase extends GeneratedDatabase {
  _$FlutterChatUiDatabase(QueryExecutor e) : super(e);
  $FlutterChatUiDatabaseManager get managers =>
      $FlutterChatUiDatabaseManager(this);
  late final $FlutterChatSessionsTable flutterChatSessions =
      $FlutterChatSessionsTable(this);
  late final $FlutterChatMessagesTable flutterChatMessages =
      $FlutterChatMessagesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    flutterChatSessions,
    flutterChatMessages,
  ];
}

typedef $$FlutterChatSessionsTableCreateCompanionBuilder =
    FlutterChatSessionsCompanion Function({
      required String sessionId,
      required String title,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$FlutterChatSessionsTableUpdateCompanionBuilder =
    FlutterChatSessionsCompanion Function({
      Value<String> sessionId,
      Value<String> title,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$FlutterChatSessionsTableReferences
    extends
        BaseReferences<
          _$FlutterChatUiDatabase,
          $FlutterChatSessionsTable,
          FlutterChatSessionEntry
        > {
  $$FlutterChatSessionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $FlutterChatMessagesTable,
    List<FlutterChatMessageEntry>
  >
  _flutterChatMessagesRefsTable(
    _$FlutterChatUiDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.flutterChatMessages,
    aliasName:
        'flutter_chat_sessions__session_id__flutter_chat_messages__session_id',
  );

  $$FlutterChatMessagesTableProcessedTableManager get flutterChatMessagesRefs {
    final manager =
        $$FlutterChatMessagesTableTableManager(
          $_db,
          $_db.flutterChatMessages,
        ).filter(
          (f) => f.sessionId.sessionId.sqlEquals(
            $_itemColumn<String>('session_id')!,
          ),
        );

    final cache = $_typedResult.readTableOrNull(
      _flutterChatMessagesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$FlutterChatSessionsTableFilterComposer
    extends Composer<_$FlutterChatUiDatabase, $FlutterChatSessionsTable> {
  $$FlutterChatSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
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

  Expression<bool> flutterChatMessagesRefs(
    Expression<bool> Function($$FlutterChatMessagesTableFilterComposer f) f,
  ) {
    final $$FlutterChatMessagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.flutterChatMessages,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FlutterChatMessagesTableFilterComposer(
            $db: $db,
            $table: $db.flutterChatMessages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FlutterChatSessionsTableOrderingComposer
    extends Composer<_$FlutterChatUiDatabase, $FlutterChatSessionsTable> {
  $$FlutterChatSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
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

class $$FlutterChatSessionsTableAnnotationComposer
    extends Composer<_$FlutterChatUiDatabase, $FlutterChatSessionsTable> {
  $$FlutterChatSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> flutterChatMessagesRefs<T extends Object>(
    Expression<T> Function($$FlutterChatMessagesTableAnnotationComposer a) f,
  ) {
    final $$FlutterChatMessagesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.sessionId,
          referencedTable: $db.flutterChatMessages,
          getReferencedColumn: (t) => t.sessionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$FlutterChatMessagesTableAnnotationComposer(
                $db: $db,
                $table: $db.flutterChatMessages,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$FlutterChatSessionsTableTableManager
    extends
        RootTableManager<
          _$FlutterChatUiDatabase,
          $FlutterChatSessionsTable,
          FlutterChatSessionEntry,
          $$FlutterChatSessionsTableFilterComposer,
          $$FlutterChatSessionsTableOrderingComposer,
          $$FlutterChatSessionsTableAnnotationComposer,
          $$FlutterChatSessionsTableCreateCompanionBuilder,
          $$FlutterChatSessionsTableUpdateCompanionBuilder,
          (FlutterChatSessionEntry, $$FlutterChatSessionsTableReferences),
          FlutterChatSessionEntry,
          PrefetchHooks Function({bool flutterChatMessagesRefs})
        > {
  $$FlutterChatSessionsTableTableManager(
    _$FlutterChatUiDatabase db,
    $FlutterChatSessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FlutterChatSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FlutterChatSessionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$FlutterChatSessionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> sessionId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FlutterChatSessionsCompanion(
                sessionId: sessionId,
                title: title,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String sessionId,
                required String title,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => FlutterChatSessionsCompanion.insert(
                sessionId: sessionId,
                title: title,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FlutterChatSessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({flutterChatMessagesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (flutterChatMessagesRefs) db.flutterChatMessages,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (flutterChatMessagesRefs)
                    await $_getPrefetchedData<
                      FlutterChatSessionEntry,
                      $FlutterChatSessionsTable,
                      FlutterChatMessageEntry
                    >(
                      currentTable: table,
                      referencedTable: $$FlutterChatSessionsTableReferences
                          ._flutterChatMessagesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$FlutterChatSessionsTableReferences(
                            db,
                            table,
                            p0,
                          ).flutterChatMessagesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.sessionId == item.sessionId,
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

typedef $$FlutterChatSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$FlutterChatUiDatabase,
      $FlutterChatSessionsTable,
      FlutterChatSessionEntry,
      $$FlutterChatSessionsTableFilterComposer,
      $$FlutterChatSessionsTableOrderingComposer,
      $$FlutterChatSessionsTableAnnotationComposer,
      $$FlutterChatSessionsTableCreateCompanionBuilder,
      $$FlutterChatSessionsTableUpdateCompanionBuilder,
      (FlutterChatSessionEntry, $$FlutterChatSessionsTableReferences),
      FlutterChatSessionEntry,
      PrefetchHooks Function({bool flutterChatMessagesRefs})
    >;
typedef $$FlutterChatMessagesTableCreateCompanionBuilder =
    FlutterChatMessagesCompanion Function({
      Value<int> localId,
      required String messageId,
      required String sessionId,
      required String authorId,
      required String body,
      required DateTime createdAt,
      Value<DateTime?> sentAt,
      Value<DateTime?> updatedAt,
      Value<String?> payloadJson,
    });
typedef $$FlutterChatMessagesTableUpdateCompanionBuilder =
    FlutterChatMessagesCompanion Function({
      Value<int> localId,
      Value<String> messageId,
      Value<String> sessionId,
      Value<String> authorId,
      Value<String> body,
      Value<DateTime> createdAt,
      Value<DateTime?> sentAt,
      Value<DateTime?> updatedAt,
      Value<String?> payloadJson,
    });

final class $$FlutterChatMessagesTableReferences
    extends
        BaseReferences<
          _$FlutterChatUiDatabase,
          $FlutterChatMessagesTable,
          FlutterChatMessageEntry
        > {
  $$FlutterChatMessagesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $FlutterChatSessionsTable _sessionIdTable(
    _$FlutterChatUiDatabase db,
  ) => db.flutterChatSessions.createAlias(
    'flutter_chat_messages__session_id__flutter_chat_sessions__session_id',
  );

  $$FlutterChatSessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<String>('session_id')!;

    final manager = $$FlutterChatSessionsTableTableManager(
      $_db,
      $_db.flutterChatSessions,
    ).filter((f) => f.sessionId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

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

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  $$FlutterChatSessionsTableFilterComposer get sessionId {
    final $$FlutterChatSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.flutterChatSessions,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FlutterChatSessionsTableFilterComposer(
            $db: $db,
            $table: $db.flutterChatSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
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

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  $$FlutterChatSessionsTableOrderingComposer get sessionId {
    final $$FlutterChatSessionsTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.sessionId,
          referencedTable: $db.flutterChatSessions,
          getReferencedColumn: (t) => t.sessionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$FlutterChatSessionsTableOrderingComposer(
                $db: $db,
                $table: $db.flutterChatSessions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
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

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  $$FlutterChatSessionsTableAnnotationComposer get sessionId {
    final $$FlutterChatSessionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.sessionId,
          referencedTable: $db.flutterChatSessions,
          getReferencedColumn: (t) => t.sessionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$FlutterChatSessionsTableAnnotationComposer(
                $db: $db,
                $table: $db.flutterChatSessions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
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
          (FlutterChatMessageEntry, $$FlutterChatMessagesTableReferences),
          FlutterChatMessageEntry,
          PrefetchHooks Function({bool sessionId})
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
                Value<String> sessionId = const Value.absent(),
                Value<String> authorId = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> sentAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<String?> payloadJson = const Value.absent(),
              }) => FlutterChatMessagesCompanion(
                localId: localId,
                messageId: messageId,
                sessionId: sessionId,
                authorId: authorId,
                body: body,
                createdAt: createdAt,
                sentAt: sentAt,
                updatedAt: updatedAt,
                payloadJson: payloadJson,
              ),
          createCompanionCallback:
              ({
                Value<int> localId = const Value.absent(),
                required String messageId,
                required String sessionId,
                required String authorId,
                required String body,
                required DateTime createdAt,
                Value<DateTime?> sentAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<String?> payloadJson = const Value.absent(),
              }) => FlutterChatMessagesCompanion.insert(
                localId: localId,
                messageId: messageId,
                sessionId: sessionId,
                authorId: authorId,
                body: body,
                createdAt: createdAt,
                sentAt: sentAt,
                updatedAt: updatedAt,
                payloadJson: payloadJson,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FlutterChatMessagesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sessionId = false}) {
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
                    if (sessionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.sessionId,
                                referencedTable:
                                    $$FlutterChatMessagesTableReferences
                                        ._sessionIdTable(db),
                                referencedColumn:
                                    $$FlutterChatMessagesTableReferences
                                        ._sessionIdTable(db)
                                        .sessionId,
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
      (FlutterChatMessageEntry, $$FlutterChatMessagesTableReferences),
      FlutterChatMessageEntry,
      PrefetchHooks Function({bool sessionId})
    >;

class $FlutterChatUiDatabaseManager {
  final _$FlutterChatUiDatabase _db;
  $FlutterChatUiDatabaseManager(this._db);
  $$FlutterChatSessionsTableTableManager get flutterChatSessions =>
      $$FlutterChatSessionsTableTableManager(_db, _db.flutterChatSessions);
  $$FlutterChatMessagesTableTableManager get flutterChatMessages =>
      $$FlutterChatMessagesTableTableManager(_db, _db.flutterChatMessages);
}
