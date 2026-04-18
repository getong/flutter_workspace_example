import 'dart:math' as math;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage(name: 'CharactersRoute')
class CharactersPage extends StatefulWidget {
  const CharactersPage({super.key});

  @override
  State<CharactersPage> createState() => _CharactersPageState();
}

class _CharactersPageState extends State<CharactersPage> {
  final TextEditingController _controller = TextEditingController(
    text: '👨‍👩‍👧‍👦 Flutter 🇺🇸 café 👩🏽‍💻',
  );

  static const String _markup =
      '<hero>👩🏽‍💻 Build Unicode-safe previews 🇺🇸</hero>';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _unsafePreview(String input, int count) {
    return input.substring(0, math.min(count, input.length));
  }

  bool _isWellFormedUtf16(String value) {
    final List<int> codeUnits = value.codeUnits;
    for (int index = 0; index < codeUnits.length; index += 1) {
      final int unit = codeUnits[index];
      final bool isLeadingSurrogate = unit >= 0xD800 && unit <= 0xDBFF;
      final bool isTrailingSurrogate = unit >= 0xDC00 && unit <= 0xDFFF;

      if (isLeadingSurrogate) {
        if (index + 1 >= codeUnits.length) {
          return false;
        }
        final int next = codeUnits[index + 1];
        if (next < 0xDC00 || next > 0xDFFF) {
          return false;
        }
        index += 1;
        continue;
      }

      if (isTrailingSurrogate) {
        return false;
      }
    }
    return true;
  }

  String _describeUnsafePreview(String input, int count) {
    final String raw = _unsafePreview(input, count);
    if (_isWellFormedUtf16(raw)) {
      return raw;
    }

    final String hexUnits = raw.codeUnits
        .map((int unit) => '0x${unit.toRadixString(16).padLeft(4, '0')}')
        .join(' ');
    return 'Malformed UTF-16 code units: $hexUnits';
  }

  String _safePreview(String input, int count) {
    return input.characters.take(count).string;
  }

  String _extractFirstTag(String input) {
    final CharacterRange? range = input.characters.findFirst('<'.characters);
    if (range == null) {
      return 'No tag found';
    }
    final bool foundEnd = range.moveUntil('>'.characters);
    if (!foundEnd) {
      return 'Tag not closed';
    }
    return range.currentCharacters.string;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String input = _controller.text;
    final Characters characters = input.characters;
    final String safePreview = _safePreview(input, 10);
    final String unsafePreview = _describeUnsafePreview(input, 10);
    final String withoutLastVisible = input.characters.skipLast(1).string;
    final String replacedFlags = input.characters
        .replaceAll('🇺🇸'.characters, '🇯🇵'.characters)
        .string;

    return Scaffold(
      appBar: AppBar(title: const Text('characters Module')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: <Widget>[
          Text(
            'characters lets you work with user-perceived characters instead '
            'of raw UTF-16 code units, which matters for emoji, flags, skin '
            'tones, and accented text.',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'This page demonstrates `string.characters`, `take`, `skipLast`, '
            '`replaceAll`, `findFirst`, and `CharacterRange.moveUntil`.',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          Card(
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Interactive input',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Edit the sample text and compare Dart `String` behavior with grapheme-aware `Characters` behavior.',
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _controller,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Text with emoji or combining marks',
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: <Widget>[
                      FilledButton.icon(
                        onPressed: () {
                          setState(() {
                            _controller.text = _controller.text.characters
                                .skipLast(1)
                                .string;
                          });
                        },
                        icon: const Icon(Icons.backspace_outlined),
                        label: const Text('Remove Last Visible Character'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            _controller.text =
                                '👩🏽‍💻 Flutter 🇺🇸 café 👨‍👩‍👧‍👦';
                          });
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Reset Sample'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Length comparisons',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _DataRow(label: 'String.length', value: '${input.length}'),
                  _DataRow(
                    label: 'Runes length',
                    value: '${input.runes.length}',
                  ),
                  _DataRow(
                    label: 'characters.length',
                    value: '${characters.length}',
                  ),
                  _DataRow(
                    label: 'First 8 visible chars',
                    value: characters.take(8).string,
                  ),
                  _DataRow(
                    label: 'Last visible char',
                    value: characters.isEmpty ? '(empty)' : characters.last,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Safe vs unsafe truncation',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Plain `substring` can cut through a grapheme cluster. `Characters.take` keeps the visible symbols intact.',
                  ),
                  const SizedBox(height: 16),
                  _PreviewPanel(
                    title: 'substring(0, 10)',
                    value: unsafePreview,
                    color: const Color(0xFFDC2626),
                  ),
                  const SizedBox(height: 12),
                  _PreviewPanel(
                    title: 'characters.take(10)',
                    value: safePreview,
                    color: const Color(0xFF0F766E),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Common transformations',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _DataRow(label: 'skipLast(1)', value: withoutLastVisible),
                  _DataRow(label: 'replaceAll flags', value: replacedFlags),
                  _DataRow(
                    label: 'Extract first tag',
                    value: _extractFirstTag(_markup),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.router.replacePath('/'),
        icon: const Icon(Icons.home),
        label: const Text('Home'),
      ),
    );
  }
}

class _DataRow extends StatelessWidget {
  const _DataRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 160,
            child: Text(
              label,
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

class _PreviewPanel extends StatelessWidget {
  const _PreviewPanel({
    required this.title,
    required this.value,
    required this.color,
  });

  final String title;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w800, color: color),
          ),
          const SizedBox(height: 8),
          Text(value),
        ],
      ),
    );
  }
}
