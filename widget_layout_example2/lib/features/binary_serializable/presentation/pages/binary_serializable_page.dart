import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:binary_serializable/binary_serializable.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';

@RoutePage(name: RouteName.binarySerializable)
class BinarySerializablePage extends StatefulWidget {
  const BinarySerializablePage({super.key});

  @override
  State<BinarySerializablePage> createState() => _BinarySerializablePageState();
}

class _BinarySerializablePageState extends State<BinarySerializablePage> {
  static const BoolType _boolType = BoolType();
  static const BufferType _magicType = BufferType(4);
  static const LengthPrefixedListType<String> _tagListType =
      LengthPrefixedListType<String>(uint8, utf8String);
  static const _TelemetryPacketType _telemetryPacketType =
      _TelemetryPacketType();
  static const _WireMessageType _wireMessageType = _WireMessageType();

  late final List<_PrimitiveExample> _primitiveExamples;
  late final _ListExample _listExample;
  late final _ChunkedPacketExample _chunkedPacketExample;
  late final _BufferExample _bufferExample;
  late final List<_MessageExample> _messageExamples;
  late final Future<_StreamExample> _streamExampleFuture;

  static const String _generatorSnippet = '''
@BinarySerializable()
class Example {
  @uint64
  final int id;

  @utf8String
  final String name;

  @LengthPrefixedListType(uint8, utf8String)
  final List<String> tags;

  Example(this.id, this.name, this.tags);
}
''';

  @override
  void initState() {
    super.initState();
    _primitiveExamples = _buildPrimitiveExamples();
    _listExample = _buildListExample();
    _chunkedPacketExample = _buildChunkedPacketExample();
    _bufferExample = _buildBufferExample();
    _messageExamples = _buildMessageExamples();
    _streamExampleFuture = _buildStreamExample();
  }

  List<_PrimitiveExample> _buildPrimitiveExamples() {
    return <_PrimitiveExample>[
      _PrimitiveExample(
        title: 'uint16',
        snippet:
            'final bytes = uint16.encode(513);\nfinal value = uint16.decode(bytes);',
        bytes: uint16.encode(513),
        decodedValue: uint16.decode(uint16.encode(513)).toString(),
      ),
      _PrimitiveExample(
        title: 'float32',
        snippet:
            'final bytes = float32.encode(23.75);\nfinal value = float32.decode(bytes);',
        bytes: float32.encode(23.75),
        decodedValue: float32.decode(float32.encode(23.75)).toStringAsFixed(2),
      ),
      _PrimitiveExample(
        title: 'BoolType',
        snippet:
            'const flagType = BoolType();\nfinal value = flagType.decode(flagType.encode(true));',
        bytes: _boolType.encode(true),
        decodedValue: _boolType.decode(_boolType.encode(true)).toString(),
      ),
      _PrimitiveExample(
        title: 'utf8String',
        snippet:
            "final bytes = utf8String.encode('sensor-A');\nfinal value = utf8String.decode(bytes);",
        bytes: utf8String.encode('sensor-A'),
        decodedValue: utf8String.decode(utf8String.encode('sensor-A')),
      ),
    ];
  }

  _ListExample _buildListExample() {
    const List<String> tags = <String>['alpha', 'stable', 'stream'];
    final Uint8List bytes = _tagListType.encode(tags);
    final List<String> decoded = _tagListType.decode(bytes);
    return _ListExample(tags: tags, bytes: bytes, decodedTags: decoded);
  }

  _ChunkedPacketExample _buildChunkedPacketExample() {
    const _TelemetryPacket packet = _TelemetryPacket(
      version: 2,
      acknowledged: true,
      temperature: 24.5,
      label: 'kitchen-probe',
      readings: <int>[120, 121, 119],
    );
    final Uint8List bytes = _telemetryPacketType.encode(packet);
    final List<Uint8List> chunks = _splitBytes(bytes, <int>[1, 2, 3, 4, 2]);
    final List<_TelemetryPacket> decodedPackets = <_TelemetryPacket>[];
    final BinaryConversion<_TelemetryPacket> conversion = _telemetryPacketType
        .startConversion(decodedPackets.add);

    for (final Uint8List chunk in chunks) {
      conversion.addAll(chunk);
    }
    conversion.flush();

    return _ChunkedPacketExample(
      packet: packet,
      bytes: bytes,
      chunks: chunks,
      decodedPackets: decodedPackets,
    );
  }

