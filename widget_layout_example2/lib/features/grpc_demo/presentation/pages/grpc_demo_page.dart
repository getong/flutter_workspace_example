import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';
import 'package:widget_layout_example2/features/grpc_demo/domain/entities/grpc_demo_snapshot.dart';
import 'package:widget_layout_example2/features/grpc_demo/presentation/view_models/grpc_demo_view_model.dart';

@RoutePage(name: RouteName.grpcDemo)
class GrpcDemoPage extends StatefulWidget {
  const GrpcDemoPage({super.key});

  @override
  State<GrpcDemoPage> createState() => _GrpcDemoPageState();
}

class _GrpcDemoPageState extends State<GrpcDemoPage> {
  final GrpcDemoViewModel _viewModel = GrpcDemoViewModel();
  final TextEditingController _userIdController = TextEditingController(
    text: 'demo-admin',
  );
  final TextEditingController _roleController = TextEditingController(
    text: 'maintainer',
  );
  final TextEditingController _targetController = TextEditingController(
    text: 'flutter-grpc-client',
  );

  int _steps = 4;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _runDemo());
  }

  @override
  void dispose() {
    _userIdController.dispose();
    _roleController.dispose();
    _targetController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _runDemo() {
    return _viewModel.runDemo(
      userId: _userIdController.text,
      preferredRole: _roleController.text,
      target: _targetController.text,
      steps: _steps,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('gRPC + protobuf Module')),
      body: SelectionArea(
        child: ListenableBuilder(
          listenable: _viewModel,
          builder: (BuildContext context, Widget? child) {
            return ListView(
              padding: const EdgeInsets.all(24),
              children: <Widget>[
                Text(
                  'gRPC turns a protobuf contract into typed client/server methods, then carries compact binary messages over HTTP/2.',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'This demo starts a local Dart gRPC server, calls it through the generated client stub, maps protobuf DTOs in the repository, and exposes domain state to the UI.',
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 24),
                _InputCard(
                  userIdController: _userIdController,
                  roleController: _roleController,
                  targetController: _targetController,
                  steps: _steps,
                  isRunning: _viewModel.isRunning,
                  onStepsChanged: (int value) => setState(() {
                    _steps = value;
                  }),
                  onRun: _runDemo,
                  onReset: () {
                    _userIdController.text = 'demo-admin';
                    _roleController.text = 'maintainer';
                    _targetController.text = 'flutter-grpc-client';
                    setState(() {
                      _steps = 4;
                    });
                    _runDemo();
                  },
                ),
                if (_viewModel.error != null) ...<Widget>[
                  const SizedBox(height: 16),
                  _ErrorCard(message: _viewModel.error!),
                ],
                const SizedBox(height: 16),
                _ArchitectureCard(),
                if (_viewModel.snapshot != null) ...<Widget>[
                  const SizedBox(height: 16),
                  _SummaryCard(snapshot: _viewModel.snapshot!),
                  const SizedBox(height: 16),
                  _ProfileCard(snapshot: _viewModel.snapshot!),
                  const SizedBox(height: 16),
                  _StreamCard(events: _viewModel.snapshot!.events),
                ],
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.router.replacePath('/'),
        icon: const Icon(Icons.home),
        label: const Text('Home'),
      ),
    );
  }
}

class _InputCard extends StatelessWidget {
  const _InputCard({
    required this.userIdController,
    required this.roleController,
    required this.targetController,
    required this.steps,
    required this.isRunning,
    required this.onStepsChanged,
    required this.onRun,
    required this.onReset,
  });

  final TextEditingController userIdController;
  final TextEditingController roleController;
  final TextEditingController targetController;
  final int steps;
  final bool isRunning;
  final ValueChanged<int> onStepsChanged;
  final VoidCallback onRun;
  final VoidCallback onReset;

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
              'Request input',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final bool useColumns = constraints.maxWidth >= 720;
                final List<Widget> fields = <Widget>[
                  TextField(
                    controller: userIdController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'ProfileRequest.user_id',
                    ),
                  ),
                  TextField(
                    controller: roleController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'ProfileRequest.preferred_role',
                    ),
                  ),
                  TextField(
                    controller: targetController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'BuildRequest.target',
                    ),
                  ),
                ];

                if (!useColumns) {
                  return Column(
                    children: fields
                        .map(
                          (Widget field) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: field,
                          ),
                        )
                        .toList(growable: false),
                  );
                }

                return Row(
                  children: fields
                      .map(
                        (Widget field) => Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: field,
                          ),
                        ),
                      )
                      .toList(growable: false),
                );
              },
            ),
            const SizedBox(height: 12),
            Text(
              'BuildRequest.steps: $steps',
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            Slider(
              value: steps.toDouble(),
              min: 1,
              max: 6,
              divisions: 5,
              label: '$steps',
              onChanged: isRunning
                  ? null
                  : (double value) => onStepsChanged(value.round()),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: <Widget>[
                FilledButton.icon(
                  onPressed: isRunning ? null : onRun,
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: Text(isRunning ? 'Running...' : 'Run gRPC Call'),
                ),
                OutlinedButton.icon(
                  onPressed: isRunning ? null : onReset,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset Sample'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ArchitectureCard extends StatelessWidget {
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
              'Clean architecture flow',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 16),
            const Wrap(
              spacing: 12,
              runSpacing: 12,
              children: <Widget>[
                _FlowChip(icon: Icons.description_outlined, label: '.proto'),
                _FlowChip(
                  icon: Icons.auto_fix_high_outlined,
                  label: 'generated stub',
                ),
                _FlowChip(icon: Icons.dns_outlined, label: 'data service'),
                _FlowChip(
                  icon: Icons.swap_horiz_outlined,
                  label: 'repository mapper',
                ),
                _FlowChip(
                  icon: Icons.account_tree_outlined,
                  label: 'domain snapshot',
                ),
                _FlowChip(
                  icon: Icons.view_agenda_outlined,
                  label: 'view model',
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'The UI never imports gRPC types. The repository owns the generated protobuf DTOs and returns domain entities that are easier to test and replace.',
            ),
          ],
        ),
      ),
    );
  }
}

