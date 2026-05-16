import 'package:auto_route/auto_route.dart';
import 'package:binarize/binarize.dart';
import 'package:flutter/material.dart';

import 'package:widget_layout_example2/core/config/router/app_navigation.dart';

@RoutePage(name: RouteName.binarize)
class BinarizePage extends StatelessWidget {
  const BinarizePage({super.key});

  static final _BinarizeDemo _scalarDemo = _buildScalarDemo();
  static final _BinarizeDemo _collectionDemo = _buildCollectionDemo();
  static final _BinarizeDemo _contractDemo = _buildContractDemo();

  static _BinarizeDemo _buildScalarDemo() {
    final writer = Payload.write()
      ..set(boolean, true)
      ..set(uint16, 2048)
      ..set(string.utf8(), 'WidgetLayout');

    final Uint8List bytes = binarize(writer);
    final reader = Payload.read(bytes);

    final bool isEnabled = reader.get(boolean);
    final int payloadSize = reader.get(uint16);
    final String label = reader.get(string.utf8());

    return _BinarizeDemo(
      title: 'Write and read scalar values',
      description:
          'Start with `Payload.write()`, push values in order, and then read '
          'them back with the same `PayloadType` order.',
      code: '''
final writer = Payload.write()
  ..set(boolean, true)
  ..set(uint16, 2048)
  ..set(string.utf8(), 'WidgetLayout');

final Uint8List bytes = binarize(writer);

final reader = Payload.read(bytes);
final bool isEnabled = reader.get(boolean);
final int payloadSize = reader.get(uint16);
final String label = reader.get(string.utf8());
''',
      bytes: bytes,
      details: <String>[
        'boolean => $isEnabled',
        'uint16 => $payloadSize',
        'string.utf8() => $label',
      ],
    );
  }

  static _BinarizeDemo _buildCollectionDemo() {
    final writer = Payload.write()
      ..set(flags, <bool>[true, false, true, true, false, false, true, false])
      ..set(list(uint8), <int>[4, 8, 15, 16, 23, 42])
      ..set(map(string.utf8(), uint8), <String, int>{'A': 1, 'B': 2, 'C': 3});

    final Uint8List bytes = binarize(writer);
    final reader = Payload.read(bytes);

    final List<bool> flagBits = reader.get(flags);
    final List<int> numbers = reader.get(list(uint8));
    final Map<String, int> scoreMap = reader.get(map(string.utf8(), uint8));

    return _BinarizeDemo(
      title: 'Lists, maps, and bit flags',
      description:
          'Binarize can serialize structured collections without manual byte '
          'offset tracking.',
      code: '''
final writer = Payload.write()
  ..set(flags, <bool>[true, false, true, true, false, false, true, false])
  ..set(list(uint8), <int>[4, 8, 15, 16, 23, 42])
  ..set(map(string.utf8(), uint8), <String, int>{'A': 1, 'B': 2, 'C': 3});

final Uint8List bytes = binarize(writer);

final reader = Payload.read(bytes);
final List<bool> flagBits = reader.get(flags);
final List<int> numbers = reader.get(list(uint8));
final Map<String, int> scoreMap = reader.get(map(string.utf8(), uint8));
''',
      bytes: bytes,
      details: <String>[
        'flags => ${flagBits.join(', ')}',
        'list(uint8) => ${numbers.join(', ')}',
        'map(string.utf8(), uint8) => $scoreMap',
      ],
    );
  }

  static _BinarizeDemo _buildContractDemo() {
    const _PrintJob sample = _PrintJob(
      copies: 3,
      priority: 7,
      label: 'Invoice Batch',
    );

    final writer = Payload.write()..set(_printJobContract, sample);
    final Uint8List bytes = binarize(writer);
    final reader = Payload.read(bytes);
    final _PrintJob restored = reader.get(_printJobContract);

    return _BinarizeDemo(
      title: 'Custom BinaryContract',
      description:
          'When you have your own model type, define a `BinaryContract` so the '
          'package can serialize and deserialize the object directly.',
      code: '''
class _PrintJobContract extends BinaryContract<_PrintJob> implements _PrintJob {
  const _PrintJobContract()
    : super(const _PrintJob(copies: 1, priority: 0, label: 'draft'));

  @override
  _PrintJob order(_PrintJob format) => _PrintJob(
    copies: format.copies,
    priority: format.priority,
    label: format.label,
  );

  @override
  int get copies => type(uint16, (o) => o.copies);

  @override
  int get priority => type(uint8, (o) => o.priority);

  @override
  String get label => type(string.utf8(), (o) => o.label);
}

final writer = Payload.write()
  ..set(_printJobContract, sample);

final Uint8List bytes = binarize(writer);
final _PrintJob restored = Payload.read(bytes).get(_printJobContract);
''',
      bytes: bytes,
      details: <String>[
        'copies => ${restored.copies}',
        'priority => ${restored.priority}',
        'label => ${restored.label}',
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('binarize Module')),
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
                      'Build binary payloads with typed readers and writers.',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'The `binarize` package wraps `ByteData` into a higher '
                      'level payload system so you can write values, convert '
                      'them to bytes, and read them back without managing '
                      'offsets by hand.',
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'This demo mirrors the package README and example: '
                      '`Payload.write`, `binarize`, `Payload.read`, typed '
                      'collections, and a custom `BinaryContract`.',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _DemoCard(demo: _scalarDemo),
            const SizedBox(height: 16),
            _DemoCard(demo: _collectionDemo),
            const SizedBox(height: 16),
            _DemoCard(demo: _contractDemo),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.router.replacePath(AppRoute.home.path),
        icon: const Icon(Icons.home),
        label: const Text('Home'),
      ),
    );
  }
}

class _DemoCard extends StatelessWidget {
  const _DemoCard({required this.demo});

  final _BinarizeDemo demo;

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
              demo.title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(demo.description),
            const SizedBox(height: 16),
            Text(
              'Code',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            DecoratedBox(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: SelectableText(
                  demo.code.trim(),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontFamily: 'monospace',
                    height: 1.4,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Result',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            ...demo.details.map(
              (String line) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(line),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Byte length: ${demo.bytes.length}',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            DecoratedBox(
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(
                  alpha: 0.4,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: SelectableText(
                  _formatBytes(demo.bytes),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontFamily: 'monospace',
                    height: 1.4,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BinarizeDemo {
  const _BinarizeDemo({
    required this.title,
    required this.description,
    required this.code,
    required this.bytes,
    required this.details,
  });

  final String title;
  final String description;
  final String code;
  final Uint8List bytes;
  final List<String> details;
}

class _PrintJob {
  const _PrintJob({
    required this.copies,
    required this.priority,
    required this.label,
  });

  final int copies;
  final int priority;
  final String label;
}

class _PrintJobContract extends BinaryContract<_PrintJob> implements _PrintJob {
  const _PrintJobContract()
    : super(const _PrintJob(copies: 1, priority: 0, label: 'draft'));

  @override
  _PrintJob order(_PrintJob format) => _PrintJob(
    copies: format.copies,
    priority: format.priority,
    label: format.label,
  );

  @override
  int get copies => type(uint16, (o) => o.copies);

  @override
  int get priority => type(uint8, (o) => o.priority);

  @override
  String get label => type(string.utf8(), (o) => o.label);
}

const _PrintJobContract _printJobContract = _PrintJobContract();

String _formatBytes(Uint8List bytes) {
  return bytes
      .map((int byte) => byte.toRadixString(16).padLeft(2, '0').toUpperCase())
      .join(' ');
}
