import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';

part 'flutter_chat_ui_database.g.dart';

@DataClassName('FlutterChatSessionEntry')
class FlutterChatSessions extends Table {
  TextColumn get sessionId =>
      text().withLength(min: 1, max: 120).customConstraint('UNIQUE NOT NULL')();

  TextColumn get title => text().withLength(min: 1, max: 160)();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>>? get primaryKey => <Column<Object>>{sessionId};
}

@DataClassName('FlutterChatMessageEntry')
class FlutterChatMessages extends Table {
  IntColumn get localId => integer().autoIncrement()();

  TextColumn get messageId =>
      text().withLength(min: 1, max: 80).customConstraint('UNIQUE NOT NULL')();

  TextColumn get sessionId => text()
      .withLength(min: 1, max: 120)
      .references(FlutterChatSessions, #sessionId)();

  TextColumn get authorId => text().withLength(min: 1, max: 80)();

  TextColumn get body => text().withLength(min: 1, max: 4000)();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get sentAt => dateTime().nullable()();

  DateTimeColumn get updatedAt => dateTime().nullable()();

  TextColumn get payloadJson => text().nullable()();
}

class FlutterChatSessionSummary {
  const FlutterChatSessionSummary({
    required this.sessionId,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    required this.messageCount,
    this.lastMessagePreview,
  });

  final String sessionId;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int messageCount;
  final String? lastMessagePreview;
}

@DriftDatabase(tables: <Type>[FlutterChatSessions, FlutterChatMessages])
class FlutterChatUiDatabase extends _$FlutterChatUiDatabase {
  FlutterChatUiDatabase()
    : super(driftDatabase(name: 'widget_layout_example2_flutter_chat_ui'));

