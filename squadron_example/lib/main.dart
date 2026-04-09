import 'package:flutter/material.dart';
import 'package:squadron/squadron.dart';

import 'src/prime_lab.dart';

void main() {
  runApp(const SquadronExampleApp());
}

class SquadronExampleApp extends StatelessWidget {
  const SquadronExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    final baseTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF0F6B5B),
        brightness: Brightness.light,
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Squadron Prime Lab',
      theme: baseTheme.copyWith(
        scaffoldBackgroundColor: const Color(0xFFF4EFE6),
        textTheme: baseTheme.textTheme.apply(
          bodyColor: const Color(0xFF1B2432),
          displayColor: const Color(0xFF1B2432),
        ),
      ),
      home: const SquadronPrimeLabPage(),
    );
  }
}

class SquadronPrimeLabPage extends StatefulWidget {
  const SquadronPrimeLabPage({super.key});

  @override
  State<SquadronPrimeLabPage> createState() => _SquadronPrimeLabPageState();
}

class _SquadronPrimeLabPageState extends State<SquadronPrimeLabPage> {
  static const _presets = [28000, 36000, 44000, 52000, 60000];
  static const _poolOffsets = [-12000, -6000, 0, 6000, 12000, 18000];

  final TextEditingController _limitController =
      TextEditingController(text: '52000');

  PrimeLabWorker? _worker;
  PrimeLabWorkerPool? _pool;
  DemoMode _mode = DemoMode.idle;
  PrimeScanResult? _singleResult;
  PoolRunSummary? _poolResult;
  String? _errorMessage;

  @override
  void dispose() {
    _worker?.stop();
    _pool?.stop();
    _limitController.dispose();
    super.dispose();
  }

  PrimeLabWorker _ensureWorker() => _worker ??= PrimeLabWorker();

  PrimeLabWorkerPool _ensurePool() => _pool ??= PrimeLabWorkerPool(
        concurrencySettings: ConcurrencySettings.threeCpuThreads,
      );

