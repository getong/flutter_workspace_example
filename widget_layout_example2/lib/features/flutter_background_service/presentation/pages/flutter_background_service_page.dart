import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:widget_layout_example2/app_navigation.dart';
import 'package:widget_layout_example2/features/flutter_background_service/domain/entities/background_service_snapshot.dart';
import 'package:widget_layout_example2/features/flutter_background_service/presentation/bloc/background_service_demo_bloc.dart';
import 'package:widget_layout_example2/features/flutter_background_service/presentation/bloc/background_service_demo_event.dart';
import 'package:widget_layout_example2/features/flutter_background_service/presentation/bloc/background_service_demo_state.dart';

@RoutePage(name: RouteName.flutterBackgroundService)
class FlutterBackgroundServicePage extends StatefulWidget {
  const FlutterBackgroundServicePage({super.key});

  @override
  State<FlutterBackgroundServicePage> createState() =>
      _FlutterBackgroundServicePageState();
}

class _FlutterBackgroundServicePageState
    extends State<FlutterBackgroundServicePage> {
  @override
  void initState() {
    super.initState();
    context.read<BackgroundServiceDemoBloc>().add(
      const BackgroundServiceDemoInitializeRequested(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('flutter_background_service Module')),
      body: SelectionArea(
        child: BlocBuilder<BackgroundServiceDemoBloc, BackgroundServiceDemoState>(
          builder: (BuildContext context, BackgroundServiceDemoState state) {
            final BackgroundServiceSnapshot snapshot = state.snapshot;
            return ListView(
              padding: const EdgeInsets.all(24),
              children: <Widget>[
                const Text(
                  'flutter_background_service runs Dart code in a dedicated isolate so background work can continue outside the page widget tree. This demo wires the plugin through clean architecture layers and shows the observable runtime effects.',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 20),
                const _InfoCard(
                  title: 'What To Observe',
                  description:
                      '1. Bootstrap configures the plugin before runApp(). 2. Start Service spawns a background isolate. 3. The heartbeat counter and log update every 5 seconds. 4. On Android, you can move the app to background and reopen it to confirm the persisted heartbeat still advanced.',
                ),
                const SizedBox(height: 16),
                const _InfoCard(
                  title: 'Clean Architecture Shape',
                  description:
                      'Presentation -> BackgroundServiceDemoBloc\nDomain -> BackgroundServiceRepository + BackgroundServiceSnapshot\nData -> FlutterBackgroundServiceDemoRepository + BackgroundServiceDemoRuntime\nPlugin boundary -> flutter_background_service + flutter_local_notifications + shared_preferences',
                ),
                const SizedBox(height: 16),
                const _CodeCard(
                  title: 'Bootstrap In The UI Isolate',
                  code: '''
await backgroundServiceDemoRepository.initialize();

runApp(createWidgetLayoutApp());
''',
                ),
                const SizedBox(height: 16),
                const _CodeCard(
                  title: 'Background Isolate Entrypoint',
                  code: '''
@pragma('vm:entry-point')
void backgroundServiceDemoOnStart(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  Timer.periodic(const Duration(seconds: 5), (timer) async {
    service.invoke('background_service_demo.state', {
      'message': 'Heartbeat emitted from the background isolate.',
    });
  });
}
''',
                ),
                const SizedBox(height: 16),
                const _CodeCard(
                  title: 'Repository Contract',
                  code: '''
abstract interface class BackgroundServiceRepository {
  Stream<BackgroundServiceSnapshot> watchSnapshot();
  Future<BackgroundServiceSnapshot> startService();
  Future<BackgroundServiceSnapshot> stopService();
  Future<BackgroundServiceSnapshot> setForegroundMode();
  Future<BackgroundServiceSnapshot> setBackgroundMode();
}
''',
                ),
                const SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Live State',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 12),
                        _StatusPanel(
                          title: 'Platform',
                          value: snapshot.platformLabel,
                        ),
                        const SizedBox(height: 12),
                        _StatusPanel(
                          title: 'Supported',
                          value: '${snapshot.isSupported}',
                        ),
                        const SizedBox(height: 12),
                        _StatusPanel(
                          title: 'Configured',
                          value: '${snapshot.isConfigured}',
                        ),
                        const SizedBox(height: 12),
                        _StatusPanel(
                          title: 'Running',
                          value: '${snapshot.isRunning}',
                        ),
                        const SizedBox(height: 12),
                        _StatusPanel(
                          title: 'Foreground Mode',
                          value: '${snapshot.isForegroundMode}',
                        ),
                        const SizedBox(height: 12),
                        _StatusPanel(
                          title: 'Heartbeat Count',
                          value: '${snapshot.tickCount}',
                        ),
                        const SizedBox(height: 12),
                        _StatusPanel(
                          title: 'Last Heartbeat',
                          value: snapshot.lastTickLabel,
                        ),
                        const SizedBox(height: 12),
                        _StatusPanel(
                          title: 'Permission',
                          value: snapshot.permissionSummary,
                        ),
                        const SizedBox(height: 12),
                        _StatusPanel(
                          title: 'Status',
                          value: snapshot.statusMessage,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const _SectionTitle(
                  title: 'Service Controls',
                  subtitle:
                      'Every action goes through the BLoC, then the repository, then the runtime wrapper around flutter_background_service.',
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: <Widget>[
                    FilledButton.icon(
                      onPressed: state.isBusy
                          ? null
                          : () => context.read<BackgroundServiceDemoBloc>().add(
                              const BackgroundServiceDemoRequestPermissionRequested(),
                            ),
                      icon: const Icon(Icons.notifications_active_outlined),
                      label: const Text('Request Permission'),
                    ),
                    OutlinedButton.icon(
                      onPressed: state.isBusy
                          ? null
                          : () => context.read<BackgroundServiceDemoBloc>().add(
                              const BackgroundServiceDemoRefreshRequested(),
                            ),
                      icon: const Icon(Icons.refresh_outlined),
                      label: const Text('Refresh'),
                    ),
                    FilledButton.icon(
                      onPressed: !snapshot.isSupported || state.isBusy
                          ? null
                          : () => context.read<BackgroundServiceDemoBloc>().add(
                              const BackgroundServiceDemoStartRequested(),
                            ),
                      icon: const Icon(Icons.play_arrow_outlined),
                      label: const Text('Start Service'),
                    ),
                    OutlinedButton.icon(
                      onPressed: !snapshot.isSupported || state.isBusy
                          ? null
                          : () => context.read<BackgroundServiceDemoBloc>().add(
                              const BackgroundServiceDemoStopRequested(),
                            ),
                      icon: const Icon(Icons.stop_outlined),
                      label: const Text('Stop Service'),
                    ),
                    OutlinedButton.icon(
                      onPressed: !snapshot.isSupported || state.isBusy
                          ? null
                          : () => context.read<BackgroundServiceDemoBloc>().add(
                              const BackgroundServiceDemoSetForegroundRequested(),
                            ),
                      icon: const Icon(Icons.visibility_outlined),
                      label: const Text('Foreground Mode'),
                    ),
                    OutlinedButton.icon(
                      onPressed: !snapshot.isSupported || state.isBusy
                          ? null
                          : () => context.read<BackgroundServiceDemoBloc>().add(
                              const BackgroundServiceDemoSetBackgroundRequested(),
                            ),
                      icon: const Icon(Icons.visibility_off_outlined),
                      label: const Text('Background Mode'),
                    ),
                    OutlinedButton.icon(
                      onPressed: state.isBusy
                          ? null
                          : () => context.read<BackgroundServiceDemoBloc>().add(
                              const BackgroundServiceDemoClearDemoDataRequested(),
                            ),
                      icon: const Icon(Icons.cleaning_services_outlined),
                      label: const Text('Clear Demo Data'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const _InfoCard(
                  title: 'Platform Notes',
                  description:
                      'Android: this demo runs best in foreground service mode because the system keeps the isolate alive and shows an ongoing notification.\n\niOS: the plugin cannot keep a long-running Dart isolate alive like Android. The demo therefore records a foreground callback and a background-fetch callback to show the platform difference.\n\nBackground mode without the Android notification is fragile in debug mode and can be killed by the OS.',
                ),
                const SizedBox(height: 24),
                Card(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Event Log',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 12),
                        if (snapshot.logEntries.isEmpty)
                          const Text(
                            'No background activity recorded yet. Start the service to populate this list.',
                          )
                        else
                          ...snapshot.logEntries.map(
                            (String entry) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(entry),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(description),
          ],
        ),
      ),
    );
  }
}

class _CodeCard extends StatelessWidget {
  const _CodeCard({required this.title, required this.code});

  final String title;
  final String code;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                code.trim(),
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontFamily: 'monospace'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        Text(subtitle),
      ],
    );
  }
}

class _StatusPanel extends StatelessWidget {
  const _StatusPanel({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text(value),
      ],
    );
  }
}
