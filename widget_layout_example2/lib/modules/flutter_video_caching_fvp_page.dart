import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/video_runtime/flutter_video_caching_fvp_runtime.dart';

@RoutePage()
class FlutterVideoCachingFvpPage extends StatelessWidget {
  const FlutterVideoCachingFvpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('flutter_video_caching + fvp Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: const <Widget>[
            Text(
              'flutter_video_caching adds a local proxy and cache layer for remote media URLs, while fvp upgrades video_player with a high-performance backend across desktop and mobile platforms.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 12),
            Text(
              'This page demonstrates one-time runtime setup, resolving a playable YouTube stream URL, cached playback URLs, pre-caching, cache inspection, and fvp-specific controller extensions.',
            ),
            SizedBox(height: 20),
            _ExampleCard(
              title: 'Lazy Runtime Setup',
              description:
                  'Initialize fvp and the flutter_video_caching proxy right before the first video controller is created for this module. That keeps app launch isolated from optional video runtime failures.',
              child: _CodeBlock(
                code:
                    'Future<void> openVideoDemo() async {\n'
                    '  await configureFlutterVideoCachingAndFvp();\n'
                    '\n'
                    '  final controller = VideoPlayerController.networkUrl(\n'
                    '    mediaUrl.toLocalUri(),\n'
                    '  );\n'
                    '  await controller.initialize();\n'
                    '}',
              ),
            ),
            SizedBox(height: 16),
            _ExampleCard(
              title: 'Resolve a Playable YouTube Stream',
              description:
                  'A YouTube watch page URL is not a direct media stream, so resolve a playable stream URL first. The runtime demo uses youtube_explode_dart to fetch the stream manifest, then passes the resolved media URL into flutter_video_caching and video_player.',
              child: _CodeBlock(
                code:
                    'final yt = YoutubeExplode();\n'
                    'final manifest = await yt.videos.streams.getManifest(\n'
                    "  'M7lc1UVf-VE',\n"
                    '  ytClients: [\n'
                    '    YoutubeApiClient.ios,\n'
                    '    YoutubeApiClient.androidVr,\n'
                    '  ],\n'
                    ');\n'
                    'final streamInfo = manifest.muxed.isNotEmpty\n'
                    '    ? manifest.muxed.withHighestBitrate()\n'
                    '    : manifest.hls.withHighestBitrate();\n'
                    'final mediaUrl = streamInfo.url.toString();',
              ),
            ),
            SizedBox(height: 16),
            _ExampleCard(
              title: 'Playback Through the Cache Proxy',
              description:
                  'Use flutter_video_caching to rewrite the resolved YouTube media URL into a local proxy URL, then feed that URI into VideoPlayerController. With fvp registered, the controller uses the fvp backend on supported platforms.',
              child: _CodeBlock(
                code:
                    'final mediaUrl = resolvedYoutubeStreamUrl;\n'
                    'final controller = VideoPlayerController.networkUrl(\n'
                    '  mediaUrl.toLocalUri(),\n'
                    '  videoPlayerOptions: const VideoPlayerOptions(\n'
                    '    mixWithOthers: true,\n'
                    '  ),\n'
                    ');\n'
                    'await controller.initialize();\n'
                    'controller.setBufferRange(min: 1000, max: 4000);\n'
                    'await controller.play();',
              ),
            ),
            SizedBox(height: 16),
            _ExampleCard(
              title: 'Pre-cache and Cache Inspection',
              description:
                  'flutter_video_caching also supports pre-caching selected segments from the resolved YouTube stream URL ahead of playback and checking whether that URL already has cached data.',
              child: _CodeBlock(
                code:
                    'await VideoCaching.precache(\n'
                    '  mediaUrl,\n'
                    '  cacheSegments: 2,\n'
                    '  progressListen: true,\n'
                    ');\n'
                    '\n'
                    'final cached = await VideoCaching.isCached(\n'
                    '  mediaUrl,\n'
                    '  cacheSegments: 2,\n'
                    ');\n'
                    '\n'
                    'await LruCacheSingleton().removeCacheByUrl(mediaUrl);',
              ),
            ),
            SizedBox(height: 16),
            _ExampleCard(
              title: 'fvp Controller Extensions',
              description:
                  'Once fvp is the active backend, VideoPlayerController gains additional capabilities such as snapshot and fastSeekTo without replacing your video_player-based UI.',
              child: _CodeBlock(
                code:
                    'await controller.fastSeekTo(const Duration(seconds: 5));\n'
                    'final bytes = await controller.snapshot(width: 480);\n'
                    'final mediaInfo = controller.getMediaInfo();',
              ),
            ),
            SizedBox(height: 16),
            FlutterVideoCachingFvpRuntimePanel(),
            SizedBox(height: 16),
            _ExampleCard(
              title: 'Platform Notes',
              description:
                  'flutter_video_caching starts a localhost HTTP proxy, so Android and iOS need the local cleartext/ATS exceptions described in the package README. This module also relies on youtube_explode_dart to turn a YouTube video ID into a playable stream URL before that URL is proxied. fvp must remain a direct dependency for its video_player backend integration.',
              child: Text(
                'Use this module as a reference page for runtime initialization, YouTube stream resolution, proxy-based playback, pre-cache workflows, and fvp-enhanced controller features.',
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

class _ExampleCard extends StatelessWidget {
  const _ExampleCard({
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

class _CodeBlock extends StatelessWidget {
  const _CodeBlock({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.blueGrey.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(code, style: Theme.of(context).textTheme.bodyMedium),
    );
  }
}
