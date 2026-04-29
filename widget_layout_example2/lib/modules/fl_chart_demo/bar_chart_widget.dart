import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:widget_layout_example2/modules/fl_chart_demo/data/price_point.dart';

class BarChartWidget extends StatelessWidget {
  const BarChartWidget({super.key, required this.points});

  final List<PricePoint> points;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: BarChart(
        BarChartData(
          barGroups: _chartGroups(),
          borderData: FlBorderData(
            border: const Border(bottom: BorderSide(), left: BorderSide()),
          ),
          gridData: const FlGridData(show: false),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(sideTitles: _bottomTitles),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
        ),
      ),
    );
  }

  List<BarChartGroupData> _chartGroups() {
    return points.map((PricePoint point) {
      return BarChartGroupData(
        x: point.x.toInt(),
        barRods: <BarChartRodData>[
          BarChartRodData(
            toY: point.y,
            color: Colors.indigo,
            width: 18,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    }).toList();
  }

  SideTitles get _bottomTitles => SideTitles(
    showTitles: true,
    getTitlesWidget: (double value, TitleMeta meta) {
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

      return SideTitleWidget(meta: meta, child: Text(text));
    },
  );
}
