import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

@RoutePage()
class FlutterTtsPage extends StatefulWidget {
  const FlutterTtsPage({super.key});

  @override
  State<FlutterTtsPage> createState() => _FlutterTtsPageState();
}

class _FlutterTtsPageState extends State<FlutterTtsPage> {
  final FlutterTts _tts = FlutterTts();
  late final TextEditingController _textController;

  double _speechRate = 0.45;
  double _pitch = 1.0;
  double _volume = 0.8;
  String _status = 'Initialize TTS controls, then speak the sample text.';
  String _progress = 'No progress events yet.';
  String? _selectedLanguage;
  Map<String, String>? _selectedVoice;
  List<String> _languages = <String>[];
  List<Map<String, String>> _voices = <Map<String, String>>[];
  final List<String> _events = <String>[];

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(
      text: 'Flutter text to speech can turn widgets into spoken feedback.',
    );
    _bindHandlers();
    unawaited(_initializeTts());
  }

  @override
  void dispose() {
    _tts.stop();
    _textController.dispose();
    super.dispose();
  }

  void _pushEvent(String message) {
    final DateTime now = DateTime.now();
    final String stamp =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
    _events.insert(0, '$stamp  $message');
    if (_events.length > 12) {
      _events.removeRange(12, _events.length);
    }
  }

  void _bindHandlers() {
    _tts.setStartHandler(() {
      if (!mounted) {
        return;
      }
      setState(() {
        _status = 'Speech playback started.';
        _pushEvent('start');
      });
    });
    _tts.setCompletionHandler(() {
      if (!mounted) {
        return;
      }
      setState(() {
        _status = 'Speech playback completed.';
        _pushEvent('complete');
      });
    });
    _tts.setPauseHandler(() {
      if (!mounted) {
        return;
      }
      setState(() {
        _status = 'Speech playback paused.';
        _pushEvent('pause');
      });
    });
    _tts.setContinueHandler(() {
      if (!mounted) {
        return;
      }
      setState(() {
        _status = 'Speech playback continued.';
        _pushEvent('continue');
      });
    });
    _tts.setCancelHandler(() {
      if (!mounted) {
        return;
      }
      setState(() {
        _status = 'Speech playback canceled.';
        _pushEvent('cancel');
      });
    });
    _tts.setErrorHandler((dynamic message) {
      if (!mounted) {
        return;
      }
      setState(() {
        _status = 'TTS error: $message';
        _pushEvent('error: $message');
      });
    });
    _tts.setProgressHandler((String text, int start, int end, String word) {
      if (!mounted) {
        return;
      }
      setState(() {
        _progress = 'word="$word" start=$start end=$end';
      });
    });
  }

  Future<void> _initializeTts() async {
    try {
      await _tts.awaitSpeakCompletion(true);
      await _tts.setSpeechRate(_speechRate);
      await _tts.setPitch(_pitch);
      await _tts.setVolume(_volume);

      final dynamic languagesResult = await _tts.getLanguages;
      final List<String> languages =
          (languagesResult as List<dynamic>?)
              ?.map((dynamic value) => value.toString())
              .toList() ??
          <String>[];

      final dynamic voicesResult = await _tts.getVoices;
      final List<Map<String, String>> voices =
          (voicesResult as List<dynamic>?)
              ?.map(
                (dynamic value) => Map<String, String>.from(
                  (value as Map<dynamic, dynamic>).map(
                    (dynamic key, dynamic val) =>
                        MapEntry(key.toString(), val.toString()),
                  ),
                ),
              )
              .toList() ??
          <Map<String, String>>[];

      if (!mounted) {
        return;
      }

      setState(() {
        _languages = languages;
        _voices = voices;
        _selectedLanguage = languages.isNotEmpty ? languages.first : null;
        _selectedVoice = voices.isNotEmpty ? voices.first : null;
        _status = 'Loaded available languages and voices from flutter_tts.';
      });

      if (_selectedLanguage != null) {
        await _tts.setLanguage(_selectedLanguage!);
      }
      if (_selectedVoice != null) {
        await _tts.setVoice(_selectedVoice!);
      }
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _status = 'Failed to initialize flutter_tts: $error';
      });
    }
  }

  Future<void> _speak() async {
    try {
      await _tts.setSpeechRate(_speechRate);
      await _tts.setPitch(_pitch);
      await _tts.setVolume(_volume);
      if (_selectedLanguage != null) {
        await _tts.setLanguage(_selectedLanguage!);
      }
      if (_selectedVoice != null) {
        await _tts.setVoice(_selectedVoice!);
      }
      await _tts.speak(_textController.text);
    } catch (error) {
      setState(() {
        _status = 'speak() failed: $error';
      });
    }
  }

  Future<void> _pause() async {
    try {
      await _tts.pause();
      setState(() {
        _status = 'pause() requested.';
      });
    } catch (error) {
      setState(() {
        _status = 'pause() failed: $error';
      });
    }
  }

  Future<void> _stop() async {
    try {
      await _tts.stop();
      setState(() {
        _status = 'stop() requested.';
      });
    } catch (error) {
      setState(() {
        _status = 'stop() failed: $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('flutter_tts Module')),
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
                      'Use `flutter_tts` to configure speech synthesis, voices, and playback callbacks.',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'This module demonstrates `FlutterTts`, `awaitSpeakCompletion`, '
                      '`setLanguage`, `setVoice`, `setSpeechRate`, `setPitch`, '
                      '`setVolume`, `getLanguages`, `getVoices`, `speak`, `pause`, '
                      '`stop`, plus start, completion, cancel, error, and progress handlers.',
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),
                    Text(_status),
                    const SizedBox(height: 8),
                    Text('Progress: $_progress'),
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
                      'Speech Controls',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _textController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: 'Text to speak',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (_languages.isNotEmpty)
                      DropdownButtonFormField<String>(
                        initialValue: _selectedLanguage,
                        items: _languages
                            .map(
                              (String language) => DropdownMenuItem<String>(
                                value: language,
                                child: Text(language),
                              ),
                            )
                            .toList(),
                        onChanged: (String? value) {
                          setState(() {
                            _selectedLanguage = value;
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: 'Language',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    if (_languages.isNotEmpty) const SizedBox(height: 12),
                    if (_voices.isNotEmpty)
                      DropdownButtonFormField<String>(
                        initialValue:
                            _selectedVoice?['name'] ??
                            _selectedVoice?['identifier'],
                        items: _voices
                            .map(
                              (Map<String, String> voice) =>
                                  DropdownMenuItem<String>(
                                    value: voice['name'] ?? voice['identifier'],
                                    child: Text(
                                      voice['name'] ??
                                          voice['identifier'] ??
                                          voice.toString(),
                                    ),
                                  ),
                            )
                            .toList(),
                        onChanged: (String? value) {
                          setState(() {
                            _selectedVoice = _voices.firstWhere(
                              (Map<String, String> voice) =>
                                  (voice['name'] ?? voice['identifier']) ==
                                  value,
                            );
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: 'Voice',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    if (_voices.isNotEmpty) const SizedBox(height: 12),
                    Text('Speech rate: ${_speechRate.toStringAsFixed(2)}'),
                    Slider(
                      value: _speechRate,
                      min: 0.1,
                      max: 1.0,
                      onChanged: (double value) {
                        setState(() {
                          _speechRate = value;
                        });
                      },
                    ),
                    Text('Pitch: ${_pitch.toStringAsFixed(2)}'),
                    Slider(
                      value: _pitch,
                      min: 0.5,
                      max: 2.0,
                      onChanged: (double value) {
                        setState(() {
                          _pitch = value;
                        });
                      },
                    ),
                    Text('Volume: ${_volume.toStringAsFixed(2)}'),
                    Slider(
                      value: _volume,
                      min: 0.0,
                      max: 1.0,
                      onChanged: (double value) {
                        setState(() {
                          _volume = value;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: <Widget>[
                        FilledButton.icon(
                          onPressed: _speak,
                          icon: const Icon(Icons.record_voice_over_outlined),
                          label: const Text('Speak'),
                        ),
                        OutlinedButton.icon(
                          onPressed: _pause,
                          icon: const Icon(Icons.pause_outlined),
                          label: const Text('Pause'),
                        ),
                        OutlinedButton.icon(
                          onPressed: _stop,
                          icon: const Icon(Icons.stop_outlined),
                          label: const Text('Stop'),
                        ),
                        OutlinedButton.icon(
                          onPressed: _initializeTts,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Reload Voices'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _CodeCard(
              title: 'Core flutter_tts Pattern',
              code: r'''
final FlutterTts tts = FlutterTts();

tts.setStartHandler(() {});
tts.setCompletionHandler(() {});
tts.setErrorHandler((message) {});
tts.setProgressHandler((text, start, end, word) {});

await tts.awaitSpeakCompletion(true);
await tts.setLanguage('en-US');
await tts.setSpeechRate(0.45);
await tts.setPitch(1.0);
await tts.setVolume(0.8);

final languages = await tts.getLanguages;
final voices = await tts.getVoices;
await tts.speak('Hello from flutter_tts');
''',
            ),
            const SizedBox(height: 16),
            _EventLogCard(entries: _events),
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
              const Text('No TTS events yet.')
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
