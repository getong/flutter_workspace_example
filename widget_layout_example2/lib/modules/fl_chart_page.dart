import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

class FlChartPage extends StatelessWidget {
  const FlChartPage({super.key});

  static const List<_PieChartDatum> _purchaserData = <_PieChartDatum>[
    _PieChartDatum('New', 42, Color(0xFF4CAF50)),
    _PieChartDatum('Returning', 33, Color(0xFF42A5F5)),
    _PieChartDatum('Enterprise', 25, Color(0xFFFFB300)),
  ];

  static const List<_PieChartDatum> _productData = <_PieChartDatum>[
    _PieChartDatum('Phones', 38, Color(0xFF7E57C2)),
    _PieChartDatum('Tablets', 22, Color(0xFF26A69A)),
    _PieChartDatum('Wearables', 18, Color(0xFFEF5350)),
    _PieChartDatum('Accessories', 22, Color(0xFF5C6BC0)),
  ];

  static const List<FlSpot> _lineSpots = <FlSpot>[
    FlSpot(1, 18),
    FlSpot(2, 24),
    FlSpot(3, 21),
    FlSpot(4, 30),
    FlSpot(5, 28),
    FlSpot(6, 36),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('fl_chart Module')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: <Widget>[
          const SelectableText(
            'fl_chart is useful for visualizing structured data with interactive Flutter charts. This example shows a line chart and two pie charts.',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),
          _ChartCard(
            title: 'Line Chart',
            description:
                'A line chart is useful for showing trends over time such as monthly revenue or signups.',
            child: SizedBox(
              height: 260,
              child: LineChart(
                LineChartData(
                  minX: 1,
                  maxX: 6,
                  minY: 0,
                  maxY: 40,
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 10,
                  ),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          const List<String> months = <String>[
                            '',
                            'Jan',
                            'Feb',
                            'Mar',
                            'Apr',
                            'May',
                            'Jun',
                          ];
                          return SideTitleWidget(
                            meta: meta,
                            child: Text(months[value.toInt()]),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 36,
                        interval: 10,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          return SideTitleWidget(
                            meta: meta,
                            child: Text('${value.toInt()}k'),
                          );
                        },
                      ),
                    ),
                  ),
                  lineTouchData: LineTouchData(enabled: true),
                  lineBarsData: <LineChartBarData>[
                    LineChartBarData(
                      spots: _lineSpots,
                      isCurved: true,
                      barWidth: 4,
                      color: Colors.indigo,
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.indigo.withValues(alpha: 0.16),
                      ),
                      dotData: FlDotData(
                        show: true,
                        getDotPainter:
                            (
                              FlSpot spot,
                              double percent,
                              LineChartBarData barData,
                              int index,
                            ) {
                              return FlDotCirclePainter(
                                radius: 4,
                                color: Colors.indigo,
                                strokeWidth: 2,
                                strokeColor: Colors.white,
                              );
                            },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _ChartCard(
            title: 'Pie Chart (Purchasers)',
            description:
                'This pie chart compares purchaser segments as a share of the total.',
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 220,
                  child: PieChart(
                    PieChartData(
                      centerSpaceRadius: 40,
                      sectionsSpace: 2,
                      sections: _purchaserData
                          .map(
                            (_PieChartDatum datum) => PieChartSectionData(
                              color: datum.color,
                              value: datum.value.toDouble(),
                              title: '${datum.value}%',
                              radius: 72,
                              titleStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ..._purchaserData.map(
                  (_PieChartDatum datum) => _LegendItem(datum),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _ChartCard(
            title: 'Pie Chart (Products)',
            description:
                'This pie chart compares product-category share in the catalog.',
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 220,
                  child: PieChart(
                    PieChartData(
                      centerSpaceRadius: 28,
                      sectionsSpace: 3,
                      sections: _productData
                          .map(
                            (_PieChartDatum datum) => PieChartSectionData(
                              color: datum.color,
                              value: datum.value.toDouble(),
                              title: '${datum.value}%',
                              radius: 78,
                              titleStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ..._productData.map(
                  (_PieChartDatum datum) => _LegendItem(datum),
                ),
              ],
            ),
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

class _ChartCard extends StatelessWidget {
  const _ChartCard({
    required this.title,
    required this.description,
    required this.child,
  });

  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            SelectableText(description),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem(this.datum);

  final _PieChartDatum datum;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: <Widget>[
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: datum.color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(child: SelectableText(datum.label)),
          SelectableText('${datum.value}%'),
        ],
      ),
    );
  }
}

class _PieChartDatum {
  const _PieChartDatum(this.label, this.value, this.color);

  final String label;
  final int value;
  final Color color;
}
