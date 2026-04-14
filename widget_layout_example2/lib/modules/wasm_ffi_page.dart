import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:widget_layout_example2/modules/wasm_ffi_demo_runtime.dart';
import 'package:widget_layout_example2/modules/wasm_library_wrapper.dart';

@RoutePage(name: 'WasmFfiRoute')
class WasmFfiPage extends StatefulWidget {
  const WasmFfiPage({super.key});

  @override
  State<WasmFfiPage> createState() => _WasmFfiPageState();
}

class _WasmFfiPageState extends State<WasmFfiPage> {
  static const WasmFfiDemoRuntime _runtime = WasmFfiDemoRuntime();

  Future<WasmFfiDemoResult>? _resultFuture;
  Future<WasmLibraryWrapper>? _wrapperFuture;
  String _interactiveResult = '';
  String _customInput = 'Flutter User';
  bool _isLoading = false;
  WasmLibraryWrapper? _wasmWrapper;
  String? _wasmLoadError;

  @override
  void initState() {
    super.initState();
    if (_runtime.isSupported) {
      _resultFuture = _runtime.loadStandaloneExample();
      _wrapperFuture = _initializeWasmWrapper();
    }
  }

  Future<WasmLibraryWrapper> _initializeWasmWrapper() async {
    try {
      final WasmLibraryWrapper wrapper = await WasmLibraryWrapper.create(
        'assets/wasm/wasm_ffi/native_example.wasm',
      );
      if (!mounted) {
        return wrapper;
      }
      setState(() {
        _wasmWrapper = wrapper;
        _wasmLoadError = null;
      });
      debugPrint('WASM library loaded successfully.');
      return wrapper;
    } catch (e) {
      if (mounted) {
        setState(() {
          _wrapperFuture = null;
          _wasmWrapper = null;
          _wasmLoadError = '$e';
        });
      }
      debugPrint('Failed to initialize WASM wrapper: $e');
      rethrow;
    }
  }

  void _reload() {
    if (!_runtime.isSupported) {
      return;
    }
    setState(() {
      _resultFuture = _runtime.loadStandaloneExample();
    });
  }

