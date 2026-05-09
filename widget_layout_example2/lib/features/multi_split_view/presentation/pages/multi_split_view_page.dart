import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:multi_split_view/multi_split_view.dart';
import 'package:widget_layout_example2/app_navigation.dart';

@RoutePage(name: RouteName.multiSplitView)
class MultiSplitViewPage extends StatefulWidget {
  const MultiSplitViewPage({super.key});

  @override
  State<MultiSplitViewPage> createState() => _MultiSplitViewPageState();
}

class _MultiSplitViewPageState extends State<MultiSplitViewPage> {
  late final MultiSplitViewController _workspaceController;
  late final MultiSplitViewController _editorController;

  Axis _workspaceAxis = Axis.horizontal;
  String _workspacePreset = 'Three columns';
  String _statusText =
      'Try dragging the divider. Double tap a divider to reset the current demo.';

  @override
  void initState() {
    super.initState();
    _workspaceController = MultiSplitViewController(
      areas: _buildWorkspaceAreas(_workspacePreset),
    );
    _editorController = MultiSplitViewController(areas: _buildEditorAreas());
  }

  @override
  void dispose() {
    _workspaceController.dispose();
    _editorController.dispose();
    super.dispose();
  }

  List<Area> _buildWorkspaceAreas(String preset) {
    switch (preset) {
      case 'Wide center':
        return <Area>[
          Area(
            min: 110,
            flex: 1.2,
            builder: (BuildContext context, Area area) =>
                _buildAreaTile('Folders', 'Narrow navigation area', area, 0),
          ),
          Area(
            min: 180,
            flex: 2.8,
            builder: (BuildContext context, Area area) => _buildAreaTile(
              'Editor',
              'Center pane gets more space',
              area,
              1,
            ),
          ),
          Area(
            min: 130,
            flex: 1.1,
            builder: (BuildContext context, Area area) =>
                _buildAreaTile('Preview', 'Result panel', area, 2),
          ),
        ];
      case 'Reading mode':
        return <Area>[
          Area(
            size: 120,
            min: 90,
            max: 180,
            builder: (BuildContext context, Area area) =>
                _buildAreaTile('Outline', 'Fixed side rail', area, 0),
          ),
          Area(
            min: 220,
            flex: 3.6,
            builder: (BuildContext context, Area area) => _buildAreaTile(
              'Document',
              'Main content expands with the window',
              area,
              1,
            ),
          ),
          Area(
            size: 200,
            min: 150,
            max: 260,
            builder: (BuildContext context, Area area) =>
                _buildAreaTile('Notes', 'Fixed utility pane', area, 2),
          ),
        ];
      case 'Three columns':
      default:
        return <Area>[
          Area(
            min: 110,
            flex: 1,
            builder: (BuildContext context, Area area) =>
                _buildAreaTile('Navigator', 'Project tree or menu', area, 0),
          ),
          Area(
            min: 180,
            flex: 1.4,
            builder: (BuildContext context, Area area) =>
                _buildAreaTile('Canvas', 'Main working area', area, 1),
          ),
          Area(
            min: 130,
            flex: 1,
            builder: (BuildContext context, Area area) =>
                _buildAreaTile('Inspector', 'Properties and tools', area, 2),
          ),
        ];
    }
  }

  List<Area> _buildEditorAreas() {
    return <Area>[
      Area(
        size: 190,
        min: 140,
        max: 280,
        builder: (BuildContext context, Area area) => _buildAreaTile(
          'Sidebar',
          'Fixed width panel. Good for tool lists.',
          area,
          3,
        ),
      ),
      Area(
        min: 180,
        flex: 1.6,
        builder: (BuildContext context, Area area) => _buildAreaTile(
          'Editor',
          'Flexible area. It grows when the page gets wider.',
          area,
          4,
        ),
      ),
      Area(
        min: 120,
        flex: 1,
        builder: (BuildContext context, Area area) => _buildAreaTile(
          'Console',
          'Another flexible area that shares remaining space.',
          area,
          5,
        ),
      ),
    ];
  }

