import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/app_navigation.dart';

enum _DrawerDemoKind { navigation, account }

@RoutePage(name: RouteName.drawer)
class DrawerPage extends StatefulWidget {
  const DrawerPage({super.key});

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  _DrawerDemoKind _drawerKind = _DrawerDemoKind.navigation;
  String _selectedDestination = 'Inbox';
  String _selectedFilter = 'All activity';
  final List<String> _eventLog = <String>[];

  void _record(String message) {
    final DateTime now = DateTime.now();
    final String timestamp =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';

    setState(() {
      _eventLog.insert(0, '$timestamp  $message');
      if (_eventLog.length > 10) {
        _eventLog.removeRange(10, _eventLog.length);
      }
    });
  }

  void _openStartDrawer() {
    _record(
      _drawerKind == _DrawerDemoKind.navigation
          ? 'Opened the navigation drawer.'
          : 'Opened the account drawer.',
    );
    _scaffoldKey.currentState?.openDrawer();
  }

  void _openEndDrawer() {
    _record('Opened the end drawer.');
    _scaffoldKey.currentState?.openEndDrawer();
  }

  void _selectDestination(String destination) {
    setState(() {
      _selectedDestination = destination;
    });
    _record('Selected "$destination" from the start drawer.');
    Navigator.of(context).pop();
  }

  void _selectFilter(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
    _record('Selected "$filter" from the end drawer.');
    Navigator.of(context).pop();
  }