class _FlowChip extends StatelessWidget {
  const _FlowChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(avatar: Icon(icon, size: 18), label: Text(label));
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.snapshot});

  final GrpcDemoSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: <Widget>[
            _MetricTile(
              label: 'Endpoint',
              value: snapshot.endpoint,
              icon: Icons.lan_outlined,
            ),
            _MetricTile(
              label: 'Elapsed',
              value: '${snapshot.elapsed.inMilliseconds} ms',
              icon: Icons.timer_outlined,
            ),
            _MetricTile(
              label: 'Unary bytes',
              value: '${snapshot.unaryBytes}',
              icon: Icons.call_made_outlined,
            ),
            _MetricTile(
              label: 'Stream bytes',
              value: '${snapshot.streamBytes}',
              icon: Icons.stream_outlined,
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 160, maxWidth: 260),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withValues(
            alpha: 0.55,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(icon, size: 22),
              const SizedBox(width: 10),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(label, style: theme.textTheme.labelMedium),
                    const SizedBox(height: 2),
                    Text(
                      value,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.snapshot});

  final GrpcDemoSnapshot snapshot;

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
              'UnaryProfile response',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            _DataRow(label: 'user_id', value: snapshot.userId),
            _DataRow(label: 'display_name', value: snapshot.displayName),
            _DataRow(label: 'role', value: snapshot.role),
            _DataRow(
              label: 'server_time_iso',
              value: snapshot.serverTime.toIso8601String(),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: snapshot.capabilities
                  .map((String value) => Chip(label: Text(value)))
                  .toList(growable: false),
            ),
          ],
        ),
      ),
    );
  }
}

class _StreamCard extends StatelessWidget {
  const _StreamCard({required this.events});

  final List<GrpcBuildEvent> events;

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
              'WatchBuild server stream',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            ...events.map((GrpcBuildEvent event) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 14,
                      child: event.done
                          ? const Icon(Icons.check, size: 16)
                          : Text('${event.step}'),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            event.phase,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(event.detail),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _DataRow extends StatelessWidget {
  const _DataRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          SelectableText(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      color: theme.colorScheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          message,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onErrorContainer,
          ),
        ),
      ),
    );
  }
}
