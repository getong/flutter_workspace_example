import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:widget_layout_example2/app_navigation.dart';
import 'package:widget_layout_example2/features/flutter_chat_ui/data/controllers/drift_flutter_chat_ui_controller.dart';
import 'package:widget_layout_example2/features/flutter_chat_ui/data/datasources/flutter_chat_ui_database.dart';

@RoutePage(name: RouteName.flutterChatUi)
class FlutterChatUiPage extends StatefulWidget {
  const FlutterChatUiPage({super.key});

  @override
  State<FlutterChatUiPage> createState() => _FlutterChatUiPageState();
}

class _FlutterChatUiPageState extends State<FlutterChatUiPage> {
  static const List<String> _emojiChoices = <String>[
    '😀',
    '😂',
    '😍',
    '🤔',
    '👏',
    '🔥',
    '🎉',
    '👍',
  ];

  static const String _currentUserId = 'flutter-learner';
  static const String _assistantUserId = 'demo-assistant';

  final Map<String, User> _users = <String, User>{
    _currentUserId: const User(
      id: _currentUserId,
      name: 'Flutter Learner',
      imageSource: 'https://i.pravatar.cc/160?img=12',
    ),
    _assistantUserId: const User(
      id: _assistantUserId,
      name: 'Chat Demo',
      imageSource: 'https://i.pravatar.cc/160?img=5',
    ),
  };

  late final FlutterChatUiDatabase _chatDatabase;
  late final DriftFlutterChatUiController _chatController;
  Timer? _assistantReplyTimer;
  int _messageSeed = 0;
  bool _isGeneratingReply = false;

  @override
  void initState() {
    super.initState();
    _chatDatabase = FlutterChatUiDatabase();
    _chatController = DriftFlutterChatUiController(database: _chatDatabase);
    unawaited(_initializeChat());
  }

  @override
  void dispose() {
    _assistantReplyTimer?.cancel();
    _chatController.dispose();
    _chatDatabase.close();
    super.dispose();
  }

  Future<void> _initializeChat() async {
    await _chatDatabase.seedDemoData();
    await _chatController.loadInitialMessages();
  }

  String _nextMessageId() {
    _messageSeed += 1;
    return 'message-${DateTime.now().microsecondsSinceEpoch}-$_messageSeed';
  }

  Future<User> _resolveUser(String userId) async {
    final User? user = _users[userId];
    if (user == null) {
      return User(id: userId, name: userId);
    }
    return user;
  }

  Future<void> _handleMessageSend(String text) async {
    final String trimmed = text.trim();
    if (trimmed.isEmpty) {
      return;
    }

    await _chatController.insertMessage(
      Message.text(
        id: _nextMessageId(),
        authorId: _currentUserId,
        text: trimmed,
        createdAt: DateTime.now(),
        sentAt: DateTime.now(),
        status: MessageStatus.sent,
      ),
    );

    final String assistantMessageId = _nextMessageId();
    await _chatController.insertMessage(
      Message.text(
        id: assistantMessageId,
        authorId: _assistantUserId,
        text: 'Thinking...',
        createdAt: DateTime.now(),
        metadata: const <String, dynamic>{'sending': true},
        status: MessageStatus.sending,
      ),
    );

    if (mounted) {
      setState(() {
        _isGeneratingReply = true;
      });
    }

    unawaited(_simulateAssistantReply(trimmed, assistantMessageId));
  }

  Future<void> _simulateAssistantReply(
    String userText,
    String assistantMessageId,
  ) async {
    _assistantReplyTimer?.cancel();
    _assistantReplyTimer = Timer(const Duration(milliseconds: 700), () async {
      if (!mounted) {
        return;
      }

      final String lowerText = userText.toLowerCase();
      final String replyText;
      if (lowerText.contains('theme')) {
        replyText =
            'The chat colors and bubble shape are customized through `ChatTheme.fromThemeData(...).copyWith(...)`.';
      } else if (lowerText.contains('controller') ||
          lowerText.contains('state')) {
        replyText =
            'This enhanced example uses a drift-backed ChatController, so insert and update operations stay aligned with SQLite persistence.';
      } else if (lowerText.contains('user')) {
        replyText =
            'The `Chat` widget asks for `currentUserId` and `resolveUser`, so message authors stay lightweight.';
      } else if (lowerText.contains('drift') || lowerText.contains('sqlite')) {
        replyText =
            'Like the OneChatGPT sample, this module now inserts a placeholder assistant message first and then updates that same drift row.';
      } else if (lowerText.contains('stop') || lowerText.contains('cancel')) {
        replyText =
            'While the placeholder is active, use the stop button to cancel generation and update that pending assistant message.';
      } else {
        replyText =
            'This example wires flutter_chat_ui, drift persistence, a custom drift-backed controller, and assistant placeholder updates into one flow.';
      }

      final Message oldMessage = _chatController.messages.singleWhere(
        (Message message) => message.id == assistantMessageId,
      );

      await _chatController.updateMessage(
        oldMessage,
        Message.text(
          id: assistantMessageId,
          authorId: _assistantUserId,
          text: replyText,
          createdAt: oldMessage.createdAt,
          sentAt: DateTime.now(),
          updatedAt: DateTime.now(),
          status: MessageStatus.sent,
        ),
      );

      if (mounted) {
        setState(() {
          _isGeneratingReply = false;
        });
      }
    });
  }

