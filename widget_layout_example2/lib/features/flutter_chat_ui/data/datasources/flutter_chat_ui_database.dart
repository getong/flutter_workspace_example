import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';

part 'flutter_chat_ui_database.g.dart';

@DataClassName('FlutterChatMessageEntry')
class FlutterChatMessages extends Table {
  IntColumn get localId => integer().autoIncrement()();

  TextColumn get messageId =>
      text().withLength(min: 1, max: 80).customConstraint('UNIQUE NOT NULL')();

  TextColumn get authorId => text().withLength(min: 1, max: 80)();

  TextColumn get body => text().withLength(min: 1, max: 4000)();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get sentAt => dateTime().nullable()();

  DateTimeColumn get updatedAt => dateTime().nullable()();

  TextColumn get payloadJson => text().nullable()();
}

@DriftDatabase(tables: <Type>[FlutterChatMessages])
class FlutterChatUiDatabase extends _$FlutterChatUiDatabase {
  FlutterChatUiDatabase()
    : super(driftDatabase(name: 'widget_layout_example2_flutter_chat_ui'));

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator migrator) async {
      await migrator.createAll();
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

    await batch((Batch batch) {
      batch.insertAll(flutterChatMessages, <FlutterChatMessagesCompanion>[
        FlutterChatMessagesCompanion.insert(
          messageId: 'seed-1',
          authorId: 'demo-assistant',
          body: 'This module stores chat messages in a local drift database.',
          createdAt: DateTime(2026, 5, 4, 10, 0),
          sentAt: Value(DateTime(2026, 5, 4, 10, 0)),
          updatedAt: const Value.absent(),
          payloadJson: Value(
            jsonEncode(
              Message.text(
                id: 'seed-1',
                authorId: 'demo-assistant',
                text:
                    'This module stores chat messages in a local drift database.',
                createdAt: DateTime(2026, 5, 4, 10, 0),
                sentAt: DateTime(2026, 5, 4, 10, 0),
              ).toJson(),
            ),
          ),
        ),
        FlutterChatMessagesCompanion.insert(
          messageId: 'seed-2',
          authorId: 'flutter-learner',
          body: 'I want flutter_chat_ui to persist messages with SQLite.',
          createdAt: DateTime(2026, 5, 4, 10, 1),
          sentAt: Value(DateTime(2026, 5, 4, 10, 1)),
          updatedAt: const Value.absent(),
          payloadJson: Value(
            jsonEncode(
              Message.text(
                id: 'seed-2',
                authorId: 'flutter-learner',
                text: 'I want flutter_chat_ui to persist messages with SQLite.',
                createdAt: DateTime(2026, 5, 4, 10, 1),
                sentAt: DateTime(2026, 5, 4, 10, 1),
              ).toJson(),
            ),
          ),
        ),
        FlutterChatMessagesCompanion.insert(
          messageId: 'seed-3',
          authorId: 'demo-assistant',
          body:
              'Send a message below. The UI will refresh from a drift watch stream.',
          createdAt: DateTime(2026, 5, 4, 10, 2),
          sentAt: Value(DateTime(2026, 5, 4, 10, 2)),
          updatedAt: const Value.absent(),
          payloadJson: Value(
            jsonEncode(
              Message.text(
                id: 'seed-3',
                authorId: 'demo-assistant',
                text:
                    'Send a message below. The UI will refresh from a drift watch stream.',
                createdAt: DateTime(2026, 5, 4, 10, 2),
                sentAt: DateTime(2026, 5, 4, 10, 2),
              ).toJson(),
            ),
          ),
        ),
      ]);
    });
  }

  Future<void> insertTextMessage({
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

    return upsertMessage(message);
  }

  Future<void> upsertMessage(Message message) {
    final DateTime timestamp = message.createdAt ?? DateTime.now();
    final FlutterChatMessagesCompanion companion =
        FlutterChatMessagesCompanion.insert(
          messageId: message.id,
          authorId: message.authorId,
          body: _extractBody(message),
          createdAt: timestamp,
          sentAt: Value(message.sentAt),
          updatedAt: Value(message.updatedAt),
          payloadJson: Value(jsonEncode(message.toJson())),
        );

    return into(flutterChatMessages).insert(
      companion,
      onConflict: DoUpdate(
        (FlutterChatMessages old) => companion,
        target: <Column<Object>>[flutterChatMessages.messageId],
      ),
    );
  }

  Future<void> replaceAllMessages(List<Message> messages) async {
    await transaction(() async {
      await delete(flutterChatMessages).go();
      for (final Message message in messages) {
        await upsertMessage(message);
      }
    });
  }

  Future<List<Message>> getMessages() {
    final SimpleSelectStatement<
      $FlutterChatMessagesTable,
      FlutterChatMessageEntry
    >
    query = select(flutterChatMessages)
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

  Stream<List<Message>> watchMessages() {
    final SimpleSelectStatement<
      $FlutterChatMessagesTable,
      FlutterChatMessageEntry
    >
    query = select(flutterChatMessages)
      ..orderBy(<OrderingTerm Function(FlutterChatMessages)>[
        (FlutterChatMessages table) => OrderingTerm.asc(table.localId),
      ]);

    return query.watch().map(
      (List<FlutterChatMessageEntry> rows) =>
          rows.map(_mapEntryToMessage).toList(),
    );
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
          ) => text ?? '[image]',
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