  void _applyWorkspacePreset(String preset) {
    setState(() {
      _workspacePreset = preset;
      _workspaceController.areas = _buildWorkspaceAreas(preset);
      _statusText = 'Applied preset: $preset';
    });
  }

  void _toggleWorkspaceAxis() {
    setState(() {
      _workspaceAxis = _workspaceAxis == Axis.horizontal
          ? Axis.vertical
          : Axis.horizontal;
      _statusText =
          'Switched to ${_workspaceAxis == Axis.horizontal ? 'horizontal' : 'vertical'} split.';
    });
  }

  void _resetWorkspaceLayout() {
    setState(() {
      _workspaceController.areas = _buildWorkspaceAreas(_workspacePreset);
      _statusText = 'Reset the main split layout.';
    });
  }

  void _resetEditorLayout() {
    setState(() {
      _editorController.areas = _buildEditorAreas();
      _statusText = 'Reset the fixed-size + flexible-size example.';
    });
  }

  void _updateStatus(String text) {
    if (!mounted) {
      return;
    }
    setState(() {
      _statusText = text;
    });
  }

  Widget _buildAreaTile(
    String title,
    String subtitle,
    Area area,
    int colorIndex,
  ) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final List<Color> fills = <Color>[
      colorScheme.primaryContainer,
      colorScheme.secondaryContainer,
      colorScheme.tertiaryContainer,
      colorScheme.surfaceContainerHigh,
      colorScheme.surfaceContainerHighest,
      colorScheme.surfaceContainerLow,
    ];
    final List<Color> accents = <Color>[
      colorScheme.primary,
      colorScheme.secondary,
      colorScheme.tertiary,
      colorScheme.outline,
      colorScheme.primary,
      colorScheme.secondary,
    ];
    final Color fill = fills[colorIndex % fills.length];
    final Color accent = accents[colorIndex % accents.length];

