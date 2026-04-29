import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:widget_layout_example2/app_navigation.dart';
import 'package:widget_layout_example2/modules/fl_chart_demo/bar_chart_widget.dart';
import 'package:widget_layout_example2/modules/fl_chart_demo/data/price_point.dart';
import 'package:widget_layout_example2/modules/fl_chart_demo/data/sector.dart';
import 'package:widget_layout_example2/modules/fl_chart_demo/line_chart_widget.dart';
import 'package:widget_layout_example2/modules/fl_chart_demo/pie_chart_widget.dart';

const List<_PieChartDatum> _purchaserData = <_PieChartDatum>[
  _PieChartDatum('New', 42, Color(0xFF4CAF50)),
  _PieChartDatum('Returning', 33, Color(0xFF42A5F5)),
  _PieChartDatum('Enterprise', 25, Color(0xFFFFB300)),
];

const List<_PieChartDatum> _productData = <_PieChartDatum>[
  _PieChartDatum('Phones', 38, Color(0xFF7E57C2)),
  _PieChartDatum('Tablets', 22, Color(0xFF26A69A)),
  _PieChartDatum('Wearables', 18, Color(0xFFEF5350)),
  _PieChartDatum('Accessories', 22, Color(0xFF5C6BC0)),
];

const List<FlSpot> _lineSpots = <FlSpot>[
  FlSpot(1, 18),
  FlSpot(2, 24),
  FlSpot(3, 21),
  FlSpot(4, 30),
  FlSpot(5, 28),
  FlSpot(6, 36),
];

const String _barChartSource = r'''
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:flutter_chart_demo/data/price_point.dart';

class BarChartWidget extends StatefulWidget {
  const BarChartWidget({Key? key, required this.points}) : super(key: key);

  final List<PricePoint> points;

  @override
  State<BarChartWidget> createState() => _BarChartWidgetState(points: this.points);
}

class _BarChartWidgetState extends State<BarChartWidget> {
  final List<PricePoint> points;

  _BarChartWidgetState({required this.points});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: BarChart(
        BarChartData(
            barGroups: _chartGroups(),
            borderData: FlBorderData(
                border: const Border(bottom: BorderSide(), left: BorderSide())),
            gridData: FlGridData(show: false),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(sideTitles: _bottomTitles),
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
          ),
      ),
    );
  }

  List<BarChartGroupData> _chartGroups() {
    return points.map((point) =>
      BarChartGroupData(
        x: point.x.toInt(),
        barRods: [
          BarChartRodData(
            toY: point.y
          )
        ]
      )

    ).toList();
  }

  SideTitles get _bottomTitles => SideTitles(
    showTitles: true,
    getTitlesWidget: (value, meta) {
      String text = '';
      switch (value.toInt()) {
        case 0:
          text = 'Jan';
          break;
        case 2:
          text = 'Mar';
          break;
        case 4:
          text = 'May';
          break;
        case 6:
          text = 'Jul';
          break;
        case 8:
          text = 'Sep';
          break;
        case 10:
          text = 'Nov';
          break;
      }

      return Text(text);
    },
  );
}
''';

const String _lineChartSource = r'''
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:flutter_chart_demo/data/price_point.dart';

class LineChartWidget extends StatelessWidget {
  final List<PricePoint> points;

  const LineChartWidget(this.points, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: LineChart(
        LineChartData(
            lineBarsData: [
              LineChartBarData(
                spots: points.map((point) => FlSpot(point.x, point.y)).toList(),
                isCurved: false,
                // dotData: FlDotData(
                //   show: false,
                // ),
              ),
            ],
          ),
      ),
    );
  }
}
''';

const String _pieChartSource = r'''
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chart_demo/data/sector.dart';

class PieChartWidget extends StatelessWidget {
  final List<Sector> sectors;

  const PieChartWidget(this.sectors, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: 1.0,
        child: PieChart(PieChartData(
          sections: _chartSections(sectors),
          centerSpaceRadius: 48.0,
        )));
  }

  List<PieChartSectionData> _chartSections(List<Sector> sectors) {
    final List<PieChartSectionData> list = [];
    for (var sector in sectors) {
      const double radius = 40.0;
      final data = PieChartSectionData(
        color: sector.color,
        value: sector.value,
        radius: radius,
        title: '',
      );
      list.add(data);
    }
    return list;
  }
}
''';

const String _pricePointSource = r'''
import 'dart:math';
import 'package:collection/collection.dart';

class PricePoint {
  final double x;
  final double y;

  PricePoint({required this.x, required this.y});
}

List<PricePoint> get pricePoints {
  final Random random = Random();
  final randomNumbers = <double>[];
  for (var i = 0; i <= 11; i++) {
    randomNumbers.add(random.nextDouble());
  }

  return randomNumbers
      .mapIndexed(
          (index, element) => PricePoint(x: index.toDouble(), y: element))
      .toList();
}
''';

