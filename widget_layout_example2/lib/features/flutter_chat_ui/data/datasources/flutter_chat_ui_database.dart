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
}

@DriftDatabase(tables: <Type>[FlutterChatMessages])
class FlutterChatUiDatabase extends _$FlutterChatUiDatabase {
  FlutterChatUiDatabase()
    : super(driftDatabase(name: 'widget_layout_example2_flutter_chat_ui'));

  @override
  int get schemaVersion => 1;

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
        ),
        FlutterChatMessagesCompanion.insert(
          messageId: 'seed-2',
          authorId: 'flutter-learner',
          body: 'I want flutter_chat_ui to persist messages with SQLite.',
          createdAt: DateTime(2026, 5, 4, 10, 1),
          sentAt: Value(DateTime(2026, 5, 4, 10, 1)),
        ),
        FlutterChatMessagesCompanion.insert(
          messageId: 'seed-3',
          authorId: 'demo-assistant',
          body:
              'Send a message below. The UI will refresh from a drift watch stream.',
          createdAt: DateTime(2026, 5, 4, 10, 2),
          sentAt: Value(DateTime(2026, 5, 4, 10, 2)),
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
  }) {
    final DateTime timestamp = createdAt ?? DateTime.now();
    return into(flutterChatMessages).insert(
      FlutterChatMessagesCompanion.insert(
        messageId: messageId,
        authorId: authorId,
        body: text,
        createdAt: timestamp,
        sentAt: Value(sentAt),
      ),
    );
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
    return Message.text(
      id: entry.messageId,
      authorId: entry.authorId,
      createdAt: entry.createdAt,
      sentAt: entry.sentAt,
      text: entry.body,
    );
  }
}
