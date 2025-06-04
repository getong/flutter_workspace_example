import 'package:flutter/material.dart';
import 'package:get_it_basic_example/service_locator.dart';
import 'package:get_it_basic_example/services/settings_service.dart';
import 'package:get_it_basic_example/services/data_repository.dart';
import 'package:get_it_basic_example/services/logger_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late final SettingsService _settingsService;
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _settingsService = getIt<SettingsService>();
    _nameController = TextEditingController(text: _settingsService.userName);
    _settingsService.addListener(_onSettingsChanged);
  }

  @override
  void dispose() {
    _settingsService.removeListener(_onSettingsChanged);
    _nameController.dispose();
    super.dispose();
  }

  void _onSettingsChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _settingsService.resetToDefaults();
              _nameController.text = _settingsService.userName;

              // Demonstrate factory pattern - new logger instance
              final logger = getIt<LoggerService>();
              logger.logInfo('Settings reset to defaults');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Appearance',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: const Text('Dark Mode'),
                      value: _settingsService.isDarkMode,
                      onChanged: (_) {
                        _settingsService.toggleDarkMode();
                        final logger = getIt<LoggerService>();
                        logger.log(
                          'Dark mode toggled: ${_settingsService.isDarkMode}',
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Font Size: ${_settingsService.fontSize.toStringAsFixed(1)}',
                    ),
                    Slider(
                      value: _settingsService.fontSize,
                      min: 10.0,
                      max: 20.0,
                      divisions: 10,
                      onChanged: (value) {
                        _settingsService.setFontSize(value);
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'User Profile',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'User Name',
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (value) {
                        _settingsService.setUserName(value);
                        final logger = getIt<LoggerService>();
                        logger.log('User name changed to: $value');
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Data Management',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        final repository = getIt<DataRepository>();
                        await repository.clearData();

                        final logger = getIt<LoggerService>();
                        logger.logInfo('Data cleared from repository');

                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Data cleared successfully'),
                            ),
                          );
                        }
                      },
                      child: const Text('Clear All Data'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
