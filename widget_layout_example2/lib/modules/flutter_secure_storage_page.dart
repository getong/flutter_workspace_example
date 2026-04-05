import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum _StoragePreset {
  defaultSecure,
  explicitAndroidDefault,
  biometricGraceful,
  biometricStrict,
  legacyCustom,
}

class _StoragePresetConfig {
  const _StoragePresetConfig({
    required this.label,
    required this.description,
    required this.storage,
    required this.code,
  });

  final String label;
  final String description;
  final FlutterSecureStorage storage;
  final String code;
}

const MacOsOptions _macOsDemoOptions = MacOsOptions(
  usesDataProtectionKeychain: false,
);

const Map<_StoragePreset, _StoragePresetConfig>
_storagePresets = <_StoragePreset, _StoragePresetConfig>{
  _StoragePreset.defaultSecure: _StoragePresetConfig(
    label: 'Default',
    description:
        'Uses the package default configuration. On Android that means RSA OAEP key wrapping with AES-GCM for stored values. On macOS this demo opts into the regular keychain so local debug builds work without a development-signing setup.',
    storage: FlutterSecureStorage(mOptions: _macOsDemoOptions),
    code: '''
final storage = FlutterSecureStorage(
  mOptions: MacOsOptions(usesDataProtectionKeychain: false),
);
''',
  ),
  _StoragePreset.explicitAndroidDefault: _StoragePresetConfig(
    label: 'AndroidOptions()',
    description:
        'Makes the Android configuration explicit while keeping the recommended default cipher setup.',
    storage: FlutterSecureStorage(
      aOptions: AndroidOptions(),
      mOptions: _macOsDemoOptions,
    ),
    code: '''
final storage = FlutterSecureStorage(
  aOptions: AndroidOptions(),
  mOptions: MacOsOptions(usesDataProtectionKeychain: false),
);
''',
  ),
  _StoragePreset.biometricGraceful: _StoragePresetConfig(
    label: 'Biometric Graceful',
    description:
        'Uses biometric-capable storage on Android, but gracefully falls back when biometric authentication is unavailable.',
    storage: FlutterSecureStorage(
      aOptions: AndroidOptions.biometric(
        enforceBiometrics: false,
        biometricPromptTitle: 'Authenticate',
      ),
      mOptions: _macOsDemoOptions,
    ),
    code: '''
final storage = FlutterSecureStorage(
  aOptions: AndroidOptions.biometric(
    enforceBiometrics: false,
    biometricPromptTitle: 'Authenticate',
  ),
  mOptions: MacOsOptions(usesDataProtectionKeychain: false),
);
''',
  ),
  _StoragePreset.biometricStrict: _StoragePresetConfig(
    label: 'Biometric Strict',
    description:
        'Requires biometric or device-credential authentication on supported Android devices. This is useful for highly sensitive values.',
    storage: FlutterSecureStorage(
      aOptions: AndroidOptions.biometric(
        enforceBiometrics: true,
        biometricPromptTitle: 'Authentication Required',
      ),
      mOptions: _macOsDemoOptions,
    ),
    code: '''
final storage = FlutterSecureStorage(
  aOptions: AndroidOptions.biometric(
    enforceBiometrics: true,
    biometricPromptTitle: 'Authentication Required',
  ),
  mOptions: MacOsOptions(usesDataProtectionKeychain: false),
);
''',
  ),
  _StoragePreset.legacyCustom: _StoragePresetConfig(
    label: 'Legacy Custom',
    description:
        'Shows the advanced constructor for legacy compatibility. This is usually only needed for migration or old Android data formats.',
    storage: FlutterSecureStorage(
      aOptions: AndroidOptions(
        keyCipherAlgorithm: KeyCipherAlgorithm.RSA_ECB_PKCS1Padding,
        storageCipherAlgorithm: StorageCipherAlgorithm.AES_CBC_PKCS7Padding,
      ),
      mOptions: _macOsDemoOptions,
    ),
    code: '''
final storage = FlutterSecureStorage(
  aOptions: AndroidOptions(
    keyCipherAlgorithm: KeyCipherAlgorithm.RSA_ECB_PKCS1Padding,
    storageCipherAlgorithm: StorageCipherAlgorithm.AES_CBC_PKCS7Padding,
  ),
  mOptions: MacOsOptions(usesDataProtectionKeychain: false),
);
''',
  ),
};

@RoutePage(name: 'FlutterSecureStorageRoute')
class FlutterSecureStoragePage extends StatefulWidget {
  const FlutterSecureStoragePage({super.key});

