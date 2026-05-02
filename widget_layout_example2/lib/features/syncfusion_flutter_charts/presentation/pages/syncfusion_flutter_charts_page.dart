import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:widget_layout_example2/app_navigation.dart';

@RoutePage(name: RouteName.syncfusionFlutterCharts)
class SyncfusionFlutterChartsPage extends StatefulWidget {
  const SyncfusionFlutterChartsPage({super.key});

  @override
  State<SyncfusionFlutterChartsPage> createState() =>
      _SyncfusionFlutterChartsPageState();
}

class _SyncfusionFlutterChartsPageState
    extends State<SyncfusionFlutterChartsPage> {
  late final TooltipBehavior _cartesianTooltipBehavior = TooltipBehavior(
    enable: true,
    format: 'point.x : point.y',
    color: const Color(0xFF111827),
    textStyle: const TextStyle(color: Colors.white),
  );
  late final TooltipBehavior _circularTooltipBehavior = TooltipBehavior(
    enable: true,
    format: 'point.x • point.y%',
  );
  late final TrackballBehavior _trackballBehavior = TrackballBehavior(
    enable: true,
    activationMode: ActivationMode.singleTap,
    tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
    tooltipAlignment: ChartAlignment.near,
    markerSettings: const TrackballMarkerSettings(
      markerVisibility: TrackballVisibilityMode.visible,
    ),
  );
  late final SelectionBehavior _selectionBehavior = SelectionBehavior(
    enable: true,
    selectedColor: const Color(0xFF0F766E),
    selectedBorderColor: const Color(0xFF0F766E),
    selectedBorderWidth: 2,
    unselectedOpacity: 0.35,
  );

  bool _showTargetLine = true;
  bool _showMonthRange = false;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final List<_ChartPoint> chartPoints = _showMonthRange
        ? _monthlyOrders
        : _weeklyOrders;

    return Scaffold(
      appBar: AppBar(title: const Text('syncfusion_flutter_charts Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            Text(
              'syncfusion_flutter_charts brings a large native-Dart charting surface to Flutter, covering cartesian, circular, and analytic interactions like tooltips, trackballs, and selection.',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'This module demonstrates `SfCartesianChart`, `SfCircularChart`, `ColumnSeries`, `LineSeries`, `DoughnutSeries`, `TooltipBehavior`, `TrackballBehavior`, `SelectionBehavior`, legends, and data labels.',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            _SectionCard(
              title: 'Cartesian Sales View',
              description:
                  'Combine column and line series to compare actual values against a target line, then enable tooltip and trackball interaction for inspection.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: <Widget>[
                      FilterChip(
                        label: const Text('Show target line'),
                        selected: _showTargetLine,
                        onSelected: (bool value) {
                          setState(() {
                            _showTargetLine = value;
                          });
                        },
                      ),
                      FilterChip(
                        label: const Text('Use monthly dataset'),
                        selected: _showMonthRange,
                        onSelected: (bool value) {
                          setState(() {
                            _showMonthRange = value;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 340,
                    child: SfCartesianChart(
                      title: ChartTitle(
                        text: _showMonthRange
                            ? 'Monthly Orders vs Target'
                            : 'Weekly Orders vs Target',
                      ),
                      legend: const Legend(isVisible: true),
                      primaryXAxis: CategoryAxis(),
                      primaryYAxis: NumericAxis(
                        labelFormat: '{value}',
                        title: AxisTitle(text: 'Orders'),
                      ),
                      tooltipBehavior: _cartesianTooltipBehavior,
                      trackballBehavior: _trackballBehavior,
                      series: <CartesianSeries<_ChartPoint, String>>[
                        ColumnSeries<_ChartPoint, String>(
                          name: 'Actual',
                          dataSource: chartPoints,
                          xValueMapper: (_ChartPoint point, _) => point.label,
                          yValueMapper: (_ChartPoint point, _) => point.actual,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(8),
                          ),
                          dataLabelSettings: const DataLabelSettings(
                            isVisible: true,
                          ),
                          selectionBehavior: _selectionBehavior,
                        ),
                        if (_showTargetLine)
                          LineSeries<_ChartPoint, String>(
                            name: 'Target',
                            dataSource: chartPoints,
                            xValueMapper: (_ChartPoint point, _) => point.label,
                            yValueMapper: (_ChartPoint point, _) =>
                                point.target,
                            markerSettings: const MarkerSettings(
                              isVisible: true,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Circular Channel Share',
              description:
                  'Circular charts are a good fit for mix or contribution views, and Syncfusion can label and tooltip the slices directly.',
              child: SizedBox(
                height: 340,
                child: SfCircularChart(
                  title: ChartTitle(text: 'Traffic Channel Share'),
                  legend: const Legend(isVisible: true),
                  tooltipBehavior: _circularTooltipBehavior,
                  series: <CircularSeries<_ChannelShare, String>>[
                    DoughnutSeries<_ChannelShare, String>(
                      dataSource: _channelShare,
                      xValueMapper: (_ChannelShare point, _) => point.channel,
                      yValueMapper: (_ChannelShare point, _) => point.share,
                      pointColorMapper: (_ChannelShare point, _) => point.color,
                      innerRadius: '58%',
                      radius: '84%',
                      dataLabelSettings: const DataLabelSettings(
                        isVisible: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Why These APIs Matter',
              description:
                  'The sample intentionally covers the chart behaviors most teams reach for first when replacing a static dashboard mock with an interactive Flutter implementation.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const <Widget>[
                  _ApiLine(
                    '`TooltipBehavior(enable: true)` for quick point inspection.',
                  ),
                  _ApiLine(
                    '`TrackballBehavior` to inspect all visible series at one x-position.',
                  ),
                  _ApiLine(
                    '`SelectionBehavior` to highlight a tapped bar or segment.',
                  ),
                  _ApiLine(
                    '`DataLabelSettings(isVisible: true)` for inline annotations.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.description,
    required this.child,
  });

  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(description),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class _ApiLine extends StatelessWidget {
  const _ApiLine(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text),
    );
  }
}

class _ChartPoint {
  const _ChartPoint({
    required this.label,
    required this.actual,
    required this.target,
  });

  final String label;
  final double actual;
  final double target;
}

class _ChannelShare {
  const _ChannelShare({
    required this.channel,
    required this.share,
    required this.color,
  });

  final String channel;
  final double share;
  final Color color;
}

const List<_ChartPoint> _weeklyOrders = <_ChartPoint>[
  _ChartPoint(label: 'Mon', actual: 24, target: 20),
  _ChartPoint(label: 'Tue', actual: 30, target: 24),
  _ChartPoint(label: 'Wed', actual: 28, target: 26),
  _ChartPoint(label: 'Thu', actual: 35, target: 30),
  _ChartPoint(label: 'Fri', actual: 42, target: 34),
  _ChartPoint(label: 'Sat', actual: 38, target: 32),
];

const List<_ChartPoint> _monthlyOrders = <_ChartPoint>[
  _ChartPoint(label: 'Jan', actual: 120, target: 100),
  _ChartPoint(label: 'Feb', actual: 145, target: 110),
  _ChartPoint(label: 'Mar', actual: 160, target: 130),
  _ChartPoint(label: 'Apr', actual: 155, target: 140),
  _ChartPoint(label: 'May', actual: 174, target: 150),
  _ChartPoint(label: 'Jun', actual: 188, target: 165),
];

const List<_ChannelShare> _channelShare = <_ChannelShare>[
  _ChannelShare(channel: 'Organic', share: 34, color: Color(0xFF2563EB)),
  _ChannelShare(channel: 'Paid', share: 26, color: Color(0xFF7C3AED)),
  _ChannelShare(channel: 'Email', share: 18, color: Color(0xFFEA580C)),
  _ChannelShare(channel: 'Referral', share: 22, color: Color(0xFF0F766E)),
];
