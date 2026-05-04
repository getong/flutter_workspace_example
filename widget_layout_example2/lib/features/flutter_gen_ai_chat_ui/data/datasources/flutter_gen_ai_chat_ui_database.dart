import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';

part 'flutter_gen_ai_chat_ui_database.g.dart';

@DataClassName('FlutterGenAiChatMessageEntry')
class FlutterGenAiChatMessages extends Table {
  IntColumn get localId => integer().autoIncrement()();

  TextColumn get messageId =>
      text().withLength(min: 1, max: 120).customConstraint('UNIQUE NOT NULL')();

  TextColumn get authorId => text().withLength(min: 1, max: 80)();

  TextColumn get body => text().withLength(min: 0, max: 12000)();

  BoolColumn get isMarkdown => boolean().withDefault(const Constant(false))();

  BoolColumn get isLoading => boolean().withDefault(const Constant(false))();

  TextColumn get loadingKind => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();
}

@DriftDatabase(tables: <Type>[FlutterGenAiChatMessages])
class FlutterGenAiChatUiDatabase extends _$FlutterGenAiChatUiDatabase {
  FlutterGenAiChatUiDatabase()
    : super(
        driftDatabase(name: 'widget_layout_example2_flutter_gen_ai_chat_ui'),
      );

  @override
  int get schemaVersion => 1;

  Future<void> seedDemoData() async {
    final QueryRow row = await customSelect(
      'SELECT COUNT(*) AS item_count FROM flutter_gen_ai_chat_messages',
      readsFrom: <TableInfo<Table, Object?>>{flutterGenAiChatMessages},
    ).getSingle();

    if (row.read<int>('item_count') > 0) {
      return;
    }

    await batch((Batch batch) {
      batch.insertAll(flutterGenAiChatMessages, <
        FlutterGenAiChatMessagesCompanion
      >[
        FlutterGenAiChatMessagesCompanion.insert(
          messageId: 'seed-ai-1',
          authorId: 'demo-ai',
          body:
              'This module uses drift as the source of truth, and `AiChatWidget` only renders what the database stream emits.',
          isMarkdown: const Value(false),
          isLoading: const Value(false),
          createdAt: DateTime(2026, 5, 4, 10, 0),
        ),
        FlutterGenAiChatMessagesCompanion.insert(
          messageId: 'seed-user-1',
          authorId: 'flutter-learner',
          body:
              'So the chat history survives page rebuilds because the messages come from SQLite?',
          isMarkdown: const Value(false),
          isLoading: const Value(false),
          createdAt: DateTime(2026, 5, 4, 10, 1),
        ),
        FlutterGenAiChatMessagesCompanion.insert(
          messageId: 'seed-ai-2',
          authorId: 'demo-ai',
          body:
              'Yes. This page also demonstrates `ChatMessage.loading(...)` by saving a loading row first, then updating that same row into the final AI answer.',
          isMarkdown: const Value(true),
          isLoading: const Value(false),
          createdAt: DateTime(2026, 5, 4, 10, 2),
        ),
      ]);
    });
  }

  Future<void> insertMessage({
    required String messageId,
    required String authorId,
    required String body,
    required DateTime createdAt,
    bool isMarkdown = false,
    bool isLoading = false,
    String? loadingKind,
  }) {
    return into(flutterGenAiChatMessages).insert(
      FlutterGenAiChatMessagesCompanion.insert(
        messageId: messageId,
        authorId: authorId,
        body: body,
        isMarkdown: Value(isMarkdown),
        isLoading: Value(isLoading),
        loadingKind: Value(loadingKind),
        createdAt: createdAt,
      ),
    );
  }

  Future<void> updateMessage({
    required String messageId,
    required String body,
    bool? isMarkdown,
    bool? isLoading,
    String? loadingKind,
  }) {
    return (update(flutterGenAiChatMessages)..where(
          (FlutterGenAiChatMessages table) => table.messageId.equals(messageId),
        ))
        .write(
          FlutterGenAiChatMessagesCompanion(
            body: Value(body),
            isMarkdown: isMarkdown == null
                ? const Value.absent()
                : Value(isMarkdown),
            isLoading: isLoading == null
                ? const Value.absent()
                : Value(isLoading),
            loadingKind: Value(loadingKind),
          ),
        );
  }

  Future<void> clearMessages() => delete(flutterGenAiChatMessages).go();

  Stream<List<ChatMessage>> watchMessages({
    required ChatUser currentUser,
    required ChatUser aiUser,
  }) {
    final SimpleSelectStatement<
      $FlutterGenAiChatMessagesTable,
      FlutterGenAiChatMessageEntry
    >
    query = select(flutterGenAiChatMessages)
      ..orderBy(<OrderingTerm Function(FlutterGenAiChatMessages)>[
        (FlutterGenAiChatMessages table) => OrderingTerm.asc(table.localId),
      ]);

    return query.watch().map(
      (List<FlutterGenAiChatMessageEntry> rows) => rows
          .map(
            (FlutterGenAiChatMessageEntry row) => _mapEntryToMessage(
              row,
              currentUser: currentUser,
              aiUser: aiUser,
            ),
          )
          .toList(),
    );
  }

  ChatMessage _mapEntryToMessage(
    FlutterGenAiChatMessageEntry entry, {
    required ChatUser currentUser,
    required ChatUser aiUser,
  }) {
    final ChatUser user = entry.authorId == currentUser.id
        ? currentUser
        : aiUser;
    final Map<String, dynamic> customProperties = <String, dynamic>{
      'id': entry.messageId,
      'isUserMessage': entry.authorId == currentUser.id,
    };

    if (entry.isLoading) {
      final Map<String, dynamic> loadingProperties = <String, dynamic>{
        ...customProperties,
        'isLoading': true,
        if (entry.loadingKind != null) 'loadingKind': entry.loadingKind,
      };

      return ChatMessage.loading(
        user: user,
        id: entry.messageId,
        text: entry.body,
        loadingKind: entry.loadingKind,
        createdAt: entry.createdAt,
      ).copyWith(customProperties: loadingProperties);
    }

    return ChatMessage(
      text: entry.body,
      user: user,
      createdAt: entry.createdAt,
      isMarkdown: entry.isMarkdown,
      customProperties: customProperties,
    );
  }
}
