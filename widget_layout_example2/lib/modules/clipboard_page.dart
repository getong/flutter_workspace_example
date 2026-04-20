import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ClipboardPage extends StatefulWidget {
  const ClipboardPage({super.key});

  @override
  State<ClipboardPage> createState() => _ClipboardPageState();
}

class _ClipboardPageState extends State<ClipboardPage> {
  final TextEditingController _copyController = TextEditingController(
    text: 'Flutter + clipboard package demo text',
  );
  final TextEditingController _richTextController = TextEditingController(
    text: 'Release note: tap to copy rich clipboard content.',
  );
  final TextEditingController _shareController = TextEditingController(
    text: 'INVITE-FLUTTER-2026',
  );

  Function()? _removeClipboardListener;

  String _statusMessage = 'Try one of the actions below.';
  String _pastedPlainText = 'Nothing pasted yet.';
  String _pastedRichText = 'No rich clipboard payload inspected yet.';
  String _clipboardType = 'unknown';
  int _clipboardSize = 0;
  bool _hasData = false;
  bool _isMonitoring = false;
  final List<String> _events = <String>[];

  @override
  void initState() {
    super.initState();
    _removeClipboardListener = FlutterClipboard.addListener(
      _onClipboardChanged,
    );
    unawaited(_refreshClipboardDiagnostics());
  }

  @override
  void dispose() {
    _removeClipboardListener?.call();
    if (_isMonitoring) {
      unawaited(FlutterClipboard.stopMonitoring());
    }
    _copyController.dispose();
    _richTextController.dispose();
    _shareController.dispose();
    super.dispose();
  }

  void _onClipboardChanged(EnhancedClipboardData data) {
    if (!mounted) {
      return;
    }

    final String summary;
    if (data.hasHtml) {
      summary = 'Clipboard changed: rich text updated.';
    } else if (data.hasText) {
      summary = 'Clipboard changed: ${data.text}';
    } else {
      summary = 'Clipboard cleared or unsupported content changed.';
    }

    setState(() {
      _events.insert(0, summary);
      if (_events.length > 6) {
        _events.removeLast();
      }
    });

    unawaited(_refreshClipboardDiagnostics());
  }

  Future<void> _runClipboardAction(
    String successMessage,
    Future<void> Function() action,
  ) async {
    try {
      await action();
      if (!mounted) {
        return;
      }

      setState(() {
        _statusMessage = successMessage;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(successMessage)));
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _statusMessage = 'Clipboard error: $error';
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Clipboard error: $error')));
    }
  }

  Future<void> _copyPlainText() async {
    await _runClipboardAction('Copied plain text to clipboard.', () async {
      await FlutterClipboard.copy(_copyController.text.trim());
      await _refreshClipboardDiagnostics();
    });
  }

  Future<void> _copyWithCallback() async {
    await _runClipboardAction(
      'Copied invite code with callback helpers.',
      () async {
        await FlutterClipboard.copyWithCallback(
          text: _shareController.text.trim(),
          onSuccess: () {
            if (!mounted) {
              return;
            }
            setState(() {
              _statusMessage = 'copyWithCallback reported success.';
            });
          },
          onError: (String error) {
            if (!mounted) {
              return;
            }
            setState(() {
              _statusMessage = 'copyWithCallback error: $error';
            });
          },
        );
        await _refreshClipboardDiagnostics();
      },
    );
  }

  Future<void> _copyRichText() async {
    await _runClipboardAction(
      'Copied plain text + HTML clipboard content.',
      () async {
        final String text = _richTextController.text.trim();
        await FlutterClipboard.copyRichText(
          text: text,
          html:
              '<h3>Flutter clipboard</h3>'
              '<p>$text</p>'
              '<ul><li>copyRichText</li><li>pasteRichText</li></ul>',
        );
        await _refreshClipboardDiagnostics();
      },
    );
  }

  Future<void> _copyMultipleFormats() async {
    await _runClipboardAction(
      'Copied text/plain and text/html formats together.',
      () async {
        final String promoCode = _shareController.text.trim();
        await FlutterClipboard.copyMultiple(<String, dynamic>{
          'text/plain': 'Promo code: $promoCode',
          'text/html':
              '<strong>Promo code:</strong> '
              '<code>$promoCode</code><br/>Shared from Flutter.',
        });
        await _refreshClipboardDiagnostics();
      },
    );
  }

  Future<void> _pastePlainText() async {
    await _runClipboardAction('Loaded plain text from clipboard.', () async {
      final String pastedText = await FlutterClipboard.paste();
      if (!mounted) {
        return;
      }

      setState(() {
        _pastedPlainText = pastedText.isEmpty
            ? 'Clipboard returned an empty string.'
            : pastedText;
      });
      await _refreshClipboardDiagnostics();
    });
  }

  Future<void> _pasteRichText() async {
    await _runClipboardAction('Loaded rich clipboard data.', () async {
      final EnhancedClipboardData data = await FlutterClipboard.pasteRichText();
      if (!mounted) {
        return;
      }

      setState(() {
        _pastedRichText =
            'text: ${data.text ?? '(none)'}\n'
            'html: ${data.html ?? '(none)'}\n'
            'hasImage: ${data.hasImage}\n'
            'hasFiles: ${data.hasFiles}';
      });
      await _refreshClipboardDiagnostics();
    });
  }

