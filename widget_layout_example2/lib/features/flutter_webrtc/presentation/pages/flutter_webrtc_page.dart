import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';
import 'package:widget_layout_example2/features/flutter_webrtc/data/repositories/flutter_webrtc_demo_repository.dart';
import 'package:widget_layout_example2/features/flutter_webrtc/domain/entities/flutter_webrtc_demo_snapshot.dart';
import 'package:widget_layout_example2/features/flutter_webrtc/domain/repositories/flutter_webrtc_repository.dart';
import 'package:widget_layout_example2/features/flutter_webrtc/presentation/cubit/flutter_webrtc_demo_cubit.dart';
import 'package:widget_layout_example2/features/flutter_webrtc/presentation/cubit/flutter_webrtc_demo_state.dart';

@RoutePage(name: RouteName.flutterWebRtc)
class FlutterWebRtcPage extends StatefulWidget {
  const FlutterWebRtcPage({super.key});

  @override
  State<FlutterWebRtcPage> createState() => _FlutterWebRtcPageState();
}

class _FlutterWebRtcPageState extends State<FlutterWebRtcPage> {
  late final FlutterWebRtcDemoRepository _repository =
      FlutterWebRtcDemoRepository();
  late final FlutterWebRtcDemoCubit _cubit = FlutterWebRtcDemoCubit(
    repository: _repository,
  );

  @override
  void initState() {
    super.initState();
    _cubit.initialize();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<FlutterWebRtcRepository>.value(
      value: _repository,
      child: BlocProvider<FlutterWebRtcDemoCubit>.value(
        value: _cubit,
        child: const _FlutterWebRtcView(),
      ),
    );
  }
}

