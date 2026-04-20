import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flutter/material.dart';

@RoutePage()
class CachedNetworkImageCePage extends StatefulWidget {
  const CachedNetworkImageCePage({super.key});

  @override
  State<CachedNetworkImageCePage> createState() =>
      _CachedNetworkImageCePageState();
}

class _CachedNetworkImageCePageState extends State<CachedNetworkImageCePage> {
  static const String _heroUrl =
      'https://www.baidu.com/img/flexible/logo/pc/result.png';
  static const String _altHeroUrl = 'https://www.baidu.com/img/bd_logo1.png';
  static const String _avatarUrl = 'https://www.baidu.com/img/bd_logo1.png';
  static const String _cardUrl =
      'https://www.baidu.com/img/flexible/logo/pc/result.png';
  static const String _transparentPngUrl =
      'https://upload.wikimedia.org/wikipedia/commons/4/47/PNG_transparency_demonstration_1.png';
  static const String _errorDemoUrl = 'https://www.baidu.com/img/bd_logo1.png';
  static const String _brokenUrl =
      'https://www.baidu.com/img/this-image-does-not-exist.png';

  final DefaultCacheManager _customCacheManager = DefaultCacheManager(
    connectionParameters: ConnectionParameters(
      connectionTimeout: Duration(seconds: 8),
      requestTimeout: Duration(seconds: 20),
    ),
  );

  bool _useAltHero = false;
  bool _loadRemoteImages = false;
  bool _simulateError = false;
  int _reloadTick = 0;

  String get _activeHeroUrl => _useAltHero ? _altHeroUrl : _heroUrl;

