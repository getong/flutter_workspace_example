import 'dart:convert';
import 'dart:typed_data';

import 'package:bloc_spawn_ws_example/websocket/bloc/ws_bloc.dart';
import 'package:bloc_spawn_ws_example/websocket/bloc/ws_event.dart';
import 'package:bloc_spawn_ws_example/websocket/bloc/ws_state.dart';
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
    _messageController = TextEditingController(text: 'hello from main isolate');
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
      appBar: AppBar(title: const Text('BLoC + Spawned Isolate WebSocket')),
      body: BlocConsumer<WsBloc, WsState>(
        listener: (context, state) {
          final errorMessage = state.errorMessage;
          if (state.status == WsStatus.error && errorMessage != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(errorMessage)));
          }
        },
        builder: (context, state) {
          final connected = state.status == WsStatus.connected;
          return LayoutBuilder(
            builder: (context, constraints) {
              final logHeight = (constraints.maxHeight * 0.3).clamp(
                160.0,
                280.0,
              );

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  TextField(
                    controller: _urlController,
                    decoration: const InputDecoration(
                      labelText: 'WebSocket URL',
                      hintText: 'wss://ws.ifelse.io',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
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
                  const SizedBox(height: 16),
                  TextField(
                    controller: _messageController,
                    enabled: connected,
                    decoration: const InputDecoration(
                      labelText: 'Outgoing text',
                      hintText: 'sent as text, or converted to bytes below',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _sendText(context),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      FilledButton(
                        onPressed: connected ? () => _sendText(context) : null,
                        child: const Text('Send Text'),
                      ),
                      FilledButton.tonal(
                        onPressed: connected
                            ? () => _sendBinary(context)
                            : null,
                        child: const Text('Send Binary'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Latest binary payload',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  _BinaryPayloadCard(state: state),
                  const SizedBox(height: 16),
                  Text(
                    'Event log',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: logHeight,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: state.logs.isEmpty
                          ? const Center(
                              child: Text('No websocket activity yet.'),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(12),
                              itemCount: state.logs.length,
                              itemBuilder: (context, index) {
                                final log =
                                    state.logs[state.logs.length - 1 - index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Text(log),
                                );
                              },
                            ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  void _sendText(BuildContext context) {
    final message = _messageController.text.trim();
    if (message.isEmpty) {
      return;
    }
    context.read<WsBloc>().add(WsSendTextPressed(message));
  }

  void _sendBinary(BuildContext context) {
    final message = _messageController.text.trim();
    final bytes = Uint8List.fromList(
      utf8.encode(message.isEmpty ? 'ping' : message),
    );
    context.read<WsBloc>().add(WsSendBinaryPressed(bytes));
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

class _BinaryPayloadCard extends StatelessWidget {
  const _BinaryPayloadCard({required this.state});

  final WsState state;

  @override
  Widget build(BuildContext context) {
    final latest = state.latestRecord;
    if (latest == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black12),
        ),
        child: const Text('Waiting for binary websocket data.'),
      );
    }

    final hex = latest.bytes
        .map((value) => value.toRadixString(16).padLeft(2, '0'))
        .join(' ');
    final asciiPreview = utf8.decode(latest.bytes, allowMalformed: true);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.teal.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.teal.shade100),
      ),
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.bodyMedium!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Frames received: ${state.history.length}'),
            const SizedBox(height: 6),
            Text('Source type: ${latest.sourceType}'),
            const SizedBox(height: 6),
            Text('Bytes: ${latest.bytes.length}'),
            const SizedBox(height: 6),
            Text('Received at: ${latest.receivedAt.toLocal()}'),
            const SizedBox(height: 12),
            const Text('Hex'),
            const SizedBox(height: 4),
            SelectableText(hex),
            const SizedBox(height: 12),
            const Text('UTF-8 preview'),
            const SizedBox(height: 4),
            SelectableText(jsonEncode(asciiPreview)),
          ],
        ),
      ),
    );
  }
}
