import 'package:flutter/material.dart';

import '../state/demo_app_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) {
      return;
    }

    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
    );
  }

  void _send() {
    final controller = DemoScope.of(context);
    controller.sendMessage(_messageController.text);
    _messageController.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  Widget build(BuildContext context) {
    final controller = DemoScope.of(context);
    final user = controller.user;
    final contact = controller.selectedContact;
    final messages = controller.activeMessages;
    final isWide = MediaQuery.sizeOf(context).width >= 900;

    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => controller.goToLogin(),
      );
      return const SizedBox.shrink();
    }

    final conversationsRail = ConversationRail(
      contacts: controller.contacts,
      selectedId: contact.id,
      onSelected: controller.selectContact,
    );

    return Scaffold(
      drawer: isWide
          ? null
          : Drawer(width: 320, child: SafeArea(child: conversationsRail)),
      body: SafeArea(
        child: Row(
          children: [
            if (isWide) SizedBox(width: 320, child: conversationsRail),
            Expanded(
              child: DecoratedBox(
                decoration: const BoxDecoration(color: AppColors.gray50),
                child: Column(
                  children: [
                    Material(
                      color: Colors.white,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Color(0x1A000000)),
                          ),
                        ),
                        child: Row(
                          children: [
                            if (!isWide) ...[
                              Builder(
                                builder: (context) {
                                  return IconButton(
                                    onPressed: () =>
                                        Scaffold.of(context).openDrawer(),
                                    icon: const Icon(Icons.menu_rounded),
                                  );
                                },
                              ),
                              const SizedBox(width: 4),
                            ],
                            ConversationAvatar(
                              initials: contact.initials,
                              colors: contact.palette,
                              size: 46,
                              isOnline: contact.isOnline,
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    contact.name,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    contact.isOnline ? 'Online' : 'Offline',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: controller.goToProfile,
                              tooltip: 'Profile',
                              icon: const Icon(Icons.person_outline_rounded),
                            ),
                            IconButton(
                              onPressed: controller.logout,
                              tooltip: 'Logout',
                              icon: const Icon(Icons.logout_rounded),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.separated(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(20),
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          return Align(
                            alignment: message.isUser
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: MessageBubble(message: message),
                          );
                        },
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 12),
                        itemCount: messages.length,
                      ),
                    ),
                    Material(
                      color: Colors.white,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Color(0x1A000000)),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _messageController,
                                onSubmitted: (_) => _send(),
                                decoration: const InputDecoration(
                                  hintText: 'Type a message...',
                                  prefixIcon: Icon(
                                    Icons.chat_bubble_outline_rounded,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            GradientIconButton(
                              icon: Icons.send_rounded,
                              onPressed: _send,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
