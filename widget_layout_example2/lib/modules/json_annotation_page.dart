import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:widget_layout_example2/modules/json_annotation_models.dart';
import 'package:widget_layout_example2/app_navigation.dart';

@RoutePage(name: RouteName.jsonAnnotation)
class JsonAnnotationPage extends StatefulWidget {
  const JsonAnnotationPage({super.key});

  @override
  State<JsonAnnotationPage> createState() => _JsonAnnotationPageState();
}

class _JsonAnnotationPageState extends State<JsonAnnotationPage> {
  late JsonCatalogEntry _entry;
  late JsonIncomingUser _incomingUser;
  late final TextEditingController _jsonController;
  String _status =
      'Encode or decode the sample payload to inspect `@JsonSerializable` output.';

  static final JsonCatalogEntry _sample = JsonCatalogEntry(
    id: 'sku_001',
    title: 'Developer Toolkit',
    seller: const JsonSeller(
      handle: '@widgetsmith',
      rating: 4.8,
      region: 'APAC',
    ),
    prices: const <JsonPricePoint>[
      JsonPricePoint(tier: 'starter', unitPrice: 19.99, currency: 'USD'),
      JsonPricePoint(tier: 'team', unitPrice: 49.50, currency: 'USD'),
    ],
    metadata: <String, dynamic>{
      'featured': true,
      'channels': <String>['mobile', 'web'],
    },
    publishedAt: DateTime.parse('2026-04-11T09:30:00.000Z'),
  );

  static final Map<String, dynamic> _alternatePayload = <String, dynamic>{
    'id': 'sku_002',
    'title': 'Design System Pack',
    'seller': <String, dynamic>{'handle': '@designops', 'rating': 4.6},
    'prices': <Map<String, dynamic>>[
      <String, dynamic>{'tier': 'solo', 'unit_price': 1250, 'currency': 'USD'},
      <String, dynamic>{
        'tier': 'studio',
        'unit_price': 3599,
        'currency': 'USD',
      },
    ],
    'metadata': <String, dynamic>{
      'featured': false,
      'channels': <String>['desktop'],
      'includes_tokens': true,
    },
    'published_at': '2026-05-02T08:00:00.000Z',
  };

  static final Map<String, dynamic> _incomingUserPayload = <String, dynamic>{
    'id': 'user_42',
    'username': 'api_reader',
    'avatar_url': 'https://example.com/avatars/api_reader.png',
    'role': 'moderator',
  };

  @override
  void initState() {
    super.initState();
    _entry = _sample;
    _incomingUser = JsonIncomingUser.fromJson(_incomingUserPayload);
    _jsonController = TextEditingController(text: _prettyJson(_entry.toJson()));
  }

  @override
  void dispose() {
    _jsonController.dispose();
    super.dispose();
  }

  void _encodeCurrentEntry() {
    setState(() {
      _jsonController.text = _prettyJson(_entry.toJson());
      _status = 'Encoded the current model with toJson().';
    });
  }

  void _loadAlternatePayload() {
    setState(() {
      _jsonController.text = _prettyJson(_alternatePayload);
      _status = 'Loaded an alternate raw JSON payload.';
    });
  }

  void _decodeFromEditor() {
    try {
      final Map<String, dynamic> decoded =
          jsonDecode(_jsonController.text) as Map<String, dynamic>;
      final JsonCatalogEntry parsed = JsonCatalogEntry.fromJson(decoded);
      setState(() {
        _entry = parsed;
        _status = 'Decoded JSON into a strongly typed model with fromJson().';
      });
    } catch (error) {
      setState(() {
        _status = 'Failed to decode JSON: $error';
      });
    }
  }

  void _reloadIncomingUserExample() {
    setState(() {
      _incomingUser = JsonIncomingUser.fromJson(_incomingUserPayload);
      _status =
          'Decoded an incoming-only payload with `@JsonSerializable(createToJson: false)`.';
    });
  }

