import 'dart:async';
import 'dart:math' as math;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_debounce_throttle/flutter_debounce_throttle.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';

const List<String> _demoCatalog = <String>[
  'Async debounce controller',
  'Async throttle submit',
  'Debounced search query',
  'Debounced text controller',
  'EventLimiterMixin cleanup',
  'Gesture throttling',
  'Queue pending jobs',
  'Rate-limited button',
  'Replace stale requests',
  'Save draft debounce',
  'Slider debounce preview',
  'Stream debounce listener',
  'Stream throttle listener',
  'Throttled gesture detector',
  'Throttled ink ripple',
];

@RoutePage(name: RouteName.flutterDebounceThrottle)
class FlutterDebounceThrottlePage extends StatefulWidget {
  const FlutterDebounceThrottlePage({super.key});

  @override
  State<FlutterDebounceThrottlePage> createState() =>
      _FlutterDebounceThrottlePageState();
}

class _FlutterDebounceThrottlePageState
    extends State<FlutterDebounceThrottlePage> {
  late final DebouncedTextController _debouncedTextController;
  late final AsyncDebouncedTextController<List<String>>
  _asyncDebouncedTextController;
  late final StreamController<double> _debounceSliderStreamController;
  late final StreamController<double> _throttleSliderStreamController;
  late final _LimiterPlaygroundController _limiterController;

  List<String> _debouncedControllerMatches = const <String>[];
  List<String> _asyncControllerMatches = const <String>[];
  List<String> _queryMatches = const <String>[];
  List<String> _completedJobs = const <String>[];
  List<String> _eventLog = const <String>[
    'Interact with the demos to see debounce and throttle behavior.',
  ];

  String _debouncedControllerQuery = 'tap';
  String _asyncControllerMessage =
      'Type to trigger AsyncDebouncedTextController.';
  String _queryMessage =
      'DebouncedQueryBuilder waits for a pause before starting the async query.';

  double _liveSliderValue = 28;
  double _debouncedSliderValue = 28;
  double _streamInputValue = 18;
  double _streamDebouncedValue = 18;
  double _streamThrottledValue = 18;

  int _throttledInkWellCount = 0;
  int _throttledBuilderCount = 0;
  int _gestureTapCount = 0;
  int _asyncSubmitCount = 0;
  int _queuedJobSeed = 0;
  bool _asyncControllerLoading = false;

  Offset _dragIndicator = const Offset(0.22, 0.48);

  @override
  void initState() {
    super.initState();
    _debouncedTextController = DebouncedTextController(
      initialValue: _debouncedControllerQuery,
      duration: const Duration(milliseconds: 420),
      onChanged: _handleDebouncedControllerSearch,
    );
    _asyncDebouncedTextController = AsyncDebouncedTextController<List<String>>(
      duration: const Duration(milliseconds: 360),
      onChanged: _runCatalogSearch,
      onSuccess: (List<String> results) {
        if (!mounted) return;
        setState(() {
          _asyncControllerMatches = results;
          _asyncControllerMessage = results.isEmpty
              ? 'No matches. Try "stream", "throttle", or "gesture".'
              : 'AsyncDebouncedTextController returned ${results.length} match(es).';
        });
        _pushLog(
          'AsyncDebouncedTextController finished with ${results.length} result(s).',
        );
      },
      onError: (Object error, StackTrace stackTrace) {
        if (!mounted) return;
        setState(() {
          _asyncControllerMessage = error.toString();
          _asyncControllerMatches = const <String>[];
        });
        _pushLog('AsyncDebouncedTextController error: $error');
      },
      onLoadingChanged: (bool isLoading) {
        if (!mounted) return;
        setState(() {
          _asyncControllerLoading = isLoading;
        });
      },
    );
    _debounceSliderStreamController = StreamController<double>.broadcast();
    _throttleSliderStreamController = StreamController<double>.broadcast();
    _limiterController = _LimiterPlaygroundController();
    _debouncedControllerMatches = _filterCatalog(_debouncedControllerQuery);
  }

  @override
  void dispose() {
    _debouncedTextController.dispose();
    _asyncDebouncedTextController.dispose();
    _debounceSliderStreamController.close();
    _throttleSliderStreamController.close();
    _limiterController.dispose();
    super.dispose();
  }

  Future<List<String>> _runCatalogSearch(String query) async {
    final String normalized = query.trim().toLowerCase();
    await Future<void>.delayed(const Duration(milliseconds: 650));

    if (normalized == 'error') {
      throw StateError(
        'Type another query to recover from the simulated error.',
      );
    }

    return _filterCatalog(query);
  }

  List<String> _filterCatalog(String query) {
    final List<String> terms = query
        .trim()
        .toLowerCase()
        .split(RegExp(r'\s+'))
        .where((String item) => item.isNotEmpty)
        .toList();

    if (terms.isEmpty) {
      return _demoCatalog.take(6).toList();
    }

    return _demoCatalog
        .where(
          (String entry) =>
              terms.every((String term) => entry.toLowerCase().contains(term)),
        )
        .take(6)
        .toList();
  }

  void _handleDebouncedControllerSearch(String query) {
    final List<String> matches = _filterCatalog(query);
    if (!mounted) return;
    setState(() {
      _debouncedControllerQuery = query;
      _debouncedControllerMatches = matches;
    });
    _pushLog(
      'DebouncedTextController committed '
      '"${query.trim().isEmpty ? '(empty)' : query.trim()}".',
    );
  }

  void _pushLog(String message) {
    final DateTime now = DateTime.now();
    final String stamp =
        '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}:'
        '${now.second.toString().padLeft(2, '0')}';
    setState(() {
      _eventLog = <String>['$stamp  $message', ..._eventLog].take(10).toList();
    });
  }

  Future<void> _runAsyncSubmitDemo() async {
    final int attempt = _asyncSubmitCount + 1;
    _pushLog('AsyncThrottledBuilder accepted submit #$attempt.');
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() {
      _asyncSubmitCount = attempt;
    });
    _pushLog('AsyncThrottledBuilder finished submit #$attempt.');
  }

  Future<void> _queueConcurrentJob() async {
    final int jobId = ++_queuedJobSeed;
    _pushLog('ConcurrentAsyncThrottledBuilder queued job #$jobId.');
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() {
      _completedJobs = <String>[
        'Job #$jobId finished',
        ..._completedJobs,
      ].take(6).toList();
    });
    _pushLog('ConcurrentAsyncThrottledBuilder finished job #$jobId.');
  }

  void _updateStreamValues(double value) {
    setState(() {
      _streamInputValue = value;
    });
    _debounceSliderStreamController.add(value);
    _throttleSliderStreamController.add(value);
  }

  void _updateDragIndicator(
    DragUpdateDetails details,
    BoxConstraints constraints,
  ) {
    final double width = math.max(constraints.maxWidth, 1);
    final double height = math.max(constraints.maxHeight, 1);
    setState(() {
      _dragIndicator = Offset(
        (_dragIndicator.dx + details.delta.dx / width).clamp(0.0, 1.0),
        (_dragIndicator.dy + details.delta.dy / height).clamp(0.0, 1.0),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('flutter_debounce_throttle Module')),
      body: SelectionArea(
        child: StreamDebounceListener<double>(
          stream: _debounceSliderStreamController.stream,
          duration: const Duration(milliseconds: 450),
          onData: (double value) {
            setState(() {
              _streamDebouncedValue = value;
            });
            _pushLog(
              'StreamDebounceListener emitted ${value.toStringAsFixed(0)}.',
            );
          },
          child: StreamThrottleListener<double>(
            stream: _throttleSliderStreamController.stream,
            duration: const Duration(milliseconds: 120),
            onData: (double value) {
              setState(() {
                _streamThrottledValue = value;
              });
            },
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: <Widget>[
                _SectionCard(
                  title: 'Why this package matters',
                  description:
                      'It combines debounce, throttle, async locking, stream listeners, gesture throttling, and controller helpers in one API. This page shows live usage for the main Flutter-facing widgets and helpers.',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: _demoCatalog
                            .map((String item) => Chip(label: Text(item)))
                            .toList(),
                      ),
                      const SizedBox(height: 16),
                      SelectableText(
                        '''
import 'package:flutter_debounce_throttle/flutter_debounce_throttle.dart';

ThrottledInkWell(
  duration: const Duration(milliseconds: 600),
  onTap: submitPayment,
  child: const Text('Pay once'),
);
''',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontFamily: 'monospace',
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _SectionCard(
                  title: 'ThrottledInkWell + ThrottledBuilder',
                  description:
                      'Tap both controls as fast as you want. Only accepted callbacks make it through the throttle window.',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: <Widget>[
                          _MetricBadge(
                            label: 'Ink taps accepted',
                            value: '$_throttledInkWellCount',
                            color: const Color(0xFF2563EB),
                          ),
                          _MetricBadge(
                            label: 'Builder taps accepted',
                            value: '$_throttledBuilderCount',
                            color: const Color(0xFF0F766E),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: <Widget>[
                          Material(
                            color: Colors.transparent,
                            child: ThrottledInkWell(
                              duration: const Duration(milliseconds: 700),
                              borderRadius: BorderRadius.circular(18),
                              onTap: () {
                                setState(() {
                                  _throttledInkWellCount += 1;
                                });
                                _pushLog(
                                  'ThrottledInkWell accepted tap '
                                  '#$_throttledInkWellCount.',
                                );
                              },
                              child: Ink(
                                width: 220,
                                padding: const EdgeInsets.all(18),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFDBEAFE),
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                    color: const Color(0xFF2563EB),
                                  ),
                                ),
                                child: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(Icons.touch_app_outlined),
                                    SizedBox(height: 10),
                                    Text(
                                      'ThrottledInkWell',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Tap repeatedly. Only one tap per 700ms is accepted.',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 260,
                            child: ThrottledBuilder(
                              duration: const Duration(milliseconds: 550),
                              builder:
                                  (
                                    BuildContext context,
                                    VoidCallback? Function(VoidCallback? action)
                                    throttle,
                                  ) {
                                    return Wrap(
                                      spacing: 12,
                                      runSpacing: 12,
                                      children: <Widget>[
                                        FilledButton.icon(
                                          onPressed: throttle(() {
                                            setState(() {
                                              _throttledBuilderCount += 1;
                                            });
                                            _pushLog(
                                              'ThrottledBuilder primary action '
                                              '#$_throttledBuilderCount.',
                                            );
                                          }),
                                          icon: const Icon(
                                            Icons.flash_on_outlined,
                                          ),
                                          label: const Text('Primary Action'),
                                        ),
                                        OutlinedButton.icon(
                                          onPressed: throttle(() {
                                            _pushLog(
                                              'ThrottledBuilder secondary action '
                                              'shared the same limiter.',
                                            );
                                          }),
                                          icon: const Icon(
                                            Icons.sync_alt_outlined,
                                          ),
                                          label: const Text('Shared Cooldown'),
                                        ),
                                      ],
                                    );
                                  },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _SectionCard(
                  title: 'DebouncedBuilder + DebouncedTextController',
                  description:
                      'The slider preview updates instantly, but the committed value waits for a pause. The text controller waits before filtering the package catalog.',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      DebouncedBuilder(
                        duration: const Duration(milliseconds: 420),
                        builder:
                            (
                              BuildContext context,
                              VoidCallback? Function(VoidCallback? action)
                              debounce,
                            ) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Slider draft: '
                                    '${_liveSliderValue.toStringAsFixed(0)} px',
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    'Committed after pause: '
                                    '${_debouncedSliderValue.toStringAsFixed(0)} px',
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                  Slider(
                                    min: 8,
                                    max: 64,
                                    value: _liveSliderValue,
                                    onChanged: (double value) {
                                      setState(() {
                                        _liveSliderValue = value;
                                      });
                                      debounce(() {
                                        setState(() {
                                          _debouncedSliderValue = value;
                                        });
                                        _pushLog(
                                          'DebouncedBuilder committed spacing '
                                          '${value.toStringAsFixed(0)}.',
                                        );
                                      });
                                    },
                                  ),
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 180),
                                    width: double.infinity,
                                    padding: EdgeInsets.all(
                                      _debouncedSliderValue,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF5F3FF),
                                      borderRadius: BorderRadius.circular(18),
                                      border: Border.all(
                                        color: const Color(0xFF7C3AED),
                                      ),
                                    ),
                                    child: Container(
                                      height: 52,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF7C3AED),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _debouncedTextController.textController,
                        decoration: const InputDecoration(
                          labelText: 'DebouncedTextController search',
                          hintText: 'Search "tap", "stream", or "queue"',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Committed query: '
                        '${_debouncedControllerQuery.isEmpty ? '(empty)' : _debouncedControllerQuery}',
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 12),
                      _ResultWrap(results: _debouncedControllerMatches),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _SectionCard(
                  title: 'DebouncedQueryBuilder + AsyncDebouncedTextController',
                  description:
                      'Both demos perform async catalog search. Type "error" to trigger the simulated error path and see the error callback update the UI.',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      DebouncedQueryBuilder<List<String>>(
                        duration: const Duration(milliseconds: 380),
                        onQuery: _runCatalogSearch,
                        onResult: (List<String> results) {
                          setState(() {
                            _queryMatches = results;
                            _queryMessage = results.isEmpty
                                ? 'No matches from DebouncedQueryBuilder.'
                                : 'DebouncedQueryBuilder returned '
                                      '${results.length} result(s).';
                          });
                          _pushLog(
                            'DebouncedQueryBuilder returned '
                            '${results.length} result(s).',
                          );
                        },
                        onError: (Object error, StackTrace stackTrace) {
                          setState(() {
                            _queryMatches = const <String>[];
                            _queryMessage = error.toString();
                          });
                          _pushLog('DebouncedQueryBuilder error: $error');
                        },
                        builder:
                            (
                              BuildContext context,
                              void Function(String)? search,
                              bool isLoading,
                            ) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  TextField(
                                    onChanged: search,
                                    decoration: InputDecoration(
                                      labelText: 'DebouncedQueryBuilder query',
                                      hintText:
                                          'Type to query the local catalog',
                                      border: const OutlineInputBorder(),
                                      prefixIcon: const Icon(
                                        Icons.manage_search,
                                      ),
                                      suffixIcon: isLoading
                                          ? const Padding(
                                              padding: EdgeInsets.all(12),
                                              child: SizedBox(
                                                width: 20,
                                                height: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                      strokeWidth: 2.2,
                                                    ),
                                              ),
                                            )
                                          : const Icon(Icons.timer_outlined),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(_queryMessage),
                                  const SizedBox(height: 12),
                                  _ResultWrap(results: _queryMatches),
                                ],
                              );
                            },
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller:
                            _asyncDebouncedTextController.textController,
                        decoration: InputDecoration(
                          labelText: 'AsyncDebouncedTextController query',
                          hintText:
                              'This controller owns its own async debounce',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.text_fields_outlined),
                          suffixIcon: _asyncControllerLoading
                              ? const Padding(
                                  padding: EdgeInsets.all(12),
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.2,
                                    ),
                                  ),
                                )
                              : IconButton(
                                  onPressed: () {
                                    _asyncDebouncedTextController.clear();
                                    setState(() {
                                      _asyncControllerMatches =
                                          const <String>[];
                                      _asyncControllerMessage =
                                          'Controller cleared.';
                                    });
                                  },
                                  icon: const Icon(Icons.clear_outlined),
                                ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(_asyncControllerMessage),
                      const SizedBox(height: 12),
                      _ResultWrap(results: _asyncControllerMatches),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _SectionCard(
                  title:
                      'AsyncThrottledBuilder + ConcurrentAsyncThrottledBuilder',
                  description:
                      'The first button locks while the async task is in flight. The second demo uses `ConcurrencyMode.enqueue` so repeated taps become a queue instead of dropped work.',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: <Widget>[
                          _MetricBadge(
                            label: 'Accepted submits',
                            value: '$_asyncSubmitCount',
                            color: const Color(0xFF0F766E),
                          ),
                          _MetricBadge(
                            label: 'Finished queued jobs',
                            value: '${_completedJobs.length}',
                            color: const Color(0xFFB45309),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      AsyncThrottledBuilder(
                        maxDuration: const Duration(seconds: 4),
                        builder:
                            (
                              BuildContext context,
                              VoidCallback? Function(
                                Future<void> Function()? action,
                              )
                              throttle,
                            ) {
                              return FilledButton.icon(
                                onPressed: throttle(_runAsyncSubmitDemo),
                                icon: const Icon(Icons.cloud_upload_outlined),
                                label: const Text('Submit Once'),
                              );
                            },
                      ),
                      const SizedBox(height: 16),
                      ConcurrentAsyncThrottledBuilder(
                        mode: ConcurrencyMode.enqueue,
                        maxDuration: const Duration(seconds: 4),
                        onPressed: _queueConcurrentJob,
                        builder:
                            (
                              BuildContext context,
                              VoidCallback? callback,
                              bool isLoading,
                              int pendingCount,
                            ) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  FilledButton.tonalIcon(
                                    onPressed: callback,
                                    icon: const Icon(Icons.queue_outlined),
                                    label: Text(
                                      isLoading
                                          ? 'Queue Job ($pendingCount pending)'
                                          : 'Add Queued Job',
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: _completedJobs.isEmpty
                                        ? const <Widget>[
                                            Chip(
                                              label: Text(
                                                'No completed jobs yet',
                                              ),
                                            ),
                                          ]
                                        : _completedJobs
                                              .map(
                                                (String item) =>
                                                    Chip(label: Text(item)),
                                              )
                                              .toList(),
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
                  title: 'StreamDebounceListener + StreamThrottleListener',
                  description:
                      'Drag the slider quickly. The throttled stream tracks intermediate changes while the debounced stream only commits after you pause.',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Input: ${_streamInputValue.toStringAsFixed(0)}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Slider(
                        min: 0,
                        max: 100,
                        value: _streamInputValue,
                        onChanged: _updateStreamValues,
                      ),
                      const SizedBox(height: 8),
                      _ProgressRow(
                        label: 'Throttled stream',
                        value: _streamThrottledValue / 100,
                        color: const Color(0xFF2563EB),
                        caption:
                            '${_streamThrottledValue.toStringAsFixed(0)} '
                            'updates frequently',
                      ),
                      const SizedBox(height: 12),
                      _ProgressRow(
                        label: 'Debounced stream',
                        value: _streamDebouncedValue / 100,
                        color: const Color(0xFF7C3AED),
                        caption:
                            '${_streamDebouncedValue.toStringAsFixed(0)} '
                            'waits for a pause',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _SectionCard(
                  title: 'ThrottledGestureDetector',
                  description:
                      'Tap or drag inside the board. Tap counts are throttled and drag updates are sampled with `ThrottleDuration.standard` so movement stays smooth without firing every raw event.',
                  child: LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                      return ThrottledGestureDetector(
                        discreteDuration: const Duration(milliseconds: 600),
                        continuousDuration: ThrottleDuration.standard,
                        onTap: () {
                          setState(() {
                            _gestureTapCount += 1;
                          });
                          _pushLog(
                            'ThrottledGestureDetector accepted tap '
                            '#$_gestureTapCount.',
                          );
                        },
                        onPanUpdate: (DragUpdateDetails details) {
                          _updateDragIndicator(details, constraints);
                        },
                        child: Container(
                          height: 220,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFF94A3B8)),
                          ),
                          child: Stack(
                            children: <Widget>[
                              Positioned.fill(
                                child: CustomPaint(painter: _GridPainter()),
                              ),
                              Positioned(
                                left:
                                    _dragIndicator.dx *
                                    math.max(constraints.maxWidth - 32, 0),
                                top: _dragIndicator.dy * (220 - 32),
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFEA580C),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 16,
                                right: 16,
                                bottom: 16,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.92),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Text(
                                      'Accepted taps: $_gestureTapCount'
                                      '  |  Position: '
                                      '(${_dragIndicator.dx.toStringAsFixed(2)}, '
                                      '${_dragIndicator.dy.toStringAsFixed(2)})',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                _SectionCard(
                  title: 'EventLimiterMixin controller demo',
                  description:
                      'This controller uses the mixin directly instead of widget wrappers. It throttles a fast tap handler, debounces autosave, and exposes cleanup for inactive limiters.',
                  child: AnimatedBuilder(
                    animation: _limiterController,
                    builder: (BuildContext context, Widget? child) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: <Widget>[
                              _MetricBadge(
                                label: 'Raw taps',
                                value: '${_limiterController.rawTapCount}',
                                color: const Color(0xFF1D4ED8),
                              ),
                              _MetricBadge(
                                label: 'Throttled taps',
                                value: '${_limiterController.acceptedTapCount}',
                                color: const Color(0xFF0891B2),
                              ),
                              _MetricBadge(
                                label: 'Debounced saves',
                                value:
                                    '${_limiterController.debouncedSaveCount}',
                                color: const Color(0xFF16A34A),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: <Widget>[
                              FilledButton.icon(
                                onPressed: () {
                                  _limiterController.recordTap();
                                  _pushLog(
                                    'EventLimiterMixin recordTap invoked.',
                                  );
                                },
                                icon: const Icon(Icons.touch_app_outlined),
                                label: const Text('Fast Tap'),
                              ),
                              OutlinedButton.icon(
                                onPressed: () {
                                  final String draft =
                                      'draft-${DateTime.now().millisecond}';
                                  _limiterController.queueAutosave(draft);
                                  _pushLog(
                                    'EventLimiterMixin queued autosave for '
                                    '$draft.',
                                  );
                                },
                                icon: const Icon(Icons.save_outlined),
                                label: const Text('Queue Autosave'),
                              ),
                              TextButton.icon(
                                onPressed: () {
                                  final int removed = _limiterController
                                      .cleanupIdleLimiters();
                                  _pushLog(
                                    'EventLimiterMixin cleanup removed '
                                    '$removed limiter(s).',
                                  );
                                },
                                icon: const Icon(Icons.cleaning_services),
                                label: const Text('Cleanup Inactive'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              'Last status: ${_limiterController.status}\n'
                              'Last saved draft: '
                              '${_limiterController.lastSavedDraft}',
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                _SectionCard(
                  title: 'Recent events',
                  description:
                      'This log makes the delay differences visible while you interact with the widgets above.',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _eventLog
                        .map(
                          (String line) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(line),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
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

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.description,
    required this.child,
  });

  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(description),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class _MetricBadge extends StatelessWidget {
  const _MetricBadge({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: TextStyle(color: color, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _ResultWrap extends StatelessWidget {
  const _ResultWrap({required this.results});

  final List<String> results;

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty) {
      return const Text('No results yet.');
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: results.map((String item) => Chip(label: Text(item))).toList(),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  const _ProgressRow({
    required this.label,
    required this.value,
    required this.color,
    required this.caption,
  });

  final String label;
  final double value;
  final Color color;
  final String caption;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: value.clamp(0.0, 1.0),
          minHeight: 12,
          borderRadius: BorderRadius.circular(999),
          color: color,
          backgroundColor: color.withValues(alpha: 0.14),
        ),
        const SizedBox(height: 6),
        Text(caption),
      ],
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint linePaint = Paint()
      ..color = const Color(0xFFDCE3EA)
      ..strokeWidth = 1;

    for (double x = 0; x <= size.width; x += size.width / 6) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), linePaint);
    }

    for (double y = 0; y <= size.height; y += size.height / 5) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LimiterPlaygroundController extends ChangeNotifier
    with EventLimiterMixin {
  int rawTapCount = 0;
  int acceptedTapCount = 0;
  int debouncedSaveCount = 0;
  String lastSavedDraft = 'Nothing saved yet.';
  String status = 'Tap fast or queue autosave to create limiters.';

  void recordTap() {
    rawTapCount += 1;
    status = 'Raw tap #$rawTapCount received.';
    notifyListeners();

    throttle('fast-tap', () {
      acceptedTapCount += 1;
      status = 'Throttled tap accepted as #$acceptedTapCount.';
      notifyListeners();
    }, duration: const Duration(milliseconds: 700));
  }

  void queueAutosave(String draftId) {
    status = 'Queued autosave for $draftId.';
    notifyListeners();

    debounce('draft-save', () {
      debouncedSaveCount += 1;
      lastSavedDraft = draftId;
      status = 'Debounced autosave committed $draftId.';
      notifyListeners();
    }, duration: const Duration(milliseconds: 650));
  }

  int cleanupIdleLimiters() {
    final int removed = cleanupInactive();
    status = 'cleanupInactive removed $removed limiter(s).';
    notifyListeners();
    return removed;
  }

  @override
  void dispose() {
    cancelAll();
    super.dispose();
  }
}
