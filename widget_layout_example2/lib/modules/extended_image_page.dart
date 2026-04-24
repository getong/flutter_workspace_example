import 'package:auto_route/auto_route.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:widget_layout_example2/app_navigation.dart';

enum _EditorAspect {
  free('Free', null),
  square('1:1', 1),
  landscape('4:3', 4 / 3),
  portrait('3:4', 3 / 4);

  const _EditorAspect(this.label, this.ratio);

  final String label;
  final double? ratio;
}

@RoutePage(name: RouteName.extendedImage)
class ExtendedImagePage extends StatefulWidget {
  const ExtendedImagePage({super.key});

  @override
  State<ExtendedImagePage> createState() => _ExtendedImagePageState();
}

class _ExtendedImagePageState extends State<ExtendedImagePage> {
  static const String _assetPath = 'assets/images/image_module_demo.png';
  static const String _networkImageUrl =
      'https://raw.githubusercontent.com/fluttercandies/flutter_candies/master/gif/extended_text/special_text.jpg';

  final GlobalKey<ExtendedImageGestureState> _gestureKey =
      GlobalKey<ExtendedImageGestureState>();
  final ImageEditorController _editorController = ImageEditorController();

  Uint8List? _memoryImageBytes;
  _EditorAspect _selectedAspect = _EditorAspect.landscape;

  @override
  void initState() {
    super.initState();
    _loadMemoryBytes();
  }

  Future<void> _loadMemoryBytes() async {
    final ByteData bytes = await rootBundle.load(_assetPath);
    if (!mounted) {
      return;
    }

    setState(() {
      _memoryImageBytes = bytes.buffer.asUint8List();
    });
  }

  void _applyAspect(_EditorAspect aspect) {
    setState(() {
      _selectedAspect = aspect;
    });
    _editorController.updateCropAspectRatio(aspect.ratio);
  }

