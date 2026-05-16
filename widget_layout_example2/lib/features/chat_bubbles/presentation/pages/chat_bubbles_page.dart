import 'package:auto_route/auto_route.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';

@RoutePage(name: RouteName.chatBubbles)
class ChatBubblesPage extends StatefulWidget {
  const ChatBubblesPage({super.key});

  @override
  State<ChatBubblesPage> createState() => _ChatBubblesPageState();
}

class _ChatBubblesPageState extends State<ChatBubblesPage> {
  static const String _replyTarget =
      'Can you send the crop preview and the final bubble styling?';

  static final List<_GroupedMessage> _groupedMessages = <_GroupedMessage>[
    _GroupedMessage(
      senderId: 'teammate',
      text: 'The package already handles tails and timestamps for us.',
      sentAt: DateTime(2026, 4, 27, 9, 0),
      isSender: false,
    ),
    _GroupedMessage(
      senderId: 'teammate',
      text: 'We can keep consecutive messages in one visual group.',
      sentAt: DateTime(2026, 4, 27, 9, 0, 20),
      isSender: false,
    ),
    _GroupedMessage(
      senderId: 'me',
      text: 'That makes grouped chat history much cleaner.',
      sentAt: DateTime(2026, 4, 27, 9, 1, 5),
      isSender: true,
    ),
    _GroupedMessage(
      senderId: 'me',
      text: 'I only need to toggle `tail: info.showTail`.',
      sentAt: DateTime(2026, 4, 27, 9, 1, 24),
      isSender: true,
    ),
    _GroupedMessage(
      senderId: 'teammate',
      text: 'Exactly. The grouping helper handles the gap and sender change.',
      sentAt: DateTime(2026, 4, 27, 9, 3, 2),
      isSender: false,
    ),
  ];

  final List<_ComposerPreviewMessage> _composerMessages =
      <_ComposerPreviewMessage>[
        const _ComposerPreviewMessage(
          text: 'Looks good. I will wire this into the content modules tab.',
          replyTarget: _replyTarget,
        ),
      ];

  bool _replying = true;

  void _handleComposerSend(String text) {
    setState(() {
      _composerMessages.add(
        _ComposerPreviewMessage(
          text: text,
          replyTarget: _replying ? _replyTarget : null,
        ),
      );
      _replying = false;
    });
  }

