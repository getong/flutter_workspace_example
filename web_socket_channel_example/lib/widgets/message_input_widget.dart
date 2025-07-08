import 'package:flutter/material.dart';

/// Widget for sending messages through WebSocket
class MessageInputWidget extends StatefulWidget {
  final TextEditingController messageController;
  final bool isConnected;
  final VoidCallback onSendMessage;

  const MessageInputWidget({
    super.key,
    required this.messageController,
    required this.isConnected,
    required this.onSendMessage,
  });

  @override
  State<MessageInputWidget> createState() => _MessageInputWidgetState();
}

class _MessageInputWidgetState extends State<MessageInputWidget> {
  @override
  void initState() {
    super.initState();
    widget.messageController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.messageController.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      // Trigger rebuild when text changes
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasText = widget.messageController.text.trim().isNotEmpty;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Send Message', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: widget.messageController,
                    enabled: widget.isConnected,
                    maxLines: 3,
                    minLines: 1,
                    decoration: const InputDecoration(
                      labelText: 'Message',
                      hintText: 'Type your message here...',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.message),
                    ),
                    onSubmitted: widget.isConnected && hasText
                        ? (_) => widget.onSendMessage()
                        : null,
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  children: [
                    ElevatedButton.icon(
                      onPressed: widget.isConnected && hasText
                          ? widget.onSendMessage
                          : null,
                      icon: const Icon(Icons.send),
                      label: const Text('Send'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: hasText
                          ? () {
                              widget.messageController.clear();
                            }
                          : null,
                      icon: const Icon(Icons.clear),
                      label: const Text('Clear'),
                    ),
                  ],
                ),
              ],
            ),
            if (!widget.isConnected)
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  'Connect to a WebSocket server to send messages',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
