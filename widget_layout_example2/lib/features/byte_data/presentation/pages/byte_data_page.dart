import 'dart:convert';
import 'dart:typed_data';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:widget_layout_example2/core/config/router/app_navigation.dart';

@RoutePage(name: RouteName.byteData)
class ByteDataPage extends StatelessWidget {
  const ByteDataPage({super.key});

  static final _ByteDataDemo _scalarDemo = _buildScalarDemo();
  static final _ByteDataDemo _endianDemo = _buildEndianDemo();
  static final _ByteDataDemo _structDemo = _buildStructDemo();

  static _ByteDataDemo _buildScalarDemo() {
    final Uint8List labelBytes = utf8.encode('WidgetLayout');
    final ByteData writer = ByteData(1 + 2 + 1 + labelBytes.length);

    int offset = 0;
    writer.setUint8(offset, 1); // boolean as one byte
    offset += 1;
    writer.setUint16(offset, 2048); // big endian by default
    offset += 2;
    writer.setUint8(offset, labelBytes.length); // length prefix
    offset += 1;
    writer.buffer.asUint8List().setRange(
      offset,
      offset + labelBytes.length,
      labelBytes,
    );

    final Uint8List bytes = writer.buffer.asUint8List();

    final ByteData reader = ByteData.sublistView(bytes);
    int readOffset = 0;
    final bool isEnabled = reader.getUint8(readOffset) != 0;
    readOffset += 1;
    final int payloadSize = reader.getUint16(readOffset);
    readOffset += 2;
    final int labelLength = reader.getUint8(readOffset);
    readOffset += 1;
    final String label = utf8.decode(
      Uint8List.sublistView(bytes, readOffset, readOffset + labelLength),
    );

    return _ByteDataDemo(
      title: 'Write and read scalar values',
      description:
          'The same payload as the binarize scalar demo, but built directly '
          'on `ByteData`: every `set*` call needs an explicit byte offset, '
          'and reading back means replaying the offsets in the same order.',
      code: '''
final Uint8List labelBytes = utf8.encode('WidgetLayout');
final ByteData writer = ByteData(1 + 2 + 1 + labelBytes.length);

int offset = 0;
writer.setUint8(offset, 1);                 // boolean as one byte
offset += 1;
writer.setUint16(offset, 2048);             // big endian by default
offset += 2;
writer.setUint8(offset, labelBytes.length); // length prefix
offset += 1;
writer.buffer.asUint8List()
    .setRange(offset, offset + labelBytes.length, labelBytes);

final Uint8List bytes = writer.buffer.asUint8List();

final ByteData reader = ByteData.sublistView(bytes);
final bool isEnabled = reader.getUint8(0) != 0;
final int payloadSize = reader.getUint16(1);
final int labelLength = reader.getUint8(3);
final String label =
    utf8.decode(Uint8List.sublistView(bytes, 4, 4 + labelLength));
''',
      bytes: bytes,
      details: <String>[
        'getUint8(0) != 0 => $isEnabled',
        'getUint16(1) => $payloadSize',
        'utf8.decode(...) => $label',
      ],
    );
  }

  static _ByteDataDemo _buildEndianDemo() {
    final ByteData writer = ByteData(12);
    writer.setUint32(0, 0xDEADBEEF, Endian.big);
    writer.setUint32(4, 0xDEADBEEF, Endian.little);
    writer.setFloat32(8, 3.14159);

    final Uint8List bytes = writer.buffer.asUint8List();

    final ByteData reader = ByteData.sublistView(bytes);
    final int bigValue = reader.getUint32(0, Endian.big);
    final int littleValue = reader.getUint32(4, Endian.little);
    final int littleReadAsBig = reader.getUint32(4, Endian.big);
    final double pi = reader.getFloat32(8);

    return _ByteDataDemo(
      title: 'Endianness and floating point',
      description:
          'binarize hides byte order behind `PayloadType`s. With raw '
          '`ByteData` you pick an `Endian` per call, so the same 32-bit '
          'value produces mirrored byte patterns, and reading with the '
          'wrong endianness silently returns garbage.',
      code: '''
final ByteData writer = ByteData(12);
writer.setUint32(0, 0xDEADBEEF, Endian.big);
writer.setUint32(4, 0xDEADBEEF, Endian.little);
writer.setFloat32(8, 3.14159);

final ByteData reader = ByteData.sublistView(writer.buffer.asUint8List());
final int bigValue = reader.getUint32(0, Endian.big);
final int littleValue = reader.getUint32(4, Endian.little);
final int littleReadAsBig = reader.getUint32(4, Endian.big);
final double pi = reader.getFloat32(8);
''',
      bytes: bytes,
      details: <String>[
        'getUint32(0, Endian.big) => 0x${bigValue.toRadixString(16).toUpperCase()}',
        'getUint32(4, Endian.little) => 0x${littleValue.toRadixString(16).toUpperCase()}',
        'getUint32(4, Endian.big) => 0x${littleReadAsBig.toRadixString(16).toUpperCase()} (wrong endianness!)',
        'getFloat32(8) => $pi',
      ],
    );
  }

