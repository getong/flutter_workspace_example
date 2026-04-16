import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

class _SwipeShowcaseItem {
  const _SwipeShowcaseItem({
    required this.title,
    required this.subtitle,
    required this.accent,
    required this.icon,
    required this.tags,
  });

  final String title;
  final String subtitle;
  final Color accent;
  final IconData icon;
  final List<String> tags;
}

class _DirectionFact {
  const _DirectionFact({
    required this.direction,
    required this.description,
    required this.color,
  });

  final CardSwiperDirection direction;
  final String description;
  final Color color;
}

const List<_SwipeShowcaseItem> _discoveryDeck = <_SwipeShowcaseItem>[
  _SwipeShowcaseItem(
    title: 'Product Designer',
    subtitle: 'Swipe a launch-ready profile with portfolio highlights.',
    accent: Color(0xFF2563EB),
    icon: Icons.palette_outlined,
    tags: <String>['Figma', 'Design systems', 'Motion'],
  ),
  _SwipeShowcaseItem(
    title: 'Mobile Engineer',
    subtitle: 'A candidate card with technical strengths and stack badges.',
    accent: Color(0xFF0F766E),
    icon: Icons.phone_android_outlined,
    tags: <String>['Flutter', 'BLoC', 'Animations'],
  ),
  _SwipeShowcaseItem(
    title: 'Growth Analyst',
    subtitle: 'Show a different content style without changing the deck API.',
    accent: Color(0xFF7C3AED),
    icon: Icons.auto_graph_outlined,
    tags: <String>['SQL', 'Dashboards', 'Experiments'],
  ),
  _SwipeShowcaseItem(
    title: 'Operations Lead',
    subtitle: 'Top, bottom, left, and right all map to custom outcomes.',
    accent: Color(0xFFEA580C),
    icon: Icons.hub_outlined,
    tags: <String>['Runbooks', 'Incident flow', 'SLAs'],
  ),
  _SwipeShowcaseItem(
    title: 'Content Strategist',
    subtitle: 'Loop the deck and keep three cards visible for depth.',
    accent: Color(0xFFDC2626),
    icon: Icons.edit_note_outlined,
    tags: <String>['CMS', 'SEO', 'Campaigns'],
  ),
];

const List<_SwipeShowcaseItem> _planningDeck = <_SwipeShowcaseItem>[
  _SwipeShowcaseItem(
    title: 'Backlog Grooming',
    subtitle: 'This deck only accepts left and right swipes.',
    accent: Color(0xFF1D4ED8),
    icon: Icons.view_kanban_outlined,
    tags: <String>['Horizontal only', 'Threshold', 'MoveTo'],
  ),
  _SwipeShowcaseItem(
    title: 'Sprint Review',
    subtitle: 'Drag right to trigger undo because undoDirection is right.',
    accent: Color(0xFF047857),
    icon: Icons.event_repeat_outlined,
    tags: <String>['UndoDirection.right', 'showBackCardOnUndo'],
  ),
  _SwipeShowcaseItem(
    title: 'Launch Checklist',
    subtitle: 'Lock the swiper to demo isDisabled and onTapDisabled.',
    accent: Color(0xFF9333EA),
    icon: Icons.lock_outline,
    tags: <String>['isDisabled', 'onTapDisabled', 'Controller'],
  ),
  _SwipeShowcaseItem(
    title: 'Post Launch Cleanup',
    subtitle: 'Jump directly to a card with CardSwiperController.moveTo.',
    accent: Color(0xFFC2410C),
    icon: Icons.route_outlined,
    tags: <String>['moveTo', 'Controller events', 'Callbacks'],
  ),
];

