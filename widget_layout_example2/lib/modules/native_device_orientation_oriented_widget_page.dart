import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:native_device_orientation/native_device_orientation.dart';

import 'package:widget_layout_example2/modules/native_device_orientation_demo_support.dart';

@RoutePage(name: 'NativeDeviceOrientationOrientedWidgetRoute')
class NativeDeviceOrientationOrientedWidgetPage extends StatefulWidget {
  const NativeDeviceOrientationOrientedWidgetPage({super.key});

  @override
  State<NativeDeviceOrientationOrientedWidgetPage> createState() =>
      _NativeDeviceOrientationOrientedWidgetPageState();
}

class _NativeDeviceOrientationOrientedWidgetPageState
    extends State<NativeDeviceOrientationOrientedWidgetPage> {
  bool _useSensor = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('native_device_orientation OrientedWidget Module'),
      ),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            Text(
              'NativeDeviceOrientedWidget wraps the reader and dispatches to orientation-specific builders. It is useful when the whole widget tree should switch between dedicated portrait and landscape implementations.',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Text(
              'The examples below cover specific per-direction builders, coarser portrait/landscape builders, and mixed setups where only a few orientations need custom handling.',
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
                featureName: 'NativeDeviceOrientedWidget',
              )
            else ...<Widget>[
              NativeOrientationExampleCard(
                title: 'Fully specific builders',
                description:
                    'Define a separate builder for each direction when mirrored layouts matter.',
                api:
                    'Uses: portraitUp, portraitDown, landscapeLeft, landscapeRight, fallback',
                child: SizedBox(
                  height: 220,
                  child: NativeDeviceOrientedWidget(
                    useSensor: _useSensor,
                    portraitUp: (BuildContext context) =>
                        const _DirectionalSurface(
                          title: 'portraitUp builder',
                          note: 'Primary summary first, actions beneath it.',
                          color: Colors.indigo,
                          icon: Icons.stay_current_portrait,
                          axis: Axis.vertical,
                          reverse: false,
                        ),
                    portraitDown: (BuildContext context) =>
                        const _DirectionalSurface(
                          title: 'portraitDown builder',
                          note:
                              'Actions move ahead of content for upside-down handling.',
                          color: Colors.deepPurple,
                          icon: Icons.screen_rotation_alt,
                          axis: Axis.vertical,
                          reverse: true,
                        ),
                    landscapeLeft: (BuildContext context) =>
                        const _DirectionalSurface(
                          title: 'landscapeLeft builder',
                          note: 'Controls dock to the left side.',
                          color: Colors.teal,
                          icon: Icons.stay_current_landscape,
                          axis: Axis.horizontal,
                          reverse: false,
                        ),
                    landscapeRight: (BuildContext context) =>
                        const _DirectionalSurface(
                          title: 'landscapeRight builder',
                          note: 'Controls dock to the right side.',
                          color: Colors.orange,
                          icon: Icons.stay_current_landscape,
                          axis: Axis.horizontal,
                          reverse: true,
                        ),
                    fallback: (BuildContext context) =>
                        const _FallbackSurface(label: 'fallback builder'),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              NativeOrientationExampleCard(
                title: 'Coarse portrait versus landscape split',
                description:
                    'If left and right do not matter, the shared `portrait` and `landscape` builders keep the code compact.',
                api: 'Uses: portrait + landscape + fallback',
                child: SizedBox(
                  height: 220,
                  child: NativeDeviceOrientedWidget(
                    useSensor: _useSensor,
                    portrait: (BuildContext context) => const _DashboardSurface(
                      title: 'Portrait dashboard',
                      columnCount: 1,
                      color: Colors.blue,
                    ),
                    landscape: (BuildContext context) =>
                        const _DashboardSurface(
                          title: 'Landscape dashboard',
                          columnCount: 2,
                          color: Colors.green,
                        ),
                    fallback: (BuildContext context) => const _FallbackSurface(
                      label: 'portrait / landscape fallback',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              NativeOrientationExampleCard(
                title: 'Mix specific builders with shared defaults',
                description:
                    'You can override just the orientations that need custom layout while letting the others share a broader builder.',
                api:
                    'Uses: portrait + landscapeLeft + landscapeRight + fallback',
                child: SizedBox(
                  height: 220,
                  child: NativeDeviceOrientedWidget(
                    useSensor: _useSensor,
                    portrait: (BuildContext context) =>
                        const _PortraitPlaylist(),
                    landscapeLeft: (BuildContext context) =>
                        const _LandscapePlaylist(leftDocked: true),
                    landscapeRight: (BuildContext context) =>
                        const _LandscapePlaylist(leftDocked: false),
                    fallback: (BuildContext context) =>
                        const _FallbackSurface(label: 'mixed-builder fallback'),
                  ),
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

class _DirectionalSurface extends StatelessWidget {
  const _DirectionalSurface({
    required this.title,
    required this.note,
    required this.color,
    required this.icon,
    required this.axis,
    required this.reverse,
  });

  final String title;
  final String note;
  final Color color;
  final IconData icon;
  final Axis axis;
  final bool reverse;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[
      Expanded(
        flex: 2,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Center(child: Icon(icon, size: 52, color: color)),
        ),
      ),
      SizedBox(
        width: axis == Axis.horizontal ? 12 : 0,
        height: axis == Axis.vertical ? 12 : 0,
      ),
      Expanded(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: color.withValues(alpha: 0.20)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                Text(note),
              ],
            ),
          ),
        ),
      ),
    ];

    final List<Widget> arranged = reverse
        ? children.reversed.toList()
        : children;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Flex(direction: axis, children: arranged),
      ),
    );
  }
}

class _DashboardSurface extends StatelessWidget {
  const _DashboardSurface({
    required this.title,
    required this.columnCount,
    required this.color,
  });

  final String title;
  final int columnCount;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: columnCount,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 2.2,
                children: List<Widget>.generate(4, (int index) {
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: color.withValues(alpha: 0.18)),
                    ),
                    child: Center(
                      child: Text(
                        'Card ${index + 1}',
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PortraitPlaylist extends StatelessWidget {
  const _PortraitPlaylist();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.pink.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'portrait builder',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            SizedBox(height: 12),
            Expanded(child: _PlaylistPreview(axis: Axis.vertical)),
          ],
        ),
      ),
    );
  }
}

class _LandscapePlaylist extends StatelessWidget {
  const _LandscapePlaylist({required this.leftDocked});

  final bool leftDocked;

  @override
  Widget build(BuildContext context) {
    final Widget queue = DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Queue', style: TextStyle(fontWeight: FontWeight.w800)),
            SizedBox(height: 8),
            Text('Song A'),
            Text('Song B'),
            Text('Song C'),
          ],
        ),
      ),
    );

    const Widget player = DecoratedBox(
      decoration: BoxDecoration(
        color: Color(0xFF132238),
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Center(
        child: Text(
          'landscape builder',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
        ),
      ),
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.cyan.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: leftDocked
              ? <Widget>[
                  Expanded(child: queue),
                  const SizedBox(width: 12),
                  const Expanded(flex: 2, child: player),
                ]
              : <Widget>[
                  const Expanded(flex: 2, child: player),
                  const SizedBox(width: 12),
                  Expanded(child: queue),
                ],
        ),
      ),
    );
  }
}

class _PlaylistPreview extends StatelessWidget {
  const _PlaylistPreview({required this.axis});

  final Axis axis;

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: axis,
      children: <Widget>[
        const Expanded(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Color(0xFF132238),
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            child: Center(
              child: Text(
                'Now playing',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: axis == Axis.horizontal ? 12 : 0,
          height: axis == Axis.vertical ? 12 : 0,
        ),
        Expanded(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Queue', style: TextStyle(fontWeight: FontWeight.w800)),
                  SizedBox(height: 8),
                  Text('Song A'),
                  Text('Song B'),
                  Text('Song C'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FallbackSurface extends StatelessWidget {
  const _FallbackSurface({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.blueGrey.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Center(
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
      ),
    );
  }
}
