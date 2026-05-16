import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart' as cupertino;
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart' as macos;
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';

@RoutePage(name: RouteName.macosUi)
class MacosUiPage extends StatefulWidget {
  const MacosUiPage({super.key});

  @override
  State<MacosUiPage> createState() => _MacosUiPageState();
}

class _MacosUiPageState extends State<MacosUiPage> {
  static const List<String> _exportFormats = <String>[
    'Release Notes',
    'Design Review',
    'Stakeholder Summary',
  ];

  int _pageIndex = 0;
  bool _notificationsEnabled = true;
  bool _rememberChoice = false;
  String _exportFormat = 'Release Notes';
  String _status =
      'The preview window embeds `MacosTheme`, `MacosWindow`, `Sidebar`, and `MacosScaffold`.';
  List<String> _eventLog = <String>[];

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

  Future<void> _showAlertDialog(BuildContext context) async {
    await macos.showMacosAlertDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return macos.MacosAlertDialog(
          appIcon: const FlutterLogo(size: 56),
          title: const Text('Export Snapshot'),
          message: Text(
            'Export the current "$_exportFormat" package from the macOS-styled preview.',
            textAlign: TextAlign.center,
          ),
          primaryButton: macos.PushButton(
            controlSize: macos.ControlSize.large,
            onPressed: () {
              Navigator.of(context).pop();
              _logEvent('Confirmed MacosAlertDialog export');
              setState(() {
                _status = 'Exported the $_exportFormat package.';
              });
            },
            child: const Text('Export'),
          ),
          secondaryButton: macos.PushButton(
            controlSize: macos.ControlSize.large,
            secondary: true,
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          suppress: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              macos.MacosCheckbox(
                value: _rememberChoice,
                onChanged: (bool? value) {
                  setState(() => _rememberChoice = value ?? false);
                },
              ),
              const SizedBox(width: 8),
              const Text('Remember this choice'),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showSheet(BuildContext context) async {
    await macos.showMacosSheet<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return macos.MacosSheet(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const FlutterLogo(size: 52),
                const SizedBox(height: 20),
                Text(
                  'macos_ui Sheet',
                  style: macos.MacosTheme.of(
                    context,
                  ).typography.largeTitle.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                const macos.MacosListTile(
                  leading: macos.MacosIcon(cupertino.CupertinoIcons.sparkles),
                  title: Text('Native looking desktop surfaces'),
                  subtitle: Text(
                    'Use sheets for richer flows that should slide over your content.',
                  ),
                ),
                const SizedBox(height: 16),
                macos.PushButton(
                  controlSize: macos.ControlSize.regular,
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close Sheet'),
                ),
              ],
            ),
          ),
        );
      },
    );
    _logEvent('Opened MacosSheet');
  }

  Widget _buildOverviewContent(BuildContext context) {
    return SingleChildScrollView(
      controller: ScrollController(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Buttons, toggles, popup menus, and list tiles',
            style: macos.MacosTheme.of(
              context,
            ).typography.title1.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: <Widget>[
              macos.PushButton(
                controlSize: macos.ControlSize.regular,
                onPressed: () => _showAlertDialog(context),
                child: const Text('Show Alert'),
              ),
              macos.PushButton(
                controlSize: macos.ControlSize.regular,
                secondary: true,
                onPressed: () => _showSheet(context),
                child: const Text('Show Sheet'),
              ),
              macos.MacosPulldownButton(
                title: 'Actions',
                items: <macos.MacosPulldownMenuEntry>[
                  macos.MacosPulldownMenuItem(
                    title: const Text('Pin workspace'),
                    onTap: () {
                      _logEvent('Pulldown selected Pin workspace');
                      setState(() {
                        _status =
                            'Pinned the workspace from MacosPulldownButton.';
                      });
                    },
                  ),
                  macos.MacosPulldownMenuItem(
                    title: const Text('Share review link'),
                    onTap: () {
                      _logEvent('Pulldown selected Share review link');
                    },
                  ),
                  const macos.MacosPulldownMenuDivider(),
                  macos.MacosPulldownMenuItem(
                    title: const Text('Archive draft'),
                    onTap: () {
                      _logEvent('Pulldown selected Archive draft');
                    },
                  ),
                ],
              ),
              macos.MacosPopupButton<String>(
                value: _exportFormat,
                onChanged: (String? value) {
                  if (value == null) {
                    return;
                  }
                  setState(() {
                    _exportFormat = value;
                    _status = 'Changed MacosPopupButton value to "$value".';
                  });
                  _logEvent('PopupButton changed to $value');
                },
                items: _exportFormats
                    .map<macos.MacosPopupMenuItem<String>>(
                      (String value) => macos.MacosPopupMenuItem<String>(
                        value: value,
                        child: Text(value),
                      ),
                    )
                    .toList(growable: false),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    macos.MacosSwitch(
                      value: _notificationsEnabled,
                      onChanged: (bool value) {
                        setState(() {
                          _notificationsEnabled = value;
                          _status =
                              'Notifications are now ${value ? 'enabled' : 'disabled'}.';
                        });
                        _logEvent('MacosSwitch notifications = $value');
                      },
                    ),
                    const SizedBox(width: 10),
                    const Text('Enable sidebar notifications'),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: <Widget>[
                    macos.MacosCheckbox(
                      value: _rememberChoice,
                      onChanged: (bool? value) {
                        final bool nextValue = value ?? false;
                        setState(() {
                          _rememberChoice = nextValue;
                          _status =
                              'MacosCheckbox remember choice = $nextValue.';
                        });
                        _logEvent('MacosCheckbox remember choice = $nextValue');
                      },
                    ),
                    const SizedBox(width: 10),
                    const Text('Remember export preferences'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const macos.MacosListTile(
            leading: macos.MacosIcon(cupertino.CupertinoIcons.doc_text),
            title: Text('Release draft'),
            subtitle: Text(
              'MacosListTile is useful for settings, file rows, and sidebar summaries.',
            ),
          ),
          const SizedBox(height: 12),
          const macos.MacosListTile(
            leading: macos.MacosIcon(cupertino.CupertinoIcons.person_2),
            title: Text('Reviewer access'),
            subtitle: Text(
              'Pair list tiles with buttons and dialogs for desktop workflows.',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogsContent(BuildContext context) {
    return SingleChildScrollView(
      controller: ScrollController(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Dialogs and sheets',
            style: macos.MacosTheme.of(
              context,
            ).typography.title1.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          const Text(
            'macos_ui provides both `showMacosAlertDialog` and `showMacosSheet` for desktop-friendly modal flows.',
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: <Widget>[
              macos.PushButton(
                controlSize: macos.ControlSize.regular,
                onPressed: () => _showAlertDialog(context),
                child: const Text('Preview Alert Dialog'),
              ),
              macos.PushButton(
                controlSize: macos.ControlSize.regular,
                secondary: true,
                onPressed: () => _showSheet(context),
                child: const Text('Preview Sheet'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarContent(BuildContext context) {
    return SingleChildScrollView(
      controller: ScrollController(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Sidebar navigation',
            style: macos.MacosTheme.of(
              context,
            ).typography.title1.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          Text(
            'Current sidebar index: $_pageIndex',
            style: macos.MacosTheme.of(context).typography.body,
          ),
          const SizedBox(height: 16),
          const Text(
            'The preview window uses `MacosWindow`, `Sidebar`, `SidebarItems`, `ToolBar`, and `ContentArea` to emulate a macOS desktop layout inside this module page.',
          ),
        ],
      ),
    );
  }

  Widget _buildWindowContent(BuildContext context) {
    switch (_pageIndex) {
      case 1:
        return _buildDialogsContent(context);
      case 2:
        return _buildSidebarContent(context);
      case 0:
      default:
        return _buildOverviewContent(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('macos_ui Module')),
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
                      'Preview macOS-style navigation and desktop controls in a contained window.',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'This module demonstrates `MacosTheme`, `MacosWindow`, '
                      '`Sidebar`, `SidebarItems`, `MacosScaffold`, `ToolBar`, '
                      '`ContentArea`, `PushButton`, `MacosSwitch`, '
                      '`MacosCheckbox`, `MacosPulldownButton`, '
                      '`MacosPopupButton`, `MacosListTile`, '
                      '`showMacosAlertDialog`, and `showMacosSheet`.',
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: <Widget>[
                        Chip(label: Text('Sidebar page: $_pageIndex')),
                        Chip(label: Text(_status)),
                      ],
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
                child: macos.MacosTheme(
                  data: macos.MacosThemeData.light(
                    accentColor: macos.AccentColor.blue,
                  ),
                  child: macos.MacosWindow(
                    sidebar: macos.Sidebar(
                      minWidth: 220,
                      startWidth: 240,
                      top: const Padding(
                        padding: EdgeInsets.fromLTRB(16, 14, 16, 10),
                        child: Text(
                          'Widget Gallery',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                      builder:
                          (
                            BuildContext context,
                            ScrollController scrollController,
                          ) {
                            return macos.SidebarItems(
                              currentIndex: _pageIndex,
                              onChanged: (int index) {
                                setState(() => _pageIndex = index);
                                _logEvent('Sidebar changed to $index');
                              },
                              scrollController: scrollController,
                              itemSize: macos.SidebarItemSize.large,
                              items: const <macos.SidebarItem>[
                                macos.SidebarItem(
                                  leading: macos.MacosIcon(
                                    cupertino.CupertinoIcons.rectangle_grid_2x2,
                                  ),
                                  label: Text('Overview'),
                                ),
                                macos.SidebarItem(
                                  leading: macos.MacosIcon(
                                    cupertino.CupertinoIcons.square_on_square,
                                  ),
                                  label: Text('Dialogs'),
                                ),
                                macos.SidebarItem(
                                  leading: macos.MacosIcon(
                                    cupertino.CupertinoIcons.sidebar_left,
                                  ),
                                  label: Text('Sidebar'),
                                ),
                              ],
                            );
                          },
                    ),
                    child: macos.MacosScaffold(
                      toolBar: const macos.ToolBar(
                        title: Text('macos_ui Preview'),
                        titleWidth: 180,
                      ),
                      children: <Widget>[
                        macos.ContentArea(
                          builder:
                              (
                                BuildContext context,
                                ScrollController scrollController,
                              ) {
                                return SingleChildScrollView(
                                  controller: scrollController,
                                  child: _buildWindowContent(context),
                                );
                              },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _CodeCard(
              title: 'Core macos_ui Pattern',
              code: '''
MacosTheme(
  data: MacosThemeData.light(),
  child: MacosWindow(
    sidebar: Sidebar(
      minWidth: 220,
      builder: (context, controller) {
        return SidebarItems(
          currentIndex: pageIndex,
          onChanged: (index) => setState(() => pageIndex = index),
          scrollController: controller,
          items: const [
            SidebarItem(label: Text('Overview')),
          ],
        );
      },
    ),
    child: MacosScaffold(
      toolBar: const ToolBar(title: Text('Preview')),
      children: [
        ContentArea(
          builder: (context, scrollController) => SingleChildScrollView(
            controller: scrollController,
            child: const SizedBox.expand(),
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
              emptyLabel: 'No macOS interactions recorded yet.',
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
