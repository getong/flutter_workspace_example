import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:fc_native_video_thumbnail/fc_native_video_thumbnail.dart';
import 'package:fc_native_video_thumbnail/fc_native_video_thumbnail_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';

const String _sampleVideoUrl =
    'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4';

final FcNativeVideoThumbnail _thumbnailPlugin = FcNativeVideoThumbnail();

class _ThumbnailPreview {
  const _ThumbnailPreview({
    required this.title,
    required this.sourceLabel,
    required this.apiLabel,
    required this.bytes,
    required this.dimensionsLabel,
    this.detailLabel,
    this.filePath,
  });

  final String title;
  final String sourceLabel;
  final String apiLabel;
  final Uint8List bytes;
  final String dimensionsLabel;
  final String? detailLabel;
  final String? filePath;
}

class _ThumbnailDemoResult {
  const _ThumbnailDemoResult({
    required this.previews,
    required this.downloadedVideoPath,
  });

  final List<_ThumbnailPreview> previews;
  final String downloadedVideoPath;
}

@RoutePage(name: RouteName.fcNativeVideoThumbnail)
class FcNativeVideoThumbnailPage extends StatefulWidget {
  const FcNativeVideoThumbnailPage({super.key});

  @override
  State<FcNativeVideoThumbnailPage> createState() =>
      _FcNativeVideoThumbnailPageState();
}