  _BufferExample _buildBufferExample() {
    final Uint8List magic = Uint8List.fromList(<int>[0x42, 0x53, 0x45, 0x01]);
    final List<Uint8List> chunks = _splitBytes(magic, <int>[1, 1, 2]);
    final List<Uint8List> decodedValues = <Uint8List>[];
    final BinaryConversion<Uint8List> conversion = _magicType.startConversion(
      decodedValues.add,
    );

    for (final Uint8List chunk in chunks) {
      conversion.addAll(chunk);
    }
    conversion.flush();

    return _BufferExample(
      magic: magic,
      chunks: chunks,
      decodedMagic: decodedValues.single,
    );
  }

  Future<_StreamExample> _buildStreamExample() async {
    final Uint8List bytes = utf8String.encode('stream decoded message');
    final List<Uint8List> chunks = _splitBytes(bytes, <int>[3, 4, 5, 2]);
    final String decoded = await utf8String.decodeStream(
      Stream<List<int>>.fromIterable(
        chunks.map((Uint8List chunk) => chunk.toList()),
      ),
    );
    return _StreamExample(bytes: bytes, chunks: chunks, decoded: decoded);
  }

  List<_MessageExample> _buildMessageExamples() {
    final List<_WireMessage> messages = <_WireMessage>[
      const _PingMessage(sequence: 7),
      const _TextMessage(text: 'hello binary_serializable'),
    ];
    return messages.map((_WireMessage message) {
      final Uint8List bytes = _wireMessageType.encode(message);
      final _WireMessage decoded = _wireMessageType.decode(bytes);
      return _MessageExample(message: message, bytes: bytes, decoded: decoded);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('binary_serializable Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            Text(
              'binary_serializable in Flutter',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'This page mirrors the existing module style in this app, but the '
              'examples come from the `binary_serializable` package API. It '
              'shows primitive codecs, length-prefixed collections, chunked '
              'decoding, stream decoding, subtype dispatch, and a generated '
              'model pattern similar to the reference project.',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            _SectionCard(
              title: 'Generator-Friendly Model',
              description:
                  'The referenced project uses `@BinarySerializable()` with '
                  'generated `BinaryType` classes. This is the same modeling '
                  'shape shown in the example package.',
              snippet: _generatorSnippet,
              child: Text(
                'Use the generator when you want declarative model definitions. '
                'The runtime sections below focus on the lower-level APIs that '
                'also work without code generation.',
                style: theme.textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Primitive BinaryType Usage',
              description:
                  'Every built-in type acts like a codec: encode bytes, decode '
                  'bytes, or plug the type into more complex conversions.',
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: _primitiveExamples
                    .map(
                      (_PrimitiveExample example) => _ExampleTile(
                        title: example.title,
                        subtitle: 'Decoded value: ${example.decodedValue}',
                        snippet: example.snippet,
                        child: _ByteWrap(bytes: example.bytes),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'LengthPrefixedListType',
              description:
                  'Lists are encoded as a length prefix followed by each '
                  'element payload. This is useful for tags, packets, and '
                  'small collections inside a binary protocol.',
              snippet: '''
const tagType = LengthPrefixedListType<String>(uint8, utf8String);
final bytes = tagType.encode(['alpha', 'stable', 'stream']);
final tags = tagType.decode(bytes);
''',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Input tags: ${_listExample.tags.join(', ')}'),
                  const SizedBox(height: 12),
                  _ByteWrap(bytes: _listExample.bytes),
                  const SizedBox(height: 12),
                  Text('Decoded tags: ${_listExample.decodedTags.join(', ')}'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'CompositeBinaryConversion',
              description:
                  'A custom packet can be assembled from multiple smaller '
                  '`BinaryType`s. The same type can decode correctly even when '
                  'the byte stream arrives in partial chunks.',
              snippet: '''
final conversion = _TelemetryPacketType().startConversion(print);
for (final chunk in chunks) {
  conversion.addAll(chunk);
}
conversion.flush();
''',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _SummaryBanner(
                    color: colorScheme.primary,
                    label: 'Encoded packet',
                    value: _chunkedPacketExample.packet.describe(),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Raw bytes',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _ByteWrap(bytes: _chunkedPacketExample.bytes),
                  const SizedBox(height: 12),
                  Text(
                    'Incoming chunks',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _chunkedPacketExample.chunks
                        .map(
                          (Uint8List chunk) =>
                              Chip(label: Text(_formatBytes(chunk))),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 12),
                  _SummaryBanner(
                    color: colorScheme.tertiary,
                    label: 'Decoded packet',
                    value: _chunkedPacketExample.decodedPackets.single
                        .describe(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'BufferType For Fixed Headers',
              description:
                  'Use `BufferType(length)` when you need an exact number of '
                  'bytes, such as magic headers, signatures, or compact binary '
                  'frames.',
              snippet: '''
const magicType = BufferType(4);
final header = magicType.decode(Uint8List.fromList([0x42, 0x53, 0x45, 0x01]));
''',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _SummaryBanner(
                    color: colorScheme.secondary,
                    label: 'Header bytes',
                    value: _formatBytes(_bufferExample.magic),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _bufferExample.chunks
                        .map(
                          (Uint8List chunk) =>
                              Chip(label: Text(_formatBytes(chunk))),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Decoded header: ${_formatBytes(_bufferExample.decodedMagic)}',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'decodeStream',
              description:
                  'A `BinaryType` can decode from `Stream<List<int>>`, which '
                  'is useful for sockets, files, and framed transport layers.',
              snippet: '''
final value = await utf8String.decodeStream(
  Stream<List<int>>.fromIterable(chunks),
);
''',
              child: FutureBuilder<_StreamExample>(
                future: _streamExampleFuture,
                builder:
                    (
                      BuildContext context,
                      AsyncSnapshot<_StreamExample> snapshot,
                    ) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      if (snapshot.hasError) {
                        return Text(
                          'Stream decoding failed: ${snapshot.error}',
                        );
                      }

                      final _StreamExample example = snapshot.requireData;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _ByteWrap(bytes: example.bytes),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: example.chunks
                                .map(
                                  (Uint8List chunk) =>
                                      Chip(label: Text(_formatBytes(chunk))),
                                )
                                .toList(),
                          ),
                          const SizedBox(height: 12),
                          Text('Decoded string: ${example.decoded}'),
                        ],
                      );
                    },
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'MultiBinaryType Dispatch',
              description:
                  'A protocol can examine a shared header byte and then route '
                  'decoding to the correct subtype automatically.',
              snippet: '''
const messageType = _WireMessageType();
final bytes = messageType.encode(const _TextMessage(text: 'hello'));
final message = messageType.decode(bytes);
''',
              child: Column(
                children: _messageExamples
                    .map(
                      (_MessageExample example) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _MessageCard(example: example),
                      ),
                    )
                    .toList(),
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

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.description,
    required this.child,
    this.snippet,
  });

  final String title;
  final String description;
  final Widget child;
  final String? snippet;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(description),
            if (snippet != null) ...<Widget>[
              const SizedBox(height: 16),
              _CodeBlock(text: snippet!),
            ],
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class _ExampleTile extends StatelessWidget {
  const _ExampleTile({
    required this.title,
    required this.subtitle,
    required this.snippet,
    required this.child,
  });

  final String title;
  final String subtitle;
  final String snippet;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      width: 290,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(subtitle),
          const SizedBox(height: 12),
          _CodeBlock(text: snippet),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _CodeBlock extends StatelessWidget {
  const _CodeBlock({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text.trim(),
        style: theme.textTheme.bodyMedium?.copyWith(fontFamily: 'monospace'),
      ),
    );
  }
}

class _ByteWrap extends StatelessWidget {
  const _ByteWrap({required this.bytes});

  final Uint8List bytes;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: bytes
          .map(
            (int value) => Chip(
              visualDensity: VisualDensity.compact,
              label: Text(
                '0x${value.toRadixString(16).padLeft(2, '0').toUpperCase()}',
              ),
            ),
          )
          .toList(),
    );
  }
}

class _SummaryBanner extends StatelessWidget {
  const _SummaryBanner({
    required this.color,
    required this.label,
    required this.value,
  });

  final Color color;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.bodyMedium,
          children: <InlineSpan>[
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}

class _MessageCard extends StatelessWidget {
  const _MessageCard({required this.example});

  final _MessageExample example;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.35,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            example.message.runtimeLabel,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text('Encoded bytes: ${_formatBytes(example.bytes)}'),
          const SizedBox(height: 8),
          Text('Decoded object: ${example.decoded.describe()}'),
        ],
      ),
    );
  }
}

class _PrimitiveExample {
  const _PrimitiveExample({
    required this.title,
    required this.snippet,
    required this.bytes,
    required this.decodedValue,
  });

  final String title;
  final String snippet;
  final Uint8List bytes;
  final String decodedValue;
}

class _ListExample {
  const _ListExample({
    required this.tags,
    required this.bytes,
    required this.decodedTags,
  });

  final List<String> tags;
  final Uint8List bytes;
  final List<String> decodedTags;
}

class _ChunkedPacketExample {
  const _ChunkedPacketExample({
    required this.packet,
    required this.bytes,
    required this.chunks,
    required this.decodedPackets,
  });

  final _TelemetryPacket packet;
  final Uint8List bytes;
  final List<Uint8List> chunks;
  final List<_TelemetryPacket> decodedPackets;
}

class _BufferExample {
  const _BufferExample({
    required this.magic,
    required this.chunks,
    required this.decodedMagic,
  });

  final Uint8List magic;
  final List<Uint8List> chunks;
  final Uint8List decodedMagic;
}

class _StreamExample {
  const _StreamExample({
    required this.bytes,
    required this.chunks,
    required this.decoded,
  });

  final Uint8List bytes;
  final List<Uint8List> chunks;
  final String decoded;
}

class _MessageExample {
  const _MessageExample({
    required this.message,
    required this.bytes,
    required this.decoded,
  });

  final _WireMessage message;
  final Uint8List bytes;
  final _WireMessage decoded;
}

class _TelemetryPacket {
  const _TelemetryPacket({
    required this.version,
    required this.acknowledged,
    required this.temperature,
    required this.label,
    required this.readings,
  });

  final int version;
  final bool acknowledged;
  final double temperature;
  final String label;
  final List<int> readings;

  String describe() {
    return 'version=$version, acknowledged=$acknowledged, '
        'temperature=${temperature.toStringAsFixed(1)}, label=$label, '
        'readings=${readings.join('/')}';
  }
}

class _TelemetryPacketType extends BinaryType<_TelemetryPacket> {
  const _TelemetryPacketType();

  static const BoolType _boolType = BoolType();
  static const LengthPrefixedListType<int> _readingListType =
      LengthPrefixedListType<int>(uint8, uint16);

  @override
  void encodeInto(_TelemetryPacket input, BytesBuilder builder) {
    uint8.encodeInto(input.version, builder);
    _boolType.encodeInto(input.acknowledged, builder);
    float32.encodeInto(input.temperature, builder);
    utf8String.encodeInto(input.label, builder);
    _readingListType.encodeInto(input.readings, builder);
  }

  @override
  BinaryConversion<_TelemetryPacket> startConversion(
    void Function(_TelemetryPacket) onValue,
  ) {
    return _TelemetryPacketConversion(onValue);
  }
}

class _TelemetryPacketConversion
    extends CompositeBinaryConversion<_TelemetryPacket> {
  _TelemetryPacketConversion(super.onValue);

  static const BoolType _boolType = BoolType();
  static const LengthPrefixedListType<int> _readingListType =
      LengthPrefixedListType<int>(uint8, uint16);

  @override
  BinaryConversion startConversion() {
    return uint8.startConversion((int version) {
      currentConversion = _boolType.startConversion((bool acknowledged) {
        currentConversion = float32.startConversion((double temperature) {
          currentConversion = utf8String.startConversion((String label) {
            currentConversion = _readingListType.startConversion((
              List<int> readings,
            ) {
              onValue(
                _TelemetryPacket(
                  version: version,
                  acknowledged: acknowledged,
                  temperature: temperature,
                  label: label,
                  readings: readings,
                ),
              );
            });
          });
        });
      });
    });
  }
}

abstract class _WireMessage {
  const _WireMessage();

  int get id;

  String get runtimeLabel;

  String describe();
}

class _PingMessage extends _WireMessage {
  const _PingMessage({required this.sequence});

  final int sequence;

  @override
  int get id => 1;

  @override
  String get runtimeLabel => 'Ping Message';

  @override
  String describe() => 'id=$id, sequence=$sequence';
}

class _TextMessage extends _WireMessage {
  const _TextMessage({required this.text});

  final String text;

  @override
  int get id => 2;

  @override
  String get runtimeLabel => 'Text Message';

  @override
  String describe() => 'id=$id, text="$text"';
}

class _PingMessageType extends BinaryType<_WireMessage> {
  const _PingMessageType();

  @override
  void encodeInto(_WireMessage input, BytesBuilder builder) {
    final _PingMessage message = input as _PingMessage;
    uint8.encodeInto(message.id, builder);
    uint16.encodeInto(message.sequence, builder);
  }

  @override
  BinaryConversion<_WireMessage> startConversion(
    void Function(_WireMessage) onValue,
  ) {
    return _PingMessageConversion(onValue);
  }
}

class _PingMessageConversion extends CompositeBinaryConversion<_WireMessage> {
  _PingMessageConversion(super.onValue);

  @override
  BinaryConversion startConversion() {
    return uint8.startConversion((int id) {
      currentConversion = uint16.startConversion((int sequence) {
        if (id != 1) {
          throw FormatException('Unexpected ping message prelude: $id');
        }
        onValue(_PingMessage(sequence: sequence));
      });
    });
  }
}

class _TextMessageType extends BinaryType<_WireMessage> {
  const _TextMessageType();

  @override
  void encodeInto(_WireMessage input, BytesBuilder builder) {
    final _TextMessage message = input as _TextMessage;
    uint8.encodeInto(message.id, builder);
    utf8String.encodeInto(message.text, builder);
  }

  @override
  BinaryConversion<_WireMessage> startConversion(
    void Function(_WireMessage) onValue,
  ) {
    return _TextMessageConversion(onValue);
  }
}

class _TextMessageConversion extends CompositeBinaryConversion<_WireMessage> {
  _TextMessageConversion(super.onValue);

  @override
  BinaryConversion startConversion() {
    return uint8.startConversion((int id) {
      currentConversion = utf8String.startConversion((String text) {
        if (id != 2) {
          throw FormatException('Unexpected text message prelude: $id');
        }
        onValue(_TextMessage(text: text));
      });
    });
  }
}

class _WireMessageType extends MultiBinaryType<_WireMessage, int> {
  const _WireMessageType()
    : super(
        subtypes: const <int, BinaryType<_WireMessage>>{
          1: _PingMessageType(),
          2: _TextMessageType(),
        },
      );

  @override
  int extractPrelude(_WireMessage instance) => instance.id;

  @override
  BinaryConversion<int> startPreludeConversion(void Function(int) onValue) {
    return uint8.startConversion(onValue);
  }
}

List<Uint8List> _splitBytes(Uint8List bytes, List<int> chunkSizes) {
  final List<Uint8List> chunks = <Uint8List>[];
  int offset = 0;

  for (final int size in chunkSizes) {
    if (offset >= bytes.length) {
      break;
    }

    final int end = (offset + size).clamp(0, bytes.length);
    chunks.add(Uint8List.sublistView(bytes, offset, end));
    offset = end;
  }

  if (offset < bytes.length) {
    chunks.add(Uint8List.sublistView(bytes, offset));
  }

  return chunks;
}

String _formatBytes(List<int> bytes) {
  return bytes
      .map(
        (int byte) =>
            '0x${byte.toRadixString(16).padLeft(2, '0').toUpperCase()}',
      )
      .join(' ');
}
