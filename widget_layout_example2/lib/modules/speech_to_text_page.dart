import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:widget_layout_example2/app_navigation.dart';

@RoutePage(name: RouteName.speechToText)
class SpeechToTextPage extends StatefulWidget {
  const SpeechToTextPage({super.key});

  @override
  State<SpeechToTextPage> createState() => _SpeechToTextPageState();
}

class _SpeechToTextPageState extends State<SpeechToTextPage> {
  final stt.SpeechToText _speech = stt.SpeechToText();

  bool _available = false;
  bool _hasPermission = false;
  bool _partialResults = true;
  bool _autoPunctuation = true;
  bool _onDevice = false;
  double _soundLevel = 0;
  String _status =
      'Initialize speech recognition to inspect locale and status callbacks.';
  String _recognizedWords = '';
  double _confidence = 0;
  String? _errorMessage;
  stt.LocaleName? _systemLocale;
  String? _selectedLocaleId;
  List<stt.LocaleName> _locales = <stt.LocaleName>[];
  final List<String> _eventLog = <String>[];

  @override
  void initState() {
    super.initState();
    _refreshPermission();
  }

  @override
  void dispose() {
    _speech.stop();
    super.dispose();
  }

  Future<void> _refreshPermission() async {
    try {
      final bool hasPermission = await _speech.hasPermission;
      if (!mounted) {
        return;
      }
      setState(() {
        _hasPermission = hasPermission;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _hasPermission = false;
      });
    }
  }

  void _addEvent(String message) {
    final DateTime now = DateTime.now();
    final String stamp =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
    _eventLog.insert(0, '$stamp  $message');
    if (_eventLog.length > 12) {
      _eventLog.removeRange(12, _eventLog.length);
    }
  }

