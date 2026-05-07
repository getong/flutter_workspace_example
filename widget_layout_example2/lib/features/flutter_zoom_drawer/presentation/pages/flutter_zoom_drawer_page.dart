import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:widget_layout_example2/app_navigation.dart';

enum _ZoomDestination { dashboard, reports, workspace, profile }

@RoutePage(name: RouteName.flutterZoomDrawer)
class FlutterZoomDrawerPage extends StatefulWidget {
  const FlutterZoomDrawerPage({super.key});

  @override
  State<FlutterZoomDrawerPage> createState() => _FlutterZoomDrawerPageState();
}

class _FlutterZoomDrawerPageState extends State<FlutterZoomDrawerPage> {
  final ZoomDrawerController _controller = ZoomDrawerController();

  _ZoomDestination _selectedDestination = _ZoomDestination.dashboard;
  DrawerStyle _drawerStyle = DrawerStyle.defaultStyle;
  bool _showShadow = true;
  bool _isRtl = false;
  bool _disableDragGesture = false;
  bool _mainScreenTapClose = true;
  double _angle = -12;
  double _borderRadius = 28;
  double _mainScreenScale = 0.24;
  double _slideWidthFactor = 0.72;

  void _selectDestination(_ZoomDestination destination) {
    setState(() {
      _selectedDestination = destination;
    });
    _controller.close?.call();
  }

