import 'package:flutter/material.dart';

import '../models/demo_models.dart';
import '../theme/app_theme.dart';

class AuthPageShell extends StatelessWidget {
  const AuthPageShell({super.key, required this.cardChild});

  final Widget cardChild;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(28),
                    child: cardChild,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GradientBackground extends StatelessWidget {
  const GradientBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.purple50, AppColors.blue50, AppColors.pink50],
        ),
      ),
      child: child,
    );
  }
}

class BrandMark extends StatelessWidget {
  const BrandMark({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [AppColors.purple500, AppColors.blue500],
        ),
      ),
      child: const Icon(
        Icons.chat_bubble_outline_rounded,
        color: Colors.white,
        size: 30,
      ),
    );
  }
}

class LabeledField extends StatelessWidget {
  const LabeledField({super.key, required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontSize: 14),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

class GradientButton extends StatelessWidget {
  const GradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.compact = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    final content = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: compact ? MainAxisSize.min : MainAxisSize.max,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 18, color: Colors.white),
          const SizedBox(width: 8),
        ],
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );

    return Opacity(
      opacity: enabled ? 1 : 0.55,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(
            colors: [AppColors.purple500, AppColors.blue500],
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x2A6D5EF8),
              blurRadius: 20,
              offset: Offset(0, 12),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(18),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: compact ? 22 : 18,
                vertical: 16,
              ),
              child: content,
            ),
          ),
        ),
      ),
    );
  }
}

class GradientIconButton extends StatelessWidget {
  const GradientIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [AppColors.purple500, AppColors.blue500],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x286D5EF8),
            blurRadius: 16,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        style: IconButton.styleFrom(
          minimumSize: const Size.square(56),
          foregroundColor: Colors.white,
        ),
        icon: Icon(icon),
      ),
    );
  }
}

class ConversationRail extends StatelessWidget {
  const ConversationRail({
    super.key,
    required this.contacts,
    required this.selectedId,
    required this.onSelected,
  });

  final List<DemoContact> contacts;
  final String selectedId;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: Color(0x1A000000))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
            child: Text(
              'Messages',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              itemCount: contacts.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final contact = contacts[index];
                final isSelected = selectedId == contact.id;

                return Material(
                  color: isSelected ? AppColors.purple50 : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    onTap: () => onSelected(contact.id),
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          ConversationAvatar(
                            initials: contact.initials,
                            colors: contact.palette,
                            size: 48,
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
                                const SizedBox(height: 4),
                                Text(
                                  contact.isOnline ? 'Online' : 'Offline',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
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
    );
  }
}

class ConversationAvatar extends StatelessWidget {
  const ConversationAvatar({
    super.key,
    required this.initials,
    required this.colors,
    required this.size,
    this.isOnline,
  });

  final String initials;
  final List<Color> colors;
  final double size;
  final bool? isOnline;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: colors),
            ),
            alignment: Alignment.center,
            child: Text(
              initials,
              style: TextStyle(
                color: Colors.white,
                fontSize: size * 0.28,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
          if (isOnline == true)
            Positioned(
              right: -1,
              bottom: -1,
              child: Container(
                width: size * 0.26,
                height: size * 0.26,
                decoration: BoxDecoration(
                  color: AppColors.green500,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2.4),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({super.key, required this.message});

  final DemoMessage message;

  @override
  Widget build(BuildContext context) {
    final bubble = BoxDecoration(
      borderRadius: BorderRadius.circular(22),
      gradient: message.isUser
          ? const LinearGradient(
              colors: [AppColors.purple500, AppColors.blue500],
            )
          : null,
      color: message.isUser ? null : Colors.white,
      border: message.isUser
          ? null
          : Border.all(color: const Color(0x1A000000)),
      boxShadow: const [
        BoxShadow(
          color: Color(0x0F111827),
          blurRadius: 12,
          offset: Offset(0, 6),
        ),
      ],
    );

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 420),
      child: DecoratedBox(
        decoration: bubble,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: message.isUser
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Text(
                message.text,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: message.isUser ? Colors.white : AppColors.text,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _formatTime(message.sentAt),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: message.isUser
                      ? Colors.white.withValues(alpha: 0.82)
                      : AppColors.gray500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileStatTile extends StatelessWidget {
  const ProfileStatTile({
    super.key,
    required this.value,
    required this.label,
    required this.color,
  });

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0x12000000)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Column(
          children: [
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.gray600),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatTime(DateTime time) {
  final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
  final minute = time.minute.toString().padLeft(2, '0');
  final period = time.hour >= 12 ? 'PM' : 'AM';
  return '$hour:$minute $period';
}
