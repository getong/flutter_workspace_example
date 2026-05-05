import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/app_navigation.dart';

@RoutePage(name: RouteName.scaffoldDemo)
class ScaffoldExamplePage extends StatefulWidget {
  const ScaffoldExamplePage({super.key});

  @override
  State<ScaffoldExamplePage> createState() => _ScaffoldExamplePageState();
}

class _ScaffoldExamplePageState extends State<ScaffoldExamplePage>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  int _selectedBottomNavIndex = 0;
  int _fabPressCount = 0;
  String _selectedDrawerAction = 'Inbox';
  bool _showPromoBanner = true;

  static const List<_ScaffoldTabData> _tabs = <_ScaffoldTabData>[
    _ScaffoldTabData(
      label: 'Overview',
      icon: Icons.dashboard_outlined,
      color: Color(0xFF3056D3),
      description:
          'Body content usually changes with tabs while the Scaffold shell stays the same.',
    ),
    _ScaffoldTabData(
      label: 'Activity',
      icon: Icons.insights_outlined,
      color: Color(0xFF0E9F6E),
      description:
          'TabBar is often placed in AppBar.bottom so page sections remain easy to scan.',
    ),
    _ScaffoldTabData(
      label: 'Profile',
      icon: Icons.person_outline,
      color: Color(0xFFE67E22),
      description:
          'A tab can hold any widget tree: lists, forms, charts, or nested layouts.',
    ),
  ];

  static const List<_DestinationData> _destinations = <_DestinationData>[
    _DestinationData(
      label: 'Home',
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      color: Color(0xFF3056D3),
      helperText: 'Top-level destination for dashboard-style content.',
    ),
    _DestinationData(
      label: 'Search',
      icon: Icons.search_outlined,
      activeIcon: Icons.search,
      color: Color(0xFF0E9F6E),
      helperText: 'Another root destination switched by the bottom bar.',
    ),
    _DestinationData(
      label: 'Library',
      icon: Icons.video_library_outlined,
      activeIcon: Icons.video_library,
      color: Color(0xFFE67E22),
      helperText: 'BottomNavigationBar is best for a few peer-level sections.',
    ),
  ];

  static const List<String> _drawerActions = <String>[
    'Inbox',
    'Saved',
    'Team',
    'Archive',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleDrawerSelection(String label) {
    setState(() {
      _selectedDrawerAction = label;
    });
    Navigator.of(context).maybePop();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Drawer selected: $label')));
  }

  void _handleFabPressed() {
    setState(() {
      _fabPressCount += 1;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('FloatingActionButton pressed $_fabPressCount times.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final _DestinationData destination = _destinations[_selectedBottomNavIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scaffold Module'),
        actions: <Widget>[
          IconButton(
            tooltip: _showPromoBanner ? 'Hide banner' : 'Show banner',
            onPressed: () {
              setState(() {
                _showPromoBanner = !_showPromoBanner;
              });
            },
            icon: Icon(
              _showPromoBanner
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: _tabs
              .map(
                (_ScaffoldTabData tab) =>
                    Tab(icon: Icon(tab.icon), text: tab.label),
              )
              .toList(),
        ),
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      destination.color,
                      destination.color.withValues(alpha: 0.75),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const CircleAvatar(
                      radius: 26,
                      child: Icon(Icons.view_quilt_outlined),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Drawer Demo',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Use a Drawer for secondary navigation and utility actions.',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  children: <Widget>[
                    for (final String label in _drawerActions)
                      ListTile(
                        leading: Icon(switch (label) {
                          'Inbox' => Icons.inbox_outlined,
                          'Saved' => Icons.bookmark_outline,
                          'Team' => Icons.groups_outlined,
                          _ => Icons.archive_outlined,
                        }),
                        title: Text(label),
                        selected: _selectedDrawerAction == label,
                        onTap: () => _handleDrawerSelection(label),
                      ),
                    const Divider(height: 24),
                    SwitchListTile(
                      value: _showPromoBanner,
                      onChanged: (bool value) {
                        setState(() {
                          _showPromoBanner = value;
                        });
                      },
                      title: const Text('Show body banner'),
                      subtitle: const Text(
                        'This toggle changes a widget inside Scaffold.body.',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          if (_showPromoBanner)
            Material(
              color: destination.color.withValues(alpha: 0.1),
              child: ListTile(
                leading: Icon(destination.activeIcon, color: destination.color),
                title: Text('${destination.label} shell is active'),
                subtitle: Text(
                  'BottomNavigationBar changes this banner and the summary cards below.',
                ),
                trailing: TextButton(
                  onPressed: () {
                    setState(() {
                      _showPromoBanner = false;
                    });
                  },
                  child: const Text('Dismiss'),
                ),
              ),
            ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: List<Widget>.generate(_tabs.length, (int index) {
                final _ScaffoldTabData tab = _tabs[index];
                return SelectionArea(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
                    children: <Widget>[
                      Text(
                        'Scaffold is the standard Material page shell. It coordinates app structure such as AppBar, Drawer, body, BottomNavigationBar, SnackBar, and FloatingActionButton.',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'This example keeps every major Scaffold slot active so you can inspect how the shell stays stable while different controls update the page.',
                        style: theme.textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 20),
                      _DemoCard(
                        title: 'AppBar + TabBar Demo',
                        description:
                            'The tabs above live in AppBar.bottom. Swiping this TabBarView or tapping a tab changes the active body section.',
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: tab.color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: tab.color.withValues(alpha: 0.22),
                            ),
                          ),
                          child: Row(
                            children: <Widget>[
                              CircleAvatar(
                                backgroundColor: tab.color,
                                foregroundColor: Colors.white,
                                child: Icon(tab.icon),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      tab.label,
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                            color: tab.color,
                                            fontWeight: FontWeight.w800,
                                          ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(tab.description),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _DemoCard(
                        title: 'Drawer Demo',
                        description:
                            'Open the Drawer from the AppBar leading icon. Selecting an item changes the shared state shown here.',
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.menu_open),
                          title: Text(
                            'Selected drawer action: $_selectedDrawerAction',
                          ),
                          subtitle: const Text(
                            'Drawer is useful for secondary navigation, account actions, or filters.',
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _DemoCard(
                        title: 'BottomNavigationBar Demo',
                        description:
                            'BottomNavigationBar switches root-level destinations. In this page it changes the active destination summary and accent color.',
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: destination.color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                destination.label,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: destination.color,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(destination.helperText),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _DemoCard(
                        title: 'FloatingActionButton Demo',
                        description:
                            'The FloatingActionButton below increments a counter and triggers a SnackBar through ScaffoldMessenger.',
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            backgroundColor: destination.color,
                            foregroundColor: Colors.white,
                            child: Text('$_fabPressCount'),
                          ),
                          title: const Text('FAB press count'),
                          subtitle: Text(
                            _fabPressCount == 0
                                ? 'Press the button in the lower-right corner.'
                                : 'The counter persists while switching tabs and bottom navigation items.',
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _DemoCard(
                        title: 'Body Demo',
                        description:
                            'Body is where the main content lives. Here it contains scrollable cards inside a TabBarView so the shell stays fixed while content changes.',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: <Widget>[
                                Chip(
                                  avatar: const Icon(Icons.layers, size: 18),
                                  label: Text(
                                    'Tab index ${_tabController.index}',
                                  ),
                                ),
                                Chip(
                                  avatar: const Icon(Icons.menu, size: 18),
                                  label: Text(_selectedDrawerAction),
                                ),
                                Chip(
                                  avatar: const Icon(
                                    Icons.navigation_outlined,
                                    size: 18,
                                  ),
                                  label: Text(destination.label),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Text(
                              'A Scaffold body can host nearly any layout: lists, forms, custom scroll views, charts, or nested navigators.',
                              style: theme.textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedBottomNavIndex,
        onTap: (int index) {
          setState(() {
            _selectedBottomNavIndex = index;
          });
        },
        items: _destinations
            .map(
              (_DestinationData destination) => BottomNavigationBarItem(
                icon: Icon(destination.icon),
                activeIcon: Icon(destination.activeIcon),
                label: destination.label,
              ),
            )
            .toList(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _handleFabPressed,
        icon: const Icon(Icons.add_comment_outlined),
        label: const Text('Demo FAB'),
      ),
    );
  }
}

class _DemoCard extends StatelessWidget {
  const _DemoCard({
    required this.title,
    required this.description,
    required this.child,
  });

  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
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

class _ScaffoldTabData {
  const _ScaffoldTabData({
    required this.label,
    required this.icon,
    required this.color,
    required this.description,
  });

  final String label;
  final IconData icon;
  final Color color;
  final String description;
}

class _DestinationData {
  const _DestinationData({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.color,
    required this.helperText,
  });

  final String label;
  final IconData icon;
  final IconData activeIcon;
  final Color color;
  final String helperText;
}
