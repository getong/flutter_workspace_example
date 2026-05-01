import 'dart:async';
import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:widget_layout_example2/app_navigation.dart';

@RoutePage(name: RouteName.desktopMultiWindow)
class DesktopMultiWindowPage extends StatelessWidget {
  const DesktopMultiWindowPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _DesktopMultiWindowScope();
  }
}

class _DesktopMultiWindowScope extends StatefulWidget {
  const _DesktopMultiWindowScope();

  @override
  State<_DesktopMultiWindowScope> createState() =>
      _DesktopMultiWindowScopeState();
}

class _DesktopMultiWindowScopeState extends State<_DesktopMultiWindowScope> {
  final _DesktopWindowCoordinator _coordinator = _DesktopWindowCoordinator();

  @override
  void initState() {
    super.initState();
    _coordinator.initialize();
  }

  @override
  void dispose() {
    _coordinator.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<_DesktopMultiWindowModel>(
      valueListenable: _coordinator,
      builder: (BuildContext context, _DesktopMultiWindowModel model, Widget? child) {
        final ThemeData theme = Theme.of(context);
        final bool desktopSupported = _isDesktopTarget;
        return Scaffold(
          appBar: AppBar(title: const Text('desktop_multi_window Module')),
          body: SelectionArea(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: <Widget>[
                Text(
                  'desktop_multi_window lets a Flutter desktop app create '
                  'and coordinate multiple engine-backed windows.',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'This page is based on the local package example and the '
                  'installed plugin API in this project. It demonstrates '
                  '`WindowConfiguration`, `WindowController.create`, '
                  '`WindowController.fromCurrentEngine`, '
                  '`WindowController.getAll`, `show`, `hide`, '
                  '`invokeMethod`, `WindowMethodChannel`, and '
                  '`onWindowsChanged`.',
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: const <Widget>[
                    _KeywordChip(label: 'WindowConfiguration'),
                    _KeywordChip(label: 'WindowController.create'),
                    _KeywordChip(label: 'WindowController.getAll'),
                    _KeywordChip(label: 'fromCurrentEngine'),
                    _KeywordChip(label: 'show / hide'),
                    _KeywordChip(label: 'invokeMethod'),
                    _KeywordChip(label: 'WindowMethodChannel'),
                    _KeywordChip(label: 'onWindowsChanged'),
                  ],
                ),
                const SizedBox(height: 24),
                if (!desktopSupported)
                  const _WarningBanner(
                    title: 'Desktop-only plugin behavior',
                    message:
                        'This dependency targets desktop runtimes. The '
                        'explanatory UI still works here, but active window '
                        'creation and cross-window messaging are disabled on '
                        'non-desktop platforms.',
                  ),
                if (model.errorMessage != null) ...<Widget>[
                  const SizedBox(height: 16),
                  _WarningBanner(
                    title: 'Last plugin error',
                    message: model.errorMessage!,
                  ),
                ],
                const SizedBox(height: 16),
                const _CodeSampleCard(),
                const SizedBox(height: 16),
                _SectionCard(
                  title: '1. Window Arguments + Configuration',
                  subtitle:
                      'The example app encodes business metadata into a '
                      'String, then passes it through `WindowConfiguration` '
                      'when spawning a new window.',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const _SnippetBlock(
                        code:
                            'final config = WindowConfiguration(\n'
                            '  hiddenAtLaunch: true,\n'
                            '  arguments: jsonEncode({\n'
                            "    'businessId': 'sample',\n"
                            "    'title': 'Inspector window',\n"
                            "    'color': 'teal',\n"
                            '  }),\n'
                            ');',
                      ),
                      const SizedBox(height: 16),
                      _ArgumentPreviewCard(
                        argumentsJson:
                            _DesktopWindowCoordinator.sampleArgumentsJson,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _SectionCard(
                  title: '2. Window Creation + Commands',
                  subtitle:
                      'These controls mirror the package example: create '
                      'hidden windows, show them later, and send method '
                      'channel commands to a target window.',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: <Widget>[
                          FilledButton.icon(
                            onPressed: desktopSupported
                                ? _coordinator.createSampleWindow
                                : null,
                            icon: const Icon(Icons.open_in_new),
                            label: const Text('Create Sample Window'),
                          ),
                          FilledButton.tonalIcon(
                            onPressed: desktopSupported
                                ? _coordinator.createBatchWindows
                                : null,
                            icon: const Icon(Icons.grid_view),
                            label: const Text('Create Batch'),
                          ),
                          OutlinedButton.icon(
                            onPressed: desktopSupported
                                ? _coordinator.refreshWindows
                                : null,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Refresh Window List'),
                          ),
                          OutlinedButton.icon(
                            onPressed: desktopSupported
                                ? _coordinator.pingRegisteredChannel
                                : null,
                            icon: const Icon(Icons.sync),
                            label: const Text('Ping Demo Channel'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      LayoutBuilder(
                        builder:
                            (BuildContext context, BoxConstraints constraints) {
                              if (constraints.maxWidth < 860) {
                                return Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    _CurrentEngineCard(model: model),
                                    const SizedBox(height: 16),
                                    _MethodChannelCard(
                                      model: model,
                                      desktopSupported: desktopSupported,
                                      onSendMessage:
                                          (String windowId, String message) {
                                            return _coordinator
                                                .sendWindowMessage(
                                                  windowId: windowId,
                                                  message: message,
                                                );
                                          },
                                    ),
                                  ],
                                );
                              }

                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: _CurrentEngineCard(model: model),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _MethodChannelCard(
                                      model: model,
                                      desktopSupported: desktopSupported,
                                      onSendMessage:
                                          (String windowId, String message) {
                                            return _coordinator
                                                .sendWindowMessage(
                                                  windowId: windowId,
                                                  message: message,
                                                );
                                          },
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
                  title: '3. onWindowsChanged + Window List',
                  subtitle:
                      'The package exposes `onWindowsChanged` so the UI can '
                      'refresh when windows are created or closed.',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _MetricWrap(
                        metrics: <_MetricData>[
                          _MetricData(
                            label: 'Window events',
                            value: '${model.windowsChangedEvents}',
                          ),
                          _MetricData(
                            label: 'Known windows',
                            value: '${model.windows.length}',
                          ),
                          _MetricData(
                            label: 'Messages received',
                            value: '${model.receivedMessages.length}',
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _WindowListCard(
                        model: model,
                        desktopSupported: desktopSupported,
                        onShow: (String id) =>
                            _coordinator.showWindow(windowId: id),
                        onHide: (String id) =>
                            _coordinator.hideWindow(windowId: id),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _SectionCard(
                  title: '4. Cross-window Messages',
                  subtitle:
                      'This demonstrates `WindowMethodChannel` registration '
                      'and `invokeMethod(...)` responses with a local event log.',
                  child: _MessageLogCard(model: model),
                ),
                const SizedBox(height: 16),
                const _SectionCard(
                  title: '5. Practical Notes',
                  subtitle:
                      'What this plugin is good at and what the example pattern implies.',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _BulletLine(
                        text:
                            'Use JSON or another compact String format for per-window launch arguments.',
                      ),
                      _BulletLine(
                        text:
                            'Register a `WindowMethodChannel` when a window needs app-specific commands from peers.',
                      ),
                      _BulletLine(
                        text:
                            'Use `onWindowsChanged` to keep task lists, inspectors, and diagnostics dashboards fresh.',
                      ),
                      _BulletLine(
                        text:
                            'Expect plugin calls to fail on unsupported platforms or if no peer window registered the channel.',
                      ),
                      _BulletLine(
                        text:
                            'A production app usually pairs this plugin with native window sizing, focus, or title APIs per platform.',
                      ),
                    ],
                  ),
                ),
              ],
            ),
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

class _DesktopWindowCoordinator
    extends ValueNotifier<_DesktopMultiWindowModel> {
  _DesktopWindowCoordinator() : super(const _DesktopMultiWindowModel());

  static const String _channelName =
      'widget_layout_example2/demo_window_channel';
  static const String sampleArgumentsJson =
      '{"businessId":"sample","title":"Inspector window","accent":"teal","counter":1}';

  final WindowMethodChannel _channel = const WindowMethodChannel(
    _channelName,
    mode: ChannelMode.unidirectional,
  );

  StreamSubscription<void>? _windowsChangedSubscription;
  bool _channelRegistered = false;

  Future<void> initialize() async {
    if (!_isDesktopTarget) {
      value = value.copyWith(
        currentWindowDescription:
            'Unsupported platform for desktop window spawning.',
      );
      return;
    }

    await _registerChannelHandler();
    await _loadCurrentWindow();
    await refreshWindows();
    _windowsChangedSubscription = onWindowsChanged.listen((_) {
      value = value.copyWith(
        windowsChangedEvents: value.windowsChangedEvents + 1,
      );
      refreshWindows();
    });
  }

  Future<void> _registerChannelHandler() async {
    try {
      await _channel.setMethodCallHandler((MethodCall call) async {
        final String time = _formatTimestamp(DateTime.now());
        final List<String> nextMessages = <String>[
          '$time  ${call.method}: ${call.arguments}',
          ...value.receivedMessages,
        ].take(20).toList();

        value = value.copyWith(
          receivedMessages: nextMessages,
          errorMessage: null,
        );

        if (call.method == 'ping') {
          return 'pong from module page';
        }
        if (call.method == 'showArguments') {
          return sampleArgumentsJson;
        }
        return 'received ${call.method}';
      });
      _channelRegistered = true;
      value = value.copyWith(
        channelState:
            'Registered `WindowMethodChannel($_channelName)` in unidirectional mode.',
        errorMessage: null,
      );
    } catch (error) {
      _recordError('Failed to register method channel: $error');
    }
  }

  Future<void> _loadCurrentWindow() async {
    try {
      final WindowController current =
          await WindowController.fromCurrentEngine();
      value = value.copyWith(
        currentWindowDescription:
            'windowId=${current.windowId}, arguments=${current.arguments.isEmpty ? '(empty)' : current.arguments}',
        errorMessage: null,
      );
    } catch (error) {
      _recordError('Failed to read current engine window: $error');
    }
  }

  Future<void> refreshWindows() async {
    if (!_isDesktopTarget) {
      return;
    }
    try {
      final List<WindowController> controllers =
          await WindowController.getAll();
      final List<_WindowSummary> summaries = controllers
          .map(
            (WindowController controller) => _WindowSummary(
              windowId: controller.windowId,
              arguments: controller.arguments,
            ),
          )
          .toList();
      value = value.copyWith(windows: summaries, errorMessage: null);
    } catch (error) {
      _recordError('Failed to refresh windows: $error');
    }
  }

  Future<void> createSampleWindow() async {
    await _createWindowWithArguments(sampleArgumentsJson);
  }

  Future<void> createBatchWindows() async {
    for (int i = 0; i < 3; i++) {
      final String args = jsonEncode(<String, dynamic>{
        'businessId': 'sample',
        'title': 'Batch window ${i + 1}',
        'accent': i.isEven ? 'orange' : 'blue',
        'counter': i + 1,
      });
      await _createWindowWithArguments(args);
    }
  }

  Future<void> _createWindowWithArguments(String arguments) async {
    if (!_isDesktopTarget) {
      return;
    }
    try {
      final WindowConfiguration configuration = WindowConfiguration(
        hiddenAtLaunch: true,
        arguments: arguments,
      );
      final WindowController controller = await WindowController.create(
        configuration,
      );
      await controller.show();
      final List<String> nextMessages = <String>[
        '${_formatTimestamp(DateTime.now())}  created window ${controller.windowId}',
        ...value.receivedMessages,
      ].take(20).toList();
      value = value.copyWith(
        receivedMessages: nextMessages,
        errorMessage: null,
      );
      await refreshWindows();
    } catch (error) {
      _recordError('Failed to create or show window: $error');
    }
  }

  Future<void> showWindow({required String windowId}) async {
    try {
      final WindowController controller = WindowController.fromWindowId(
        windowId,
      );
      await controller.show();
      await refreshWindows();
    } catch (error) {
      _recordError('Failed to show window $windowId: $error');
    }
  }

  Future<void> hideWindow({required String windowId}) async {
    try {
      final WindowController controller = WindowController.fromWindowId(
        windowId,
      );
      await controller.hide();
      await refreshWindows();
    } catch (error) {
      _recordError('Failed to hide window $windowId: $error');
    }
  }

  Future<void> pingRegisteredChannel() async {
    if (!_channelRegistered) {
      _recordError('The demo window channel is not registered.');
      return;
    }
    try {
      final String? result = await _channel.invokeMethod<String>(
        'ping',
        'ping',
      );
      final List<String> nextMessages = <String>[
        '${_formatTimestamp(DateTime.now())}  ping -> $result',
        ...value.receivedMessages,
      ].take(20).toList();
      value = value.copyWith(
        receivedMessages: nextMessages,
        errorMessage: null,
      );
    } catch (error) {
      _recordError('Failed to ping demo channel: $error');
    }
  }

  Future<void> sendWindowMessage({
    required String windowId,
    required String message,
  }) async {
    if (message.trim().isEmpty) {
      return;
    }
    try {
      final WindowController controller = WindowController.fromWindowId(
        windowId,
      );
      final String? reply = await controller.invokeMethod<String>(
        'demo_message',
        <String, dynamic>{
          'message': message,
          'from': 'desktop_multi_window_page',
        },
      );
      final List<String> nextMessages = <String>[
        '${_formatTimestamp(DateTime.now())}  invokeMethod($windowId) -> ${reply ?? '(null)'}',
        ...value.receivedMessages,
      ].take(20).toList();
      value = value.copyWith(
        receivedMessages: nextMessages,
        errorMessage: null,
      );
    } catch (error) {
      _recordError('Failed to invoke method on window $windowId: $error');
    }
  }

  void _recordError(String message) {
    value = value.copyWith(errorMessage: message);
  }

  @override
  void dispose() {
    _windowsChangedSubscription?.cancel();
    _channel.setMethodCallHandler(null);
    super.dispose();
  }
}

class _DesktopMultiWindowModel {
  const _DesktopMultiWindowModel({
    this.currentWindowDescription = 'Loading current window metadata...',
    this.channelState = 'Preparing demo method channel...',
    this.windows = const <_WindowSummary>[],
    this.receivedMessages = const <String>[],
    this.windowsChangedEvents = 0,
    this.errorMessage,
  });

  final String currentWindowDescription;
  final String channelState;
  final List<_WindowSummary> windows;
  final List<String> receivedMessages;
  final int windowsChangedEvents;
  final String? errorMessage;

  _DesktopMultiWindowModel copyWith({
    String? currentWindowDescription,
    String? channelState,
    List<_WindowSummary>? windows,
    List<String>? receivedMessages,
    int? windowsChangedEvents,
    String? errorMessage,
  }) {
    return _DesktopMultiWindowModel(
      currentWindowDescription:
          currentWindowDescription ?? this.currentWindowDescription,
      channelState: channelState ?? this.channelState,
      windows: windows ?? this.windows,
      receivedMessages: receivedMessages ?? this.receivedMessages,
      windowsChangedEvents: windowsChangedEvents ?? this.windowsChangedEvents,
      errorMessage: errorMessage,
    );
  }
}

class _WindowSummary {
  const _WindowSummary({required this.windowId, required this.arguments});

  final String windowId;
  final String arguments;

  Map<String, dynamic>? get decodedArguments {
    if (arguments.isEmpty) {
      return null;
    }
    try {
      return jsonDecode(arguments) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }
}

class _CodeSampleCard extends StatelessWidget {
  const _CodeSampleCard();

  @override
  Widget build(BuildContext context) {
    return const _SectionCard(
      title: 'Core API Shape',
      subtitle:
          'These examples match the plugin and example code inspected locally.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _SnippetBlock(
            code:
                'final controller = await WindowController.create(\n'
                '  WindowConfiguration(\n'
                '    hiddenAtLaunch: true,\n'
                "    arguments: jsonEncode({'businessId': 'sample'}),\n"
                '  ),\n'
                ');\n'
                'await controller.show();',
          ),
          SizedBox(height: 12),
          _SnippetBlock(
            code:
                'final current = await WindowController.fromCurrentEngine();\n'
                'final allWindows = await WindowController.getAll();',
          ),
          SizedBox(height: 12),
          _SnippetBlock(
            code:
                'const channel = WindowMethodChannel(\n'
                "  'widget_layout_example2/demo_window_channel',\n"
                '  mode: ChannelMode.unidirectional,\n'
                ');\n'
                'await channel.setMethodCallHandler((call) async {\n'
                "  if (call.method == 'ping') return 'pong';\n"
                "  return 'received';\n"
                '});',
          ),
          SizedBox(height: 12),
          _SnippetBlock(
            code:
                'onWindowsChanged.listen((_) {\n'
                '  refreshWindowList();\n'
                '});',
          ),
        ],
      ),
    );
  }
}

class _ArgumentPreviewCard extends StatelessWidget {
  const _ArgumentPreviewCard({required this.argumentsJson});

  final String argumentsJson;

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> decoded =
        jsonDecode(argumentsJson) as Map<String, dynamic>;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.55),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Arguments sent to a child window',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          Text(argumentsJson),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: decoded.entries
                .map(
                  (MapEntry<String, dynamic> entry) =>
                      Chip(label: Text('${entry.key}: ${entry.value}')),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _CurrentEngineCard extends StatelessWidget {
  const _CurrentEngineCard({required this.model});

  final _DesktopMultiWindowModel model;

  @override
  Widget build(BuildContext context) {
    return _DemoCard(
      title: 'Current Engine',
      subtitle:
          'Use `WindowController.fromCurrentEngine()` to discover the current '
          'window ID and launch arguments.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(model.currentWindowDescription),
          const SizedBox(height: 16),
          Text(
            model.channelState,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _MethodChannelCard extends StatefulWidget {
  const _MethodChannelCard({
    required this.model,
    required this.desktopSupported,
    required this.onSendMessage,
  });

  final _DesktopMultiWindowModel model;
  final bool desktopSupported;
  final Future<void> Function(String windowId, String message) onSendMessage;

  @override
  State<_MethodChannelCard> createState() => _MethodChannelCardState();
}

class _MethodChannelCardState extends State<_MethodChannelCard> {
  late final TextEditingController _windowIdController;
  late final TextEditingController _messageController;

  @override
  void initState() {
    super.initState();
    _windowIdController = TextEditingController();
    _messageController = TextEditingController(text: 'Hello from the module');
  }

  @override
  void didUpdateWidget(covariant _MethodChannelCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_windowIdController.text.isEmpty && widget.model.windows.isNotEmpty) {
      _windowIdController.text = widget.model.windows.first.windowId;
    }
  }

  @override
  void dispose() {
    _windowIdController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_windowIdController.text.isEmpty && widget.model.windows.isNotEmpty) {
      _windowIdController.text = widget.model.windows.first.windowId;
    }

    return _DemoCard(
      title: 'Method Calls',
      subtitle:
          'Use `invokeMethod(...)` for targeted commands and '
          '`WindowMethodChannel` for app-defined cross-window channels.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            controller: _windowIdController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Target window ID',
              hintText: 'Example: 1',
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _messageController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Message payload',
            ),
            minLines: 2,
            maxLines: 4,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: <Widget>[
              FilledButton.icon(
                onPressed: widget.desktopSupported
                    ? () => widget.onSendMessage(
                        _windowIdController.text.trim(),
                        _messageController.text.trim(),
                      )
                    : null,
                icon: const Icon(Icons.send),
                label: const Text('invokeMethod'),
              ),
              OutlinedButton.icon(
                onPressed: widget.desktopSupported
                    ? () => _messageController.text =
                          jsonEncode(<String, dynamic>{
                            'action': 'inspect',
                            'timestamp': DateTime.now().toIso8601String(),
                          })
                    : null,
                icon: const Icon(Icons.data_object),
                label: const Text('Fill JSON Payload'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WindowListCard extends StatelessWidget {
  const _WindowListCard({
    required this.model,
    required this.desktopSupported,
    required this.onShow,
    required this.onHide,
  });

  final _DesktopMultiWindowModel model;
  final bool desktopSupported;
  final Future<void> Function(String windowId) onShow;
  final Future<void> Function(String windowId) onHide;

  @override
  Widget build(BuildContext context) {
    return _DemoCard(
      title: 'Window Registry Snapshot',
      subtitle:
          'Equivalent to the example’s `WindowList`: list known windows and '
          'issue simple window commands.',
      child: model.windows.isEmpty
          ? const Text('No desktop windows reported by the plugin yet.')
          : Column(
              children: model.windows.map((_WindowSummary window) {
                final Map<String, dynamic>? args = window.decodedArguments;
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Window ${window.windowId}',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          args == null
                              ? (window.arguments.isEmpty
                                    ? 'No arguments'
                                    : window.arguments)
                              : args.toString(),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: <Widget>[
                            OutlinedButton(
                              onPressed: desktopSupported
                                  ? () => onShow(window.windowId)
                                  : null,
                              child: const Text('Show'),
                            ),
                            OutlinedButton(
                              onPressed: desktopSupported
                                  ? () => onHide(window.windowId)
                                  : null,
                              child: const Text('Hide'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
    );
  }
}

class _MessageLogCard extends StatelessWidget {
  const _MessageLogCard({required this.model});

  final _DesktopMultiWindowModel model;

  @override
  Widget build(BuildContext context) {
    return _DemoCard(
      title: 'Event Log',
      subtitle:
          'Incoming channel calls, ping results, and spawn operations are kept in a simple rolling list.',
      child: model.receivedMessages.isEmpty
          ? const Text('No messages recorded yet.')
          : Column(
              children: model.receivedMessages
                  .map(
                    (String line) => ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.subdirectory_arrow_right),
                      title: Text(line),
                    ),
                  )
                  .toList(),
            ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
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
            const SizedBox(height: 8),
            Text(subtitle, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class _DemoCard extends StatelessWidget {
  const _DemoCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(subtitle),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class _SnippetBlock extends StatelessWidget {
  const _SnippetBlock({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        code,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(fontFamily: 'monospace', height: 1.45),
      ),
    );
  }
}

class _KeywordChip extends StatelessWidget {
  const _KeywordChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      avatar: const Icon(Icons.desktop_windows_outlined, size: 18),
    );
  }
}

class _WarningBanner extends StatelessWidget {
  const _WarningBanner({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: colorScheme.onErrorContainer,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colorScheme.onErrorContainer,
            ),
          ),
        ],
      ),
    );
  }
}

class _BulletLine extends StatelessWidget {
  const _BulletLine({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Icon(Icons.circle, size: 8),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class _MetricWrap extends StatelessWidget {
  const _MetricWrap({required this.metrics});

  final List<_MetricData> metrics;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: metrics
          .map(
            (_MetricData data) => Container(
              constraints: const BoxConstraints(minWidth: 150),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.55),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(data.label),
                  const SizedBox(height: 6),
                  Text(
                    data.value,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _MetricData {
  const _MetricData({required this.label, required this.value});

  final String label;
  final String value;
}

bool get _isDesktopTarget =>
    !kIsWeb &&
    (defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.linux);

String _formatTimestamp(DateTime value) {
  final String hour = value.hour.toString().padLeft(2, '0');
  final String minute = value.minute.toString().padLeft(2, '0');
  final String second = value.second.toString().padLeft(2, '0');
  return '$hour:$minute:$second';
}
