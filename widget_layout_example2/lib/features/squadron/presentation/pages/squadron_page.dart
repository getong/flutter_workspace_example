import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';
import 'package:widget_layout_example2/features/squadron/data/repositories/squadron_repository_impl.dart';
import 'package:widget_layout_example2/features/squadron/domain/entities/squadron_models.dart';
import 'package:widget_layout_example2/features/squadron/presentation/view_models/squadron_view_model.dart';

@RoutePage(name: RouteName.squadron)
class SquadronPage extends StatefulWidget {
  const SquadronPage({super.key});

  @override
  State<SquadronPage> createState() => _SquadronPageState();
}

class _SquadronPageState extends State<SquadronPage> {
  late final SquadronViewModel _viewModel = SquadronViewModel(
    repository: SquadronRepositoryImpl(),
  );

  @override
  void initState() {
    super.initState();
    _viewModel.runBatch();
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
          appBar: AppBar(title: const Text('squadron Module')),
          body: SelectionArea(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: <Widget>[
                const _IntroCard(),
                const SizedBox(height: 16),
                _RunCard(viewModel: _viewModel),
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
              'Move CPU-heavy Dart work into managed workers.',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'squadron is a worker orchestration library. It helps structure '
              'isolate or web-worker calls behind service methods, then scales '
              'those calls through a worker pool. In clean architecture, keep '
              'the worker plumbing in data services and expose ordinary domain '
              'results upward.',
            ),
            const SizedBox(height: 12),
            const _CodeBlock(
              code: '''
class CpuWorker extends Worker {
  Future<Result> runDigest(WorkItem item) {
    return send(commandId, args: [item.label, item.seed])
      .then(Result.fromWorkerMessage);
  }
}

final pool = CpuWorkerPool(entrypoint);
await pool.start();
final results = await Future.wait(items.map(pool.runDigest));
pool.stop();
''',
            ),
          ],
        ),
      ),
    );
  }
}

class _RunCard extends StatelessWidget {
  const _RunCard({required this.viewModel});

  final SquadronViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Worker Pool Batch',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            const Text(
              'This batch schedules six deterministic CPU tasks. Each task is '
              'sent through SquadronCpuWorkerPool, and the repository maps the '
              'worker messages into domain results.',
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: viewModel.isRunning ? null : viewModel.runBatch,
              icon: viewModel.isRunning
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.memory),
              label: const Text('Run Worker Batch'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.viewModel});

  final SquadronViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final SquadronRunReport? report = viewModel.report;
    final String? errorMessage = viewModel.errorMessage;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Repository Output',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            if (viewModel.isRunning)
              const LinearProgressIndicator()
            else if (errorMessage != null)
              Text(errorMessage, style: TextStyle(color: Colors.red.shade700))
            else if (report == null)
              const Text('Run the batch to see worker output.')
            else ...<Widget>[
              _MetricRow(label: 'Main thread', value: report.mainThreadId),
              _MetricRow(label: 'Worker count', value: '${report.workerCount}'),
              _MetricRow(
                label: 'Total workload',
                value: '${report.totalWorkload}',
              ),
              _MetricRow(label: 'Total errors', value: '${report.totalErrors}'),
              _MetricRow(label: 'Elapsed', value: report.elapsedLabel),
              _MetricRow(
                label: 'Worker threads',
                value: report.workerThreadsLabel,
              ),
              const SizedBox(height: 16),
              for (final SquadronWorkResult result in report.results)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    '${result.label}: digest=${result.digest}, '
                    'thread=${result.threadId}',
                  ),
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
                  'SquadronWorkItem, SquadronWorkResult, and '
                  'SquadronRunReport describe work and outcomes without '
                  'depending on worker APIs.',
            ),
            SizedBox(height: 8),
            _LayerRow(
              label: 'Data',
              detail:
                  'SquadronCpuWorkerService, SquadronCpuWorker, and '
                  'SquadronCpuWorkerPool isolate squadron-specific commands, '
                  'entrypoints, and concurrency settings.',
            ),
            SizedBox(height: 8),
            _LayerRow(
              label: 'Presentation',
              detail:
                  'SquadronViewModel starts the batch and exposes a report; '
                  'the page stays unaware of WorkerRequest and WorkerPool.',
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
        crossAxisAlignment: CrossAxisAlignment.start,
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
