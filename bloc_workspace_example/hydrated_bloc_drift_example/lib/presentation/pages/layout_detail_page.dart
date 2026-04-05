import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';

import '../../domain/layout_item.dart';
import '../layout_catalog_bloc.dart';

class LayoutDetailPage extends StatelessWidget {
  const LayoutDetailPage({required this.slug, super.key});

  final String slug;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LayoutCatalogBloc, LayoutCatalogState>(
      builder: (BuildContext context, LayoutCatalogState state) {
        final LayoutItem? item = context.read<LayoutCatalogBloc>().findBySlug(
          slug,
        );

        if (item == null && state.status == LayoutCatalogStatus.loading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (item == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Layout not found')),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('No layout found for slug: $slug'),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: () => context.read<LayoutCatalogBloc>().add(
                      const LayoutCatalogRefreshRequested(),
                    ),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Fetch from Dio'),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(title: Text(item.title)),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              Text('Dynamic route: /layouts/${item.slug}'),
              const SizedBox(height: 16),
              SizedBox(
                height: 260,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _kindColor(item.kind).withAlpha(26),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _kindColor(item.kind), width: 2),
                  ),
                  child: _buildChartPreview(item),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Fetched text from Dio:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              SelectableText(item.message),
            ],
          ),
          persistentFooterButtons: <Widget>[
            TextButton.icon(
              onPressed: () => context.go('/'),
              icon: const Icon(Icons.home),
              label: const Text('Back Home'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildChartPreview(LayoutItem item) {
    if (item.kind == LayoutKind.row) {
      return _buildBarChart(item);
    }
    return _buildLineChart(item);
  }

  Widget _buildBarChart(LayoutItem item) {
    final List<String> words = item.message
        .split(RegExp(r'\s+'))
        .where((String word) => word.isNotEmpty)
        .take(6)
        .toList();
    final List<String> buckets = words.isEmpty ? <String>[item.title] : words;

    final List<double> values = buckets
        .map((String word) => word.length.toDouble())
        .toList();
    final double maxValue = values.reduce(
      (double a, double b) => a > b ? a : b,
    );
    final double maxY = (maxValue + 2).clamp(4, 40).toDouble();

    return BarChart(
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
              reservedSize: 28,
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
                if (index < 0 || index >= buckets.length) {
                  return const SizedBox.shrink();
                }
                final String label = buckets[index];
                return SideTitleWidget(
                  meta: meta,
                  child: Text(
                    label.length > 4 ? label.substring(0, 4) : label,
                    style: const TextStyle(fontSize: 10),
                  ),
                );
              },
            ),
          ),
        ),
        barGroups: List<BarChartGroupData>.generate(
          buckets.length,
          (int index) => BarChartGroupData(
            x: index,
            barRods: <BarChartRodData>[
              BarChartRodData(
                toY: values[index],
                width: 18,
                borderRadius: BorderRadius.circular(4),
                color: Colors.orange,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLineChart(LayoutItem item) {
    final String text = item.message.isEmpty ? item.title : item.message;
    final List<int> runes = text.runes.take(12).toList();
    final List<int> seeds = runes.isEmpty ? <int>[10, 18, 13, 24, 16] : runes;

    final List<FlSpot> spots = <FlSpot>[
      for (int i = 0; i < seeds.length; i++)
        FlSpot(i.toDouble(), ((seeds[i] % 30) + 5).toDouble()),
    ];
    final double maxY =
        spots
            .map((FlSpot spot) => spot.y)
            .reduce((double a, double b) => a > b ? a : b) +
        4;

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: (spots.length - 1).toDouble(),
        minY: 0,
        maxY: maxY,
        gridData: const FlGridData(show: true),
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
              reservedSize: 28,
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
              interval: 1,
              getTitlesWidget: (double value, TitleMeta meta) {
                return SideTitleWidget(
                  meta: meta,
                  child: Text(
                    value.toInt().toString(),
                    style: const TextStyle(fontSize: 10),
                  ),
                );
              },
            ),
          ),
        ),
        lineBarsData: <LineChartBarData>[
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Colors.teal,
            barWidth: 3,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.teal.withAlpha(40),
            ),
          ),
        ],
      ),
    );
  }

  Color _kindColor(LayoutKind kind) {
    return kind == LayoutKind.row ? Colors.orange : Colors.teal;
  }
}