  Future<void> _executeCustomGreeting() async {
    setState(() {
      _isLoading = true;
      _interactiveResult = 'Loading WASM library...';
    });

    try {
      final Future<WasmLibraryWrapper> wrapperFuture = _wrapperFuture ??=
          _initializeWasmWrapper();
      final WasmLibraryWrapper wrapper = _wasmWrapper ?? await wrapperFuture;
      final String result = wrapper.callHello(_customInput);

      setState(() {
        _interactiveResult = result;
        _wasmWrapper = wrapper;
        _wasmLoadError = null;
      });
    } catch (e) {
      setState(() {
        _wasmLoadError = '$e';
        _interactiveResult = 'Error calling WASM: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final bool isInteractiveReady = _runtime.isSupported;
    final Color interactiveStatusColor = !_runtime.isSupported
        ? colorScheme.surfaceContainerHighest
        : _wasmLoadError != null
        ? colorScheme.errorContainer
        : _wasmWrapper != null
        ? colorScheme.primaryContainer
        : colorScheme.secondaryContainer;
    final IconData interactiveStatusIcon = !_runtime.isSupported
        ? Icons.info_outline
        : _wasmLoadError != null
        ? Icons.error_outline
        : _wasmWrapper != null
        ? Icons.check_circle_outline
        : Icons.hourglass_top_outlined;
    final String interactiveStatusTitle = !_runtime.isSupported
        ? 'Interactive calls disabled'
        : _wasmLoadError != null
        ? 'WASM library failed to load'
        : _wasmWrapper != null
        ? 'WASM library loaded'
        : 'Initializing WASM library';
    final String interactiveStatusMessage = !_runtime.isSupported
        ? 'Open this page on Flutter web to call exports from the bundled WASM module.'
        : _wasmLoadError != null
        ? '$_wasmLoadError Tap the button again to retry initialization.'
        : _wasmWrapper != null
        ? 'The interactive button now calls the real `hello` export from `native_example.wasm`.'
        : 'The page is loading `native_example.wasm`. You can click the button once initialization finishes, or click now and the call will wait for the loader.';

    return Scaffold(
      appBar: AppBar(title: const Text('wasm_ffi Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            // Introduction Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Use `wasm_ffi` to call WebAssembly exports with a '
                      '`dart:ffi`-style API on Flutter web.',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'This module goes beyond a single snippet. It shows how '
                      'to load a `.wasm` asset, create typed bindings, marshal '
                      'UTF-8 strings, verify exported symbols, and keep the app '
                      'safe on non-web targets with a conditional runtime.',
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: const <Widget>[
                        Chip(label: Text('DynamicLibrary.open')),
                        Chip(label: Text('lookup / lookupFunction')),
                        Chip(label: Text('Utf8 marshalling')),
                        Chip(label: Text('Asset bundling')),
                        Chip(label: Text('Flutter web only')),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Runtime Support',
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    _runtime.isSupported
                        ? Icons.language_outlined
                        : Icons.desktop_access_disabled_outlined,
                    color: _runtime.isSupported
                        ? colorScheme.primary
                        : colorScheme.error,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          _runtime.isSupported
                              ? 'Live demo available'
                              : 'Documentation mode',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(_runtime.supportMessage),
                        const SizedBox(height: 10),
                        Text(
                          'Asset path: ${WasmFfiDemoRuntime.assetPath}',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Interactive Custom Input Demo
            _SectionCard(
              title: '🎮 Interactive: Custom Greeting Demo',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Call wasm function with your custom input:',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  _StatusBanner(
                    color: interactiveStatusColor,
                    icon: interactiveStatusIcon,
                    title: interactiveStatusTitle,
                    message: interactiveStatusMessage,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    onChanged: (String value) {
                      setState(() {
                        _customInput = value.isEmpty ? 'User' : value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter your name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: <Widget>[
                      FilledButton.icon(
                        onPressed: _isLoading || !isInteractiveReady
                            ? null
                            : _executeCustomGreeting,
                        icon: _isLoading
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.play_arrow),
                        label: const Text('Call Wasm Function'),
                      ),
                    ],
                  ),
                  if (_interactiveResult.isNotEmpty) ...<Widget>[
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Result:', style: theme.textTheme.labelSmall),
                          const SizedBox(height: 8),
                          Text(
                            _interactiveResult,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Standalone Wasm Demo
            _SectionCard(
              title: 'Standalone Wasm Demo',
              action: _runtime.isSupported
                  ? FilledButton.icon(
                      onPressed: _reload,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reload'),
                    )
                  : null,
              child: _runtime.isSupported
                  ? FutureBuilder<WasmFfiDemoResult>(
                      future: _resultFuture,
                      builder:
                          (
                            BuildContext context,
                            AsyncSnapshot<WasmFfiDemoResult> snapshot,
                          ) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            if (snapshot.hasError) {
                              return _StatusBanner(
                                color: colorScheme.errorContainer,
                                icon: Icons.error_outline,
                                title: 'Demo failed to load',
                                message: '${snapshot.error}',
                              );
                            }

                            final WasmFfiDemoResult result =
                                snapshot.requireData;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Wrap(
                                  spacing: 12,
                                  runSpacing: 12,
                                  children: <Widget>[
                                    _MetricCard(
                                      label: 'Library Name',
                                      value: result.libraryName,
                                    ),
                                    _MetricCard(
                                      label: 'Hello Result',
                                      value: result.helloMessage,
                                    ),
                                    _MetricCard(
                                      label: 'sizeof(int)',
                                      value: '${result.intSize}',
                                    ),
                                    _MetricCard(
                                      label: 'sizeof(bool)',
                                      value: '${result.boolSize}',
                                    ),
                                    _MetricCard(
                                      label: 'sizeof(pointer)',
                                      value: '${result.pointerSize}',
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Resolved exports',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: result.availableSymbols
                                      .map(
                                        (String symbol) => Chip(
                                          label: Text(symbol),
                                          avatar: const Icon(
                                            Icons.check_circle_outline,
                                            size: 18,
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ],
                            );
                          },
                    )
                  : _StatusBanner(
                      color: colorScheme.surfaceContainerHighest,
                      icon: Icons.info_outline,
                      title: 'Live execution disabled',
                      message:
                          'Open this page on Flutter web to run the bundled '
                          'standalone Wasm example.',
                    ),
            ),
            const SizedBox(height: 16),
            // Code Examples Section
            _SectionCard(
              title: '📝 Code Examples',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 12),
                  _CodeCard(
                    title: '1. Load the `.wasm` asset directly',
                    code: '''final library = await ffi.DynamicLibrary.open(
  'assets/wasm/wasm_ffi/native_example.wasm',
);''',
                  ),
                  const SizedBox(height: 12),
                  _CodeCard(
                    title: '2. Build typed bindings with lookup / asFunction',
                    code: '''final helloPtr = library.lookup<
    ffi.NativeFunction<ffi.Pointer<ffi.Char> Function(
      ffi.Pointer<ffi.Char>
    )>
  >('hello');

final hello = helloPtr.asFunction<
    ffi.Pointer<ffi.Char> Function(ffi.Pointer<ffi.Char>)
  >();''',
                  ),
                  const SizedBox(height: 12),
                  _CodeCard(
                    title: '3. Marshal UTF-8 strings and free memory',
                    code: '''final message = using((Arena arena) {
  final name = 'Flutter Web'
      .toNativeUtf8(allocator: arena)
      .cast<ffi.Char>();
  final response = bindings.hello(name);

  try {
    return response.cast<Utf8>().toDartString();
  } finally {
    bindings.freeMemory(response);
  }
}, library.allocator);''',
                  ),
                  const SizedBox(height: 12),
                  _CodeCard(
                    title: '4. Verify exports before you call them',
                    code: '''const expectedSymbols = <String>[
  'getLibraryName',
  'hello',
  'freeMemory',
  'intSize',
];

final available = expectedSymbols
    .where(library.providesSymbol)
    .toList();''',
                  ),
                  const SizedBox(height: 12),
                  _CodeCard(
                    title: '5. Handle memory management safely',
                    code: '''// Always use Arena for automatic cleanup
using((Arena arena) {
  final ptr = 'text'.toNativeUtf8(allocator: arena);
  // ptr is automatically freed when exiting scope
  return someWasmFunction(ptr);
}, library.allocator);''',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'When To Use It',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Reach for `wasm_ffi` when you already have C-style APIs '
                    'compiled to WebAssembly and want a familiar FFI workflow '
                    'inside Flutter web.',
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Keep native platforms behind a separate implementation, '
                    'because `wasm_ffi` is explicitly a web-only package.',
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '✅ Use when: You have precompiled WASM modules, need low-level access, or want FFI-like patterns on web',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '❌ Avoid when: You need platform-specific code, want to share logic between native and web, or need high-level bindings',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Key Concepts',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _ConceptRow(
                    icon: Icons.inventory_2_outlined,
                    label: 'Asset Bundling',
                    description:
                        'Bundle nested `.wasm` files in `pubspec.yaml` so Flutter web serves them',
                  ),
                  const SizedBox(height: 12),
                  _ConceptRow(
                    icon: Icons.link,
                    label: 'Symbol Lookup',
                    description:
                        'Finds exported functions by name from WASM library',
                  ),
                  const SizedBox(height: 12),
                  _ConceptRow(
                    icon: Icons.memory,
                    label: 'FFI Memory Model',
                    description:
                        'Manages memory across WASM boundaries with Arena',
                  ),
                  const SizedBox(height: 12),
                  _ConceptRow(
                    icon: Icons.language,
                    label: 'String Marshalling',
                    description:
                        'Converts Dart strings to C-style pointers and back',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
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
  const _SectionCard({required this.title, required this.child, this.action});

  final String title;
  final Widget child;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (action case final Widget action) action,
              ],
            ),
            const SizedBox(height: 14),
            child,
          ],
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Container(
      width: 180,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBanner extends StatelessWidget {
  const _StatusBanner({
    required this.color,
    required this.icon,
    required this.title,
    required this.message,
  });

  final Color color;
  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(message),
              ],
            ),
          ),
        ],
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
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.55,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                code,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontFamily: 'monospace',
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConceptRow extends StatelessWidget {
  const _ConceptRow({
    required this.icon,
    required this.label,
    required this.description,
  });

  final IconData icon;
  final String label;
  final String description;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  label,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(description, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Wrapper class for WASM library with type-safe bindings
/// Web-only implementation for Flutter web platform
/// (Implementation provided by wasm_library_wrapper.dart)
