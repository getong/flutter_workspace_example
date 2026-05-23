import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';
import 'package:widget_layout_example2/features/leak_tracker/data/repositories/leak_tracker_repository_impl.dart';
import 'package:widget_layout_example2/features/leak_tracker/data/services/leak_tracker_service.dart';
import 'package:widget_layout_example2/features/leak_tracker/domain/entities/leak_tracker_models.dart';
import 'package:widget_layout_example2/features/leak_tracker/presentation/view_models/leak_tracker_view_model.dart';

@RoutePage(name: RouteName.leakTracker)
class LeakTrackerPage extends StatefulWidget {
  const LeakTrackerPage({super.key});

  @override
  State<LeakTrackerPage> createState() => _LeakTrackerPageState();
}

class _LeakTrackerPageState extends State<LeakTrackerPage> {
  late final LeakTrackerViewModel _viewModel = LeakTrackerViewModel(
    repository: LeakTrackerRepositoryImpl(service: LeakTrackerService()),
  );

  @override
  void initState() {
    super.initState();
    _viewModel.runScenario(disposedLeakTrackerScenario);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (BuildContext context, Widget? child) {
        return Scaffold(
          appBar: AppBar(title: const Text('leak_tracker Module')),
          body: SelectionArea(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: <Widget>[
                const _IntroCard(),
                const SizedBox(height: 16),
                _ScenarioCard(viewModel: _viewModel),
                const SizedBox(height: 16),
                _ResultCard(viewModel: _viewModel),
                const SizedBox(height: 16),
                const _ArchitectureCard(),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => context.router.replacePath(AppRoute.home.path),
            icon: const Icon(Icons.home),
            label: const Text('Home'),
          ),
        );
      },
    );
  }
}

class _IntroCard extends StatelessWidget {
  const _IntroCard();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Track disposable objects and catch lifecycle leaks early.',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'leak_tracker is a diagnostic dependency. It belongs at the '
              'tooling/data boundary, where framework or service objects can '
              'dispatch creation and disposal events. Domain code should only '
              'care about the leak report, not the tracker implementation.',
            ),
            const SizedBox(height: 12),
            const _CodeBlock(
              code: '''
LeakTracking.start(
  config: LeakTrackingConfig.passive(),
  resetIfAlreadyStarted: true,
);
LeakTracking.dispatchObjectCreated(
  library: 'feature',
  className: 'TrackedDemoController',
  object: controller,
);
LeakTracking.dispatchObjectDisposed(object: controller);
final leaks = await LeakTracking.collectLeaks();
LeakTracking.stop();
''',
            ),
          ],
        ),
      ),
    );
  }
}

class _ScenarioCard extends StatelessWidget {
  const _ScenarioCard({required this.viewModel});

  final LeakTrackerViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Lifecycle Scenarios',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            const Text(
              'Run both paths to see how a repository can expose a clean leak '
              'summary while the data service owns leak_tracker calls.',
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: <Widget>[
                FilledButton.icon(
                  onPressed: viewModel.isRunning
                      ? null
                      : () =>
                            viewModel.runScenario(disposedLeakTrackerScenario),
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Correct Disposal'),
                ),
                OutlinedButton.icon(
                  onPressed: viewModel.isRunning
                      ? null
                      : () => viewModel.runScenario(leakedLeakTrackerScenario),
                  icon: const Icon(Icons.report_problem_outlined),
                  label: const Text('Missing Disposal'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.viewModel});

  final LeakTrackerViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final LeakTrackerRunResult? result = viewModel.result;
    final String? errorMessage = viewModel.errorMessage;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Collector Output',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            if (viewModel.isRunning)
              const LinearProgressIndicator()
            else if (errorMessage != null)
              Text(errorMessage, style: TextStyle(color: Colors.red.shade700))
            else if (result == null)
              const Text('Run a scenario to collect leak data.')
            else ...<Widget>[
              Text(
                result.summaryLabel,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              _MetricRow(label: 'Scenario', value: result.scenario.name),
              _MetricRow(label: 'Tracked class', value: result.trackedClass),
              _MetricRow(label: 'Created', value: '${result.createdObjects}'),
              _MetricRow(label: 'Disposed', value: '${result.disposedObjects}'),
              _MetricRow(
                label: 'Not disposed',
                value: '${result.notDisposedLeaks}',
              ),
              _MetricRow(label: 'Not GCed', value: '${result.notGcedLeaks}'),
              _MetricRow(label: 'GCed late', value: '${result.gcedLateLeaks}'),
              const SizedBox(height: 12),
              for (final String detail in result.details)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(detail),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ArchitectureCard extends StatelessWidget {
  const _ArchitectureCard();

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _SectionTitle('Clean Architecture Placement'),
            SizedBox(height: 12),
            _LayerRow(
              label: 'Domain',
              detail:
                  'LeakTrackerScenario and LeakTrackerRunResult describe '
                  'lifecycle behavior and leak totals without importing '
                  'leak_tracker.',
            ),
            SizedBox(height: 8),
            _LayerRow(
              label: 'Data',
              detail:
                  'LeakTrackerService wraps LeakTracking.start(), object '
                  'events, and collectLeaks(). The repository returns a stable '
                  'domain result.',
            ),
            SizedBox(height: 8),
            _LayerRow(
              label: 'Presentation',
              detail:
                  'LeakTrackerViewModel runs scenarios and exposes loading, '
                  'error, and result state to the page.',
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: <Widget>[
          SizedBox(width: 120, child: Text(label)),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class _LayerRow extends StatelessWidget {
  const _LayerRow({required this.label, required this.detail});

  final String label;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        Expanded(child: Text(detail)),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
    );
  }
}

class _CodeBlock extends StatelessWidget {
  const _CodeBlock({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(code, style: const TextStyle(fontFamily: 'monospace')),
    );
  }
}
