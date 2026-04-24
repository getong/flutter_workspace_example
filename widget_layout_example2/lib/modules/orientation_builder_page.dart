import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/app_navigation.dart';

@RoutePage(name: RouteName.orientationBuilder)
class OrientationBuilderPage extends StatefulWidget {
  const OrientationBuilderPage({super.key});

  @override
  State<OrientationBuilderPage> createState() => _OrientationBuilderPageState();
}

class _OrientationBuilderPageState extends State<OrientationBuilderPage> {
  double _previewWidth = 240;
  double _previewHeight = 360;

  bool get _previewIsPortrait => _previewHeight >= _previewWidth;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('OrientationBuilder Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            Text(
              'OrientationBuilder rebuilds when a parent box becomes portrait '
              'or landscape. It is useful for reusable widgets that should '
              'adapt to their own space instead of depending on the full '
              'screen orientation.',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'This module demonstrates local orientation-aware layouts, '
              'adaptive toolbars, gallery density changes, and split reading '
              'panels. The examples focus on parent constraints rather than '
              'global MediaQuery state.',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            const _OrientationCodeCard(
              title: 'Typical usage',
              code: '''
OrientationBuilder(
  builder: (context, orientation) {
    if (orientation == Orientation.portrait) {
      return const Column(children: <Widget>[...]);
    }

    return const Row(children: <Widget>[...]);
  },
)
''',
            ),
            const SizedBox(height: 16),
            _OrientationExampleCard(
              title: 'Interactive Constraint Preview',
              description:
                  'Resize the same component to see OrientationBuilder switch '
                  'between vertical and horizontal layouts based on the parent '
                  'box only.',
              api:
                  'Uses: SizedBox + OrientationBuilder + local width/height changes',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Preview orientation: '
                    '${_previewIsPortrait ? 'Portrait' : 'Landscape'}',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Slider(
                    min: 180,
                    max: 440,
                    value: _previewWidth,
                    label: '${_previewWidth.round()} px',
                    onChanged: (double value) {
                      setState(() {
                        _previewWidth = value;
                      });
                    },
                  ),
                  Text('Width: ${_previewWidth.round()} px'),
                  const SizedBox(height: 8),
                  Slider(
                    min: 180,
                    max: 440,
                    value: _previewHeight,
                    label: '${_previewHeight.round()} px',
                    onChanged: (double value) {
                      setState(() {
                        _previewHeight = value;
                      });
                    },
                  ),
                  Text('Height: ${_previewHeight.round()} px'),
                  const SizedBox(height: 16),
                  Center(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOutCubic,
                      width: _previewWidth,
                      height: _previewHeight,
                      child: const _AdaptiveHeroPanel(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const _OrientationExampleCard(
              title: 'Fixed Portrait And Landscape Previews',
              description:
                  'Constrain identical widgets to different shapes when you '
                  'want predictable visual QA for both states.',
              api: 'Uses: two parent boxes with different aspect ratios',
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: 220,
                      height: 320,
                      child: _AdaptiveHeroPanel(),
                    ),
                    SizedBox(width: 16),
                    SizedBox(
                      width: 360,
                      height: 190,
                      child: _AdaptiveHeroPanel(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const _OrientationExampleCard(
              title: 'Orientation-Based Gallery Density',
              description:
                  'A gallery can adjust column count from the orientation of '
                  'its local container, which is useful inside cards, tabs, or '
                  'split-pane layouts.',
              api:
                  'Uses: orientation to control GridView crossAxisCount and aspect ratio',
              child: SizedBox(height: 230, child: _OrientationGallery()),
            ),
            const SizedBox(height: 16),
            const _OrientationExampleCard(
              title: 'Adaptive Action Toolbar',
              description:
                  'Toolbars and action strips can stack vertically in portrait '
                  'and collapse into a horizontal row in landscape.',
              api: 'Uses: OrientationBuilder to choose Column vs Row',
              child: SizedBox(height: 190, child: _AdaptiveActionToolbar()),
            ),
            const SizedBox(height: 16),
            const _OrientationExampleCard(
              title: 'Reading Summary Layout',
              description:
                  'A detail view can keep its hero and metadata stacked in '
                  'portrait while moving into a split summary layout in '
                  'landscape.',
              api: 'Uses: OrientationBuilder inside a reusable content card',
              child: SizedBox(height: 250, child: _ReadingSummaryPreview()),
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

class _AdaptiveHeroPanel extends StatelessWidget {
  const _AdaptiveHeroPanel();

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        final bool portrait = orientation == Orientation.portrait;

        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[
                Colors.blue.shade50,
                Colors.cyan.shade50,
                Colors.teal.shade50,
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.blueGrey.withValues(alpha: 0.18)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: portrait
                ? const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(flex: 3, child: _HeroBlock()),
                      SizedBox(height: 12),
                      _MiniStatRow(),
                    ],
                  )
                : const Row(
                    children: <Widget>[
                      Expanded(flex: 3, child: _HeroBlock()),
                      SizedBox(width: 12),
                      Expanded(flex: 2, child: _MiniStatColumn()),
                    ],
                  ),
          ),
        );
      },
    );
  }
}

class _OrientationGallery extends StatelessWidget {
  const _OrientationGallery();

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        final bool portrait = orientation == Orientation.portrait;
        final int columns = portrait ? 2 : 4;

        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 8,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: portrait ? 1.0 : 1.35,
          ),
          itemBuilder: (BuildContext context, int index) {
            final Color color = switch (index % 4) {
              0 => const Color(0xFF2563EB),
              1 => const Color(0xFF0F766E),
              2 => const Color(0xFF7C3AED),
              _ => const Color(0xFFEA580C),
            };

            return DecoratedBox(
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: color.withValues(alpha: 0.22)),
              ),
              child: Center(
                child: Text(
                  'Item ${index + 1}',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: color.withValues(alpha: 0.88),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _AdaptiveActionToolbar extends StatelessWidget {
  const _AdaptiveActionToolbar();

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        final bool portrait = orientation == Orientation.portrait;

        final List<Widget> actions = <Widget>[
          FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.play_circle_outline),
            label: const Text('Preview'),
          ),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.edit_outlined),
            label: const Text('Edit'),
          ),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.share_outlined),
            label: const Text('Share'),
          ),
        ];

        return DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.primary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: portrait
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        'Portrait keeps controls stacked for reachability.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 14),
                      ...actions.map(
                        (Widget action) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: action,
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Landscape can compress the same actions into a single row.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 14),
                      Wrap(spacing: 10, runSpacing: 10, children: actions),
                    ],
                  ),
          ),
        );
      },
    );
  }
}

