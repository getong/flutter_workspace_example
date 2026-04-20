import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';

import 'package:widget_layout_example2/modules/built_value_models.dart';

@RoutePage(name: 'BuiltValueRoute')
class BuiltValuePage extends StatefulWidget {
  const BuiltValuePage({super.key});

  @override
  State<BuiltValuePage> createState() => _BuiltValuePageState();
}

class _BuiltValuePageState extends State<BuiltValuePage> {
  static final BuiltValueDemoPackage _sample = BuiltValueDemoPackage(
    (BuiltValueDemoPackageBuilder builder) => builder
      ..id = 'pkg_sharekit'
      ..packageName = 'share_plus'
      ..maintainer = 'Flutter Community'
      ..status = BuiltValueReleaseStatus.review
      ..weeklyDownloads = 184200
      ..updatedAt = DateTime.parse('2026-04-20T08:15:00.000Z')
      ..badges.addAll(<BuiltValueFeatureBadge>[
        BuiltValueFeatureBadge(
          (BuiltValueFeatureBadgeBuilder badge) => badge
            ..label = 'immutable'
            ..tone = 'primary',
        ),
        BuiltValueFeatureBadge(
          (BuiltValueFeatureBadgeBuilder badge) => badge
            ..label = 'codegen'
            ..tone = 'accent',
        ),
      ]),
  );

  static final Map<String, dynamic> _alternatePayload = <String, dynamic>{
    'id': 'pkg_pagination',
    'package_name': 'infinite_scroll_pagination',
    'maintainer': 'Widget Systems',
    'status': 'shipped',
    'weekly_downloads': 92800,
    'badges': <Map<String, String>>[
      <String, String>{'label': 'api-ready', 'tone': 'success'},
      <String, String>{'label': 'typed', 'tone': 'neutral'},
      <String, String>{'label': 'fast-scroll', 'tone': 'warning'},
    ],
    'updated_at': '2026-04-18T02:45:00.000Z',
  };

  late BuiltValueDemoPackage _package;
  late final TextEditingController _jsonController;
  String _status =
      'Inspect immutable updates, builders, enum values, and JSON serialization.';

  @override
  void initState() {
    super.initState();
    _package = _sample;
    _jsonController = TextEditingController(
      text: _prettyJson(_package.toJson()),
    );
  }

  @override
  void dispose() {
    _jsonController.dispose();
    super.dispose();
  }

  String _prettyJson(Map<String, dynamic> json) {
    return const JsonEncoder.withIndent('  ').convert(json);
  }

  void _encodeCurrentModel() {
    setState(() {
      _jsonController.text = _prettyJson(_package.toJson());
      _status = 'Serialized the current immutable model with built_value.';
    });
  }

  void _decodeFromEditor() {
    try {
      final Map<String, dynamic> payload =
          jsonDecode(_jsonController.text) as Map<String, dynamic>;
      setState(() {
        _package = BuiltValueDemoPackage.fromJson(payload);
        _status = 'Deserialized JSON back into a typed built_value model.';
      });
    } catch (error) {
      setState(() {
        _status = 'Failed to decode payload: $error';
      });
    }
  }

  void _loadAlternatePayload() {
    setState(() {
      _jsonController.text = _prettyJson(_alternatePayload);
      _status = 'Loaded a second API-style payload that uses wire names.';
    });
  }

  void _promoteRelease() {
    setState(() {
      _package = _package.rebuild((BuiltValueDemoPackageBuilder builder) {
        builder
          ..status = BuiltValueReleaseStatus.shipped
          ..weeklyDownloads = _package.weeklyDownloads + 24000
          ..updatedAt = DateTime.now().toUtc()
          ..badges.add(
            BuiltValueFeatureBadge(
              (BuiltValueFeatureBadgeBuilder badge) => badge
                ..label = 'release-ready'
                ..tone = 'success',
            ),
          );
      });
      _status =
          'Used rebuild() to create a new immutable instance with updated fields.';
    });
  }