  Future<void> _clearClipboard() async {
    await _runClipboardAction('Cleared clipboard contents.', () async {
      await FlutterClipboard.clear();
      if (!mounted) {
        return;
      }

      setState(() {
        _pastedPlainText = 'Clipboard cleared.';
        _pastedRichText = 'Clipboard cleared.';
      });
      await _refreshClipboardDiagnostics();
    });
  }

  Future<void> _toggleMonitoring() async {
    await _runClipboardAction(
      _isMonitoring
          ? 'Stopped clipboard monitoring.'
          : 'Started clipboard monitoring.',
      () async {
        if (_isMonitoring) {
          await FlutterClipboard.stopMonitoring();
        } else {
          await FlutterClipboard.startMonitoring(
            interval: const Duration(seconds: 1),
          );
        }

        if (!mounted) {
          return;
        }

        setState(() {
          _isMonitoring = !_isMonitoring;
        });
      },
    );
  }

  Future<void> _refreshClipboardDiagnostics() async {
    final bool hasData = await FlutterClipboard.hasData();
    final ClipboardContentType contentType =
        await FlutterClipboard.getContentType();
    final int dataSize = await FlutterClipboard.getDataSize();

    if (!mounted) {
      return;
    }

    setState(() {
      _hasData = hasData;
      _clipboardType = contentType.name;
      _clipboardSize = dataSize;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('clipboard Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            Text(
              'Use `package:clipboard` when you want more than the basic Flutter clipboard helpers. This page covers copy, paste, rich text, multiple formats, and clipboard change monitoring.',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            _ClipboardCard(
              title: 'Clipboard Diagnostics',
              description:
                  'Refresh the derived clipboard state after running any action.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: <Widget>[
                      _StatChip(label: 'hasData', value: '$_hasData'),
                      _StatChip(label: 'contentType', value: _clipboardType),
                      _StatChip(label: 'dataSize', value: '$_clipboardSize'),
                      _StatChip(label: 'monitoring', value: '$_isMonitoring'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: <Widget>[
                      FilledButton(
                        onPressed: _refreshClipboardDiagnostics,
                        child: const Text('Refresh Diagnostics'),
                      ),
                      OutlinedButton(
                        onPressed: _toggleMonitoring,
                        child: Text(
                          _isMonitoring
                              ? 'Stop Monitoring'
                              : 'Start Monitoring',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Status: $_statusMessage',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _ClipboardCard(
              title: 'Example 1: Copy Plain Text',
              description:
                  'A standard copy workflow with a text field and explicit action button.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextField(
                    controller: _copyController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Text to copy',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: <Widget>[
                      FilledButton(
                        onPressed: _copyPlainText,
                        child: const Text('FlutterClipboard.copy'),
                      ),
                      OutlinedButton(
                        onPressed: _pastePlainText,
                        child: const Text('Paste Plain Text'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _ResultPanel(
                    title: 'Last plain-text paste result',
                    value: _pastedPlainText,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _ClipboardCard(
              title: 'Example 2: Copy With Callback',
              description:
                  'Useful when you want success and error hooks without duplicating clipboard status code in your widget.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextField(
                    controller: _shareController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Invite code or promo code',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: <Widget>[
                      FilledButton(
                        onPressed: _copyWithCallback,
                        child: const Text('Copy Invite Code'),
                      ),
                      OutlinedButton(
                        onPressed: _copyMultipleFormats,
                        child: const Text('Copy Multiple Formats'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _ClipboardCard(
              title: 'Example 3: Rich Text Clipboard',
              description:
                  'The package can write both plain text and HTML, then inspect them again with `pasteRichText()`.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextField(
                    controller: _richTextController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Rich text message',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: <Widget>[
                      FilledButton(
                        onPressed: _copyRichText,
                        child: const Text('Copy Rich Text'),
                      ),
                      OutlinedButton(
                        onPressed: _pasteRichText,
                        child: const Text('Paste Rich Text'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _ResultPanel(
                    title: 'Rich clipboard payload',
                    value: _pastedRichText,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _ClipboardCard(
              title: 'Example 4: Monitor Clipboard Changes',
              description:
                  'Monitoring lets your Flutter UI react when clipboard contents change outside this page.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (_events.isEmpty)
                    Text(
                      'No clipboard events captured yet. Start monitoring and copy or paste something.',
                      style: theme.textTheme.bodyMedium,
                    )
                  else
                    ..._events.map(
                      (String event) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Padding(
                              padding: EdgeInsets.only(top: 3),
                              child: Icon(Icons.fiber_manual_record, size: 10),
                            ),
                            const SizedBox(width: 8),
                            Expanded(child: Text(event)),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _ClipboardCard(
              title: 'Example 5: Housekeeping Actions',
              description:
                  'Clear the clipboard when a flow finishes, or refresh metadata after a paste-heavy workflow.',
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: <Widget>[
                  FilledButton.tonal(
                    onPressed: _clearClipboard,
                    child: const Text('Clear Clipboard'),
                  ),
                  OutlinedButton(
                    onPressed: _refreshClipboardDiagnostics,
                    child: const Text('Re-read Metadata'),
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
  }
}

class _ClipboardCard extends StatelessWidget {
  const _ClipboardCard({
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
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class _ResultPanel extends StatelessWidget {
  const _ResultPanel({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(title, style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            Text(value),
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text('$label: $value'),
      visualDensity: VisualDensity.compact,
    );
  }
}
