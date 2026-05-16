import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';

enum _SliderDrawerPreset { inbox, analytics, profile, settings }

@RoutePage(name: RouteName.flutterSliderDrawer)
class FlutterSliderDrawerPage extends StatefulWidget {
  const FlutterSliderDrawerPage({super.key});

  @override
  State<FlutterSliderDrawerPage> createState() =>
      _FlutterSliderDrawerPageState();
}

class _FlutterSliderDrawerPageState extends State<FlutterSliderDrawerPage> {
  final GlobalKey<SliderDrawerState> _sliderDrawerKey =
      GlobalKey<SliderDrawerState>();

  _SliderDrawerPreset _selectedPreset = _SliderDrawerPreset.inbox;
  SlideDirection _slideDirection = SlideDirection.leftToRight;
  bool _isDraggable = true;
  bool _showShadow = true;

  void _selectPreset(_SliderDrawerPreset preset) {
    setState(() {
      _selectedPreset = preset;
    });
    _sliderDrawerKey.currentState?.closeSlider();
  }

  void _toggleDrawer() {
    _sliderDrawerKey.currentState?.toggle();
  }

  void _openDrawer() {
    _sliderDrawerKey.currentState?.openSlider();
  }

  void _closeDrawer() {
    _sliderDrawerKey.currentState?.closeSlider();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: SliderDrawer(
          key: _sliderDrawerKey,
          slideDirection: _slideDirection,
          isDraggable: _isDraggable,
          sliderOpenSize: _slideDirection == SlideDirection.topToBottom
              ? 300
              : 272,
          backgroundColor: colorScheme.surface,
          sliderBoxShadow: _showShadow
              ? SliderBoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.22),
                  blurRadius: 20,
                  spreadRadius: 6,
                )
              : null,
          appBar: SliderAppBar(
            config: SliderAppBarConfig(
              backgroundColor: colorScheme.surface,
              drawerIconColor: colorScheme.onSurface,
              title: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'flutter_slider_drawer',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    _directionLabel(_slideDirection),
                    textAlign: TextAlign.center,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              trailing: IconButton(
                tooltip: 'Toggle drawer',
                onPressed: _toggleDrawer,
                icon: const Icon(Icons.tune),
              ),
            ),
          ),
          slider: _DrawerPanel(
            selectedPreset: _selectedPreset,
            onPresetSelected: _selectPreset,
            slideDirection: _slideDirection,
          ),
          child: _DrawerShowcaseBody(
            selectedPreset: _selectedPreset,
            slideDirection: _slideDirection,
            isDraggable: _isDraggable,
            showShadow: _showShadow,
            onDirectionChanged: (SlideDirection direction) {
              setState(() {
                _slideDirection = direction;
              });
            },
            onDraggableChanged: (bool value) {
              setState(() {
                _isDraggable = value;
              });
            },
            onShadowChanged: (bool value) {
              setState(() {
                _showShadow = value;
              });
            },
            onOpenPressed: _openDrawer,
            onClosePressed: _closeDrawer,
            onTogglePressed: _toggleDrawer,
          ),
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

class _DrawerPanel extends StatelessWidget {
  const _DrawerPanel({
    required this.selectedPreset,
    required this.onPresetSelected,
    required this.slideDirection,
  });

  final _SliderDrawerPreset selectedPreset;
  final ValueChanged<_SliderDrawerPreset> onPresetSelected;
  final SlideDirection slideDirection;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final bool reverseHeader = slideDirection == SlideDirection.rightToLeft;

