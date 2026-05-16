import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';

@RoutePage(name: RouteName.pullDownButton)
class PullDownButtonPage extends StatefulWidget {
  const PullDownButtonPage({super.key});

  @override
  State<PullDownButtonPage> createState() => _PullDownButtonPageState();
}

class _PullDownButtonPageState extends State<PullDownButtonPage> {
  final GlobalKey _contextMenuButtonKey = GlobalKey();
  String _lastAction = 'Nothing selected yet.';
  String _selectedTheme = 'System';
  bool _notificationsEnabled = true;
  bool _compactCards = false;

  void _showMessage(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _setLastAction(String action) {
    setState(() {
      _lastAction = action;
    });
    _showMessage(action);
  }

  List<PullDownMenuEntry> _buildBasicItems(BuildContext context) {
    return <PullDownMenuEntry>[
      const PullDownMenuTitle(title: Text('Quick actions')),
      PullDownMenuItem(
        title: 'Edit article',
        icon: CupertinoIcons.pencil,
        onTap: () => _setLastAction('Edit article tapped'),
      ),
      PullDownMenuItem(
        title: 'Duplicate',
        icon: CupertinoIcons.doc_on_doc,
        onTap: () => _setLastAction('Duplicate tapped'),
      ),
      PullDownMenuItem(
        title: 'Archive',
        icon: CupertinoIcons.archivebox,
        onTap: () => _setLastAction('Archive tapped'),
      ),
      PullDownMenuItem(
        title: 'Delete',
        icon: CupertinoIcons.delete,
        isDestructive: true,
        onTap: () => _setLastAction('Delete tapped'),
      ),
    ];
  }

  List<PullDownMenuEntry> _buildSelectableItems(BuildContext context) {
    return <PullDownMenuEntry>[
      const PullDownMenuTitle(title: Text('Theme preference')),
      PullDownMenuItem.selectable(
        title: 'System',
        selected: _selectedTheme == 'System',
        icon: CupertinoIcons.device_phone_portrait,
        onTap: () {
          setState(() {
            _selectedTheme = 'System';
          });
          _setLastAction('Theme changed to System');
        },
      ),
      PullDownMenuItem.selectable(
        title: 'Light',
        selected: _selectedTheme == 'Light',
        icon: CupertinoIcons.sun_max,
        onTap: () {
          setState(() {
            _selectedTheme = 'Light';
          });
          _setLastAction('Theme changed to Light');
        },
      ),
      PullDownMenuItem.selectable(
        title: 'Dark',
        selected: _selectedTheme == 'Dark',
        icon: CupertinoIcons.moon,
        onTap: () {
          setState(() {
            _selectedTheme = 'Dark';
          });
          _setLastAction('Theme changed to Dark');
        },
      ),
    ];
  }

  List<PullDownMenuEntry> _buildHeaderItems(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return <PullDownMenuEntry>[
      PullDownMenuHeader(
        leading: CircleAvatar(
          backgroundColor: colorScheme.primaryContainer,
          foregroundColor: colorScheme.onPrimaryContainer,
          child: const Icon(CupertinoIcons.person_crop_circle_fill),
        ),
        title: 'Design workspace',
        subtitle: 'Open settings and quick tools',
        onTap: () => _setLastAction('Workspace header tapped'),
        icon: CupertinoIcons.chevron_right,
      ),
      PullDownMenuActionsRow.medium(
        items: <PullDownMenuItem>[
          PullDownMenuItem(
            title: 'Reply',
            icon: CupertinoIcons.reply,
            onTap: () => _setLastAction('Reply tapped'),
          ),
          PullDownMenuItem(
            title: 'Share',
            icon: CupertinoIcons.share,
            onTap: () => _setLastAction('Share tapped'),
          ),
          PullDownMenuItem(
            title: 'Copy',
            icon: CupertinoIcons.doc_on_doc,
            onTap: () => _setLastAction('Copy tapped'),
          ),
        ],
      ),
      const PullDownMenuDivider.large(),
      PullDownMenuItem.selectable(
        title: 'Enable notifications',
        selected: _notificationsEnabled,
        icon: CupertinoIcons.bell,
        onTap: () {
          setState(() {
            _notificationsEnabled = !_notificationsEnabled;
          });
          _setLastAction(
            _notificationsEnabled
                ? 'Notifications enabled'
                : 'Notifications disabled',
          );
        },
      ),
      PullDownMenuItem.selectable(
        title: 'Compact cards',
        selected: _compactCards,
        icon: CupertinoIcons.rectangle_grid_2x2,
        onTap: () {
          setState(() {
            _compactCards = !_compactCards;
          });
          _setLastAction(
            _compactCards ? 'Compact cards enabled' : 'Compact cards disabled',
          );
        },
      ),
    ];
  }

  Future<void> _showContextMenu() {
    final BuildContext? buttonContext = _contextMenuButtonKey.currentContext;
    if (buttonContext == null) {
      return Future<void>.value();
    }

    final RenderBox button = buttonContext.findRenderObject()! as RenderBox;
    final Offset topLeft = button.localToGlobal(Offset.zero);
    final Rect position = topLeft & button.size;

    return showPullDownMenu(
      context: context,
      items: <PullDownMenuEntry>[
        const PullDownMenuTitle(title: Text('More actions')),
        PullDownMenuItem(
          title: 'Rename',
          icon: CupertinoIcons.text_cursor,
          onTap: () => _setLastAction('Rename tapped'),
        ),
        PullDownMenuItem(
          title: 'Move to folder',
          subtitle: 'Organize this page example',
          icon: CupertinoIcons.folder,
          onTap: () => _setLastAction('Move to folder tapped'),
        ),
        PullDownMenuItem(
          title: 'Pin to top',
          icon: CupertinoIcons.pin,
          onTap: () => _setLastAction('Pin to top tapped'),
        ),
      ],
      position: position,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('pull_down_button Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'pull_down_button provides iOS-style pull-down menus. It works well for compact action lists, selectable settings, and contextual overflow menus without building a full custom overlay.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            _PullDownExampleCard(
              title: 'Basic PullDownButton',
              description:
                  'Use PullDownButton when you want a trigger widget that builds a menu on demand. The itemBuilder returns menu entries such as titles, items, and dividers.',
              footer:
                  'APIs: PullDownButton, PullDownMenuItem, PullDownMenuTitle',
              child: Align(
                alignment: Alignment.centerLeft,
                child: PullDownButton(
                  itemBuilder: _buildBasicItems,
                  buttonBuilder: (BuildContext context, VoidCallback showMenu) {
                    return FilledButton.icon(
                      onPressed: showMenu,
                      icon: const Icon(Icons.arrow_drop_down_circle_outlined),
                      label: const Text('Open basic menu'),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            _PullDownExampleCard(
              title: 'Selectable Menu Items',
              description:
                  'PullDownMenuItem.selectable is useful for single-choice preferences. This example keeps one selected theme and shows the active value below.',
              footer:
                  'Current theme: $_selectedTheme\nAPI: PullDownMenuItem.selectable',
              child: Align(
                alignment: Alignment.centerLeft,
                child: PullDownButton(
                  itemBuilder: _buildSelectableItems,
                  buttonBuilder: (BuildContext context, VoidCallback showMenu) {
                    return OutlinedButton.icon(
                      onPressed: showMenu,
                      icon: const Icon(Icons.palette_outlined),
                      label: const Text('Choose theme'),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            _PullDownExampleCard(
              title: 'Header + Actions Row + Toggle State',
              description:
                  'A richer menu can mix a header, grouped action row, larger divider, and selectable state items in the same panel.',
              footer:
                  'Notifications: ${_notificationsEnabled ? 'On' : 'Off'}  |  Compact cards: ${_compactCards ? 'On' : 'Off'}',
              child: Align(
                alignment: Alignment.centerLeft,
                child: PullDownButton(
                  itemBuilder: _buildHeaderItems,
                  buttonBuilder: (BuildContext context, VoidCallback showMenu) {
                    return IconButton.filledTonal(
                      onPressed: showMenu,
                      icon: const Icon(Icons.more_horiz),
                      tooltip: 'Open advanced pull-down menu',
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            _PullDownExampleCard(
              title: 'showPullDownMenu Imperative Example',
              description:
                  'If you already have a button and only want to open the menu imperatively, showPullDownMenu gives you a direct API instead of wrapping the button with PullDownButton.',
              footer: 'API: showPullDownMenu(context: ..., items: ...)',
              child: Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  key: _contextMenuButtonKey,
                  onPressed: _showContextMenu,
                  icon: const Icon(Icons.touch_app_outlined),
                  label: const Text('Open context menu'),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Icon(Icons.info_outline, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Last action: $_lastAction',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                  ],
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

class _PullDownExampleCard extends StatelessWidget {
  const _PullDownExampleCard({
    required this.title,
    required this.description,
    required this.footer,
    required this.child,
  });

  final String title;
  final String description;
  final String footer;
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
              footer,
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
