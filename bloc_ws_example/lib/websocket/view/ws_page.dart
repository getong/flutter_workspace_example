import 'package:bloc_ws_example/websocket/bloc/ws_bloc.dart';
import 'package:bloc_ws_example/websocket/bloc/ws_event.dart';
import 'package:bloc_ws_example/websocket/bloc/ws_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WsPage extends StatefulWidget {
  const WsPage({super.key});

  @override
  State<WsPage> createState() => _WsPageState();
}

class _WsPageState extends State<WsPage> {
  late final TextEditingController _urlController;
  late final TextEditingController _messageController;

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController(text: 'wss://ws.ifelse.io');
    _messageController = TextEditingController();
  }

  @override
  void dispose() {
    _urlController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BLoC + WebSocket Demo')),
      body: BlocConsumer<WsBloc, WsState>(
        listener: (context, state) {
          if (state.status == WsStatus.error && state.errorMessage != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          }
        },
        builder: (context, state) {
          final canSend = state.status == WsStatus.connected;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _urlController,
                  decoration: const InputDecoration(
                    labelText: 'WebSocket URL',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: [
                    FilledButton(
                      onPressed: () {
                        context.read<WsBloc>().add(
                          WsConnectRequested(_urlController.text),
                        );
                      },
                      child: const Text('Connect'),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        context.read<WsBloc>().add(
                          const WsDisconnectRequested(),
                        );
                      },
                      child: const Text('Disconnect'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _StatusLine(state: state),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        enabled: canSend,
                        decoration: const InputDecoration(
                          labelText: 'Message',
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: (_) => _sendMessage(context),
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: canSend ? () => _sendMessage(context) : null,
                      child: const Text('Send'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Messages',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: state.messages.isEmpty
                        ? const Center(child: Text('No messages yet.'))
                        : ListView.builder(
                            padding: const EdgeInsets.all(12),
                            itemCount: state.messages.length,
                            itemBuilder: (context, index) {
                              final message = state
                                  .messages[state.messages.length - 1 - index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Text(message),
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
    );
  }

  void _sendMessage(BuildContext context) {
    final message = _messageController.text.trim();
    if (message.isEmpty) {
      return;
    }
    context.read<WsBloc>().add(WsSendPressed(message));
    _messageController.clear();
  }
}

class _StatusLine extends StatelessWidget {
  const _StatusLine({required this.state});

  final WsState state;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (state.status) {
      WsStatus.disconnected => ('Disconnected', Colors.grey),
      WsStatus.connecting => ('Connecting', Colors.orange),
      WsStatus.connected => ('Connected', Colors.green),
      WsStatus.error => ('Error', Colors.red),
    };

    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 8),
        Text('Status: $label'),
        const SizedBox(width: 8),
        if (state.connectedUrl != null)
          Expanded(
            child: Text(
              state.connectedUrl!,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
      ],
    );
  }
}
