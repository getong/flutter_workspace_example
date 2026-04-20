import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

@RoutePage()
class PermissionHandlerPage extends StatefulWidget {
  const PermissionHandlerPage({super.key});

  @override
  State<PermissionHandlerPage> createState() => _PermissionHandlerPageState();
}

class _PermissionHandlerPageState extends State<PermissionHandlerPage> {
  static const List<_PermissionItem> _items = <_PermissionItem>[
    _PermissionItem(
      label: 'Camera',
      permission: Permission.camera,
      description: 'Common for image capture and scanning flows.',
    ),
    _PermissionItem(
      label: 'Location When In Use',
      permission: Permission.locationWhenInUse,
      description: 'Useful for maps and nearby-search features.',
    ),
    _PermissionItem(
      label: 'Microphone',
      permission: Permission.microphone,
      description: 'Used by voice notes and recording features.',
    ),
    _PermissionItem(
      label: 'Notification',
      permission: Permission.notification,
      description: 'Push and local notification authorization.',
    ),
    _PermissionItem(
      label: 'Photos',
      permission: Permission.photos,
      description: 'Media library access, especially relevant on Apple OSes.',
    ),
  ];

  Permission _activePermission = Permission.locationWhenInUse;
  Map<Permission, PermissionStatus> _statuses =
      <Permission, PermissionStatus>{};
  Map<String, String> _activeChecks = <String, String>{};
  String _status =
      'Refresh and request permissions to inspect real status transitions.';
  final List<String> _log = <String>[];

  @override
  void initState() {
    super.initState();
    _refreshStatuses();
  }

  _PermissionItem get _activeItem => _items.firstWhere(
    (_PermissionItem item) => item.permission == _activePermission,
  );

  String _enumLabel(Object value) => value.toString().split('.').last;

  void _pushLog(String message) {
    final DateTime now = DateTime.now();
    final String timestamp =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
    _log.insert(0, '$timestamp  $message');
    if (_log.length > 10) {
      _log.removeRange(10, _log.length);
    }
  }

