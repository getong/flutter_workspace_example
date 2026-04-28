import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/di.dart';
import '../../data/services/serve_pem_chat_uri.dart';
import '../../domain/entities/serve_pem_chat_event.dart';
import '../cubit/chat_cubit.dart';

@RoutePage()
class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ChatCubit>(),
      child: const _ChatScreen(),
    );
  }
}

class _ChatScreen extends StatefulWidget {
  const _ChatScreen();

  @override
  State<_ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<_ChatScreen> {
  final _formKey = GlobalKey<FormState>();
  final _roomController = TextEditingController(text: 'general');
  final _userController = TextEditingController(text: 'alice');
  final _messageController = TextEditingController(text: 'hello room');

  @override
  void dispose() {
    _roomController.dispose();
    _userController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat Room')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: BlocBuilder<ChatCubit, ServePemChatState>(
            builder: (context, state) {
              final previewUri = _previewUri();
              final timelineChildren = state.events.isEmpty
                  ? const [SizedBox(height: 240, child: _EmptyTimeline())]
                  : [
                      for (final event in state.events) ...[
                        _EventCard(event: event),
                        const SizedBox(height: 12),
                      ],
                    ];

              return ListView(
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        'WSS /ws/{room}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        'The Rust server upgrades HTTPS to WSS on `/ws/{room}`. After connect, it sends `welcome`, broadcasts `presence` updates for joins and leaves, and relays `chat_message` events to everyone in the same room.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _roomController,
                          decoration: const InputDecoration(
                            labelText: 'Room',
                            border: OutlineInputBorder(),
                            helperText:
                                'ASCII letters, digits, ".", "_" and "-" only.',
                          ),
                          validator: _validateRoom,
                          enabled: !state.isBusy,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _userController,
                          decoration: const InputDecoration(
                            labelText: 'User',
                            border: OutlineInputBorder(),
                            helperText:
                                'The server appends the socket port to this value.',
                          ),
                          validator: _validateUser,
                          enabled: !state.isBusy,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: state.isBusy ? null : _joinRoom,
                          icon: state.isBusy
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.wifi),
                          label: const Text('Join room'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed:
                              state.status == ServePemChatStatus.disconnected
                              ? null
                              : () => context.read<ChatCubit>().disconnect(),
                          icon: const Icon(Icons.link_off),
                          label: const Text('Disconnect'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _ChatStatusCard(state: state, previewUri: previewUri),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          enabled: state.isConnected,
                          minLines: 1,
                          maxLines: 4,
                          textInputAction: TextInputAction.send,
                          onSubmitted: (_) => _sendMessage(),
                          decoration: const InputDecoration(
                            labelText: 'Message',
                            border: OutlineInputBorder(),
                            helperText:
                                'Sent as {"event":"chat_message","payload":{"user":"...","msg":"..."}}',
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      FilledButton.icon(
                        onPressed: state.isConnected ? _sendMessage : null,
                        icon: const Icon(Icons.send),
                        label: const Text('Send'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...timelineChildren,
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Uri? _previewUri() {
    try {
      return buildServePemChatUri(room: _roomController.text);
    } on FormatException {
      return null;
    }
  }

  String? _validateRoom(String? value) {
    try {
      normalizeServePemChatRoom(value ?? '');
      return null;
    } on FormatException catch (error) {
      return error.message;
    }
  }

  String? _validateUser(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty || trimmed.length > 64) {
      return 'User is required and must be 64 characters or fewer.';
    }

    return null;
  }

  void _joinRoom() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.read<ChatCubit>().connect(
      room: _roomController.text,
      user: _userController.text,
    );
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) {
      return;
    }

    context.read<ChatCubit>().sendMessage(text);
    _messageController.clear();
  }
}

class _ChatStatusCard extends StatelessWidget {
  final ServePemChatState state;
  final Uri? previewUri;

  const _ChatStatusCard({required this.state, required this.previewUri});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final statusLabel = switch (state.status) {
      ServePemChatStatus.disconnected => 'Disconnected',
      ServePemChatStatus.connecting => 'Connecting',
      ServePemChatStatus.connected => 'Connected',
    };

    final backgroundColor = switch (state.status) {
      ServePemChatStatus.disconnected => colorScheme.surfaceContainerHighest,
      ServePemChatStatus.connecting => colorScheme.secondaryContainer,
      ServePemChatStatus.connected => colorScheme.tertiaryContainer,
    };

    return Card(
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(statusLabel, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            Text(
              'Active room: ${state.room.isEmpty ? 'n/a' : state.room}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 6),
            Text(
              'User: ${state.user.isEmpty ? 'n/a' : state.user}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (state.memberCount != null) ...[
              const SizedBox(height: 6),
              Text(
                'Members online: ${state.memberCount}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
            const SizedBox(height: 10),
            SelectableText(
              (state.socketUri ?? previewUri)?.toString() ??
                  'Enter a valid room to preview the websocket URL.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyTimeline extends StatelessWidget {
  const _EmptyTimeline();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'Connect to a room to see `welcome`, `presence`, and `chat_message` events.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final ServePemChatEvent event;

  const _EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final backgroundColor = switch (event.type) {
      ServePemChatEventType.error ||
      ServePemChatEventType.disconnected => colorScheme.errorContainer,
      ServePemChatEventType.chatMessage => colorScheme.primaryContainer,
      ServePemChatEventType.presence => colorScheme.secondaryContainer,
      ServePemChatEventType.welcome => colorScheme.tertiaryContainer,
      ServePemChatEventType.localInfo => colorScheme.surfaceContainerHighest,
    };

    return Card(
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(event.label, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(_describeEvent(event), style: theme.textTheme.bodyMedium),
            const SizedBox(height: 8),
            Text(
              _formatTimestamp(event.timestamp),
              style: theme.textTheme.bodySmall,
            ),
            if (event.rawMessage != null) ...[
              const SizedBox(height: 8),
              SelectableText(
                event.rawMessage!,
                style: theme.textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _describeEvent(ServePemChatEvent event) {
    return switch (event.type) {
      ServePemChatEventType.localInfo ||
      ServePemChatEventType.error ||
      ServePemChatEventType.disconnected => event.message ?? event.label,
      ServePemChatEventType.welcome =>
        'Room ${event.room}, connection ${event.connection ?? 'unknown'}, member count ${event.memberCount ?? 'unknown'}.',
      ServePemChatEventType.presence =>
        '${event.action ?? 'updated'} room ${event.room}; member count ${event.memberCount ?? 'unknown'}; connection ${event.connection ?? 'unknown'}.',
      ServePemChatEventType.chatMessage =>
        '${event.user ?? 'Anonymous'}: ${event.message ?? ''}',
    };
  }

  String _formatTimestamp(DateTime timestamp) {
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');
    final second = timestamp.second.toString().padLeft(2, '0');
    return '$hour:$minute:$second';
  }
}
