import 'dart:convert';
import 'dart:typed_data';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:widget_layout_example2/app_navigation.dart';

@RoutePage(name: RouteName.gal)
class GalPage extends StatefulWidget {
  const GalPage({super.key});

  @override
  State<GalPage> createState() => _GalPageState();
}

class _GalPageState extends State<GalPage> {
  bool? _hasAccess;
  String _status = 'No gallery action yet.';

  static const String _samplePngBase64 =
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAusB9Wn2wS8AAAAASUVORK5CYII=';

  Future<void> _checkAccess({bool toAlbum = false}) async {
    final bool hasAccess = await Gal.hasAccess(toAlbum: toAlbum);
    if (!mounted) {
      return;
    }
    setState(() {
      _hasAccess = hasAccess;
      _status = toAlbum
          ? 'Album access: $hasAccess'
          : 'Gallery access: $hasAccess';
    });
  }

  Future<void> _requestAccess({bool toAlbum = false}) async {
    await Gal.requestAccess(toAlbum: toAlbum);
    await _checkAccess(toAlbum: toAlbum);
  }

  Future<void> _saveImageBytes() async {
    try {
      final Uint8List bytes = base64Decode(_samplePngBase64);
      await Gal.putImageBytes(
        bytes,
        album: 'widget_layout_example2',
        name: 'gal_demo_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _status = 'Saved demo PNG bytes to gallery successfully.';
      });
    } on GalException catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _status = 'GalException: ${error.type.name}';
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _status = 'Unexpected error: $error';
      });
    }
  }

  Future<void> _openGallery() async {
    try {
      await Gal.open();
      if (!mounted) {
        return;
      }
      setState(() {
        _status = 'Requested gallery app open.';
      });
    } on GalException catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _status = 'Open gallery failed: ${error.type.name}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('gal Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'gal is a gallery save plugin. Its main use case is saving image bytes, image files, or video files into the user photo library with permission handling built in.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            _SectionCard(
              title: 'What It Does',
              description:
                  'Use gal when your app exports generated images, camera captures, edited media, or downloaded files into the system gallery instead of only keeping them in app storage.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const <Widget>[
                  Text('Common methods:'),
                  SizedBox(height: 8),
                  Text('• `Gal.putImage(path)` saves an existing image file.'),
                  Text(
                    '• `Gal.putImageBytes(bytes)` saves in-memory image data.',
                  ),
                  Text('• `Gal.putVideo(path)` saves an existing video file.'),
                  Text(
                    '• `Gal.hasAccess()` and `Gal.requestAccess()` handle permission checks.',
                  ),
                  Text(
                    '• `album:` lets you save into a named album when the platform supports it.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Platform Setup',
              description:
                  'The package works only after platform permission strings and manifest entries are configured correctly.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const <Widget>[
                  Text('iOS / macOS:'),
                  SizedBox(height: 6),
                  Text(
                    'Add `NSPhotoLibraryAddUsageDescription`. Add `NSPhotoLibraryUsageDescription` as well when older iOS versions or album-specific access are involved.',
                  ),
                  SizedBox(height: 12),
                  Text('Android:'),
                  SizedBox(height: 6),
                  Text(
                    'For Android API 29 and below, older storage permissions may still matter. Album-specific behavior can also depend on manifest setup.',
                  ),
                  SizedBox(height: 12),
                  Text(
                    'In practice: if save calls fail immediately, check platform setup before debugging Dart code.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Interactive Demo',
              description:
                  'This demo uses `putImageBytes` with a tiny in-memory PNG, so you can see the gal workflow without adding extra assets.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: <Widget>[
                      FilledButton(
                        onPressed: _checkAccess,
                        child: const Text('Check Access'),
                      ),
                      OutlinedButton(
                        onPressed: _requestAccess,
                        child: const Text('Request Access'),
                      ),
                      OutlinedButton(
                        onPressed: () => _requestAccess(toAlbum: true),
                        child: const Text('Request Album Access'),
                      ),
                      FilledButton.tonal(
                        onPressed: _saveImageBytes,
                        child: const Text('Save Demo PNG'),
                      ),
                      TextButton(
                        onPressed: _openGallery,
                        child: const Text('Open Gallery'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Last status: $_status',
                    style: theme.textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Cached access result: ${_hasAccess ?? 'unknown'}',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Usage Pattern',
              description:
                  'In a real feature, the usual sequence is permission check -> generate or locate file -> save -> catch `GalException` -> show user feedback.',
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'final hasAccess = await Gal.hasAccess();\n'
                  'if (!hasAccess) {\n'
                  '  await Gal.requestAccess();\n'
                  '}\n'
                  'await Gal.putImageBytes(bytes, album: \'Exports\');',
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