  int? _readLimit() {
    final value = int.tryParse(_limitController.text.trim());
    if (value == null || value < 1000 || value > 200000) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Choose a limit between 1,000 and 200,000.'),
        ),
      );
      return null;
    }
    return value;
  }

  Future<void> _runSingleWorker() async {
    final limit = _readLimit();
    if (limit == null) {
      return;
    }

    setState(() {
      _mode = DemoMode.single;
      _errorMessage = null;
    });

    final stopwatch = Stopwatch()..start();
    try {
      final payload = await _ensureWorker().scanPrimes(limit);
      stopwatch.stop();

      if (!mounted) {
        return;
      }

      setState(() {
        _singleResult = PrimeScanResult.fromPayload(
          payload,
          wallClock: stopwatch.elapsed,
        );
        _mode = DemoMode.idle;
      });
    } catch (error, stackTrace) {
      stopwatch.stop();
      _handleRunFailure(error, stackTrace);
    }
  }

  Future<void> _runWorkerPool() async {
    final baseLimit = _readLimit();
    if (baseLimit == null) {
      return;
    }

    final limits = [
      for (final offset in _poolOffsets)
        (baseLimit + offset).clamp(1000, 200000).toInt(),
    ];

    setState(() {
      _mode = DemoMode.pool;
      _errorMessage = null;
    });

    final stopwatch = Stopwatch()..start();
    try {
      final payloads =
          await Future.wait(limits.map((limit) => _ensurePool().scanPrimes(limit)));
      stopwatch.stop();

      if (!mounted) {
        return;
      }

      final jobs = [
        for (final payload in payloads) PrimeScanResult.fromPayload(payload),
      ];

      setState(() {
        _poolResult = PoolRunSummary(jobs: jobs, wallClock: stopwatch.elapsed);
        _mode = DemoMode.idle;
      });
    } catch (error, stackTrace) {
      stopwatch.stop();
      _handleRunFailure(error, stackTrace);
    }
  }

  void _handleRunFailure(Object error, StackTrace stackTrace) {
    if (!mounted) {
      return;
    }

    final message = '$error\n$stackTrace';
    setState(() {
      _errorMessage = message;
      _mode = DemoMode.idle;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final showSideBySide = screenWidth >= 980;

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFF6F1E8),
              Color(0xFFE6F0EB),
              Color(0xFFF4EBDD),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1140),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 40),
                children: [
                  _HeroCard(mode: _mode),
                  const SizedBox(height: 24),
                  _buildControlsCard(context),
                  const SizedBox(height: 24),
                  if (showSideBySide)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildSingleResultCard()),
                        const SizedBox(width: 20),
                        Expanded(child: _buildPoolResultCard()),
                      ],
                    )
                  else
                    Column(
                      children: [
                        _buildSingleResultCard(),
                        const SizedBox(height: 20),
                        _buildPoolResultCard(),
                      ],
                    ),
                  if (_errorMessage case final message?) ...[
                    const SizedBox(height: 20),
                    _ErrorCard(message: message),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildControlsCard(BuildContext context) {
    final theme = Theme.of(context);
    final isBusy = _mode != DemoMode.idle;
    final poolLimits = [
      for (final offset in _poolOffsets)
        ((_readOnlyLimit ?? 52000) + offset).clamp(1000, 200000).toInt(),
    ];

    return _SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Benchmark Controls',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Single worker mode sends one CPU-bound prime scan to a persistent background isolate. '
            'Pool mode fans out six scans across up to three workers.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: const Color(0xFF465264),
              height: 1.45,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _limitController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Prime scan upper bound',
                    hintText: '52000',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              _MetricPill(
                label: 'Pool size',
                value: '1-3 workers',
                tone: const Color(0xFFD6EDE5),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final preset in _presets)
                ActionChip(
                  label: Text('Use $preset'),
                  onPressed: isBusy
                      ? null
                      : () {
                          _limitController.text = '$preset';
                          setState(() {});
                        },
                ),
            ],
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              FilledButton.icon(
                onPressed: isBusy ? null : _runSingleWorker,
                icon: _mode == DemoMode.single
                    ? const SizedBox.square(
                        dimension: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.precision_manufacturing_rounded),
                label: const Text('Single worker run'),
              ),
              FilledButton.tonalIcon(
                onPressed: isBusy ? null : _runWorkerPool,
                icon: _mode == DemoMode.pool
                    ? const SizedBox.square(
                        dimension: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.hub_rounded),
                label: const Text('Worker pool batch'),
              ),
              Text(
                _statusLabel(poolLimits),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF596579),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSingleResultCard() {
    return _ResultCard(
      title: 'Single Worker Result',
      accentColor: const Color(0xFF0F6B5B),
      child: _singleResult == null
          ? const _EmptyState(
              title: 'No single-worker run yet',
              detail: 'Run one benchmark to inspect worker thread reuse and compute time.',
            )
          : _PrimeScanView(
              result: _singleResult!,
              showWallClock: true,
            ),
    );
  }

  Widget _buildPoolResultCard() {
    final result = _poolResult;
    return _ResultCard(
      title: 'Worker Pool Result',
      accentColor: const Color(0xFFB35C2E),
      child: result == null
          ? const _EmptyState(
              title: 'No pool batch yet',
              detail: 'Run the pool batch to spread six jobs across the Squadron worker pool.',
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _MetricPill(
                      label: 'Wall clock',
                      value: formatDuration(result.wallClock),
                      tone: const Color(0xFFF4DFC8),
                    ),
                    _MetricPill(
                      label: 'Observed workers',
                      value: '${result.workerCount}',
                      tone: const Color(0xFFE6E0F8),
                    ),
                    _MetricPill(
                      label: 'Prime total',
                      value: '${result.totalPrimes}',
                      tone: const Color(0xFFD6EDE5),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                for (final job in result.jobs) ...[
                  _PrimeScanRow(result: job),
                  const SizedBox(height: 10),
                ],
              ],
            ),
    );
  }

  String _statusLabel(List<int> poolLimits) {
    switch (_mode) {
      case DemoMode.idle:
        return 'Pool batch queue: ${poolLimits.join(', ')}';
      case DemoMode.single:
        return 'Running one request on a persistent worker isolate...';
      case DemoMode.pool:
        return 'Dispatching ${poolLimits.length} jobs through the worker pool...';
    }
  }

  int? get _readOnlyLimit => int.tryParse(_limitController.text.trim());
}

enum DemoMode { idle, single, pool }

class PrimeScanResult {
  PrimeScanResult({
    required this.requestedLimit,
    required this.limit,
    required this.primeCount,
    required this.largestPrime,
    required this.checksum,
    required this.workerElapsedMs,
    required this.threadId,
    this.wallClock,
  });

  factory PrimeScanResult.fromPayload(
    Map<String, Object> payload, {
    Duration? wallClock,
  }) {
    return PrimeScanResult(
      requestedLimit: payload['requestedLimit'] as int,
      limit: payload['limit'] as int,
      primeCount: payload['primeCount'] as int,
      largestPrime: payload['largestPrime'] as int,
      checksum: payload['checksum'] as int,
      workerElapsedMs: (payload['elapsedMs'] as num).toDouble(),
      threadId: payload['threadId'] as String,
      wallClock: wallClock,
    );
  }

  final int requestedLimit;
  final int limit;
  final int primeCount;
  final int largestPrime;
  final int checksum;
  final double workerElapsedMs;
  final String threadId;
  final Duration? wallClock;
}

