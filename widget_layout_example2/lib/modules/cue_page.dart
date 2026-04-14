import 'package:auto_route/auto_route.dart';
import 'package:cue/cue.dart';
import 'package:flutter/material.dart';

/// Comprehensive demo of the Cue animation package with physics-first animations
/// and composable motion patterns.
///
/// Cue provides several trigger points for animations:
/// - [Cue.onMount]: Trigger on widget mount
/// - [Cue.onToggle]: Toggle animations based on boolean state
/// - [Cue.onChange]: Trigger on value changes (tabs, filters, etc.)
/// - [Cue.onHover]: Pointer enter/exit animations (desktop/web)
/// - [Cue.onScrollVisible]: Trigger when scrolling into viewport
/// - [Cue.onCallback]: Manual callback-driven animations
@RoutePage(name: 'CueRoute')
class CuePage extends StatefulWidget {
  const CuePage({super.key});

  @override
  State<CuePage> createState() => _CuePageState();
}

class _CuePageState extends State<CuePage> {
  bool _expanded = false;
  bool _showNotification = false;
  int _selectedWorkflow = 0;
  int _activeTab = 0;
  String _formInput = '';
  bool _isHovered = false;
  bool _showListItems = false;
  int _selectedCard = -1;
  bool _showSuccess = false;

  static const List<
    ({String title, String summary, IconData icon, Color color})
  >
  _workflows = <({String title, String summary, IconData icon, Color color})>[
    (
      title: 'Entrance Motion',
      summary:
          'Stagger a title, subtitle, and chips when the section mounts with smooth physics.',
      icon: Icons.rocket_launch,
      color: Color(0xFF2A6F97),
    ),
    (
      title: 'Toggle Panels',
      summary:
          'Drive expansion and reversal from a single boolean state flag with coordinated animations.',
      icon: Icons.expand_circle_down,
      color: Color(0xFF7B2CBF),
    ),
    (
      title: 'Scroll Reactions',
      summary:
          'Scrub or reveal cards as they move through the viewport with scroll-based triggers.',
      icon: Icons.swipe_vertical,
      color: Color(0xFF2D6A4F),
    ),
  ];

  void _toggleExpanded() {
    setState(() {
      _expanded = !_expanded;
    });
  }

  void _toggleNotification() {
    setState(() {
      _showNotification = !_showNotification;
    });
  }

  void _selectWorkflow(int index) {
    setState(() {
      _selectedWorkflow = index;
    });
  }

  void _selectTab(int index) {
    setState(() {
      _activeTab = index;
    });
  }

  void _toggleListItems() {
    setState(() {
      _showListItems = !_showListItems;
    });
  }

  void _selectCard(int index) {
    setState(() {
      _selectedCard = _selectedCard == index ? -1 : index;
    });
  }

