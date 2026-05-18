import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';
import 'package:widget_layout_example2/features/flutter_rust_bridge_libp2p_webrtc/data/repositories/frb_libp2p_webrtc_bridge_repository.dart';
import 'package:widget_layout_example2/features/flutter_rust_bridge_libp2p_webrtc/domain/entities/libp2p_webrtc_demo_snapshot.dart';
import 'package:widget_layout_example2/features/flutter_rust_bridge_libp2p_webrtc/domain/repositories/libp2p_webrtc_bridge_repository.dart';
import 'package:widget_layout_example2/features/flutter_rust_bridge_libp2p_webrtc/presentation/bloc/libp2p_webrtc_demo_bloc.dart';
import 'package:widget_layout_example2/features/flutter_rust_bridge_libp2p_webrtc/presentation/bloc/libp2p_webrtc_demo_event.dart';
import 'package:widget_layout_example2/features/flutter_rust_bridge_libp2p_webrtc/presentation/bloc/libp2p_webrtc_demo_state.dart';

@RoutePage(name: RouteName.flutterRustBridgeLibp2pWebRtc)
class FlutterRustBridgeLibp2pWebRtcPage extends StatefulWidget {
  const FlutterRustBridgeLibp2pWebRtcPage({super.key});

  @override
  State<FlutterRustBridgeLibp2pWebRtcPage> createState() =>
      _FlutterRustBridgeLibp2pWebRtcPageState();
}

