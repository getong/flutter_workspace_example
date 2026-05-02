import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:widget_layout_example2/features/fl_chart/domain/entities/sector.dart';

class PieChartWidget extends StatelessWidget {
  const PieChartWidget(this.sectors, {super.key});

  final List<Sector> sectors;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: PieChart(
        PieChartData(
          sections: _chartSections(sectors),
          centerSpaceRadius: 48,
          sectionsSpace: 2,
        ),
      ),
    );
  }

  List<PieChartSectionData> _chartSections(List<Sector> sectors) {
    return sectors.map((Sector sector) {
      return PieChartSectionData(
        color: sector.color,
        value: sector.value,
        radius: 40,
        title: '',
      );
    }).toList();
  }
}