  @override
  void dispose() {
    _editorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('extended_image Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            Text(
              'extended_image extends Flutter image rendering with richer load-state handling, gesture zooming, and built-in editor mode for crop, rotate, flip, and undo/redo workflows.',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'This module demonstrates practical usage with `ExtendedImage.asset`, `ExtendedImage.memory`, `ExtendedImage.network`, `loadStateChanged`, `ExtendedImageMode.gesture`, `ExtendedImageMode.editor`, `GestureConfig`, and `ImageEditorController`.',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            _SectionCard(
              title: 'Constructors and Common UI Usage',
              description:
                  'Use the same package widget with assets, memory bytes, and network images while keeping Flutter layout, clipping, and decoration patterns.',
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: <Widget>[
                  _DemoTile(
                    title: 'ExtendedImage.asset',
                    subtitle:
                        'Local assets still fit naturally into cards and clipped containers.',
                    child: ExtendedImage.asset(
                      _assetPath,
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                      borderRadius: BorderRadius.circular(20),
                      shape: BoxShape.rectangle,
                    ),
                  ),
                  _DemoTile(
                    title: 'ExtendedImage.memory',
                    subtitle:
                        'Memory bytes are useful after downloads, transforms, or encrypted file reads.',
                    child: _memoryImageBytes == null
                        ? const SizedBox(
                            width: 120,
                            height: 120,
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : ExtendedImage.memory(
                            _memoryImageBytes!,
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                            shape: BoxShape.circle,
                          ),
                  ),
                  _DemoTile(
                    title: 'ExtendedImage.network',
                    subtitle:
                        'Network images can be cached, clipped, and sized like any other widget.',
                    child: ExtendedImage.network(
                      _networkImageUrl,
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                      cache: true,
                      borderRadius: BorderRadius.circular(20),
                      shape: BoxShape.rectangle,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Load State Handling',
              description:
                  'The package exposes progress, failure, and retry hooks through `loadStateChanged`, which is where it moves beyond standard `Image` usage.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: SizedBox(
                      height: 240,
                      width: double.infinity,
                      child: ExtendedImage.network(
                        _networkImageUrl,
                        fit: BoxFit.cover,
                        cache: true,
                        handleLoadingProgress: true,
                        enableLoadState: true,
                        clearMemoryCacheIfFailed: true,
                        loadStateChanged: (ExtendedImageState state) {
                          switch (state.extendedImageLoadState) {
                            case LoadState.loading:
                              final ImageChunkEvent? progressEvent =
                                  state.loadingProgress;
                              final double? progress =
                                  progressEvent?.expectedTotalBytes != null
                                  ? progressEvent!.cumulativeBytesLoaded /
                                        progressEvent.expectedTotalBytes!
                                  : null;
                              return Container(
                                color: colorScheme.surfaceContainerHighest,
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    CircularProgressIndicator(value: progress),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Downloading image ${progress == null ? '' : '${(progress * 100).toStringAsFixed(0)}%'}',
                                      style: theme.textTheme.titleMedium,
                                    ),
                                  ],
                                ),
                              );
                            case LoadState.completed:
                              return Stack(
                                fit: StackFit.expand,
                                children: <Widget>[
                                  state.completedWidget,
                                  Positioned(
                                    top: 12,
                                    right: 12,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: Colors.black.withValues(
                                          alpha: 0.55,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          999,
                                        ),
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 8,
                                        ),
                                        child: Text(
                                          'cache: true',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            case LoadState.failed:
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    const Icon(Icons.error_outline, size: 40),
                                    const SizedBox(height: 12),
                                    const Text('Image load failed'),
                                    const SizedBox(height: 12),
                                    OutlinedButton(
                                      onPressed: state.reLoadImage,
                                      child: const Text('Retry'),
                                    ),
                                  ],
                                ),
                              );
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card.outlined(
                    child: ListTile(
                      leading: SizedBox(
                        width: 44,
                        height: 44,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: ExtendedImage.asset(
                            _assetPath,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      title: const Text('ExtendedImage inside ListTile'),
                      subtitle: const Text(
                        'A compact example for feed rows, media lists, or settings screens.',
                      ),
                      trailing: FilledButton(
                        onPressed: clearMemoryImageCache,
                        child: const Text('Clear memory cache'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Gesture Mode',
              description:
                  'Set `mode: ExtendedImageMode.gesture` when you need pinch zoom, drag, and double-tap style image exploration.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: <Widget>[
                      FilledButton.icon(
                        onPressed: () => _gestureKey.currentState?.reset(),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Reset gesture state'),
                      ),
                      Chip(
                        label: const Text(
                          'Pinch, drag, trackpad scroll, or double tap',
                        ),
                        avatar: const Icon(
                          Icons.pan_tool_alt_outlined,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      height: 260,
                      color: Colors.black,
                      child: ExtendedImage.network(
                        _networkImageUrl,
                        fit: BoxFit.contain,
                        mode: ExtendedImageMode.gesture,
                        extendedImageGestureKey: _gestureKey,
                        initGestureConfigHandler: (ExtendedImageState state) {
                          return GestureConfig(
                            minScale: 0.9,
                            animationMinScale: 0.8,
                            maxScale: 4.0,
                            animationMaxScale: 4.5,
                            speed: 1.0,
                            inertialSpeed: 90.0,
                            initialScale: 1.0,
                            inPageView: false,
                            initialAlignment: InitialAlignment.center,
                            reverseMousePointerScrollDirection: true,
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
              title: 'Editor Mode',
              description:
                  'Use `ExtendedImageMode.editor` when the page needs crop, rotate, flip, history, and aspect-ratio controls without building a full editor from scratch.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _EditorAspect.values
                        .map((_EditorAspect aspect) {
                          return ChoiceChip(
                            label: Text(aspect.label),
                            selected: _selectedAspect == aspect,
                            onSelected: (bool selected) {
                              if (selected) {
                                _applyAspect(aspect);
                              }
                            },
                          );
                        })
                        .toList(growable: false),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 320,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: ColoredBox(
                        color: colorScheme.surfaceContainerHighest,
                        child: ExtendedImage.asset(
                          _assetPath,
                          fit: BoxFit.contain,
                          mode: ExtendedImageMode.editor,
                          enableLoadState: true,
                          cacheRawData: true,
                          initEditorConfigHandler: (ExtendedImageState? state) {
                            return EditorConfig(
                              maxScale: 5,
                              cropRectPadding: const EdgeInsets.all(24),
                              hitTestSize: 20,
                              initCropRectType: InitCropRectType.imageRect,
                              cropAspectRatio: _selectedAspect.ratio,
                              controller: _editorController,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  AnimatedBuilder(
                    animation: _editorController,
                    builder: (BuildContext context, Widget? child) {
                      final Rect? cropRect = _editorController.getCropRect();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: <Widget>[
                              FilledButton.icon(
                                onPressed: () => _editorController.rotate(
                                  degree: 90,
                                  animation: true,
                                ),
                                icon: const Icon(Icons.rotate_right),
                                label: const Text('Rotate 90°'),
                              ),
                              OutlinedButton.icon(
                                onPressed: () =>
                                    _editorController.flip(animation: true),
                                icon: const Icon(Icons.flip),
                                label: const Text('Flip'),
                              ),
                              OutlinedButton.icon(
                                onPressed: _editorController.canUndo
                                    ? _editorController.undo
                                    : null,
                                icon: const Icon(Icons.undo),
                                label: const Text('Undo'),
                              ),
                              OutlinedButton.icon(
                                onPressed: _editorController.canRedo
                                    ? _editorController.redo
                                    : null,
                                icon: const Icon(Icons.redo),
                                label: const Text('Redo'),
                              ),
                              TextButton.icon(
                                onPressed: _editorController.reset,
                                icon: const Icon(Icons.restart_alt),
                                label: const Text('Reset'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'rotateDegrees: ${_editorController.rotateDegrees.toStringAsFixed(0)}\n'
                              'canUndo: ${_editorController.canUndo} | canRedo: ${_editorController.canRedo}\n'
                              'cropAspectRatio: ${_editorController.cropAspectRatio?.toStringAsFixed(2) ?? 'free'}\n'
                              'cropRect: ${cropRect == null ? 'not ready' : '${cropRect.width.toStringAsFixed(0)} x ${cropRect.height.toStringAsFixed(0)}'}',
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      );
                    },
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
        padding: const EdgeInsets.all(20),
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
    final ThemeData theme = Theme.of(context);
    return SizedBox(
      width: 220,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(child: child),
              const SizedBox(height: 16),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(subtitle, style: theme.textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}
