import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../models/demo_stores.dart';
import 'provider_catalog.dart';

class ProviderDetailPage extends StatelessWidget {
  const ProviderDetailPage({required this.demo, super.key});

  final ProviderDemoSpec demo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(demo.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              demo.subtitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(demo.description),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: demo.color.withAlpha(24),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: demo.color.withAlpha(110)),
                ),
                child: _DemoBody(demo: demo),
              ),
            ),
          ],
        ),
      ),
      persistentFooterButtons: <Widget>[
        TextButton.icon(
          onPressed: () => context.go('/'),
          icon: const Icon(Icons.home),
          label: const Text('Back Home'),
        ),
        FilledButton.tonalIcon(
          onPressed: () => _resetDemo(context, demo.slug),
          icon: const Icon(Icons.refresh),
          label: const Text('Reset Demo'),
        ),
      ],
    );
  }

  void _resetDemo(BuildContext context, String slug) {
    switch (slug) {
      case 'counter-dashboard':
        context.read<CounterStore>().reset();
      case 'team-scoreboard':
        context.read<TeamScoreStore>().reset();
      case 'study-plan':
        context.read<StudyPlanStore>().reset();
    }
  }
}

class _DemoBody extends StatelessWidget {
  const _DemoBody({required this.demo});

  final ProviderDemoSpec demo;

  @override
  Widget build(BuildContext context) {
    switch (demo.slug) {
      case 'counter-dashboard':
        return const _CounterDemo();
      case 'team-scoreboard':
        return const _ScoreboardDemo();
      case 'study-plan':
        return const _StudyPlanDemo();
    }

    return const SizedBox.shrink();
  }
}

class _CounterDemo extends StatelessWidget {
  const _CounterDemo();

  @override
  Widget build(BuildContext context) {
    final int count = context.watch<CounterStore>().count;
    final ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Counter value',
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Row(
          children: <Widget>[
            Expanded(
              child: _MetricCard(
                label: 'Current',
                value: '$count',
                icon: Icons.pin_outlined,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _MetricCard(
                label: 'Remaining',
                value:
                    '${context.select<CounterStore, int>((store) => store.remainingToGoal)}',
                icon: Icons.flag_outlined,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const _CounterGoalBanner(),
        const Spacer(),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: <Widget>[
            FilledButton.icon(
              onPressed: () => context.read<CounterStore>().increment(),
              icon: const Icon(Icons.add),
              label: const Text('Increment'),
            ),
            FilledButton.tonalIcon(
              onPressed: () => context.read<CounterStore>().decrement(),
              icon: const Icon(Icons.remove),
              label: const Text('Decrement'),
            ),
            OutlinedButton.icon(
              onPressed: () => context.read<CounterStore>().reset(),
              icon: const Icon(Icons.refresh),
              label: const Text('Reset'),
            ),
          ],
        ),
      ],
    );
  }
}

class _CounterGoalBanner extends StatelessWidget {
  const _CounterGoalBanner();

  @override
  Widget build(BuildContext context) {
    final bool reachedGoal =
        context.select<CounterStore, bool>((store) => store.isGoalReached);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: reachedGoal ? Colors.green.shade100 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: reachedGoal ? Colors.green : Colors.black12,
        ),
      ),
      child: Row(
        children: <Widget>[
          Icon(
            reachedGoal ? Icons.emoji_events : Icons.track_changes,
            color: reachedGoal ? Colors.green.shade700 : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              reachedGoal
                  ? 'Goal reached. Every widget here stayed stateless.'
                  : 'Tap increment until the notifier reaches its goal of 10.',
            ),
          ),
        ],
      ),
    );
  }
}

