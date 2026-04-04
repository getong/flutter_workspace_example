import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../models.dart';
import '../router/app_router.dart';
import '../sample_data.dart';
import '../theme.dart';
import '../widgets/common.dart';

@RoutePage(name: 'HomeShellRoute')
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      _ChatsTab(onBack: _backToLogin, onOpenChat: _openChat),
      const _PeopleTab(),
      _ProfileTab(onBack: _backToChats, onLogout: _logout),
    ];

    return Scaffold(
      extendBody: true,
      floatingActionButton: _currentIndex == 0
          ? DecoratedBox(
              decoration: BoxDecoration(
                gradient: atriumPrimaryGradient(),
                borderRadius: BorderRadius.circular(22),
                boxShadow: atriumShadow(),
              ),
              child: FloatingActionButton(
                onPressed: () {},
                elevation: 0,
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Icon(Icons.edit_rounded),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      backgroundColor: Colors.transparent,
      body: AtriumBackground(
        compact: true,
        child: SafeArea(
          bottom: false,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 260),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeOutCubic,
            child: KeyedSubtree(
              key: ValueKey(_currentIndex),
              child: tabs[_currentIndex],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }

  void _openChat(ChatPreview chat) {
    context.router.push(ChatDetailRoute(chat: chat));
  }

  void _logout() {
    context.router.replaceAll([const LoginRoute()]);
  }

  void _backToLogin() {
    context.router.replaceAll([const LoginRoute()]);
  }

  void _backToChats() {
    setState(() {
      _currentIndex = 0;
    });
  }
}

class _ChatsTab extends StatelessWidget {
  const _ChatsTab({required this.onBack, required this.onOpenChat});

  final VoidCallback onBack;
  final ValueChanged<ChatPreview> onOpenChat;

  @override
  Widget build(BuildContext context) {
    return EntranceFader(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 128),
        child: WidthClamp(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  AtriumBackButton(
                    onPressed: onBack,
                    iconColor: AtriumColors.onSurface,
                  ),
                  const AvatarBubble(
                    initials: 'AT',
                    accent: AtriumColors.primaryBright,
                    fill: Color(0xFF202A3B),
                    withRing: true,
                    icon: Icons.person_rounded,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Messages',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium?.copyWith(fontSize: 22),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.search_rounded),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.settings_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AtriumColors.surfaceLow,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    icon: Icon(Icons.search_rounded),
                    hintText: 'Search conversations...',
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const SectionLabel('Recently Active'),
              const SizedBox(height: 16),
              SizedBox(
                height: 96,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: people.length - 1,
                  separatorBuilder: (_, _) => const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    final person = people[index];
                    return Column(
                      children: [
                        AvatarBubble(
                          initials: person.initials,
                          accent: person.accent,
                          fill: person.fill,
                          withRing: true,
                          isOnline: person.isOnline,
                          size: 68,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          person.name.split(' ').first,
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(color: AtriumColors.onSurface),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 28),
              const SectionLabel('Recent Chats'),
              const SizedBox(height: 14),
              Container(
                decoration: BoxDecoration(
                  color: AtriumColors.surfaceRaised,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: atriumShadow(opacity: 0.05),
                ),
                child: Column(
                  children: [
                    for (var i = 0; i < chats.length; i++)
                      _ChatTile(
                        chat: chats[i],
                        onTap: () => onOpenChat(chats[i]),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PeopleTab extends StatelessWidget {
  const _PeopleTab();

  @override
  Widget build(BuildContext context) {
    return EntranceFader(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 128),
        child: WidthClamp(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'People',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium?.copyWith(fontSize: 22),
                    ),
                  ),
                  FilledButton.tonalIcon(
                    onPressed: () {},
                    icon: const Icon(Icons.person_add_alt_1_rounded),
                    label: const Text('Invite'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AtriumColors.surfaceHigh,
                      foregroundColor: AtriumColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'A lightweight companion screen built from the same “recently active” visual language in the provided chat list design.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              const SectionLabel('Available Now'),
              const SizedBox(height: 14),
              for (final person in people.take(5))
                Padding(
                  padding: const EdgeInsets.only(bottom: 18),
                  child: _PersonCard(person: person),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileTab extends StatelessWidget {
  const _ProfileTab({required this.onBack, required this.onLogout});

  final VoidCallback onBack;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return EntranceFader(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 128),
        child: WidthClamp(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  AtriumBackButton(
                    onPressed: onBack,
                    iconColor: AtriumColors.onSurface,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'Messages',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium?.copyWith(fontSize: 20),
                    ),
                  ),
                  const AvatarBubble(
                    initials: 'AT',
                    accent: AtriumColors.primaryBright,
                    fill: Color(0xFF1E2C42),
                    size: 42,
                    withRing: true,
                    icon: Icons.person_rounded,
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.settings_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Center(
                child: Column(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        const AvatarBubble(
                          initials: 'AT',
                          accent: AtriumColors.primaryBright,
                          fill: Color(0xFF1E2C42),
                          size: 132,
                          withRing: true,
                          icon: Icons.person_rounded,
                        ),
                        Positioned(
                          right: 6,
                          bottom: 4,
                          child: Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              gradient: atriumPrimaryGradient(),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                              boxShadow: atriumShadow(opacity: 0.08),
                            ),
                            child: const Icon(
                              Icons.edit_rounded,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Text(
                      currentUser.name,
                      style: Theme.of(
                        context,
                      ).textTheme.displaySmall?.copyWith(fontSize: 24),
                    ),
                    const SizedBox(height: 6),
                    Text(currentUser.email),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      value: currentUser.contacts,
                      label: 'Contacts',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _StatCard(
                      value: currentUser.messages,
                      label: 'Messages',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const SectionLabel('Account Settings'),
              const SizedBox(height: 14),
              Container(
                decoration: BoxDecoration(
                  color: AtriumColors.surfaceRaised,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: atriumShadow(opacity: 0.05),
                ),
                child: Column(
                  children: [
                    for (final action in profileActions)
                      _SettingTile(action: action),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: AtriumColors.error,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AtriumColors.error.withValues(alpha: 0.2),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: FilledButton.icon(
                  onPressed: onLogout,
                  icon: const Icon(Icons.logout_rounded),
                  label: const Text('Log Out'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(58),
                    backgroundColor: Colors.transparent,
                    foregroundColor: AtriumColors.errorText,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChatTile extends StatelessWidget {
  const _ChatTile({required this.chat, required this.onTap});

  final ChatPreview chat;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final previewStyle = chat.unreadCount > 0
        ? Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AtriumColors.onSurface,
            fontWeight: FontWeight.w700,
          )
        : Theme.of(context).textTheme.bodyMedium;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            AvatarBubble(
              initials: chat.person.initials,
              accent: chat.person.accent,
              fill: chat.person.fill,
              square: true,
              size: 56,
              icon: chat.person.icon,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          chat.person.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        chat.timestamp,
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              color: chat.unreadCount > 0
                                  ? AtriumColors.primary
                                  : AtriumColors.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              if (chat.senderPrefix != null)
                                TextSpan(
                                  text: '${chat.senderPrefix}: ',
                                  style: const TextStyle(
                                    color: AtriumColors.primary,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              TextSpan(text: chat.lastMessage),
                            ],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: previewStyle,
                        ),
                      ),
                      if (chat.unreadCount > 0) ...[
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AtriumColors.primary,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            '${chat.unreadCount}',
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PersonCard extends StatelessWidget {
  const _PersonCard({required this.person});

  final Person person;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: atriumShadow(opacity: 0.05),
      ),
      child: Row(
        children: [
          AvatarBubble(
            initials: person.initials,
            accent: person.accent,
            fill: person.fill,
            withRing: true,
            isOnline: person.isOnline,
            size: 62,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  person.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(person.role),
              ],
            ),
          ),
          FilledButton.tonal(
            onPressed: () {},
            style: FilledButton.styleFrom(
              backgroundColor: AtriumColors.surfaceHigh,
              foregroundColor: AtriumColors.primary,
            ),
            child: const Text('Message'),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: AtriumColors.surfaceLow,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: 28,
              color: AtriumColors.primary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label.toUpperCase(),
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  const _SettingTile({required this.action});

  final SettingAction action;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: action.background,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(action.icon, color: action.accent),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                action.label,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AtriumColors.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