  @override
  State<FlutterSecureStoragePage> createState() =>
      _FlutterSecureStoragePageState();
}

class _FlutterSecureStoragePageState extends State<FlutterSecureStoragePage> {
  static const String _listenerKey = 'listener_demo_key';
  static const FlutterSecureStorage _listenerStorage = FlutterSecureStorage(
    mOptions: _macOsDemoOptions,
  );

  final TextEditingController _keyController = TextEditingController(
    text: 'demo_access_token',
  );
  final TextEditingController _valueController = TextEditingController(
    text: 'token_123456789',
  );
  late final ValueChanged<String?> _listener = _listenerCallback;

  _StoragePreset _selectedPreset = _StoragePreset.defaultSecure;
  Map<String, String> _entries = <String, String>{};
  List<String> _eventLog = <String>[];
  String _result =
      'Choose a preset, then use the buttons below to interact with secure storage.';
  String _cupertinoStatus =
      'Protected-data availability has not been checked yet.';
  bool _listenerRegistered = false;
  bool _busy = false;

  _StoragePresetConfig get _activePreset => _storagePresets[_selectedPreset]!;
  FlutterSecureStorage get _activeStorage => _activePreset.storage;

  @override
  void initState() {
    super.initState();
    _registerListener();
    _refreshEntries();
  }

