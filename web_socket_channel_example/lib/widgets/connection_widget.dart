import 'package:flutter/material.dart';
import '../models/connection_state.dart';

/// Widget for managing WebSocket connection
class ConnectionWidget extends StatefulWidget {
  final TextEditingController urlController;
  final TextEditingController tokenController;
  final WebSocketConnectionState connectionState;
  final VoidCallback onConnect;
  final VoidCallback onDisconnect;

  const ConnectionWidget({
    super.key,
    required this.urlController,
    required this.tokenController,
    required this.connectionState,
    required this.onConnect,
    required this.onDisconnect,
  });

  @override
  State<ConnectionWidget> createState() => _ConnectionWidgetState();
}

class _ConnectionWidgetState extends State<ConnectionWidget> {
  @override
  Widget build(BuildContext context) {
    final isConnected =
        widget.connectionState == WebSocketConnectionState.connected;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Connection', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            TextField(
              controller: widget.urlController,
              enabled: !isConnected,
              decoration: const InputDecoration(
                labelText: 'WebSocket URL',
                hintText: 'wss://127.0.0.1:3000/ws',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.link),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: widget.tokenController,
              enabled: !isConnected,
              maxLines: 2,
              minLines: 1,
              decoration: const InputDecoration(
                labelText: 'Supabase Access Token',
                hintText: 'Paste the access_token from /auth/supabase/signin',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.vpn_key),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Secure Axum endpoint: use wss://127.0.0.1:3000/ws on desktop, iOS simulator, and web. Use wss://10.0.2.2:3000/ws on the Android emulator. The token is appended as ?access_token=... when connecting.',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        _getStatusIcon(widget.connectionState),
                        color: _getStatusColor(widget.connectionState),
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Status: ${widget.connectionState.displayName}',
                        style: TextStyle(
                          color: _getStatusColor(widget.connectionState),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed:
                      widget.connectionState ==
                          WebSocketConnectionState.connecting
                      ? null
                      : (isConnected ? widget.onDisconnect : widget.onConnect),
                  icon: Icon(isConnected ? Icons.link_off : Icons.link),
                  label: Text(isConnected ? 'Disconnect' : 'Connect'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isConnected ? Colors.red : Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getStatusIcon(WebSocketConnectionState state) {
    switch (state) {
      case WebSocketConnectionState.disconnected:
        return Icons.link_off;
      case WebSocketConnectionState.connecting:
        return Icons.sync;
      case WebSocketConnectionState.connected:
        return Icons.link;
      case WebSocketConnectionState.error:
        return Icons.error;
    }
  }

  Color _getStatusColor(WebSocketConnectionState state) {
    switch (state) {
      case WebSocketConnectionState.disconnected:
        return Colors.grey;
      case WebSocketConnectionState.connecting:
        return Colors.orange;
      case WebSocketConnectionState.connected:
        return Colors.green;
      case WebSocketConnectionState.error:
        return Colors.red;
    }
  }
}