  Drawer _buildNavigationDrawer(BuildContext context) {
    final List<(String label, IconData icon)> items = <(String, IconData)>[
      ('Inbox', Icons.inbox_outlined),
      ('Projects', Icons.folder_open_outlined),
      ('Calendar', Icons.calendar_month_outlined),
      ('Archive', Icons.archive_outlined),
    ];

    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.white.withValues(alpha: 0.18),
                    child: const Icon(
                      Icons.dashboard_customize,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    'Workspace Drawer',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Use DrawerHeader for branded navigation content.',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.92),
                    ),
                  ),
                ],
              ),
            ),
            ...items.map(
              ((String, IconData) item) => ListTile(
                leading: Icon(item.$2),
                title: Text(item.$1),
                selected: _selectedDestination == item.$1,
                onTap: () => _selectDestination(item.$1),
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Settings'),
              onTap: () => _selectDestination('Settings'),
            ),
          ],
        ),
      ),
    );
  }

  Drawer _buildAccountDrawer(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(child: Text('G')),
              accountName: Text('Gerald Demo'),
              accountEmail: Text('gerald@example.com'),
              otherAccountsPictures: <Widget>[
                CircleAvatar(child: Icon(Icons.work_outline)),
              ],
            ),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('Profile'),
              onTap: () => _selectDestination('Profile'),
            ),
            ListTile(
              leading: const Icon(Icons.credit_card_outlined),
              title: const Text('Billing'),
              onTap: () => _selectDestination('Billing'),
            ),
            ListTile(
              leading: const Icon(Icons.group_outlined),
              title: const Text('Team members'),
              onTap: () => _selectDestination('Team members'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sign out'),
              onTap: () => _selectDestination('Sign out'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEndDrawer(BuildContext context) {
    final List<String> filters = <String>[
      'All activity',
      'Assigned to me',
      'Unread',
      'Flagged',
    ];

    return Drawer(
      child: SafeArea(
        child: SizedBox(
          width: 320,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiaryContainer,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Icon(
                      Icons.tune_outlined,
                      size: 32,
                      color: Theme.of(context).colorScheme.onTertiaryContainer,
                    ),
                    const Spacer(),
                    Text(
                      'End Drawer Filters',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: Theme.of(
                          context,
                        ).colorScheme.onTertiaryContainer,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Use `endDrawer` for secondary tools, filters, or actions.',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onTertiaryContainer
                            .withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
              ...filters.map(
                (String filter) => ListTile(
                  leading: Icon(
                    _selectedFilter == filter
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                  ),
                  selected: _selectedFilter == filter,
                  title: Text(filter),
                  onTap: () => _selectFilter(filter),
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(16),
                child: FilledButton.icon(
                  onPressed: () {
                    _record('Applied "$_selectedFilter" in the end drawer.');
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.check),
                  label: const Text('Apply Filter'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: const Text('Drawer Module')),
      drawer: _drawerKind == _DrawerDemoKind.navigation
          ? _buildNavigationDrawer(context)
          : _buildAccountDrawer(context),
      endDrawer: _buildEndDrawer(context),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'Drawer provides a Material side sheet for primary navigation or secondary tools. Use `drawer` for the leading side and `endDrawer` for actions, filters, or contextual utilities.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            const _DrawerCodeCard(
              title: 'Typical setup',
              code: '''
Scaffold(
  drawer: Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        const DrawerHeader(child: Text('Navigation')),
        ListTile(title: const Text('Inbox')),
      ],
    ),
  ),
)
''',
            ),
            const SizedBox(height: 16),
            _DrawerExampleCard(
              title: 'Start Drawer Variants',
              description:
                  'Switch between a classic navigation drawer using `DrawerHeader` and an account drawer using `UserAccountsDrawerHeader`.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SegmentedButton<_DrawerDemoKind>(
                    segments: const <ButtonSegment<_DrawerDemoKind>>[
                      ButtonSegment(
                        value: _DrawerDemoKind.navigation,
                        icon: Icon(Icons.menu),
                        label: Text('Navigation'),
                      ),
                      ButtonSegment(
                        value: _DrawerDemoKind.account,
                        icon: Icon(Icons.account_circle_outlined),
                        label: Text('Account'),
                      ),
                    ],
                    selected: <_DrawerDemoKind>{_drawerKind},
                    onSelectionChanged: (Set<_DrawerDemoKind> selection) {
                      setState(() {
                        _drawerKind = selection.first;
                      });
                      _record(
                        selection.first == _DrawerDemoKind.navigation
                            ? 'Switched to DrawerHeader example.'
                            : 'Switched to UserAccountsDrawerHeader example.',
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: <Widget>[
                      FilledButton.icon(
                        onPressed: _openStartDrawer,
                        icon: const Icon(Icons.menu_open),
                        label: Text(
                          _drawerKind == _DrawerDemoKind.navigation
                              ? 'Open navigation drawer'
                              : 'Open account drawer',
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: _openEndDrawer,
                        icon: const Icon(Icons.tune),
                        label: const Text('Open end drawer'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _DrawerExampleCard(
              title: 'Current Drawer State',
              description:
                  'Selections made inside the drawers update the page without leaving the current route.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Start drawer mode: ${_drawerKind.name}'),
                  const SizedBox(height: 8),
                  Text('Selected destination: $_selectedDestination'),
                  const SizedBox(height: 8),
                  Text('Selected filter: $_selectedFilter'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const _DrawerExampleCard(
              title: 'Common Usage Notes',
              description:
                  'Use `drawerEnableOpenDragGesture` if you need to disable swipe opening, use `ScaffoldState.openDrawer()` or `openEndDrawer()` for explicit control, and keep large menus inside a scrollable child such as `ListView`.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _DrawerBullet(
                    text: 'Primary navigation often belongs in `drawer`.',
                  ),
                  _DrawerBullet(
                    text:
                        'Filters and secondary actions fit well in `endDrawer`.',
                  ),
                  _DrawerBullet(
                    text:
                        'Wrap content in `SafeArea` to avoid status-bar overlap.',
                  ),
                  _DrawerBullet(
                    text:
                        'Use `DrawerHeader` or `UserAccountsDrawerHeader` for clear hierarchy.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _DrawerExampleCard(
              title: 'Recent Event Log',
              description:
                  'This helps verify drawer open and selection behavior while testing the examples.',
              child: _eventLog.isEmpty
                  ? const Text('No drawer events yet.')
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _eventLog
                          .map(
                            (String entry) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(entry),
                            ),
                          )
                          .toList(growable: false),
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

class _DrawerExampleCard extends StatelessWidget {
  const _DrawerExampleCard({
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

class _DrawerCodeCard extends StatelessWidget {
  const _DrawerCodeCard({required this.title, required this.code});

  final String title;
  final String code;

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
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                code,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'monospace',
                  height: 1.45,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerBullet extends StatelessWidget {
  const _DrawerBullet({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Icon(Icons.circle, size: 8),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
