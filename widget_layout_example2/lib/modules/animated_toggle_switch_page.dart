import 'dart:math' as math;

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

enum _WorkspaceTheme { focus, balanced }

enum _DeliveryStage { queued, building, shipped }

enum _BoardDensity { compact, comfy, roomy }

@RoutePage(name: 'AnimatedToggleSwitchRoute')
class AnimatedToggleSwitchPage extends StatefulWidget {
  const AnimatedToggleSwitchPage({super.key});

  @override
  State<AnimatedToggleSwitchPage> createState() =>
      _AnimatedToggleSwitchPageState();
}

class _AnimatedToggleSwitchPageState extends State<AnimatedToggleSwitchPage> {
  _WorkspaceTheme _workspaceTheme = _WorkspaceTheme.focus;
  _DeliveryStage _deliveryStage = _DeliveryStage.building;
  _BoardDensity? _boardDensity = _BoardDensity.comfy;
  int _qualityPreset = 1;
  int _timelineZoom = 2;
  double _timelinePosition = 2;
  ToggleMode _timelineMode = ToggleMode.none;
  bool _notificationsEnabled = true;
  bool _savingTheme = false;
  PositionListenerInfo<int>? _pendingTimelineInfo;
  bool _timelineUpdateScheduled = false;

  Future<void> _updateWorkspaceTheme(_WorkspaceTheme nextTheme) async {
    setState(() {
      _workspaceTheme = nextTheme;
      _savingTheme = true;
    });
    await Future<void>.delayed(const Duration(milliseconds: 850));
    if (!mounted) {
      return;
    }
    setState(() {
      _savingTheme = false;
    });
  }

  IconData _deliveryIcon(_DeliveryStage stage) {
    switch (stage) {
      case _DeliveryStage.queued:
        return Icons.inventory_2_outlined;
      case _DeliveryStage.building:
        return Icons.precision_manufacturing_outlined;
      case _DeliveryStage.shipped:
        return Icons.local_shipping_outlined;
    }
  }

  Color _deliveryColor(_DeliveryStage stage) {
    switch (stage) {
      case _DeliveryStage.queued:
        return Colors.blueGrey;
      case _DeliveryStage.building:
        return Colors.orange;
      case _DeliveryStage.shipped:
        return Colors.green;
    }
  }

  Color _densityColor(_BoardDensity density) {
    switch (density) {
      case _BoardDensity.compact:
        return Colors.deepPurple;
      case _BoardDensity.comfy:
        return Colors.teal;
      case _BoardDensity.roomy:
        return Colors.deepOrange;
    }
  }

  Color _qualityColor(int value) {
    switch (value) {
      case 0:
        return Colors.indigo;
      case 1:
        return Colors.teal;
      case 2:
        return Colors.deepOrange;
      default:
        return Colors.blueGrey;
    }
  }

  IconData _qualityIcon(int value) {
    switch (value) {
      case 0:
        return Icons.speed_outlined;
      case 1:
        return Icons.auto_awesome_outlined;
      case 2:
        return Icons.high_quality_rounded;
      default:
        return Icons.tune_rounded;
    }
  }

  String _qualityLabel(int value) {
    switch (value) {
      case 0:
        return 'Fast';
      case 1:
        return 'Balanced';
      case 2:
        return 'Cinematic';
      default:
        return 'Unknown';
    }
  }

