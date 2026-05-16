import 'package:flutter/material.dart';

Future<void> configureFlutterVideoCachingAndFvp() async {}

class FlutterVideoCachingFvpRuntimePanel extends StatelessWidget {
  const FlutterVideoCachingFvpRuntimePanel({super.key});

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
              'Runtime Demo Unavailable',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            const Text(
              'This live playback demo uses flutter_video_caching and fvp on IO platforms. On unsupported targets such as web, the page stays available and documents the setup, but the runtime player is disabled.',
            ),
          ],
        ),
      ),
    );
  }
}
