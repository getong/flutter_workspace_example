import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:widget_layout_example2/features/freezed_annotation/domain/entities/freezed_annotation_models.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';

@RoutePage(name: RouteName.freezedAnnotation)
class FreezedAnnotationPage extends StatefulWidget {
  const FreezedAnnotationPage({super.key});

  @override
  State<FreezedAnnotationPage> createState() => _FreezedAnnotationPageState();
}

class _FreezedAnnotationPageState extends State<FreezedAnnotationPage> {
  late FreezedSyncState _state;

  @override
  void initState() {
    super.initState();
    _state = FreezedSyncState.idle(profile: _sampleProfile);
  }

  static const FreezedProfile _sampleProfile = FreezedProfile(
    id: 'user_42',
    name: 'Alex Rivera',
    tags: <String>['mobile', 'design-system'],
    isPro: false,
    completedMissions: 4,
  );

  FreezedProfile get _profile => _state.when(
    idle: (FreezedProfile profile) => profile,
    syncing: (FreezedProfile profile, double progress) => profile,
    success: (FreezedProfile profile, DateTime syncedAt) => profile,
    failure: (FreezedProfile profile, String message) => profile,
  );

  void _replaceProfile(FreezedProfile profile) {
    setState(() {
      _state = _state.when(
        idle: (_) => FreezedSyncState.idle(profile: profile),
        syncing: (_, double progress) =>
            FreezedSyncState.syncing(profile: profile, progress: progress),
        success: (_, DateTime syncedAt) =>
            FreezedSyncState.success(profile: profile, syncedAt: syncedAt),
        failure: (_, String message) =>
            FreezedSyncState.failure(profile: profile, message: message),
      );
    });
  }

  void _upgradeProfile() {
    _replaceProfile(
      _profile.copyWith(
        isPro: true,
        completedMissions: _profile.completedMissions + 1,
      ),
    );
  }

  void _addTag() {
    _replaceProfile(
      _profile.copyWith(tags: <String>[..._profile.tags, 'freezed']),
    );
  }

  void _setSyncing() {
    setState(() {
      _state = FreezedSyncState.syncing(profile: _profile, progress: 0.25);
    });
  }

  void _advanceSync() {
    setState(() {
      _state = _state.maybeWhen(
        syncing: (FreezedProfile profile, double progress) {
          final double next = (progress + 0.25).clamp(0.0, 1.0);
          return FreezedSyncState.syncing(profile: profile, progress: next);
        },
        orElse: () =>
            FreezedSyncState.syncing(profile: _profile, progress: 0.5),
      );
    });
  }

  void _markSuccess() {
    setState(() {
      _state = FreezedSyncState.success(
        profile: _profile,
        syncedAt: DateTime.now(),
      );
    });
  }

  void _markFailure() {
    setState(() {
      _state = FreezedSyncState.failure(
        profile: _profile,
        message: 'Network timeout while uploading the sync batch.',
      );
    });
  }

  void _reset() {
    setState(() {
      _state = FreezedSyncState.idle(profile: _sampleProfile);
    });
  }

  String _statusLabel() {
    return _state.when(
      idle: (FreezedProfile profile) =>
          'Idle for ${profile.name} with ${profile.completedMissions} missions.',
      syncing: (FreezedProfile profile, double progress) =>
          'Syncing ${profile.name} at ${(progress * 100).round()}%.',
      success: (FreezedProfile profile, DateTime syncedAt) =>
          'Synced ${profile.name} at ${syncedAt.toIso8601String()}.',
      failure: (FreezedProfile profile, String message) =>
          'Failed for ${profile.name}: $message',
    );
  }

  Color _statusColor() {
    return _state.map(
      idle: (_) => const Color(0xFF1D4ED8),
      syncing: (_) => const Color(0xFF7C3AED),
      success: (_) => const Color(0xFF0F766E),
      failure: (_) => const Color(0xFFDC2626),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final FreezedProfile comparison = _profile.copyWith();
    final String prettyJson = const JsonEncoder.withIndent(
      '  ',
    ).convert(_state.toJson());

    return Scaffold(
      appBar: AppBar(title: const Text('freezed_annotation Module')),
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
                    'Generate immutable data classes, unions, `copyWith`, equality, and JSON support with `freezed_annotation`.',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'This module demonstrates `@freezed`, union states, '
                    '`when`, `map`, structural equality, generated `copyWith`, '
                    'and `toJson` / `fromJson` on real generated types.',
                    style: theme.textTheme.bodyLarge,
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
                    'Current State',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Chip(
                    label: Text(_statusLabel()),
                    backgroundColor: _statusColor().withValues(alpha: 0.12),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: <Widget>[
                      Chip(label: Text('name: ${_profile.name}')),
                      Chip(label: Text('isPro: ${_profile.isPro}')),
                      Chip(
                        label: Text('missions: ${_profile.completedMissions}'),
                      ),
                      Chip(label: Text('tags: ${_profile.tags.join(', ')}')),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Generated equality: copyWith() == original -> ${comparison == _profile}',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: <Widget>[
                  FilledButton.icon(
                    onPressed: _upgradeProfile,
                    icon: const Icon(Icons.workspace_premium_outlined),
                    label: const Text('copyWith Upgrade'),
                  ),
                  FilledButton.icon(
                    onPressed: _addTag,
                    icon: const Icon(Icons.sell_outlined),
                    label: const Text('Add Tag'),
                  ),
                  FilledButton.icon(
                    onPressed: _setSyncing,
                    icon: const Icon(Icons.sync),
                    label: const Text('Set Syncing'),
                  ),
                  OutlinedButton.icon(
                    onPressed: _advanceSync,
                    icon: const Icon(Icons.trending_up),
                    label: const Text('Advance Sync'),
                  ),
                  OutlinedButton.icon(
                    onPressed: _markSuccess,
                    icon: const Icon(Icons.done_all),
                    label: const Text('Success'),
                  ),
                  OutlinedButton.icon(
                    onPressed: _markFailure,
                    icon: const Icon(Icons.error_outline),
                    label: const Text('Failure'),
                  ),
                  OutlinedButton.icon(
                    onPressed: _reset,
                    icon: const Icon(Icons.replay),
                    label: const Text('Reset'),
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
                    'Serialized Union JSON',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SelectableText(
                    prettyJson,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontFamily: 'monospace',
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Round-trip type: ${FreezedSyncState.fromJson(_state.toJson()).runtimeType}',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _FreezedCodeCard(
            title: 'Core freezed_annotation Pattern',
            code: r'''
@freezed
class FreezedSyncState with _$FreezedSyncState {
  const factory FreezedSyncState.idle({
    required FreezedProfile profile,
  }) = _FreezedSyncStateIdle;

  const factory FreezedSyncState.success({
    required FreezedProfile profile,
    required DateTime syncedAt,
  }) = _FreezedSyncStateSuccess;

  factory FreezedSyncState.fromJson(Map<String, dynamic> json) =>
      _$FreezedSyncStateFromJson(json);
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

class _FreezedCodeCard extends StatelessWidget {
  const _FreezedCodeCard({required this.title, required this.code});

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
