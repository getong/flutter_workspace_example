import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';
import 'package:widget_layout_example2/features/custom_multi_child_layout/domain/entities/custom_multi_child_layout_example.dart';
import 'package:widget_layout_example2/features/custom_multi_child_layout/presentation/widgets/custom_multi_child_layout_showcase.dart';

@RoutePage(name: RouteName.customMultiChildLayout)
class CustomMultiChildLayoutPage extends StatelessWidget {
  const CustomMultiChildLayoutPage({super.key});

  static const List<CustomMultiChildLayoutExample>
  _examples = <CustomMultiChildLayoutExample>[
    CustomMultiChildLayoutExample(
      title: 'Profile Header Delegate',
      description:
          'This layout positions an avatar, title, subtitle, status chip, and trailing action with exact spacing rules.',
      api: 'Uses: CustomMultiChildLayout + LayoutId + MultiChildLayoutDelegate',
      takeaway:
          'Use one delegate when multiple children depend on each other for size and position.',
      type: CustomMultiChildLayoutExampleType.profileHeader,
      previewHeight: 120,
    ),
    CustomMultiChildLayoutExample(
      title: 'Media Controls Delegate',
      description:
          'A playback card can place artwork, text, a seek bar, and transport buttons with deliberate alignment.',
      api: 'Uses: layoutChild() constraints and positionChild() offsets',
      takeaway:
          'This is useful when Row, Column, and Stack become awkward for a composed control surface.',
      type: CustomMultiChildLayoutExampleType.mediaControls,
      previewHeight: 132,
    ),
    CustomMultiChildLayoutExample(
      title: 'Boarding Pass Delegate',
      description:
          'Named slots help build ticket, dashboard, or summary layouts where each region has a stable anchor.',
      api: 'Uses: named child slots for header, meta row, and footer areas',
      takeaway:
          'The delegate keeps layout intent in one place instead of scattering spacing logic across many widgets.',
      type: CustomMultiChildLayoutExampleType.boardingPass,
      previewHeight: 150,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CustomMultiChildLayout Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'CustomMultiChildLayout lets one delegate measure and position multiple named children. It is useful when Row, Column, Stack, and Align cannot describe the relationship between children clearly enough.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            Card(
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'How It Works',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('1. Wrap each child with LayoutId.'),
                    const SizedBox(height: 4),
                    const Text(
                      '2. Implement a MultiChildLayoutDelegate to size each child with layoutChild().',
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '3. Place each child with positionChild() using the measured sizes.',
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'This pattern is best for custom dashboards, headers, cards, media controls, and ticket-like layouts where children need coordinated placement.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ..._examples.expand(
              (CustomMultiChildLayoutExample example) => <Widget>[
                CustomMultiChildLayoutShowcase(example: example),
                const SizedBox(height: 16),
              ],
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
