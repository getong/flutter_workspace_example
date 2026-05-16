import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';

@RoutePage(name: RouteName.photoView)
class PhotoViewPage extends StatefulWidget {
  const PhotoViewPage({super.key});

  @override
  State<PhotoViewPage> createState() => _PhotoViewPageState();
}

class _PhotoViewPageState extends State<PhotoViewPage> {
  late final PhotoViewController _controller;
  late final PhotoViewScaleStateController _scaleStateController;
  late final PageController _pageController;

  int _currentIndex = 0;
  PhotoViewControllerValue? _controllerValue;

  static const List<String> _images = <String>[
    'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?w=1200',
    'https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=1200',
    'https://images.unsplash.com/photo-1518837695005-2083093ee35b?w=1200',
  ];

  @override
  void initState() {
    super.initState();
    _controller = PhotoViewController();
    _scaleStateController = PhotoViewScaleStateController();
    _pageController = PageController();
    _controller.outputStateStream.listen((PhotoViewControllerValue value) {
      if (mounted) {
        setState(() {
          _controllerValue = value;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scaleStateController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _animateToContained() {
    _scaleStateController.scaleState = PhotoViewScaleState.initial;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('photo_view Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'photo_view makes an image or any custom child zoomable, pannable, and gesture-sensitive. The package is commonly used for image preview pages, product detail zoom, map-like detail views, and media galleries.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            _SectionCard(
              title: 'Basic PhotoView',
              description:
                  'The simplest entry point is `PhotoView(imageProvider: ...)`. You get pinch-to-zoom, drag-to-pan, double-tap scaling, and boundary-aware gesture behavior without writing gesture math manually.',
              child: SizedBox(
                height: 280,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: PhotoView(
                    imageProvider: NetworkImage(_images[0]),
                    backgroundDecoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                    ),
                    minScale: PhotoViewComputedScale.contained,
                    maxScale: PhotoViewComputedScale.covered * 2.2,
                    controller: _controller,
                    scaleStateController: _scaleStateController,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Controllers',
              description:
                  'When you need external control, use `PhotoViewController` and `PhotoViewScaleStateController`. They let you reset scale, observe position changes, and coordinate with the rest of your page state.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: <Widget>[
                      FilledButton(
                        onPressed: _animateToContained,
                        child: const Text('Reset Scale'),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          _scaleStateController.scaleState =
                              PhotoViewScaleState.covering;
                        },
                        child: const Text('Cover'),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          _scaleStateController.scaleState =
                              PhotoViewScaleState.zoomedIn;
                        },
                        child: const Text('Zoom In'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Current scale: ${_controllerValue?.scale?.toStringAsFixed(2) ?? 'n/a'}',
                  ),
                  Text(
                    'Current position: ${_controllerValue?.position ?? Offset.zero}',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'PhotoViewGallery',
              description:
                  '`PhotoViewGallery` is the right choice when you have multiple images. It combines swipe-based paging with per-page zoom and is the usual solution for gallery/lightbox style screens.',
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 320,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: PhotoViewGallery.builder(
                        itemCount: _images.length,
                        pageController: _pageController,
                        backgroundDecoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                        ),
                        onPageChanged: (int index) {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                        builder: (BuildContext context, int index) {
                          return PhotoViewGalleryPageOptions(
                            imageProvider: NetworkImage(_images[index]),
                            minScale: PhotoViewComputedScale.contained,
                            maxScale: PhotoViewComputedScale.covered * 2.5,
                            heroAttributes: PhotoViewHeroAttributes(
                              tag: 'photo-view-$index',
                            ),
                          );
                        },
                        loadingBuilder:
                            (BuildContext context, ImageChunkEvent? event) =>
                                const Center(
                                  child: CircularProgressIndicator(),
                                ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Gallery page: ${_currentIndex + 1} / ${_images.length}',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Usage Notes',
              description:
                  'Use PhotoView when you need precise media inspection. For ordinary image display, `Image` is simpler. PhotoView is most valuable when the user needs to zoom into detail.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const <Widget>[
                  Text('Recommended patterns:'),
                  SizedBox(height: 8),
                  Text('• Wrap it in a bounded height/width container.'),
                  Text(
                    '• Use `PhotoViewGallery` for albums, not a manual PageView + PhotoView combination unless you need custom coordination.',
                  ),
                  Text(
                    '• Add hero attributes when transitioning from thumbnails to detail screens.',
                  ),
                  Text(
                    '• Use controllers only when you genuinely need external scale or position control.',
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
