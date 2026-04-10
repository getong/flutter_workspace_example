import 'package:flutter/material.dart';

import '../../../shared/theme/app_theme.dart';

class CatalogHeaderCard extends StatelessWidget {
  const CatalogHeaderCard({
    super.key,
    required this.itemCount,
    required this.isRefreshing,
    required this.isCacheExpired,
    required this.lastSyncAt,
    required this.cacheTtl,
    required this.statusMessage,
    required this.onRefreshPressed,
  });

  final int itemCount;
  final bool isRefreshing;
  final bool isCacheExpired;
  final DateTime? lastSyncAt;
  final Duration cacheTtl;
  final String statusMessage;
  final VoidCallback onRefreshPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: <Color>[AppColors.ink, AppColors.forest],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x3014213D),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Pull-through cache demo',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w700,
              height: 1.1,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          const Text(
            'No Firestore, no Firebase. Drift stores the catalogue, SharedPreferencesWithCache tracks freshness, and flutter_bloc coordinates the UI.',
            style: TextStyle(color: Color(0xFFEAE6DD), height: 1.5),
          ),
          const SizedBox(height: AppSpacing.lg),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: <Widget>[
              _StatPill(label: 'Rows', value: '$itemCount'),
              _StatPill(label: 'TTL', value: '${cacheTtl.inMinutes} min'),
              _StatPill(
                label: 'Mode',
                value: isRefreshing
                    ? 'Refreshing'
                    : isCacheExpired
                    ? 'Stale cache'
                    : 'Fresh cache',
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _MetaRow(
                  label: 'Last sync',
                  value: _formatTimestamp(lastSyncAt),
                ),
                const SizedBox(height: AppSpacing.sm),
                _MetaRow(label: 'Repository state', value: statusMessage),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          FilledButton.tonalIcon(
            onPressed: onRefreshPressed,
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.ink,
            ),
            icon: const Icon(Icons.auto_awesome),
            label: const Text('Fetch Remote Snapshot'),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime? value) {
    if (value == null) {
      return 'Never synced';
    }

    String twoDigits(int part) => part.toString().padLeft(2, '0');
    return '${value.year}-${twoDigits(value.month)}-${twoDigits(value.day)} '
        '${twoDigits(value.hour)}:${twoDigits(value.minute)}';
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: const TextStyle(color: Color(0xFFF9F7F2), fontSize: 12),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 104,
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFFD9D4CB),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(color: Colors.white, height: 1.4),
          ),
        ),
      ],
    );
  }
}