class _ReadingSummaryPreview extends StatelessWidget {
  const _ReadingSummaryPreview();

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        final bool portrait = orientation == Orientation.portrait;

        final Widget cover = Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: <Color>[Color(0xFF312E81), Color(0xFF1D4ED8)],
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          alignment: Alignment.center,
          child: const Text(
            'Weekly Report',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
        );

        final Widget details = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Orientation-aware detail card',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            const Text(
              'Portrait favors vertical reading flow. Landscape can surface '
              'metadata beside the hero instead of below it.',
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: const <Widget>[
                Chip(label: Text('8 sections')),
                Chip(label: Text('2 approvals pending')),
                Chip(label: Text('ETA 14 min')),
              ],
            ),
          ],
        );

        return DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.blueGrey.withValues(alpha: 0.14)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: portrait
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(flex: 3, child: SizedBox.expand(child: cover)),
                      const SizedBox(height: 14),
                      details,
                    ],
                  )
                : Row(
                    children: <Widget>[
                      Expanded(child: cover),
                      const SizedBox(width: 16),
                      Expanded(child: details),
                    ],
                  ),
          ),
        );
      },
    );
  }
}

class _HeroBlock extends StatelessWidget {
  const _HeroBlock();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.indigo,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Campaign Snapshot',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 18,
              ),
            ),
            const Spacer(),
            Text(
              'OrientationBuilder is using the parent box shape, not the full device.',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.92),
                height: 1.35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniStatRow extends StatelessWidget {
  const _MiniStatRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: <Widget>[
        Expanded(
          child: _MiniTile(label: 'Reach', value: '42K'),
        ),
        SizedBox(width: 10),
        Expanded(
          child: _MiniTile(label: 'CTR', value: '6.4%'),
        ),
      ],
    );
  }
}

class _MiniStatColumn extends StatelessWidget {
  const _MiniStatColumn();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: <Widget>[
        Expanded(
          child: _MiniTile(label: 'Reach', value: '42K'),
        ),
        SizedBox(height: 10),
        Expanded(
          child: _MiniTile(label: 'CTR', value: '6.4%'),
        ),
      ],
    );
  }
}

class _MiniTile extends StatelessWidget {
  const _MiniTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(label, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 6),
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrientationExampleCard extends StatelessWidget {
  const _OrientationExampleCard({
    required this.title,
    required this.description,
    required this.api,
    required this.child,
  });

  final String title;
  final String description;
  final String api;
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
            const SizedBox(height: 12),
            Text(
              api,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.blueGrey.shade700),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrientationCodeCard extends StatelessWidget {
  const _OrientationCodeCard({required this.title, required this.code});

  final String title;
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
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                code,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'monospace',
                  height: 1.45,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
