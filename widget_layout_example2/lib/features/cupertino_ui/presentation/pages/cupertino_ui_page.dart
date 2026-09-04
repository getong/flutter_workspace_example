import 'package:auto_route/auto_route.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';

@RoutePage(name: RouteName.cupertinoUi)
class CupertinoUiPage extends StatefulWidget {
  const CupertinoUiPage({super.key});

  @override
  State<CupertinoUiPage> createState() => _CupertinoUiPageState();
}

class _CupertinoUiPageState extends State<CupertinoUiPage> {
  final MenuController _imperativeMenuController = MenuController();
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

  void _setTheme(String theme) {
    setState(() {
      _selectedTheme = theme;
    });
    _setLastAction('Theme changed to $theme');
  }

  void _toggleNotifications() {
    setState(() {
      _notificationsEnabled = !_notificationsEnabled;
    });
    _setLastAction(
      _notificationsEnabled
          ? 'Notifications enabled'
          : 'Notifications disabled',
    );
  }

  void _toggleCompactCards() {
    setState(() {
      _compactCards = !_compactCards;
    });
    _setLastAction(
      _compactCards ? 'Compact cards enabled' : 'Compact cards disabled',
    );
  }

  List<Widget> _buildBasicItems() {
    return <Widget>[
      CupertinoMenuItem(
        onPressed: () => _setLastAction('Edit article tapped'),
        leading: const Icon(CupertinoIcons.pencil),
        child: const Text('Edit article'),
      ),
      CupertinoMenuItem(
        onPressed: () => _setLastAction('Duplicate tapped'),
        leading: const Icon(CupertinoIcons.doc_on_doc),
        child: const Text('Duplicate'),
      ),
      CupertinoMenuItem(
        onPressed: () => _setLastAction('Archive tapped'),
        leading: const Icon(CupertinoIcons.archivebox),
        child: const Text('Archive'),
      ),
      CupertinoMenuItem(
        onPressed: () => _setLastAction('Delete tapped'),
        leading: const Icon(CupertinoIcons.delete),
        isDestructiveAction: true,
        child: const Text('Delete'),
      ),
    ];
  }

  List<Widget> _buildSelectableItems() {
    return <Widget>[
      _SelectableMenuItem(
        selected: _selectedTheme == 'System',
        onPressed: () => _setTheme('System'),
        leading: CupertinoIcons.device_phone_portrait,
        label: 'System',
      ),
      _SelectableMenuItem(
        selected: _selectedTheme == 'Light',
        onPressed: () => _setTheme('Light'),
        leading: CupertinoIcons.sun_max,
        label: 'Light',
      ),
      _SelectableMenuItem(
        selected: _selectedTheme == 'Dark',
        onPressed: () => _setTheme('Dark'),
        leading: CupertinoIcons.moon,
        label: 'Dark',
      ),
    ];
  }

  List<Widget> _buildRichItems(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return <Widget>[
      CupertinoMenuItem(
        onPressed: () => _setLastAction('Workspace header tapped'),
        leading: CircleAvatar(
          backgroundColor: colorScheme.primaryContainer,
          foregroundColor: colorScheme.onPrimaryContainer,
          child: const Icon(CupertinoIcons.person_crop_circle_fill),
        ),
        subtitle: const Text('Open settings and quick tools'),
        trailing: const Icon(CupertinoIcons.chevron_right),
        child: const Text('Design workspace'),
      ),
      const CupertinoMenuDivider(),
      CupertinoMenuItem(
        onPressed: () => _setLastAction('Reply tapped'),
        leading: const Icon(CupertinoIcons.reply),
        child: const Text('Reply'),
      ),
      CupertinoMenuItem(
        onPressed: () => _setLastAction('Share tapped'),
        leading: const Icon(CupertinoIcons.share),
        child: const Text('Share'),
      ),
      CupertinoMenuItem(
        onPressed: () => _setLastAction('Copy tapped'),
        leading: const Icon(CupertinoIcons.doc_on_doc),
        child: const Text('Copy'),
      ),
      const CupertinoMenuDivider(),
      _SelectableMenuItem(
        selected: _notificationsEnabled,
        onPressed: _toggleNotifications,
        leading: CupertinoIcons.bell,
        label: 'Enable notifications',
      ),
      _SelectableMenuItem(
        selected: _compactCards,
        onPressed: _toggleCompactCards,
        leading: CupertinoIcons.rectangle_grid_2x2,
        label: 'Compact cards',
      ),
    ];
  }

