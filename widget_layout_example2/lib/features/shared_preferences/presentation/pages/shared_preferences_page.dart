import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:widget_layout_example2/app_navigation.dart';

@RoutePage(name: RouteName.sharedPreferences)
class SharedPreferencesPage extends StatefulWidget {
  const SharedPreferencesPage({super.key});

  @override
  State<SharedPreferencesPage> createState() => _SharedPreferencesPageState();
}

class _SharedPreferencesPageState extends State<SharedPreferencesPage> {
  static const String _counterKey = 'shared_preferences_demo_counter';
  static const String _noteKey = 'shared_preferences_demo_note';

  final TextEditingController _noteController = TextEditingController();

  int _counter = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _loadPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int savedCounter = prefs.getInt(_counterKey) ?? 0;
    final String savedNote = prefs.getString(_noteKey) ?? 'No saved note yet.';

    if (!mounted) {
      return;
    }

    setState(() {
      _counter = savedCounter;
      _noteController.text = savedNote;
      _isLoading = false;
    });
  }

  Future<void> _saveCounter(int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_counterKey, value);

    if (!mounted) {
      return;
    }

    setState(() {
      _counter = value;
    });
  }

  Future<void> _saveNote() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_noteKey, _noteController.text);

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Note saved with shared_preferences.')),
    );
  }

  Future<void> _resetValues() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_counterKey);
    await prefs.remove(_noteKey);

    if (!mounted) {
      return;
    }

    setState(() {
      _counter = 0;
      _noteController.text = 'No saved note yet.';
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Saved values cleared.')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('shared_preferences Module')),
      body: SelectionArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(24),
                children: <Widget>[
                  const Text(
                    'shared_preferences is useful for simple local persistence such as counters, flags, and short text values that should survive app restarts.',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    clipBehavior: Clip.antiAlias,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Persisted Counter',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Press the button to save a counter value locally. It will still be here the next time the app opens.',
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Current saved counter: $_counter',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: <Widget>[
                              FilledButton(
                                onPressed: () => _saveCounter(_counter + 1),
                                child: const Text('Increment And Save'),
                              ),
                              OutlinedButton(
                                onPressed: () => _saveCounter(0),
                                child: const Text('Reset Counter'),
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
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Persisted Note',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Edit the note below and save it to SharedPreferences.',
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _noteController,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Saved note',
                            ),
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: <Widget>[
                              FilledButton(
                                onPressed: _saveNote,
                                child: const Text('Save Note'),
                              ),
                              TextButton(
                                onPressed: _resetValues,
                                child: const Text('Clear All Saved Values'),
                              ),
                            ],
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