const List<_SwipeShowcaseItem> _presetDeck = <_SwipeShowcaseItem>[
  _SwipeShowcaseItem(
    title: 'Inbox Triage',
    subtitle:
        'Swap between all, horizontal, vertical, mixed, and locked rules.',
    accent: Color(0xFF0369A1),
    icon: Icons.inbox_outlined,
    tags: <String>['AllowedSwipeDirection', 'Presets', 'ChoiceChip'],
  ),
  _SwipeShowcaseItem(
    title: 'Priority Review',
    subtitle:
        'Controller buttons can still drive the deck while gestures are disabled.',
    accent: Color(0xFF15803D),
    icon: Icons.playlist_add_check_circle_outlined,
    tags: <String>['isDisabled', 'Controller', 'Programmatic swipe'],
  ),
  _SwipeShowcaseItem(
    title: 'Escalation Routing',
    subtitle: 'Send a card diagonally with a custom 45-degree swipe direction.',
    accent: Color(0xFF9333EA),
    icon: Icons.north_east_outlined,
    tags: <String>['CardSwiperDirection.custom', 'angle', 'name'],
  ),
  _SwipeShowcaseItem(
    title: 'Compliance Hold',
    subtitle: 'Use undo and direction-change callbacks to audit card state.',
    accent: Color(0xFFB45309),
    icon: Icons.policy_outlined,
    tags: <String>['Undo', 'Callbacks', 'Telemetry'],
  ),
];

enum _SwipePreset { all, horizontal, vertical, mixed, locked }

final CardSwiperDirection _topRightDirection = CardSwiperDirection.custom(
  45,
  name: 'top-right',
);

final List<_DirectionFact> _directionFacts = <_DirectionFact>[
  _DirectionFact(
    direction: CardSwiperDirection.top,
    description: 'Built-in vertical direction for upward dismissal.',
    color: Color(0xFF2563EB),
  ),
  _DirectionFact(
    direction: CardSwiperDirection.right,
    description: 'Built-in horizontal direction for accept or approve flows.',
    color: Color(0xFF047857),
  ),
  _DirectionFact(
    direction: CardSwiperDirection.bottom,
    description: 'Built-in vertical direction for snooze or defer actions.',
    color: Color(0xFFDC2626),
  ),
  _DirectionFact(
    direction: CardSwiperDirection.left,
    description: 'Built-in horizontal direction for reject or archive actions.',
    color: Color(0xFF7C3AED),
  ),
  _DirectionFact(
    direction: _topRightDirection,
    description: 'A custom angle with a readable name and helper methods.',
    color: Color(0xFFEA580C),
  ),
];

@RoutePage(name: 'FlutterCardSwiperRoute')
class FlutterCardSwiperPage extends StatefulWidget {
  const FlutterCardSwiperPage({super.key});

  @override
  State<FlutterCardSwiperPage> createState() => _FlutterCardSwiperPageState();
}

class _FlutterCardSwiperPageState extends State<FlutterCardSwiperPage> {
  final CardSwiperController _discoveryController = CardSwiperController();
  final CardSwiperController _planningController = CardSwiperController();
  final CardSwiperController _presetController = CardSwiperController();
  List<String> _eventLog = <String>[];
  String _directionStatus = 'horizontal: none, vertical: none';
  String _presetDirectionStatus = 'horizontal: none, vertical: none';
  bool _planningLocked = false;
  int _planningTopIndex = 1;
  int _presetTopIndex = 0;
  _SwipePreset _preset = _SwipePreset.all;

  @override
  void dispose() {
    _discoveryController.dispose();
    _planningController.dispose();
    _presetController.dispose();
    super.dispose();
  }

  void _recordEvent(String message) {
    final TimeOfDay time = TimeOfDay.now();
    final String stamp =
        '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}';

    setState(() {
      _eventLog = <String>['$stamp  $message', ..._eventLog].take(10).toList();
    });
  }

  void _showNotice(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  bool _onDiscoverySwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  ) {
    _recordEvent(
      'Discovery deck swiped ${_discoveryDeck[previousIndex].title} '
      'to ${direction.name}; next index: ${currentIndex ?? 'none'}',
    );
    return true;
  }

  bool _onDiscoveryUndo(
    int? previousIndex,
    int currentIndex,
    CardSwiperDirection direction,
  ) {
    _recordEvent(
      'Discovery undo restored ${_discoveryDeck[currentIndex].title} '
      'from ${direction.name}',
    );
    return true;
  }

