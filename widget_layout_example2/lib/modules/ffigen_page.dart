import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/app_navigation.dart';

@RoutePage(name: RouteName.ffigen)
class FfigenPage extends StatefulWidget {
  const FfigenPage({super.key});

  @override
  State<FfigenPage> createState() => _FfigenPageState();
}

class _FfigenPageState extends State<FfigenPage> {
  late final TextEditingController _headerController;
  late final TextEditingController _outputController;
  late final TextEditingController _libraryController;

  bool _includeStruct = true;
  bool _includeComments = true;

  @override
  void initState() {
    super.initState();
    _headerController = TextEditingController(text: 'src/native/device_api.h');
    _outputController = TextEditingController(
      text: 'lib/src/generated/device_api_bindings.dart',
    );
    _libraryController = TextEditingController(text: 'device_api');
  }

  @override
  void dispose() {
    _headerController.dispose();
    _outputController.dispose();
    _libraryController.dispose();
    super.dispose();
  }

  String get _headerPath => _headerController.text.trim().isEmpty
      ? 'src/native/device_api.h'
      : _headerController.text.trim();

  String get _outputPath => _outputController.text.trim().isEmpty
      ? 'lib/src/generated/device_api_bindings.dart'
      : _outputController.text.trim();

  String get _libraryName => _libraryController.text.trim().isEmpty
      ? 'device_api'
      : _libraryController.text.trim();

  String get _headerCode {
    final String structBlock = _includeStruct
        ? '''

typedef struct DeviceSnapshot {
  int battery_level;
  int is_charging;
} DeviceSnapshot;

DeviceSnapshot read_device_snapshot(void);
'''
        : '';

    return '''
#ifndef DEVICE_API_H_
#define DEVICE_API_H_

#ifdef __cplusplus
extern "C" {
#endif

int sum_values(int left, int right);
const char* current_device_name(void);$structBlock

#ifdef __cplusplus
}
#endif

#endif  // DEVICE_API_H_
''';
  }

  String get _configCode {
    final String commentConfig = _includeComments
        ? "comments:\n  style: any\n\n"
        : '';
    final String structConfig = _includeStruct
        ? '''
structs:
  include:
    - DeviceSnapshot

'''
        : '';

    final StringBuffer buffer = StringBuffer()
      ..writeln('name: ${_libraryName}_bindings')
      ..writeln('description: Generated bindings for $_libraryName')
      ..writeln()
      ..writeln('output: $_outputPath')
      ..writeln()
      ..writeln('headers:')
      ..writeln('  entry-points:')
      ..writeln('    - $_headerPath')
      ..writeln()
      ..write(commentConfig)
      ..write(structConfig)
      ..writeln('functions:')
      ..writeln('  include:')
      ..writeln('    - sum_values')
      ..writeln('    - current_device_name')
      ..writeln()
      ..writeln('llvm-path:')
      ..writeln('  - /opt/homebrew/opt/llvm');

    return buffer.toString();
  }

  String get _generatorCommand => 'dart run ffigen --config ffigen.yaml';

  String get _dartUsageCode {
    final String structSnippet = _includeStruct
        ? '''

  final DeviceSnapshot snapshot = bindings.read_device_snapshot();
  debugPrint(
    'battery: \${snapshot.batteryLevel}, charging: \${snapshot.isCharging}',
  );
'''
        : '';

    return '''
import 'dart:ffi' as ffi;
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:widget_layout_example2/src/generated/${_outputPath.split('/').last}';
import 'package:widget_layout_example2/app_navigation.dart';

ffi.DynamicLibrary loadNativeLibrary() {
  if (Platform.isMacOS || Platform.isIOS) {
    return ffi.DynamicLibrary.process();
  }
  if (Platform.isAndroid || Platform.isLinux) {
    return ffi.DynamicLibrary.open('lib$_libraryName.so');
  }
  if (Platform.isWindows) {
    return ffi.DynamicLibrary.open('$_libraryName.dll');
  }
  throw UnsupportedError('Unsupported platform');
}

void runFfiDemo() {
  final DeviceApiBindings bindings = DeviceApiBindings(loadNativeLibrary());

  final int total = bindings.sum_values(7, 11);
  final String name =
      bindings.current_device_name().cast<Utf8>().toDartString();

  debugPrint('sum: \$total, device: \$name');$structSnippet
}
''';
  }