  void _addIncomingExample() {
    setState(() {
      _composerMessages.add(
        const _ComposerPreviewMessage(
          text: 'Please also demo image bubbles and a grouped transcript.',
          isSender: false,
        ),
      );
      _replying = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('chat_bubbles Module')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: <Widget>[
          Text(
            'chat_bubbles gives Flutter a ready-made chat UI toolkit with bubble shapes, reply previews, date chips, grouped transcripts, image bubbles, and composer bars.',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'This module demonstrates `BubbleNormal`, `BubbleSpecialOne`, `BubbleSpecialTwo`, `BubbleReply`, `BubbleNormalImage`, `DateChip`, `BubbleGroupBuilder`, and `MessageBar` in one place.',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          _SectionCard(
            title: 'Standard and Special Bubbles',
            description:
                'Use the basic bubble for most messages, then switch to the special painters when you want a more opinionated chat style.',
            child: _ChatSurface(
              child: Column(
                children: <Widget>[
                  BubbleNormal(
                    text:
                        'BubbleNormal works well for routine messages and status ticks.',
                    isSender: false,
                    color: const Color(0xFF2563EB),
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                    timestamp: '09:12',
                  ),
                  BubbleNormal(
                    text:
                        'The sender version can show sent, delivered, or seen states.',
                    color: colorScheme.surfaceContainerHighest,
                    sent: true,
                    delivered: true,
                    seen: true,
                    isEdited: true,
                    timestamp: '09:13',
                  ),
                  BubbleSpecialOne(
                    text:
                        'BubbleSpecialOne paints a more stylized tail using CustomPainter.',
                    isSender: false,
                    color: const Color(0xFFF59E0B),
                    textStyle: const TextStyle(
                      color: Colors.black87,
                      fontSize: 15,
                    ),
                    timestamp: '09:14',
                  ),
                  BubbleSpecialTwo(
                    text:
                        'BubbleSpecialTwo gives another visual variant without changing your message data model.',
                    color: const Color(0xFFE2E8F0),
                    delivered: true,
                    timestamp: '09:15',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _SectionCard(
            title: 'Reply and Image Bubbles',
            description:
                'Reply previews and image bubbles cover the common messaging cases without building the layout from scratch.',
            child: _ChatSurface(
              child: Column(
                children: <Widget>[
                  BubbleReply(
                    repliedMessage:
                        'Use the same sample image that already exists in assets.',
                    repliedMessageSender: 'Design QA',
                    text:
                        'Done. This reply bubble shows the quoted sender, the quoted text, and the new outgoing message.',
                    color: const Color(0xFFDCFCE7),
                    replyBorderColor: const Color(0xFF16A34A),
                    sent: true,
                    timestamp: '10:02',
                  ),
                  BubbleNormalImage(
                    id: 'chat-bubbles-demo-image',
                    image: Image.asset(
                      'assets/images/image_module_demo.png',
                      fit: BoxFit.cover,
                    ),
                    color: Colors.white,
                    isSender: false,
                    tail: true,
                    timestamp: '10:03',
                    isForwarded: true,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _SectionCard(
            title: 'Date Chips and Grouped Messages',
            description:
                'The grouping helper decides where a tail should appear so the UI reflects sender runs instead of isolated messages.',
            child: _ChatSurface(
              child: Column(
                children: <Widget>[
                  DateChip(date: DateTime(2026, 4, 26)),
                  BubbleGroupBuilder(
                    itemCount: _groupedMessages.length,
                    senderIdOf: (int index) => _groupedMessages[index].senderId,
                    timestampOf: (int index) => _groupedMessages[index].sentAt,
                    itemBuilder:
                        (BuildContext context, int index, GroupInfo info) {
                          final _GroupedMessage message =
                              _groupedMessages[index];
                          return BubbleNormal(
                            text: message.text,
                            isSender: message.isSender,
                            color: message.isSender
                                ? colorScheme.surfaceContainerHighest
                                : const Color(0xFF0F766E),
                            textStyle: TextStyle(
                              color: message.isSender
                                  ? colorScheme.onSurface
                                  : Colors.white,
                              fontSize: 15,
                            ),
                            tail: info.showTail,
                            timestamp: _formatTime(message.sentAt),
                            leading: info.showAvatar
                                ? const CircleAvatar(
                                    radius: 14,
                                    child: Text('T'),
                                  )
                                : const SizedBox(width: 28),
                          );
                        },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _SectionCard(
            title: 'MessageBar Playground',
            description:
                'Send a few messages to see `MessageBar.onSend` produce either a normal bubble or a reply bubble in the preview.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: <Widget>[
                    FilterChip(
                      label: const Text('Reply Mode'),
                      selected: _replying,
                      onSelected: (bool value) {
                        setState(() {
                          _replying = value;
                        });
                      },
                    ),
                    OutlinedButton.icon(
                      onPressed: _addIncomingExample,
                      icon: const Icon(Icons.mark_chat_unread_outlined),
                      label: const Text('Add Incoming Example'),
                    ),
                    OutlinedButton.icon(
                      onPressed: _composerMessages.isEmpty
                          ? null
                          : () {
                              setState(() {
                                _composerMessages.clear();
                              });
                            },
                      icon: const Icon(Icons.clear_all),
                      label: const Text('Clear Preview'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _ChatSurface(
                  child: _composerMessages.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(18),
                          child: Text(
                            'No composer output yet. Send a message below to exercise the widget callbacks.',
                            style: theme.textTheme.bodyMedium,
                          ),
                        )
                      : Column(
                          children: _composerMessages
                              .map(
                                (_ComposerPreviewMessage message) =>
                                    message.replyTarget == null
                                    ? BubbleNormal(
                                        text: message.text,
                                        isSender: message.isSender,
                                        color: message.isSender
                                            ? colorScheme
                                                  .surfaceContainerHighest
                                            : const Color(0xFF7C3AED),
                                        textStyle: TextStyle(
                                          color: message.isSender
                                              ? colorScheme.onSurface
                                              : Colors.white,
                                        ),
                                        timestamp: 'Now',
                                        tail: true,
                                      )
                                    : BubbleReply(
                                        repliedMessage: message.replyTarget!,
                                        repliedMessageSender: 'Reviewer',
                                        text: message.text,
                                        isSender: message.isSender,
                                        color: const Color(0xFFDBEAFE),
                                        replyBorderColor: const Color(
                                          0xFF2563EB,
                                        ),
                                        timestamp: 'Now',
                                      ),
                              )
                              .toList(),
                        ),
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Material(
                    color: colorScheme.surfaceContainerLowest,
                    child: MessageBar(
                      replying: _replying,
                      replyingTo: _replyTarget,
                      actions: <Widget>[
                        IconButton(
                          onPressed: _addIncomingExample,
                          icon: const Icon(Icons.add_photo_alternate_outlined),
                        ),
                      ],
                      onTapCloseReply: () {
                        setState(() {
                          _replying = false;
                        });
                      },
                      onSend: _handleComposerSend,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final String hour = time.hour.toString().padLeft(2, '0');
    final String minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.description,
    required this.child,
  });

  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(description),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class _ChatSurface extends StatelessWidget {
  const _ChatSurface({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        child: child,
      ),
    );
  }
}

class _GroupedMessage {
  const _GroupedMessage({
    required this.senderId,
    required this.text,
    required this.sentAt,
    required this.isSender,
  });

  final String senderId;
  final String text;
  final DateTime sentAt;
  final bool isSender;
}

class _ComposerPreviewMessage {
  const _ComposerPreviewMessage({
    required this.text,
    this.replyTarget,
    this.isSender = true,
  });

  final String text;
  final String? replyTarget;
  final bool isSender;
}
