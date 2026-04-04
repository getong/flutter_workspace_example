import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage(name: 'BottomNavigationBarExampleRoute')
class BottomNavigationBarExamplePage extends StatefulWidget {
  const BottomNavigationBarExamplePage({super.key});

  @override
  State<BottomNavigationBarExamplePage> createState() =>
      _BottomNavigationBarExamplePageState();
}

class _BottomNavigationBarExamplePageState
    extends State<BottomNavigationBarExamplePage> {
  int _selectedIndex = 0;

  static const List<_TabData> _tabs = <_TabData>[
    _TabData(
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: 'Home',
      color: Colors.indigo,
      description: 'Dashboard, overview cards, and quick summaries.',
    ),
    _TabData(
      icon: Icons.analytics_outlined,
      activeIcon: Icons.analytics,
      label: 'Analytics',
      color: Colors.teal,
      description: 'Reports, charts, and performance trends.',
    ),
    _TabData(
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: 'Profile',
      color: Colors.deepOrange,
      description: 'Account details, preferences, and saved settings.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final _TabData activeTab = _tabs[_selectedIndex];

    return Scaffold(
      appBar: AppBar(title: const Text('BottomNavigationBar Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
          children: <Widget>[
            const Text(
              'BottomNavigationBar is a classic Material widget for switching between a small number of top-level destinations.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
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
                      'Selected tab: ${activeTab.label}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(activeTab.description),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: activeTab.color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: <Widget>[
                          Icon(
                            activeTab.activeIcon,
                            size: 40,
                            color: activeTab.color,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            activeTab.label,
                            style: TextStyle(
                              color: activeTab.color,
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                            ),
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: _tabs
            .map(
              (_TabData tab) => BottomNavigationBarItem(
                icon: Icon(tab.icon),
                activeIcon: Icon(tab.activeIcon),
                label: tab.label,
              ),
            )
            .toList(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.router.replacePath('/'),
        icon: const Icon(Icons.home),
        label: const Text('Home'),
      ),
    );
  }
}

class _TabData {
  const _TabData({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.color,
    required this.description,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final Color color;
  final String description;
}
