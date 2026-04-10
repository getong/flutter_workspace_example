import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/theme/app_theme.dart';
import '../bloc/catalog_bloc.dart';
import '../bloc/catalog_event.dart';
import '../bloc/catalog_state.dart';
import '../data/models/catalog_item.dart';
import 'widgets/catalog_header_card.dart';
import 'widgets/catalog_item_card.dart';

class CatalogPage extends StatelessWidget {
  const CatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cache Studio',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: <Widget>[
          IconButton(
            tooltip: 'Refresh',
            onPressed: () {
              context.read<CatalogBloc>().add(
                const CatalogRefreshRequested(force: true),
              );
            },
            icon: const Icon(Icons.sync_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<CatalogBloc, CatalogState>(
          builder: (BuildContext context, CatalogState state) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<CatalogBloc>().add(
                  const CatalogRefreshRequested(force: true),
                );
              },
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.sm,
                  AppSpacing.md,
                  AppSpacing.xl,
                ),
                children: <Widget>[
                  CatalogHeaderCard(
                    itemCount: state.items.length,
                    isRefreshing: state.isRefreshing,
                    isCacheExpired: state.isCacheExpired,
                    lastSyncAt: state.lastSyncAt,
                    cacheTtl: state.cacheTtl,
                    statusMessage: state.statusMessage,
                    onRefreshPressed: () {
                      context.read<CatalogBloc>().add(
                        const CatalogRefreshRequested(force: true),
                      );
                    },
                  ),
                  if (state.errorMessage != null) ...<Widget>[
                    const SizedBox(height: AppSpacing.md),
                    _ErrorBanner(message: state.errorMessage!),
                  ],
                  const SizedBox(height: AppSpacing.lg),
                  const Text(
                    'Cached catalogue',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Drift rows render immediately, and the refresh action only updates the local store.',
                    style: TextStyle(
                      color: AppColors.muted.withValues(alpha: 0.95),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  if (state.showInitialLoader)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (state.items.isEmpty)
                    const _EmptyCatalogState()
                  else
                    ...state.items.map(
                      (CatalogItem item) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: CatalogItemCard(item: item),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.read<CatalogBloc>().add(
            const CatalogRefreshRequested(force: true),
          );
        },
        backgroundColor: AppColors.forest,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.cloud_download_outlined),
        label: const Text('Force Refresh'),
      ),
    );
  }
}

class _EmptyCatalogState extends StatelessWidget {
  const _EmptyCatalogState();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'No cached entries yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            'Pull to refresh or tap the button below to seed drift from the fake remote datasource.',
            style: TextStyle(color: AppColors.muted, height: 1.45),
          ),
        ],
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: const Color(0xFFFDECEA),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF4C7C3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Icon(Icons.error_outline, color: AppColors.error),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: AppColors.error, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
