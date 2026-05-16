import 'package:auto_route/auto_route.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';

@RoutePage(name: RouteName.fluentUi)
class FluentUiPage extends StatefulWidget {
  const FluentUiPage({super.key});

  @override
  State<FluentUiPage> createState() => _FluentUiPageState();
}

class _FluentUiPageState extends State<FluentUiPage> {
  static const double _twoColumnBreakpoint = 720;
  static const List<String> _deploymentRingOptions = <String>[
    'Canary',
    'Preview',
    'Production',
  ];
  static const List<String> _commandSuggestions = <String>[
    'Create release branch',
    'Open deployment center',
    'Invite reviewer',
    'Restart build',
  ];

  final TextEditingController _workspaceController = TextEditingController(
    text: 'contoso-control-center',
  );

  bool _compactPane = false;
  bool _notificationsEnabled = true;
  bool _syncDrafts = true;
  int _selectedPaneIndex = 0;
  String _deploymentRing = 'Preview';
  String _status =
      'The embedded preview uses `FluentTheme`, `NavigationView`, and multiple WinUI-style controls.';
  List<String> _eventLog = <String>[];

  @override
  void dispose() {
    _workspaceController.dispose();
    super.dispose();
  }

  void _logEvent(String message) {
    final DateTime now = DateTime.now();
    final String timestamp =
        '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}:'
        '${now.second.toString().padLeft(2, '0')}';
    setState(() {
      _eventLog = <String>[
        '$timestamp  $message',
        ..._eventLog,
      ].take(10).toList();
    });
  }