const String _sectorSource = r'''
import 'dart:math';

import 'package:flutter/material.dart';

class Sector {
  final Color color;
  final double value;
  final String title;

  Sector({required this.color, required this.value, required this.title});
}


List<double> get randomNumbers {
  final Random random = Random();
  final randomNumbers = <double>[];
  for (var i = 1; i <= 7; i++) {
    randomNumbers.add(random.nextDouble() * 100);
  }

  return randomNumbers;
}

List<Sector> get industrySectors {
  return [
    Sector(
        color: Colors.redAccent,
        value: randomNumbers[0],
        title: 'Information Technology'),
    Sector(
        color: Colors.blueGrey,
        value: randomNumbers[1],
        title: 'Automobile'),
    Sector(
        color: Colors.deepPurpleAccent,
        value: randomNumbers[2],
        title: 'Food'),
    Sector(
        color: Colors.yellow,
        value: randomNumbers[3],
        title: 'Finance'),
    Sector(
        color: Colors.black,
        value: randomNumbers[4],
        title: 'Energy'),
    Sector(
        color: Colors.orange,
        value: randomNumbers[5],
        title: 'Agriculture'),
    Sector(color: Colors.teal,
        value: randomNumbers[6],
        title: 'Pharma'),
  ];
}
''';

@RoutePage(name: RouteName.flChart)
class FlChartPage extends StatefulWidget {
  const FlChartPage({super.key});

  @override
  State<FlChartPage> createState() => _FlChartPageState();
}

class _FlChartPageState extends State<FlChartPage> {
  late final List<PricePoint> _points = pricePoints;
  late final List<Sector> _sectors = industrySectors;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('fl_chart Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const SelectableText(
              'fl_chart is useful for visualizing structured data with interactive Flutter charts. This example keeps the original fl_chart demos and appends the flutter_charts_demo source code below.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            _ChartCard(
              title: 'Original Line Chart',
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
              title: 'Original Pie Chart (Purchasers)',
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
              title: 'Original Pie Chart (Products)',
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
            const SizedBox(height: 28),
            const Text(
              'Appended flutter_charts_demo',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            const SelectableText(
              'The next cards append the copied flutter_charts_demo widgets, data models, and their original source code. The live demo caches the random lists once so the rendered charts and legend stay aligned.',
            ),
            const SizedBox(height: 16),
            _ChartCard(
              title: 'Copied Line Chart Widget Demo',
              description:
                  'This uses the copied LineChartWidget with the copied PricePoint model.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 240, child: LineChartWidget(_points)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: _points.map((PricePoint point) {
                      return Chip(
                        label: Text(
                          'x=${point.x.toInt()} y=${point.y.toStringAsFixed(2)}',
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _ChartCard(
              title: 'Copied Pie Chart Widget Demo',
              description:
                  'This uses the copied PieChartWidget with the copied Sector model and a matching legend.',
              child: Column(
                children: <Widget>[
                  SizedBox(height: 240, child: PieChartWidget(_sectors)),
                  const SizedBox(height: 16),
                  ..._sectors.map((Sector sector) => _SectorRow(sector)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _ChartCard(
              title: 'Copied Bar Chart Widget Demo',
              description:
                  'This uses the copied BarChartWidget with the same PricePoint list as the copied line chart.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 220, child: BarChartWidget(points: _points)),
                  const SizedBox(height: 12),
                  SelectableText(
                    'Bars rendered: ${_points.length}. Shared dataset avoids mismatched charts from repeated random generation.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const _CodeCard(
              title: 'bar_chart_widget.dart',
              description:
                  'Original source from flutter_charts_demo/lib/bar_chart_widget.dart',
              code: _barChartSource,
            ),
            const SizedBox(height: 16),
            const _CodeCard(
              title: 'line_chart_widget.dart',
              description:
                  'Original source from flutter_charts_demo/lib/line_chart_widget.dart',
              code: _lineChartSource,
            ),
            const SizedBox(height: 16),
            const _CodeCard(
              title: 'pie_chart_widget.dart',
              description:
                  'Original source from flutter_charts_demo/lib/pie_chart_widget.dart',
              code: _pieChartSource,
            ),
            const SizedBox(height: 16),
            const _CodeCard(
              title: 'data/price_point.dart',
              description:
                  'Original source from flutter_charts_demo/lib/data/price_point.dart',
              code: _pricePointSource,
            ),
            const SizedBox(height: 16),
            const _CodeCard(
              title: 'data/sector.dart',
              description:
                  'Original source from flutter_charts_demo/lib/data/sector.dart',
              code: _sectorSource,
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

class _CodeCard extends StatelessWidget {
  const _CodeCard({
    required this.title,
    required this.description,
    required this.code,
  });

  final String title;
  final String description;
  final String code;

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
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: SelectableText(
                code.trim(),
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontFamily: 'monospace'),
              ),
            ),
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

class _SectorRow extends StatelessWidget {
  const _SectorRow(this.sector);

  final Sector sector;

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
              color: sector.color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(child: SelectableText(sector.title)),
          SelectableText(sector.value.toStringAsFixed(1)),
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
