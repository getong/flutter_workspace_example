import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:fl_chart/fl_chart.dart';
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
                if (state.items.isNotEmpty) ...<Widget>[
                  const SizedBox(height: 16),
                  _LayoutItemsChart(items: state.items),
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
                        'No data yet. Pull down or tap refresh to fetch from Dio.',
                      ),
                    ),
                  ),
                ...state.items.map((LayoutItem item) {
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
              'Dio Data Chart (fl_chart)',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            const Text(
              'Bars show fetched message length (characters) for the first 6 items.',
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
