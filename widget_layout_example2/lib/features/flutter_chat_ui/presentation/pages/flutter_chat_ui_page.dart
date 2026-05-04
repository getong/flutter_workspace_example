import 'dart:async';
import 'dart:math' as math;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:widget_layout_example2/app_navigation.dart';
import 'package:widget_layout_example2/features/flutter_chat_ui/data/controllers/drift_flutter_chat_ui_controller.dart';
import 'package:widget_layout_example2/features/flutter_chat_ui/data/datasources/flutter_chat_ui_database.dart';
import 'package:widget_layout_example2/features/flutter_chat_ui/data/services/flutter_chat_ui_image_storage.dart';

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

  final ImagePicker _imagePicker = ImagePicker();

  late final FlutterChatUiDatabase _chatDatabase;
  late final DriftFlutterChatUiController _chatController;
  Timer? _assistantReplyTimer;
  int _messageSeed = 0;
  bool _isGeneratingReply = false;
  bool _isPickingImage = false;
  String _activeSessionId = FlutterChatUiDatabase.defaultSessionId;
  bool _isSwitchingSession = false;

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
    await _chatController.loadInitialMessages(sessionId: _activeSessionId);
    if (mounted) {
      setState(() {});
    }
  }

  String _nextMessageId() {
    _messageSeed += 1;
    return 'message-${DateTime.now().microsecondsSinceEpoch}-$_messageSeed';
  }

  String _nextSessionPreview(String text) {
    final String trimmed = text.trim();
    return trimmed.length > 40 ? '${trimmed.substring(0, 40)}...' : trimmed;
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

    final bool isEmptyConversation = _chatController.messages.isEmpty;
    if (isEmptyConversation &&
        _activeSessionId == FlutterChatUiDatabase.defaultSessionId) {
      await _chatController.createAndSwitchSession(
        firstMessagePreview: _nextSessionPreview(trimmed),
      );
      _activeSessionId = _chatController.activeSessionId;
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
    final String sessionId = _chatController.activeSessionId;
    _assistantReplyTimer?.cancel();
    _assistantReplyTimer = Timer(const Duration(milliseconds: 700), () async {
      if (!mounted || _chatController.activeSessionId != sessionId) {
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
            'This version persists both chat sessions and their messages in drift, so the drawer can switch across saved histories.';
      } else if (lowerText.contains('image') ||
          lowerText.contains('photo') ||
          lowerText.contains('preview')) {
        replyText =
            'Images are picked from the gallery, copied into app storage for durable chat history, and can be previewed fullscreen or saved into the system album.';
      } else if (lowerText.contains('stop') || lowerText.contains('cancel')) {
        replyText =
            'While the placeholder is active, use the stop button to cancel generation and update that pending assistant message.';
      } else {
        replyText =
            'This example wires flutter_chat_ui, drift persistence, image attachments, gallery export, and assistant placeholder updates into one flow.';
      }

      final Message? oldMessage = _chatController.messages
          .where((Message message) => message.id == assistantMessageId)
          .cast<Message?>()
          .firstOrNull;

      if (oldMessage == null) {
        return;
      }

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

  Future<void> _handleAttachmentTap() async {
    if (_isPickingImage || _isSwitchingSession) {
      return;
    }

    if (mounted) {
      setState(() {
        _isPickingImage = true;
      });
    }

    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 92,
      );
      if (pickedFile == null) {
        return;
      }

      final StoredChatImage storedImage = await persistPickedChatImage(
        pickedFile,
      );
      final bool isEmptyConversation = _chatController.messages.isEmpty;
      if (isEmptyConversation &&
          _activeSessionId == FlutterChatUiDatabase.defaultSessionId) {
        await _chatController.createAndSwitchSession(
          firstMessagePreview: pickedFile.name.isEmpty
              ? 'Image'
              : pickedFile.name,
        );
        _activeSessionId = _chatController.activeSessionId;
      }

      final Message imageMessage = Message.image(
        id: _nextMessageId(),
        authorId: _currentUserId,
        createdAt: DateTime.now(),
        sentAt: DateTime.now(),
        status: MessageStatus.sent,
        source: storedImage.source,
        size: storedImage.size,
        text: pickedFile.name.isEmpty ? 'Image' : pickedFile.name,
        metadata: <String, dynamic>{'fileName': pickedFile.name},
      );

      await _chatController.insertMessage(imageMessage);
      _showStatus('Image sent. Tap the image to preview or save it.');
    } on UnsupportedError {
      _showStatus('This platform does not support local image attachments.');
    } catch (error) {
      _showStatus('Image send failed: $error');
    } finally {
      if (mounted) {
        setState(() {
          _isPickingImage = false;
        });
      }
    }
  }

  Future<String> _exportImageToSystem(ImageMessage message) {
    return exportChatImageToSystem(
      source: message.source,
      suggestedName: message.text ?? message.metadata?['fileName'] as String?,
    );
  }

  void _handleMessageTap(
    BuildContext context,
    Message message, {
    required int index,
    required TapUpDetails details,
  }) {
    if (message is! ImageMessage) {
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => _ChatImagePreviewPage(
          message: message,
          heroTag: 'chat-image-${message.id}',
          onSaveRequested: () => _exportImageToSystem(message),
        ),
      ),
    );
  }

  void _showStatus(String message) {
    final ScaffoldMessengerState? messenger = ScaffoldMessenger.maybeOf(
      context,
    );
    messenger
      ?..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _switchSession(String sessionId) async {
    if (_activeSessionId == sessionId || _isSwitchingSession) {
      Navigator.of(context).maybePop();
      return;
    }

    _assistantReplyTimer?.cancel();

    if (mounted) {
      setState(() {
        _isGeneratingReply = false;
        _isSwitchingSession = true;
      });
    }

    await _chatController.switchSession(sessionId);

    if (!mounted) {
      return;
    }

    setState(() {
      _activeSessionId = sessionId;
      _isSwitchingSession = false;
    });

    Navigator.of(context).maybePop();
  }

  Future<void> _startNewConversation() async {
    if (_isSwitchingSession) {
      return;
    }

    _assistantReplyTimer?.cancel();

    if (mounted) {
      setState(() {
        _isGeneratingReply = false;
        _isSwitchingSession = true;
      });
    }

    await _chatController.createAndSwitchSession();

    if (!mounted) {
      return;
    }

    setState(() {
      _activeSessionId = _chatController.activeSessionId;
      _isSwitchingSession = false;
    });

    Navigator.of(context).maybePop();
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

    return StreamBuilder<List<FlutterChatSessionSummary>>(
      stream: _chatDatabase.watchSessions(),
      builder:
          (
            BuildContext context,
            AsyncSnapshot<List<FlutterChatSessionSummary>> snapshot,
          ) {
            final List<FlutterChatSessionSummary> sessions =
                snapshot.data ?? <FlutterChatSessionSummary>[];
            final FlutterChatSessionSummary? activeSession = sessions
                .where(
                  (FlutterChatSessionSummary session) =>
                      session.sessionId == _activeSessionId,
                )
                .cast<FlutterChatSessionSummary?>()
                .firstOrNull;

            return Scaffold(
              drawer: _ChatSessionDrawer(
                sessions: sessions,
                activeSessionId: _activeSessionId,
                onSessionSelected: _switchSession,
                onCreateSession: _startNewConversation,
              ),
              appBar: AppBar(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text('flutter_chat_ui Module'),
                    Text(
                      activeSession?.title ?? 'Current Chat',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
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
                              'This enhanced demo uses drift-backed sessions and messages, supports image picking, fullscreen preview, and keeps selected images in durable app storage. Export to the system photo library or Downloads folder is handled explicitly from preview.',
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
                          child: Stack(
                            children: <Widget>[
                              Chat(
                                currentUserId: _currentUserId,
                                resolveUser: _resolveUser,
                                chatController: _chatController,
                                theme: chatTheme,
                                builders: Builders(
                                  composerBuilder: (BuildContext context) =>
                                      _EmojiComposer(
                                        emojiChoices: _emojiChoices,
                                        isGeneratingReply: _isGeneratingReply,
                                        isPickingImage: _isPickingImage,
                                      ),
                                  imageMessageBuilder:
                                      (
                                        BuildContext context,
                                        ImageMessage message,
                                        int index, {
                                        required bool isSentByMe,
                                        MessageGroupStatus? groupStatus,
                                      }) => _ChatImageBubble(
                                        message: message,
                                        isSentByMe: isSentByMe,
                                        heroTag: 'chat-image-${message.id}',
                                      ),
                                ),
                                onAttachmentTap: _handleAttachmentTap,
                                onMessageTap: _handleMessageTap,
                                onMessageSend: _handleMessageSend,
                              ),
                              if (_isSwitchingSession)
                                Positioned.fill(
                                  child: ColoredBox(
                                    color: colorScheme.surface.withValues(
                                      alpha: 0.72,
                                    ),
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
    );
  }
}

class _ChatSessionDrawer extends StatelessWidget {
  const _ChatSessionDrawer({
    required this.sessions,
    required this.activeSessionId,
    required this.onSessionSelected,
    required this.onCreateSession,
  });

  final List<FlutterChatSessionSummary> sessions;
  final String activeSessionId;
  final ValueChanged<String> onSessionSelected;
  final VoidCallback onCreateSession;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Drawer(
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      'Chat Sessions',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  FilledButton.icon(
                    onPressed: onCreateSession,
                    icon: const Icon(Icons.add_comment_outlined),
                    label: const Text('New'),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: sessions.isEmpty
                  ? Center(
                      child: Text(
                        'No saved conversations yet.',
                        style: theme.textTheme.bodyMedium,
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemBuilder: (BuildContext context, int index) {
                        final FlutterChatSessionSummary session =
                            sessions[index];
                        final bool isActive =
                            session.sessionId == activeSessionId;

                        return ListTile(
                          leading: CircleAvatar(child: Text('${index + 1}')),
                          selected: isActive,
                          selectedTileColor: theme.colorScheme.primaryContainer,
                          title: Text(
                            session.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            _sessionSubtitle(session),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: isActive
                              ? Icon(
                                  Icons.check_circle,
                                  color: theme.colorScheme.primary,
                                )
                              : null,
                          onTap: () => onSessionSelected(session.sessionId),
                        );
                      },
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemCount: sessions.length,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  String _sessionSubtitle(FlutterChatSessionSummary session) {
    final DateFormat formatter = DateFormat('MM-dd HH:mm');
    final String preview = session.lastMessagePreview?.trim().isNotEmpty == true
        ? session.lastMessagePreview!.trim()
        : '${session.messageCount} messages';
    return '$preview · ${formatter.format(session.updatedAt)}';
  }
}

class _EmojiComposer extends StatefulWidget {
  const _EmojiComposer({
    required this.emojiChoices,
    required this.isGeneratingReply,
    required this.isPickingImage,
  });

  final List<String> emojiChoices;
  final bool isGeneratingReply;
  final bool isPickingImage;

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
    final VoidCallback? onAttachmentTap = context
        .read<OnAttachmentTapCallback?>();
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
                    IconButton(
                      onPressed:
                          onAttachmentTap != null &&
                              !widget.isGeneratingReply &&
                              !widget.isPickingImage
                          ? onAttachmentTap
                          : null,
                      tooltip: 'Pick image',
                      icon: widget.isPickingImage
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.add_photo_alternate_outlined),
                    ),
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
                              !widget.isGeneratingReply &&
                              !widget.isPickingImage
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

class _ChatImageBubble extends StatelessWidget {
  const _ChatImageBubble({
    required this.message,
    required this.isSentByMe,
    required this.heroTag,
  });

  final ImageMessage message;
  final bool isSentByMe;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double maxWidth = math
        .min(MediaQuery.of(context).size.width * 0.62, 260)
        .toDouble();
    final double aspectRatio = _resolvedAspectRatio(message);
    final String? caption = message.text?.trim().isEmpty == true
        ? null
        : message.text?.trim();

    return Container(
      constraints: BoxConstraints(maxWidth: maxWidth),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: isSentByMe
            ? theme.colorScheme.primaryContainer
            : theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.45),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Hero(
            tag: heroTag,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: AspectRatio(
                aspectRatio: aspectRatio,
                child: Image(
                  image: chatImageProvider(message.source),
                  fit: BoxFit.cover,
                  errorBuilder:
                      (
                        BuildContext context,
                        Object error,
                        StackTrace? stackTrace,
                      ) => DecoratedBox(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.broken_image_outlined,
                            color: theme.colorScheme.error,
                            size: 32,
                          ),
                        ),
                      ),
                ),
              ),
            ),
          ),
          if (caption != null) ...<Widget>[
            const SizedBox(height: 8),
            Text(
              caption,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ],
      ),
    );
  }

  double _resolvedAspectRatio(ImageMessage message) {
    final double? width = message.width;
    final double? height = message.height;
    if (width == null || height == null || width <= 0 || height <= 0) {
      return 1;
    }

    return (width / height).clamp(0.75, 1.4);
  }
}

class _ChatImagePreviewPage extends StatefulWidget {
  const _ChatImagePreviewPage({
    required this.message,
    required this.heroTag,
    required this.onSaveRequested,
  });

  final ImageMessage message;
  final String heroTag;
  final Future<String> Function() onSaveRequested;

  @override
  State<_ChatImagePreviewPage> createState() => _ChatImagePreviewPageState();
}

class _ChatImagePreviewPageState extends State<_ChatImagePreviewPage> {
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    final String title = widget.message.text?.trim().isNotEmpty == true
        ? widget.message.text!.trim()
        : 'Image Preview';

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: <Widget>[
          IconButton(
            onPressed: _isSaving ? null : _handleSavePressed,
            tooltip: 'Save image',
            icon: _isSaving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.download_outlined),
          ),
        ],
      ),
      body: PhotoView(
        imageProvider: chatImageProvider(widget.message.source),
        backgroundDecoration: const BoxDecoration(color: Colors.black),
        heroAttributes: PhotoViewHeroAttributes(tag: widget.heroTag),
      ),
    );
  }

  Future<void> _handleSavePressed() async {
    setState(() {
      _isSaving = true;
    });

    try {
      final String result = await widget.onSaveRequested();
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(result)));
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }
}
