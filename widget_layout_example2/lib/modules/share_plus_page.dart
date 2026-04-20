import 'dart:convert';
import 'dart:typed_data';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

@RoutePage(name: 'SharePlusRoute')
class SharePlusPage extends StatefulWidget {
  const SharePlusPage({super.key});

  @override
  State<SharePlusPage> createState() => _SharePlusPageState();
}

class _SharePlusPageState extends State<SharePlusPage> {
  final TextEditingController _messageController = TextEditingController(
    text:
        'Widget demos now include built_value, package_info_plus, share_plus, and infinite_scroll_pagination.',
  );

  String _status =
      'Trigger a share flow and inspect the returned ShareResult status.';

  ShareResult? _lastResult;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _runShare(Future<ShareResult> Function() action) async {
    try {
      final ShareResult result = await action();

      if (!mounted) {
        return;
      }

      setState(() {
        _lastResult = result;
        _status = 'Share completed with status: ${result.status.name}.';
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _status = 'Share failed: $error';
      });
    }
  }

  Future<void> _shareText() {
    return _runShare(() {
      return SharePlus.instance.share(
        ShareParams(
          title: 'Module Demo',
          subject: 'share_plus text payload',
          text: _messageController.text,
        ),
      );
    });
  }

  Future<void> _shareUri() {
    return _runShare(() {
      return SharePlus.instance.share(
        ShareParams(
          title: 'Package Link',
          uri: Uri.parse('https://pub.dev/packages/share_plus'),
        ),
      );
    });
  }

  Future<void> _shareGeneratedFile() {
    final String content = jsonEncode(<String, Object?>{
      'module': 'share_plus',
      'message': _messageController.text,
      'generatedAt': DateTime.now().toUtc().toIso8601String(),
    });

    final Uint8List bytes = Uint8List.fromList(utf8.encode(content));

    return _runShare(() {
      return SharePlus.instance.share(
        ShareParams(
          title: 'Generated File',
          text: 'Sharing a generated JSON file alongside a text caption.',
          files: <XFile>[
            XFile.fromData(
              bytes,
              mimeType: 'application/json',
              name: 'module-share.json',
            ),
          ],
          fileNameOverrides: const <String>['module-share.json'],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('share_plus Module')),
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
                      'share_plus opens the native share sheet for text, links, and files.',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'This module demonstrates `SharePlus.instance.share`, `ShareParams`, URI sharing, file sharing with `XFile.fromData`, and reading `ShareResult` back into the UI.',
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 12),
                    Text(_status),
                    if (_lastResult != null) ...<Widget>[
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: <Widget>[
                          Chip(
                            label: Text('status: ${_lastResult!.status.name}'),
                          ),
                          Chip(label: Text('raw: ${_lastResult!.raw}')),
                        ],
                      ),
                    ],
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
                      'Share Message',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _messageController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Text payload',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: <Widget>[
                        FilledButton.icon(
                          onPressed: _shareText,
                          icon: const Icon(Icons.text_fields),
                          label: const Text('Share Text'),
                        ),
                        FilledButton.icon(
                          onPressed: _shareUri,
                          icon: const Icon(Icons.link),
                          label: const Text('Share URI'),
                        ),
                        OutlinedButton.icon(
                          onPressed: _shareGeneratedFile,
                          icon: const Icon(Icons.attach_file),
                          label: const Text('Share Generated File'),
                        ),
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
                      'Typical Usage',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        '''final ShareResult result = await SharePlus.instance.share(
  ShareParams(
    text: 'Hello from Flutter',
    files: <XFile>[file],
  ),
);

print(result.status);''',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          color: Colors.white,
                          height: 1.5,
                        ),
                      ),
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
