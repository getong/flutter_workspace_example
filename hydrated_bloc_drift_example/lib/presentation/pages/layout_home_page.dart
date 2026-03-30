import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../data/local/app_database.dart';
import '../../data/repositories/layout_catalog_repository.dart';
import '../../domain/layout_item.dart';
import '../layout_catalog_bloc.dart';

class LayoutHomePage extends StatelessWidget {
  const LayoutHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HydratedBloc + Drift + Dio'),
        actions: <Widget>[
          IconButton(
            tooltip: 'Open URL fetch page',
            onPressed: () => context.go('/fetch'),
            icon: const Icon(Icons.link),
          ),
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
            tooltip: 'Read cached rows from Drift',
            onPressed: () => _showDriftRows(context),
            icon: const Icon(Icons.storage),
          ),
        ],
      ),
      body: BlocBuilder<LayoutCatalogBloc, LayoutCatalogState>(
        builder: (BuildContext context, LayoutCatalogState state) {
          final List<LayoutItem> visibleItems = state.visibleItems;

          return RefreshIndicator(
            onRefresh: () async {
              context.read<LayoutCatalogBloc>().add(
                const LayoutCatalogRefreshRequested(),
              );
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: <Widget>[
                _SummaryCard(
                  state: state,
                  visibleItemCount: visibleItems.length,
                ),
                const SizedBox(height: 16),
                _FilterCard(selectedFilter: state.filter),
                if (visibleItems.isNotEmpty) ...<Widget>[
                  const SizedBox(height: 16),
                  _LayoutItemsChart(items: visibleItems),
                ],
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
                        'No data cached yet. Pull down or tap refresh to fetch from Dio and store it in Drift.',
                      ),
                    ),
                  ),
                if (state.items.isNotEmpty && visibleItems.isEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'No layouts match the ${_filterLabel(state.filter).toLowerCase()} filter.',
                      ),
                    ),
                  ),
                ...visibleItems.map((LayoutItem item) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Card(
                      child: ListTile(
                        isThreeLine: true,
                        leading: CircleAvatar(
                          backgroundColor: _tileColor(item.kind, item.id),
                          child: Icon(
                            _tileIcon(item.kind),
                            color: Colors.white,
                          ),
                        ),
                        title: Text(item.title),
                        subtitle: Text(
                          item.message.isEmpty
                              ? '/layouts/${item.slug}'
                              : '${item.message}\n/layouts/${item.slug}',
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
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
    final LayoutCatalogRepository repository = context
        .read<LayoutCatalogRepository>();
    final List<PersistedLayoutCatalogRow> rows = await repository
        .readCachedRows();
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
            child: Center(child: Text('No layout rows cached in Drift yet.')),
          );
        }

        return SafeArea(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: rows.length,
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(height: 20),
            itemBuilder: (BuildContext context, int index) {
              final PersistedLayoutCatalogRow row = rows[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    row.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 6),
                  Text('slug: ${row.slug}'),
                  Text('kind: ${row.kind.name}'),
                  Text(
                    'cached: ${row.fetchedAt.toIso8601String()}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    row.message,
                    maxLines: 6,
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
  const _SummaryCard({required this.state, required this.visibleItemCount});

  final LayoutCatalogState state;
  final int visibleItemCount;

  @override
  Widget build(BuildContext context) {
    final String source = switch (state.source) {
      LayoutCatalogSource.driftCache => 'drift cache',
      LayoutCatalogSource.network => 'dio -> drift cache',
      LayoutCatalogSource.none => 'n/a',
    };
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
              'Drift caches layout rows for bootstrap and offline reuse. HydratedBloc only persists the selected filter for this page.',
            ),
            const SizedBox(height: 10),
            Text('status: $status'),
            Text('source: $source'),
            Text('filter: ${_filterLabel(state.filter)}'),
            Text('visible items: $visibleItemCount / ${state.items.length}'),
            Text('lastUpdatedAt: $updatedAt'),
          ],
        ),
      ),
    );
  }
}

class _FilterCard extends StatelessWidget {
  const _FilterCard({required this.selectedFilter});

  final LayoutCatalogFilter selectedFilter;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Home Page Filter',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            const Text(
              'This choice is persisted by HydratedBloc and restored on the next app launch.',
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: LayoutCatalogFilter.values.map((
                LayoutCatalogFilter filter,
              ) {
                return ChoiceChip(
                  label: Text(_filterLabel(filter)),
                  selected: selectedFilter == filter,
                  onSelected: (_) {
                    context.read<LayoutCatalogBloc>().add(
                      LayoutCatalogFilterChanged(filter),
                    );
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _LayoutItemsChart extends StatelessWidget {
  const _LayoutItemsChart({required this.items});

  final List<LayoutItem> items;

  @override
  Widget build(BuildContext context) {
    final List<LayoutItem> chartItems = items.take(6).toList();
    final List<double> values = chartItems
        .map((LayoutItem item) => item.message.length.toDouble())
        .toList();
    final double maxValue = values.isEmpty
        ? 10
        : values.reduce((double a, double b) => a > b ? a : b);
    final double maxY = (maxValue + 10).clamp(10, 5000).toDouble();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Cached Layout Chart',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            const Text(
              'Bars show cached message length for the first 6 visible items.',
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 220,
              child: BarChart(
                BarChartData(
                  maxY: maxY,
                  gridData: FlGridData(show: true, drawVerticalLine: false),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          final int index = value.toInt();
                          if (index < 0 || index >= chartItems.length) {
                            return const SizedBox.shrink();
                          }
                          return SideTitleWidget(
                            meta: meta,
                            child: Text(
                              '#${chartItems[index].id}',
                              style: const TextStyle(fontSize: 10),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  barGroups: List<BarChartGroupData>.generate(
                    chartItems.length,
                    (int index) {
                      final LayoutItem item = chartItems[index];
                      return BarChartGroupData(
                        x: index,
                        barRods: <BarChartRodData>[
                          BarChartRodData(
                            toY: item.message.length.toDouble(),
                            width: 18,
                            borderRadius: BorderRadius.circular(5),
                            color: item.kind == LayoutKind.row
                                ? Colors.orange
                                : Colors.teal,
                          ),
                        ],
                      );
                    },
                  ),
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem:
                          (
                            BarChartGroupData group,
                            int groupIndex,
                            BarChartRodData rod,
                            int rodIndex,
                          ) {
                            final int index = group.x.toInt();
                            if (index < 0 || index >= chartItems.length) {
                              return null;
                            }
                            final LayoutItem item = chartItems[index];
                            return BarTooltipItem(
                              '${item.title}\n${rod.toY.toInt()} chars',
                              const TextStyle(color: Colors.white),
                            );
                          },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _filterLabel(LayoutCatalogFilter filter) {
  return switch (filter) {
    LayoutCatalogFilter.all => 'All Layouts',
    LayoutCatalogFilter.row => 'Row Layouts',
    LayoutCatalogFilter.column => 'Column Layouts',
  };
}
