import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

@RoutePage(name: 'PackageInfoPlusRoute')
class PackageInfoPlusPage extends StatefulWidget {
  const PackageInfoPlusPage({super.key});

  @override
  State<PackageInfoPlusPage> createState() => _PackageInfoPlusPageState();
}

class _PackageInfoPlusPageState extends State<PackageInfoPlusPage> {
  PackageInfo? _packageInfo;
  bool _isLoading = true;
  String _status =
      'Loading application metadata from the current platform bundle.';

  @override
  void initState() {
    super.initState();
    _loadPackageInfo();
  }

  Future<void> _loadPackageInfo() async {
    setState(() {
      _isLoading = true;
      _status = 'Refreshing package metadata from the platform.';
    });

    try {
      final PackageInfo info = await PackageInfo.fromPlatform();

      if (!mounted) {
        return;
      }

      setState(() {
        _packageInfo = info;
        _isLoading = false;
        _status =
            'Loaded app name, package id, version, build number, and install metadata.';
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _status = 'Failed to load package metadata: $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final PackageInfo? info = _packageInfo;

    return Scaffold(
      appBar: AppBar(title: const Text('package_info_plus Module')),
      body: SelectionArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(24),
                children: <Widget>[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'package_info_plus reads versioning and bundle metadata from the current platform target.',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'This module demonstrates `PackageInfo.fromPlatform()` plus the fields most apps use for diagnostics, about screens, and release banners.',
                            style: theme.textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 12),
                          Text(_status),
                          const SizedBox(height: 16),
                          FilledButton.icon(
                            onPressed: _loadPackageInfo,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Refresh Platform Info'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (info != null) ...<Widget>[
                    _MetadataCard(
                      title: 'Identity',
                      rows: <_MetadataRow>[
                        _MetadataRow(label: 'App Name', value: info.appName),
                        _MetadataRow(
                          label: 'Package Name',
                          value: info.packageName,
                        ),
                        _MetadataRow(label: 'Version', value: info.version),
                        _MetadataRow(
                          label: 'Build Number',
                          value: info.buildNumber,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _MetadataCard(
                      title: 'Extended Metadata',
                      rows: <_MetadataRow>[
                        _MetadataRow(
                          label: 'Build Signature',
                          value: info.buildSignature.isEmpty
                              ? 'Unavailable on this platform'
                              : info.buildSignature,
                        ),
                        _MetadataRow(
                          label: 'Installer Store',
                          value: info.installerStore ?? 'Unavailable',
                        ),
                        _MetadataRow(
                          label: 'Install Time',
                          value:
                              info.installTime?.toIso8601String() ??
                              'Unavailable',
                        ),
                        _MetadataRow(
                          label: 'Update Time',
                          value:
                              info.updateTime?.toIso8601String() ??
                              'Unavailable',
                        ),
                      ],
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
                                color: const Color(0xFF111827),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                r'''final PackageInfo info = await PackageInfo.fromPlatform();

print(info.appName);
print(info.packageName);
print('${info.version}+${info.buildNumber}');''',
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

class _MetadataCard extends StatelessWidget {
  const _MetadataCard({required this.title, required this.rows});

  final String title;
  final List<_MetadataRow> rows;

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
            ...rows.map(
              (_MetadataRow row) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: 140,
                      child: Text(
                        row.label,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Expanded(child: Text(row.value)),
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

class _MetadataRow {
  const _MetadataRow({required this.label, required this.value});

  final String label;
  final String value;
}
