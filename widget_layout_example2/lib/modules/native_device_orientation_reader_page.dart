import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:native_device_orientation/native_device_orientation.dart';

import 'package:widget_layout_example2/modules/native_device_orientation_demo_support.dart';
import 'package:widget_layout_example2/app_navigation.dart';

@RoutePage(name: RouteName.nativeDeviceOrientationReader)
class NativeDeviceOrientationReaderPage extends StatefulWidget {
  const NativeDeviceOrientationReaderPage({super.key});

  @override
  State<NativeDeviceOrientationReaderPage> createState() =>
      _NativeDeviceOrientationReaderPageState();
}

class _NativeDeviceOrientationReaderPageState
    extends State<NativeDeviceOrientationReaderPage> {
  bool _useSensor = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('native_device_orientation Reader Module'),
      ),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            Text(
              'NativeDeviceOrientationReader wraps a subtree, listens for native orientation updates, and lets any descendant read the latest value with `NativeDeviceOrientationReader.orientation(context)`.',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Text(
              'This page demonstrates reading the value from multiple descendants and using the result to reorganize UI beyond Flutter’s coarse portrait versus landscape split.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            Card(
              clipBehavior: Clip.antiAlias,
              child: SwitchListTile.adaptive(
                value: _useSensor,
                onChanged: supportsNativeDeviceOrientation
                    ? (bool value) => setState(() => _useSensor = value)
                    : null,
                title: const Text('Use device sensors'),
                subtitle: Text(
                  'Current mode: ${nativeOrientationSignalLabel(_useSensor)}.',
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (!supportsNativeDeviceOrientation)
              const NativeOrientationSupportNotice(
                featureName: 'NativeDeviceOrientationReader',
              )
            else ...<Widget>[
              NativeOrientationExampleCard(
                title: 'Read orientation from the inherited context',
                description:
                    'A descendant widget can read the native value directly and present a richer status model than `MediaQuery.orientation`.',
                api:
                    'Uses: NativeDeviceOrientationReader(useSensor: $_useSensor) + NativeDeviceOrientationReader.orientation(context)',
                child: NativeDeviceOrientationReader(
                  useSensor: _useSensor,
                  builder: (BuildContext context) => const _ReaderStatusPanel(),
                ),
              ),
              const SizedBox(height: 16),
              NativeOrientationExampleCard(
                title: 'Reflow a workspace preview',
                description:
                    'This preview uses the live native direction to move tools left, right, or below the content area.',
                api:
                    'Uses: NativeDeviceOrientationReader.orientation(context) inside a nested preview widget',
                child: NativeDeviceOrientationReader(
                  useSensor: _useSensor,
                  builder: (BuildContext context) =>
                      const _ReaderWorkspacePreview(),
                ),
              ),
              const SizedBox(height: 16),
              NativeOrientationExampleCard(
                title: 'Drive direction-aware guidance',
                description:
                    'Landscape left and landscape right often need mirrored affordances, especially for camera or media overlays.',
                api:
                    'Uses: conditional UI branches for portraitUp, portraitDown, landscapeLeft, and landscapeRight',
                child: NativeDeviceOrientationReader(
                  useSensor: _useSensor,
                  builder: (BuildContext context) =>
                      const _ReaderActionRailPreview(),
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

class _ReaderStatusPanel extends StatelessWidget {
  const _ReaderStatusPanel();

  @override
  Widget build(BuildContext context) {
    final NativeDeviceOrientation orientation =
        NativeDeviceOrientationReader.orientation(context);
    final bool isLandscape = nativeOrientationIsLandscape(orientation);
    final Color accent = nativeOrientationColor(orientation);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: accent.withValues(alpha: 0.24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          NativeOrientationBadge(orientation: orientation),
          const SizedBox(height: 12),
          Text(
            isLandscape
                ? 'The device is rotated sideways, so this panel exposes a wide information layout.'
                : 'The device is upright or upside down, so this panel keeps a stacked summary layout.',
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: <Widget>[
              _MetricPill(
                label: 'Axis',
                value: isLandscape ? 'Landscape' : 'Portrait',
                accent: accent,
              ),
              _MetricPill(
                label: 'DeviceOrientation',
                value: '${orientation.deviceOrientation}',
                accent: accent,
              ),
              _MetricPill(
                label: 'Preview mode',
                value: nativeOrientationLabel(orientation),
                accent: accent,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReaderWorkspacePreview extends StatelessWidget {
  const _ReaderWorkspacePreview();

  @override
  Widget build(BuildContext context) {
    final NativeDeviceOrientation orientation =
        NativeDeviceOrientationReader.orientation(context);
    final Color accent = nativeOrientationColor(orientation);

    Widget buildToolbar(Axis axis) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: accent.withValues(alpha: 0.16),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Flex(
            direction: axis,
            children: List<Widget>.generate(3, (int index) {
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: axis == Axis.horizontal && index < 2 ? 10 : 0,
                    bottom: axis == Axis.vertical && index < 2 ? 10 : 0,
                  ),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Icon(
                        <IconData>[
                          Icons.crop_rotate,
                          Icons.grid_view_rounded,
                          Icons.tune_rounded,
                        ][index],
                        color: accent,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      );
    }

    final Widget canvas = Expanded(
      flex: 3,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[accent.withValues(alpha: 0.18), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            nativeOrientationLabel(orientation),
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
        ),
      ),
    );

    return SizedBox(
      height: 220,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 220),
        child: KeyedSubtree(
          key: ValueKey<String>(orientation.name),
          child: switch (orientation) {
            NativeDeviceOrientation.landscapeLeft => Row(
              children: <Widget>[
                Expanded(child: buildToolbar(Axis.vertical)),
                const SizedBox(width: 12),
                canvas,
              ],
            ),
            NativeDeviceOrientation.landscapeRight => Row(
              children: <Widget>[
                canvas,
                const SizedBox(width: 12),
                Expanded(child: buildToolbar(Axis.vertical)),
              ],
            ),
            NativeDeviceOrientation.portraitUp ||
            NativeDeviceOrientation.portraitDown ||
            NativeDeviceOrientation.unknown => Column(
              children: <Widget>[
                canvas,
                const SizedBox(height: 12),
                SizedBox(height: 72, child: buildToolbar(Axis.horizontal)),
              ],
            ),
          },
        ),
      ),
    );
  }
}

class _ReaderActionRailPreview extends StatelessWidget {
  const _ReaderActionRailPreview();

  @override
  Widget build(BuildContext context) {
    final NativeDeviceOrientation orientation =
        NativeDeviceOrientationReader.orientation(context);
    final Color accent = nativeOrientationColor(orientation);

    Widget buildPreviewBox() {
      return Expanded(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blueGrey.shade900,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Stack(
            children: <Widget>[
              const Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[Color(0xFF162032), Color(0xFF273B59)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: switch (orientation) {
                  NativeDeviceOrientation.landscapeLeft => Alignment.centerLeft,
                  NativeDeviceOrientation.landscapeRight =>
                    Alignment.centerRight,
                  NativeDeviceOrientation.portraitDown =>
                    Alignment.bottomCenter,
                  NativeDeviceOrientation.portraitUp ||
                  NativeDeviceOrientation.unknown => Alignment.topCenter,
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      child: Text(
                        'Capture',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final Widget tips = Expanded(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: accent.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              NativeOrientationBadge(orientation: orientation, compact: true),
              const SizedBox(height: 12),
              Text(switch (orientation) {
                NativeDeviceOrientation.landscapeLeft =>
                  'Move controls to the left edge to stay near the user’s thumb.',
                NativeDeviceOrientation.landscapeRight =>
                  'Mirror controls onto the right edge for a handed layout.',
                NativeDeviceOrientation.portraitDown =>
                  'Pin the primary action lower to match the upside-down grip.',
                NativeDeviceOrientation.portraitUp ||
                NativeDeviceOrientation.unknown =>
                  'Keep controls near the top when the handset is upright.',
              }),
            ],
          ),
        ),
      ),
    );

    return SizedBox(
      height: 220,
      child: switch (orientation) {
        NativeDeviceOrientation.landscapeLeft => Row(
          children: <Widget>[
            tips,
            const SizedBox(width: 12),
            buildPreviewBox(),
          ],
        ),
        NativeDeviceOrientation.landscapeRight => Row(
          children: <Widget>[
            buildPreviewBox(),
            const SizedBox(width: 12),
            tips,
          ],
        ),
        NativeDeviceOrientation.portraitUp ||
        NativeDeviceOrientation.portraitDown ||
        NativeDeviceOrientation.unknown => Column(
          children: <Widget>[
            buildPreviewBox(),
            const SizedBox(height: 12),
            tips,
          ],
        ),
      },
    );
  }
}

class _MetricPill extends StatelessWidget {
  const _MetricPill({
    required this.label,
    required this.value,
    required this.accent,
  });

  final String label;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: accent.withValues(alpha: 0.20)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(label, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}
