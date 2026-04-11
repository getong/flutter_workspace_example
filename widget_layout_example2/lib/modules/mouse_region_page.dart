import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage(name: 'MouseRegionRoute')
class MouseRegionPage extends StatelessWidget {
  const MouseRegionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MouseRegion Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'MouseRegion listens for pointer entry, exit, and hover on desktop and web. It is useful for hover effects, pointer tracking, and custom cursors.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            const _MouseExampleCard(
              title: 'Hover-Reactive Card',
              description:
                  'A simple hover region can update elevation, border color, and cursor to make desktop UI feel responsive.',
              api: 'Uses: onEnter, onExit, cursor',
              child: _HoverCardPreview(),
            ),
            const SizedBox(height: 16),
            const _MouseExampleCard(
              title: 'Pointer Coordinate Tracker',
              description:
                  'onHover gives you the local pointer position for dashboards, canvases, and custom editors.',
              api: 'Uses: onHover + localPosition',
              child: _PointerTrackerPreview(),
            ),
            const SizedBox(height: 16),
            const _MouseExampleCard(
              title: 'Per-Zone Cursors',
              description:
                  'Different areas of one widget tree can expose different cursors and hover labels.',
              api: 'Uses: nested MouseRegion widgets',
              child: _CursorZonePreview(),
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

class _HoverCardPreview extends StatefulWidget {
  const _HoverCardPreview();

  @override
  State<_HoverCardPreview> createState() => _HoverCardPreviewState();
}

class _HoverCardPreviewState extends State<_HoverCardPreview> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: _hovered ? Colors.cyan.shade50 : Colors.blueGrey.shade50,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: _hovered ? Colors.cyan : Colors.blueGrey.shade200,
            width: _hovered ? 2 : 1,
          ),
          boxShadow: _hovered
              ? const <BoxShadow>[
                  BoxShadow(blurRadius: 16, color: Colors.black12),
                ]
              : const <BoxShadow>[],
        ),
        child: Row(
          children: <Widget>[
            Icon(
              Icons.desktop_windows_outlined,
              color: _hovered ? Colors.cyan.shade700 : Colors.blueGrey,
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Hover to preview desktop-style interaction feedback.',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PointerTrackerPreview extends StatefulWidget {
  const _PointerTrackerPreview();

  @override
  State<_PointerTrackerPreview> createState() => _PointerTrackerPreviewState();
}

class _PointerTrackerPreviewState extends State<_PointerTrackerPreview> {
  Offset _position = const Offset(0, 0);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        MouseRegion(
          cursor: SystemMouseCursors.precise,
          onHover: (PointerEvent event) {
            setState(() => _position = event.localPosition);
          },
          child: Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[Colors.indigo.shade50, Colors.blue.shade50],
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Stack(
              children: <Widget>[
                Positioned(
                  left: (_position.dx - 8).clamp(0, double.infinity),
                  top: (_position.dy - 8).clamp(0, double.infinity),
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: const BoxDecoration(
                      color: Colors.indigo,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                const Center(
                  child: Text(
                    'Move the pointer here',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'localPosition: (${_position.dx.toStringAsFixed(0)}, ${_position.dy.toStringAsFixed(0)})',
        ),
      ],
    );
  }
}

class _CursorZonePreview extends StatefulWidget {
  const _CursorZonePreview();

  @override
  State<_CursorZonePreview> createState() => _CursorZonePreviewState();
}

class _CursorZonePreviewState extends State<_CursorZonePreview> {
  String _label = 'No zone hovered';

  @override
  Widget build(BuildContext context) {
    Widget buildZone({
      required String label,
      required MouseCursor cursor,
      required Color color,
    }) {
      return Expanded(
        child: MouseRegion(
          cursor: cursor,
          onEnter: (_) => setState(() => _label = label),
          onExit: (_) => setState(() => _label = 'No zone hovered'),
          child: Container(
            height: 110,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            buildZone(
              label: 'Resize',
              cursor: SystemMouseCursors.resizeLeftRight,
              color: Colors.orange,
            ),
            const SizedBox(width: 12),
            buildZone(
              label: 'Text',
              cursor: SystemMouseCursors.text,
              color: Colors.teal,
            ),
            const SizedBox(width: 12),
            buildZone(
              label: 'Click',
              cursor: SystemMouseCursors.click,
              color: Colors.purple,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text('Hovered zone: $_label'),
      ],
    );
  }
}

class _MouseExampleCard extends StatelessWidget {
  const _MouseExampleCard({
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