  String _prettyJson(Map<String, dynamic> json) {
    return const JsonEncoder.withIndent('  ').convert(json);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('json_annotation Module')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: <Widget>[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Generate typed JSON serialization with `json_annotation` and `json_serializable`.',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'This module demonstrates `@JsonSerializable`, `fieldRename`, '
                    '`explicitToJson`, nested model generation, '
                    '`@JsonKey(fromJson: ..., toJson: ...)`, '
                    '`createToJson: false`, plus real `fromJson` and `toJson` '
                    'round-trips.',
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
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
                    'Decoded Model Snapshot',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: <Widget>[
                      Chip(label: Text('id: ${_entry.id}')),
                      Chip(label: Text('title: ${_entry.title}')),
                      Chip(label: Text('seller: ${_entry.seller.handle}')),
                      Chip(
                        label: Text(
                          'publishedAt: ${_entry.publishedAt.toIso8601String()}',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ..._entry.prices.map(
                    (JsonPricePoint point) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(child: Text(point.tier[0])),
                      title: Text('${point.tier} tier'),
                      subtitle: Text(
                        'unitPrice=${point.unitPrice.toStringAsFixed(2)} ${point.currency}',
                      ),
                    ),
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
                    'Incoming-only Model Snapshot',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Use `createToJson: false` when a model is only decoded from an API or auth provider and never sent back.',
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: <Widget>[
                      Chip(label: Text('id: ${_incomingUser.id}')),
                      Chip(label: Text('username: ${_incomingUser.username}')),
                      Chip(label: Text('role: ${_incomingUser.role}')),
                      Chip(
                        label: Text(
                          'avatarUrl: ${_incomingUser.avatarUrl ?? 'null'}',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: _reloadIncomingUserExample,
                    icon: const Icon(Icons.download_for_offline_outlined),
                    label: const Text('Decode Incoming User'),
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
                    'Editable JSON Payload',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _jsonController,
                    maxLines: 18,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontFamily: 'monospace',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: <Widget>[
                      FilledButton.icon(
                        onPressed: _encodeCurrentEntry,
                        icon: const Icon(Icons.upload_file),
                        label: const Text('toJson'),
                      ),
                      FilledButton.icon(
                        onPressed: _decodeFromEditor,
                        icon: const Icon(Icons.download),
                        label: const Text('fromJson'),
                      ),
                      OutlinedButton.icon(
                        onPressed: _loadAlternatePayload,
                        icon: const Icon(Icons.swap_horiz),
                        label: const Text('Load Alternate JSON'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _JsonCodeCard(
            title: 'Core json_annotation Pattern',
            code: r'''
@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class JsonCatalogEntry {
  const JsonCatalogEntry({
    required this.id,
    required this.seller,
    required this.prices,
  });

  final String id;
  final JsonSeller seller;
  final List<JsonPricePoint> prices;

  factory JsonCatalogEntry.fromJson(Map<String, dynamic> json) =>
      _$JsonCatalogEntryFromJson(json);

  Map<String, dynamic> toJson() => _$JsonCatalogEntryToJson(this);
}
''',
          ),
          const SizedBox(height: 16),
          _JsonCodeCard(
            title: 'Incoming-only Pattern',
            code: r'''
@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class JsonIncomingUser {
  const JsonIncomingUser({
    required this.id,
    required this.username,
    this.avatarUrl,
    required this.role,
  });

  final String id;
  final String username;

  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;

  final String role;

  factory JsonIncomingUser.fromJson(Map<String, dynamic> json) =>
      _$JsonIncomingUserFromJson(json);
}
''',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.router.replacePath('/'),
        icon: const Icon(Icons.home),
        label: const Text('Home'),
      ),
    );
  }
}

class _JsonCodeCard extends StatelessWidget {
  const _JsonCodeCard({required this.title, required this.code});

  final String title;
  final String code;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            SelectableText(
              code,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