class _FlutterRustBridgeLibp2pWebRtcPageState
    extends State<FlutterRustBridgeLibp2pWebRtcPage> {
  _FlutterRustBridgeLibp2pWebRtcPageState({
    Libp2pWebRtcBridgeRepository? repository,
  }) : _repository = repository ?? FrbLibp2pWebRtcBridgeRepository();

  final Libp2pWebRtcBridgeRepository _repository;
  late final Libp2pWebRtcDemoBloc _bloc = Libp2pWebRtcDemoBloc(
    repository: _repository,
  );

  final TextEditingController _multiaddrController = TextEditingController();
  final TextEditingController _timeoutController = TextEditingController(
    text: '12',
  );
  final TextEditingController _messageController = TextEditingController(
    text: 'hello from flutter',
  );

  @override
  void initState() {
    super.initState();
    _bloc.add(const Libp2pWebRtcDemoInitializeRequested());
  }

  @override
  void dispose() {
    _multiaddrController.dispose();
    _timeoutController.dispose();
    _messageController.dispose();
    _bloc.close();
    super.dispose();
  }

  void _submitDial() {
    _bloc.add(
      Libp2pWebRtcDemoDialRequested(
        serverMultiaddr: _multiaddrController.text.trim(),
        timeoutSeconds: int.tryParse(_timeoutController.text.trim()) ?? 12,
        message: _messageController.text.trim(),
      ),
    );
  }

  Future<void> _copyFailureReason(String message) async {
    await Clipboard.setData(ClipboardData(text: message));
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Failure reason copied.')));
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return BlocProvider<Libp2pWebRtcDemoBloc>.value(
      value: _bloc,
      child: BlocBuilder<Libp2pWebRtcDemoBloc, Libp2pWebRtcDemoState>(
        builder: (BuildContext context, Libp2pWebRtcDemoState state) {
          final Libp2pWebRtcDemoSnapshot snapshot = state.snapshot;
          final bool hasFailureReason =
              !snapshot.hasSuccessfulDial &&
              snapshot.statusMessage.startsWith('Dial failed:');

          return Scaffold(
            appBar: AppBar(
              title: const Text('flutter_rust_bridge + libp2p-webrtc Module'),
            ),
            body: ListView(
              padding: const EdgeInsets.all(24),
              children: <Widget>[
                Text(
                  'This feature uses clean architecture on the Flutter side, flutter_rust_bridge as the FFI boundary, and a native Rust libp2p-webrtc client to dial a dedicated Rust server.',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                Text(snapshot.explanation, style: theme.textTheme.bodyLarge),
                const SizedBox(height: 24),
                Card(
                  clipBehavior: Clip.antiAlias,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Dial a Rust libp2p WebRTC server',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Start the dedicated server example in the Rust workspace, copy one printed /webrtc-direct/certhash/.../p2p/... multiaddr, and submit it here.',
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _multiaddrController,
                          minLines: 2,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Server multiaddr',
                            hintText:
                                '/ip4/192.168.1.10/udp/43123/webrtc-direct/certhash/.../p2p/...',
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _timeoutController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Timeout seconds',
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _messageController,
                          minLines: 2,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Chat message',
                            hintText: 'Type a message for the Rust server',
                          ),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: <Widget>[
                            FilledButton.icon(
                              onPressed: state.isBusy ? null : _submitDial,
                              icon: const Icon(Icons.send_outlined),
                              label: Text(
                                state.isBusy
                                    ? 'Sending...'
                                    : 'Connect And Send',
                              ),
                            ),
                            OutlinedButton.icon(
                              onPressed: state.isBusy
                                  ? null
                                  : () {
                                      _multiaddrController.clear();
                                      _timeoutController.text = '12';
                                      _messageController.text =
                                          'hello from flutter';
                                    },
                              icon: const Icon(Icons.clear),
                              label: const Text('Clear'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        if (hasFailureReason) ...<Widget>[
                          SelectableText(
                            snapshot.statusMessage,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.error,
                            ),
                          ),
                          const SizedBox(height: 12),
                          OutlinedButton.icon(
                            onPressed: () =>
                                _copyFailureReason(snapshot.statusMessage),
                            icon: const Icon(Icons.content_copy_outlined),
                            label: const Text('Copy Failure Reason'),
                          ),
                        ] else
                          Text(
                            snapshot.statusMessage,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: snapshot.hasSuccessfulDial
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.error,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _InfoCard(snapshot: snapshot),
                if (snapshot.hasSuccessfulDial) ...<Widget>[
                  const SizedBox(height: 16),
                  _ResultCard(
                    title: 'Connection result',
                    rows: <_ResultRow>[
                      _ResultRow(
                        label: 'Dialed multiaddr',
                        value: snapshot.serverMultiaddr,
                      ),
                      _ResultRow(
                        label: 'Local peer id',
                        value: snapshot.localPeerId,
                      ),
                      _ResultRow(
                        label: 'Remote peer id',
                        value: snapshot.remotePeerId,
                      ),
                      _ResultRow(
                        label: 'Sent message',
                        value: snapshot.lastSentMessage,
                      ),
                      _ResultRow(
                        label: 'Server response',
                        value: snapshot.lastEchoedMessage,
                      ),
                      _ResultRow(
                        label: 'Server timestamp',
                        value: snapshot.lastServerTimestamp,
                      ),
                    ],
                  ),
                ],
              ],
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () => context.router.replacePath('/'),
              icon: const Icon(Icons.home),
              label: const Text('Home'),
            ),
          );
        },
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.snapshot});

  final Libp2pWebRtcDemoSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Architecture split',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Flutter owns the page, bloc, and repository boundary. flutter_rust_bridge owns the glue code. Rust owns the native libp2p-webrtc transport, Noise handshake, and ping behaviour.',
            ),
            const SizedBox(height: 16),
            ...snapshot.steps.map(
              (String step) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Icon(Icons.check_circle_outline, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Text(step)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.title, required this.rows});

  final String title;
  final List<_ResultRow> rows;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 16),
            ...rows.map(
              (_ResultRow row) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      row.label,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    SelectableText(row.value),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultRow {
  const _ResultRow({required this.label, required this.value});

  final String label;
  final String value;
}

// rust_example/libp2p_workspace_example/libp2p_flutter_webrtc_server_example
