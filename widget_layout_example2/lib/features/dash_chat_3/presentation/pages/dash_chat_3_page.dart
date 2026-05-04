import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:dash_chat_3/dash_chat_3.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/app_navigation.dart';

@RoutePage(name: RouteName.dashChat3)
class DashChat3Page extends StatefulWidget {
  const DashChat3Page({super.key});

  @override
  State<DashChat3Page> createState() => _DashChat3PageState();
}

class _DashChat3PageState extends State<DashChat3Page> {
  static final ChatUser _currentUser = ChatUser(
    id: 'current-user',
    firstName: 'Flutter',
    lastName: 'Learner',
  );

  static final ChatUser _assistantUser = ChatUser(
    id: 'assistant',
    firstName: 'Dash',
    lastName: 'Assistant',
  );

  late final TextEditingController _inputController;
  late final List<ChatMessage> _messages;

  List<ChatUser> _typingUsers = <ChatUser>[];

  @override
  void initState() {
    super.initState();
    _inputController = TextEditingController();
    _messages = <ChatMessage>[
      ChatMessage(
        user: _assistantUser,
        createdAt: DateTime(2026, 5, 4, 9, 35),
        text: 'Try sending a message or tapping one of the quick replies.',
      ),
      ChatMessage(
        user: _currentUser,
        createdAt: DateTime(2026, 5, 4, 9, 33),
        text: 'I need a small but realistic `dash_chat_3` module demo.',
        replyTo: ChatMessage(
          user: _assistantUser,
          createdAt: DateTime(2026, 5, 4, 9, 32),
          text: 'What should this feature showcase?',
        ),
      ),
      ChatMessage(
        user: _assistantUser,
        createdAt: DateTime(2026, 5, 4, 9, 32),
        text: 'What should this feature showcase?',
        quickReplies: <QuickReply>[
          QuickReply(title: 'Quick replies', value: 'Show quick replies.'),
          QuickReply(title: 'Typing state', value: 'Show typing state.'),
          QuickReply(title: 'Bubble theme', value: 'Show bubble theme.'),
        ],
      ),
    ];
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _handleSend(ChatMessage message) {
    setState(() {
      _messages.insert(0, message);
      _typingUsers = <ChatUser>[_assistantUser];
    });

    unawaited(_simulateAssistantReply(message));
  }

  Future<void> _simulateAssistantReply(ChatMessage userMessage) async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (!mounted) {
      return;
    }

    final String sourceText = userMessage.text.trim().toLowerCase();
    final String responseText;
    if (sourceText.contains('quick')) {
      responseText =
          'Quick replies are attached to a message and handled through `QuickReplyOptions.onTapQuickReply`.';
    } else if (sourceText.contains('typing')) {
      responseText =
          'Typing indicators come from the `typingUsers` list you pass into `DashChat3`.';
    } else if (sourceText.contains('theme') || sourceText.contains('bubble')) {
      responseText =
          'Bubble styling is driven here by `MessageOptions`, including colors, spacing, border radius, and timestamps.';
    } else {
      responseText =
          'This demo stores messages locally, inserts new ones at index 0, and uses the package input toolbar out of the box.';
    }

    setState(() {
      _typingUsers = <ChatUser>[];
      _messages.insert(
        0,
        ChatMessage(
          user: _assistantUser,
          createdAt: DateTime.now(),
          text: responseText,
          replyTo: ChatMessage(
            user: userMessage.user,
            createdAt: userMessage.createdAt,
            text: userMessage.text,
          ),
        ),
      );
    });
  }

  void _handleQuickReply(QuickReply quickReply) {
    _handleSend(
      ChatMessage(
        user: _currentUser,
        createdAt: DateTime.now(),
        text: quickReply.value ?? quickReply.title,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('dash_chat_3 Module')),
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
                      'dash_chat_3 provides a ready-made chat surface with message bubbles, reply threads, quick replies, typing indicators, and a configurable composer.',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'This module keeps the demo self-contained with local messages, themed bubbles, quick reply actions, and a simulated assistant response.',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                  child: DashChat3(
                    currentUser: _currentUser,
                    onSend: _handleSend,
                    messages: _messages,
                    typingUsers: _typingUsers,
                    quickReplyOptions: QuickReplyOptions(
                      onTapQuickReply: _handleQuickReply,
                      quickReplyPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      quickReplyStyle: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      quickReplyTextStyle: TextStyle(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    inputOptions: InputOptions(
                      textController: _inputController,
                      alwaysShowSend: true,
                      inputToolbarMargin: EdgeInsets.zero,
                      inputToolbarPadding: const EdgeInsets.fromLTRB(
                        8,
                        8,
                        8,
                        12,
                      ),
                      inputDecoration: const InputDecoration(
                        hintText: 'Send a message about this demo',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(18)),
                        ),
                      ),
                    ),
                    messageListOptions: const MessageListOptions(
                      showDateSeparator: true,
                      separatorFrequency: SeparatorFrequency.hours,
                    ),
                    messageOptions: MessageOptions(
                      showTime: true,
                      showOtherUsersName: true,
                      currentUserContainerColor: colorScheme.primary,
                      currentUserTextColor: colorScheme.onPrimary,
                      containerColor: colorScheme.surfaceContainerHighest,
                      textColor: colorScheme.onSurface,
                      borderRadius: 18,
                      marginDifferentAuthor: const EdgeInsets.only(top: 16),
                      marginSameAuthor: const EdgeInsets.only(top: 6),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.router.replacePath('/'),
        icon: const Icon(Icons.home),
        label: const Text('Home'),
      ),
    );
  }
}