  @override
  void dispose() {
    _unregisterListener();
    _keyController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  String get _key => _keyController.text.trim();
  String get _value => _valueController.text;

  void _registerListener() {
    if (_listenerRegistered) {
      return;
    }

    _listenerStorage.registerListener(key: _listenerKey, listener: _listener);
    _listenerRegistered = true;
    _addLog('registerListener(key: $_listenerKey)');
  }

  void _unregisterListener() {
    if (!_listenerRegistered) {
      return;
    }

    _listenerStorage.unregisterListener(key: _listenerKey, listener: _listener);
    _listenerRegistered = false;
  }

  void _listenerCallback(String? value) {
    _addLog(
      'listener event for $_listenerKey -> ${value == null ? 'null' : '"$value"'}',
    );
  }

  void _addLog(String message) {
    final DateTime now = DateTime.now();
    final String timestamp =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';

    if (!mounted) {
      return;
    }

    setState(() {
      _eventLog = <String>[
        '$timestamp  $message',
        ..._eventLog,
      ].take(10).toList();
    });
  }

  Future<void> _refreshEntries() async {
    try {
      final Map<String, String> snapshot = await _activeStorage.readAll();
      final List<MapEntry<String, String>> sortedEntries =
          snapshot.entries.toList()
            ..sort((MapEntry<String, String> a, MapEntry<String, String> b) {
              return a.key.compareTo(b.key);
            });
      if (!mounted) {
        return;
      }
      setState(() {
        _entries = Map<String, String>.fromEntries(sortedEntries);
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _entries = <String, String>{};
      });
      _addLog('readAll failed during refresh: $error');
    }
  }

  Future<void> _runOperation({
    required String label,
    required Future<String> Function() action,
  }) async {
    if (_busy) {
      return;
    }

    setState(() {
      _busy = true;
    });

    try {
      final String message = await action();
      if (!mounted) {
        return;
      }
      setState(() {
        _result = message;
      });
      _addLog('${_activePreset.label}: $label');
    } on PlatformException catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _result =
            'PlatformException(${error.code}): ${error.message ?? 'No message'}';
      });
      _addLog('${_activePreset.label}: $label failed with ${error.code}');
    } on UnsupportedError catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _result = 'UnsupportedError: $error';
      });
      _addLog('${_activePreset.label}: $label unsupported');
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _result = 'Unexpected error: $error';
      });
      _addLog('${_activePreset.label}: $label failed');
    } finally {
      await _refreshEntries();
      if (mounted) {
        setState(() {
          _busy = false;
        });
      }
    }
  }

  Future<void> _writeValue() async {
    await _runOperation(
      label: 'write',
      action: () async {
        await _activeStorage.write(key: _key, value: _value);
        final String? readBack = await _activeStorage.read(key: _key);
        return 'write(key: "$_key") succeeded. read(...) returned ${readBack == null ? 'null' : '"$readBack"'}.';
      },
    );
  }

  Future<void> _readValue() async {
    await _runOperation(
      label: 'read',
      action: () async {
        final String? value = await _activeStorage.read(key: _key);
        return 'read(key: "$_key") -> ${value == null ? 'null' : '"$value"'}.';
      },
    );
  }

  Future<void> _containsKey() async {
    await _runOperation(
      label: 'containsKey',
      action: () async {
        final bool exists = await _activeStorage.containsKey(key: _key);
        return 'containsKey(key: "$_key") -> $exists.';
      },
    );
  }

  Future<void> _deleteValue() async {
    await _runOperation(
      label: 'delete',
      action: () async {
        await _activeStorage.delete(key: _key);
        return 'delete(key: "$_key") completed.';
      },
    );
  }

  Future<void> _writeNullShortcut() async {
    await _runOperation(
      label: 'write(value: null)',
      action: () async {
        await _activeStorage.write(key: _key, value: null);
        return 'write(key: "$_key", value: null) deleted the value for that key.';
      },
    );
  }

  Future<void> _readAllValues() async {
    await _runOperation(
      label: 'readAll',
      action: () async {
        final Map<String, String> values = await _activeStorage.readAll();
        return 'readAll() returned ${values.length} entr${values.length == 1 ? 'y' : 'ies'}.';
      },
    );
  }

  Future<void> _deleteAllValues() async {
    await _runOperation(
      label: 'deleteAll',
      action: () async {
        await _activeStorage.deleteAll();
        return 'deleteAll() completed for the active storage configuration.';
      },
    );
  }

  Future<void> _checkProtectedData() async {
    await _runOperation(
      label: 'isCupertinoProtectedDataAvailable',
      action: () async {
        final bool? isAvailable = await _activeStorage
            .isCupertinoProtectedDataAvailable();
        final String status = switch (isAvailable) {
          true => 'Protected data is currently available.',
          false => 'Protected data is currently unavailable.',
          null =>
            'This platform does not expose Cupertino protected-data state.',
        };
        if (mounted) {
          setState(() {
            _cupertinoStatus = status;
          });
        }
        return status;
      },
    );
  }

  Future<void> _writeListenerKey() async {
    await _runOperation(
      label: 'listener write',
      action: () async {
        await _activeStorage.write(
          key: _listenerKey,
          value: 'listener_value_${DateTime.now().millisecondsSinceEpoch}',
        );
        return 'Wrote a value for the listener demo key "$_listenerKey".';
      },
    );
  }

  Future<void> _deleteListenerKey() async {
    await _runOperation(
      label: 'listener delete',
      action: () async {
        await _activeStorage.delete(key: _listenerKey);
        return 'Deleted the listener demo key "$_listenerKey".';
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('flutter_secure_storage Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'flutter_secure_storage stores sensitive values using platform-secure APIs. This demo shows constructor presets, CRUD operations, listeners, and platform-specific capability checks.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            const _InfoCard(
              title: 'What this module demonstrates',
              description:
                  'The preset constructors below all compile against flutter_secure_storage 10.x. Android-specific options only change behavior on Android. For macOS, this demo uses MacOsOptions(usesDataProtectionKeychain: false) so the page runs in local debug builds without requiring Apple development signing.',
            ),
            const SizedBox(height: 16),
            _InfoCard(
              title: 'Active preset',
              description: _activePreset.description,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _storagePresets.entries.map((
                MapEntry<_StoragePreset, _StoragePresetConfig> entry,
              ) {
                return ChoiceChip(
                  label: Text(entry.value.label),
                  selected: entry.key == _selectedPreset,
                  onSelected: (bool selected) {
                    if (!selected) {
                      return;
                    }
                    setState(() {
                      _selectedPreset = entry.key;
                      _result =
                          'Switched to ${entry.value.label}. Future operations will use this storage configuration.';
                    });
                    _addLog('Switched preset to ${entry.value.label}');
                    _refreshEntries();
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            _CodeCard(title: 'Selected constructor', code: _activePreset.code),
            const SizedBox(height: 16),
            const _CodeCard(
              title: 'CRUD operations',
              code: '''
await storage.write(key: 'token', value: 'abc123');
final String? token = await storage.read(key: 'token');
final bool exists = await storage.containsKey(key: 'token');
final Map<String, String> allValues = await storage.readAll();
await storage.delete(key: 'token');
await storage.deleteAll();
''',
            ),
            const SizedBox(height: 16),
            const _CodeCard(
              title: 'Listeners and Cupertino-only status',
              code: '''
storage.registerListener(
  key: 'listener_demo_key',
  listener: (String? value) {
    debugPrint('listener_demo_key -> \$value');
  },
);

final bool? protectedData =
    await storage.isCupertinoProtectedDataAvailable();
''',
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Playground',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Use the selected preset to write, read, inspect, or erase secure values.',
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _keyController,
                      decoration: const InputDecoration(
                        labelText: 'Key',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _valueController,
                      decoration: const InputDecoration(
                        labelText: 'Value',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: <Widget>[
                        FilledButton.icon(
                          onPressed: _busy ? null : _writeValue,
                          icon: const Icon(Icons.save_outlined),
                          label: const Text('Write'),
                        ),
                        OutlinedButton.icon(
                          onPressed: _busy ? null : _readValue,
                          icon: const Icon(Icons.visibility_outlined),
                          label: const Text('Read'),
                        ),
                        OutlinedButton.icon(
                          onPressed: _busy ? null : _containsKey,
                          icon: const Icon(Icons.key_outlined),
                          label: const Text('Contains Key'),
                        ),
                        OutlinedButton.icon(
                          onPressed: _busy ? null : _deleteValue,
                          icon: const Icon(Icons.delete_outline),
                          label: const Text('Delete'),
                        ),
                        OutlinedButton.icon(
                          onPressed: _busy ? null : _writeNullShortcut,
                          icon: const Icon(Icons.remove_circle_outline),
                          label: const Text('Write Null'),
                        ),
                        OutlinedButton.icon(
                          onPressed: _busy ? null : _readAllValues,
                          icon: const Icon(Icons.list_alt_outlined),
                          label: const Text('Read All'),
                        ),
                        OutlinedButton.icon(
                          onPressed: _busy ? null : _deleteAllValues,
                          icon: const Icon(Icons.delete_sweep_outlined),
                          label: const Text('Delete All'),
                        ),
                        OutlinedButton.icon(
                          onPressed: _busy ? null : _checkProtectedData,
                          icon: const Icon(Icons.lock_clock_outlined),
                          label: const Text('Check Protected Data'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (_busy) const LinearProgressIndicator(),
                    if (_busy) const SizedBox(height: 12),
                    _StatusPanel(title: 'Result', value: _result),
                    const SizedBox(height: 12),
                    _StatusPanel(
                      title: 'Cupertino Status',
                      value: _cupertinoStatus,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Listener Example',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'The package can notify listener callbacks after write/delete operations. This card listens to "$_listenerKey".',
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: <Widget>[
                        FilledButton.icon(
                          onPressed: _busy ? null : _writeListenerKey,
                          icon: const Icon(Icons.notifications_active_outlined),
                          label: const Text('Write Listener Key'),
                        ),
                        OutlinedButton.icon(
                          onPressed: _busy ? null : _deleteListenerKey,
                          icon: const Icon(Icons.notifications_off_outlined),
                          label: const Text('Delete Listener Key'),
                        ),
                        OutlinedButton.icon(
                          onPressed: () {
                            if (_listenerRegistered) {
                              _unregisterListener();
                              _addLog('unregisterListener(key: $_listenerKey)');
                            } else {
                              _registerListener();
                            }
                            setState(() {
                              _result = _listenerRegistered
                                  ? 'Listener registered for $_listenerKey.'
                                  : 'Listener unregistered for $_listenerKey.';
                            });
                          },
                          icon: Icon(
                            _listenerRegistered
                                ? Icons.link_off_outlined
                                : Icons.link_outlined,
                          ),
                          label: Text(
                            _listenerRegistered
                                ? 'Unregister Listener'
                                : 'Register Listener',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Stored Entries Snapshot',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _entries.isEmpty
                          ? 'No stored entries were returned by readAll() for the active preset.'
                          : 'Current keys returned by readAll() for the active preset.',
                    ),
                    const SizedBox(height: 12),
                    if (_entries.isEmpty)
                      const Text('Storage is empty.')
                    else
                      ..._entries.entries.map((MapEntry<String, String> entry) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _StatusPanel(
                            title: entry.key,
                            value: entry.value,
                          ),
                        );
                      }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Event Log',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (_eventLog.isEmpty)
                      const Text('No events yet.')
                    else
                      ..._eventLog.map((String line) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Text(
                            line,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(fontFamily: 'monospace'),
                          ),
                        );
                      }),
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

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(description),
          ],
        ),
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
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                code.trim(),
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontFamily: 'monospace'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusPanel extends StatelessWidget {
  const _StatusPanel({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(value),
        ],
      ),
    );
  }
}