  static _ByteDataDemo _buildStructDemo() {
    const _PrintJob sample = _PrintJob(
      copies: 3,
      priority: 7,
      label: 'Invoice Batch',
    );

    final Uint8List bytes = _encodePrintJob(sample);
    final _PrintJob restored = _decodePrintJob(bytes);

    return _ByteDataDemo(
      title: 'Hand-rolled struct codec',
      description:
          'The `BinaryContract` demo rebuilt by hand: encode and decode '
          'functions that agree on a layout of uint16 copies, uint8 '
          'priority, and a length-prefixed UTF-8 label. This is exactly '
          'the offset bookkeeping binarize automates.',
      code: '''
Uint8List _encodePrintJob(_PrintJob job) {
  final Uint8List labelBytes = utf8.encode(job.label);
  final ByteData data = ByteData(2 + 1 + 1 + labelBytes.length);
  data.setUint16(0, job.copies);
  data.setUint8(2, job.priority);
  data.setUint8(3, labelBytes.length);
  final Uint8List bytes = data.buffer.asUint8List();
  bytes.setRange(4, 4 + labelBytes.length, labelBytes);
  return bytes;
}

_PrintJob _decodePrintJob(Uint8List bytes) {
  final ByteData data = ByteData.sublistView(bytes);
  final int labelLength = data.getUint8(3);
  return _PrintJob(
    copies: data.getUint16(0),
    priority: data.getUint8(2),
    label: utf8.decode(Uint8List.sublistView(bytes, 4, 4 + labelLength)),
  );
}
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
      appBar: AppBar(title: const Text('ByteData Module')),
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
                      'Build binary payloads with raw ByteData.',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '`ByteData` from `dart:typed_data` is the low-level '
                      'fixed-length byte buffer that packages like binarize '
                      'build on. You choose every offset and endianness '
                      'yourself with `setUint16`, `getFloat32`, and friends.',
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'This demo mirrors the binarize module page: the same '
                      'scalar, collection-ish, and struct payloads, rewritten '
                      'with manual offset tracking so you can compare both '
                      'approaches byte for byte.',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _DemoCard(demo: _scalarDemo),
            const SizedBox(height: 16),
            _DemoCard(demo: _endianDemo),
            const SizedBox(height: 16),
            _DemoCard(demo: _structDemo),
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

  final _ByteDataDemo demo;

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

class _ByteDataDemo {
  const _ByteDataDemo({
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

Uint8List _encodePrintJob(_PrintJob job) {
  final Uint8List labelBytes = utf8.encode(job.label);
  final ByteData data = ByteData(2 + 1 + 1 + labelBytes.length);
  data.setUint16(0, job.copies);
  data.setUint8(2, job.priority);
  data.setUint8(3, labelBytes.length);
  final Uint8List bytes = data.buffer.asUint8List();
  bytes.setRange(4, 4 + labelBytes.length, labelBytes);
  return bytes;
}

_PrintJob _decodePrintJob(Uint8List bytes) {
  final ByteData data = ByteData.sublistView(bytes);
  final int labelLength = data.getUint8(3);
  return _PrintJob(
    copies: data.getUint16(0),
    priority: data.getUint8(2),
    label: utf8.decode(Uint8List.sublistView(bytes, 4, 4 + labelLength)),
  );
}

String _formatBytes(Uint8List bytes) {
  return bytes
      .map((int byte) => byte.toRadixString(16).padLeft(2, '0').toUpperCase())
      .join(' ');
}
