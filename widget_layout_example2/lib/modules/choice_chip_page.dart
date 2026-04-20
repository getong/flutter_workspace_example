import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/app_navigation.dart';

@RoutePage(name: RouteName.choiceChip)
class ChoiceChipPage extends StatefulWidget {
  const ChoiceChipPage({super.key});

  @override
  State<ChoiceChipPage> createState() => _ChoiceChipPageState();
}

class _ChoiceChipPageState extends State<ChoiceChipPage> {
  String _selectedFramework = 'auto_route';
  String _selectedDensity = 'Comfortable';
  String _selectedTheme = 'Ocean';

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('ChoiceChip Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'ChoiceChip is for single selection from a small set of related options.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Text(
              'This page demonstrates radio-like behavior with compact chips, summary text, and different visual treatments.',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            _ExampleCard(
              title: 'Primary Navigation Choice',
              description:
                  'Each chip represents one routing package. Only one option stays selected at a time.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children:
                        <String>[
                          'auto_route',
                          'go_router',
                          'Navigator 2.0',
                        ].map((String option) {
                          return ChoiceChip(
                            avatar: Icon(switch (option) {
                              'auto_route' => Icons.route,
                              'go_router' => Icons.alt_route,
                              _ => Icons.map_outlined,
                            }, size: 18),
                            label: Text(option),
                            selected: _selectedFramework == option,
                            onSelected: (_) {
                              setState(() {
                                _selectedFramework = option;
                              });
                            },
                          );
                        }).toList(),
                  ),
                  const SizedBox(height: 16),
                  Text('Selected framework: $_selectedFramework'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'Density Presets',
              description:
                  'ChoiceChip works well for quick preference panels where one layout mode should be active.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: <String>['Compact', 'Comfortable', 'Expanded']
                        .map((String option) {
                          return ChoiceChip(
                            label: Text(option),
                            selectedColor: Colors.blue.withValues(alpha: 0.18),
                            showCheckmark: false,
                            selected: _selectedDensity == option,
                            onSelected: (_) {
                              setState(() {
                                _selectedDensity = option;
                              });
                            },
                          );
                        })
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    width: double.infinity,
                    padding: switch (_selectedDensity) {
                      'Compact' => const EdgeInsets.all(12),
                      'Expanded' => const EdgeInsets.all(28),
                      _ => const EdgeInsets.all(20),
                    },
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.blue.withValues(alpha: 0.24),
                      ),
                    ),
                    child: Text(
                      'Density preview: $_selectedDensity spacing',
                      style: theme.textTheme.titleSmall,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'Theme Selector',
              description:
                  'Visual choices often pair a label with color, which makes chips a concise alternative to dropdowns.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children:
                        <({String label, Color color})>[
                          (label: 'Ocean', color: Colors.teal),
                          (label: 'Sunset', color: Colors.deepOrange),
                          (label: 'Slate', color: Colors.blueGrey),
                        ].map((({Color color, String label}) option) {
                          return ChoiceChip(
                            label: Text(option.label),
                            avatar: CircleAvatar(
                              backgroundColor: option.color,
                              radius: 8,
                            ),
                            selected: _selectedTheme == option.label,
                            selectedColor: option.color.withValues(alpha: 0.18),
                            onSelected: (_) {
                              setState(() {
                                _selectedTheme = option.label;
                              });
                            },
                          );
                        }).toList(),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: switch (_selectedTheme) {
                        'Sunset' => Colors.deepOrange.withValues(alpha: 0.12),
                        'Slate' => Colors.blueGrey.withValues(alpha: 0.12),
                        _ => Colors.teal.withValues(alpha: 0.12),
                      },
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text('Active theme preset: $_selectedTheme'),
                  ),
                ],
              ),
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

class _ExampleCard extends StatelessWidget {
  const _ExampleCard({
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
            Text(description),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}
