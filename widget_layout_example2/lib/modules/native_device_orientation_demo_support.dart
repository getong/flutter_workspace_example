import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:native_device_orientation/native_device_orientation.dart';

bool get supportsNativeDeviceOrientation =>
    !kIsWeb &&
    (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS);

bool nativeOrientationIsLandscape(NativeDeviceOrientation orientation) {
  switch (orientation) {
    case NativeDeviceOrientation.landscapeLeft:
    case NativeDeviceOrientation.landscapeRight:
      return true;
    case NativeDeviceOrientation.portraitUp:
    case NativeDeviceOrientation.portraitDown:
    case NativeDeviceOrientation.unknown:
      return false;
  }
}

String nativeOrientationLabel(NativeDeviceOrientation orientation) {
  switch (orientation) {
    case NativeDeviceOrientation.portraitUp:
      return 'Portrait Up';
    case NativeDeviceOrientation.portraitDown:
      return 'Portrait Down';
    case NativeDeviceOrientation.landscapeLeft:
      return 'Landscape Left';
    case NativeDeviceOrientation.landscapeRight:
      return 'Landscape Right';
    case NativeDeviceOrientation.unknown:
      return 'Unknown';
  }
}

String nativeOrientationSignalLabel(bool useSensor) {
  return useSensor ? 'sensor-based updates' : 'window/page updates';
}

IconData nativeOrientationIcon(NativeDeviceOrientation orientation) {
  switch (orientation) {
    case NativeDeviceOrientation.portraitUp:
    case NativeDeviceOrientation.portraitDown:
      return Icons.stay_current_portrait;
    case NativeDeviceOrientation.landscapeLeft:
    case NativeDeviceOrientation.landscapeRight:
      return Icons.stay_current_landscape;
    case NativeDeviceOrientation.unknown:
      return Icons.help_outline;
  }
}

Color nativeOrientationColor(NativeDeviceOrientation orientation) {
  switch (orientation) {
    case NativeDeviceOrientation.portraitUp:
      return Colors.indigo;
    case NativeDeviceOrientation.portraitDown:
      return Colors.deepPurple;
    case NativeDeviceOrientation.landscapeLeft:
      return Colors.teal;
    case NativeDeviceOrientation.landscapeRight:
      return Colors.orange;
    case NativeDeviceOrientation.unknown:
      return Colors.blueGrey;
  }
}

class NativeOrientationExampleCard extends StatelessWidget {
  const NativeOrientationExampleCard({
    super.key,
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

class NativeOrientationBadge extends StatelessWidget {
  const NativeOrientationBadge({
    super.key,
    required this.orientation,
    this.compact = false,
  });

  final NativeDeviceOrientation orientation;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final Color color = nativeOrientationColor(orientation);

    return Chip(
      avatar: Icon(nativeOrientationIcon(orientation), color: color, size: 18),
      label: Text(
        compact
            ? nativeOrientationLabel(orientation)
            : 'Current: ${nativeOrientationLabel(orientation)}',
      ),
      backgroundColor: color.withValues(alpha: 0.10),
      side: BorderSide(color: color.withValues(alpha: 0.22)),
      visualDensity: compact ? VisualDensity.compact : null,
    );
  }
}

class NativeOrientationSupportNotice extends StatelessWidget {
  const NativeOrientationSupportNotice({super.key, required this.featureName});

  final String featureName;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.amber.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(Icons.info_outline, color: Colors.amber.shade800),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '$featureName is only meaningful on Android and iOS. '
                'This page still opens on desktop and web, but the live plugin '
                'widgets are not mounted there to avoid missing-platform '
                'errors.',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