  Future<void> _showDialog(BuildContext context) async {
    await fluent.showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return fluent.ContentDialog(
          title: const fluent.Text('Publish workspace snapshot?'),
          content: const fluent.Text(
            'This dialog demonstrates `ContentDialog` embedded inside a local '
            'Fluent themed preview rather than a full `FluentApp`.',
          ),
          actions: <Widget>[
            fluent.Button(
              onPressed: () => Navigator.of(context).pop(),
              child: const fluent.Text('Cancel'),
            ),
            fluent.FilledButton(
              onPressed: () {
                Navigator.of(context).pop();
                _logEvent('Confirmed dialog action');
                setState(() {
                  _status =
                      'Published a workspace snapshot from ContentDialog.';
                });
              },
              child: const fluent.Text('Publish'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildResponsiveTwoPane({
    required Widget leading,
    required Widget trailing,
  }) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth < _twoColumnBreakpoint) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[leading, const SizedBox(height: 16), trailing],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(child: leading),
            const SizedBox(width: 16),
            Expanded(child: trailing),
          ],
        );
      },
    );
  }

  Widget _buildOverviewPage(BuildContext context) {
    return fluent.ScaffoldPage.scrollable(
      header: fluent.PageHeader(
        title: const fluent.Text('Workspace Overview'),
        commandBar: Wrap(
          spacing: 8,
          children: <Widget>[
            fluent.Button(
              onPressed: () => _showDialog(context),
              child: const fluent.Text('Open Dialog'),
            ),
            fluent.FilledButton(
              onPressed: () {
                fluent.displayInfoBar(
                  context,
                  builder: (BuildContext context, VoidCallback close) {
                    return fluent.InfoBar.success(
                      title: const fluent.Text('Deployment queued'),
                      content: const fluent.Text(
                        'The preview uses `displayInfoBar` with a dismiss '
                        'action and Fluent theming.',
                      ),
                      action: fluent.IconButton(
                        icon: const fluent.Icon(
                          fluent.FluentIcons.chrome_close,
                        ),
                        onPressed: close,
                      ),
                    );
                  },
                );
                _logEvent('Displayed InfoBar popup');
                setState(() {
                  _status =
                      'Queued a deployment and displayed an InfoBar popup.';
                });
              },
              child: const fluent.Text('Queue Deploy'),
            ),
          ],
        ),
      ),
      children: <Widget>[
        fluent.InfoBar(
          title: const fluent.Text('Embedded Fluent preview'),
          content: const fluent.Text(
            'This card demonstrates `InfoBar`, while the sections below use '
            '`TextBox`, `AutoSuggestBox`, `ComboBox`, `ToggleSwitch`, '
            '`ProgressBar`, `ProgressRing`, `Button`, `FilledButton`, and '
            '`Acrylic`.',
          ),
          severity: fluent.InfoBarSeverity.info,
        ),
        const SizedBox(height: 20),
        fluent.Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const fluent.Text(
                  'Project Configuration',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 16),
                fluent.InfoLabel(
                  label: 'Workspace name',
                  child: fluent.TextBox(
                    controller: _workspaceController,
                    placeholder: 'Enter a workspace name',
                    onChanged: (String value) {
                      setState(() {
                        _status = 'Updated TextBox value to "$value".';
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),
                fluent.InfoLabel(
                  label: 'Quick commands',
                  child: fluent.AutoSuggestBox<String>(
                    placeholder: 'Type a command',
                    items: _commandSuggestions
                        .map(
                          (String command) => fluent.AutoSuggestBoxItem<String>(
                            value: command,
                            label: command,
                          ),
                        )
                        .toList(growable: false),
                    onSelected: (fluent.AutoSuggestBoxItem<String> item) {
                      setState(() {
                        _status =
                            'Selected AutoSuggestBox command "${item.value}".';
                      });
                      _logEvent('AutoSuggestBox selected ${item.value}');
                    },
                  ),
                ),
                const SizedBox(height: 16),
                _buildResponsiveTwoPane(
                  leading: fluent.InfoLabel(
                    label: 'Deployment ring',
                    child: fluent.ComboBox<String>(
                      value: _deploymentRing,
                      isExpanded: true,
                      items: _deploymentRingOptions
                          .map(
                            (String value) => fluent.ComboBoxItem<String>(
                              value: value,
                              child: fluent.Text(value),
                            ),
                          )
                          .toList(growable: false),
                      onChanged: (String? value) {
                        if (value == null) {
                          return;
                        }
                        setState(() {
                          _deploymentRing = value;
                          _status = 'Switched ComboBox value to "$value".';
                        });
                        _logEvent('ComboBox changed to $value');
                      },
                    ),
                  ),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const fluent.Text(
                        'ToggleSwitch',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 10),
                      fluent.ToggleSwitch(
                        checked: _notificationsEnabled,
                        content: const fluent.Text(
                          'Enable release notifications',
                        ),
                        onChanged: (bool value) {
                          setState(() {
                            _notificationsEnabled = value;
                            _status =
                                'Toggled notifications to ${value ? 'enabled' : 'disabled'}.';
                          });
                          _logEvent('ToggleSwitch notifications = $value');
                        },
                      ),
                      const SizedBox(height: 10),
                      fluent.ToggleSwitch(
                        checked: _syncDrafts,
                        content: const fluent.Text('Sync local drafts'),
                        onChanged: (bool value) {
                          setState(() {
                            _syncDrafts = value;
                            _status =
                                'Sync drafts is now ${value ? 'on' : 'off'}.';
                          });
                          _logEvent('ToggleSwitch draft sync = $value');
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        _buildResponsiveTwoPane(
          leading: fluent.Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const <Widget>[
                  fluent.Text(
                    'ProgressBar',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 12),
                  fluent.ProgressBar(value: 76),
                  SizedBox(height: 10),
                  fluent.Text('Release validation: 76% complete'),
                ],
              ),
            ),
          ),
          trailing: fluent.Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const <Widget>[
                  fluent.Text(
                    'ProgressRing',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: SizedBox(
                      width: 44,
                      height: 44,
                      child: fluent.ProgressRing(value: 0.58),
                    ),
                  ),
                  SizedBox(height: 12),
                  Center(child: fluent.Text('58% rollout readiness')),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        fluent.Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const fluent.Text(
                  'Acrylic Surface',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                Stack(
                  children: <Widget>[
                    Container(
                      height: 120,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: <Color>[
                            Colors.blue.shade200,
                            Colors.indigo.shade400,
                            Colors.teal.shade300,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    const Positioned.fill(
                      child: fluent.Acrylic(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        luminosityAlpha: 0.35,
                        tintAlpha: 0.08,
                      ),
                    ),
                    const Positioned.fill(
                      child: Center(
                        child: fluent.Text(
                          'Use Acrylic to create layered Windows-like surfaces.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInsightsPage() {
    return fluent.ScaffoldPage.scrollable(
      header: const fluent.PageHeader(title: fluent.Text('Insights')),
      children: <Widget>[
        fluent.Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                fluent.Text(
                  'InfoLabel + metrics cards',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 12),
                fluent.Text(
                  'A second page inside `NavigationView` shows how Fluent '
                  'navigation swaps page bodies without leaving the module.',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: const <Widget>[
            _FluentMetricCard(
              title: 'Crash-free Sessions',
              value: '99.93%',
              caption: 'InfoBadge-style summary surface',
            ),
            _FluentMetricCard(
              title: 'Review Queue',
              value: '14',
              caption: 'Pending approvals in current ring',
            ),
            _FluentMetricCard(
              title: 'Blocked Checks',
              value: '2',
              caption: 'Use alerts before shipping',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSettingsPage() {
    return fluent.ScaffoldPage.withPadding(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const fluent.PageHeader(title: fluent.Text('Settings')),
          fluent.InfoBar.warning(
            title: const fluent.Text('Compact pane preview'),
            content: fluent.Text(
              _compactPane
                  ? 'Compact mode is enabled, so the navigation pane shows icons only.'
                  : 'Switch to compact mode from the card above to preview adaptive navigation.',
            ),
          ),
          const SizedBox(height: 20),
          const fluent.Text(
            'The outer page remains Material while the preview subtree is themed with Fluent widgets only.',
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('fluent_ui Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Use Windows-style controls in Flutter with a local themed subtree.',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'This module demonstrates `FluentTheme`, `NavigationView`, '
                      '`NavigationPane`, `PaneItem`, `InfoBar`, `ContentDialog`, '
                      '`TextBox`, `AutoSuggestBox`, `ComboBox`, `ToggleSwitch`, '
                      '`Button`, `FilledButton`, `ProgressBar`, `ProgressRing`, '
                      'and `Acrylic` without replacing the app root.',
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: <Widget>[
                        FilterChip(
                          label: const Text('Compact Pane'),
                          selected: _compactPane,
                          onSelected: (bool value) {
                            setState(() => _compactPane = value);
                            _logEvent('Pane display mode compact = $value');
                          },
                        ),
                        Chip(label: Text('Current pane: $_selectedPaneIndex')),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Status: $_status',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              clipBehavior: Clip.antiAlias,
              child: SizedBox(
                height: 760,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A).withValues(alpha: 0.04),
                  ),
                  child: fluent.FluentTheme(
                    data: fluent.FluentThemeData(
                      accentColor: fluent.Colors.blue,
                      brightness: Brightness.light,
                    ),
                    child: fluent.NavigationView(
                      pane: fluent.NavigationPane(
                        selected: _selectedPaneIndex,
                        displayMode: _compactPane
                            ? fluent.PaneDisplayMode.compact
                            : fluent.PaneDisplayMode.expanded,
                        onChanged: (int index) {
                          setState(() => _selectedPaneIndex = index);
                          _logEvent('NavigationPane changed to tab $index');
                        },
                        header: const Padding(
                          padding: EdgeInsetsDirectional.only(start: 12),
                          child: fluent.Text(
                            'Contoso Console',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                        items: <fluent.NavigationPaneItem>[
                          fluent.PaneItem(
                            icon: const fluent.Icon(fluent.FluentIcons.home),
                            title: const fluent.Text('Overview'),
                            body: Builder(
                              builder: (BuildContext context) {
                                return _buildOverviewPage(context);
                              },
                            ),
                          ),
                          fluent.PaneItem(
                            icon: const fluent.Icon(fluent.FluentIcons.chart),
                            title: const fluent.Text('Insights'),
                            body: _buildInsightsPage(),
                          ),
                          fluent.PaneItem(
                            icon: const fluent.Icon(
                              fluent.FluentIcons.settings,
                            ),
                            title: const fluent.Text('Settings'),
                            body: _buildSettingsPage(),
                          ),
                        ],
                        footerItems: <fluent.NavigationPaneItem>[
                          fluent.PaneItemAction(
                            icon: const fluent.Icon(fluent.FluentIcons.share),
                            title: const fluent.Text('Log Event'),
                            onTap: () {
                              _logEvent('Tapped footer PaneItemAction');
                              setState(() {
                                _status =
                                    'Triggered a footer action inside NavigationPane.';
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _CodeCard(
              title: 'Core fluent_ui Pattern',
              code: '''
FluentTheme(
  data: FluentThemeData(
    accentColor: Colors.blue,
    brightness: Brightness.light,
  ),
  child: NavigationView(
    pane: NavigationPane(
      selected: selectedIndex,
      onChanged: (index) => setState(() => selectedIndex = index),
      items: [
        PaneItem(
          icon: const Icon(FluentIcons.home),
          title: const Text('Overview'),
          body: ScaffoldPage(
            header: const PageHeader(title: Text('Overview')),
            content: const SizedBox.expand(),
          ),
        ),
      ],
    ),
  ),
)
''',
            ),
            const SizedBox(height: 16),
            _EventLogCard(
              entries: _eventLog,
              emptyLabel: 'No Fluent interactions recorded yet.',
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

class _FluentMetricCard extends StatelessWidget {
  const _FluentMetricCard({
    required this.title,
    required this.value,
    required this.caption,
  });

  final String title;
  final String value;
  final String caption;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 210,
      child: fluent.Card(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              fluent.Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              fluent.Text(
                value,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              fluent.Text(caption),
            ],
          ),
        ),
      ),
    );
  }
}

class _CodeCard extends StatelessWidget {
  const _CodeCard({required this.title, required this.code});

  final String title;
  final String code;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
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
                color: Colors.black.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                code,
                style: const TextStyle(fontFamily: 'monospace', height: 1.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EventLogCard extends StatelessWidget {
  const _EventLogCard({required this.entries, required this.emptyLabel});

  final List<String> entries;
  final String emptyLabel;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Event Log',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            if (entries.isEmpty)
              Text(emptyLabel)
            else
              ...entries.map(
                (String entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(entry),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