  Future<void> _stopAssistantReply() async {
    if (!_isGeneratingReply) {
      return;
    }

    _assistantReplyTimer?.cancel();

    final List<Message> pendingMessages = _chatController.messages
        .where((Message message) => message.metadata?['sending'] == true)
        .toList();

    for (final Message pendingMessage in pendingMessages) {
      await _chatController.updateMessage(
        pendingMessage,
        Message.text(
          id: pendingMessage.id,
          authorId: pendingMessage.authorId,
          text: 'Generation stopped.',
          createdAt: pendingMessage.createdAt,
          updatedAt: DateTime.now(),
          status: MessageStatus.error,
        ),
      );
    }

    if (mounted) {
      setState(() {
        _isGeneratingReply = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final ChatTheme chatTheme = ChatTheme.fromThemeData(theme).copyWith(
      colors: ChatColors.fromThemeData(theme).copyWith(
        primary: colorScheme.primary,
        onPrimary: colorScheme.onPrimary,
        surface: colorScheme.surface,
        onSurface: colorScheme.onSurface,
        surfaceContainer: colorScheme.surfaceContainer,
        surfaceContainerLow: colorScheme.surfaceContainerLow,
        surfaceContainerHigh: colorScheme.surfaceContainerHigh,
      ),
      shape: const BorderRadius.all(Radius.circular(18)),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('flutter_chat_ui Module'),
        actions: <Widget>[
          IconButton(
            onPressed: () => context.router.replacePath('/'),
            icon: const Icon(Icons.home),
            tooltip: 'Home',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Card(
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'flutter_chat_ui renders the chat surface, while flutter_chat_core provides the message models, controller, and theme primitives.',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'This enhanced demo uses a drift-backed chat controller, inserts a placeholder assistant message first, and updates that same SQLite row when the reply completes.',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_isGeneratingReply)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton.icon(
                    onPressed: _stopAssistantReply,
                    icon: const Icon(Icons.stop_circle_outlined),
                    label: const Text('Stop Generation'),
                  ),
                ),
              ),
            Expanded(
              child: BlocProvider<_EmojiComposerCubit>(
                create: (_) => _EmojiComposerCubit(),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: Chat(
                    currentUserId: _currentUserId,
                    resolveUser: _resolveUser,
                    chatController: _chatController,
                    theme: chatTheme,
                    builders: Builders(
                      composerBuilder: (BuildContext context) => _EmojiComposer(
                        emojiChoices: _emojiChoices,
                        isGeneratingReply: _isGeneratingReply,
                      ),
                    ),
                    onMessageSend: _handleMessageSend,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmojiComposer extends StatefulWidget {
  const _EmojiComposer({
    required this.emojiChoices,
    required this.isGeneratingReply,
  });

  final List<String> emojiChoices;
  final bool isGeneratingReply;

  @override
  State<_EmojiComposer> createState() => _EmojiComposerState();
}

class _EmojiComposerState extends State<_EmojiComposer> {
  final GlobalKey _composerKey = GlobalKey();
  late final TextEditingController _textController;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _focusNode = FocusNode();
    _textController.addListener(_handleControllerChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureComposer());
  }

  @override
  void dispose() {
    _textController.removeListener(_handleControllerChanged);
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ChatTheme theme = context.read<ChatTheme>();
    final OnMessageSendCallback? onMessageSend = context
        .read<OnMessageSendCallback?>();
    final double bottomSafeArea = MediaQuery.of(context).padding.bottom;
    final Color iconColor = theme.colors.onSurface.withValues(alpha: 0.65);

    return BlocBuilder<_EmojiComposerCubit, _EmojiComposerStateData>(
      builder: (BuildContext context, _EmojiComposerStateData state) {
        final bool canSend =
            _textController.text.trim().isNotEmpty ||
            state.selectedEmoji != null;

        return Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            key: _composerKey,
            color: theme.colors.surfaceContainerLow.withValues(alpha: 0.96),
            padding: EdgeInsets.fromLTRB(8, 8, 8, 8 + bottomSafeArea),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (state.showEmojiPicker)
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colors.surfaceContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Choose an emoji',
                          style: theme.typography.labelLarge.copyWith(
                            color: theme.colors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: widget.emojiChoices.map((String emoji) {
                            final bool isSelected =
                                emoji == state.selectedEmoji;
                            return ChoiceChip(
                              label: Text(
                                emoji,
                                style: const TextStyle(fontSize: 22),
                              ),
                              selected: isSelected,
                              onSelected: (_) => _handleEmojiSelected(emoji),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        focusNode: _focusNode,
                        minLines: 1,
                        maxLines: 3,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          hintText: state.selectedEmoji == null
                              ? 'Type a message'
                              : 'Selected emoji: ${state.selectedEmoji}',
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(Radius.circular(24)),
                          ),
                          filled: true,
                          fillColor: theme.colors.surfaceContainerHigh
                              .withValues(alpha: 0.85),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: _toggleEmojiPicker,
                      tooltip: 'Choose emoji',
                      icon: Icon(
                        state.showEmojiPicker
                            ? Icons.keyboard
                            : Icons.emoji_emotions,
                      ),
                      color: state.selectedEmoji == null
                          ? iconColor
                          : theme.colors.primary,
                    ),
                    IconButton(
                      onPressed:
                          canSend &&
                              onMessageSend != null &&
                              !widget.isGeneratingReply
                          ? () => _handleSubmit(onMessageSend)
                          : null,
                      tooltip: 'Send message',
                      icon: widget.isGeneratingReply
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.send),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleControllerChanged() {
    setState(() {});
    _scheduleMeasure();
  }

  void _handleEmojiSelected(String emoji) {
    final _EmojiComposerCubit cubit = context.read<_EmojiComposerCubit>();
    cubit.selectEmoji(emoji);
    if (_textController.text.trim().isEmpty) {
      _textController.text = emoji;
    } else if (!_textController.text.contains(emoji)) {
      _textController.text = '${_textController.text} $emoji';
    }
    _textController.selection = TextSelection.collapsed(
      offset: _textController.text.length,
    );
    _scheduleMeasure();
  }

  void _handleSubmit(OnMessageSendCallback onMessageSend) {
    final _EmojiComposerCubit cubit = context.read<_EmojiComposerCubit>();
    final _EmojiComposerStateData state = cubit.state;
    final String text = _textController.text.trim();
    if (text.isEmpty && state.selectedEmoji == null) {
      return;
    }

    onMessageSend(text.isEmpty ? state.selectedEmoji! : text);

    _textController.clear();
    cubit.clear();
    _scheduleMeasure();
  }

  void _toggleEmojiPicker() {
    context.read<_EmojiComposerCubit>().toggleEmojiPicker();
    _scheduleMeasure();
  }

  void _scheduleMeasure() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureComposer());
  }

  void _measureComposer() {
    if (!mounted) {
      return;
    }

    final RenderBox? renderBox =
        _composerKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) {
      return;
    }

    final double bottomSafeArea = MediaQuery.of(context).padding.bottom;
    context.read<ComposerHeightNotifier>().setHeight(
      renderBox.size.height - bottomSafeArea,
    );
  }
}

class _EmojiComposerCubit extends Cubit<_EmojiComposerStateData> {
  _EmojiComposerCubit() : super(const _EmojiComposerStateData());

  void clear() {
    emit(const _EmojiComposerStateData());
  }

  void selectEmoji(String emoji) {
    emit(_EmojiComposerStateData(selectedEmoji: emoji));
  }

  void toggleEmojiPicker() {
    emit(state.copyWith(showEmojiPicker: !state.showEmojiPicker));
  }
}

class _EmojiComposerStateData {
  const _EmojiComposerStateData({
    this.showEmojiPicker = false,
    this.selectedEmoji,
  });

  final bool showEmojiPicker;
  final String? selectedEmoji;

  _EmojiComposerStateData copyWith({
    bool? showEmojiPicker,
    String? selectedEmoji,
  }) {
    return _EmojiComposerStateData(
      showEmojiPicker: showEmojiPicker ?? this.showEmojiPicker,
      selectedEmoji: selectedEmoji ?? this.selectedEmoji,
    );
  }
}
