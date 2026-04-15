import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/news_bloc.dart';
import '../models/news_connection_status.dart';
import '../models/news_socket_message.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  late final TextEditingController _urlController;
  late final TextEditingController _messageController;

  @override
  void initState() {
    super.initState();
    final initialUrl = context.read<NewsBloc>().state.currentUrl;
    _urlController = TextEditingController(text: initialUrl);
    _messageController = TextEditingController(
      text: 'Hello from Flutter BLoC isolate client',
    );
  }

  @override
  void dispose() {
    _urlController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocListener<NewsBloc, NewsState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage &&
          current.errorMessage != null,
      listener: (context, state) {
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: colorScheme.error,
            ),
          );
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Isolate WebSocket Feed'),
          backgroundColor: colorScheme.surface,
        ),
        body: SafeArea(
          child: BlocBuilder<NewsBloc, NewsState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ConnectionCard(
                      status: state.connectionStatus,
                      urlController: _urlController,
                      onConnect: () {
                        context.read<NewsBloc>().add(
                          NewsConnectRequested(url: _urlController.text),
                        );
                      },
                      onDisconnect: () {
                        context.read<NewsBloc>().add(
                          const NewsDisconnectRequested(),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    _ComposerCard(
                      messageController: _messageController,
                      enabled: state.isConnected,
                      onSend: () {
                        context.read<NewsBloc>().add(
                          NewsMessageSubmitted(
                            message: _messageController.text,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Messages',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: state.messages.isEmpty
                            ? const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(24),
                                  child: Text(
                                    'No messages yet. Connect to your websocket server and send a payload.',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )
                            : ListView.separated(
                                padding: const EdgeInsets.all(12),
                                itemCount: state.messages.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 8),
                                itemBuilder: (context, index) {
                                  return _MessageTile(
                                    message: state.messages[index],
                                  );
                                },
                              ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ConnectionCard extends StatelessWidget {
  const _ConnectionCard({
    required this.status,
    required this.urlController,
    required this.onConnect,
    required this.onDisconnect,
  });

  final NewsConnectionStatus status;
  final TextEditingController urlController;
  final VoidCallback onConnect;
  final VoidCallback onDisconnect;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isBusy = status == NewsConnectionStatus.connecting;
    final isConnected = status == NewsConnectionStatus.connected;
    final chipColor = switch (status) {
      NewsConnectionStatus.connected => Colors.green,
      NewsConnectionStatus.connecting => colorScheme.primary,
      NewsConnectionStatus.error => colorScheme.error,
      NewsConnectionStatus.disconnected => colorScheme.outline,
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  'Connection',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Chip(
                  avatar: CircleAvatar(backgroundColor: chipColor),
                  label: Text(status.label),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: urlController,
              enabled: !isBusy,
              decoration: const InputDecoration(
                labelText: 'WebSocket URL',
                hintText: 'ws://127.0.0.1:3000/ws',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: isBusy || isConnected ? null : onConnect,
                    child: isBusy
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Connect'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: isConnected ? onDisconnect : null,
                    child: const Text('Disconnect'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ComposerCard extends StatelessWidget {
  const _ComposerCard({
    required this.messageController,
    required this.enabled,
    required this.onSend,
  });

  final TextEditingController messageController;
  final bool enabled;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Payload', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            TextField(
              controller: messageController,
              enabled: enabled,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Message body',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.tonal(
                onPressed: enabled ? onSend : null,
                child: const Text('Send Message'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageTile extends StatelessWidget {
  const _MessageTile({required this.message});

  final NewsSocketMessage message;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final (backgroundColor, foregroundColor, label) = switch (message.type) {
      NewsSocketMessageType.sent => (
        colorScheme.primaryContainer,
        colorScheme.onPrimaryContainer,
        'Sent',
      ),
      NewsSocketMessageType.received => (
        colorScheme.secondaryContainer,
        colorScheme.onSecondaryContainer,
        'Received',
      ),
      NewsSocketMessageType.error => (
        colorScheme.errorContainer,
        colorScheme.onErrorContainer,
        'Error',
      ),
      NewsSocketMessageType.system => (
        colorScheme.surface,
        colorScheme.onSurface,
        'System',
      ),
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: foregroundColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Text(
                  message.formattedTime,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: foregroundColor),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SelectableText(
              message.text,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: foregroundColor),
            ),
          ],
        ),
      ),
    );
  }
}
