import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:widget_layout_example2/app_navigation.dart';

@RoutePage(name: RouteName.forui)
class ForuiPage extends StatefulWidget {
  const ForuiPage({super.key});

  @override
  State<ForuiPage> createState() => _ForuiPageState();
}

class _ForuiPageState extends State<ForuiPage> {
  static const Map<String, String> _stackItems = <String, String>{
    'Flutter': 'flutter',
    'Dart Frog': 'dart_frog',
    'Serverpod': 'serverpod',
    'Firebase': 'firebase',
  };

  final List<String> _activityLog = <String>[
    'Ready to preview Forui widgets inside the demo app.',
    'Home page link and router registration are part of this module.',
  ];

  bool _darkPreview = false;
  bool _releaseChecklistAccepted = true;
  bool _notificationsEnabled = true;
  int _footerIndex = 0;
  int _tabsIndex = 0;
  String? _selectedStack = 'flutter';
  FPlatformVariant _platform = switch (defaultTargetPlatform) {
    TargetPlatform.android || TargetPlatform.iOS => FPlatformVariant.iOS,
    _ => FPlatformVariant.macOS,
  };
  TextEditingValue _workspaceValue = const TextEditingValue(
    text: 'forui-widget-showcase',
  );
  TextEditingValue _emailValue = const TextEditingValue(
    text: 'design.system@example.dev',
  );
  TextEditingValue _notesValue = const TextEditingValue(
    text:
        'Use FScaffold, FHeader, FTabs, FButton, FBadge, FTextField, FSelect, '
        'FSwitch, FCheckbox, and FBottomNavigationBar together.',
  );
  TextEditingValue _passwordValue = const TextEditingValue(text: 'release-123');

  FThemeData get _previewTheme {
    final FPlatformThemeData palette = _darkPreview
        ? FThemes.blue.dark
        : FThemes.blue.light;
    return _platform.desktop ? palette.desktop : palette.touch;
  }

  void _togglePlatform() {
    setState(() {
      _platform = _platform.desktop
          ? FPlatformVariant.iOS
          : FPlatformVariant.macOS;
    });
    _log(
      _platform.desktop
          ? 'Switched the local preview to desktop platform styling.'
          : 'Switched the local preview to touch platform styling.',
    );
  }

  void _toggleTheme() {
    setState(() => _darkPreview = !_darkPreview);
    _log(
      _darkPreview
          ? 'Enabled the dark Forui preview palette.'
          : 'Returned to the light Forui preview palette.',
    );
  }

  void _log(String message) {
    setState(() {
      _activityLog.insert(0, message);
      if (_activityLog.length > 8) {
        _activityLog.removeLast();
      }
    });
  }

  void _showToast(BuildContext context) {
    showFToast(
      context: context,
      title: const Text('Toast from Forui'),
      description: const Text(
        'This is rendered with `FToaster` and `FToast` inside the local preview.',
      ),
      suffixBuilder: (BuildContext context, FToasterEntry entry) {
        return FButton.icon(
          onPress: entry.dismiss,
          child: const Icon(Icons.close),
        );
      },
      onDismiss: () => _log('Dismissed the preview toast.'),
    );
    _log('Displayed a Forui toast.');
  }

