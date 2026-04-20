import 'dart:convert';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

@RoutePage()
class OpenFilePage extends StatefulWidget {
  const OpenFilePage({super.key});

  @override
  State<OpenFilePage> createState() => _OpenFilePageState();
}

class _OpenFilePageState extends State<OpenFilePage> {
  bool _isPreparing = false;
  bool _isIOSAppOpen = false;
  String _status =
      'Prepare sample files, then use open_file to inspect open results.';
  String? _workspacePath;
  String? _notesPath;
  String? _jsonPath;
  OpenResult? _lastResult;
  final List<String> _eventLog = <String>[];

  void _addLog(String message) {
    final DateTime now = DateTime.now();
    final String stamp =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
    setState(() {
      _eventLog.insert(0, '$stamp  $message');
      if (_eventLog.length > 12) {
        _eventLog.removeRange(12, _eventLog.length);
      }
    });
  }

  Future<void> _prepareSamples() async {
    setState(() {
      _isPreparing = true;
      _status = 'Writing sample files into a temporary folder.';
    });

    try {
      final Directory directory = await Directory.systemTemp.createTemp(
        'open-file-module-',
      );
      final File notesFile = File('${directory.path}/release_notes.txt');
      final File jsonFile = File('${directory.path}/catalog.json');

      await notesFile.writeAsString(
        'OpenFile module demo\n'
        '\n'
        '- This sample file lives in a temp directory.\n'
        '- The plugin opens real filesystem paths.\n'
        '- ResultType and message are captured below.\n',
      );
      await jsonFile.writeAsString(
        const JsonEncoder.withIndent('  ').convert(<String, Object>{
          'module': 'open_file',
          'generated_at': '2026-04-11T00:00:00.000Z',
          'files': <String>['release_notes.txt', 'catalog.json'],
          'notes': <String>[
            'Open files by path',
            'Optionally set type',
            'Inspect OpenResult.type and message',
          ],
        }),
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _workspacePath = directory.path;
        _notesPath = notesFile.path;
        _jsonPath = jsonFile.path;
        _status = 'Prepared sample files in a temp workspace.';
        _isPreparing = false;
      });
      _addLog('Prepared sample files in ${directory.path}.');
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _status = 'Failed to prepare sample files: $error';
        _isPreparing = false;
      });
      _addLog('Preparation failed: $error');
    }
  }

  Future<void> _openPath(
    String? path, {
    String? type,
    bool linuxUseGio = false,
    bool linuxByProcess = true,
  }) async {
    try {
      final OpenResult result = await OpenFile.open(
        path,
        type: type,
        isIOSAppOpen: _isIOSAppOpen,
        linuxDesktopName: 'xdg',
        linuxUseGio: linuxUseGio,
        linuxByProcess: linuxByProcess,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _lastResult = result;
        _status =
            'OpenFile.open completed with `${result.type}` and message `${result.message}`.';
      });
      _addLog(
        'OpenFile.open(path: ${path ?? 'null'}, type: ${type ?? 'default'}) -> '
        '${result.type} / ${result.message}',
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _status = 'OpenFile.open threw an exception: $error';
      });
      _addLog('OpenFile.open exception for ${path ?? 'null'}: $error');
    }
  }

  String _resultTypeLabel(OpenResult? result) {
    if (result == null) {
      return 'none';
    }

    return result.type.toString().split('.').last;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('open_file Module')),
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
                      'Use `open_file` to launch a real file path and inspect the returned `OpenResult`.',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'This module demonstrates `OpenFile.open`, explicit `type`, '
                      '`isIOSAppOpen`, Linux options like `linuxUseGio` and '
                      '`linuxByProcess`, and the returned `OpenResult` / '
                      '`ResultType` values.',
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),
                    Text(_status),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: <Widget>[
                        FilledButton.icon(
                          onPressed: _isPreparing ? null : _prepareSamples,
                          icon: const Icon(Icons.folder_copy_outlined),
                          label: const Text('Prepare Sample Files'),
                        ),
                        FilterChip(
                          label: const Text('Pass isIOSAppOpen'),
                          selected: _isIOSAppOpen,
                          onSelected: (bool value) {
                            setState(() {
                              _isIOSAppOpen = value;
                            });
                          },
                        ),
                        Chip(
                          label: Text(
                            'Last result: ${_resultTypeLabel(_lastResult)}',
                          ),
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
                      'Prepared Paths',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _PathTile(
                      label: 'Workspace',
                      value: _workspacePath ?? 'Not prepared yet',
                    ),
                    _PathTile(
                      label: 'Text file',
                      value: _notesPath ?? 'Not prepared yet',
                    ),
                    _PathTile(
                      label: 'JSON file',
                      value: _jsonPath ?? 'Not prepared yet',
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
                      'Open Actions',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'These actions use temp files created by the page, so the module does not depend on hard-coded device storage paths.',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: <Widget>[
                        FilledButton.icon(
                          onPressed: _notesPath == null
                              ? null
                              : () => _openPath(_notesPath),
                          icon: const Icon(Icons.description_outlined),
                          label: const Text('Open Text File'),
                        ),
                        FilledButton.icon(
                          onPressed: _jsonPath == null
                              ? null
                              : () => _openPath(
                                  _jsonPath,
                                  type: 'application/json',
                                ),
                          icon: const Icon(Icons.data_object_outlined),
                          label: const Text('Open JSON with type'),
                        ),
                        OutlinedButton.icon(
                          onPressed: _notesPath == null
                              ? null
                              : () => _openPath(
                                  _notesPath,
                                  type: 'text/plain',
                                  linuxUseGio: false,
                                  linuxByProcess: true,
                                ),
                          icon: const Icon(Icons.terminal_outlined),
                          label: const Text('Open with Linux flags'),
                        ),
                        OutlinedButton.icon(
                          onPressed: () => _openPath(
                            _workspacePath == null
                                ? null
                                : '$_workspacePath/missing_document.pdf',
                            type: 'application/pdf',
                          ),
                          icon: const Icon(Icons.error_outline),
                          label: const Text('Open Missing File'),
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
                      'Last OpenResult',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: <Widget>[
                        Chip(
                          label: Text('type: ${_resultTypeLabel(_lastResult)}'),
                        ),
                        Chip(
                          label: Text(
                            'message: ${_lastResult?.message ?? 'No result yet'}',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _CodeCard(
              title: 'Core open_file Pattern',
              code: r'''
final OpenResult result = await OpenFile.open(
  filePath,
  type: 'application/json',
  isIOSAppOpen: false,
  linuxDesktopName: 'xdg',
  linuxUseGio: false,
  linuxByProcess: true,
);

debugPrint('type=${result.type} message=${result.message}');
''',
            ),
            const SizedBox(height: 16),
            _EventLogCard(entries: _eventLog),
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

class _PathTile extends StatelessWidget {
  const _PathTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          SelectableText(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontFamily: 'monospace',
              height: 1.45,
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
            const SizedBox(height: 12),
            SelectableText(
              code,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontFamily: 'monospace',
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EventLogCard extends StatelessWidget {
  const _EventLogCard({required this.entries});

  final List<String> entries;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Event Log',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            if (entries.isEmpty)
              const Text('No open_file events yet.')
            else
              ...entries.map(
                (String entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(entry),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
