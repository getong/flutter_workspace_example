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
  int _paginationPage = 2;
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

  String _stackLabel(String? value) {
    if (value == null) {
      return 'No stack selected';
    }

    return _stackItems.entries
        .firstWhere(
          (MapEntry<String, String> entry) => entry.value == value,
          orElse: () => const MapEntry<String, String>('Unknown stack', ''),
        )
        .key;
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
            SizedBox(height: 1280, child: _buildPreview()),
            const SizedBox(height: 24),
            Text(
              'Reference snippets adapted from the upstream Forui `docs_snippets` package. These are meant to be copied as starting points when you need a concrete API shape instead of only a visual preview.',
              style: pageTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            _buildCodeExamplesSection(),
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
                            : 'Stack: ${_stackLabel(_selectedStack)}',
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
                            '${_selectedStack == null ? 'no stack yet' : _stackLabel(_selectedStack)}.',
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
          const SizedBox(height: 16),
          FCard(
            title: const Text('Accordion, pagination, and tooltips'),
            subtitle: const Text(
              'These examples are adapted from the upstream docs snippets and demonstrate common higher-level interaction patterns.',
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 16),
                const Text(
                  'Single-open accordion',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                FAccordion(
                  control: const FAccordionControl.managed(max: 1),
                  children: const <Widget>[
                    FAccordionItem(
                      title: Text('Production information'),
                      child: Text(
                        'Forui components share the same theme tokens, so cards, overlays, inputs, and navigation elements stay visually aligned.',
                      ),
                    ),
                    FAccordionItem(
                      initiallyExpanded: true,
                      title: Text('Shipping details'),
                      child: Text(
                        'The docs repository uses accordion items for compact sections with a controlled maximum number of expanded panels.',
                      ),
                    ),
                    FAccordionItem(
                      title: Text('Return policy'),
                      child: Text(
                        'This is useful when you want dense content without pushing the rest of the page too far down.',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  'Pagination state: page ${_paginationPage + 1} of 8',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                Center(
                  child: FPagination(
                    control: FPaginationControl.lifted(
                      page: _paginationPage,
                      pages: 8,
                      siblings: 1,
                      onChange: (int page) {
                        setState(() => _paginationPage = page);
                        _log(
                          'Moved the pagination example to page ${page + 1}.',
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Grouped tooltips',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                FTooltipGroup(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: <Widget>[
                      FTooltip(
                        tipBuilder:
                            (BuildContext context, FTooltipController _) {
                              return const Text('Bold');
                            },
                        child: FButton.icon(
                          onPress: () => _log('Pressed the bold icon button.'),
                          variant: FButtonVariant.ghost,
                          size: FButtonSizeVariant.sm,
                          child: const Icon(Icons.format_bold_outlined),
                        ),
                      ),
                      FTooltip(
                        tipBuilder:
                            (BuildContext context, FTooltipController _) {
                              return const Text('Italic');
                            },
                        child: FButton.icon(
                          onPress: () =>
                              _log('Pressed the italic icon button.'),
                          variant: FButtonVariant.ghost,
                          size: FButtonSizeVariant.sm,
                          child: const Icon(Icons.format_italic_outlined),
                        ),
                      ),
                      FTooltip(
                        tipBuilder:
                            (BuildContext context, FTooltipController _) {
                              return const Text('Underline');
                            },
                        child: FButton.icon(
                          onPress: () =>
                              _log('Pressed the underline icon button.'),
                          variant: FButtonVariant.ghost,
                          size: FButtonSizeVariant.sm,
                          child: const Icon(Icons.format_underlined_outlined),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeExamplesSection() {
    final List<Widget> cards = <Widget>[
      const _ForuiCodeExampleCard(
        title: 'Button Sizes',
        description:
            'Adapted from `docs_snippets/lib/examples/widgets/button.dart`.',
        code: '''
Row(
  mainAxisSize: MainAxisSize.min,
  spacing: 10,
  children: [
    FButton(
      variant: FButtonVariant.outline,
      size: FButtonSizeVariant.xs,
      onPress: () {},
      child: const Text('xs'),
    ),
    FButton(
      variant: FButtonVariant.outline,
      size: FButtonSizeVariant.sm,
      onPress: () {},
      child: const Text('sm'),
    ),
    FButton(
      variant: FButtonVariant.outline,
      onPress: () {},
      child: const Text('base'),
    ),
    FButton(
      variant: FButtonVariant.outline,
      size: FButtonSizeVariant.lg,
      onPress: () {},
      child: const Text('lg'),
    ),
  ],
)''',
      ),
      const _ForuiCodeExampleCard(
        title: 'Accordion With max: 1',
        description:
            'Adapted from `docs_snippets/lib/examples/widgets/accordion.dart`.',
        code: '''
FAccordion(
  control: const FAccordionControl.managed(max: 1),
  children: const <Widget>[
    FAccordionItem(
      title: Text('Production Information'),
      child: Text('Explain the primary section here.'),
    ),
    FAccordionItem(
      initiallyExpanded: true,
      title: Text('Shipping Details'),
      child: Text('Open one item by default.'),
    ),
    FAccordionItem(
      title: Text('Return Policy'),
      child: Text('Keep dense help text collapsible.'),
    ),
  ],
)''',
      ),
      const _ForuiCodeExampleCard(
        title: 'Pagination With Siblings',
        description:
            'Adapted from `docs_snippets/lib/examples/widgets/pagination.dart`.',
        code: '''
const FPagination(
  control: FPaginationControl.managed(
    pages: 20,
    siblings: 2,
    initial: 9,
  ),
)''',
      ),
      const _ForuiCodeExampleCard(
        title: 'Tooltip Group',
        description:
            'Adapted from `docs_snippets/lib/examples/widgets/tooltip.dart`.',
        code: '''
FTooltipGroup(
  child: Row(
    mainAxisSize: MainAxisSize.min,
    spacing: 2,
    children: [
      FTooltip(
        tipBuilder: (context, _) => const Text('Bold'),
        child: FButton.icon(
          variant: FButtonVariant.ghost,
          size: FButtonSizeVariant.sm,
          onPress: () {},
          child: const Icon(FIcons.bold),
        ),
      ),
      FTooltip(
        tipBuilder: (context, _) => const Text('Italic'),
        child: FButton.icon(
          variant: FButtonVariant.ghost,
          size: FButtonSizeVariant.sm,
          onPress: () {},
          child: const Icon(FIcons.italic),
        ),
      ),
    ],
  ),
)''',
      ),
      const _ForuiCodeExampleCard(
        title: 'Anchored Popover',
        description:
            'Adapted from `docs_snippets/lib/examples/widgets/popover.dart`.',
        code: '''
FPopover(
  popoverAnchor: Alignment.topCenter,
  childAnchor: Alignment.bottomCenter,
  popoverBuilder: (context, _) => const Padding(
    padding: EdgeInsets.all(16),
    child: SizedBox(
      width: 288,
      child: Text('Popover content goes here.'),
    ),
  ),
  builder: (_, controller, _) => FButton(
    variant: FButtonVariant.outline,
    onPress: controller.toggle,
    child: const Text('Open popover'),
  ),
)''',
      ),
      const _ForuiCodeExampleCard(
        title: 'Rich Select Sections',
        description:
            'Adapted from `docs_snippets/lib/examples/widgets/select.dart`.',
        code: '''
FSelect<String>.rich(
  hint: 'Select a timezone',
  format: (String value) => value,
  children: [
    FSelectSection<String>(
      label: const Text('Asia'),
      items: <String, String>{
        'China Standard Time (CST)': 'China Standard Time (CST)',
        'Japan Standard Time (JST)': 'Japan Standard Time (JST)',
      },
    ),
    FSelectItem<String>.item(
      title: const Text('UTC'),
      value: 'UTC',
    ),
  ],
)''',
      ),
    ];

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth < 900) {
          return Column(
            children:
                cards
                    .expand(
                      (Widget card) => <Widget>[
                        card,
                        const SizedBox(height: 16),
                      ],
                    )
                    .toList()
                  ..removeLast(),
          );
        }

        final List<Widget> leftColumn = <Widget>[];
        final List<Widget> rightColumn = <Widget>[];
        for (int index = 0; index < cards.length; index += 1) {
          final Widget card = cards[index];
          final List<Widget> target = index.isEven ? leftColumn : rightColumn;
          if (target.isNotEmpty) {
            target.add(const SizedBox(height: 16));
          }
          target.add(card);
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(child: Column(children: leftColumn)),
            const SizedBox(width: 16),
            Expanded(child: Column(children: rightColumn)),
          ],
        );
      },
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

class _ForuiCodeExampleCard extends StatelessWidget {
  const _ForuiCodeExampleCard({
    required this.title,
    required this.description,
    required this.code,
  });

  final String title;
  final String description;
  final String code;

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
            const SizedBox(height: 12),
            DecoratedBox(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: SelectableText(
                  code,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontFamily: 'monospace',
                    height: 1.45,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
