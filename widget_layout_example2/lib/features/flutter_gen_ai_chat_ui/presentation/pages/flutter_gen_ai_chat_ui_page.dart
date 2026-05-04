import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';
import 'package:widget_layout_example2/app_navigation.dart';
import 'package:widget_layout_example2/features/flutter_gen_ai_chat_ui/data/datasources/flutter_gen_ai_chat_ui_database.dart';

@RoutePage(name: RouteName.flutterGenAiChatUi)
class FlutterGenAiChatUiPage extends StatefulWidget {
  const FlutterGenAiChatUiPage({super.key});

  @override
  State<FlutterGenAiChatUiPage> createState() => _FlutterGenAiChatUiPageState();
}

class _FlutterGenAiChatUiPageState extends State<FlutterGenAiChatUiPage> {
  static const ChatUser _currentUser = ChatUser(
    id: 'flutter-learner',
    name: 'Flutter Learner',
    role: 'user',
  );

  static const ChatUser _aiUser = ChatUser(
    id: 'demo-ai',
    name: 'Demo Assistant',
    role: 'assistant',
  );

  late final FlutterGenAiChatUiDatabase _database;
  late final ChatMessagesController _controller;
  late final TextEditingController _inputController;
  late final FocusNode _inputFocusNode;
  StreamSubscription<List<ChatMessage>>? _messageSubscription;
  bool _isGeneratingReply = false;
  int _messageSeed = 0;

  @override
  void initState() {
    super.initState();
    _database = FlutterGenAiChatUiDatabase();
    _controller = ChatMessagesController(
      paginationConfig: const PaginationConfig(reverseOrder: false),
    );
    _inputController = TextEditingController();
    _inputFocusNode = FocusNode();
    _messageSubscription = _database
        .watchMessages(currentUser: _currentUser, aiUser: _aiUser)
        .listen((List<ChatMessage> messages) {
          _controller.setMessages(messages);
        });
    unawaited(_database.seedDemoData());
  }

  @override
  void dispose() {
    _messageSubscription?.cancel();
    _inputController.dispose();
    _inputFocusNode.dispose();
    _controller.dispose();
    _database.close();
    super.dispose();
  }

  String _nextMessageId(String prefix) {
    _messageSeed += 1;
    return '$prefix-${DateTime.now().microsecondsSinceEpoch}-$_messageSeed';
  }

  Future<void> _handleSendMessage(ChatMessage message) async {
    final String trimmed = message.text.trim();
    if (trimmed.isEmpty) {
      return;
    }

    final DateTime now = DateTime.now();
    final String userMessageId =
        message.customProperties?['id'] as String? ?? _nextMessageId('user');

    await _database.insertMessage(
      messageId: userMessageId,
      authorId: _currentUser.id,
      body: trimmed,
      createdAt: now,
    );

    final String loadingMessageId = _nextMessageId('ai');
    await _database.insertMessage(
      messageId: loadingMessageId,
      authorId: _aiUser.id,
      body: 'Thinking about: $trimmed',
      isLoading: true,
      loadingKind: 'analysis',
      createdAt: now.add(const Duration(milliseconds: 1)),
    );

    if (mounted) {
      setState(() {
        _isGeneratingReply = true;
      });
    }

    unawaited(
      _simulateAiReply(userText: trimmed, loadingMessageId: loadingMessageId),
    );
  }

  Future<void> _simulateAiReply({
    required String userText,
    required String loadingMessageId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 950));

    final String reply = _buildReply(userText);
    final bool isMarkdown =
        reply.contains('`') || reply.contains('- ') || reply.contains('1.');

    await _database.updateMessage(
      messageId: loadingMessageId,
      body: reply,
      isLoading: false,
      isMarkdown: isMarkdown,
      loadingKind: null,
    );