  Future<void> _initializeSpeech() async {
    try {
      final bool available = await _speech.initialize(
        onStatus: _onStatus,
        onError: _onError,
        options: <stt.SpeechConfigOption>[stt.SpeechToText.androidNoBluetooth],
      );
      final List<stt.LocaleName> locales = available
          ? await _speech.locales()
          : <stt.LocaleName>[];
      final stt.LocaleName? systemLocale = available
          ? await _speech.systemLocale()
          : null;

      if (!mounted) {
        return;
      }

      setState(() {
        _available = available;
        _locales = locales;
        _systemLocale = systemLocale;
        _selectedLocaleId =
            systemLocale?.localeId ??
            (locales.isNotEmpty ? locales.first.localeId : null);
        _status = available
            ? 'Speech recognition initialized successfully.'
            : 'Speech recognition is unavailable on this platform or permission was denied.';
        _addEvent('initialize -> $available');
      });
      await _refreshPermission();
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _status = 'initialize() failed: $error';
        _addEvent('initialize failed: $error');
      });
    }
  }

  Future<void> _startListening() async {
    if (!_available) {
      setState(() {
        _status = 'Initialize speech recognition before calling listen().';
      });
      return;
    }

    try {
      await _speech.listen(
        onResult: _onResult,
        onSoundLevelChange: (double level) {
          if (!mounted) {
            return;
          }
          setState(() {
            _soundLevel = level;
          });
        },
        listenOptions: stt.SpeechListenOptions(
          partialResults: _partialResults,
          autoPunctuation: _autoPunctuation,
          onDevice: _onDevice,
          listenMode: stt.ListenMode.dictation,
          pauseFor: const Duration(seconds: 3),
          listenFor: const Duration(seconds: 20),
          localeId: _selectedLocaleId,
        ),
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _status = 'listen() requested with SpeechListenOptions.';
        _addEvent('listen(localeId: ${_selectedLocaleId ?? 'system'})');
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _status = 'listen() failed: $error';
        _addEvent('listen failed: $error');
      });
    }
  }

  Future<void> _stopListening() async {
    await _speech.stop();
    if (!mounted) {
      return;
    }
    setState(() {
      _status = 'stop() requested.';
      _addEvent('stop');
    });
  }

  Future<void> _cancelListening() async {
    await _speech.cancel();
    if (!mounted) {
      return;
    }
    setState(() {
      _status = 'cancel() requested.';
      _addEvent('cancel');
    });
  }

  void _shortenPauseWindow() {
    try {
      _speech.changePauseFor(const Duration(seconds: 1));
      setState(() {
        _status = 'changePauseFor() updated the active session to 1 second.';
        _addEvent('changePauseFor(1s)');
      });
    } catch (error) {
      setState(() {
        _status = 'changePauseFor() failed: $error';
      });
    }
  }

  void _onStatus(String status) {
    if (!mounted) {
      return;
    }
    setState(() {
      _status = 'Status callback: $status';
      _addEvent('status -> $status');
    });
  }

  void _onError(SpeechRecognitionError error) {
    if (!mounted) {
      return;
    }
    setState(() {
      _errorMessage = '${error.errorMsg} (permanent=${error.permanent})';
      _status = 'Error callback: ${error.errorMsg}';
      _addEvent('error -> ${error.errorMsg}');
    });
  }

  void _onResult(SpeechRecognitionResult result) {
    if (!mounted) {
      return;
    }
    setState(() {
      _recognizedWords = result.recognizedWords;
      _confidence = result.confidence;
      _status = result.finalResult
          ? 'Received a final speech result.'
          : 'Received a partial speech result.';
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('speech_to_text Module')),
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
                      'Use `speech_to_text` to initialize speech recognition, inspect locale support, and stream partial results.',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'This module demonstrates `SpeechToText`, `initialize`, '
                      '`hasPermission`, `locales`, `systemLocale`, `listen`, '
                      '`SpeechListenOptions`, `stop`, `cancel`, `changePauseFor`, '
                      '`onResult`, `onStatus`, `onError`, and `onSoundLevelChange`.',
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),
                    Text(_status),
                    if (_errorMessage != null) ...<Widget>[
                      const SizedBox(height: 8),
                      Text('Last error: $_errorMessage'),
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
                      'Recognizer State',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: <Widget>[
                        Chip(label: Text('available: $_available')),
                        Chip(label: Text('hasPermission: $_hasPermission')),
                        Chip(
                          label: Text('isListening: ${_speech.isListening}'),
                        ),
                        Chip(
                          label: Text(
                            'systemLocale: ${_systemLocale?.localeId ?? 'unknown'}',
                          ),
                        ),
                        Chip(
                          label: Text(
                            'soundLevel: ${_soundLevel.toStringAsFixed(2)}',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: <Widget>[
                        FilledButton.icon(
                          onPressed: _initializeSpeech,
                          icon: const Icon(Icons.settings_voice_outlined),
                          label: const Text('Initialize'),
                        ),
                        FilledButton.icon(
                          onPressed: _startListening,
                          icon: const Icon(Icons.mic_none_outlined),
                          label: const Text('Listen'),
                        ),
                        OutlinedButton.icon(
                          onPressed: _stopListening,
                          icon: const Icon(Icons.stop_outlined),
                          label: const Text('Stop'),
                        ),
                        OutlinedButton.icon(
                          onPressed: _cancelListening,
                          icon: const Icon(Icons.cancel_outlined),
                          label: const Text('Cancel'),
                        ),
                        OutlinedButton.icon(
                          onPressed: _shortenPauseWindow,
                          icon: const Icon(Icons.timer_outlined),
                          label: const Text('Pause 1s'),
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
                      'Listen Options',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (_locales.isNotEmpty)
                      DropdownButtonFormField<String>(
                        initialValue: _selectedLocaleId,
                        items: _locales
                            .map(
                              (stt.LocaleName locale) =>
                                  DropdownMenuItem<String>(
                                    value: locale.localeId,
                                    child: Text(
                                      '${locale.name} (${locale.localeId})',
                                    ),
                                  ),
                            )
                            .toList(),
                        onChanged: (String? value) {
                          setState(() {
                            _selectedLocaleId = value;
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: 'Locale',
                          border: OutlineInputBorder(),
                        ),
                      )
                    else
                      const Text('No locales loaded yet. Initialize first.'),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: <Widget>[
                        FilterChip(
                          label: const Text('partialResults'),
                          selected: _partialResults,
                          onSelected: (bool value) {
                            setState(() {
                              _partialResults = value;
                            });
                          },
                        ),
                        FilterChip(
                          label: const Text('autoPunctuation'),
                          selected: _autoPunctuation,
                          onSelected: (bool value) {
                            setState(() {
                              _autoPunctuation = value;
                            });
                          },
                        ),
                        FilterChip(
                          label: const Text('onDevice'),
                          selected: _onDevice,
                          onSelected: (bool value) {
                            setState(() {
                              _onDevice = value;
                            });
                          },
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
                      'Recognition Result',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SelectableText(
                      _recognizedWords.isEmpty
                          ? 'No recognized words yet.'
                          : _recognizedWords,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: <Widget>[
                        Chip(
                          label: Text(
                            'confidence: ${_confidence.toStringAsFixed(2)}',
                          ),
                        ),
                        Chip(label: Text('lastStatus: ${_speech.lastStatus}')),
                        Chip(
                          label: Text(
                            'hasRecognized: ${_speech.hasRecognized}',
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
              title: 'Core speech_to_text Pattern',
              code: r'''
final stt.SpeechToText speech = stt.SpeechToText();

final bool available = await speech.initialize(
  onStatus: (status) {},
  onError: (error) {},
);

await speech.listen(
  onResult: (result) {},
  onSoundLevelChange: (level) {},
  listenOptions: stt.SpeechListenOptions(
    partialResults: true,
    autoPunctuation: true,
    listenMode: stt.ListenMode.dictation,
    pauseFor: Duration(seconds: 3),
    listenFor: Duration(seconds: 20),
    localeId: 'en_US',
  ),
);
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
              const Text('No speech events yet.')
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
