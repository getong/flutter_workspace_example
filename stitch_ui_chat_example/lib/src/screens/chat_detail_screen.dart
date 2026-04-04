import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../models.dart';
import '../theme.dart';
import '../widgets/common.dart';

@RoutePage()
class ChatDetailScreen extends StatefulWidget {
  const ChatDetailScreen({super.key, required this.chat});

  final ChatPreview chat;

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  late final List<MessageEntry> _messages;
  final TextEditingController _composerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _messages = [...widget.chat.messages];
  }

  @override
  void dispose() {
    _composerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: AtriumBackground(
        compact: true,
        child: Stack(
          children: [
            Positioned.fill(
              child: IgnorePointer(child: CustomPaint(painter: _DotPainter())),
            ),
            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 6, 12, 0),
                    child: WidthClamp(
                      maxWidth: 620,
                      child: GlassPanel(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        child: Row(
                          children: [
                            FilledButton.tonalIcon(
                              onPressed: () => context.maybePop(),
                              style: FilledButton.styleFrom(
                                backgroundColor: AtriumColors.surfaceHigh,
                                foregroundColor: AtriumColors.onSurface,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              icon: const Icon(
                                Icons.arrow_back_rounded,
                                size: 18,
                              ),
                              label: const Text('Back'),
                            ),
                            const SizedBox(width: 8),
                            AvatarBubble(
                              initials: widget.chat.person.initials,
                              accent: widget.chat.person.accent,
                              fill: widget.chat.person.fill,
                              isOnline: widget.chat.person.isOnline,
                              size: 42,
                              icon: widget.chat.person.icon,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.chat.person.name,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium,
                                  ),
                                  Text(
                                    widget.chat.person.isOnline
                                        ? 'ONLINE'
                                        : widget.chat.person.role,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(fontWeight: FontWeight.w800),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.videocam_rounded),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.info_rounded),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: WidthClamp(
                      maxWidth: 620,
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(18, 22, 18, 120),
                        children: [
                          Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AtriumColors.surfaceHigh,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                'TODAY',
                                style: Theme.of(context).textTheme.labelMedium
                                    ?.copyWith(fontWeight: FontWeight.w800),
                              ),
                            ),
                          ),
                          const SizedBox(height: 22),
                          for (final message in _messages) ...[
                            _MessageBubble(message: message),
                            const SizedBox(height: 18),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          child: WidthClamp(
            maxWidth: 620,
            child: GlassPanel(
              padding: const EdgeInsets.all(8),
              borderRadius: BorderRadius.circular(28),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.maybePop(),
                    icon: const Icon(Icons.arrow_back_rounded),
                    color: AtriumColors.onSurface,
                    tooltip: 'Back',
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.add_circle_rounded),
                    color: AtriumColors.primary,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _composerController,
                      decoration: const InputDecoration(
                        hintText: 'Type a message...',
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.image_rounded),
                    color: AtriumColors.onSurfaceVariant,
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: atriumPrimaryGradient(),
                      shape: BoxShape.circle,
                      boxShadow: atriumShadow(opacity: 0.1),
                    ),
                    child: IconButton(
                      onPressed: _sendMessage,
                      icon: const Icon(Icons.send_rounded),
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _sendMessage() {
    final text = _composerController.text.trim();
    if (text.isEmpty) {
      return;
    }

    setState(() {
      _messages.add(MessageEntry(text: text, time: 'Now', isMe: true));
      _composerController.clear();
    });
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});

  final MessageEntry message;

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;
    final background = isMe
        ? BoxDecoration(
            gradient: atriumPrimaryGradient(begin: Alignment.topCenter),
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(28),
              topRight: const Radius.circular(28),
              bottomLeft: const Radius.circular(28),
              bottomRight: Radius.circular(message.attachment == null ? 8 : 28),
            ),
            boxShadow: atriumShadow(opacity: 0.08),
          )
        : BoxDecoration(
            color: AtriumColors.surfaceHigh,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(28),
            ),
          );

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
        child: Column(
          crossAxisAlignment: isMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            DecoratedBox(
              decoration: background,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message.text,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: isMe
                            ? AtriumColors.onPrimary
                            : AtriumColors.onSurface,
                      ),
                    ),
                    if (message.attachment != null) ...[
                      const SizedBox(height: 14),
                      _AttachmentCard(attachment: message.attachment!),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                message.time,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AtriumColors.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AttachmentCard extends StatelessWidget {
  const _AttachmentCard({required this.attachment});

  final MessageAttachment attachment;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.86),
        borderRadius: BorderRadius.circular(18),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              color: attachment.colors.first,
              alignment: Alignment.center,
              child: Text(
                'SAFE WORK',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AtriumColors.onSurface,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    color: attachment.colors[1],
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      attachment.title,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: attachment.colors[2],
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      attachment.subtitle,
                      textAlign: TextAlign.center,
                      style: Theme.of(
                        context,
                      ).textTheme.labelSmall?.copyWith(color: Colors.white70),
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
}

class _DotPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AtriumColors.primary.withValues(alpha: 0.08)
      ..style = PaintingStyle.fill;

    const spacing = 24.0;
    const radius = 1.1;

    for (double x = 12; x < size.width; x += spacing) {
      for (double y = 12; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