  void _showSuccessMessage() {
    setState(() {
      _showSuccess = true;
    });
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        setState(() {
          _showSuccess = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ({String title, String summary, IconData icon, Color color})
    workflow = _workflows[_selectedWorkflow];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cue - Physics-First Animations'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: <Widget>[
          Card(
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Cue: Physics-First Animation Package',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Cue is a composable Flutter motion package for building sophisticated animations with physics-based motion, '
                    'trigger points, and actor-based composition. It separates animation logic from UI concerns.',
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: const <Widget>[
                                Chip(label: Text('Physics-based')),
                                Chip(label: Text('Composable')),
                                Chip(label: Text('Trigger Points')),
                                Chip(label: Text('Actor Pattern')),
                                Chip(label: Text('Smooth Curves')),
                                Chip(label: Text('Stateless')),
                              ],
                            ),
                          );
                        },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _CueSectionCard(
            title: 'Cue.onToggle - Advanced State Management',
            description:
                'Advanced toggle patterns with multiple actors coordinating seamlessly. '
                'Useful for collapsibles, sidebars, modals, and any expand/collapse pattern.',
            codeLabel:
                'Cue.onToggle(toggled: expanded, child: MultiActor([...], child: ...))',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                FilledButton.tonalIcon(
                  onPressed: _toggleExpanded,
                  icon: Cue.onToggle(
                    toggled: _expanded,
                    skipFirstAnimation: true,
                    motion: .smooth(),
                    acts: <Act>[.rotate(to: 180)],
                    child: const Icon(Icons.expand_more),
                  ),
                  label: Text(
                    _expanded ? 'Collapse detail panel' : 'Expand detail panel',
                  ),
                ),
                const SizedBox(height: 12),
                Cue.onToggle(
                  toggled: _expanded,
                  skipFirstAnimation: true,
                  motion: .smooth(),
                  child: Actor(
                    acts: <Act>[
                      .clipHeight(),
                      .fadeIn(from: 0.16),
                      .slideY(from: -0.08),
                    ],
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3E8FF),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Expanded Content Panel',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'One `Cue.onToggle` orchestrates multiple child actors in sync. '
                            'This is perfect for accordions, command menus, filters, and drill-down UI patterns.',
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: <Widget>[
                              Chip(
                                label: const Text('rotate'),
                                backgroundColor: Colors.purple[100],
                              ),
                              Chip(
                                label: const Text('slideY'),
                                backgroundColor: Colors.purple[100],
                              ),
                              Chip(
                                label: const Text('fadeIn'),
                                backgroundColor: Colors.purple[100],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (_expanded) ...<Widget>[
                  const SizedBox(height: 12),
                  Cue.onToggle(
                    toggled: _expanded,
                    skipFirstAnimation: true,
                    motion: .smooth(),
                    child: Actor(
                      delay: 160.ms,
                      acts: <Act>[.fadeIn(from: 0), .slideY(from: 0.06)],
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.purple[50],
                          border: Border.all(color: Colors.purple[200]!),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Sequential child animations with staggered delays are perfect for accordions and disclosure patterns.',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          _CueSectionCard(
            title: 'Cue.onChange - Tab & Filter Animations',
            description:
                'Animate content changes when a tracked value updates. '
                'Ideal for tabs, filters, plan switches, and any state-driven content swaps.',
            codeLabel:
                'Cue.onChange(value: activeTab, acts: [.fadeIn(), .scale(from: 0.96)])',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List<Widget>.generate(
                      3,
                      (int index) => Padding(
                        padding: EdgeInsets.only(right: index == 2 ? 0 : 8),
                        child: ChoiceChip(
                          label: Text(
                            <String>['Overview', 'Details', 'Advanced'][index],
                          ),
                          selected: _activeTab == index,
                          onSelected: (_) => _selectTab(index),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Cue.onChange(
                  value: _activeTab,
                  fromCurrentValue: true,
                  motion: .easeInOut(320.ms),
                  acts: <Act>[
                    .fadeIn(from: 0.45),
                    .slideY(from: 0.12),
                    .scale(from: 0.96),
                  ],
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: <Color>[
                        Colors.blue[50]!,
                        Colors.green[50]!,
                        Colors.amber[50]!,
                      ][_activeTab],
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: <Color>[
                          Colors.blue[200]!,
                          Colors.green[200]!,
                          Colors.amber[200]!,
                        ][_activeTab],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          <String>[
                            'Overview Panel',
                            'Details Panel',
                            'Advanced Settings',
                          ][_activeTab],
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          <String>[
                            'Quick view of your content with key metrics and summary information.',
                            'Detailed breakdowns, stats, and comprehensive information display.',
                            'Advanced configuration options and power-user features.',
                          ][_activeTab],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _CueSectionCard(
            title: 'Cue.onHover - Interactive Feedback',
            description:
                'Trigger animations on pointer enter/exit for desktop and web. '
                'Great for cards, rows, toolbars, and interactive surfaces.',
            codeLabel:
                'Cue.onHover(acts: [.scale(to: 1.04), .slideY(to: -0.02)], child: card)',
            child: Cue.onHover(
              acts: <Act>[.scale(to: 1.04), .slideY(to: -0.04)],
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFF1D3557),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: const Color(0xFF1D3557).withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(Icons.touch_app, color: Colors.white),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Hover Interaction',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Cue.onHover automatically plays forward on pointer enter and reverses on exit.',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    FilledButton(onPressed: () {}, child: const Text('View')),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _CueSectionCard(
            title: 'Cue.onScrollVisible - Scroll Triggers',
            description:
                'Activate animations when elements scroll into the viewport. '
                'Perfect for feed items, dashboard cards, and lazy-loaded content.',
            codeLabel:
                'Cue.onScrollVisible(child: widget.act([.fadeIn(), .slideY(from: 0.16)]))',
            child: Column(
              children: List<Widget>.generate(3, (int index) {
                final Color color = <Color>[
                  const Color(0xFFDCEAF7),
                  const Color(0xFFE8F6E8),
                  const Color(0xFFFBE7C6),
                ][index];
                final IconData icon = <IconData>[
                  Icons.feed,
                  Icons.list_alt,
                  Icons.analytics,
                ][index];
                final String label = <String>[
                  'Feed Cards',
                  'Section Items',
                  'Metrics',
                ][index];
                final String description = <String>[
                  'Trigger when feed items become visible',
                  'Reveal sections as user scrolls',
                  'Animate metrics and charts into view',
                ][index];

                return Padding(
                  padding: EdgeInsets.only(bottom: index == 2 ? 0 : 12),
                  child: Cue.onScrollVisible(
                    child:
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                alignment: Alignment.center,
                                child: Icon(icon, size: 24),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      label,
                                      style: theme.textTheme.titleSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      description,
                                      style: theme.textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ).act(<Act>[
                          .fadeIn(),
                          .slideY(from: 0.16),
                          .scale(from: 0.94),
                        ]),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 16),
          _CueSectionCard(
            title: 'Complex Act Combinations',
            description:
                'Chain multiple acts together for sophisticated animations. '
                'Combine blur, scale, rotate, slide, and fade for polished effects.',
            codeLabel:
                '.act([.blur(from: 8), .slideX(from: -0.2), .scale(from: 0.8), .rotate(from: 180)])',
            child: Cue.onMount(
              motion: .easeInOut(500.ms),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: <Color>[Color(0xFFFF006E), Color(0xFF8338EC)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: <Widget>[
                    Cue.onMount(
                      motion: .easeOut(300.ms),
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        alignment: Alignment.center,
                        child: Cue.onMount(
                          motion: .easeOut(400.ms),
                          child: const Icon(
                            Icons.star,
                            color: Colors.white,
                            size: 48,
                          ).act(<Act>[.scale(from: 0), .rotate(from: -180)]),
                        ),
                      ).act(<Act>[.scale(from: 0.6), .fadeIn(from: 0)]),
                    ),
                    const SizedBox(height: 16),
                    Cue.onMount(
                      motion: .easeOut(600.ms),
                      child: Text(
                        'Advanced Composition',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ).act(<Act>[.fadeIn(from: 0), .slideY(from: 0.2)]),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _CueSectionCard(
            title: 'Cue.onMount - Staggered Entrance',
            description:
                'Mount animations trigger when a widget first builds. '
                'Perfect for loading screens, onboarding, and feature intros.',
            codeLabel:
                'Cue.onMount(motion: .smooth(), child: Column(children: [Actor(...), Actor(delay: 80.ms, ...)]))',
            child: Cue.onMount(
              motion: .smooth(),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: <Color>[Color(0xFF0B3D91), Color(0xFF3A86FF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Actor(
                      acts: <Act>[
                        .fadeIn(),
                        .slideY(from: 0.22),
                        .blur(from: 8),
                      ],
                      child: Text(
                        'Launch a motion system without wiring controllers everywhere.',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Actor(
                      delay: 80.ms,
                      acts: <Act>[.fadeIn(), .slideY(from: 0.18)],
                      child: Text(
                        'Cue keeps trigger logic, rendered widgets, and animation effects separated so larger interfaces stay readable.',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: Colors.white.withValues(alpha: 0.88),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Actor(
                      delay: 160.ms,
                      acts: <Act>[
                        .fadeIn(),
                        .slideY(from: 0.14),
                        .scale(from: 0.94),
                      ],
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: const <Widget>[
                          _MountChip(label: 'fadeIn'),
                          _MountChip(label: 'slideY'),
                          _MountChip(label: 'blur'),
                          _MountChip(label: 'stagger'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _CueSectionCard(
            title: 'Act Types - Animation Primitives',
            description:
                'Cue provides a variety of Act types for different animation effects. '
                'Each act can be combined with others for complex animations.',
            codeLabel: '',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Cue.onMount(
                  motion: .smooth(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _ActDefinition(
                        name: 'fadeIn / fadeOut',
                        example: '.fadeIn(from: 0.5)  or  .fadeOut(to: 0.3)',
                        description:
                            'Controls opacity. Perfect for entrance and exit transitions.',
                      ),
                      const SizedBox(height: 12),
                      _ActDefinition(
                        name: 'slideX / slideY',
                        example: '.slideX(from: -0.3)  or  .slideY(to: 0.2)',
                        description:
                            'Moves widget horizontally or vertically as percentage of viewport.',
                      ),
                      const SizedBox(height: 12),
                      _ActDefinition(
                        name: 'scale',
                        example: '.scale(from: 0.8)  or  .scale(to: 1.2)',
                        description:
                            'Resizes widget from origin point. 1.0 is normal size.',
                      ),
                      const SizedBox(height: 12),
                      _ActDefinition(
                        name: 'rotate',
                        example: '.rotate(from: -180)  or  .rotate(to: 360)',
                        description:
                            'Rotates widget in degrees. Perfect for loading spinners.',
                      ),
                      const SizedBox(height: 12),
                      _ActDefinition(
                        name: 'blur',
                        example: '.blur(from: 8)  or  .blur(to: 0)',
                        description:
                            'Applies Gaussian blur filter. Great for focus effects.',
                      ),
                      const SizedBox(height: 12),
                      _ActDefinition(
                        name: 'clipHeight / clipWidth',
                        example: '.clipHeight()  or  .clipWidth()',
                        description:
                            'Reveals/hides content by clipping. Best for expand/collapse.',
                      ),
                    ],
                  ).act(<Act>[.fadeIn(), .slideY(from: 0.15)]),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _CueSectionCard(
            title: 'List Item Animations',
            description:
                'Stagger animations for list items with coordinated entrance. '
                'Each item animates in sequence with delays.',
            codeLabel:
                'for (item in items) Actor(delay: i * 80.ms, acts: [...], child: item)',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                FilledButton.tonalIcon(
                  onPressed: _toggleListItems,
                  icon: const Icon(Icons.list),
                  label: Text(
                    _showListItems ? 'Hide List' : 'Show Staggered List',
                  ),
                ),
                const SizedBox(height: 12),
                if (_showListItems)
                  Cue.onMount(
                    motion: .smooth(),
                    child: Column(
                      children: List<Widget>.generate(
                        5,
                        (int index) => Padding(
                          padding: EdgeInsets.only(bottom: index == 4 ? 0 : 12),
                          child: Actor(
                            delay: Duration(milliseconds: index * 80),
                            acts: <Act>[
                              .fadeIn(),
                              .slideX(from: -0.3),
                              .scale(from: 0.9),
                            ],
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                border: Border.all(color: Colors.blue[200]!),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'List Item ${index + 1}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      '${index + 1}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _CueSectionCard(
            title: 'Form Validation with Success State',
            description:
                'Animate to provide visual feedback on form submission. '
                'Success message appears with coordinated animations.',
            codeLabel:
                'Cue.onToggle(toggled: isValid, acts: [.scale(from: 0.8), .fadeIn()])',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                FilledButton.icon(
                  onPressed: _showSuccessMessage,
                  icon: const Icon(Icons.check),
                  label: const Text('Submit Form'),
                ),
                const SizedBox(height: 12),
                if (_showSuccess)
                  Cue.onMount(
                    motion: .easeOut(400.ms),
                    child:
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            border: Border.all(color: Colors.green[300]!),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: <Widget>[
                              Cue.onMount(
                                motion: .easeOut(300.ms),
                                child:
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      alignment: Alignment.center,
                                      child: const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ).act(<Act>[
                                      .scale(from: 0),
                                      .rotate(from: -180),
                                    ]),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    const Text(
                                      'Success!',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Your changes have been saved.',
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ).act(<Act>[
                          .fadeIn(),
                          .slideY(from: -0.2),
                          .scale(from: 0.9),
                        ]),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _CueSectionCard(
            title: 'Card Flip Animation',
            description:
                'Click cards to reveal details with a flip and scale animation. '
                'Perfect for interactive content cards.',
            codeLabel:
                'Cue.onToggle(toggled: isSelected, acts: [.rotate(to: 0.5), .scale(...)])',
            child: Column(
              children: List<Widget>.generate(3, (int index) {
                final bool isSelected = _selectedCard == index;
                return Padding(
                  padding: EdgeInsets.only(bottom: index == 2 ? 0 : 12),
                  child: GestureDetector(
                    onTap: () => _selectCard(index),
                    child: Cue.onToggle(
                      toggled: isSelected,
                      skipFirstAnimation: true,
                      motion: .smooth(),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: <Color>[
                            Colors.red[50]!,
                            Colors.orange[50]!,
                            Colors.purple[50]!,
                          ][index],
                          border: Border.all(
                            color: <Color>[
                              Colors.red[300]!,
                              Colors.orange[300]!,
                              Colors.purple[300]!,
                            ][index],
                            width: isSelected ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  <String>[
                                    'Feature A',
                                    'Feature B',
                                    'Feature C',
                                  ][index],
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w700),
                                ),
                                Cue.onToggle(
                                  toggled: isSelected,
                                  skipFirstAnimation: true,
                                  motion: .smooth(),
                                  acts: <Act>[.rotate(to: 180)],
                                  child: const Icon(Icons.expand_more),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              <String>[
                                'Advanced functionality',
                                'Enhanced performance',
                                'Premium features',
                              ][index],
                            ),
                            if (isSelected) ...<Widget>[
                              const SizedBox(height: 12),
                              Cue.onToggle(
                                toggled: isSelected,
                                skipFirstAnimation: true,
                                motion: .smooth(),
                                child: Actor(
                                  acts: <Act>[.fadeIn(), .slideY(from: -0.08)],
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.5,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      <String>[
                                        '• Unlimited access\n• Priority support\n• Custom integrations',
                                        '• 10x faster processing\n• Optimized caching\n• Advanced analytics',
                                        '• Exclusive templates\n• Premium support\n• White label options',
                                      ][index],
                                      style: const TextStyle(
                                        fontSize: 13,
                                        height: 1.6,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ).act(<Act>[isSelected ? .scale(to: 1.02) : .scale(from: 0.98)]),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 16),
          _CueSectionCard(
            title: 'Chained Cue Triggers - Complex Workflows',
            description:
                'Combine multiple Cue triggers and actors for sophisticated animations. '
                'Each trigger layer adds more depth to the animation.',
            codeLabel: 'Cue.onMount(child: Cue.onHover(child: Actor(...)))',
            child: Cue.onMount(
              motion: .smooth(),
              child: Cue.onHover(
                acts: <Act>[.scale(to: 1.03), .slideY(to: -0.02)],
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[Colors.teal[400]!, Colors.cyan[300]!],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Actor(
                            acts: <Act>[
                              .fadeIn(),
                              .scale(from: 0),
                              .rotate(from: -90),
                            ],
                            child: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.rocket,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Actor(
                              delay: 80.ms,
                              acts: <Act>[.fadeIn(), .slideX(from: -0.2)],
                              child: Text(
                                'Chained Triggers',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Actor(
                        delay: 160.ms,
                        acts: <Act>[.fadeIn(), .slideY(from: 0.12)],
                        child: Text(
                          'Mount animations combined with hover effects create polished, responsive UX.',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _CueSectionCard(
            title: 'Advanced Motion Curves',
            description:
                'Cue provides different motion profiles for different use cases. '
                'Choose the right curve for natural, responsive animations.',
            codeLabel:
                '.smooth()  .easeInOut()  .easeOut()  .easeIn()  .linear()',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Cue.onMount(
                  motion: .smooth(),
                  child: Column(
                    children: <Widget>[
                      _MotionCurveExample(
                        title: '.smooth() - Physics-based Spring',
                        description:
                            'Natural, bouncy motion. Best for user interactions.',
                        curve: 'smooth',
                      ),
                      const SizedBox(height: 12),
                      _MotionCurveExample(
                        title: '.easeInOut() - Smooth Acceleration',
                        description:
                            'Starts slow, speeds up mid, slows at end.',
                        curve: 'easeInOut',
                      ),
                      const SizedBox(height: 12),
                      _MotionCurveExample(
                        title: '.easeOut() - Snappy Start',
                        description: 'Fast start with smooth deceleration.',
                        curve: 'easeOut',
                      ),
                      const SizedBox(height: 12),
                      _MotionCurveExample(
                        title: '.easeIn() - Slow Start',
                        description: 'Slow start with acceleration at the end.',
                        curve: 'easeIn',
                      ),
                    ],
                  ).act(<Act>[.fadeIn(), .slideY(from: 0.15)]),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _CueSectionCard(
            title: 'Delay & Stagger Patterns',
            description:
                'Use delays to create staggered, coordinated animations. '
                'Perfect for lists, grids, and multi-element layouts.',
            codeLabel:
                'Actor(delay: 0.ms, ...), Actor(delay: 100.ms, ...), Actor(delay: 200.ms, ...)',
            child: Cue.onMount(
              motion: .smooth(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    children: List<Widget>.generate(9, (int index) {
                      return Actor(
                        delay: Duration(milliseconds: index * 60),
                        acts: <Act>[
                          .fadeIn(),
                          .scale(from: 0),
                          .slideY(from: 0.2),
                        ],
                        child: Container(
                          decoration: BoxDecoration(
                            color: <Color>[
                              Colors.blue[100]!,
                              Colors.purple[100]!,
                              Colors.pink[100]!,
                              Colors.green[100]!,
                              Colors.orange[100]!,
                              Colors.cyan[100]!,
                              Colors.indigo[100]!,
                              Colors.lime[100]!,
                              Colors.amber[100]!,
                            ][index],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _CueSectionCard(
            title: 'Practical Use Cases',
            description: 'Real-world scenarios where Cue animations shine.',
            codeLabel: '',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Cue.onMount(
                  motion: .smooth(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _UseCaseItem(
                        icon: Icons.shopping_cart,
                        title: 'E-commerce Product Cards',
                        description:
                            'Entrance animations + hover scale effects for product grids',
                      ),
                      const SizedBox(height: 12),
                      _UseCaseItem(
                        icon: Icons.chat,
                        title: 'Chat Message Bubbles',
                        description:
                            'Sequential message animations with staggered delays',
                      ),
                      const SizedBox(height: 12),
                      _UseCaseItem(
                        icon: Icons.dashboard,
                        title: 'Dashboard Metrics',
                        description:
                            'Scroll-triggered animations for KPI cards',
                      ),
                      const SizedBox(height: 12),
                      _UseCaseItem(
                        icon: Icons.task_alt,
                        title: 'Todo List Items',
                        description:
                            'Completion animations with checkmark rotations',
                      ),
                      const SizedBox(height: 12),
                      _UseCaseItem(
                        icon: Icons.notifications,
                        title: 'Notification Toasts',
                        description:
                            'Slide-in entrance and fade-out exit animations',
                      ),
                      const SizedBox(height: 12),
                      _UseCaseItem(
                        icon: Icons.menu,
                        title: 'Navigation Drawers',
                        description:
                            'Expandable menu items with reveal animations',
                      ),
                    ],
                  ).act(<Act>[.fadeIn(), .slideY(from: 0.15)]),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _CueSectionCard(
            title: 'Best Practices & Performance',
            description:
                'Guidelines for using Cue effectively and efficiently in production apps.',
            codeLabel: '',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _BestPracticeItem(
                  icon: Icons.check_circle,
                  title: 'Use .smooth() for natural motion',
                  description:
                      'Physics-based curves feel better than linear animations. '
                      'Use `.smooth()` for interactive feedback.',
                ),
                const SizedBox(height: 12),
                _BestPracticeItem(
                  icon: Icons.check_circle,
                  title: 'Leverage Actor for composition',
                  description:
                      'Use Actor to apply multiple acts with delays. '
                      'This creates complex staggered animations without controllers.',
                ),
                const SizedBox(height: 12),
                _BestPracticeItem(
                  icon: Icons.check_circle,
                  title: 'Combine Cue triggers intelligently',
                  description:
                      'Layer multiple Cue triggers (onToggle + onChange) for sophisticated state-driven UX.',
                ),
                const SizedBox(height: 12),
                _BestPracticeItem(
                  icon: Icons.check_circle,
                  title: 'Test on actual devices',
                  description:
                      'Animation performance varies across devices. Always test on both high-end and budget devices.',
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.router.replacePath('/'),
        icon: const Icon(Icons.home),
        label: const Text('Home'),
      ),
    );
  }
}

class _CueSectionCard extends StatelessWidget {
  const _CueSectionCard({
    required this.title,
    required this.description,
    required this.codeLabel,
    required this.child,
  });

  final String title;
  final String description;
  final String codeLabel;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(description, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 16),
            child,
            if (codeLabel.isNotEmpty) ...<Widget>[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Text(
                  codeLabel,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontFamily: 'monospace',
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MountChip extends StatelessWidget {
  const _MountChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _BestPracticeItem extends StatelessWidget {
  const _BestPracticeItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Icon(icon, color: Colors.green, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(description, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActDefinition extends StatelessWidget {
  const _ActDefinition({
    required this.name,
    required this.example,
    required this.description,
  });

  final String name;
  final String example;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            name,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.blue[800],
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              example,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontFamily: 'monospace',
                color: Colors.grey[700],
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(description, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _MotionCurveExample extends StatefulWidget {
  const _MotionCurveExample({
    required this.title,
    required this.description,
    required this.curve,
  });

  final String title;
  final String description;
  final String curve;

  @override
  State<_MotionCurveExample> createState() => _MotionCurveExampleState();
}

class _MotionCurveExampleState extends State<_MotionCurveExample> {
  bool _animate = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _animate = !_animate;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.title,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              widget.description,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            Cue.onToggle(
              toggled: _animate,
              skipFirstAnimation: true,
              motion: widget.curve == 'smooth'
                  ? .smooth()
                  : widget.curve == 'easeInOut'
                  ? .easeInOut(300.ms)
                  : widget.curve == 'easeOut'
                  ? .easeOut(300.ms)
                  : widget.curve == 'easeIn'
                  ? .easeIn(300.ms)
                  : .linear(300.ms),
              child: Container(
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Click to animate',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ).act(<Act>[.slideX(to: 200)]),
            ),
          ],
        ),
      ),
    );
  }
}

class _UseCaseItem extends StatelessWidget {
  const _UseCaseItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.amber[300],
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
