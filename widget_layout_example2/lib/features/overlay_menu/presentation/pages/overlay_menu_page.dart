import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/app_navigation.dart';

@RoutePage(name: RouteName.overlayMenu)
class OverlayMenuPage extends StatefulWidget {
  const OverlayMenuPage({super.key});

  @override
  State<OverlayMenuPage> createState() => _OverlayMenuPageState();
}

class _OverlayMenuPageState extends State<OverlayMenuPage> {
  String _lastAction = 'No overlay action selected yet.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('OverlayMenu Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'OverlayMenu shows contextual actions in an anchored overlay without pushing a new route or opening a full-screen modal.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 24),
            _ExampleCard(
              title: 'Button-Style Overlay Menu',
              description:
                  'Use the widget as an action trigger when you want anchored menu items near the source control.',
              child: OverlayMenu<String>(
                menuWidth: 220,
                items: const <OverlayMenuItem<String>>[
                  OverlayMenuItem(
                    value: 'Open details',
                    label: 'Open details',
                    icon: Icons.open_in_new,
                  ),
                  OverlayMenuItem(
                    value: 'Duplicate record',
                    label: 'Duplicate record',
                    icon: Icons.copy_outlined,
                  ),
                  OverlayMenuItem(
                    value: 'Archive item',
                    label: 'Archive item',
                    icon: Icons.archive_outlined,
                  ),
                ],
                onSelected: (String value) {
                  setState(() {
                    _lastAction = value;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(Icons.more_horiz, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Open Overlay Menu',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'Card Action Menu',
              description:
                  'OverlayMenu also works well inside custom surfaces such as dashboards, tables, and activity cards.',
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: <Widget>[
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Release notes draft',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          SizedBox(height: 6),
                          Text('Last edited by Product Ops 18 minutes ago'),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    OverlayMenu<String>(
                      menuWidth: 200,
                      items: const <OverlayMenuItem<String>>[
                        OverlayMenuItem(
                          value: 'Share draft',
                          label: 'Share draft',
                          icon: Icons.share_outlined,
                        ),
                        OverlayMenuItem(
                          value: 'Move to review',
                          label: 'Move to review',
                          icon: Icons.rate_review_outlined,
                        ),
                        OverlayMenuItem(
                          value: 'Delete draft',
                          label: 'Delete draft',
                          icon: Icons.delete_outline,
                          destructive: true,
                        ),
                      ],
                      onSelected: (String value) {
                        setState(() {
                          _lastAction = value;
                        });
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(Icons.more_vert),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'Latest Result',
              description:
                  'Selected overlay actions can be returned to the page without leaving the current layout.',
              child: Text(_lastAction),
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

class OverlayMenuItem<T> {
  const OverlayMenuItem({
    required this.value,
    required this.label,
    this.icon,
    this.destructive = false,
  });

  final T value;
  final String label;
  final IconData? icon;
  final bool destructive;
}

class OverlayMenu<T> extends StatefulWidget {
  const OverlayMenu({
    super.key,
    required this.child,
    required this.items,
    required this.onSelected,
    this.menuWidth = 240,
  });

  final Widget child;
  final List<OverlayMenuItem<T>> items;
  final ValueChanged<T> onSelected;
  final double menuWidth;

  @override
  State<OverlayMenu<T>> createState() => _OverlayMenuState<T>();
}

class _OverlayMenuState<T> extends State<OverlayMenu<T>> {
  final OverlayPortalController _controller = OverlayPortalController();
  final LayerLink _layerLink = LayerLink();

  void _toggle() {
    if (_controller.isShowing) {
      _controller.hide();
    } else {
      _controller.show();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return CompositedTransformTarget(
      link: _layerLink,
      child: OverlayPortal(
        controller: _controller,
        overlayChildBuilder: (BuildContext context) {
          return Stack(
            children: <Widget>[
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: _controller.hide,
                ),
              ),
              CompositedTransformFollower(
                link: _layerLink,
                targetAnchor: Alignment.bottomRight,
                followerAnchor: Alignment.topRight,
                offset: const Offset(0, 8),
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    width: widget.menuWidth,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: theme.colorScheme.outlineVariant,
                      ),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: widget.items.map((OverlayMenuItem<T> item) {
                        final Color? textColor = item.destructive
                            ? Colors.red
                            : null;
                        return InkWell(
                          onTap: () {
                            _controller.hide();
                            widget.onSelected(item.value);
                          },
                          borderRadius: BorderRadius.circular(18),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            child: Row(
                              children: <Widget>[
                                if (item.icon != null) ...<Widget>[
                                  Icon(item.icon, color: textColor),
                                  const SizedBox(width: 12),
                                ],
                                Expanded(
                                  child: Text(
                                    item.label,
                                    style: TextStyle(color: textColor),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: _toggle,
            child: widget.child,
          ),
        ),
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