  double _resolveSlideWidth(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    return (screenWidth * _slideWidthFactor).clamp(240.0, 420.0);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: ZoomDrawer(
          controller: _controller,
          style: _drawerStyle,
          showShadow: _showShadow,
          isRtl: _isRtl,
          disableDragGesture: _disableDragGesture,
          mainScreenTapClose: _mainScreenTapClose,
          borderRadius: _borderRadius,
          angle: _angle,
          mainScreenScale: _mainScreenScale,
          slideWidth: _resolveSlideWidth(context),
          openCurve: Curves.easeOutCubic,
          closeCurve: Curves.easeInOutCubic,
          duration: const Duration(milliseconds: 320),
          menuBackgroundColor: colorScheme.primaryContainer,
          drawerShadowsBackgroundColor: colorScheme.shadow.withValues(
            alpha: 0.12,
          ),
          mainScreenOverlayColor: colorScheme.scrim.withValues(alpha: 0.08),
          menuScreen: _ZoomMenuScreen(
            selectedDestination: _selectedDestination,
            onDestinationSelected: _selectDestination,
            isRtl: _isRtl,
          ),
          mainScreen: _ZoomMainScreen(
            selectedDestination: _selectedDestination,
            drawerStyle: _drawerStyle,
            isRtl: _isRtl,
            showShadow: _showShadow,
            disableDragGesture: _disableDragGesture,
            mainScreenTapClose: _mainScreenTapClose,
            angle: _angle,
            borderRadius: _borderRadius,
            mainScreenScale: _mainScreenScale,
            slideWidthFactor: _slideWidthFactor,
            onTogglePressed: () => _controller.toggle?.call(),
            onOpenPressed: () => _controller.open?.call(),
            onClosePressed: () => _controller.close?.call(),
            onDrawerStyleChanged: (DrawerStyle style) {
              setState(() {
                _drawerStyle = style;
              });
            },
            onRtlChanged: (bool value) {
              setState(() {
                _isRtl = value;
              });
            },
            onShowShadowChanged: (bool value) {
              setState(() {
                _showShadow = value;
              });
            },
            onDisableDragGestureChanged: (bool value) {
              setState(() {
                _disableDragGesture = value;
              });
            },
            onMainScreenTapCloseChanged: (bool value) {
              setState(() {
                _mainScreenTapClose = value;
              });
            },
            onAngleChanged: (double value) {
              setState(() {
                _angle = value;
              });
            },
            onBorderRadiusChanged: (double value) {
              setState(() {
                _borderRadius = value;
              });
            },
            onMainScreenScaleChanged: (double value) {
              setState(() {
                _mainScreenScale = value;
              });
            },
            onSlideWidthFactorChanged: (double value) {
              setState(() {
                _slideWidthFactor = value;
              });
            },
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

class _ZoomMenuScreen extends StatelessWidget {
  const _ZoomMenuScreen({
    required this.selectedDestination,
    required this.onDestinationSelected,
    required this.isRtl,
  });

  final _ZoomDestination selectedDestination;
  final ValueChanged<_ZoomDestination> onDestinationSelected;
  final bool isRtl;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Material(
        color: colorScheme.primaryContainer,
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
            children: <Widget>[
              Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    child: const Icon(Icons.auto_graph),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Zoom Menu',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'The menu stays underneath while the main page translates, scales, and can rotate.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ..._ZoomDestination.values.map(
                (_ZoomDestination destination) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    selected: selectedDestination == destination,
                    selectedTileColor: colorScheme.surface.withValues(
                      alpha: 0.66,
                    ),
                    leading: Icon(_destinationIcon(destination)),
                    title: Text(_destinationTitle(destination)),
                    subtitle: Text(_destinationSubtitle(destination)),
                    trailing: selectedDestination == destination
                        ? const Icon(Icons.check_circle)
                        : const Icon(Icons.chevron_right),
                    onTap: () => onDestinationSelected(destination),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Compared with a plain drawer, flutter_zoom_drawer makes the reveal effect much more theatrical by animating the main surface itself.',
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ZoomMainScreen extends StatelessWidget {
  const _ZoomMainScreen({
    required this.selectedDestination,
    required this.drawerStyle,
    required this.isRtl,
    required this.showShadow,
    required this.disableDragGesture,
    required this.mainScreenTapClose,
    required this.angle,
    required this.borderRadius,
    required this.mainScreenScale,
    required this.slideWidthFactor,
    required this.onTogglePressed,
    required this.onOpenPressed,
    required this.onClosePressed,
    required this.onDrawerStyleChanged,
    required this.onRtlChanged,
    required this.onShowShadowChanged,
    required this.onDisableDragGestureChanged,
    required this.onMainScreenTapCloseChanged,
    required this.onAngleChanged,
    required this.onBorderRadiusChanged,
    required this.onMainScreenScaleChanged,
    required this.onSlideWidthFactorChanged,
  });

  final _ZoomDestination selectedDestination;
  final DrawerStyle drawerStyle;
  final bool isRtl;
  final bool showShadow;
  final bool disableDragGesture;
  final bool mainScreenTapClose;
  final double angle;
  final double borderRadius;
  final double mainScreenScale;
  final double slideWidthFactor;
  final VoidCallback onTogglePressed;
  final VoidCallback onOpenPressed;
  final VoidCallback onClosePressed;
  final ValueChanged<DrawerStyle> onDrawerStyleChanged;
  final ValueChanged<bool> onRtlChanged;
  final ValueChanged<bool> onShowShadowChanged;
  final ValueChanged<bool> onDisableDragGestureChanged;
  final ValueChanged<bool> onMainScreenTapCloseChanged;
  final ValueChanged<double> onAngleChanged;
  final ValueChanged<double> onBorderRadiusChanged;
  final ValueChanged<double> onMainScreenScaleChanged;
  final ValueChanged<double> onSlideWidthFactorChanged;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('flutter_zoom_drawer Module'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: onTogglePressed,
        ),
        actions: <Widget>[
          IconButton(
            tooltip: 'Open drawer',
            onPressed: onOpenPressed,
            icon: const Icon(Icons.keyboard_double_arrow_right),
          ),
          IconButton(
            tooltip: 'Close drawer',
            onPressed: onClosePressed,
            icon: const Icon(Icons.close_fullscreen),
          ),
        ],
      ),
      body: SelectionArea(
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
                    colorScheme.tertiaryContainer,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'What flutter_zoom_drawer does',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'It reveals a hidden menu by moving the main screen away, shrinking it, rounding its corners, and optionally rotating it. The effect feels more layered and cinematic than a standard Drawer.',
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: const <Widget>[
                      _ZoomFeatureChip(label: 'Slide + scale + rotate'),
                      _ZoomFeatureChip(label: 'Multiple drawer styles'),
                      _ZoomFeatureChip(label: 'LTR and RTL support'),
                      _ZoomFeatureChip(
                        label: 'Controller open / close / toggle',
                      ),
                      _ZoomFeatureChip(label: 'Optional shadows'),
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
                      'Use these controls, then press the menu button in the AppBar to feel how the animation changes.',
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<DrawerStyle>(
                      initialValue: drawerStyle,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Drawer style',
                      ),
                      items: DrawerStyle.values
                          .map(
                            (DrawerStyle style) =>
                                DropdownMenuItem<DrawerStyle>(
                                  value: style,
                                  child: Text(_drawerStyleLabel(style)),
                                ),
                          )
                          .toList(),
                      onChanged: (DrawerStyle? value) {
                        if (value != null) {
                          onDrawerStyleChanged(value);
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Show drawer shadows'),
                      subtitle: const Text(
                        'Makes the layered zoom effect easier to see.',
                      ),
                      value: showShadow,
                      onChanged: onShowShadowChanged,
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Use RTL layout'),
                      subtitle: const Text(
                        'The drawer opens from the opposite side.',
                      ),
                      value: isRtl,
                      onChanged: onRtlChanged,
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Disable drag gesture'),
                      subtitle: const Text(
                        'Button control only, no swipe-to-open.',
                      ),
                      value: disableDragGesture,
                      onChanged: onDisableDragGestureChanged,
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Tap main screen to close'),
                      subtitle: const Text(
                        'Useful when the drawer behaves like an overlay.',
                      ),
                      value: mainScreenTapClose,
                      onChanged: onMainScreenTapCloseChanged,
                    ),
                    const SizedBox(height: 8),
                    _ZoomSliderRow(
                      label: 'Rotation angle',
                      valueLabel: angle.toStringAsFixed(0),
                      min: -24,
                      max: 0,
                      value: angle,
                      onChanged: onAngleChanged,
                    ),
                    _ZoomSliderRow(
                      label: 'Border radius',
                      valueLabel: borderRadius.toStringAsFixed(0),
                      min: 0,
                      max: 48,
                      value: borderRadius,
                      onChanged: onBorderRadiusChanged,
                    ),
                    _ZoomSliderRow(
                      label: 'Main screen scale',
                      valueLabel: mainScreenScale.toStringAsFixed(2),
                      min: 0.10,
                      max: 0.40,
                      value: mainScreenScale,
                      onChanged: onMainScreenScaleChanged,
                    ),
                    _ZoomSliderRow(
                      label: 'Slide width factor',
                      valueLabel: slideWidthFactor.toStringAsFixed(2),
                      min: 0.55,
                      max: 0.85,
                      value: slideWidthFactor,
                      onChanged: onSlideWidthFactorChanged,
                    ),
                    const SizedBox(height: 10),
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
                          icon: const Icon(Icons.compare_arrows),
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
            _ZoomPreviewCard(
              destination: selectedDestination,
              drawerStyle: drawerStyle,
              showShadow: showShadow,
              angle: angle,
              isRtl: isRtl,
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
                      'When this package is useful',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const _ZoomBenefitRow(
                      icon: Icons.theater_comedy_outlined,
                      text:
                          'When the app should feel more dramatic than a plain Material Drawer.',
                    ),
                    const SizedBox(height: 10),
                    const _ZoomBenefitRow(
                      icon: Icons.dashboard_customize_outlined,
                      text:
                          'When the hidden menu is a branded workspace surface rather than a simple list of routes.',
                    ),
                    const SizedBox(height: 10),
                    const _ZoomBenefitRow(
                      icon: Icons.tune_outlined,
                      text:
                          'When you want a side panel that behaves like a motion-heavy shell around the main page.',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ZoomPreviewCard extends StatelessWidget {
  const _ZoomPreviewCard({
    required this.destination,
    required this.drawerStyle,
    required this.showShadow,
    required this.angle,
    required this.isRtl,
  });

  final _ZoomDestination destination;
  final DrawerStyle drawerStyle;
  final bool showShadow;
  final double angle;
  final bool isRtl;

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
              _destinationTitle(destination),
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _destinationDescription(destination),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: _destinationAccent(destination).withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: _destinationAccent(
                    destination,
                  ).withValues(alpha: 0.24),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(
                        _destinationIcon(destination),
                        color: _destinationAccent(destination),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Current animation recipe',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: <Widget>[
                      _ZoomInfoPill(
                        label: 'Style: ${_drawerStyleLabel(drawerStyle)}',
                      ),
                      _ZoomInfoPill(
                        label: 'Angle: ${angle.toStringAsFixed(0)}°',
                      ),
                      _ZoomInfoPill(
                        label: showShadow ? 'Shadow: on' : 'Shadow: off',
                      ),
                      _ZoomInfoPill(
                        label: isRtl ? 'Direction: RTL' : 'Direction: LTR',
                      ),
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

class _ZoomSliderRow extends StatelessWidget {
  const _ZoomSliderRow({
    required this.label,
    required this.valueLabel,
    required this.min,
    required this.max,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final String valueLabel;
  final double min;
  final double max;
  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(child: Text(label)),
              Text(valueLabel),
            ],
          ),
          Slider(min: min, max: max, value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _ZoomFeatureChip extends StatelessWidget {
  const _ZoomFeatureChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(label: Text(label));
  }
}

class _ZoomBenefitRow extends StatelessWidget {
  const _ZoomBenefitRow({required this.icon, required this.text});

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

class _ZoomInfoPill extends StatelessWidget {
  const _ZoomInfoPill({required this.label});

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

String _drawerStyleLabel(DrawerStyle style) {
  return switch (style) {
    DrawerStyle.defaultStyle => 'defaultStyle',
    DrawerStyle.style1 => 'style1',
    DrawerStyle.style2 => 'style2',
    DrawerStyle.style3 => 'style3',
    DrawerStyle.style4 => 'style4',
  };
}

String _destinationTitle(_ZoomDestination destination) {
  return switch (destination) {
    _ZoomDestination.dashboard => 'Executive Dashboard',
    _ZoomDestination.reports => 'Reports Hub',
    _ZoomDestination.workspace => 'Workspace Switcher',
    _ZoomDestination.profile => 'Profile Center',
  };
}

String _destinationSubtitle(_ZoomDestination destination) {
  return switch (destination) {
    _ZoomDestination.dashboard =>
      'Quick access to KPIs and top-level navigation.',
    _ZoomDestination.reports => 'Jump between insight-heavy sections.',
    _ZoomDestination.workspace => 'Change active product area from one shell.',
    _ZoomDestination.profile =>
      'Account tools, shortcuts, and personal actions.',
  };
}

String _destinationDescription(_ZoomDestination destination) {
  return switch (destination) {
    _ZoomDestination.dashboard =>
      'A zoom drawer works well here because the app shell feels spatial: the dashboard recedes while the navigation layer appears behind it.',
    _ZoomDestination.reports =>
      'Use it when analytics pages need a more premium transition than a flat side sheet or default drawer.',
    _ZoomDestination.workspace =>
      'This is useful for apps with several work areas, where the menu feels like a hidden control deck rather than a one-off panel.',
    _ZoomDestination.profile =>
      'Profile and account surfaces benefit from the extra emphasis because the motion makes that context feel intentionally separate from the main task.',
  };
}

Color _destinationAccent(_ZoomDestination destination) {
  return switch (destination) {
    _ZoomDestination.dashboard => const Color(0xFF1565C0),
    _ZoomDestination.reports => const Color(0xFF00695C),
    _ZoomDestination.workspace => const Color(0xFF6A1B9A),
    _ZoomDestination.profile => const Color(0xFFEF6C00),
  };
}

IconData _destinationIcon(_ZoomDestination destination) {
  return switch (destination) {
    _ZoomDestination.dashboard => Icons.space_dashboard_outlined,
    _ZoomDestination.reports => Icons.bar_chart_outlined,
    _ZoomDestination.workspace => Icons.workspaces_outline,
    _ZoomDestination.profile => Icons.person_outline,
  };
}
