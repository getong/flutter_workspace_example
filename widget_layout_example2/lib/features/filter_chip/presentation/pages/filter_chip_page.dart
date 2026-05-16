import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';

@RoutePage(name: RouteName.filterChip)
class FilterChipPage extends StatefulWidget {
  const FilterChipPage({super.key});

  @override
  State<FilterChipPage> createState() => _FilterChipPageState();
}

class _FilterChipPageState extends State<FilterChipPage> {
  final Set<String> _activeTags = <String>{'Layout', 'Forms'};
  bool _onlyFavorites = false;
  bool _includeStable = true;

  @override
  Widget build(BuildContext context) {
    final List<String> filteredItems = <String>[
      if (_activeTags.contains('Layout')) 'Padding examples',
      if (_activeTags.contains('Animation')) 'AnimatedSwitcher examples',
      if (_activeTags.contains('Forms')) 'FormField examples',
      if (_activeTags.contains('Routing')) 'auto_route examples',
      if (_activeTags.contains('Accessibility')) 'Semantics examples',
      if (_includeStable) 'Production-ready samples',
      if (_onlyFavorites) 'Favorited demos',
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('FilterChip Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'FilterChip supports multi-selection, which makes it useful for tag filters and faceted search.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 24),
            _ExampleCard(
              title: 'Category Filters',
              description:
                  'Multiple chips can stay selected together, unlike ChoiceChip.',
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children:
                    <String>[
                      'Layout',
                      'Animation',
                      'Forms',
                      'Routing',
                      'Accessibility',
                    ].map((String tag) {
                      return FilterChip(
                        label: Text(tag),
                        selected: _activeTags.contains(tag),
                        avatar: _activeTags.contains(tag)
                            ? const Icon(Icons.check, size: 18)
                            : null,
                        onSelected: (bool value) {
                          setState(() {
                            if (value) {
                              _activeTags.add(tag);
                            } else {
                              _activeTags.remove(tag);
                            }
                          });
                        },
                      );
                    }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'Boolean Filters',
              description:
                  'FilterChip also works for on/off constraints that affect the result list.',
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: <Widget>[
                  FilterChip(
                    label: const Text('Only favorites'),
                    selected: _onlyFavorites,
                    selectedColor: Colors.amber.withValues(alpha: 0.22),
                    onSelected: (bool value) {
                      setState(() {
                        _onlyFavorites = value;
                      });
                    },
                  ),
                  FilterChip(
                    label: const Text('Include stable samples'),
                    selected: _includeStable,
                    onSelected: (bool value) {
                      setState(() {
                        _includeStable = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'Filtered Results',
              description:
                  'The UI below reacts to the selected filters so the chip state has visible impact.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Active tags: ${_activeTags.isEmpty ? 'none' : _activeTags.join(', ')}',
                  ),
                  const SizedBox(height: 12),
                  if (filteredItems.isEmpty)
                    const Text('No results match the active filters.')
                  else
                    ...filteredItems.map(
                      (String item) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        leading: const Icon(Icons.tune),
                        title: Text(item),
                      ),
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