class _ScoreboardDemo extends StatelessWidget {
  const _ScoreboardDemo();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const _LeaderBanner(),
        const SizedBox(height: 16),
        Row(
          children: const <Widget>[
            Expanded(
              child: _ScorePanel(
                label: 'Home',
                scoreSelector: _ScoreSelector.home,
                color: Colors.deepOrange,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _ScorePanel(
                label: 'Away',
                scoreSelector: _ScoreSelector.away,
                color: Colors.blue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Selector<TeamScoreStore, int>(
          selector: (_, TeamScoreStore store) => store.totalPoints,
          builder: (BuildContext context, int totalPoints, _) {
            return _MetricCard(
              label: 'Total points',
              value: '$totalPoints',
              icon: Icons.functions,
            );
          },
        ),
        const Spacer(),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: <Widget>[
            FilledButton(
              onPressed: () => context.read<TeamScoreStore>().scoreHome(1),
              child: const Text('Home +1'),
            ),
            FilledButton(
              onPressed: () => context.read<TeamScoreStore>().scoreHome(3),
              child: const Text('Home +3'),
            ),
            FilledButton.tonal(
              onPressed: () => context.read<TeamScoreStore>().scoreAway(1),
              child: const Text('Away +1'),
            ),
            FilledButton.tonal(
              onPressed: () => context.read<TeamScoreStore>().scoreAway(3),
              child: const Text('Away +3'),
            ),
          ],
        ),
      ],
    );
  }
}

enum _ScoreSelector {
  home,
  away,
}

class _ScorePanel extends StatelessWidget {
  const _ScorePanel({
    required this.label,
    required this.scoreSelector,
    required this.color,
  });

  final String label;
  final _ScoreSelector scoreSelector;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final int score = context.select<TeamScoreStore, int>((store) {
      return scoreSelector == _ScoreSelector.home
          ? store.homeScore
          : store.awayScore;
    });

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withAlpha(160), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '$score',
            style: Theme.of(context).textTheme.displaySmall,
          ),
        ],
      ),
    );
  }
}

class _LeaderBanner extends StatelessWidget {
  const _LeaderBanner();

  @override
  Widget build(BuildContext context) {
    final String leader =
        context.select<TeamScoreStore, String>((store) => store.leader);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: <Widget>[
          const Icon(Icons.insights),
          const SizedBox(width: 12),
          Expanded(child: Text(leader)),
        ],
      ),
    );
  }
}

class _StudyPlanDemo extends StatelessWidget {
  const _StudyPlanDemo();

  @override
  Widget build(BuildContext context) {
    return Consumer<StudyPlanStore>(
      builder: (BuildContext context, StudyPlanStore store, _) {
        return ListView(
          children: <Widget>[
            _MetricCard(
              label: 'Progress',
              value: store.progressLabel,
              icon: Icons.school_outlined,
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: store.progress,
              minHeight: 12,
              borderRadius: BorderRadius.circular(999),
            ),
            const SizedBox(height: 20),
            SwitchListTile(
              value: store.focusMode,
              contentPadding: EdgeInsets.zero,
              title: const Text('Focus mode'),
              subtitle: const Text(
                'A stateless control can still toggle provider-owned state.',
              ),
              onChanged: (_) =>
                  context.read<StudyPlanStore>().toggleFocusMode(),
            ),
            const SizedBox(height: 12),
            Row(
              children: <Widget>[
                Expanded(
                  child: _ModeCard(
                    label: 'Mode',
                    value: store.focusMode ? 'Focus' : 'Relaxed',
                    icon: store.focusMode ? Icons.bolt : Icons.spa_outlined,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ModeCard(
                    label: 'Lessons left',
                    value: '${store.totalLessons - store.completedLessons}',
                    icon: Icons.schedule,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: <Widget>[
                FilledButton.icon(
                  onPressed: () =>
                      context.read<StudyPlanStore>().completeLesson(),
                  icon: const Icon(Icons.check),
                  label: const Text('Complete Lesson'),
                ),
                FilledButton.tonalIcon(
                  onPressed: () =>
                      context.read<StudyPlanStore>().rewindLesson(),
                  icon: const Icon(Icons.undo),
                  label: const Text('Rewind'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon),
          const SizedBox(height: 12),
          Text(label),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: <Widget>[
          Icon(icon),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(label),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
