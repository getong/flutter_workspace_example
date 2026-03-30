import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../data/local/app_database.dart';
import '../../data/local/drift_hydrated_storage.dart';
import '../../domain/layout_item.dart';
import '../layout_catalog_bloc.dart';

class LayoutHomePage extends StatelessWidget {
  const LayoutHomePage({required this.hydratedStorage, super.key});

  final DriftHydratedStorage hydratedStorage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HydratedBloc + Drift + Dio'),
        actions: <Widget>[
          IconButton(
            tooltip: 'Refresh from API',
            onPressed: () {
              context.read<LayoutCatalogBloc>().add(
                const LayoutCatalogRefreshRequested(),
              );
            },
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            tooltip: 'Read raw rows from Drift',
            onPressed: () => _showDriftRows(context),
            icon: const Icon(Icons.storage),
          ),
        ],
      ),
      body: BlocBuilder<LayoutCatalogBloc, LayoutCatalogState>(
        builder: (BuildContext context, LayoutCatalogState state) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<LayoutCatalogBloc>().add(
                const LayoutCatalogRefreshRequested(),
              );
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: <Widget>[
                _SummaryCard(state: state),
                const SizedBox(height: 16),
                if (state.status == LayoutCatalogStatus.loading)
                  const LinearProgressIndicator(),
                if (state.status == LayoutCatalogStatus.failure &&
                    state.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Card(
                      color: Theme.of(context).colorScheme.errorContainer,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    'Dio Error',
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onErrorContainer,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  tooltip: 'Copy error',
                                  onPressed: () async {
                                    await Clipboard.setData(
                                      ClipboardData(text: state.errorMessage!),
                                    );
                                    if (!context.mounted) {
                                      return;
                                    }
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Error copied'),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.copy),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            SelectableText(
                              state.errorMessage!,
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onErrorContainer,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                if (state.items.isEmpty &&
                    state.status != LayoutCatalogStatus.loading)
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'No data yet. Pull down or tap refresh to fetch from Dio.',
                      ),
                    ),
                  ),
                ...state.items.map((LayoutItem item) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: _tileColor(item.kind, item.id),
                          child: Icon(
                            _tileIcon(item.kind),
                            color: Colors.white,
                          ),
                        ),
                        title: Text(item.title),
                        subtitle: Text('/layouts/${item.slug}'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () => context.go('/layouts/${item.slug}'),
                      ),
                    ),
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _showDriftRows(BuildContext context) async {
    final List<PersistedHydratedRow> rows = await hydratedStorage.readRows();
    if (!context.mounted) {
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        if (rows.isEmpty) {
          return const SizedBox(
            height: 180,
            child: Center(child: Text('No hydrated rows in drift yet.')),
          );
        }

        return SafeArea(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: rows.length,
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(height: 20),
            itemBuilder: (BuildContext context, int index) {
              final PersistedHydratedRow row = rows[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(row.key, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 6),
                  Text(
                    'updated: ${row.updatedAt.toIso8601String()}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    row.value,
                    maxLines: 10,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Color _tileColor(LayoutKind kind, int id) {
    if (kind == LayoutKind.row) {
      return Colors.orange.shade600;
    }
    return id % 3 == 0 ? Colors.teal.shade600 : Colors.indigo.shade600;
  }

  IconData _tileIcon(LayoutKind kind) {
    return kind == LayoutKind.row ? Icons.view_week : Icons.view_stream;
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.state});

  final LayoutCatalogState state;

  @override
  Widget build(BuildContext context) {
    final String source = state.loadedFromDrift ? 'drift (hydrated)' : 'dio';
    final String status = state.status.name;
    final String updatedAt = state.lastUpdatedAt?.toIso8601String() ?? 'n/a';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Data Pipeline',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            const Text(
              'Dio fetches API data, HydratedBloc persists state to Drift.',
            ),
            const SizedBox(height: 10),
            Text('status: $status'),
            Text('source: $source'),
            Text('items: ${state.items.length}'),
            Text('lastUpdatedAt: $updatedAt'),
          ],
        ),
      ),
    );
  }
}