class _FlutterWebRtcView extends StatelessWidget {
  const _FlutterWebRtcView();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return BlocBuilder<FlutterWebRtcDemoCubit, FlutterWebRtcDemoState>(
      builder: (BuildContext context, FlutterWebRtcDemoState state) {
        final FlutterWebRtcDemoSnapshot snapshot = state.snapshot;

        return Scaffold(
          appBar: AppBar(title: const Text('flutter_webrtc Module')),
          body: ListView(
            padding: const EdgeInsets.all(24),
            children: <Widget>[
              Text(
                'flutter_webrtc gives Flutter direct access to camera, microphone, PeerConnection negotiation, ICE candidate exchange, and low-latency media rendering.',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              Text(snapshot.effectSummary, style: theme.textTheme.bodyLarge),
              const SizedBox(height: 24),
              _SectionCard(
                title: 'Why This Package Matters',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _InfoRow(label: 'Core role', value: snapshot.explanation),
                    const SizedBox(height: 12),
                    _InfoRow(
                      label: 'Visible effect in this demo',
                      value:
                          'Left video is your directly captured local stream. Right video is the same stream delivered back through WebRTC offer/answer plus ICE inside the app.',
                    ),
                    const SizedBox(height: 12),
                    _InfoRow(
                      label: 'Typical real-world uses',
                      value:
                          'Video call, voice call, live classroom, remote support, screen sharing, low-latency monitoring, and peer-to-peer media transport.',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _SectionCard(
                title: 'Loopback Demo',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: <Widget>[
                        FilledButton.icon(
                          onPressed: snapshot.isSupported && !snapshot.isBusy
                              ? context
                                    .read<FlutterWebRtcDemoCubit>()
                                    .restartLoopback
                              : null,
                          icon: const Icon(Icons.play_circle_outline),
                          label: Text(
                            snapshot.localVideoReady ||
                                    snapshot.remoteVideoReady
                                ? 'Restart Loopback'
                                : 'Start Loopback',
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed:
                              snapshot.localVideoReady && !snapshot.isBusy
                              ? context
                                    .read<FlutterWebRtcDemoCubit>()
                                    .toggleCameraEnabled
                              : null,
                          icon: Icon(
                            snapshot.cameraEnabled
                                ? Icons.videocam_off_outlined
                                : Icons.videocam_outlined,
                          ),
                          label: Text(
                            snapshot.cameraEnabled
                                ? 'Disable Camera'
                                : 'Enable Camera',
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed:
                              snapshot.localVideoReady && !snapshot.isBusy
                              ? context
                                    .read<FlutterWebRtcDemoCubit>()
                                    .toggleMicrophoneEnabled
                              : null,
                          icon: Icon(
                            snapshot.microphoneEnabled
                                ? Icons.mic_off_outlined
                                : Icons.mic_none_outlined,
                          ),
                          label: Text(
                            snapshot.microphoneEnabled
                                ? 'Mute Microphone'
                                : 'Unmute Microphone',
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed:
                              snapshot.localVideoReady &&
                                  snapshot.isSupported &&
                                  !snapshot.isBusy
                              ? context
                                    .read<FlutterWebRtcDemoCubit>()
                                    .switchCamera
                              : null,
                          icon: const Icon(Icons.cameraswitch_outlined),
                          label: const Text('Switch Camera'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _StatusStrip(snapshot: snapshot),
                    const SizedBox(height: 20),
                    LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints constraints) {
                        final bool stacked = constraints.maxWidth < 840;
                        if (stacked) {
                          return Column(
                            children: <Widget>[
                              _VideoPanel(
                                title: 'Local capture',
                                subtitle:
                                    'Direct camera preview from getUserMedia.',
                                renderer: state.localRenderer,
                                mirror: snapshot.usingFrontCamera,
                                isActive: snapshot.localVideoReady,
                              ),
                              const SizedBox(height: 16),
                              _VideoPanel(
                                title: 'Remote loopback',
                                subtitle:
                                    'Rendered after WebRTC negotiation and track delivery.',
                                renderer: state.remoteRenderer,
                                mirror: false,
                                isActive: snapshot.remoteVideoReady,
                              ),
                            ],
                          );
                        }

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: _VideoPanel(
                                title: 'Local capture',
                                subtitle:
                                    'Direct camera preview from getUserMedia.',
                                renderer: state.localRenderer,
                                mirror: snapshot.usingFrontCamera,
                                isActive: snapshot.localVideoReady,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _VideoPanel(
                                title: 'Remote loopback',
                                subtitle:
                                    'Rendered after WebRTC negotiation and track delivery.',
                                renderer: state.remoteRenderer,
                                mirror: false,
                                isActive: snapshot.remoteVideoReady,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _SectionCard(
                title: 'What To Observe',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    for (final String step in snapshot.steps) ...<Widget>[
                      _StepRow(text: step),
                      const SizedBox(height: 10),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _SectionCard(
                title: 'Clean Architecture In This Module',
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _InfoRow(
                      label: 'Domain',
                      value:
                          'FlutterWebRtcDemoSnapshot and FlutterWebRtcRepository define the demo state and feature contract.',
                    ),
                    SizedBox(height: 10),
                    _InfoRow(
                      label: 'Data',
                      value:
                          'FlutterWebRtcDemoRuntime owns MediaStream, RTCPeerConnection, ICE forwarding, and RTCVideoRenderer lifecycle.',
                    ),
                    SizedBox(height: 10),
                    _InfoRow(
                      label: 'Presentation',
                      value:
                          'FlutterWebRtcDemoCubit reacts to repository snapshots, and FlutterWebRtcPage renders local/remote video plus control buttons.',
                    ),
                  ],
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => context.router.replacePath('/'),
            icon: const Icon(Icons.home),
            label: const Text('Home'),
          ),
        );
      },
    );
  }
}

class _StatusStrip extends StatelessWidget {
  const _StatusStrip({required this.snapshot});

  final FlutterWebRtcDemoSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: <Widget>[
              _StatusChip(
                label: 'Connection: ${snapshot.connectionStateLabel}',
                active:
                    snapshot.connectionStateLabel == 'connected' ||
                    snapshot.connectionStateLabel == 'completed',
              ),
              _StatusChip(
                label: 'ICE: ${snapshot.iceStateLabel}',
                active: snapshot.remoteVideoReady,
              ),
              _StatusChip(
                label: snapshot.cameraEnabled ? 'Camera on' : 'Camera off',
                active: snapshot.cameraEnabled,
              ),
              _StatusChip(
                label: snapshot.microphoneEnabled ? 'Mic on' : 'Mic muted',
                active: snapshot.microphoneEnabled,
              ),
              _StatusChip(
                label: snapshot.usingFrontCamera
                    ? 'Front camera'
                    : 'Rear camera',
                active: true,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(snapshot.statusMessage, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _VideoPanel extends StatelessWidget {
  const _VideoPanel({
    required this.title,
    required this.subtitle,
    required this.renderer,
    required this.mirror,
    required this.isActive,
  });

  final String title;
  final String subtitle;
  final RTCVideoRenderer renderer;
  final bool mirror;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(subtitle, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 14),
            AspectRatio(
              aspectRatio: 16 / 10,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: theme.colorScheme.outlineVariant),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: RTCVideoView(
                    renderer,
                    mirror: mirror,
                    objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                    placeholderBuilder: (BuildContext context) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(
                              isActive
                                  ? Icons.hourglass_top_rounded
                                  : Icons.videocam_off_outlined,
                              size: 36,
                              color: Colors.white70,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              isActive
                                  ? 'Waiting for first frame...'
                                  : 'No video yet',
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
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
            const SizedBox(height: 14),
            child,
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return RichText(
      text: TextSpan(
        style: theme.textTheme.bodyLarge,
        children: <InlineSpan>[
          TextSpan(
            text: '$label: ',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          TextSpan(text: value),
        ],
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.only(top: 4),
          child: Icon(Icons.check_circle_outline, size: 18),
        ),
        const SizedBox(width: 10),
        Expanded(child: Text(text)),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label, required this.active});

  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: active
            ? theme.colorScheme.primaryContainer
            : theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