  List<Widget> _buildImperativeItems() {
    return <Widget>[
      CupertinoMenuItem(
        onPressed: () => _setLastAction('Rename tapped'),
        leading: const Icon(CupertinoIcons.text_cursor),
        child: const Text('Rename'),
      ),
      CupertinoMenuItem(
        onPressed: () => _setLastAction('Move to folder tapped'),
        leading: const Icon(CupertinoIcons.folder),
        subtitle: const Text('Organize this page example'),
        child: const Text('Move to folder'),
      ),
      CupertinoMenuItem(
        onPressed: () => _setLastAction('Pin to top tapped'),
        leading: const Icon(CupertinoIcons.pin),
        child: const Text('Pin to top'),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('cupertino_ui Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'cupertino_ui is the new package for Cupertino components. '
              'CupertinoMenuAnchor implements the iOS-style pull-down menu and '
              'is the official replacement for the discontinued pull_down_button '
              'package.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            _CupertinoMenuExampleCard(
              title: 'Basic CupertinoMenuAnchor',
              description:
                  'A trigger widget wraps the menu. The builder receives a MenuController '
                  'whose open() shows the menu anchored to the trigger.',
              footer:
                  'APIs: CupertinoMenuAnchor, CupertinoMenuItem, CupertinoMenuDivider',
              child: CupertinoMenuAnchor(
                menuChildren: _buildBasicItems(),
                builder:
                    (BuildContext context, MenuController controller, Widget? child) {
                  return FilledButton.icon(
                    onPressed: controller.open,
                    icon: const Icon(Icons.arrow_drop_down_circle_outlined),
                    label: const Text('Open basic menu'),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            _CupertinoMenuExampleCard(
              title: 'Selectable Menu Items',
              description:
                  'Selecting a value is shown with a trailing checkmark icon. '
                  'This example keeps one selected theme and shows the active value below.',
              footer:
                  'Current theme: $_selectedTheme\nAPI: CupertinoMenuItem + trailing checkmark',
              child: CupertinoMenuAnchor(
                menuChildren: _buildSelectableItems(),
                builder:
                    (BuildContext context, MenuController controller, Widget? child) {
                  return OutlinedButton.icon(
                    onPressed: controller.open,
                    icon: const Icon(Icons.palette_outlined),
                    label: const Text('Choose theme'),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            _CupertinoMenuExampleCard(
              title: 'Header + Quick Actions + Toggle State',
              description:
                  'A richer menu mixes a header item, grouped quick actions, larger '
                  'dividers, and selectable state items in the same panel.',
              footer:
                  'Notifications: ${_notificationsEnabled ? 'On' : 'Off'}  |  '
                  'Compact cards: ${_compactCards ? 'On' : 'Off'}',
              child: CupertinoMenuAnchor(
                menuChildren: _buildRichItems(context),
                builder:
                    (BuildContext context, MenuController controller, Widget? child) {
                  return IconButton.filledTonal(
                    onPressed: controller.open,
                    icon: const Icon(Icons.more_horiz),
                    tooltip: 'Open advanced pull-down menu',
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            _CupertinoMenuExampleCard(
              title: 'MenuController Imperative Example',
              description:
                  'If you already have a button and only want to open the menu '
                  'imperatively, drive it with an external MenuController instead of '
                  'wrapping the button in the anchor builder.',
              footer: 'API: MenuController.open / MenuController.close',
              child: CupertinoMenuAnchor(
                controller: _imperativeMenuController,
                menuChildren: _buildImperativeItems(),
                builder:
                    (BuildContext context, MenuController controller, Widget? child) {
                  return TextButton.icon(
                    onPressed: () {
                      if (controller.isOpen) {
                        controller.close();
                      } else {
                        controller.open();
                      }
                    },
                    icon: const Icon(Icons.touch_app_outlined),
                    label: const Text('Open context menu'),
                  );
                },
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

class _SelectableMenuItem extends StatelessWidget {
  const _SelectableMenuItem({
    required this.selected,
    required this.onPressed,
    required this.leading,
    required this.label,
  });

  final bool selected;
  final VoidCallback onPressed;
  final IconData leading;
  final String label;

  @override
  Widget build(BuildContext context) {
    return CupertinoMenuItem(
      onPressed: onPressed,
      leading: Icon(leading),
      trailing: Icon(
        CupertinoIcons.checkmark,
        color: selected ? CupertinoColors.activeBlue : CupertinoColors.transparent,
      ),
      child: Text(label),
    );
  }
}

class _CupertinoMenuExampleCard extends StatelessWidget {
  const _CupertinoMenuExampleCard({
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