    return Material(
      color: Color.lerp(
        colorScheme.primaryContainer,
        colorScheme.surface,
        0.35,
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
          children: <Widget>[
            Row(
              textDirection: reverseHeader
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              children: <Widget>[
                CircleAvatar(
                  radius: 24,
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  child: const Icon(Icons.space_dashboard_outlined),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: reverseHeader
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Drawer Surface',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'This panel stays behind the main page and slides into view.',
                        textAlign: reverseHeader
                            ? TextAlign.right
                            : TextAlign.left,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ..._SliderDrawerPreset.values.map(
              (_SliderDrawerPreset preset) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  selected: selectedPreset == preset,
                  leading: Icon(_presetIcon(preset)),
                  title: Text(_presetTitle(preset)),
                  subtitle: Text(_presetSubtitle(preset)),
                  trailing: selectedPreset == preset
                      ? const Icon(Icons.check_circle)
                      : const Icon(Icons.chevron_right),
                  onTap: () => onPresetSelected(preset),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              color: colorScheme.surface.withValues(alpha: 0.78),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Best for dashboards, side navigation, contextual tools, and branded menu reveals.',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerShowcaseBody extends StatelessWidget {
  const _DrawerShowcaseBody({
    required this.selectedPreset,
    required this.slideDirection,
    required this.isDraggable,
    required this.showShadow,
    required this.onDirectionChanged,
    required this.onDraggableChanged,
    required this.onShadowChanged,
    required this.onOpenPressed,
    required this.onClosePressed,
    required this.onTogglePressed,
  });

  final _SliderDrawerPreset selectedPreset;
  final SlideDirection slideDirection;
  final bool isDraggable;
  final bool showShadow;
  final ValueChanged<SlideDirection> onDirectionChanged;
  final ValueChanged<bool> onDraggableChanged;
  final ValueChanged<bool> onShadowChanged;
  final VoidCallback onOpenPressed;
  final VoidCallback onClosePressed;
  final VoidCallback onTogglePressed;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return SelectionArea(
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: LinearGradient(
                colors: <Color>[
                  colorScheme.primaryContainer,
                  colorScheme.secondaryContainer,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'What flutter_slider_drawer does',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'It keeps a menu panel underneath the main page, then translates the page to reveal that panel with a drawer-style animation.',
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: const <Widget>[
                    _FeatureChip(label: 'Left / Right / Top directions'),
                    _FeatureChip(label: 'Drag to open'),
                    _FeatureChip(label: 'Animated menu icon'),
                    _FeatureChip(label: 'Programmable open / close'),
                    _FeatureChip(label: 'Optional child shadow'),
                  ],
                ),
              ],
            ),
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
                    'Interactive Controls',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Change the slide direction, toggle drag support, and control the drawer from code.',
                  ),
                  const SizedBox(height: 16),
                  SegmentedButton<SlideDirection>(
                    segments: <ButtonSegment<SlideDirection>>[
                      const ButtonSegment<SlideDirection>(
                        value: SlideDirection.leftToRight,
                        label: Text('Left'),
                        icon: Icon(Icons.keyboard_tab),
                      ),
                      ButtonSegment<SlideDirection>(
                        value: SlideDirection.rightToLeft,
                        label: Text('Right'),
                        icon: Icon(Icons.keyboard_backspace),
                      ),
                      const ButtonSegment<SlideDirection>(
                        value: SlideDirection.topToBottom,
                        label: Text('Top'),
                        icon: Icon(Icons.vertical_align_top),
                      ),
                    ],
                    selected: <SlideDirection>{slideDirection},
                    onSelectionChanged: (Set<SlideDirection> selection) {
                      onDirectionChanged(selection.first);
                    },
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Allow swipe / drag gestures'),
                    subtitle: const Text(
                      'Disable this to show button-only control.',
                    ),
                    value: isDraggable,
                    onChanged: onDraggableChanged,
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Show shadow under the main page'),
                    subtitle: const Text(
                      'This makes the drawer reveal more obvious.',
                    ),
                    value: showShadow,
                    onChanged: onShadowChanged,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: <Widget>[
                      FilledButton.icon(
                        onPressed: onOpenPressed,
                        icon: const Icon(Icons.menu_open),
                        label: const Text('Open Drawer'),
                      ),
                      OutlinedButton.icon(
                        onPressed: onTogglePressed,
                        icon: const Icon(Icons.swap_horiz),
                        label: const Text('Toggle'),
                      ),
                      TextButton.icon(
                        onPressed: onClosePressed,
                        icon: const Icon(Icons.close),
                        label: const Text('Close'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          _PresetPreviewCard(
            preset: selectedPreset,
            slideDirection: slideDirection,
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
                    'Why use this package',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _BenefitRow(
                    icon: Icons.dashboard_customize_outlined,
                    text:
                        'It feels more like a reveal animation than a standard Material Drawer.',
                  ),
                  const SizedBox(height: 10),
                  _BenefitRow(
                    icon: Icons.touch_app_outlined,
                    text:
                        'It gives you direct state control with `openSlider()`, `closeSlider()`, and `toggle()`.',
                  ),
                  const SizedBox(height: 10),
                  _BenefitRow(
                    icon: Icons.swap_calls_outlined,
                    text:
                        'It supports left-to-right, right-to-left, and top-to-bottom slide patterns.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PresetPreviewCard extends StatelessWidget {
  const _PresetPreviewCard({
    required this.preset,
    required this.slideDirection,
  });

  final _SliderDrawerPreset preset;
  final SlideDirection slideDirection;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              _presetTitle(preset),
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _presetSubtitle(preset),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: _presetAccent(preset).withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: _presetAccent(preset).withValues(alpha: 0.24),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(_presetIcon(preset), color: _presetAccent(preset)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Current drawer content preset',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(_presetDescription(preset)),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: <Widget>[
                      _InfoPill(
                        label: 'Direction: ${_directionLabel(slideDirection)}',
                      ),
                      _InfoPill(label: 'Use case: ${_presetUseCase(preset)}'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureChip extends StatelessWidget {
  const _FeatureChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(label: Text(label));
  }
}

class _BenefitRow extends StatelessWidget {
  const _BenefitRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Icon(icon, size: 20),
        ),
        const SizedBox(width: 10),
        Expanded(child: Text(text)),
      ],
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label, style: theme.textTheme.labelLarge),
    );
  }
}

String _directionLabel(SlideDirection direction) {
  return switch (direction) {
    SlideDirection.leftToRight => 'Left to right',
    SlideDirection.rightToLeft => 'Right to left',
    SlideDirection.topToBottom => 'Top to bottom',
  };
}

String _presetTitle(_SliderDrawerPreset preset) {
  return switch (preset) {
    _SliderDrawerPreset.inbox => 'Inbox Workspace',
    _SliderDrawerPreset.analytics => 'Analytics Snapshot',
    _SliderDrawerPreset.profile => 'Profile Center',
    _SliderDrawerPreset.settings => 'Settings Console',
  };
}

String _presetSubtitle(_SliderDrawerPreset preset) {
  return switch (preset) {
    _SliderDrawerPreset.inbox =>
      'Navigation-focused drawer with unread context.',
    _SliderDrawerPreset.analytics =>
      'Quick KPI overview hidden behind the page.',
    _SliderDrawerPreset.profile =>
      'Identity and shortcuts in a branded side panel.',
    _SliderDrawerPreset.settings =>
      'Dense utility actions grouped in one reveal.',
  };
}

String _presetDescription(_SliderDrawerPreset preset) {
  return switch (preset) {
    _SliderDrawerPreset.inbox =>
      'Use the drawer as a workspace switcher. The main page stays visible, so the menu feels lighter than a full route transition.',
    _SliderDrawerPreset.analytics =>
      'Use it for secondary insights. Teams often reveal charts, filters, or KPI tiles without leaving the active task screen.',
    _SliderDrawerPreset.profile =>
      'Use it for account context, plan details, shortcuts, and personal actions that do not need to dominate the main content.',
    _SliderDrawerPreset.settings =>
      'Use it for dense preference groups, admin switches, and rarely used actions that should stay nearby but hidden by default.',
  };
}

String _presetUseCase(_SliderDrawerPreset preset) {
  return switch (preset) {
    _SliderDrawerPreset.inbox => 'navigation',
    _SliderDrawerPreset.analytics => 'insights',
    _SliderDrawerPreset.profile => 'account',
    _SliderDrawerPreset.settings => 'tools',
  };
}

IconData _presetIcon(_SliderDrawerPreset preset) {
  return switch (preset) {
    _SliderDrawerPreset.inbox => Icons.inbox_outlined,
    _SliderDrawerPreset.analytics => Icons.insights_outlined,
    _SliderDrawerPreset.profile => Icons.person_outline,
    _SliderDrawerPreset.settings => Icons.tune_outlined,
  };
}

Color _presetAccent(_SliderDrawerPreset preset) {
  return switch (preset) {
    _SliderDrawerPreset.inbox => const Color(0xFF1E88E5),
    _SliderDrawerPreset.analytics => const Color(0xFF00897B),
    _SliderDrawerPreset.profile => const Color(0xFF8E24AA),
    _SliderDrawerPreset.settings => const Color(0xFFEF6C00),
  };
}