  Future<void> _showDialog(BuildContext context) async {
    await showFDialog<void>(
      context: context,
      builder:
          (
            BuildContext context,
            FDialogStyle style,
            Animation<double> animation,
          ) {
            return FDialog.adaptive(
              style: style,
              animation: animation,
              title: const Text('Ship the Forui module?'),
              body: const Text(
                'This dialog uses `showFDialog` and `FDialog.adaptive` so the '
                'package handles its own transition and layout.',
              ),
              actions: <Widget>[
                FButton(
                  onPress: () => Navigator.of(context).pop(),
                  variant: FButtonVariant.secondary,
                  child: const Text('Not yet'),
                ),
                FButton(
                  onPress: () {
                    Navigator.of(context).pop();
                    _log('Confirmed the preview dialog action.');
                  },
                  child: const Text('Ship it'),
                ),
              ],
            );
          },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData pageTheme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('forui Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            Text(
              'forui is a Flutter component library with its own theme system, scaffold, navigation, form fields, feedback widgets, and data display components.',
              style: pageTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'This module embeds a local Forui preview instead of changing the app-wide Material theme. The preview below demonstrates `FTheme`, `FScaffold`, `FHeader`, `FBadge`, `FCard`, `FAvatar`, `FButton`, `FProgress`, `FTextField`, `FSelect`, `FCheckbox`, `FSwitch`, `FTabs`, `showFDialog`, `FToast`, and `FBottomNavigationBar`.',
              style: pageTheme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            SizedBox(height: 940, child: _buildPreview()),
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

  Widget _buildPreview() {
    final FThemeData previewTheme = _previewTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Theme(
          data: previewTheme.toApproximateMaterialTheme(),
          child: FTheme(
            data: previewTheme,
            platform: _platform,
            child: FToaster(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: previewTheme.colors.background,
                ),
                child: FScaffold(
                  childPad: false,
                  header: FHeader(
                    title: const Text('Forui Preview Surface'),
                    suffixes: <Widget>[
                      FHeaderAction(
                        icon: Icon(
                          _platform.desktop
                              ? Icons.smartphone_outlined
                              : Icons.desktop_windows_outlined,
                        ),
                        onPress: _togglePlatform,
                      ),
                      FHeaderAction(
                        icon: Icon(
                          _darkPreview
                              ? Icons.light_mode_outlined
                              : Icons.dark_mode_outlined,
                        ),
                        onPress: _toggleTheme,
                      ),
                      Builder(
                        builder: (BuildContext context) {
                          return FHeaderAction(
                            icon: const Icon(Icons.notifications_outlined),
                            onPress: () => _showToast(context),
                          );
                        },
                      ),
                    ],
                  ),
                  footer: FBottomNavigationBar(
                    index: _footerIndex,
                    onChange: (int index) {
                      setState(() => _footerIndex = index);
                    },
                    safeAreaBottom: true,
                    children: const <Widget>[
                      FBottomNavigationBarItem(
                        icon: Icon(Icons.space_dashboard_outlined),
                        label: Text('Overview'),
                      ),
                      FBottomNavigationBarItem(
                        icon: Icon(Icons.tune_outlined),
                        label: Text('Inputs'),
                      ),
                      FBottomNavigationBarItem(
                        icon: Icon(Icons.auto_awesome_outlined),
                        label: Text('Feedback'),
                      ),
                    ],
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    child: switch (_footerIndex) {
                      0 => _buildOverviewPanel(),
                      1 => _buildInputsPanel(),
                      _ => _buildFeedbackPanel(),
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewPanel() {
    return SingleChildScrollView(
      key: const ValueKey<String>('overview'),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: <Widget>[
              FBadge(
                child: Text(
                  _platform.desktop ? 'Desktop tokens' : 'Touch tokens',
                ),
              ),
              FBadge(
                variant: FBadgeVariant.secondary,
                child: Text(_darkPreview ? 'Dark mode' : 'Light mode'),
              ),
              FBadge(
                variant: FBadgeVariant.outline,
                child: const Text('Local FTheme'),
              ),
              FBadge(
                variant: FBadgeVariant.destructive,
                child: const Text('Interactive'),
              ),
            ],
          ),
          const SizedBox(height: 18),
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final bool stacked = constraints.maxWidth < 760;
              final List<Widget> cards = <Widget>[
                FCard(
                  title: const Text('Release cockpit'),
                  subtitle: const Text(
                    'Card, avatar, progress, and button variants together.',
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 16),
                      Row(
                        children: <Widget>[
                          FAvatar.raw(
                            size: 52,
                            child: const Text(
                              'UI',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const <Widget>[
                                Text(
                                  'forui-widget-showcase',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'A package demo page with more than one widget per section.',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'Release readiness',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 10),
                      const FProgress(),
                      const SizedBox(height: 18),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: <Widget>[
                          FButton(
                            onPress: () => _log('Pressed the primary action.'),
                            child: const Text('Primary'),
                          ),
                          FButton(
                            onPress: () =>
                                _log('Pressed the secondary action.'),
                            variant: FButtonVariant.secondary,
                            child: const Text('Secondary'),
                          ),
                          FButton(
                            onPress: () => _log('Pressed the outline action.'),
                            variant: FButtonVariant.outline,
                            child: const Text('Outline'),
                          ),
                          FButton(
                            onPress: () =>
                                _log('Pressed the destructive action.'),
                            variant: FButtonVariant.destructive,
                            child: const Text('Destructive'),
                          ),
                          FButton(onPress: null, child: const Text('Disabled')),
                        ],
                      ),
                    ],
                  ),
                ),
                FCard(
                  title: const Text('Quick actions'),
                  subtitle: const Text(
                    'Icon buttons, ghost actions, and event logging.',
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: <Widget>[
                          FButton.icon(
                            onPress: () =>
                                _log('Pressed the icon-only deploy button.'),
                            child: const Icon(Icons.rocket_launch_outlined),
                          ),
                          FButton.icon(
                            onPress: () =>
                                _log('Pressed the icon-only sync button.'),
                            variant: FButtonVariant.secondary,
                            child: const Icon(Icons.sync_outlined),
                          ),
                          FButton(
                            onPress: () => _showDialog(context),
                            variant: FButtonVariant.ghost,
                            child: const Text('Open dialog'),
                          ),
                          Builder(
                            builder: (BuildContext context) {
                              return FButton(
                                onPress: () => _showToast(context),
                                variant: FButtonVariant.outline,
                                child: const Text('Show toast'),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'Recent activity',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 12),
                      ..._activityLog
                          .take(4)
                          .map(
                            (String item) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  const Padding(
                                    padding: EdgeInsets.only(top: 2),
                                    child: Icon(Icons.circle, size: 10),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(child: Text(item)),
                                ],
                              ),
                            ),
                          ),
                    ],
                  ),
                ),
              ];

              if (stacked) {
                return Column(
                  children: <Widget>[
                    cards[0],
                    const SizedBox(height: 16),
                    cards[1],
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(child: cards[0]),
                  const SizedBox(width: 16),
                  Expanded(child: cards[1]),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInputsPanel() {
    return SingleChildScrollView(
      key: const ValueKey<String>('inputs'),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          FCard(
            title: const Text('Form controls'),
            subtitle: const Text(
              'Lifted state with `FTextField`, `FSelect`, and multiline input.',
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 16),
                FTextField(
                  control: FTextFieldControl.lifted(
                    value: _workspaceValue,
                    onChange: (TextEditingValue value) =>
                        setState(() => _workspaceValue = value),
                  ),
                  label: const Text('Workspace name'),
                  hint: 'Enter a package demo slug',
                  description: const Text(
                    'This field uses lifted state so the page can reference the current value.',
                  ),
                  clearable: (TextEditingValue value) => value.text.isNotEmpty,
                ),
                const SizedBox(height: 16),
                FTextField.email(
                  control: FTextFieldControl.lifted(
                    value: _emailValue,
                    onChange: (TextEditingValue value) =>
                        setState(() => _emailValue = value),
                  ),
                  hint: 'team@example.dev',
                  description: const Text(
                    'The email constructor applies email keyboard and autofill defaults.',
                  ),
                ),
                const SizedBox(height: 16),
                FSelect<String>(
                  items: _stackItems,
                  control: FSelectControl.lifted(
                    value: _selectedStack,
                    onChange: (String? value) =>
                        setState(() => _selectedStack = value),
                  ),
                  label: const Text('Primary stack'),
                  hint: 'Choose a stack',
                  description: const Text(
                    'This uses Forui’s popover-backed select field.',
                  ),
                  clearable: true,
                ),
                const SizedBox(height: 16),
                FTextField.multiline(
                  control: FTextFieldControl.lifted(
                    value: _notesValue,
                    onChange: (TextEditingValue value) =>
                        setState(() => _notesValue = value),
                  ),
                  label: const Text('Release notes'),
                  hint: 'Describe what this demo page teaches.',
                  minLines: 4,
                  maxLines: 6,
                  clearable: (TextEditingValue value) => value.text.isNotEmpty,
                ),
                const SizedBox(height: 16),
                FTextField.password(
                  control: FTextFieldControl.lifted(
                    value: _passwordValue,
                    onChange: (TextEditingValue value) =>
                        setState(() => _passwordValue = value),
                  ),
                  label: const Text('Preview token'),
                  description: const Text(
                    'The password helper includes the visibility toggle.',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          FCard(
            title: const Text('Toggles and validation states'),
            subtitle: const Text(
              'Checkboxes and switches stay visually consistent with the same theme tokens.',
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 16),
                FCheckbox(
                  value: _releaseChecklistAccepted,
                  onChange: (bool value) =>
                      setState(() => _releaseChecklistAccepted = value),
                  label: const Text('Release checklist accepted'),
                  description: const Text(
                    'Use this when the user must explicitly confirm a task.',
                  ),
                ),
                const SizedBox(height: 16),
                FSwitch(
                  value: _notificationsEnabled,
                  onChange: (bool value) =>
                      setState(() => _notificationsEnabled = value),
                  label: const Text('Preview notifications'),
                  description: const Text(
                    'Switches are better for immediate on/off settings.',
                  ),
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: <Widget>[
                    FBadge(
                      child: Text(
                        _releaseChecklistAccepted
                            ? 'Checklist ready'
                            : 'Checklist pending',
                      ),
                    ),
                    FBadge(
                      variant: _notificationsEnabled
                          ? FBadgeVariant.secondary
                          : FBadgeVariant.outline,
                      child: Text(
                        _notificationsEnabled
                            ? 'Notifications on'
                            : 'Notifications off',
                      ),
                    ),
                    FBadge(
                      variant: FBadgeVariant.outline,
                      child: Text(
                        _selectedStack == null
                            ? 'No stack selected'
                            : 'Stack: ${_stackItems.entries.firstWhere((MapEntry<String, String> entry) => entry.value == _selectedStack).key}',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackPanel() {
    return SingleChildScrollView(
      key: const ValueKey<String>('feedback'),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          FCard(
            title: const Text('Tabs and contextual summaries'),
            subtitle: const Text(
              'The tab widget can host compact status panels without leaving the page.',
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 16),
                FTabs(
                  control: FTabControl.lifted(
                    index: _tabsIndex,
                    onChange: (int index) => setState(() => _tabsIndex = index),
                  ),
                  children: <FTabEntry>[
                    FTabEntry(
                      label: const Text('Summary'),
                      child: _ForuiPanel(
                        title: 'Current values',
                        body:
                            'Workspace `${_workspaceValue.text}` is configured for '
                            '${_selectedStack == null ? 'no stack yet' : _stackItems.entries.firstWhere((MapEntry<String, String> entry) => entry.value == _selectedStack).key}.',
                      ),
                    ),
                    FTabEntry(
                      label: const Text('Theme'),
                      child: _ForuiPanel(
                        title: 'Preview theme',
                        body:
                            'The embedded Forui surface is using the '
                            '${_darkPreview ? 'dark' : 'light'} palette with '
                            '${_platform.desktop ? 'desktop' : 'touch'} platform variants.',
                      ),
                    ),
                    FTabEntry(
                      label: const Text('Events'),
                      child: _ForuiPanel(
                        title: 'Latest event',
                        body: _activityLog.first,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          FCard(
            title: const Text('Dialogs and toasts'),
            subtitle: const Text(
              'Overlay widgets stay inside the local Forui theme surface.',
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: <Widget>[
                    FButton(
                      onPress: () => _showDialog(context),
                      child: const Text('Open dialog'),
                    ),
                    Builder(
                      builder: (BuildContext context) {
                        return FButton(
                          onPress: () => _showToast(context),
                          variant: FButtonVariant.secondary,
                          child: const Text('Show toast'),
                        );
                      },
                    ),
                    FButton(
                      onPress: () => _log('Pressed the ghost feedback action.'),
                      variant: FButtonVariant.ghost,
                      child: const Text('Ghost action'),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                const Text(
                  'Notes',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                const Text(
                  'The footer uses `FBottomNavigationBar`, the header uses `FHeader` with `FHeaderAction`, and overlays are handled through `showFDialog` plus `FToaster`.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ForuiPanel extends StatelessWidget {
  const _ForuiPanel({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
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
            Text(body),
          ],
        ),
      ),
    );
  }
}