  Future<void> _refreshStatuses() async {
    try {
      final Map<Permission, PermissionStatus> nextStatuses =
          <Permission, PermissionStatus>{};
      for (final _PermissionItem item in _items) {
        nextStatuses[item.permission] = await item.permission.status;
      }

      final Map<String, String> checks = await _collectChecks(
        _activePermission,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _statuses = nextStatuses;
        _activeChecks = checks;
        _status = 'Loaded current permission statuses from the plugin.';
        _pushLog('Refreshed all tracked permissions.');
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _status = 'Failed to refresh permission statuses: $error';
        _pushLog('Refresh failed: $error');
      });
    }
  }

  Future<Map<String, String>> _collectChecks(Permission permission) async {
    ServiceStatus? serviceStatus;
    if (permission is PermissionWithService) {
      try {
        serviceStatus = await permission.serviceStatus;
      } catch (_) {
        serviceStatus = null;
      }
    }

    return <String, String>{
      'status': _enumLabel(await permission.status),
      'isGranted': '${await permission.isGranted}',
      'isDenied': '${await permission.isDenied}',
      'isPermanentlyDenied': '${await permission.isPermanentlyDenied}',
      'isRestricted': '${await permission.isRestricted}',
      'isLimited': '${await permission.isLimited}',
      'isProvisional': '${await permission.isProvisional}',
      'shouldShowRequestRationale':
          '${await permission.shouldShowRequestRationale}',
      'serviceStatus': serviceStatus == null
          ? 'n/a'
          : _enumLabel(serviceStatus),
    };
  }

  Future<void> _setActivePermission(Permission permission) async {
    setState(() {
      _activePermission = permission;
      _status = 'Inspecting `${_enumLabel(permission)}`.';
    });

    try {
      final Map<String, String> checks = await _collectChecks(permission);
      if (!mounted) {
        return;
      }

      setState(() {
        _activeChecks = checks;
        _pushLog('Switched active permission to ${_enumLabel(permission)}.');
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _status = 'Failed to inspect `${_enumLabel(permission)}`: $error';
        _pushLog('Inspection failed for ${_enumLabel(permission)}.');
      });
    }
  }

  Future<void> _requestActivePermission() async {
    try {
      final PermissionStatus result = await _activePermission
          .onGrantedCallback(() {
            _pushLog(
              '${_enumLabel(_activePermission)} granted callback fired.',
            );
          })
          .onDeniedCallback(() {
            _pushLog('${_enumLabel(_activePermission)} denied callback fired.');
          })
          .onPermanentlyDeniedCallback(() {
            _pushLog(
              '${_enumLabel(_activePermission)} permanently denied callback fired.',
            );
          })
          .onRestrictedCallback(() {
            _pushLog(
              '${_enumLabel(_activePermission)} restricted callback fired.',
            );
          })
          .onLimitedCallback(() {
            _pushLog(
              '${_enumLabel(_activePermission)} limited callback fired.',
            );
          })
          .onProvisionalCallback(() {
            _pushLog(
              '${_enumLabel(_activePermission)} provisional callback fired.',
            );
          })
          .request();

      final Map<String, String> checks = await _collectChecks(
        _activePermission,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _statuses = <Permission, PermissionStatus>{
          ..._statuses,
          _activePermission: result,
        };
        _activeChecks = checks;
        _status =
            'Requested `${_enumLabel(_activePermission)}` and received `${_enumLabel(result)}`.';
        _pushLog(
          'Requested ${_enumLabel(_activePermission)} -> ${_enumLabel(result)}.',
        );
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _status =
            'Request failed for `${_enumLabel(_activePermission)}`: $error';
        _pushLog('Request failed for ${_enumLabel(_activePermission)}.');
      });
    }
  }

  Future<void> _requestBundle() async {
    try {
      final Map<Permission, PermissionStatus> results = await <Permission>[
        Permission.camera,
        Permission.microphone,
      ].request();

      if (!mounted) {
        return;
      }

      setState(() {
        _statuses = <Permission, PermissionStatus>{..._statuses, ...results};
        _status =
            'Batch request completed for camera and microphone permissions.';
        _pushLog(
          'Batch request -> '
          'camera=${_enumLabel(results[Permission.camera] ?? PermissionStatus.denied)}, '
          'microphone=${_enumLabel(results[Permission.microphone] ?? PermissionStatus.denied)}.',
        );
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _status = 'Batch permission request failed: $error';
        _pushLog('Batch request failed.');
      });
    }
  }

  Future<void> _openSystemSettings() async {
    try {
      final bool opened = await openAppSettings();
      if (!mounted) {
        return;
      }

      setState(() {
        _status = opened
            ? 'Opened the system app-settings screen.'
            : 'The system refused to open the app-settings screen.';
        _pushLog('openAppSettings() -> $opened');
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _status = 'Failed to open app settings: $error';
        _pushLog('openAppSettings failed.');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('permission_handler Module')),
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
                      'Use `permission_handler` to inspect permission state, trigger requests, and route users to settings.',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'This module demonstrates `status`, `request`, callback '
                      'hooks such as `onGrantedCallback`, shortcut getters like '
                      '`isGranted` and `isPermanentlyDenied`, '
                      '`shouldShowRequestRationale`, `serviceStatus`, batch '
                      'requests with `List<Permission>.request()`, and '
                      '`openAppSettings()`.',
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),
                    Text(_status),
                    const SizedBox(height: 12),
                    Text(
                      'Real permission behavior still depends on your app manifests, Info.plist entries, and the current platform.',
                      style: theme.textTheme.bodyMedium,
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
                      'Tracked Permissions',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ..._items.map(
                      (_PermissionItem item) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(item.label),
                        subtitle: Text(item.description),
                        trailing: Chip(
                          label: Text(
                            _enumLabel(
                              _statuses[item.permission] ??
                                  PermissionStatus.denied,
                            ),
                          ),
                        ),
                        onTap: () => _setActivePermission(item.permission),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: <Widget>[
                        FilledButton.icon(
                          onPressed: _refreshStatuses,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Refresh Statuses'),
                        ),
                        FilledButton.icon(
                          onPressed: _requestActivePermission,
                          icon: const Icon(Icons.security),
                          label: const Text('Request Active'),
                        ),
                        OutlinedButton.icon(
                          onPressed: _requestBundle,
                          icon: const Icon(Icons.layers_outlined),
                          label: const Text('Batch Request'),
                        ),
                        OutlinedButton.icon(
                          onPressed: _openSystemSettings,
                          icon: const Icon(Icons.settings_outlined),
                          label: const Text('Open App Settings'),
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
                      'Active Permission Detail',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _items
                          .map(
                            (_PermissionItem item) => FilterChip(
                              label: Text(item.label),
                              selected: _activePermission == item.permission,
                              onSelected: (_) =>
                                  _setActivePermission(item.permission),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _activeItem.description,
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _activeChecks.entries
                          .map(
                            (MapEntry<String, String> entry) => Chip(
                              label: Text('${entry.key}: ${entry.value}'),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _CodeCard(
              title: 'Core permission_handler Pattern',
              code: r'''
final Permission permission = Permission.locationWhenInUse;
final PermissionStatus status = await permission.status;
final bool rationale = await permission.shouldShowRequestRationale;

final PermissionStatus requestResult = await permission
    .onGrantedCallback(() {})
    .onDeniedCallback(() {})
    .request();

final Map<Permission, PermissionStatus> batchResult =
    await <Permission>[Permission.camera, Permission.microphone].request();

final bool openedSettings = await openAppSettings();
''',
            ),
            const SizedBox(height: 16),
            _EventLogCard(entries: _log),
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

class _PermissionItem {
  const _PermissionItem({
    required this.label,
    required this.permission,
    required this.description,
  });

  final String label;
  final Permission permission;
  final String description;
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
              const Text('No permission events yet.')
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
