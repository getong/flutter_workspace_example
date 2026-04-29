import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:widget_layout_example2/modules/fl_chart_demo/data/price_point.dart';

class LineChartWidget extends StatelessWidget {
  const LineChartWidget(this.points, {super.key});

  final List<PricePoint> points;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: LineChart(
        LineChartData(
          lineBarsData: <LineChartBarData>[
            LineChartBarData(
              spots: points
                  .map((PricePoint point) => FlSpot(point.x, point.y))
                  .toList(),
              isCurved: false,
              color: Colors.indigo,
              barWidth: 3,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: Colors.indigo.withValues(alpha: 0.12),
              ),
            ),
          ],
          borderData: FlBorderData(
            border: const Border(bottom: BorderSide(), left: BorderSide()),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 0.25,
            getDrawingHorizontalLine: (double value) {
              return const FlLine(color: Colors.black12, strokeWidth: 1);
            },
          ),
          minX: 0,
          maxX: 11,
          minY: 0,
          maxY: 1,
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(sideTitles: _bottomTitles),
            leftTitles: AxisTitles(sideTitles: _leftTitles),
          ),
        ),
      ),
    );
  }

  SideTitles get _bottomTitles => SideTitles(
    showTitles: true,
    getTitlesWidget: (double value, TitleMeta meta) {
      const List<String> months = <String>[
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];

      final int index = value.toInt();
      final String label = index >= 0 && index < months.length
          ? months[index]
          : '';

      return SideTitleWidget(meta: meta, child: Text(label));
    },
  );

  SideTitles get _leftTitles => SideTitles(
    showTitles: true,
    reservedSize: 34,
    interval: 0.25,
    getTitlesWidget: (double value, TitleMeta meta) {
      return SideTitleWidget(meta: meta, child: Text(value.toStringAsFixed(2)));
    },
  );
}