  Color _zoomColor(int value) {
    switch (value) {
      case 0:
        return Colors.blueGrey;
      case 1:
        return Colors.blue;
      case 2:
        return Colors.purple;
      case 3:
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }

  IconData _zoomIcon(int value) {
    switch (value) {
      case 0:
        return Icons.filter_1_rounded;
      case 1:
        return Icons.filter_2_rounded;
      case 2:
        return Icons.filter_3_rounded;
      case 3:
        return Icons.filter_4_rounded;
      default:
        return Icons.adjust_rounded;
    }
  }

  void _queueTimelineFeedback(PositionListenerInfo<int> info) {
    final bool unchanged =
        _timelinePosition == info.position &&
        _timelineMode == info.mode &&
        _timelineZoom == info.value;
    if (unchanged && _pendingTimelineInfo == null) {
      return;
    }

    _pendingTimelineInfo = info;
    if (_timelineUpdateScheduled) {
      return;
    }

    _timelineUpdateScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _timelineUpdateScheduled = false;
      final PositionListenerInfo<int>? pending = _pendingTimelineInfo;
      _pendingTimelineInfo = null;
      if (!mounted || pending == null) {
        return;
      }

      final bool needsUpdate =
          _timelinePosition != pending.position ||
          _timelineMode != pending.mode ||
          _timelineZoom != pending.value;
      if (!needsUpdate) {
        return;
      }

      setState(() {
        _timelinePosition = pending.position;
        _timelineMode = pending.mode;
        _timelineZoom = pending.value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('animated_toggle_switch Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'animated_toggle_switch adds animated, multi-choice toggles with prebuilt constructors and deeper customization hooks than the stock Switch widget.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            _ExampleCard(
              title: 'AnimatedToggleSwitch.dual',
              description:
                  'This two-state switch uses async onChanged support so the control can show a loading state while a save request is in flight.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: AnimatedToggleSwitch<_WorkspaceTheme>.dual(
                      current: _workspaceTheme,
                      first: _WorkspaceTheme.focus,
                      second: _WorkspaceTheme.balanced,
                      spacing: 52,
                      height: 56,
                      borderWidth: 0,
                      loading: _savingTheme,
                      style: ToggleStyle(
                        backgroundColor: colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: const <BoxShadow>[
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 16,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      styleBuilder: (_WorkspaceTheme value) {
                        final bool focus = value == _WorkspaceTheme.focus;
                        return ToggleStyle(
                          indicatorColor: focus
                              ? colorScheme.primary
                              : colorScheme.secondary,
                        );
                      },
                      textBuilder: (value) => Text(
                        value == _WorkspaceTheme.focus ? 'Focus' : 'Balanced',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      iconBuilder: (value) => Icon(
                        value == _WorkspaceTheme.focus
                            ? Icons.bolt_rounded
                            : Icons.spa_rounded,
                      ),
                      onChanged: _updateWorkspaceTheme,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _savingTheme
                        ? 'Saving preference...'
                        : 'Current profile: ${_workspaceTheme.name}',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'AnimatedToggleSwitch.rolling + vertical()',
              description:
                  'Rolling switches are useful for status pickers. This demo adds per-value styles, separators, and the vertical layout helper.',
              child: Wrap(
                spacing: 24,
                runSpacing: 24,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  AnimatedToggleSwitch<_DeliveryStage>.rolling(
                    current: _deliveryStage,
                    values: _DeliveryStage.values,
                    indicatorIconScale: 1.1,
                    spacing: 18,
                    borderWidth: 3,
                    height: 56,
                    iconBuilder: (_DeliveryStage value, bool foreground) =>
                        Icon(
                          _deliveryIcon(value),
                          color: foreground ? Colors.white : null,
                        ),
                    separatorBuilder: (int index) =>
                        const VerticalDivider(width: 8, thickness: 1),
                    style: ToggleStyle(
                      borderColor: Colors.transparent,
                      backgroundColor: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    styleBuilder: (_DeliveryStage value) {
                      final Color color = _deliveryColor(value);
                      return ToggleStyle(
                        indicatorColor: color,
                        backgroundColor: color.withValues(alpha: 0.15),
                      );
                    },
                    onChanged: (_DeliveryStage value) {
                      setState(() {
                        _deliveryStage = value;
                      });
                    },
                  ),
                  AnimatedToggleSwitch<_DeliveryStage>.rolling(
                    current: _deliveryStage,
                    values: _DeliveryStage.values,
                    loading: false,
                    indicatorIconScale: 1.05,
                    height: 64,
                    iconBuilder: (_DeliveryStage value, bool foreground) =>
                        Icon(
                          _deliveryIcon(value),
                          size: 18,
                          color: foreground ? Colors.white : null,
                        ),
                    style: const ToggleStyle(
                      borderColor: Colors.transparent,
                      indicatorColor: Colors.white,
                    ),
                    styleBuilder: (_DeliveryStage value) =>
                        ToggleStyle(backgroundColor: _deliveryColor(value)),
                    onChanged: (_DeliveryStage value) {
                      setState(() {
                        _deliveryStage = value;
                      });
                    },
                  ).vertical(),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'AnimatedToggleSwitch.size + allowUnlistedValues',
              description:
                  'The size constructor works well for segmented controls. Here it uses custom labels, animated styling, and allows clearing the selection.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  AnimatedToggleSwitch<_BoardDensity?>.size(
                    current: _boardDensity,
                    values: _BoardDensity.values,
                    allowUnlistedValues: true,
                    iconOpacity: 0.18,
                    indicatorSize: const Size.fromWidth(132),
                    borderWidth: 0,
                    selectedIconScale: 1,
                    styleAnimationType: AnimationType.onHover,
                    customIconBuilder:
                        (
                          BuildContext context,
                          AnimatedToggleProperties<_BoardDensity?> local,
                          DetailedGlobalToggleProperties<_BoardDensity?> global,
                        ) {
                          final _BoardDensity? value = local.value;
                          if (value == null) {
                            return const SizedBox.shrink();
                          }
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                switch (value) {
                                  _BoardDensity.compact =>
                                    Icons.view_headline_rounded,
                                  _BoardDensity.comfy =>
                                    Icons.dashboard_customize,
                                  _BoardDensity.roomy => Icons.space_dashboard,
                                },
                                color: Color.lerp(
                                  colorScheme.onSurfaceVariant,
                                  Colors.white,
                                  local.animationValue,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                value.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Color.lerp(
                                    colorScheme.onSurfaceVariant,
                                    Colors.white,
                                    local.animationValue,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                    style: ToggleStyle(
                      backgroundColor: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    styleBuilder: (_BoardDensity? value) {
                      final Color color = value == null
                          ? colorScheme.outline
                          : _densityColor(value);
                      return ToggleStyle(
                        indicatorColor: color,
                        backgroundColor: color.withValues(alpha: 0.18),
                      );
                    },
                    onTap: (info) {
                      if (_boardDensity == info.tapped?.value) {
                        setState(() {
                          _boardDensity = null;
                        });
                      }
                    },
                    onChanged: (_BoardDensity? value) {
                      setState(() {
                        _boardDensity = value;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: <Widget>[
                      FilledButton.tonal(
                        onPressed: () {
                          setState(() {
                            _boardDensity = null;
                          });
                        },
                        child: const Text('Clear Selection'),
                      ),
                      Text(
                        _boardDensity == null
                            ? 'No density selected'
                            : 'Selected density: ${_boardDensity!.name}',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'ThemeData.toggleStyle + styleList + RTL',
              description:
                  'The package also reads ToggleStyle from ThemeData. This example adds a local theme extension, overrides per-value styles with styleList, and flips the control with TextDirection.rtl.',
              child: Theme(
                data: theme.copyWith(
                  extensions: <ThemeExtension<dynamic>>[
                    const ToggleStyle(
                      backgroundColor: Color(0xFFF3F6FB),
                      borderColor: Colors.transparent,
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                  ],
                ),
                child: Builder(
                  builder: (BuildContext context) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        AnimatedToggleSwitch<int>.size(
                          current: _qualityPreset,
                          values: const <int>[0, 1, 2],
                          textDirection: TextDirection.rtl,
                          iconOpacity: 0.24,
                          selectedIconScale: 1,
                          indicatorSize: const Size.fromWidth(124),
                          borderWidth: 0,
                          styleList: <ToggleStyle>[
                            ToggleStyle(
                              indicatorColor: _qualityColor(0),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            ToggleStyle(
                              indicatorColor: _qualityColor(1),
                              borderRadius: BorderRadius.circular(22),
                            ),
                            ToggleStyle(
                              indicatorColor: _qualityColor(2),
                              borderRadius: BorderRadius.circular(28),
                            ),
                          ],
                          customIconBuilder:
                              (
                                BuildContext context,
                                AnimatedToggleProperties<int> local,
                                DetailedGlobalToggleProperties<int> global,
                              ) => Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    _qualityIcon(local.value),
                                    color: Color.lerp(
                                      colorScheme.onSurfaceVariant,
                                      Colors.white,
                                      local.animationValue,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _qualityLabel(local.value),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Color.lerp(
                                        colorScheme.onSurfaceVariant,
                                        Colors.white,
                                        local.animationValue,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                          onChanged: (int value) {
                            setState(() {
                              _qualityPreset = value;
                            });
                          },
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Local theme default comes from Theme.of(context).toggleStyle, while styleList still animates indicator color and radius for each selection.',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'ByHeight Constructors + positionListener',
              description:
                  'These examples use the by-height constructors from the package docs: rollingByHeight for motion-heavy segmented states, then sizeByHeight with a custom foreground indicator icon.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  AnimatedToggleSwitch<int>.rollingByHeight(
                    current: _timelineZoom,
                    values: const <int>[0, 1, 2, 3],
                    height: 56,
                    indicatorSize: const Size(0.92, 1),
                    spacing: 0.14,
                    borderWidth: 0,
                    iconOpacity: 0.32,
                    style: ToggleStyle(
                      backgroundColor: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    customStyleBuilder:
                        (
                          BuildContext context,
                          StyledToggleProperties<int> local,
                          GlobalToggleProperties<int> global,
                        ) {
                          final Color color = _zoomColor(local.value);
                          final bool dragging =
                              global.mode == ToggleMode.dragged;
                          return ToggleStyle(
                            indicatorColor: color,
                            backgroundColor: color.withValues(
                              alpha: dragging ? 0.24 : 0.14,
                            ),
                            borderRadius: BorderRadius.circular(
                              dragging ? 24 : 18,
                            ),
                          );
                        },
                    iconBuilder: (int value, bool foreground) => Icon(
                      _zoomIcon(value),
                      color: foreground ? Colors.white : _zoomColor(value),
                    ),
                    customSeparatorBuilder:
                        (
                          BuildContext context,
                          SeparatorProperties<int> local,
                          DetailedGlobalToggleProperties<int> global,
                        ) => Center(
                          child: Container(
                            width: 2,
                            height: 20,
                            decoration: BoxDecoration(
                              color: colorScheme.outlineVariant,
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                        ),
                    positionListener: _queueTimelineFeedback,
                    onChanged: (int value) {
                      setState(() {
                        _timelineZoom = value;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: <Widget>[
                      Chip(
                        avatar: const Icon(Icons.motion_photos_on, size: 18),
                        label: Text(
                          'Position: ${_timelinePosition.toStringAsFixed(2)}',
                        ),
                      ),
                      Chip(
                        avatar: const Icon(Icons.touch_app_outlined, size: 18),
                        label: Text('Mode: ${_timelineMode.name}'),
                      ),
                      Chip(
                        avatar: Icon(_zoomIcon(_timelineZoom), size: 18),
                        label: Text('Zoom step: ${_timelineZoom + 1}'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  AnimatedToggleSwitch<int>.sizeByHeight(
                    current: _timelineZoom,
                    values: const <int>[0, 1, 2, 3],
                    height: 52,
                    indicatorSize: const Size(1.35, 1),
                    spacing: 0.08,
                    borderWidth: 0,
                    iconOpacity: 0.18,
                    selectedIconScale: 1,
                    style: ToggleStyle(
                      backgroundColor: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    styleBuilder: (int value) =>
                        ToggleStyle(indicatorColor: _zoomColor(value)),
                    iconBuilder: (int value) => Icon(_zoomIcon(value)),
                    foregroundIndicatorIconBuilder:
                        (
                          BuildContext context,
                          DetailedGlobalToggleProperties<int> global,
                        ) {
                          final double transitionValue =
                              global.position - global.position.floorToDouble();
                          return Transform.rotate(
                            angle: transitionValue * math.pi,
                            child: Icon(
                              _zoomIcon(global.current),
                              color: Colors.white,
                              size: 18,
                            ),
                          );
                        },
                    onChanged: (int value) {
                      setState(() {
                        _timelineZoom = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'CustomAnimatedToggleSwitch',
              description:
                  'For designs that do not fit the built-in constructors, the custom widget exposes wrapper and indicator builders for full control.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: CustomAnimatedToggleSwitch<bool>(
                      current: _notificationsEnabled,
                      values: const <bool>[false, true],
                      spacing: 0,
                      indicatorSize: const Size.square(30),
                      animationDuration: const Duration(milliseconds: 220),
                      animationCurve: Curves.easeOut,
                      iconsTappable: false,
                      cursors: const ToggleCursors(
                        defaultCursor: SystemMouseCursors.click,
                      ),
                      onTap: (_) {
                        setState(() {
                          _notificationsEnabled = !_notificationsEnabled;
                        });
                      },
                      onChanged: (bool value) {
                        setState(() {
                          _notificationsEnabled = value;
                        });
                      },
                      iconBuilder:
                          (
                            BuildContext context,
                            LocalToggleProperties<bool> local,
                            DetailedGlobalToggleProperties<bool> global,
                          ) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                              ),
                              child: Text(
                                local.value ? 'Alerts' : 'Muted',
                                style: TextStyle(
                                  color: local.value
                                      ? colorScheme.primary
                                      : colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          },
                      wrapperBuilder:
                          (
                            BuildContext context,
                            GlobalToggleProperties<bool> global,
                            Widget child,
                          ) {
                            return Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                Positioned(
                                  left: 12,
                                  right: 12,
                                  height: 22,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: Color.lerp(
                                        colorScheme.surfaceContainerHighest,
                                        colorScheme.primary.withValues(
                                          alpha: 0.24,
                                        ),
                                        global.position,
                                      ),
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                  ),
                                ),
                                child,
                              ],
                            );
                          },
                      foregroundIndicatorBuilder:
                          (
                            BuildContext context,
                            DetailedGlobalToggleProperties<bool> global,
                          ) {
                            return SizedBox.fromSize(
                              size: global.indicatorSize,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Color.lerp(
                                    Colors.white,
                                    colorScheme.primary,
                                    global.position,
                                  ),
                                  borderRadius: BorderRadius.circular(999),
                                  boxShadow: const <BoxShadow>[
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 10,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _notificationsEnabled
                        ? 'Notifications are enabled for build failures.'
                        : 'Notifications are muted for this workspace.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Current Demo State',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: <Widget>[
                        Chip(
                          avatar: const Icon(Icons.palette_outlined, size: 18),
                          label: Text('Theme: ${_workspaceTheme.name}'),
                        ),
                        Chip(
                          avatar: Icon(_deliveryIcon(_deliveryStage), size: 18),
                          label: Text('Delivery: ${_deliveryStage.name}'),
                        ),
                        Chip(
                          avatar: const Icon(Icons.grid_view_rounded, size: 18),
                          label: Text(
                            'Density: ${_boardDensity?.name ?? 'none'}',
                          ),
                        ),
                        Chip(
                          avatar: const Icon(
                            Icons.movie_filter_outlined,
                            size: 18,
                          ),
                          label: Text(
                            'Preset: ${_qualityLabel(_qualityPreset)}',
                          ),
                        ),
                        Chip(
                          avatar: const Icon(Icons.timeline_rounded, size: 18),
                          label: Text(
                            'Zoom ${_timelineZoom + 1} • ${_timelineMode.name}',
                          ),
                        ),
                        Chip(
                          avatar: const Icon(
                            Icons.notifications_active,
                            size: 18,
                          ),
                          label: Text(
                            _notificationsEnabled
                                ? 'Alerts enabled'
                                : 'Alerts muted',
                          ),
                        ),
                      ],
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

class _ExampleCard extends StatelessWidget {
  const _ExampleCard({
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