  String get _cImplementationCode {
    final String structImpl = _includeStruct
        ? '''

DeviceSnapshot read_device_snapshot(void) {
  DeviceSnapshot snapshot;
  snapshot.battery_level = 87;
  snapshot.is_charging = 1;
  return snapshot;
}'''
        : '';

    return '''
#include "$_headerPath"

int sum_values(int left, int right) {
  return left + right;
}

const char* current_device_name(void) {
  return "widget-layout-example2";
}$structImpl
''';
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('ffigen Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Use `ffigen` to generate Dart FFI bindings from C or Objective-C headers.',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'This module demonstrates a practical FFI workflow: define exported C APIs in a header, generate Dart bindings with `ffigen`, load the native library, and call strongly typed functions from Flutter.',
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: const <Widget>[
                        Chip(label: Text('ffigen.yaml')),
                        Chip(label: Text('headers.entry-points')),
                        Chip(label: Text('DynamicLibrary.open')),
                        Chip(label: Text('ffi / Utf8')),
                        Chip(label: Text('generated bindings')),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Binding Setup',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _headerController,
                      decoration: const InputDecoration(
                        labelText: 'Header path',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _outputController,
                      decoration: const InputDecoration(
                        labelText: 'Generated Dart output',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _libraryController,
                      decoration: const InputDecoration(
                        labelText: 'Native library base name',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 12),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      value: _includeStruct,
                      title: const Text('Include struct binding example'),
                      subtitle: const Text(
                        'Shows how ffigen maps C structs in addition to functions.',
                      ),
                      onChanged: (bool value) {
                        setState(() => _includeStruct = value);
                      },
                    ),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      value: _includeComments,
                      title: const Text('Preserve header comments'),
                      subtitle: const Text(
                        'Useful when generated bindings should carry source docs.',
                      ),
                      onChanged: (bool value) {
                        setState(() => _includeComments = value);
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _CodeCard(
              title: 'Native Header',
              description:
                  'Keep exported C APIs in a header file and make sure symbols use C linkage when compiling with C++.',
              code: _headerCode,
            ),
            const SizedBox(height: 16),
            _CodeCard(
              title: 'ffigen Config',
              description:
                  'The YAML file controls header entry points, output location, symbol filters, and optional LLVM paths.',
              code: _configCode,
            ),
            const SizedBox(height: 16),
            _CodeCard(
              title: 'Generator Command',
              description:
                  'Regenerate bindings whenever the header changes so Dart stays aligned with the native API.',
              code: _generatorCommand,
            ),
            const SizedBox(height: 16),
            _CodeCard(
              title: 'Flutter FFI Usage',
              description:
                  'Load the native library, instantiate the generated bindings class, and call C APIs through typed Dart wrappers.',
              code: _dartUsageCode,
            ),
            const SizedBox(height: 16),
            _CodeCard(
              title: 'C Implementation',
              description:
                  'This is the native side that the generated bindings expect to find inside the shared library.',
              code: _cImplementationCode,
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'When To Use ffigen',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const _UsageBullet(
                      text:
                          'Use `ffigen` when you already have C or Objective-C headers and want generated Dart FFI bindings instead of hand-writing `lookupFunction` signatures.',
                    ),
                    const _UsageBullet(
                      text:
                          'It works best for stable native APIs where headers are the source of truth and regeneration can be part of your build workflow.',
                    ),
                    const _UsageBullet(
                      text:
                          'Prefer it over manual bindings when structs, enums, typedefs, or many function signatures would otherwise create repetitive FFI boilerplate.',
                    ),
                  ],
                ),
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
  }
}

class _CodeCard extends StatelessWidget {
  const _CodeCard({
    required this.title,
    required this.description,
    required this.code,
  });

  final String title;
  final String description;
  final String code;

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
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(description),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.45,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                code,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontFamily: 'monospace',
                  height: 1.45,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UsageBullet extends StatelessWidget {
  const _UsageBullet({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Icon(Icons.arrow_right, size: 18),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