  void _cloneWithBuilder() {
    final BuiltValueDemoPackageBuilder builder = _package.toBuilder();
    builder
      ..maintainer = 'Typed Data Team'
      ..badges = ListBuilder<BuiltValueFeatureBadge>(<BuiltValueFeatureBadge>[
        ..._package.badges,
        BuiltValueFeatureBadge(
          (BuiltValueFeatureBadgeBuilder badge) => badge
            ..label = 'builder-copy'
            ..tone = 'neutral',
        ),
      ]);

    setState(() {
      _package = builder.build();
      _status =
          'Cloned the model with toBuilder(), then built a separate immutable value.';
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('built_value Module')),
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
                      'built_value generates immutable value objects, builders, enum classes, equality, and optional serializers.',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'This module demonstrates `Built<>`, `EnumClass`, `BuiltList`, builder defaults, validation, `rebuild()`, `toBuilder()`, and JSON round-tripping with `StandardJsonPlugin`.',
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 12),
                    Text(_status),
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
                      'Current Immutable Snapshot',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: <Widget>[
                        Chip(label: Text('id: ${_package.id}')),
                        Chip(label: Text('package: ${_package.packageName}')),
                        Chip(label: Text('status: ${_package.status.name}')),
                        Chip(
                          label: Text('downloads: ${_package.weeklyDownloads}'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text('Maintainer: ${_package.maintainer}'),
                    const SizedBox(height: 8),
                    Text('Updated: ${_package.updatedAt.toIso8601String()}'),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _package.badges
                          .map(
                            (BuiltValueFeatureBadge badge) => Chip(
                              avatar: CircleAvatar(
                                backgroundColor: _badgeColor(badge.tone),
                              ),
                              label: Text('${badge.label} · ${badge.tone}'),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: <Widget>[
                        FilledButton.icon(
                          onPressed: _promoteRelease,
                          icon: const Icon(Icons.rocket_launch_outlined),
                          label: const Text('rebuild() Update'),
                        ),
                        OutlinedButton.icon(
                          onPressed: _cloneWithBuilder,
                          icon: const Icon(Icons.copy_all_outlined),
                          label: const Text('toBuilder() Clone'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _BuiltValueCodeCard(
              title: 'Core built_value Pattern',
              code: r'''
abstract class DemoPackage
    implements Built<DemoPackage, DemoPackageBuilder> {
  factory DemoPackage([void Function(DemoPackageBuilder) updates]) =
      _$DemoPackage;

  DemoPackage._();

  String get id;
  BuiltList<FeatureBadge> get badges;

  @BuiltValueHook(initializeBuilder: true)
  static void _initializeBuilder(DemoPackageBuilder b) =>
      b..status = ReleaseStatus.review;
}
''',
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Editable JSON',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _jsonController,
                      maxLines: 16,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontFamily: 'monospace',
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: <Widget>[
                        FilledButton.icon(
                          onPressed: _encodeCurrentModel,
                          icon: const Icon(Icons.upload_file_outlined),
                          label: const Text('Serialize'),
                        ),
                        FilledButton.icon(
                          onPressed: _decodeFromEditor,
                          icon: const Icon(Icons.download_outlined),
                          label: const Text('Deserialize'),
                        ),
                        OutlinedButton.icon(
                          onPressed: _loadAlternatePayload,
                          icon: const Icon(Icons.swap_horiz),
                          label: const Text('Load Alternate Payload'),
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

  Color _badgeColor(String tone) {
    switch (tone) {
      case 'primary':
        return const Color(0xFF2563EB);
      case 'accent':
        return const Color(0xFF7C3AED);
      case 'success':
        return const Color(0xFF16A34A);
      case 'warning':
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFF6B7280);
    }
  }
}

class _BuiltValueCodeCard extends StatelessWidget {
  const _BuiltValueCodeCard({required this.title, required this.code});

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
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                code,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  color: Colors.white,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
