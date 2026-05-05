import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/app_navigation.dart';

@RoutePage(name: RouteName.tabBarView)
class TabBarViewPage extends StatefulWidget {
  const TabBarViewPage({super.key});

  @override
  State<TabBarViewPage> createState() => _TabBarViewPageState();
}

class _TabBarViewPageState extends State<TabBarViewPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  int _currentTabIndex = 0;

  static const List<_TabShowcaseData> _tabs = <_TabShowcaseData>[
    _TabShowcaseData(
      label: 'Overview',
      title: 'Tab 1: Overview',
      icon: Icons.dashboard_outlined,
      color: Color(0xFF5B4FE9),
      description:
          'TabBarView shows the body for the currently selected tab and keeps the page area aligned with the TabBar.',
    ),
    _TabShowcaseData(
      label: 'Tasks',
      title: 'Tab 2: Tasks',
      icon: Icons.checklist_rtl_outlined,
      color: Color(0xFF0E9F6E),
      description:
          'It is commonly paired with TabBar inside a DefaultTabController or a manually managed TabController.',
    ),
    _TabShowcaseData(
      label: 'Profile',
      title: 'Tab 3: Profile',
      icon: Icons.person_outline,
      color: Color(0xFFE67E22),
      description:
          'Users can tap a tab or swipe horizontally through the matching content pages when swipe gestures are enabled.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this)
      ..addListener(_handleTabChanged);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChanged() {
    if (_currentTabIndex == _tabController.index) {
      return;
    }

    setState(() {
      _currentTabIndex = _tabController.index;
    });
  }

  void _selectTab(int index) {
    _tabController.animateTo(index);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final _TabShowcaseData activeTab = _tabs[_currentTabIndex];

    return Scaffold(
      appBar: AppBar(title: const Text('TabBarView Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
          children: <Widget>[
            const Text(
              'TabBarView displays a page for each tab and keeps the visible body synchronized with a TabBar.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Text(
              'Use it when several related sections share one screen shell, such as dashboards, settings pages, or category views.',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            Card(
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'TabBar + TabBarView In Sync',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Tap the tabs or swipe the content panel. The selected tab and visible body stay synchronized through one TabController.',
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        dividerColor: Colors.transparent,
                        labelPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        tabs: _tabs
                            .map(
                              (_TabShowcaseData tab) =>
                                  Tab(icon: Icon(tab.icon), text: tab.label),
                            )
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 300,
                      child: TabBarView(
                        controller: _tabController,
                        children: _tabs
                            .map(
                              (_TabShowcaseData tab) =>
                                  _TabDemoPanel(data: tab),
                            )
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: List<Widget>.generate(_tabs.length, (
                        int index,
                      ) {
                        return FilledButton.tonalIcon(
                          onPressed: () => _selectTab(index),
                          icon: Icon(_tabs[index].icon),
                          label: Text('Open ${_tabs[index].label}'),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Current Tab State',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'This panel shows the currently active tab. In a real app, the same tab index often controls toolbar actions, filters, or badges.',
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: activeTab.color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: activeTab.color.withValues(alpha: 0.24),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            activeTab.title,
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: activeTab.color,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Selected index: $_currentTabIndex',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: activeTab.color,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            activeTab.description,
                            style: theme.textTheme.bodyLarge,
                          ),
                        ],
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

class _TabDemoPanel extends StatelessWidget {
  const _TabDemoPanel({required this.data});

  final _TabShowcaseData data;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[data.color, data.color.withValues(alpha: 0.68)],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.white,
              foregroundColor: data.color,
              child: Icon(data.icon, size: 30),
            ),
            const SizedBox(height: 20),
            Text(
              data.title,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              data.description,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: Colors.white.withValues(alpha: 0.92),
                height: 1.4,
              ),
            ),
            const Spacer(),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: const <Widget>[
                Chip(label: Text('Shared AppBar')),
                Chip(label: Text('Swipe Between Tabs')),
                Chip(label: Text('Controller Driven')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TabShowcaseData {
  const _TabShowcaseData({
    required this.label,
    required this.title,
    required this.icon,
    required this.color,
    required this.description,
  });

  final String label;
  final String title;
  final IconData icon;
  final Color color;
  final String description;
}