class PoolRunSummary {
  PoolRunSummary({required this.jobs, required this.wallClock});

  final List<PrimeScanResult> jobs;
  final Duration wallClock;

  int get workerCount => jobs.map((job) => job.threadId).toSet().length;

  int get totalPrimes =>
      jobs.fold(0, (runningTotal, job) => runningTotal + job.primeCount);
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.mode});

  final DemoMode mode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF17212B),
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 28,
            offset: Offset(0, 20),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -10,
            right: -24,
            child: Container(
              width: 180,
              height: 180,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x1FFFFFFF),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -10,
            child: Container(
              width: 220,
              height: 220,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x220F6B5B),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: const [
                    _HeroBadge(label: 'Persistent workers'),
                    _HeroBadge(label: 'Worker pools'),
                    _HeroBadge(label: 'CPU-bound isolates'),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'Squadron Prime Lab',
                  style: theme.textTheme.displaySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1.5,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'A Flutter example wired to Squadron code generation. '
                  'You can compare one long-lived worker against a worker pool '
                  'without touching `dart:isolate` directly.',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: const Color(0xFFD8E1E9),
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _MetricPill(
                      label: 'Mode',
                      value: switch (mode) {
                        DemoMode.idle => 'Ready',
                        DemoMode.single => 'Single worker',
                        DemoMode.pool => 'Pool batch',
                      },
                      tone: const Color(0xFF245C52),
                      foreground: Colors.white,
                    ),
                    const _MetricPill(
                      label: 'Library',
                      value: 'squadron ^7.4.3',
                      tone: Color(0xFFF4DFC8),
                    ),
                    const _MetricPill(
                      label: 'Pool preset',
                      value: 'threeCpuThreads',
                      tone: Color(0xFFDCE6FF),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SurfaceCard extends StatelessWidget {
  const _SurfaceCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFFDFBF8),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2D9CC)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 20,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({
    required this.title,
    required this.accentColor,
    required this.child,
  });

  final String title;
  final Color accentColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: accentColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }
}

class _PrimeScanView extends StatelessWidget {
  const _PrimeScanView({
    required this.result,
    required this.showWallClock,
  });

  final PrimeScanResult result;
  final bool showWallClock;

  @override
  Widget build(BuildContext context) {
    final wallClock = result.wallClock;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _MetricPill(
              label: 'Prime count',
              value: '${result.primeCount}',
              tone: const Color(0xFFD6EDE5),
            ),
            _MetricPill(
              label: 'Largest prime',
              value: '${result.largestPrime}',
              tone: const Color(0xFFEDE1CF),
            ),
            _MetricPill(
              label: 'Worker compute',
              value: '${result.workerElapsedMs.toStringAsFixed(1)} ms',
              tone: const Color(0xFFE6E0F8),
            ),
            if (showWallClock && wallClock != null)
              _MetricPill(
                label: 'Wall clock',
                value: formatDuration(wallClock),
                tone: const Color(0xFFDCE6FF),
              ),
          ],
        ),
        const SizedBox(height: 18),
        _PrimeScanRow(result: result),
      ],
    );
  }
}

class _PrimeScanRow extends StatelessWidget {
  const _PrimeScanRow({required this.result});

  final PrimeScanResult result;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F1EA),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'limit ${result.requestedLimit} -> ${result.limit}',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'worker ${result.threadId} found ${result.primeCount} primes, '
            'largest ${result.largestPrime}, checksum ${result.checksum}.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: const Color(0xFF4D5A6C),
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricPill extends StatelessWidget {
  const _MetricPill({
    required this.label,
    required this.value,
    required this.tone,
    this.foreground = const Color(0xFF1B2432),
  });

  final String label;
  final String value;
  final Color tone;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: tone,
        borderRadius: BorderRadius.circular(18),
      ),
      child: RichText(
        text: TextSpan(
          style: TextStyle(color: foreground),
          children: [
            TextSpan(
              text: '$label\n',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroBadge extends StatelessWidget {
  const _HeroBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0x23FFFFFF),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.title, required this.detail});

  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F2EB),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            detail,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: const Color(0xFF596579),
              height: 1.45,
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
    return _SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Last run failed',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: const Color(0xFF8A2D1C),
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 12),
          SelectableText(
            message,
            style: const TextStyle(
              color: Color(0xFF8A2D1C),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

String formatDuration(Duration duration) {
  final milliseconds = duration.inMicroseconds / 1000;
  if (milliseconds >= 1000) {
    return '${(milliseconds / 1000).toStringAsFixed(2)} s';
  }
  return '${milliseconds.toStringAsFixed(1)} ms';
}
