import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_video_caching/flutter_video_caching.dart';
import 'package:fvp/fvp.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

Future<void>? _configureFlutterVideoCachingAndFvpFuture;

Future<void> configureFlutterVideoCachingAndFvp() async {
  final Future<void>? existingFuture =
      _configureFlutterVideoCachingAndFvpFuture;
  if (existingFuture != null) {
    return existingFuture;
  }

  final Completer<void> completer = Completer<void>();
  _configureFlutterVideoCachingAndFvpFuture = completer.future;

  unawaited(() async {
    try {
      registerWith();
      if (!await VideoProxy.isRunning()) {
        await VideoProxy.init(logPrint: false);
      }
      completer.complete();
    } catch (error, stackTrace) {
      _configureFlutterVideoCachingAndFvpFuture = null;
      completer.completeError(error, stackTrace);
    }
  }());

  return completer.future;
}

class FlutterVideoCachingFvpRuntimePanel extends StatefulWidget {
  const FlutterVideoCachingFvpRuntimePanel({super.key});

  @override
  State<FlutterVideoCachingFvpRuntimePanel> createState() =>
      _FlutterVideoCachingFvpRuntimePanelState();
}

class _FlutterVideoCachingFvpRuntimePanelState
    extends State<FlutterVideoCachingFvpRuntimePanel> {
  static const List<({String label, String videoId, int cacheSegments})>
  _samples = <({String label, String videoId, int cacheSegments})>[
    (label: 'YouTube API Demo', videoId: 'M7lc1UVf-VE', cacheSegments: 2),
    (label: 'YouTube Package Sample', videoId: 'fRh_vgS2dFE', cacheSegments: 2),
  ];

  final YoutubeExplode _youtube = YoutubeExplode();
  VideoPlayerController? _controller;
  StreamSubscription<Map>? _precacheSubscription;

  int _sampleIndex = 0;
  bool _loadingPlayer = true;
  bool _isCached = false;
  bool _proxyRunning = false;
  bool _retryingWithoutProxy = false;
  bool _usingProxyPlayback = true;
  double _precacheProgress = 0;
  String _status = 'Preparing player...';
  String _lastProgressEvent = 'No pre-cache event yet.';
  String _mediaInfoSummary =
      'Media info unavailable until initialization completes.';
  String _resolvedStreamSummary =
      'The YouTube stream URL will appear after resolution succeeds.';
  String? _resolvedMediaUrl;
  Uint8List? _snapshotBytes;

  ({String label, String videoId, int cacheSegments}) get _sample =>
      _samples[_sampleIndex];

  String get _youtubeWatchUrl =>
      'https://www.youtube.com/watch?v=${_sample.videoId}';

  @override
  void initState() {
    super.initState();
    _initializeCurrentSample();
  }

  @override
  void dispose() {
    _precacheSubscription?.cancel();
    _controller?.dispose();
    _youtube.close();
    super.dispose();
  }

  Future<void> _initializeCurrentSample() async {
    setState(() {
      _loadingPlayer = true;
      _usingProxyPlayback = true;
      _status =
          'Configuring fvp and the flutter_video_caching proxy for ${_sample.label}...';
      _snapshotBytes = null;
      _resolvedMediaUrl = null;
      _mediaInfoSummary =
          'Media info unavailable until initialization completes.';
      _resolvedStreamSummary =
          'The YouTube stream URL will appear after resolution succeeds.';
    });

    await _precacheSubscription?.cancel();
    final VideoPlayerController? previousController = _controller;

    try {
      await configureFlutterVideoCachingAndFvp();

      if (!mounted) {
        return;
      }

      setState(() {
        _status = 'Resolving a playable YouTube stream for ${_sample.label}...';
      });

      final ({String resolvedMediaUrl, String resolvedStreamSummary})
      resolvedVideo = await _resolveYouTubeStream();

      final ({
        VideoPlayerController controller,
        bool usingProxy,
        String statusMessage,
      })
      playerSetup = await _initializeControllerWithFallback(
        resolvedVideo.resolvedMediaUrl,
      );

      final VideoPlayerController nextController = playerSetup.controller;
      final String mediaSummary = _buildMediaSummary(nextController);

      if (!mounted) {
        await nextController.dispose();
        return;
      }

      setState(() {
        _controller = nextController;
        _loadingPlayer = false;
        _usingProxyPlayback = playerSetup.usingProxy;
        _status = playerSetup.statusMessage;
        _mediaInfoSummary = mediaSummary;
        _resolvedMediaUrl = resolvedVideo.resolvedMediaUrl;
        _resolvedStreamSummary = resolvedVideo.resolvedStreamSummary;
      });

      await previousController?.dispose();
      await _refreshProxyState();
      await _refreshCacheState();
    } catch (error) {
      await previousController?.dispose();

      if (!mounted) {
        return;
      }

      setState(() {
        _controller = null;
        _loadingPlayer = false;
        _status = 'Failed to initialize the video runtime: $error';
        _mediaInfoSummary =
            'Playback setup failed before media info became available.';
        _resolvedStreamSummary =
            'Runtime setup did not complete, so the YouTube stream was not resolved.';
      });
    }
  }

  Future<
    ({VideoPlayerController controller, bool usingProxy, String statusMessage})
  >
  _initializeControllerWithFallback(String mediaUrl) async {
    try {
      final VideoPlayerController proxyController =
          await _createAndStartController(mediaUrl.toLocalUri());
      return (
        controller: proxyController,
        usingProxy: true,
        statusMessage:
            'Playing the resolved YouTube stream through the flutter_video_caching local proxy with the fvp backend.',
      );
    } catch (error) {
      if (!_shouldFallbackFromError(error)) {
        rethrow;
      }

      final VideoPlayerController directController =
          await _createAndStartController(Uri.parse(mediaUrl));
      return (
        controller: directController,
        usingProxy: false,
        statusMessage:
            'Proxy playback failed on this platform, so playback fell back to the resolved YouTube media URL with the fvp backend.',
      );
    }
  }

  Future<({String resolvedMediaUrl, String resolvedStreamSummary})>
  _resolveYouTubeStream() async {
    final Video video = await _youtube.videos.get(_sample.videoId);
    final StreamManifest manifest = await _youtube.videos.streams.getManifest(
      _sample.videoId,
      ytClients: <YoutubeApiClient>[
        YoutubeApiClient.ios,
        YoutubeApiClient.androidVr,
      ],
    );

    final StreamInfo? streamInfo = manifest.muxed.isNotEmpty
        ? manifest.muxed.withHighestBitrate()
        : manifest.hls.isNotEmpty
        ? manifest.hls.withHighestBitrate()
        : null;

    if (streamInfo == null) {
      throw StateError(
        'YouTube did not provide a playable muxed or HLS stream for ${_sample.videoId}.',
      );
    }

    return (
      resolvedMediaUrl: streamInfo.url.toString(),
      resolvedStreamSummary:
          'Resolved "${video.title}" from YouTube to a ${streamInfo.qualityLabel} ${streamInfo.container.name.toUpperCase()} stream.',
    );
  }

  Future<VideoPlayerController> _createAndStartController(Uri uri) async {
    final VideoPlayerController controller = VideoPlayerController.networkUrl(
      uri,
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );
    controller.setLooping(true);
    controller.addListener(_handleControllerChanged);

    try {
      await controller.initialize();
      controller.setBufferRange(min: 1000, max: 4000, drop: false);
      await controller.play();
      return controller;
    } catch (error) {
      controller.removeListener(_handleControllerChanged);
      await controller.dispose();
      rethrow;
    }
  }

  String _buildMediaSummary(VideoPlayerController controller) {
    final Object? mediaInfo = controller.getMediaInfo();
    if (mediaInfo == null) {
      return 'fvp is active, but extended media info is not available yet.';
    }
    return 'fvp media info loaded. Duration: ${controller.value.duration.inSeconds}s';
  }

  bool _shouldFallbackFromError(Object error) {
    final String message = error.toString().toLowerCase();
    return message.contains('source error') ||
        message.contains('media open error') ||
        message.contains('invalid or unsupported media');
  }

  void _handleControllerChanged() {
    if (!mounted) {
      return;
    }
    final VideoPlayerController? controller = _controller;
    final String? errorDescription = controller?.value.errorDescription;
    if (controller != null &&
        controller.value.hasError &&
        _usingProxyPlayback &&
        !_retryingWithoutProxy &&
        _shouldFallbackFromError(errorDescription ?? '')) {
      unawaited(_fallbackToOriginalUrl(controller, errorDescription ?? ''));
    }
    setState(() {});
  }

  Future<void> _fallbackToOriginalUrl(
    VideoPlayerController failedController,
    String errorDescription,
  ) async {
    if (_retryingWithoutProxy || _controller != failedController) {
      return;
    }

    _retryingWithoutProxy = true;
    if (mounted) {
      setState(() {
        _loadingPlayer = true;
        _status =
            'Proxy playback hit "$errorDescription". Retrying with the original remote URL...';
      });
    }

    try {
      final VideoPlayerController directController =
          await _createAndStartController(Uri.parse(_resolvedMediaUrl!));
      final String mediaSummary = _buildMediaSummary(directController);

      if (!mounted || _controller != failedController) {
        await directController.dispose();
        return;
      }

      failedController.removeListener(_handleControllerChanged);
      await failedController.dispose();

      if (!mounted) {
        await directController.dispose();
        return;
      }

      setState(() {
        _controller = directController;
        _loadingPlayer = false;
        _usingProxyPlayback = false;
        _status =
            'Proxy playback failed after initialization, so playback switched to the resolved YouTube media URL with the fvp backend.';
        _mediaInfoSummary = mediaSummary;
      });
    } catch (error) {
      if (!mounted || _controller != failedController) {
        return;
      }
      setState(() {
        _loadingPlayer = false;
        _status = 'Failed to recover from proxy playback error: $error';
      });
    } finally {
      _retryingWithoutProxy = false;
      await _refreshProxyState();
      await _refreshCacheState();
    }
  }

  Future<void> _refreshProxyState() async {
    final bool running = await VideoProxy.isRunning();
    if (!mounted) {
      return;
    }
    setState(() {
      _proxyRunning = running;
    });
  }

  Future<void> _refreshCacheState() async {
    final String? resolvedMediaUrl = _resolvedMediaUrl;
    if (resolvedMediaUrl == null) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isCached = false;
      });
      return;
    }

    final bool cached = await VideoCaching.isCached(
      resolvedMediaUrl,
      cacheSegments: _sample.cacheSegments,
    );
    if (!mounted) {
      return;
    }
    setState(() {
      _isCached = cached;
    });
  }

  Future<void> _startPrecache() async {
    final String? resolvedMediaUrl = _resolvedMediaUrl;
    if (resolvedMediaUrl == null) {
      setState(() {
        _lastProgressEvent =
            'Resolve the YouTube stream successfully before starting pre-cache.';
      });
      return;
    }

    await _precacheSubscription?.cancel();

    setState(() {
      _precacheProgress = 0;
      _lastProgressEvent = 'Starting pre-cache for ${_sample.label}...';
    });

    final StreamController<Map>? progressController =
        await VideoCaching.precache(
          resolvedMediaUrl,
          cacheSegments: _sample.cacheSegments,
          progressListen: true,
        );

    if (progressController == null) {
      return;
    }

    _precacheSubscription = progressController.stream.listen((Map event) async {
      final double progress = (event['progress'] as num?)?.toDouble() ?? 0;
      if (!mounted) {
        return;
      }
      setState(() {
        _precacheProgress = progress;
        _lastProgressEvent = event.toString();
      });
      if (progress >= 1) {
        await _refreshCacheState();
      }
    });
  }

  Future<void> _clearCurrentCache() async {
    final String? resolvedMediaUrl = _resolvedMediaUrl;
    if (resolvedMediaUrl == null) {
      if (!mounted) {
        return;
      }
      setState(() {
        _status = 'No resolved YouTube media URL is available to clear yet.';
      });
      return;
    }

    try {
      await LruCacheSingleton().removeCacheByUrl(resolvedMediaUrl);
    } on PathNotFoundException {
      if (!mounted) {
        return;
      }
      setState(() {
        _status = 'Cache directory was already missing for ${_sample.label}.';
      });
    } on FileSystemException catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _status = 'Cache removal reported a filesystem issue: ${error.message}';
      });
    }
    if (!mounted) {
      return;
    }
    setState(() {
      _precacheProgress = 0;
      _lastProgressEvent = 'Removed cache for ${_sample.label}.';
      _snapshotBytes = null;
    });
    await _refreshCacheState();
  }

  Future<void> _captureSnapshot() async {
    final VideoPlayerController? controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    final Uint8List? bytes = await controller.snapshot(width: 480);
    if (!mounted) {
      return;
    }
    setState(() {
      _snapshotBytes = bytes;
      _status = bytes == null
          ? 'Snapshot was not available for the current frame.'
          : 'Captured a frame using the fvp snapshot extension.';
    });
  }

  Future<void> _fastSeekDemo() async {
    final VideoPlayerController? controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    await controller.fastSeekTo(const Duration(seconds: 5));
    if (!mounted) {
      return;
    }
    setState(() {
      _status = 'Jumped to 00:05 with fvp.fastSeekTo().';
    });
  }

  @override
  Widget build(BuildContext context) {
    final VideoPlayerController? controller = _controller;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Native Runtime Demo',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            const Text(
              'This panel resolves a playable stream from a YouTube video ID, then uses flutter_video_caching to proxy that media URL through a local cache server while fvp replaces the default video_player backend for playback.',
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: <Widget>[
                for (int index = 0; index < _samples.length; index += 1)
                  ChoiceChip(
                    label: Text(_samples[index].label),
                    selected: _sampleIndex == index,
                    onSelected: (_) {
                      setState(() {
                        _sampleIndex = index;
                      });
                      _initializeCurrentSample();
                    },
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(18),
              ),
              child: AspectRatio(
                aspectRatio: controller?.value.isInitialized == true
                    ? controller!.value.aspectRatio
                    : 16 / 9,
                child: _loadingPlayer
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : controller?.value.isInitialized == true
                    ? Stack(
                        alignment: Alignment.bottomCenter,
                        children: <Widget>[
                          VideoPlayer(controller!),
                          VideoProgressIndicator(
                            controller,
                            allowScrubbing: true,
                            colors: VideoProgressColors(
                              playedColor: Colors.teal.shade300,
                              bufferedColor: Colors.white54,
                              backgroundColor: Colors.white24,
                            ),
                          ),
                        ],
                      )
                    : Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(
                            _status,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: <Widget>[
                FilledButton.icon(
                  onPressed: controller == null
                      ? null
                      : () {
                          if (controller.value.isPlaying) {
                            controller.pause();
                            setState(() {
                              _status = 'Paused playback.';
                            });
                          } else {
                            controller.play();
                            setState(() {
                              _status = 'Resumed playback.';
                            });
                          }
                        },
                  icon: Icon(
                    controller?.value.isPlaying == true
                        ? Icons.pause
                        : Icons.play_arrow,
                  ),
                  label: Text(
                    controller?.value.isPlaying == true ? 'Pause' : 'Play',
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: controller == null ? null : _fastSeekDemo,
                  icon: const Icon(Icons.forward_5),
                  label: const Text('fastSeekTo 5s'),
                ),
                OutlinedButton.icon(
                  onPressed: controller == null ? null : _captureSnapshot,
                  icon: const Icon(Icons.photo_camera),
                  label: const Text('Snapshot'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.blueGrey.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Proxy running: ${_proxyRunning ? 'Yes' : 'No'}'),
                  Text('Cached: ${_isCached ? 'Yes' : 'No'}'),
                  Text(
                    'Playback source: ${_usingProxyPlayback ? 'Local proxy URL' : 'Original remote URL fallback'}',
                  ),
                  Text('YouTube watch URL: $_youtubeWatchUrl'),
                  Text(_resolvedStreamSummary),
                  Text(
                    'Local playback URL: ${_resolvedMediaUrl == null ? 'Unavailable until the stream is resolved.' : _resolvedMediaUrl!.toLocalUrl()}',
                  ),
                  const SizedBox(height: 8),
                  Text(_mediaInfoSummary),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: <Widget>[
                FilledButton.icon(
                  onPressed: _startPrecache,
                  icon: const Icon(Icons.download_for_offline),
                  label: Text(
                    'Pre-cache ${_sample.cacheSegments} segment${_sample.cacheSegments == 1 ? '' : 's'}',
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: _refreshCacheState,
                  icon: const Icon(Icons.inventory_2_outlined),
                  label: const Text('Check Cache'),
                ),
                OutlinedButton.icon(
                  onPressed: _clearCurrentCache,
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Remove Cache'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: _precacheProgress == 0 ? null : _precacheProgress,
            ),
            const SizedBox(height: 8),
            Text(
              'Latest pre-cache event: $_lastProgressEvent',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            if (_snapshotBytes != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'fvp Snapshot Preview',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.memory(
                      _snapshotBytes!,
                      height: 180,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
