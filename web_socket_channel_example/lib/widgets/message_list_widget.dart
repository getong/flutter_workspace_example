import 'package:flutter/material.dart';
import '../models/websocket_message.dart';

/// Widget to display WebSocket messages
class MessageListWidget extends StatelessWidget {
  static const _compactLayoutThreshold = 140.0;

  final List<WebSocketMessage> messages;
  final VoidCallback onClearMessages;

  const MessageListWidget({
    super.key,
    required this.messages,
    required this.onClearMessages,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxHeight < _compactLayoutThreshold) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: constraints.maxWidth),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildHeader(context),
                      _buildCompactBody(context),
                    ],
                  ),
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(context),
                Expanded(child: _buildScrollableBody(context)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Messages (${messages.length})',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          if (messages.isNotEmpty)
            TextButton.icon(
              onPressed: onClearMessages,
              icon: const Icon(Icons.clear_all, size: 16),
              label: const Text('Clear'),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildScrollableBody(BuildContext context) {
    if (messages.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            'No messages yet.\nConnect to a WebSocket server and send a message to see it here.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: messages.length,
      itemBuilder: (context, index) =>
          _buildMessageCard(context, messages[index]),
    );
  }

  Widget _buildCompactBody(BuildContext context) {
    if (messages.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(12.0),
        child: Text(
          'No messages yet. Connect to the Axum websocket server to begin.',
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: messages
            .map((message) => _buildMessageCard(context, message))
            .toList(),
      ),
    );
  }

  Widget _buildMessageCard(BuildContext context, WebSocketMessage message) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: message.type == MessageType.sent
            ? Colors.blue.shade50
            : message.type == MessageType.received
            ? Colors.green.shade50
            : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: message.type == MessageType.sent
              ? Colors.blue.shade200
              : message.type == MessageType.received
              ? Colors.green.shade200
              : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    _getMessageIcon(message.type),
                    size: 16,
                    color: _getIconColor(message.type),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _getMessageTypeLabel(message.type),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _getIconColor(message.type),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Text(
                _formatTimestamp(message.timestamp),
                style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(message.content, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.hour.toString().padLeft(2, '0')}:'
        '${timestamp.minute.toString().padLeft(2, '0')}:'
        '${timestamp.second.toString().padLeft(2, '0')}';
  }

  IconData _getMessageIcon(MessageType type) {
    switch (type) {
      case MessageType.sent:
        return Icons.arrow_upward;
      case MessageType.received:
        return Icons.arrow_downward;
      case MessageType.connection:
        return Icons.link;
      case MessageType.error:
        return Icons.error_outline;
      case MessageType.info:
        return Icons.info_outline;
    }
  }

  Color _getIconColor(MessageType type) {
    switch (type) {
      case MessageType.sent:
        return Colors.blue;
      case MessageType.received:
        return Colors.green;
      case MessageType.connection:
        return Colors.purple;
      case MessageType.error:
        return Colors.red;
      case MessageType.info:
        return Colors.orange;
    }
  }

  String _getMessageTypeLabel(MessageType type) {
    switch (type) {
      case MessageType.sent:
        return 'Sent';
      case MessageType.received:
        return 'Received';
      case MessageType.connection:
        return 'Connection';
      case MessageType.error:
        return 'Error';
      case MessageType.info:
        return 'Info';
    }
  }
}