    if (mounted) {
      setState(() {
        _isGeneratingReply = false;
      });
    }
  }

  String _buildReply(String userText) {
    final String lower = userText.toLowerCase();

    if (lower.contains('drift') || lower.contains('sqlite')) {
      return '''
drift is the persistence layer here:

- user messages are inserted into SQLite
- the loading placeholder is also inserted into SQLite
- the final AI reply updates that same row

That means reopening the page still restores the conversation history.
''';
    }

    if (lower.contains('loading') || lower.contains('stream')) {
      return '''
This demo uses `ChatMessage.loading(...)` in a database-backed way:

1. insert a loading row into drift
2. map that row into a loading `ChatMessage`
3. update the same row with the final answer

The widget never becomes the source of truth.
''';
    }

    if (lower.contains('markdown') || lower.contains('code')) {
      return '''
`flutter_gen_ai_chat_ui` can render markdown content directly.

Example:

```dart
final controller = ChatMessagesController();
```

- set `isMarkdown: true` on stored rows
- map them back to `ChatMessage`
- let `AiChatWidget` render the formatted content
''';
    }

    return '''
This page demonstrates three layers working together:

1. `AiChatWidget` renders the conversation UI.
2. `ChatMessagesController` mirrors the latest message list into the widget.
3. drift stores every message so the database remains the single source of truth.

Try asking about `drift`, `loading`, or `markdown`.
''';
  }

  Future<void> _clearConversation() async {
    await _database.clearMessages();
    await _database.seedDemoData();
  }

  Future<void> _sendFromShortcut() async {
    final String text = _inputController.text.trim();
    if (text.isEmpty) {
      return;
    }

    _controller.hideWelcomeMessage();

    final ChatMessage message = ChatMessage(
      text: text,
      user: _currentUser,
      createdAt: DateTime.now(),
      customProperties: <String, dynamic>{
        'id': _nextMessageId('user'),
        'isUserMessage': true,
      },
    );

    _inputController.clear();
    await _handleSendMessage(message);
    if (mounted) {
      _inputFocusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final bool isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('flutter_gen_ai_chat_ui + drift Module'),
        actions: <Widget>[
          IconButton(
            onPressed: _clearConversation,
            tooltip: 'Reset demo',
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            SelectionArea(
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'flutter_gen_ai_chat_ui renders the AI chat surface, while drift stores the conversation as the single source of truth.',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'This demo writes user and AI messages into SQLite, then streams those rows back into `ChatMessagesController` for display.',
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: <Widget>[
                          Chip(
                            avatar: const Icon(Icons.storage, size: 18),
                            label: const Text('drift stores all messages'),
                            backgroundColor: colorScheme.surfaceContainerHigh,
                          ),
                          Chip(
                            avatar: const Icon(Icons.sync, size: 18),
                            label: const Text('watch stream -> controller'),
                            backgroundColor: colorScheme.surfaceContainerHigh,
                          ),
                          Chip(
                            avatar: Icon(
                              _isGeneratingReply
                                  ? Icons.hourglass_top
                                  : Icons.check_circle_outline,
                              size: 18,
                            ),
                            label: Text(
                              _isGeneratingReply
                                  ? 'AI placeholder active'
                                  : 'AI idle',
                            ),
                            backgroundColor: colorScheme.surfaceContainerHigh,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final bool showPersistentSuggestions =
                      constraints.maxHeight >= 320;

                  return Shortcuts(
                    shortcuts: const <ShortcutActivator, Intent>{
                      SingleActivator(LogicalKeyboardKey.enter, control: true):
                          ActivateIntent(),
                    },
                    child: Actions(
                      actions: <Type, Action<Intent>>{
                        ActivateIntent: CallbackAction<ActivateIntent>(
                          onInvoke: (ActivateIntent intent) {
                            _sendFromShortcut();
                            return null;
                          },
                        ),
                      },
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        child: AiChatWidget(
                          currentUser: _currentUser,
                          aiUser: _aiUser,
                          controller: _controller,
                          onSendMessage: _handleSendMessage,
                          aiName: 'Demo Assistant',
                          paginationConfig: const PaginationConfig(
                            reverseOrder: false,
                          ),
                          messageListOptions: const MessageListOptions(
                            paginationConfig: PaginationConfig(
                              reverseOrder: false,
                            ),
                          ),
                          enableAnimation: true,
                          enableMarkdownStreaming: true,
                          persistentExampleQuestions: showPersistentSuggestions,
                          loadingConfig: LoadingConfig(
                            isLoading: _isGeneratingReply,
                            loadingIndicator: const LoadingWidget(
                              texts: <String>[
                                'Querying local history...',
                                'Composing SQLite-backed answer...',
                              ],
                            ),
                          ),
                          inputOptions: InputOptions(
                            textController: _inputController,
                            focusNode: _inputFocusNode,
                            sendOnEnter: false,
                            decoration: InputDecoration(
                              hintText:
                                  'Ask about drift, loading, markdown...  Ctrl+Enter to send',
                              hintStyle: TextStyle(
                                color: isDark ? Colors.white38 : Colors.black45,
                              ),
                              filled: true,
                              fillColor: isDark
                                  ? const Color(0xFF23242B)
                                  : colorScheme.surfaceContainerLow,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 14,
                              ),
                            ),
                            sendButtonIcon: Icons.arrow_upward_rounded,
                            sendButtonColor: colorScheme.primary,
                          ),
                          welcomeMessageConfig: WelcomeMessageConfig(
                            title: 'drift-backed AI Chat Demo',
                            titleStyle: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                            questionsSectionTitle: 'Try these prompts',
                            questionsSectionTitleStyle:
                                theme.textTheme.labelLarge,
                            containerDecoration: BoxDecoration(
                              color: colorScheme.surface,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: colorScheme.outlineVariant,
                              ),
                            ),
                          ),
                          exampleQuestions: const <ExampleQuestion>[
                            ExampleQuestion(
                              question:
                                  'How does drift store chat history here?',
                            ),
                            ExampleQuestion(
                              question: 'How is loading state persisted?',
                            ),
                            ExampleQuestion(
                              question: 'Show a markdown example with code',
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