class _FcNativeVideoThumbnailPageState
    extends State<FcNativeVideoThumbnailPage> {
  int _quality = 88;
  int _maxWidth = 320;
  int _maxHeight = 180;
  int _focusSeconds = 1;
  late Future<_ThumbnailDemoResult> _demoFuture;

  bool get _isSupportedPlatform {
    if (kIsWeb) {
      return false;
    }

    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.windows;
  }

  bool get _supportsUriSource {
    if (!_isSupportedPlatform) {
      return false;
    }

    return defaultTargetPlatform != TargetPlatform.windows;
  }

  @override
  void initState() {
    super.initState();
    _demoFuture = _loadDemo();
  }

  Future<_ThumbnailDemoResult> _loadDemo() async {
    if (!_isSupportedPlatform) {
      return const _ThumbnailDemoResult(
        previews: <_ThumbnailPreview>[],
        downloadedVideoPath: '',
      );
    }

    final String localVideoPath = await _downloadSampleVideo();
    final List<_ThumbnailPreview> previews = <_ThumbnailPreview>[];

    if (_supportsUriSource) {
      final Uint8List? uriBytes = await _thumbnailPlugin.saveThumbnailToBytes(
        srcFile: _sampleVideoUrl,
        srcFileUri: true,
        width: _maxWidth,
        height: _maxHeight,
        format: 'jpeg',
        quality: _quality,
        at: FcVideoThumbnailTime(
          _focusSeconds,
          FcVideoThumbnailTimeUnit.seconds,
        ),
      );

      if (uriBytes != null) {
        previews.add(
          await _buildPreview(
            title: 'Remote URI -> bytes',
            sourceLabel: 'URI source',
            apiLabel: 'saveThumbnailToBytes',
            detailLabel: 'Seeking at ${_focusSeconds}s',
            bytes: uriBytes,
          ),
        );
      }
    }

    final Uint8List? pathBytes = await _thumbnailPlugin.saveThumbnailToBytes(
      srcFile: localVideoPath,
      width: _maxWidth,
      height: _maxHeight,
      format: 'jpeg',
      quality: _quality,
    );

    if (pathBytes != null) {
      previews.add(
        await _buildPreview(
          title: 'Local file path -> bytes',
          sourceLabel: 'Path source',
          apiLabel: 'saveThumbnailToBytes',
          detailLabel: 'Works across the plugin-supported native platforms.',
          bytes: pathBytes,
        ),
      );
    }

    final String outputPath =
        '${Directory.systemTemp.path}/fc_native_video_thumbnail_'
        '${_maxWidth}x$_maxHeight'
        '_q$_quality'
        '_t$_focusSeconds.jpg';

    final bool didSave = await _thumbnailPlugin.saveThumbnailToFile(
      srcFile: localVideoPath,
      destFile: outputPath,
      width: _maxWidth,
      height: _maxHeight,
      format: 'jpeg',
      quality: _quality,
    );

    if (didSave) {
      final Uint8List fileBytes = await File(outputPath).readAsBytes();
      previews.add(
        await _buildPreview(
          title: 'Local file path -> saved JPEG',
          sourceLabel: 'Path source',
          apiLabel: 'saveThumbnailToFile',
          detailLabel: 'Saved to a temporary file for reuse or sharing.',
          bytes: fileBytes,
          filePath: outputPath,
        ),
      );
    }

    if (previews.isEmpty) {
      throw StateError(
        'The plugin did not return a thumbnail for the sample video on this platform.',
      );
    }

    return _ThumbnailDemoResult(
      previews: previews,
      downloadedVideoPath: localVideoPath,
    );
  }

  Future<_ThumbnailPreview> _buildPreview({
    required String title,
    required String sourceLabel,
    required String apiLabel,
    required Uint8List bytes,
    String? detailLabel,
    String? filePath,
  }) async {
    final decodedImage = await decodeImageFromList(bytes);
    return _ThumbnailPreview(
      title: title,
      sourceLabel: sourceLabel,
      apiLabel: apiLabel,
      bytes: bytes,
      detailLabel: detailLabel,
      filePath: filePath,
      dimensionsLabel:
          '${decodedImage.width}x${decodedImage.height} px, ${bytes.length} bytes',
    );
  }

  Future<String> _downloadSampleVideo() async {
    final String fileName = Uri.parse(_sampleVideoUrl).pathSegments.last;
    final String path =
        '${Directory.systemTemp.path}/fc_native_video_thumbnail_$fileName';
    final File file = File(path);

    if (await file.exists() && await file.length() > 0) {
      return file.path;
    }

    final HttpClient client = HttpClient();
    try {
      final HttpClientRequest request = await client.getUrl(
        Uri.parse(_sampleVideoUrl),
      );
      final HttpClientResponse response = await request.close();
      if (response.statusCode != HttpStatus.ok) {
        throw HttpException(
          'Sample video download failed with ${response.statusCode}.',
          uri: Uri.parse(_sampleVideoUrl),
        );
      }

      final Uint8List bytes = await consolidateHttpClientResponseBytes(
        response,
      );
      await file.writeAsBytes(bytes, flush: true);
      return file.path;
    } finally {
      client.close(force: true);
    }
  }

  void _refreshDemo() {
    setState(() {
      _demoFuture = _loadDemo();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('fc_native_video_thumbnail Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            Text(
              'Generate native video thumbnails as bytes or as files.',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '`fc_native_video_thumbnail` exposes two focused APIs: '
              '`saveThumbnailToBytes` for in-memory previews and '
              '`saveThumbnailToFile` for persisted JPEG output. This page '
              'demonstrates remote URI sources, downloaded local files, '
              'seek positions, quality, width, and height controls.',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            const _CodeSampleCard(
              title: 'Remote URI -> bytes',
              code: r'''
final bytes = await FcNativeVideoThumbnail().saveThumbnailToBytes(
  srcFile: videoUrl,
  srcFileUri: true,
  width: 320,
  height: 180,
  format: 'jpeg',
  quality: 88,
  at: FcVideoThumbnailTime(1, FcVideoThumbnailTimeUnit.seconds),
);

if (bytes != null) {
  return Image.memory(bytes);
}
''',
            ),
            const SizedBox(height: 16),
            const _CodeSampleCard(
              title: 'Local file path -> saved thumbnail file',
              code: r'''
final saved = await FcNativeVideoThumbnail().saveThumbnailToFile(
  srcFile: localVideoPath,
  destFile: '${Directory.systemTemp.path}/preview.jpg',
  width: 320,
  height: 180,
  format: 'jpeg',
  quality: 90,
);

if (saved) {
  debugPrint('Thumbnail written to disk.');
}
''',
            ),
            const SizedBox(height: 16),
            const _CodeSampleCard(
              title: 'Seeking with different time units',
              code: r'''
await FcNativeVideoThumbnail().saveThumbnailToBytes(
  srcFile: videoUrl,
  srcFileUri: true,
  width: 320,
  height: 180,
  at: FcVideoThumbnailTime(
    1500,
    FcVideoThumbnailTimeUnit.milliseconds,
  ),
);
''',
            ),
            const SizedBox(height: 24),
            _SectionCard(
              title: 'API Notes',
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: const <Widget>[
                  _InfoChip(
                    icon: Icons.memory,
                    label: 'Bytes API',
                    value: 'Image.memory or custom upload flows',
                  ),
                  _InfoChip(
                    icon: Icons.save_alt,
                    label: 'File API',
                    value: 'Temporary or shareable JPEG output',
                  ),
                  _InfoChip(
                    icon: Icons.link,
                    label: 'URI Source',
                    value: 'Android / iOS / macOS',
                  ),
                  _InfoChip(
                    icon: Icons.folder_open,
                    label: 'Path Source',
                    value: 'Android / iOS / macOS / Windows',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Live Demo',
              description:
                  'The page downloads a sample MP4 to a temporary path, then '
                  'runs both plugin APIs. URI-source seeking is shown where the '
                  'plugin supports it.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Remote sample: $_sampleVideoUrl',
                          style: theme.textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _supportsUriSource
                              ? 'URI-source preview is enabled on this platform.'
                              : 'URI-source preview is skipped here, so the demo falls back to a downloaded local file.',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (!_isSupportedPlatform)
                    const _UnsupportedPanel()
                  else ...<Widget>[
                    Text(
                      'Quality: $_quality',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Slider(
                      value: _quality.toDouble(),
                      min: 40,
                      max: 100,
                      divisions: 12,
                      label: '$_quality',
                      onChanged: (double value) {
                        setState(() {
                          _quality = value.round();
                        });
                      },
                    ),
                    Text(
                      'Max width: $_maxWidth px',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Slider(
                      value: _maxWidth.toDouble(),
                      min: 160,
                      max: 480,
                      divisions: 8,
                      label: '$_maxWidth',
                      onChanged: (double value) {
                        setState(() {
                          _maxWidth = value.round();
                        });
                      },
                    ),
                    Text(
                      'Max height: $_maxHeight px',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Slider(
                      value: _maxHeight.toDouble(),
                      min: 90,
                      max: 300,
                      divisions: 7,
                      label: '$_maxHeight',
                      onChanged: (double value) {
                        setState(() {
                          _maxHeight = value.round();
                        });
                      },
                    ),
                    Text(
                      'Seek position: ${_focusSeconds}s',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Slider(
                      value: _focusSeconds.toDouble(),
                      min: 0,
                      max: 4,
                      divisions: 4,
                      label: '${_focusSeconds}s',
                      onChanged: _supportsUriSource
                          ? (double value) {
                              setState(() {
                                _focusSeconds = value.round();
                              });
                            }
                          : null,
                    ),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: <Widget>[
                        FilledButton.icon(
                          onPressed: _refreshDemo,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Generate Thumbnails'),
                        ),
                        ActionChip(
                          label: const Text('160 x 90'),
                          onPressed: () {
                            setState(() {
                              _maxWidth = 160;
                              _maxHeight = 90;
                            });
                            _refreshDemo();
                          },
                        ),
                        ActionChip(
                          label: const Text('320 x 180'),
                          onPressed: () {
                            setState(() {
                              _maxWidth = 320;
                              _maxHeight = 180;
                            });
                            _refreshDemo();
                          },
                        ),
                        ActionChip(
                          label: const Text('480 x 270'),
                          onPressed: () {
                            setState(() {
                              _maxWidth = 480;
                              _maxHeight = 270;
                            });
                            _refreshDemo();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    FutureBuilder<_ThumbnailDemoResult>(
                      future: _demoFuture,
                      builder:
                          (
                            BuildContext context,
                            AsyncSnapshot<_ThumbnailDemoResult> snapshot,
                          ) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Padding(
                                padding: EdgeInsets.all(24),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            if (snapshot.hasError) {
                              return _ErrorPanel(error: snapshot.error);
                            }

                            final _ThumbnailDemoResult result = snapshot.data!;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Downloaded sample path: ${result.downloadedVideoPath}',
                                  style: theme.textTheme.bodySmall,
                                ),
                                const SizedBox(height: 16),
                                Wrap(
                                  spacing: 16,
                                  runSpacing: 16,
                                  children: result.previews.map((
                                    _ThumbnailPreview preview,
                                  ) {
                                    return _ThumbnailPreviewCard(
                                      preview: preview,
                                    );
                                  }).toList(),
                                ),
                              ],
                            );
                          },
                    ),
                  ],
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

class _ThumbnailPreviewCard extends StatelessWidget {
  const _ThumbnailPreviewCard({required this.preview});

  final _ThumbnailPreview preview;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return SizedBox(
      width: 260,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.memory(
                  preview.bytes,
                  height: 144,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                preview.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(preview.apiLabel),
              Text(preview.sourceLabel),
              Text(preview.dimensionsLabel),
              if (preview.detailLabel case final String detailLabel)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(detailLabel),
                ),
              if (preview.filePath case final String filePath)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    'Saved file: $filePath',
                    style: theme.textTheme.bodySmall,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      width: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon),
          const SizedBox(height: 12),
          Text(
            label,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(value, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _UnsupportedPanel extends StatelessWidget {
  const _UnsupportedPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.24)),
      ),
      child: const Text(
        'The live thumbnail demo is disabled on this platform. '
        '`fc_native_video_thumbnail` currently targets Android, iOS, macOS, '
        'and Windows, so the code samples remain visible while runtime preview '
        'generation is skipped on web and Linux.',
      ),
    );
  }
}

class _ErrorPanel extends StatelessWidget {
  const _ErrorPanel({required this.error});

  final Object? error;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.red.withValues(alpha: 0.18)),
      ),
      child: Text('Thumbnail generation failed.\n$error'),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.child,
    this.description,
  });

  final String title;
  final String? description;
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
                fontWeight: FontWeight.w800,
              ),
            ),
            if (description case final String description) ...<Widget>[
              const SizedBox(height: 8),
              Text(description, style: theme.textTheme.bodyMedium),
            ],
            const SizedBox(height: 18),
            child,
          ],
        ),
      ),
    );
  }
}

class _CodeSampleCard extends StatelessWidget {
  const _CodeSampleCard({required this.title, required this.code});

  final String title;
  final String code;

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
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.65,
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                code.trim(),
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontFamily: 'monospace',
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
