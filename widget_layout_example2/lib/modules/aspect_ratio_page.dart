import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class AspectRatioPage extends StatelessWidget {
  const AspectRatioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AspectRatio Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'AspectRatio sizes its child to a specific width-to-height ratio within the space allowed by the parent. It is useful for videos, photos, cards, posters, and any layout that must keep consistent proportions.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            const _AspectRatioExampleCard(
              title: '16:9 Video Frame',
              description:
                  'A common use case is keeping media previews at a stable widescreen ratio.',
              api: 'Uses: AspectRatio(aspectRatio: 16 / 9)',
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: _GradientFrame(
                  label: '16:9 video preview',
                  colors: <Color>[Color(0xFF1E3A8A), Color(0xFF60A5FA)],
                  icon: Icons.play_circle_fill_rounded,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const _AspectRatioExampleCard(
              title: 'Square Product Tile',
              description:
                  'Gallery tiles often need equal width and height regardless of the parent width.',
              api: 'Uses: AspectRatio(aspectRatio: 1)',
              child: SizedBox(
                width: 180,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: _GradientFrame(
                    label: '1:1 product tile',
                    colors: <Color>[Color(0xFF166534), Color(0xFF4ADE80)],
                    icon: Icons.shopping_bag_outlined,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const _AspectRatioExampleCard(
              title: 'Poster Preview',
              description:
                  'Portrait artwork and book covers usually rely on taller ratios like 3:4.',
              api: 'Uses: AspectRatio(aspectRatio: 3 / 4)',
              child: SizedBox(
                width: 180,
                child: AspectRatio(
                  aspectRatio: 3 / 4,
                  child: _GradientFrame(
                    label: '3:4 poster',
                    colors: <Color>[Color(0xFF7C2D12), Color(0xFFF97316)],
                    icon: Icons.movie_outlined,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const _AspectRatioExampleCard(
              title: 'Panorama Banner',
              description:
                  'Wider ratios create cinematic banners and dashboard headers that feel distinct from standard cards.',
              api: 'Uses: AspectRatio(aspectRatio: 21 / 9)',
              child: AspectRatio(
                aspectRatio: 21 / 9,
                child: _GradientFrame(
                  label: '21:9 panoramic banner',
                  colors: <Color>[Color(0xFF581C87), Color(0xFFC084FC)],
                  icon: Icons.landscape_outlined,
                ),
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

class _GradientFrame extends StatelessWidget {
  const _GradientFrame({
    required this.label,
    required this.colors,
    required this.icon,
  });

  final String label;
  final List<Color> colors;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, color: Colors.white, size: 34),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AspectRatioExampleCard extends StatelessWidget {
  const _AspectRatioExampleCard({
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
