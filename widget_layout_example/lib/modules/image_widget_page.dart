import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ImageWidgetPage extends StatelessWidget {
  const ImageWidgetPage({super.key});

  static const String _assetPath = 'assets/images/image_module_demo.png';

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final ImageProvider assetProvider = const AssetImage(_assetPath);
    final ImageProvider resizedProvider = ResizeImage.resizeIfNeeded(
      48,
      48,
      assetProvider,
    );
    return Scaffold(
      appBar: AppBar(title: const Text('Image Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            Text(
              'Flutter Image widget examples',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'This module demonstrates several `Image` usage patterns: '
              '`Image.asset`, the generic `Image(image: ...)` constructor, '
              '`AssetImage`, `ExactAssetImage`, `ResizeImage`, `frameBuilder`, '
              '`errorBuilder`, and image providers reused in avatar and '
              'decoration-style UI.',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            const _CodeSampleCard(),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Image.asset Variants',
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: <Widget>[
                  _DemoTile(
                    title: 'Basic Asset',
                    subtitle: 'The simplest local image example.',
                    child: Image.asset(
                      _assetPath,
                      width: 96,
                      height: 96,
                      fit: BoxFit.cover,
                      semanticLabel: 'Local asset image',
                    ),
                  ),
                  _DemoTile(
                    title: 'Asset + frameBuilder',
                    subtitle:
                        'Decorate how the image is presented in the tree.',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Image.asset(
                        _assetPath,
                        width: 104,
                        height: 104,
                        fit: BoxFit.cover,
                        frameBuilder:
                            (
                              BuildContext context,
                              Widget child,
                              int? frame,
                              bool wasSynchronouslyLoaded,
                            ) {
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: EdgeInsets.all(
                                  wasSynchronouslyLoaded || frame != null
                                      ? 0
                                      : 8,
                                ),
                                color: colorScheme.primary.withValues(
                                  alpha: 0.12,
                                ),
                                child: child,
                              );
                            },
                      ),
                    ),
                  ),
                  _DemoTile(
                    title: 'Tinted Asset',
                    subtitle: 'Use `color` and `colorBlendMode` for effects.',
                    child: Container(
                      width: 104,
                      height: 104,
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Image.asset(
                        _assetPath,
                        color: colorScheme.primary,
                        colorBlendMode: BlendMode.srcIn,
                        scale: 0.015,
                        repeat: ImageRepeat.repeat,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Image Providers',
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: <Widget>[
                  _DemoTile(
                    title: 'Image(image: AssetImage)',
                    subtitle: 'Use the generic constructor with a provider.',
                    child: Image(
                      image: assetProvider,
                      width: 96,
                      height: 96,
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                  _DemoTile(
                    title: 'ExactAssetImage',
                    subtitle: 'Pick an explicit asset provider implementation.',
                    child: Image(
                      image: const ExactAssetImage(_assetPath),
                      width: 96,
                      height: 96,
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                    ),
                  ),
                  _DemoTile(
                    title: 'ResizeImage Wrapper',
                    subtitle: 'Wrap providers when you want resized decoding.',
                    child: Image(
                      image: resizedProvider,
                      width: 96,
                      height: 96,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Image Providers in UI',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: colorScheme.primaryContainer,
                        backgroundImage: assetProvider,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'The same `AssetImage` can be reused in places like '
                          '`CircleAvatar`, buttons, and decorated containers.',
                          style: theme.textTheme.bodyLarge,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: colorScheme.surfaceContainerHighest.withValues(
                        alpha: 0.55,
                      ),
                      image: DecorationImage(
                        image: assetProvider,
                        fit: BoxFit.cover,
                        opacity: 0.18,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'DecorationImage with AssetImage',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: SizedBox(
                      width: 18,
                      height: 18,
                      child: Image(image: assetProvider, fit: BoxFit.cover),
                    ),
                    label: const Text('Image in Button'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Layout and Clipping',
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: <Widget>[
                  _DemoTile(
                    title: 'AspectRatio',
                    subtitle: 'Combine Image with layout widgets for control.',
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image(image: assetProvider, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  _DemoTile(
                    title: 'Error Handling',
                    subtitle:
                        'The builder keeps layout stable when a source fails.',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/images/does_not_exist.png',
                        width: 104,
                        height: 104,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (
                              BuildContext context,
                              Object error,
                              StackTrace? stackTrace,
                            ) {
                              return Container(
                                width: 104,
                                height: 104,
                                color: colorScheme.errorContainer,
                                alignment: Alignment.center,
                                child: Text(
                                  'Missing image',
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onErrorContainer,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              );
                            },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/'),
        icon: const Icon(Icons.home),
        label: const Text('Home'),
      ),
    );
  }
}

class _CodeSampleCard extends StatelessWidget {
  const _CodeSampleCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[Color(0xFF1F2937), Color(0xFF111827)],
          ),
        ),
        child: DefaultTextStyle(
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'monospace',
            height: 1.5,
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Image.asset('assets/images/image_module_demo.png')"),
              SizedBox(height: 8),
              Text(
                "Image(image: const AssetImage('assets/images/image_module_demo.png'))",
              ),
              SizedBox(height: 8),
              Text('Image('),
              Text(
                "  image: ResizeImage.resizeIfNeeded(48, 48, const AssetImage('assets/images/image_module_demo.png')),",
              ),
              Text('  fit: BoxFit.cover,'),
              Text(')'),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
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
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class _DemoTile extends StatelessWidget {
  const _DemoTile({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 210,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 118, child: Center(child: child)),
          const SizedBox(height: 12),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(subtitle),
        ],
      ),
    );
  }
}