  bool _onPlanningSwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  ) {
    setState(() {
      _planningTopIndex = currentIndex ?? _planningTopIndex;
    });
    _recordEvent(
      'Planning deck moved ${_planningDeck[previousIndex].title} '
      'to ${direction.name}',
    );
    return true;
  }

  bool _onPlanningUndo(
    int? previousIndex,
    int currentIndex,
    CardSwiperDirection direction,
  ) {
    setState(() {
      _planningTopIndex = currentIndex;
    });
    _recordEvent(
      'Planning undo restored ${_planningDeck[currentIndex].title} '
      'from ${direction.name}',
    );
    return true;
  }

  void _movePlanningDeckTo(int index) {
    _planningController.moveTo(index);
    setState(() {
      _planningTopIndex = index;
    });
    _recordEvent('Planning controller moved to index $index');
  }

  AllowedSwipeDirection get _activePresetDirection {
    return switch (_preset) {
      _SwipePreset.all => const AllowedSwipeDirection.all(),
      _SwipePreset.horizontal => const AllowedSwipeDirection.symmetric(
        horizontal: true,
      ),
      _SwipePreset.vertical => const AllowedSwipeDirection.symmetric(
        vertical: true,
      ),
      _SwipePreset.mixed => const AllowedSwipeDirection.only(
        up: true,
        right: true,
      ),
      _SwipePreset.locked => const AllowedSwipeDirection.none(),
    };
  }

  String get _presetLabel {
    return switch (_preset) {
      _SwipePreset.all => 'All directions',
      _SwipePreset.horizontal => 'Horizontal only',
      _SwipePreset.vertical => 'Vertical only',
      _SwipePreset.mixed => 'Up + right only',
      _SwipePreset.locked => 'Locked gestures',
    };
  }

  String _formatAllowedDirections(AllowedSwipeDirection direction) {
    final List<String> allowed = <String>[
      if (direction.up) 'up',
      if (direction.right) 'right',
      if (direction.down) 'down',
      if (direction.left) 'left',
    ];
    return allowed.isEmpty ? 'none' : allowed.join(', ');
  }

  void _setPreset(_SwipePreset preset) {
    setState(() {
      _preset = preset;
      _presetDirectionStatus = 'horizontal: none, vertical: none';
    });
    _recordEvent('Preset demo switched to $_presetLabel');
  }

  bool _onPresetSwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  ) {
    setState(() {
      _presetTopIndex = currentIndex ?? _presetTopIndex;
    });
    _recordEvent(
      'Preset deck moved ${_presetDeck[previousIndex].title} '
      'to ${direction.name} (${direction.angle.toStringAsFixed(0)}°)',
    );
    return true;
  }

  bool _onPresetUndo(
    int? previousIndex,
    int currentIndex,
    CardSwiperDirection direction,
  ) {
    setState(() {
      _presetTopIndex = currentIndex;
    });
    _recordEvent(
      'Preset undo restored ${_presetDeck[currentIndex].title} '
      'from ${direction.name}',
    );
    return true;
  }

  void _swipePreset(CardSwiperDirection direction) {
    _presetController.swipe(direction);
    _recordEvent(
      'Preset controller requested ${direction.name} '
      '(${direction.angle.toStringAsFixed(0)}°)',
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('flutter_card_swiper Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            Text(
              'Build Tinder-style swipe flows in Flutter',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'This module demonstrates `CardSwiper`, '
              '`CardSwiperController`, `AllowedSwipeDirection`, '
              '`CardSwiperDirection`, and `UndoDirection` with practical, '
              'interactive examples, direction presets, and custom-angle '
              'swipes rather than a single minimal snippet.',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            const _CodeSampleCard(
              title: 'Basic deck',
              code: '''
CardSwiper(
  cardsCount: cards.length,
  cardBuilder: (
    context,
    index,
    horizontalThresholdPercentage,
    verticalThresholdPercentage,
  ) {
    return cards[index];
  },
)
''',
            ),
            const SizedBox(height: 16),
            const _CodeSampleCard(
              title: 'Controller and callbacks',
              code: r'''
final controller = CardSwiperController();

CardSwiper(
  controller: controller,
  numberOfCardsDisplayed: 3,
  onSwipe: (previousIndex, currentIndex, direction) {
    debugPrint('Swiped to ${direction.name}');
    return true;
  },
  onUndo: (previousIndex, currentIndex, direction) => true,
  cardBuilder: (context, index, h, v) => MyCard(index: index),
)

controller.swipe(CardSwiperDirection.right);
controller.undo();
controller.moveTo(2);
''',
            ),
            const SizedBox(height: 16),
            const _CodeSampleCard(
              title: 'Direction and undo configuration',
              code: r'''
CardSwiper(
  allowedSwipeDirection: const AllowedSwipeDirection.only(
    left: true,
    right: true,
  ),
  showBackCardOnUndo: true,
  undoDirection: UndoDirection.right,
  threshold: 35,
  maxAngle: 12,
  onTapDisabled: () => debugPrint('Deck is locked'),
  onSwipeDirectionChange: (horizontal, vertical) {
    debugPrint('${horizontal.name} / ${vertical.name}');
  },
  cardBuilder: (context, index, h, v) => MyCard(index: index),
  cardsCount: 4,
)
''',
            ),
            const SizedBox(height: 16),
            const _CodeSampleCard(
              title: 'Preset constructors',
              code: r'''
final horizontalOnly = AllowedSwipeDirection.symmetric(horizontal: true);
final verticalOnly = AllowedSwipeDirection.symmetric(vertical: true);
final lockedGestures = AllowedSwipeDirection.none();

CardSwiper(
  allowedSwipeDirection: horizontalOnly,
  isDisabled: false,
  cardsCount: cards.length,
  cardBuilder: (context, index, h, v) => cards[index],
)
''',
            ),
            const SizedBox(height: 16),
            const _CodeSampleCard(
              title: 'Custom direction objects',
              code: r'''
final topRight = CardSwiperDirection.custom(45, name: 'top-right');

controller.swipe(topRight);
debugPrint(topRight.name); // top-right
debugPrint('${topRight.angle}'); // 45.0
debugPrint('${topRight.isHorizontal} / ${topRight.isVertical}');
debugPrint(
  '${topRight.isCloseTo(CardSwiperDirection.right, tolerance: 50)}',
);
''',
            ),
            const SizedBox(height: 24),
            _SectionCard(
              title: 'Exported API highlights',
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: const <Widget>[
                  _ApiPill(
                    title: 'CardSwiper',
                    subtitle: 'Main widget for the stacked swipe deck.',
                    color: Color(0xFF2563EB),
                  ),
                  _ApiPill(
                    title: 'CardSwiperController',
                    subtitle:
                        'Trigger `swipe`, `undo`, and `moveTo` externally.',
                    color: Color(0xFF0F766E),
                  ),
                  _ApiPill(
                    title: 'AllowedSwipeDirection',
                    subtitle: 'Use `.all`, `.only`, `.symmetric`, or `.none`.',
                    color: Color(0xFF7C3AED),
                  ),
                  _ApiPill(
                    title: 'CardSwiperDirection',
                    subtitle:
                        'Read callback state or create custom angles in code.',
                    color: Color(0xFFEA580C),
                  ),
                  _ApiPill(
                    title: 'UndoDirection',
                    subtitle:
                        'Choose which swipe direction should restore cards.',
                    color: Color(0xFFDC2626),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Direction helpers and custom angles',
              description:
                  'The package exports direction objects, helper getters, and '
                  '`AllowedSwipeDirection` constructors you can reuse outside '
                  'the widget tree.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _directionFacts.map((_DirectionFact fact) {
                      return _DirectionFactCard(fact: fact);
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withValues(
                        alpha: 0.45,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Preset constructors: '
                      'const AllowedSwipeDirection.all(), '
                      'const AllowedSwipeDirection.only(...), '
                      'const AllowedSwipeDirection.symmetric(...), '
                      'const AllowedSwipeDirection.none().',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Live Demo A: Multi-direction discovery deck',
              description:
                  'This example uses looping, multiple visible back cards, '
                  'controller buttons, and swipe/undo callbacks.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 430,
                    child: CardSwiper(
                      controller: _discoveryController,
                      cardsCount: _discoveryDeck.length,
                      numberOfCardsDisplayed: 3,
                      backCardOffset: const Offset(0, 28),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 12,
                      ),
                      onSwipe: _onDiscoverySwipe,
                      onUndo: _onDiscoveryUndo,
                      onEnd: () {
                        _recordEvent('Discovery deck reached the end.');
                      },
                      cardBuilder:
                          (
                            BuildContext context,
                            int index,
                            int horizontalThresholdPercentage,
                            int verticalThresholdPercentage,
                          ) {
                            return _SwiperPreviewCard(
                              item: _discoveryDeck[index],
                              horizontalThresholdPercentage:
                                  horizontalThresholdPercentage,
                              verticalThresholdPercentage:
                                  verticalThresholdPercentage,
                              footer:
                                  'Looping deck with controller-driven swipe buttons.',
                            );
                          },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: <Widget>[
                      FilledButton.icon(
                        onPressed: _discoveryController.undo,
                        icon: const Icon(Icons.undo),
                        label: const Text('Undo'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {
                          _discoveryController.swipe(CardSwiperDirection.left);
                        },
                        icon: const Icon(Icons.keyboard_arrow_left),
                        label: const Text('Swipe Left'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {
                          _discoveryController.swipe(CardSwiperDirection.right);
                        },
                        icon: const Icon(Icons.keyboard_arrow_right),
                        label: const Text('Swipe Right'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {
                          _discoveryController.swipe(CardSwiperDirection.top);
                        },
                        icon: const Icon(Icons.keyboard_arrow_up),
                        label: const Text('Swipe Up'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {
                          _discoveryController.swipe(
                            CardSwiperDirection.bottom,
                          );
                        },
                        icon: const Icon(Icons.keyboard_arrow_down),
                        label: const Text('Swipe Down'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Live Demo B: Direction rules, undo mode, and moveTo',
              description:
                  'This deck restricts gestures to horizontal swipes, shows the '
                  'undo back card, and can be locked or repositioned by code.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withValues(
                        alpha: 0.45,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 8,
                      children: <Widget>[
                        Text('Top index: $_planningTopIndex'),
                        Text('Locked: ${_planningLocked ? 'yes' : 'no'}'),
                        Text(_directionStatus),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 410,
                    child: CardSwiper(
                      controller: _planningController,
                      cardsCount: _planningDeck.length,
                      initialIndex: 1,
                      isLoop: false,
                      isDisabled: _planningLocked,
                      threshold: 35,
                      maxAngle: 12,
                      scale: 0.93,
                      numberOfCardsDisplayed: 2,
                      backCardOffset: const Offset(0, 22),
                      showBackCardOnUndo: true,
                      undoDirection: UndoDirection.right,
                      undoSwipeThreshold: 70,
                      allowedSwipeDirection: const AllowedSwipeDirection.only(
                        left: true,
                        right: true,
                      ),
                      onTapDisabled: () {
                        _showNotice('Deck is locked. Unlock or use moveTo.');
                      },
                      onSwipeDirectionChange:
                          (
                            CardSwiperDirection horizontalDirection,
                            CardSwiperDirection verticalDirection,
                          ) {
                            setState(() {
                              _directionStatus =
                                  'horizontal: ${horizontalDirection.name}, '
                                  'vertical: ${verticalDirection.name}';
                            });
                          },
                      onSwipe: _onPlanningSwipe,
                      onUndo: _onPlanningUndo,
                      onEnd: () {
                        _recordEvent('Planning deck reached the end.');
                      },
                      cardBuilder:
                          (
                            BuildContext context,
                            int index,
                            int horizontalThresholdPercentage,
                            int verticalThresholdPercentage,
                          ) {
                            return _SwiperPreviewCard(
                              item: _planningDeck[index],
                              horizontalThresholdPercentage:
                                  horizontalThresholdPercentage,
                              verticalThresholdPercentage:
                                  verticalThresholdPercentage,
                              footer:
                                  'Horizontal-only deck with right-swipe undo mode.',
                            );
                          },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: <Widget>[
                      FilledButton.icon(
                        onPressed: () {
                          setState(() {
                            _planningLocked = !_planningLocked;
                          });
                          _recordEvent(
                            'Planning deck ${_planningLocked ? 'locked' : 'unlocked'}',
                          );
                        },
                        icon: Icon(
                          _planningLocked
                              ? Icons.lock_open
                              : Icons.lock_outline,
                        ),
                        label: Text(
                          _planningLocked ? 'Unlock Swipes' : 'Lock Swipes',
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: _planningController.undo,
                        icon: const Icon(Icons.undo),
                        label: const Text('Undo'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {
                          _planningController.swipe(CardSwiperDirection.left);
                        },
                        icon: const Icon(Icons.chevron_left),
                        label: const Text('Reject'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {
                          _planningController.swipe(CardSwiperDirection.right);
                        },
                        icon: const Icon(Icons.chevron_right),
                        label: const Text('Approve'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: List<Widget>.generate(_planningDeck.length, (
                      int index,
                    ) {
                      return ActionChip(
                        label: Text('moveTo($index)'),
                        onPressed: () => _movePlanningDeckTo(index),
                      );
                    }),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Live Demo C: Presets, disabled input, and custom swipe',
              description:
                  'This deck swaps between `AllowedSwipeDirection` presets, '
                  'shows a fully locked gesture state, and triggers a custom '
                  '45-degree swipe with the controller.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withValues(
                        alpha: 0.45,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 8,
                      children: <Widget>[
                        Text('Preset: $_presetLabel'),
                        Text(
                          'Allowed: ${_formatAllowedDirections(_activePresetDirection)}',
                        ),
                        Text('Top index: $_presetTopIndex'),
                        Text(_presetDirectionStatus),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: _SwipePreset.values.map((_SwipePreset preset) {
                      final String label = switch (preset) {
                        _SwipePreset.all => 'All',
                        _SwipePreset.horizontal => 'Horizontal',
                        _SwipePreset.vertical => 'Vertical',
                        _SwipePreset.mixed => 'Up + Right',
                        _SwipePreset.locked => 'Locked',
                      };
                      return ChoiceChip(
                        label: Text(label),
                        selected: _preset == preset,
                        onSelected: (bool selected) {
                          if (selected) {
                            _setPreset(preset);
                          }
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 400,
                    child: CardSwiper(
                      controller: _presetController,
                      cardsCount: _presetDeck.length,
                      isDisabled: _preset == _SwipePreset.locked,
                      duration: const Duration(milliseconds: 320),
                      threshold: 32,
                      maxAngle: 18,
                      scale: 0.92,
                      numberOfCardsDisplayed: 2,
                      backCardOffset: const Offset(0, 24),
                      allowedSwipeDirection: _activePresetDirection,
                      onTapDisabled: () {
                        _showNotice(
                          'Gestures are locked. Controller buttons still work.',
                        );
                      },
                      onSwipeDirectionChange:
                          (
                            CardSwiperDirection horizontalDirection,
                            CardSwiperDirection verticalDirection,
                          ) {
                            setState(() {
                              _presetDirectionStatus =
                                  'horizontal: ${horizontalDirection.name}, '
                                  'vertical: ${verticalDirection.name}';
                            });
                          },
                      onSwipe: _onPresetSwipe,
                      onUndo: _onPresetUndo,
                      onEnd: () {
                        _recordEvent('Preset deck reached the end.');
                      },
                      cardBuilder:
                          (
                            BuildContext context,
                            int index,
                            int horizontalThresholdPercentage,
                            int verticalThresholdPercentage,
                          ) {
                            return _SwiperPreviewCard(
                              item: _presetDeck[index],
                              horizontalThresholdPercentage:
                                  horizontalThresholdPercentage,
                              verticalThresholdPercentage:
                                  verticalThresholdPercentage,
                              footer:
                                  '$_presetLabel preset with controller support for diagonal swipes.',
                            );
                          },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: <Widget>[
                      FilledButton.icon(
                        onPressed: _presetController.undo,
                        icon: const Icon(Icons.undo),
                        label: const Text('Undo'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {
                          _swipePreset(CardSwiperDirection.left);
                        },
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Left'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {
                          _swipePreset(CardSwiperDirection.right);
                        },
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text('Right'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {
                          _swipePreset(CardSwiperDirection.top);
                        },
                        icon: const Icon(Icons.arrow_upward),
                        label: const Text('Up'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {
                          _swipePreset(CardSwiperDirection.bottom);
                        },
                        icon: const Icon(Icons.arrow_downward),
                        label: const Text('Down'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {
                          _swipePreset(_topRightDirection);
                        },
                        icon: const Icon(Icons.north_east),
                        label: const Text('45° Custom'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Use the Locked preset to verify that drag gestures stop '
                    'while `CardSwiperController.swipe(...)` continues to work.',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Recent callback log',
              child: _EventLogPanel(events: _eventLog),
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

class _DirectionFactCard extends StatelessWidget {
  const _DirectionFactCard({required this.fact});

  final _DirectionFact fact;

  @override
  Widget build(BuildContext context) {
    final CardSwiperDirection direction = fact.direction;

    return Container(
      width: 260,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: fact.color.withValues(alpha: 0.10),
        border: Border.all(color: fact.color.withValues(alpha: 0.22)),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '${direction.name} (${direction.angle.toStringAsFixed(0)}°)',
            style: TextStyle(color: fact.color, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(fact.description),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              _PropertyBadge(
                label: 'horizontal: ${direction.isHorizontal}',
                color: fact.color,
              ),
              _PropertyBadge(
                label: 'vertical: ${direction.isVertical}',
                color: fact.color,
              ),
              _PropertyBadge(
                label:
                    'close to right (50°): '
                    '${direction.isCloseTo(CardSwiperDirection.right, tolerance: 50)}',
                color: fact.color,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SwiperPreviewCard extends StatelessWidget {
  const _SwiperPreviewCard({
    required this.item,
    required this.horizontalThresholdPercentage,
    required this.verticalThresholdPercentage,
    required this.footer,
  });

  final _SwipeShowcaseItem item;
  final int horizontalThresholdPercentage;
  final int verticalThresholdPercentage;
  final String footer;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              item.accent.withValues(alpha: 0.98),
              item.accent.withValues(alpha: 0.72),
              Colors.black.withValues(alpha: 0.90),
            ],
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(item.icon, color: Colors.white),
                ),
                const Spacer(),
                _MetricBadge(
                  label: 'H $horizontalThresholdPercentage%',
                  color: Colors.white.withValues(alpha: 0.14),
                ),
                const SizedBox(width: 8),
                _MetricBadge(
                  label: 'V $verticalThresholdPercentage%',
                  color: Colors.white.withValues(alpha: 0.14),
                ),
              ],
            ),
            const SizedBox(height: 22),
            Text(
              item.title,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              item.subtitle,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: Colors.white.withValues(alpha: 0.88),
                height: 1.45,
              ),
            ),
            const SizedBox(height: 18),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: item.tags.map((String tag) {
                return Chip(
                  label: Text(tag),
                  side: BorderSide.none,
                  backgroundColor: Colors.white.withValues(alpha: 0.14),
                  labelStyle: const TextStyle(color: Colors.white),
                );
              }).toList(),
            ),
            const Spacer(),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                footer,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.92),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PropertyBadge extends StatelessWidget {
  const _PropertyBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label),
    );
  }
}

class _MetricBadge extends StatelessWidget {
  const _MetricBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.child,
    this.description,
  });

  final String title;
  final String? description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            if (description case final String description) ...<Widget>[
              const SizedBox(height: 8),
              Text(description, style: theme.textTheme.bodyMedium),
            ],
            const SizedBox(height: 18),
            child,
          ],
        ),
      ),
    );
  }
}

class _CodeSampleCard extends StatelessWidget {
  const _CodeSampleCard({required this.title, required this.code});

  final String title;
  final String code;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.65,
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                code.trim(),
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontFamily: 'monospace',
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ApiPill extends StatelessWidget {
  const _ApiPill({
    required this.title,
    required this.subtitle,
    required this.color,
  });

  final String title;
  final String subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        border: Border.all(color: color.withValues(alpha: 0.22)),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(color: color, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(subtitle),
        ],
      ),
    );
  }
}

class _EventLogPanel extends StatelessWidget {
  const _EventLogPanel({required this.events});

  final List<String> events;

  @override
  Widget build(BuildContext context) {
    final List<String> displayEvents = events.isEmpty
        ? const <String>[
            'No callbacks yet. Swipe or use the controller buttons above.',
          ]
        : events;

    return Column(
      children: displayEvents.map((String entry) {
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(entry),
        );
      }).toList(),
    );
  }
}
