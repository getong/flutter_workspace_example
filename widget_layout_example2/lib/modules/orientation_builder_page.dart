import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class OrientationBuilderPage extends StatelessWidget {
  const OrientationBuilderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('OrientationBuilder Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'OrientationBuilder rebuilds when the parent constraints change between portrait and landscape. It is useful for responsive components that should adapt to local orientation rather than the whole app.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            const _OrientationExampleCard(
              title: 'Portrait Layout Preview',
              description:
                  'A taller container is treated as portrait, so the component stacks its content vertically.',
              api: 'Uses: OrientationBuilder with portrait constraints',
              child: SizedBox(
                width: 220,
                height: 320,
                child: _AdaptiveOrientationPanel(),
              ),
            ),
            const SizedBox(height: 16),
            const _OrientationExampleCard(
              title: 'Landscape Layout Preview',
              description:
                  'A wider container flips to landscape and arranges the same content horizontally.',
              api: 'Uses: OrientationBuilder with landscape constraints',
              child: SizedBox(height: 180, child: _AdaptiveOrientationPanel()),
            ),
            const SizedBox(height: 16),
            const _OrientationExampleCard(
              title: 'Orientation-Based Gallery',
              description:
                  'A local gallery component can change its column count based on the orientation of the box that contains it.',
              api: 'Uses: orientation to adjust GridView crossAxisCount',
              child: SizedBox(height: 210, child: _OrientationGallery()),
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

class _AdaptiveOrientationPanel extends StatelessWidget {
  const _AdaptiveOrientationPanel();

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        final bool portrait = orientation == Orientation.portrait;

        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[Colors.blue.shade50, Colors.cyan.shade50],
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: portrait
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const <Widget>[
                      _HeroBlock(),
                      SizedBox(height: 12),
                      _MiniStatRow(),
                    ],
                  )
                : const Row(
                    children: <Widget>[
                      Expanded(flex: 2, child: _HeroBlock()),
                      SizedBox(width: 12),
                      Expanded(child: _MiniStatColumn()),
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
        final int columns = orientation == Orientation.portrait ? 2 : 4;

        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 8,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemBuilder: (BuildContext context, int index) {
            return DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.indigo.withValues(
                  alpha: 0.08 * ((index % 4) + 4),
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(
                  'Item ${index + 1}',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            );
          },
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
      child: const Center(
        child: Text(
          'Hero content',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
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
        Expanded(child: _MiniTile(label: 'Reach')),
        SizedBox(width: 10),
        Expanded(child: _MiniTile(label: 'CTR')),
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
        Expanded(child: _MiniTile(label: 'Reach')),
        SizedBox(height: 10),
        Expanded(child: _MiniTile(label: 'CTR')),
      ],
    );
  }
}

class _MiniTile extends StatelessWidget {
  const _MiniTile({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
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
