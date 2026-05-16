import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';

@RoutePage(name: RouteName.spacer)
class SpacerPage extends StatefulWidget {
  const SpacerPage({super.key});

  @override
  State<SpacerPage> createState() => _SpacerPageState();
}

class _SpacerPageState extends State<SpacerPage> {
  int _leftFlex = 1;
  int _centerFlex = 2;
  bool _showMetadata = true;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Spacer Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            Text(
              'Spacer takes the remaining space inside a Row, Column, or Flex '
              'and turns it into intentional breathing room.',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Use it when the gap itself should expand. It is simpler than '
              'manually wrapping an empty widget with Expanded, and it keeps '
              'flex-based layouts easier to read.',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            const _SectionCard(
              title: 'Basic Row Spacing',
              description:
                  'A Spacer pushes trailing actions away from leading content '
                  'without hard-coding the gap width.',
              child: _ToolbarExample(),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Multiple Spacer Widgets',
              description:
                  'Each Spacer can use a different flex value to divide empty '
                  'space proportionally.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      _ControlChip(
                        label: 'left flex: $_leftFlex',
                        onDecrement: _leftFlex > 1
                            ? () => setState(() => _leftFlex -= 1)
                            : null,
                        onIncrement: _leftFlex < 4
                            ? () => setState(() => _leftFlex += 1)
                            : null,
                      ),
                      const SizedBox(width: 12),
                      _ControlChip(
                        label: 'center flex: $_centerFlex',
                        onDecrement: _centerFlex > 1
                            ? () => setState(() => _centerFlex -= 1)
                            : null,
                        onIncrement: _centerFlex < 5
                            ? () => setState(() => _centerFlex += 1)
                            : null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer.withValues(
                        alpha: 0.42,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: <Widget>[
                        const _DemoBlock(label: 'Start', color: Colors.teal),
                        Spacer(flex: _leftFlex),
                        const _DemoBlock(label: 'Middle', color: Colors.orange),
                        Spacer(flex: _centerFlex),
                        const _DemoBlock(label: 'End', color: Colors.indigo),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Current layout: Spacer(flex: $_leftFlex) before the '
                    'middle block, Spacer(flex: $_centerFlex) before the end block.',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Column Layouts',
              description:
                  'Spacer also works vertically. This is useful for cards that '
                  'pin a button or footer to the bottom.',
              child: SizedBox(
                height: 280,
                child: Row(
                  children: const <Widget>[
                    Expanded(
                      child: _PromoCard(
                        title: 'Without Spacer',
                        useSpacer: false,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: _PromoCard(title: 'With Spacer', useSpacer: true),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Adaptive Header Row',
              description:
                  'Spacer is a clean way to let metadata stay on the trailing '
                  'edge while the title area keeps its natural size.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Show trailing metadata'),
                    value: _showMetadata,
                    onChanged: (bool value) {
                      setState(() {
                        _showMetadata = value;
                      });
                    },
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: Colors.deepPurple.withValues(
                                  alpha: 0.16,
                                ),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              alignment: Alignment.center,
                              child: const Icon(Icons.widgets_outlined),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Flutter Widget Catalog',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Spacer helps distribute the remaining room.',
                                  ),
                                ],
                              ),
                            ),
                            if (_showMetadata) ...<Widget>[
                              const Spacer(),
                              DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Colors.green.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  child: Text(
                                    'Updated now',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 16),
                        const LinearProgressIndicator(value: 0.64),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const _SectionCard(
              title: 'When To Prefer SizedBox',
              description:
                  'Use SizedBox for a fixed gap. Use Spacer when the gap should '
                  'expand to absorb leftover space.',
              child: _ComparisonExample(),
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

class _ToolbarExample extends StatelessWidget {
  const _ToolbarExample();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blueGrey.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: <Widget>[
          const CircleAvatar(
            backgroundColor: Color(0xFF1D3557),
            child: Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Ada Lovelace',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 2),
              Text('Reviewing layout examples'),
            ],
          ),
          const Spacer(),
          FilledButton.tonalIcon(
            onPressed: () {},
            icon: const Icon(Icons.visibility_outlined),
            label: const Text('Open'),
          ),
        ],
      ),
    );
  }
}

class _ControlChip extends StatelessWidget {
  const _ControlChip({
    required this.label,
    required this.onDecrement,
    required this.onIncrement,
  });

  final String label;
  final VoidCallback? onDecrement;
  final VoidCallback? onIncrement;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.58),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              visualDensity: VisualDensity.compact,
              onPressed: onDecrement,
              icon: const Icon(Icons.remove),
            ),
            Text(label),
            IconButton(
              visualDensity: VisualDensity.compact,
              onPressed: onIncrement,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}

class _DemoBlock extends StatelessWidget {
  const _DemoBlock({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 78,
      height: 78,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _PromoCard extends StatelessWidget {
  const _PromoCard({required this.title, required this.useSpacer});

  final String title;
  final bool useSpacer;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: useSpacer
            ? Colors.green.withValues(alpha: 0.12)
            : Colors.orange.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: useSpacer ? Colors.green : Colors.orange,
          width: 1.2,
        ),
      ),
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
            const SizedBox(height: 12),
            const Text('Title'),
            const SizedBox(height: 6),
            const Text(
              'This description may be short or long depending on the card content.',
            ),
            const SizedBox(height: 12),
            if (useSpacer) const Spacer(),
            FilledButton(
              onPressed: () {},
              child: Text(
                useSpacer ? 'Pinned Footer CTA' : 'CTA After Content',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ComparisonExample extends StatelessWidget {
  const _ComparisonExample();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.cyan.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Row(
            children: <Widget>[
              Icon(Icons.circle, size: 18),
              SizedBox(width: 12),
              Text('Fixed gap'),
              SizedBox(width: 24),
              Text('Trailing'),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.pink.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Row(
            children: <Widget>[
              Icon(Icons.circle, size: 18),
              SizedBox(width: 12),
              Text('Flexible gap'),
              Spacer(),
              Text('Trailing'),
            ],
          ),
        ),
      ],
    );
  }
}