    return Container(
      decoration: BoxDecoration(
        color: fill,
        border: Border.all(color: accent.withValues(alpha: 0.35)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          title,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 8),
                        Text(subtitle),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: <Widget>[
                            Chip(label: Text('min ${_formatNumber(area.min)}')),
                            Chip(
                              label: Text(
                                area.size != null
                                    ? 'size ${_formatNumber(area.size)} px'
                                    : 'flex ${_formatNumber(area.flex)}',
                              ),
                            ),
                            Chip(
                              label: Text(
                                area.max != null
                                    ? 'max ${_formatNumber(area.max)}'
                                    : 'max -',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      area.size != null
                          ? 'This pane uses a pixel size, so it behaves more like a fixed sidebar.'
                          : 'This pane uses flex, so it grows or shrinks with remaining space.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatNumber(double? value) {
    if (value == null) {
      return '-';
    }
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(1);
  }

  Widget _buildMainSplitDemo() {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Interactive Split Workspace',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            const Text(
              'multi_split_view can divide one container into multiple resizable panes. It is useful for IDE layouts, dashboards, mail clients, file explorers, and comparison tools.',
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: <Widget>[
                FilledButton.icon(
                  onPressed: _toggleWorkspaceAxis,
                  icon: Icon(
                    _workspaceAxis == Axis.horizontal
                        ? Icons.swap_horiz
                        : Icons.swap_vert,
                  ),
                  label: Text(
                    _workspaceAxis == Axis.horizontal
                        ? 'Horizontal Split'
                        : 'Vertical Split',
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: _resetWorkspaceLayout,
                  icon: const Icon(Icons.restart_alt),
                  label: const Text('Reset Layout'),
                ),
                SegmentedButton<String>(
                  segments: const <ButtonSegment<String>>[
                    ButtonSegment<String>(
                      value: 'Three columns',
                      label: Text('Balanced'),
                    ),
                    ButtonSegment<String>(
                      value: 'Wide center',
                      label: Text('Wide Center'),
                    ),
                    ButtonSegment<String>(
                      value: 'Reading mode',
                      label: Text('Mixed Size'),
                    ),
                  ],
                  selected: <String>{_workspacePreset},
                  onSelectionChanged: (Set<String> values) {
                    _applyWorkspacePreset(values.first);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            SelectionContainer.disabled(
              child: Container(
                height: 320,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: MultiSplitViewTheme(
                    data: MultiSplitViewThemeData(
                      dividerThickness: 14,
                      dividerHandleBuffer: 3,
                      dividerPainter: DividerPainters.grooved1(
                        color: Theme.of(context).colorScheme.outline,
                        highlightedColor: Theme.of(context).colorScheme.primary,
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.surfaceContainer,
                        highlightedBackgroundColor: Theme.of(
                          context,
                        ).colorScheme.primaryContainer,
                      ),
                    ),
                    child: MultiSplitView(
                      axis: _workspaceAxis,
                      controller: _workspaceController,
                      onDividerDragStart: (int index) {
                        _updateStatus('Dragging divider ${index + 1}...');
                      },
                      onDividerDragUpdate: (int index) {
                        _updateStatus(
                          'Divider ${index + 1} moved. Neighbor panes resized immediately.',
                        );
                      },
                      onDividerDragEnd: (int index) {
                        _updateStatus(
                          'Divider ${index + 1} released. Final pane sizes are kept.',
                        );
                      },
                      onDividerDoubleTap: (int index) {
                        _resetWorkspaceLayout();
                        _updateStatus(
                          'Double tapped divider ${index + 1}. Restored the current preset.',
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFixedAndFlexibleDemo() {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Fixed Pane + Flexible Panes',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            const Text(
              'You can mix `size` and `flex`. A fixed-size area stays close to a pixel width, while flex areas share the remaining space.',
            ),
            const SizedBox(height: 16),
            SelectionContainer.disabled(
              child: Container(
                height: 250,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: MultiSplitViewTheme(
                    data: MultiSplitViewThemeData(
                      dividerThickness: 12,
                      dividerPainter: DividerPainters.background(
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHigh,
                        highlightedColor: Theme.of(
                          context,
                        ).colorScheme.secondaryContainer,
                      ),
                    ),
                    child: MultiSplitView(
                      controller: _editorController,
                      onDividerDoubleTap: (int index) {
                        _resetEditorLayout();
                        _updateStatus(
                          'Reset the second demo from divider ${index + 1}.',
                        );
                      },
                      dividerBuilder:
                          (
                            Axis axis,
                            int index,
                            bool resizable,
                            bool dragging,
                            bool highlighted,
                            MultiSplitViewThemeData themeData,
                          ) {
                            return Tooltip(
                              message: 'Drag divider ${index + 1}',
                              child: DividerWidget(
                                axis: axis,
                                index: index,
                                resizable: resizable,
                                dragging: dragging,
                                highlighted: highlighted,
                                themeData: themeData,
                              ),
                            );
                          },
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: <Widget>[
                OutlinedButton.icon(
                  onPressed: _resetEditorLayout,
                  icon: const Icon(Icons.restart_alt),
                  label: const Text('Reset Example'),
                ),
                const Chip(label: Text('Sidebar: fixed `size`')),
                const Chip(label: Text('Editor + Console: flexible `flex`')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConceptSummary() {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'What This Package Does',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            const Text('1. Split one region into multiple panes.'),
            const SizedBox(height: 8),
            const Text('2. Let users drag dividers to resize adjacent panes.'),
            const SizedBox(height: 8),
            const Text('3. Support horizontal and vertical layouts.'),
            const SizedBox(height: 8),
            const Text(
              '4. Support fixed pixel size, min/max constraints, and flex sizing.',
            ),
            const SizedBox(height: 8),
            const Text(
              '5. Fit UI patterns like IDEs, admin consoles, compare views, and mail apps.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        leading: const Icon(Icons.drag_indicator),
        title: const Text('Current Interaction'),
        subtitle: Text(_statusText),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('multi_split_view Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'multi_split_view is a resizable multi-pane layout widget. It lets you build desktop-style split panels, where users can drag dividers to redistribute space between sections.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            _buildMainSplitDemo(),
            const SizedBox(height: 16),
            _buildFixedAndFlexibleDemo(),
            const SizedBox(height: 16),
            _buildConceptSummary(),
            const SizedBox(height: 16),
            _buildStatusCard(),
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
