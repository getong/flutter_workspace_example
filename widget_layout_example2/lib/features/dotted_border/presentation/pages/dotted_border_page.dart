import 'package:auto_route/auto_route.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';

@RoutePage(name: RouteName.dottedBorder)
class DottedBorderPage extends StatefulWidget {
  const DottedBorderPage({super.key});

  @override
  State<DottedBorderPage> createState() => _DottedBorderPageState();
}

class _DottedBorderPageState extends State<DottedBorderPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _borderAnimationController =
      AnimationController(vsync: this, duration: const Duration(seconds: 4))
        ..repeat();

  bool _animateBorder = true;

  @override
  void dispose() {
    _borderAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('dotted_border Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            Text(
              'dotted_border draws dashed outlines around any Flutter child and now exposes typed option objects for rectangle, rounded rectangle, circle, oval, and custom-path borders.',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'This module demonstrates `RoundedRectDottedBorderOptions`, `RectDottedBorderOptions`, `CircularDottedBorderOptions`, `OvalDottedBorderOptions`, `CustomPathDottedBorderOptions`, gradients, dash patterns, and the built-in animation hook.',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            _SectionCard(
              title: 'Upload Zone Pattern',
              description:
                  'A rounded dashed border is a common way to signal drag-and-drop or file upload areas.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FilterChip(
                    label: const Text('Animate border motion'),
                    selected: _animateBorder,
                    onSelected: (bool value) {
                      setState(() {
                        _animateBorder = value;
                      });
                      if (value) {
                        _borderAnimationController.repeat();
                      } else {
                        _borderAnimationController.stop();
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  DottedBorder(
                    animation: _animateBorder
                        ? _borderAnimationController
                        : null,
                    options: const RoundedRectDottedBorderOptions(
                      radius: Radius.circular(26),
                      dashPattern: <double>[10, 5],
                      strokeWidth: 2.4,
                      color: Color(0xFF2563EB),
                      padding: EdgeInsets.all(18),
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: const Column(
                        children: <Widget>[
                          Icon(Icons.cloud_upload_outlined, size: 46),
                          SizedBox(height: 12),
                          Text(
                            'Drop assets or click to browse',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'The animated dash pattern helps the zone feel active.',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Built-in Border Shapes',
              description:
                  'The option classes cover the most common outline shapes without needing a custom painter.',
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: <Widget>[
                  DottedBorder(
                    options: const CircularDottedBorderOptions(
                      color: Color(0xFF16A34A),
                      dashPattern: <double>[4, 3],
                      strokeWidth: 2,
                      padding: EdgeInsets.all(14),
                    ),
                    child: const CircleAvatar(
                      radius: 36,
                      backgroundColor: Color(0xFFDCFCE7),
                      child: Icon(Icons.person_outline, size: 30),
                    ),
                  ),
                  DottedBorder(
                    options: const OvalDottedBorderOptions(
                      color: Color(0xFF9333EA),
                      dashPattern: <double>[8, 3],
                      strokeWidth: 2,
                      padding: EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                    ),
                    child: const Chip(
                      avatar: Icon(Icons.timelapse_outlined, size: 18),
                      label: Text('Oval status badge'),
                    ),
                  ),
                  DottedBorder(
                    options: const RectDottedBorderOptions(
                      dashPattern: <double>[2, 4],
                      strokeWidth: 2,
                      color: Color(0xFFF97316),
                      padding: EdgeInsets.all(10),
                    ),
                    child: Container(
                      width: 180,
                      padding: const EdgeInsets.all(14),
                      color: const Color(0xFFFFF7ED),
                      child: const Text(
                        'RectDottedBorderOptions keeps a crisp dashboard-card frame.',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Custom Path Border',
              description:
                  'For shapes that are not rectangle or oval based, use the custom-path option and provide the path yourself.',
              child: DottedBorder(
                options: CustomPathDottedBorderOptions(
                  dashPattern: const <double>[6, 5],
                  strokeWidth: 2.2,
                  gradient: const LinearGradient(
                    colors: <Color>[Color(0xFF0EA5E9), Color(0xFFF43F5E)],
                  ),
                  padding: const EdgeInsets.all(14),
                  customPath: (Size size) {
                    final Path path = Path();
                    final double width = size.width;
                    final double height = size.height;
                    final double notch = 18;

                    path.moveTo(notch, 0);
                    path.lineTo(width - notch, 0);
                    path.lineTo(width, height / 2);
                    path.lineTo(width - notch, height);
                    path.lineTo(notch, height);
                    path.lineTo(0, height / 2);
                    path.close();
                    return path;
                  },
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 24,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'CustomPathDottedBorderOptions',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'This ticket-style outline is driven by a custom hexagonal path instead of a stock border type.',
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Decorative Dash Pattern Sampler',
              description:
                  'Different dash lengths communicate different visual weight. The samples below all use the same child but different border options.',
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: List<Widget>.generate(3, (int index) {
                  final List<List<double>> patterns = <List<double>>[
                    <double>[3, 2],
                    <double>[10, 4],
                    <double>[1, 6],
                  ];
                  final List<Color> colors = <Color>[
                    const Color(0xFF334155),
                    const Color(0xFF0F766E),
                    const Color(0xFFB45309),
                  ];

                  return DottedBorder(
                    options: RoundedRectDottedBorderOptions(
                      radius: const Radius.circular(18),
                      dashPattern: patterns[index],
                      strokeWidth: 2,
                      color: colors[index],
                      padding: const EdgeInsets.all(10),
                    ),
                    child: Container(
                      width: 180,
                      padding: const EdgeInsets.all(16),
                      child: Text('Dash pattern ${patterns[index]}'),
                    ),
                  );
                }),
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