  static const String defaultSessionId = 'session-default';
  static final DateTime _seedBaseTime = DateTime(2026, 5, 4, 10);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator migrator) async {
      await migrator.createAll();
      await _ensureDefaultSession();
    },
    onUpgrade: (Migrator migrator, int from, int to) async {
      if (from < 2) {
        await migrator.addColumn(
          flutterChatMessages,
          flutterChatMessages.updatedAt,
        );
        await migrator.addColumn(
          flutterChatMessages,
          flutterChatMessages.payloadJson,
        );
      }

      if (from < 3) {
        await migrator.createTable(flutterChatSessions);

        await customStatement(
          'ALTER TABLE flutter_chat_messages '
          'ADD COLUMN session_id TEXT NOT NULL DEFAULT '
          "'$defaultSessionId'",
        );

        await customStatement(
          'INSERT OR IGNORE INTO flutter_chat_sessions '
          '(session_id, title, created_at, updated_at) '
          'VALUES (?, ?, ?, ?)',
          <Object>[
            defaultSessionId,
            'Current Chat',
            _seedBaseTime.millisecondsSinceEpoch,
            DateTime.now().millisecondsSinceEpoch,
          ],
        );

        await customStatement(
          'UPDATE flutter_chat_messages '
          'SET session_id = ? '
          'WHERE session_id IS NULL OR session_id = ?',
          <Object>[defaultSessionId, ''],
        );
      }
    },
    beforeOpen: (OpeningDetails details) async {
      await customStatement('PRAGMA foreign_keys = ON');
      await _ensureDefaultSession();
    },
  );

  Future<void> seedDemoData() async {
    final QueryRow row = await customSelect(
      'SELECT COUNT(*) AS item_count FROM flutter_chat_messages',
      readsFrom: <TableInfo<Table, Object?>>{flutterChatMessages},
    ).getSingle();

    if (row.read<int>('item_count') > 0) {
      return;
    }

    await upsertSession(
      sessionId: defaultSessionId,
      title: 'Current Chat',
      createdAt: _seedBaseTime,
      updatedAt: _seedBaseTime,
    );

    await batch((Batch batch) {
      batch.insertAll(flutterChatMessages, <FlutterChatMessagesCompanion>[
        FlutterChatMessagesCompanion.insert(
          messageId: 'seed-1',
          sessionId: defaultSessionId,
          authorId: 'demo-assistant',
          body: 'This module stores chat messages in a local drift database.',
          createdAt: _seedBaseTime,
          sentAt: Value(_seedBaseTime),
          updatedAt: const Value.absent(),
          payloadJson: Value(
            jsonEncode(
              Message.text(
                id: 'seed-1',
                authorId: 'demo-assistant',
                text:
                    'This module stores chat messages in a local drift database.',
                createdAt: _seedBaseTime,
                sentAt: _seedBaseTime,
              ).toJson(),
            ),
          ),
        ),
        FlutterChatMessagesCompanion.insert(
          messageId: 'seed-2',
          sessionId: defaultSessionId,
          authorId: 'flutter-learner',
          body: 'I want flutter_chat_ui to persist messages with SQLite.',
          createdAt: _seedBaseTime.add(const Duration(minutes: 1)),
          sentAt: Value(_seedBaseTime.add(const Duration(minutes: 1))),
          updatedAt: const Value.absent(),
          payloadJson: Value(
            jsonEncode(
              Message.text(
                id: 'seed-2',
                authorId: 'flutter-learner',
                text: 'I want flutter_chat_ui to persist messages with SQLite.',
                createdAt: _seedBaseTime.add(const Duration(minutes: 1)),
                sentAt: _seedBaseTime.add(const Duration(minutes: 1)),
              ).toJson(),
            ),
          ),
        ),
        FlutterChatMessagesCompanion.insert(
          messageId: 'seed-3',
          sessionId: defaultSessionId,
          authorId: 'demo-assistant',
          body:
              'Send a message below. The UI will refresh from a drift watch stream.',
          createdAt: _seedBaseTime.add(const Duration(minutes: 2)),
          sentAt: Value(_seedBaseTime.add(const Duration(minutes: 2))),
          updatedAt: const Value.absent(),
          payloadJson: Value(
            jsonEncode(
              Message.text(
                id: 'seed-3',
                authorId: 'demo-assistant',
                text:
                    'Send a message below. The UI will refresh from a drift watch stream.',
                createdAt: _seedBaseTime.add(const Duration(minutes: 2)),
                sentAt: _seedBaseTime.add(const Duration(minutes: 2)),
              ).toJson(),
            ),
          ),
        ),
      ]);
    });
  }

  Future<void> createSession({
    required String sessionId,
    required String title,
    DateTime? createdAt,
  }) {
    final DateTime now = createdAt ?? DateTime.now();
    return upsertSession(
      sessionId: sessionId,
      title: title,
      createdAt: now,
      updatedAt: now,
    );
  }

  Future<void> upsertSession({
    required String sessionId,
    required String title,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) {
    final FlutterChatSessionsCompanion companion =
        FlutterChatSessionsCompanion.insert(
          sessionId: sessionId,
          title: title,
          createdAt: createdAt,
          updatedAt: updatedAt ?? createdAt,
        );

    return into(flutterChatSessions).insert(
      companion,
      onConflict: DoUpdate(
        (FlutterChatSessions old) => FlutterChatSessionsCompanion(
          title: Value(title),
          createdAt: Value(createdAt),
          updatedAt: Value(updatedAt ?? createdAt),
        ),
        target: <Column<Object>>[flutterChatSessions.sessionId],
      ),
    );
  }

  Future<void> touchSession(
    String sessionId, {
    String? title,
    DateTime? updatedAt,
  }) {
    return (update(flutterChatSessions)..where(
          (FlutterChatSessions table) => table.sessionId.equals(sessionId),
        ))
        .write(
          FlutterChatSessionsCompanion(
            title: title == null ? const Value.absent() : Value(title),
            updatedAt: Value(updatedAt ?? DateTime.now()),
          ),
        );
  }

  Future<String> createNextSession({String? firstMessagePreview}) async {
    final int existingCount = await _sessionCount();
    final DateTime now = DateTime.now();
    final String sessionId = 'session-${now.microsecondsSinceEpoch}';
    final String title = _buildSessionTitle(
      index: existingCount + 1,
      preview: firstMessagePreview,
    );

    await createSession(sessionId: sessionId, title: title, createdAt: now);
    return sessionId;
  }

  Future<void> insertTextMessage({
    required String sessionId,
    required String messageId,
    required String authorId,
    required String text,
    DateTime? createdAt,
    DateTime? sentAt,
    DateTime? updatedAt,
    MessageStatus? status,
    Map<String, dynamic>? metadata,
  }) {
    final Message message = Message.text(
      id: messageId,
      authorId: authorId,
      text: text,
      createdAt: createdAt ?? DateTime.now(),
      sentAt: sentAt,
      updatedAt: updatedAt,
      status: status,
      metadata: metadata,
    );

    return upsertMessage(sessionId: sessionId, message: message);
  }

  Future<void> upsertMessage({
    required String sessionId,
    required Message message,
  }) async {
    final DateTime timestamp = message.createdAt ?? DateTime.now();
    final FlutterChatMessagesCompanion companion =
        FlutterChatMessagesCompanion.insert(
          messageId: message.id,
          sessionId: sessionId,
          authorId: message.authorId,
          body: _extractBody(message),
          createdAt: timestamp,
          sentAt: Value(message.sentAt),
          updatedAt: Value(message.updatedAt),
          payloadJson: Value(jsonEncode(message.toJson())),
        );

    await into(flutterChatMessages).insert(
      companion,
      onConflict: DoUpdate(
        (FlutterChatMessages old) => companion,
        target: <Column<Object>>[flutterChatMessages.messageId],
      ),
    );

    await _touchSessionForMessage(
      sessionId: sessionId,
      message: message,
      fallbackCreatedAt: timestamp,
    );
  }

  Future<void> replaceAllMessages({
    required String sessionId,
    required List<Message> messages,
  }) async {
    await transaction(() async {
      await (delete(flutterChatMessages)..where(
            (FlutterChatMessages table) => table.sessionId.equals(sessionId),
          ))
          .go();
      for (final Message message in messages) {
        await upsertMessage(sessionId: sessionId, message: message);
      }
    });
  }

  Future<List<Message>> getMessages(String sessionId) {
    final SimpleSelectStatement<
      $FlutterChatMessagesTable,
      FlutterChatMessageEntry
    >
    query = select(flutterChatMessages)
      ..where((FlutterChatMessages table) => table.sessionId.equals(sessionId))
      ..orderBy(<OrderingTerm Function(FlutterChatMessages)>[
        (FlutterChatMessages table) => OrderingTerm.asc(table.localId),
      ]);

    return query.get().then(
      (List<FlutterChatMessageEntry> rows) =>
          rows.map(_mapEntryToMessage).toList(),
    );
  }

  Future<void> deleteMessage(String messageId) {
    return (delete(flutterChatMessages)..where(
          (FlutterChatMessages table) => table.messageId.equals(messageId),
        ))
        .go();
  }

  Future<List<FlutterChatSessionSummary>> getSessions() async {
    final List<FlutterChatSessionEntry> sessions = await _orderedSessionsQuery()
        .get();
    return Future.wait(sessions.map(_buildSessionSummary));
  }

  Stream<List<FlutterChatSessionSummary>> watchSessions() {
    return _orderedSessionsQuery().watch().asyncMap(
      (List<FlutterChatSessionEntry> sessions) =>
          Future.wait(sessions.map(_buildSessionSummary)),
    );
  }

  Stream<List<Message>> watchMessages(String sessionId) {
    final SimpleSelectStatement<
      $FlutterChatMessagesTable,
      FlutterChatMessageEntry
    >
    query = select(flutterChatMessages)
      ..where((FlutterChatMessages table) => table.sessionId.equals(sessionId))
      ..orderBy(<OrderingTerm Function(FlutterChatMessages)>[
        (FlutterChatMessages table) => OrderingTerm.asc(table.localId),
      ]);

    return query.watch().map(
      (List<FlutterChatMessageEntry> rows) =>
          rows.map(_mapEntryToMessage).toList(),
    );
  }

  Future<void> _ensureDefaultSession() async {
    final FlutterChatSessionEntry? defaultSession =
        await (select(flutterChatSessions)..where(
              (FlutterChatSessions table) =>
                  table.sessionId.equals(defaultSessionId),
            ))
            .getSingleOrNull();

    if (defaultSession != null) {
      return;
    }

    await into(flutterChatSessions).insert(
      FlutterChatSessionsCompanion.insert(
        sessionId: defaultSessionId,
        title: 'Current Chat',
        createdAt: _seedBaseTime,
        updatedAt: DateTime.now(),
      ),
    );
  }

  SimpleSelectStatement<$FlutterChatSessionsTable, FlutterChatSessionEntry>
  _orderedSessionsQuery() {
    return select(flutterChatSessions)
      ..orderBy(<OrderingTerm Function(FlutterChatSessions)>[
        (FlutterChatSessions table) => OrderingTerm.desc(table.createdAt),
      ]);
  }

  Future<FlutterChatSessionSummary> _buildSessionSummary(
    FlutterChatSessionEntry session,
  ) async {
    final QueryRow countRow = await customSelect(
      'SELECT COUNT(*) AS item_count FROM flutter_chat_messages '
      'WHERE session_id = ?',
      variables: <Variable<Object>>[Variable<String>(session.sessionId)],
      readsFrom: <TableInfo<Table, Object?>>{flutterChatMessages},
    ).getSingle();

    final FlutterChatMessageEntry? lastMessage =
        await ((select(flutterChatMessages)..where(
                (FlutterChatMessages table) =>
                    table.sessionId.equals(session.sessionId),
              ))
              ..orderBy(<OrderingTerm Function(FlutterChatMessages)>[
                (FlutterChatMessages table) =>
                    OrderingTerm.desc(table.createdAt),
                (FlutterChatMessages table) => OrderingTerm.desc(table.localId),
              ])
              ..limit(1))
            .getSingleOrNull();

    final int count = countRow.read<int>('item_count');
    return FlutterChatSessionSummary(
      sessionId: session.sessionId,
      title: session.title,
      createdAt: session.createdAt,
      updatedAt: lastMessage?.createdAt ?? session.updatedAt,
      messageCount: count,
      lastMessagePreview: lastMessage?.body,
    );
  }

  Future<int> _sessionCount() async {
    final QueryRow row = await customSelect(
      'SELECT COUNT(*) AS item_count FROM flutter_chat_sessions',
      readsFrom: <TableInfo<Table, Object?>>{flutterChatSessions},
    ).getSingle();

    return row.read<int>('item_count');
  }

  Future<void> _touchSessionForMessage({
    required String sessionId,
    required Message message,
    required DateTime fallbackCreatedAt,
  }) async {
    final String nextTitle;
    final FlutterChatSessionEntry? session =
        await (select(flutterChatSessions)..where(
              (FlutterChatSessions table) => table.sessionId.equals(sessionId),
            ))
            .getSingleOrNull();

    if (session == null) {
      await createSession(
        sessionId: sessionId,
        title: _buildSessionTitle(index: 1, preview: _extractBody(message)),
        createdAt: fallbackCreatedAt,
      );
      return;
    }

    if (_shouldPromoteSessionTitle(session.title, message.authorId)) {
      nextTitle = _buildSessionTitle(
        index: null,
        preview: _extractBody(message),
      );
    } else {
      nextTitle = session.title;
    }

    await touchSession(
      sessionId,
      title: nextTitle,
      updatedAt: message.updatedAt ?? message.sentAt ?? fallbackCreatedAt,
    );
  }

  bool _shouldPromoteSessionTitle(String currentTitle, String authorId) {
    return authorId != 'demo-assistant' &&
        (currentTitle == 'Current Chat' ||
            currentTitle.startsWith('Conversation '));
  }

  String _buildSessionTitle({required int? index, String? preview}) {
    final String normalizedPreview = (preview ?? '').trim().replaceAll(
      RegExp(r'\s+'),
      ' ',
    );

    if (normalizedPreview.isNotEmpty) {
      return normalizedPreview.length > 28
          ? '${normalizedPreview.substring(0, 28)}...'
          : normalizedPreview;
    }

    if (index == null) {
      return 'Current Chat';
    }

    return index == 1 ? 'Current Chat' : 'Conversation $index';
  }

  Message _mapEntryToMessage(FlutterChatMessageEntry entry) {
    if (entry.payloadJson != null && entry.payloadJson!.isNotEmpty) {
      return Message.fromJson(
        jsonDecode(entry.payloadJson!) as Map<String, dynamic>,
      );
    }

    return Message.text(
      id: entry.messageId,
      authorId: entry.authorId,
      createdAt: entry.createdAt,
      sentAt: entry.sentAt,
      updatedAt: entry.updatedAt,
      text: entry.body,
    );
  }

  String _extractBody(Message message) {
    return message.when(
      text:
          (
            String id,
            String authorId,
            String? replyToMessageId,
            DateTime? createdAt,
            DateTime? deletedAt,
            DateTime? failedAt,
            DateTime? sentAt,
            DateTime? deliveredAt,
            DateTime? seenAt,
            DateTime? updatedAt,
            DateTime? editedAt,
            Map<String, List<String>>? reactions,
            bool? pinned,
            Map<String, dynamic>? metadata,
            MessageStatus? status,
            String text,
            LinkPreviewData? linkPreviewData,
          ) => text,
      textStream:
          (
            String id,
            String authorId,
            String? replyToMessageId,
            DateTime? createdAt,
            DateTime? deletedAt,
            DateTime? failedAt,
            DateTime? sentAt,
            DateTime? deliveredAt,
            DateTime? seenAt,
            DateTime? updatedAt,
            Map<String, List<String>>? reactions,
            bool? pinned,
            Map<String, dynamic>? metadata,
            MessageStatus? status,
            String streamId,
          ) => metadata?['previewText'] as String? ?? '',
      image:
          (
            String id,
            String authorId,
            String? replyToMessageId,
            DateTime? createdAt,
            DateTime? deletedAt,
            DateTime? failedAt,
            DateTime? sentAt,
            DateTime? deliveredAt,
            DateTime? seenAt,
            DateTime? updatedAt,
            Map<String, List<String>>? reactions,
            bool? pinned,
            Map<String, dynamic>? metadata,
            MessageStatus? status,
            String source,
            String? text,
            String? thumbhash,
            String? blurhash,
            double? width,
            double? height,
            int? size,
            bool? hasOverlay,
          ) => text ?? metadata?['fileName'] as String? ?? '[image]',
      file:
          (
            String id,
            String authorId,
            String? replyToMessageId,
            DateTime? createdAt,
            DateTime? deletedAt,
            DateTime? failedAt,
            DateTime? sentAt,
            DateTime? deliveredAt,
            DateTime? seenAt,
            DateTime? updatedAt,
            Map<String, List<String>>? reactions,
            bool? pinned,
            Map<String, dynamic>? metadata,
            MessageStatus? status,
            String source,
            String name,
            int? size,
            String? mimeType,
          ) => name,
      video:
          (
            String id,
            String authorId,
            String? replyToMessageId,
            DateTime? createdAt,
            DateTime? deletedAt,
            DateTime? failedAt,
            DateTime? sentAt,
            DateTime? deliveredAt,
            DateTime? seenAt,
            DateTime? updatedAt,
            Map<String, List<String>>? reactions,
            bool? pinned,
            Map<String, dynamic>? metadata,
            MessageStatus? status,
            String source,
            String? text,
            String? name,
            int? size,
            double? width,
            double? height,
          ) => text ?? name ?? '[video]',
      audio:
          (
            String id,
            String authorId,
            String? replyToMessageId,
            DateTime? createdAt,
            DateTime? deletedAt,
            DateTime? failedAt,
            DateTime? sentAt,
            DateTime? deliveredAt,
            DateTime? seenAt,
            DateTime? updatedAt,
            Map<String, List<String>>? reactions,
            bool? pinned,
            Map<String, dynamic>? metadata,
            MessageStatus? status,
            String source,
            Duration duration,
            String? text,
            int? size,
            List<double>? waveform,
          ) => text ?? '[audio]',
      system:
          (
            String id,
            String authorId,
            String? replyToMessageId,
            DateTime? createdAt,
            DateTime? deletedAt,
            DateTime? failedAt,
            DateTime? sentAt,
            DateTime? deliveredAt,
            DateTime? seenAt,
            DateTime? updatedAt,
            Map<String, List<String>>? reactions,
            bool? pinned,
            Map<String, dynamic>? metadata,
            MessageStatus? status,
            String text,
          ) => text,
      custom:
          (
            String id,
            String authorId,
            String? replyToMessageId,
            DateTime? createdAt,
            DateTime? deletedAt,
            DateTime? failedAt,
            DateTime? sentAt,
            DateTime? deliveredAt,
            DateTime? seenAt,
            DateTime? updatedAt,
            Map<String, List<String>>? reactions,
            bool? pinned,
            Map<String, dynamic>? metadata,
            MessageStatus? status,
          ) => '[custom message]',
      unsupported:
          (
            String id,
            String authorId,
            String? replyToMessageId,
            DateTime? createdAt,
            DateTime? deletedAt,
            DateTime? failedAt,
            DateTime? sentAt,
            DateTime? deliveredAt,
            DateTime? seenAt,
            DateTime? updatedAt,
            Map<String, List<String>>? reactions,
            bool? pinned,
            Map<String, dynamic>? metadata,
            MessageStatus? status,
          ) => '[unsupported message]',
    );
  }
}