  Future<void> _evictCurrentImage() async {
    final bool removed = await CachedNetworkImage.evictFromCache(
      _activeHeroUrl,
      cacheManager: _customCacheManager,
    );

    if (!mounted) return;

    setState(() {
      _reloadTick += 1;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          removed
              ? 'Cleared the current image from cache.'
              : 'Image cache entry was not found.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final CachedNetworkImageProvider avatarProvider =
        CachedNetworkImageProvider(
          _avatarUrl,
          cacheManager: _customCacheManager,
          maxWidth: 220,
          maxHeight: 220,
        );

    return Scaffold(
      appBar: AppBar(title: const Text('cached_network_image_ce Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            Text(
              'Load, cache, and reuse remote images in Flutter.',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'This module demonstrates `CachedNetworkImage`, '
              '`progressIndicatorBuilder`, `imageBuilder`, '
              '`CachedNetworkImageProvider`, `errorBuilder`, '
              '`useOldImageOnUrlChange`, `memCacheWidth`, '
              '`maxWidthDiskCache`, `cacheManager`, and '
              '`CachedNetworkImage.evictFromCache`.',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: colorScheme.tertiaryContainer.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    Icons.wifi_off_rounded,
                    color: colorScheme.onTertiaryContainer,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'If this device blocks outbound network access, the '
                      'examples below should now show fallback UI instead of '
                      'failing through raw image-provider exceptions.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onTertiaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const _CodeSampleCard(),
            const SizedBox(height: 16),
            if (!_loadRemoteImages)
              _SectionCard(
                title: 'Remote Demo Disabled',
                description:
                    'This runtime appears to block outbound image requests. '
                    'The module stays usable, but the actual remote fetch '
                    'examples are gated behind a manual button.',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '`www.baidu.com` is also not a direct image URL, so '
                      'changing hosts alone is unlikely to fix a socket '
                      'permission error.',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () {
                        setState(() {
                          _loadRemoteImages = true;
                        });
                      },
                      icon: const Icon(Icons.cloud_download_outlined),
                      label: const Text('Try Loading Remote Images'),
                    ),
                  ],
                ),
              ),
            if (_loadRemoteImages) ...<Widget>[
              _SectionCard(
                title: 'Basic Loading And Progress',
                description:
                    'Use the widget directly when you want placeholder and '
                    'download progress behavior in the same place.',
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: <Widget>[
                    _DemoTile(
                      width: 280,
                      title: 'CachedNetworkImage',
                      subtitle:
                          'Shows a loader first, then fades into the cached '
                          'network image.',
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: CachedNetworkImage(
                          imageUrl: _heroUrl,
                          width: 240,
                          height: 160,
                          fit: BoxFit.cover,
                          placeholder: (BuildContext context, String url) {
                            return Container(
                              width: 240,
                              height: 160,
                              color: colorScheme.surfaceContainerHighest,
                              alignment: Alignment.center,
                              child: const CircularProgressIndicator(),
                            );
                          },
                          errorBuilder:
                              (
                                BuildContext context,
                                Object error,
                                StackTrace? stackTrace,
                              ) {
                                return _ImageErrorBox(
                                  width: 240,
                                  height: 160,
                                  message: 'Unable to load image',
                                );
                              },
                        ),
                      ),
                    ),
                    _DemoTile(
                      width: 280,
                      title: 'progressIndicatorBuilder',
                      subtitle:
                          'Use download progress to render a richer loading '
                          'state than a plain spinner.',
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: CachedNetworkImage(
                          imageUrl: _cardUrl,
                          width: 240,
                          height: 160,
                          fit: BoxFit.cover,
                          progressIndicatorBuilder:
                              (
                                BuildContext context,
                                String url,
                                DownloadProgress progress,
                              ) {
                                final double? value = progress.progress;
                                return Container(
                                  width: 240,
                                  height: 160,
                                  color: colorScheme.secondaryContainer
                                      .withValues(alpha: 0.6),
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      CircularProgressIndicator(value: value),
                                      const SizedBox(height: 14),
                                      Text(
                                        value == null
                                            ? 'Starting download...'
                                            : 'Downloading ${(value * 100).round()}%',
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                          errorBuilder:
                              (
                                BuildContext context,
                                Object error,
                                StackTrace? stackTrace,
                              ) {
                                return _ImageErrorBox(
                                  width: 240,
                                  height: 160,
                                  message: 'Progress demo failed',
                                );
                              },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _SectionCard(
                title: 'imageBuilder For Custom UI',
                description:
                    'Use `imageBuilder` when the final result needs an '
                    '`ImageProvider`, such as a background decoration.',
                child: CachedNetworkImage(
                  imageUrl: _cardUrl,
                  cacheManager: _customCacheManager,
                  imageBuilder:
                      (BuildContext context, ImageProvider imageProvider) {
                        return Container(
                          width: double.infinity,
                          height: 220,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(
                                Colors.black.withValues(alpha: 0.34),
                                BlendMode.darken,
                              ),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.88),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  'imageBuilder + DecorationImage',
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Text(
                                'Build hero cards, banners, and marketing '
                                'surfaces from one cached network source.',
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                  placeholder: (BuildContext context, String url) {
                    return Container(
                      width: double.infinity,
                      height: 220,
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(),
                    );
                  },
                  errorBuilder:
                      (
                        BuildContext context,
                        Object error,
                        StackTrace? stackTrace,
                      ) {
                        return const _ImageErrorBox(
                          width: double.infinity,
                          height: 220,
                          message: 'Banner image failed',
                        );
                      },
                ),
              ),
              const SizedBox(height: 16),
              _SectionCard(
                title: 'Transparent Images',
                description:
                    'A checkerboard background makes transparent PNG edges '
                    'obvious while `cached_network_image_ce` still handles the '
                    'fetch, cache, placeholder, and failure states.',
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: <Widget>[
                    _DemoTile(
                      width: 280,
                      title: 'Transparent PNG + Checkerboard',
                      subtitle:
                          'Keep alpha visible by placing the network image '
                          'above a custom background instead of flattening it '
                          'into an opaque box.',
                      child: _TransparentImageDemo(
                        imageUrl: _transparentPngUrl,
                        cacheManager: _customCacheManager,
                      ),
                    ),
                    _DemoTile(
                      width: 280,
                      title: 'When To Use It',
                      subtitle:
                          'This pattern works well for logos, stickers, and '
                          'product cutouts that need to sit on different card '
                          'or theme colors.',
                      child: Container(
                        width: 240,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest.withValues(
                            alpha: 0.55,
                          ),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Text(
                          'Use `imageBuilder` or a `Stack` when the alpha '
                          'channel matters. That gives you control over the '
                          'surface behind the downloaded image.',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _SectionCard(
                title: 'CachedNetworkImageProvider Reuse',
                description:
                    'The provider API is useful when Flutter expects an '
                    '`ImageProvider`, not a widget.',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        _ProviderAvatar(
                          provider: avatarProvider,
                          backgroundColor: colorScheme.primaryContainer,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            'The same `CachedNetworkImageProvider` can be used '
                            'in `CircleAvatar`, `Image`, and `DecorationImage` '
                            'without reworking the layout.',
                            style: theme.textTheme.bodyLarge,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: <Widget>[
                        _DemoTile(
                          title: 'Image(image: provider)',
                          subtitle:
                              'Use the provider with the generic Image widget.',
                          child: _ProviderImageSurface(
                            provider: avatarProvider,
                            width: 108,
                            height: 108,
                            borderRadius: 18,
                          ),
                        ),
                        _DemoTile(
                          title: 'Provider In A Card',
                          subtitle:
                              'Reuse the same provider in a custom surface with '
                              'an explicit error fallback.',
                          child: _ProviderCardSurface(provider: avatarProvider),
                        ),
                        _DemoTile(
                          width: 280,
                          title: 'Provider Pattern',
                          subtitle:
                              'Wrap provider-based rendering with your own '
                              'placeholder and failure treatment when the device '
                              'is offline.',
                          child: Container(
                            width: 220,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainerHighest
                                  .withValues(alpha: 0.55),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Text(
                              'This keeps the provider example intact without '
                              'depending on `CircleAvatar.backgroundImage` or '
                              '`DecorationImage` error behavior.',
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _SectionCard(
                title: 'Cache Tuning And URL Changes',
                description:
                    'This example keeps the previous image visible while the new '
                    'URL loads, and shows how to evict the cache manually.',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: <Widget>[
                        FilledButton.icon(
                          onPressed: () {
                            setState(() {
                              _useAltHero = !_useAltHero;
                            });
                          },
                          icon: const Icon(Icons.swap_horiz),
                          label: const Text('Swap Image URL'),
                        ),
                        OutlinedButton.icon(
                          onPressed: _evictCurrentImage,
                          icon: const Icon(Icons.delete_sweep_outlined),
                          label: const Text('Evict Current Cache'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Active URL: $_activeHeroUrl',
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CachedNetworkImage(
                        key: ValueKey<String>('$_activeHeroUrl-$_reloadTick'),
                        imageUrl: _activeHeroUrl,
                        cacheManager: _customCacheManager,
                        width: double.infinity,
                        height: 220,
                        fit: BoxFit.cover,
                        memCacheWidth: 720,
                        maxWidthDiskCache: 960,
                        useOldImageOnUrlChange: true,
                        fadeInDuration: const Duration(milliseconds: 350),
                        fadeOutDuration: const Duration(milliseconds: 180),
                        progressIndicatorBuilder:
                            (
                              BuildContext context,
                              String url,
                              DownloadProgress progress,
                            ) {
                              return Container(
                                width: double.infinity,
                                height: 220,
                                color: colorScheme.tertiaryContainer.withValues(
                                  alpha: 0.55,
                                ),
                                alignment: Alignment.center,
                                child: CircularProgressIndicator(
                                  value: progress.progress,
                                ),
                              );
                            },
                        errorBuilder:
                            (
                              BuildContext context,
                              Object error,
                              StackTrace? stackTrace,
                            ) {
                              return const _ImageErrorBox(
                                width: double.infinity,
                                height: 220,
                                message: 'Swappable image failed',
                              );
                            },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _SectionCard(
                title: 'Error Handling',
                description:
                    'Use `errorBuilder` to keep the layout stable when the '
                    'request fails.',
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: <Widget>[
                    _DemoTile(
                      width: 280,
                      title: 'Toggle errorBuilder',
                      subtitle:
                          'Starts with a working image. Tap the button to switch '
                          'to a broken URL and verify the fallback UI.',
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          OutlinedButton.icon(
                            onPressed: () {
                              setState(() {
                                _simulateError = !_simulateError;
                              });
                            },
                            icon: Icon(
                              _simulateError
                                  ? Icons.check_circle_outline
                                  : Icons.error_outline,
                            ),
                            label: Text(
                              _simulateError
                                  ? 'Use working image'
                                  : 'Use broken URL',
                            ),
                          ),
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: CachedNetworkImage(
                              imageUrl: _simulateError
                                  ? _brokenUrl
                                  : _errorDemoUrl,
                              width: 240,
                              height: 150,
                              fit: BoxFit.cover,
                              placeholder: (BuildContext context, String url) {
                                return Container(
                                  width: 240,
                                  height: 150,
                                  color: colorScheme.surfaceContainerHighest,
                                  alignment: Alignment.center,
                                  child: const CircularProgressIndicator(),
                                );
                              },
                              errorBuilder:
                                  (
                                    BuildContext context,
                                    Object error,
                                    StackTrace? stackTrace,
                                  ) {
                                    return _ImageErrorBox(
                                      width: 240,
                                      height: 150,
                                      message: 'Handled with errorBuilder',
                                    );
                                  },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
            colors: <Color>[Color(0xFF0F172A), Color(0xFF1E293B)],
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
              Text('CachedNetworkImage('),
              Text("  imageUrl: transparentPngUrl,"),
              Text('  imageBuilder: (context, provider) {'),
              Text(
                '    return Stack(children: [checkerboard, Image(image: provider)]);',
              ),
              Text('  },'),
              Text('  placeholder: (...),'),
              Text('  errorBuilder: (...),'),
              Text(')'),
            ],
          ),
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

class _DemoTile extends StatelessWidget {
  const _DemoTile({
    required this.title,
    required this.subtitle,
    required this.child,
    this.width = 220,
  });

  final String title;
  final String subtitle;
  final Widget child;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.42),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(child: child),
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

class _ImageErrorBox extends StatelessWidget {
  const _ImageErrorBox({
    required this.width,
    required this.height,
    required this.message,
  });

  final double width;
  final double height;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: Theme.of(context).colorScheme.errorContainer,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(16),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.onErrorContainer,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ProviderAvatar extends StatelessWidget {
  const _ProviderAvatar({
    required this.provider,
    required this.backgroundColor,
  });

  final CachedNetworkImageProvider provider;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 28,
      backgroundColor: backgroundColor,
      child: ClipOval(
        child: Image(
          image: provider,
          width: 56,
          height: 56,
          fit: BoxFit.cover,
          errorBuilder:
              (BuildContext context, Object error, StackTrace? stackTrace) {
                return Icon(
                  Icons.person_outline_rounded,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                );
              },
        ),
      ),
    );
  }
}

class _TransparentImageDemo extends StatelessWidget {
  const _TransparentImageDemo({
    required this.imageUrl,
    required this.cacheManager,
  });

  final String imageUrl;
  final DefaultCacheManager cacheManager;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        cacheManager: cacheManager,
        width: 240,
        height: 180,
        fit: BoxFit.contain,
        imageBuilder: (BuildContext context, ImageProvider imageProvider) {
          return Stack(
            children: <Widget>[
              const Positioned.fill(child: _CheckerboardBackground()),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[
                        Theme.of(
                          context,
                        ).colorScheme.primaryContainer.withValues(alpha: 0.26),
                        Theme.of(
                          context,
                        ).colorScheme.tertiaryContainer.withValues(alpha: 0.36),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Image(image: imageProvider, fit: BoxFit.contain),
                ),
              ),
            ],
          );
        },
        placeholder: (BuildContext context, String url) {
          return Stack(
            children: <Widget>[
              const Positioned.fill(child: _CheckerboardBackground()),
              Positioned.fill(
                child: Container(
                  color: Theme.of(
                    context,
                  ).colorScheme.surface.withValues(alpha: 0.72),
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(),
                ),
              ),
            ],
          );
        },
        errorBuilder:
            (BuildContext context, Object error, StackTrace? stackTrace) {
              return Stack(
                children: <Widget>[
                  const Positioned.fill(child: _CheckerboardBackground()),
                  const Positioned.fill(
                    child: _ImageErrorBox(
                      width: 240,
                      height: 180,
                      message: 'Transparent image failed',
                    ),
                  ),
                ],
              );
            },
      ),
    );
  }
}

class _CheckerboardBackground extends StatelessWidget {
  const _CheckerboardBackground();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CheckerboardPainter(
        lightColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        darkColor: Theme.of(
          context,
        ).colorScheme.surfaceContainerHigh.withValues(alpha: 0.92),
      ),
      child: const SizedBox.expand(),
    );
  }
}

class _CheckerboardPainter extends CustomPainter {
  const _CheckerboardPainter({
    required this.lightColor,
    required this.darkColor,
  });

  final Color lightColor;
  final Color darkColor;
  static const double _squareSize = 18;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint lightPaint = Paint()..color = lightColor;
    final Paint darkPaint = Paint()..color = darkColor;

    canvas.drawRect(Offset.zero & size, lightPaint);

    for (double y = 0; y < size.height; y += _squareSize) {
      for (double x = 0; x < size.width; x += _squareSize) {
        final int row = (y / _squareSize).floor();
        final int column = (x / _squareSize).floor();
        if ((row + column).isEven) {
          continue;
        }

        canvas.drawRect(
          Rect.fromLTWH(x, y, _squareSize, _squareSize),
          darkPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_CheckerboardPainter oldDelegate) {
    return oldDelegate.lightColor != lightColor ||
        oldDelegate.darkColor != darkColor;
  }
}

class _ProviderImageSurface extends StatelessWidget {
  const _ProviderImageSurface({
    required this.provider,
    required this.width,
    required this.height,
    required this.borderRadius,
  });

  final CachedNetworkImageProvider provider;
  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image(
        image: provider,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder:
            (BuildContext context, Object error, StackTrace? stackTrace) {
              return _ImageErrorBox(
                width: width,
                height: height,
                message: 'Provider load failed',
              );
            },
      ),
    );
  }
}

class _ProviderCardSurface extends StatelessWidget {
  const _ProviderCardSurface({required this.provider});

  final CachedNetworkImageProvider provider;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Stack(
        children: <Widget>[
          Image(
            image: provider,
            width: 180,
            height: 108,
            fit: BoxFit.cover,
            errorBuilder:
                (BuildContext context, Object error, StackTrace? stackTrace) {
                  return _ImageErrorBox(
                    width: 180,
                    height: 108,
                    message: 'Provider card failed',
                  );
                },
          ),
          Container(
            width: 180,
            height: 108,
            color: Colors.black.withValues(alpha: 0.18),
            padding: const EdgeInsets.all(12),
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: colorScheme.surface.withValues(alpha: 0.88),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                'Provider Reuse',
                style: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
