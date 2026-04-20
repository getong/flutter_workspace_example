import 'dart:math' as math;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:loot_reel/loot_reel.dart';

class _LootDrop {
  const _LootDrop({
    required this.name,
    required this.rarity,
    required this.color,
    required this.weight,
  });

  final String name;
  final String rarity;
  final Color color;
  final double weight;

  bool get isLegendary => rarity == 'Legendary';
}

const List<String> _starterPool = <String>[
  'P250 Sand Dune',
  'USP-S Cortex',
  'AK-47 Neon Rider',
  'AWP Asiimov',
  'Sticker Capsule',
];

const List<_LootDrop> _weightedPool = <_LootDrop>[
  _LootDrop(
    name: 'P250 Sand Dune',
    rarity: 'Common',
    color: Color(0xFF64748B),
    weight: 35,
  ),
  _LootDrop(
    name: 'USP-S Cortex',
    rarity: 'Rare',
    color: Color(0xFF2563EB),
    weight: 18,
  ),
  _LootDrop(
    name: 'AK-47 Neon Rider',
    rarity: 'Epic',
    color: Color(0xFF9333EA),
    weight: 8,
  ),
  _LootDrop(
    name: 'AWP Asiimov',
    rarity: 'Epic',
    color: Color(0xFFF97316),
    weight: 5,
  ),
  _LootDrop(
    name: 'Karambit Fade',
    rarity: 'Legendary',
    color: Color(0xFFFACC15),
    weight: 1.2,
  ),
  _LootDrop(
    name: 'Sport Gloves Vice',
    rarity: 'Legendary',
    color: Color(0xFFFB7185),
    weight: 0.5,
  ),
];

@RoutePage()
class LootReelPage extends StatefulWidget {
  const LootReelPage({super.key});

  @override
  State<LootReelPage> createState() => _LootReelPageState();
}

class _LootReelPageState extends State<LootReelPage> {
  final LootReelController _starterController = LootReelController();
  final LootReelController _weightedController = LootReelController();
  final LootReelController _customController = LootReelController();
  final math.Random _random = math.Random();

  late final LootReelDropTable<_LootDrop> _dropTable =
      LootReelDropTable<_LootDrop>(
        _weightedPool.map(
          (_LootDrop item) =>
              LootReelDrop<_LootDrop>(value: item, weight: item.weight),
        ),
      );

  String _starterWinner = _starterPool[2];
  String _starterSummary = 'Ready to spin a default reel.';
  _LootDrop _weightedWinner = _weightedPool[0];
  String _weightedSummary =
      'Weighted demo uses itemWeightBuilder and reelItemFilter.';
  _LootDrop _customWinner = _weightedPool[3];
  String _customSummary =
      'Custom itemBuilder demo highlights tile state changes.';
  List<String> _eventLog = <String>[
    'Idle: spin any reel to inspect callbacks.',
  ];

  Future<void> _spinStarter({String? forcedWinner}) async {
    if (_starterController.isSpinning) {
      return;
    }

    final String nextWinner =
        forcedWinner ?? _starterPool[_random.nextInt(_starterPool.length)];

    setState(() {
      _starterWinner = nextWinner;
      _starterSummary =
          'Current winner is "$nextWinner". The default builder renders simple text cards.';
    });

    await WidgetsBinding.instance.endOfFrame;
    await _starterController.spin();
  }

  Future<void> _spinWeighted({_LootDrop? forcedWinner}) async {
    if (_weightedController.isSpinning) {
      return;
    }

    final _LootDrop nextWinner = forcedWinner ?? _dropTable.pick(_random);

    setState(() {
      _weightedWinner = nextWinner;
      _weightedSummary =
          'Winner "${nextWinner.name}" came from LootReelDropTable.pick() '
          'and the reel uses weights plus a premium-item filter.';
    });

    await WidgetsBinding.instance.endOfFrame;
    await _weightedController.spin();
  }

  Future<void> _spinCustom({_LootDrop? forcedWinner}) async {
    if (_customController.isSpinning) {
      return;
    }

    final List<_LootDrop> nonLegendary = _weightedPool
        .where((_LootDrop item) => !item.isLegendary)
        .toList(growable: false);
    final _LootDrop nextWinner =
        forcedWinner ?? nonLegendary[_random.nextInt(nonLegendary.length)];

    setState(() {
      _customWinner = nextWinner;
      _customSummary =
          'Custom reel set winner to "${nextWinner.name}" and uses LootReelSpinCurve(power: 10).';
    });

    await WidgetsBinding.instance.endOfFrame;
    await _customController.spin();
  }

  void _appendEvent(String message) {
    final DateTime time = DateTime.now();
    final String stamp =
        '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}:'
        '${time.second.toString().padLeft(2, '0')}';

    setState(() {
      _eventLog = <String>['$stamp  $message', ..._eventLog].take(8).toList();
    });
  }

  bool _nonWinningFilter(_LootDrop item, _LootDrop winner) {
    return !item.isLegendary;
  }

  Widget _buildCustomDropTile(
    BuildContext context,
    _LootDrop item,
    LootReelTileState state,
  ) {
    final ThemeData theme = Theme.of(context);
    final bool isWinner = state != LootReelTileState.idle;
    final bool isFocused = state == LootReelTileState.focusedWinner;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            item.color.withValues(alpha: isFocused ? 0.96 : 0.76),
            const Color(0xFF101217),
          ],
        ),
        border: Border.all(
          color: isWinner
              ? Colors.white
              : theme.colorScheme.outline.withValues(alpha: 0.25),
          width: isFocused ? 2.2 : 1,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            blurRadius: isFocused ? 22 : 12,
            offset: const Offset(0, 10),
            color: item.color.withValues(alpha: isFocused ? 0.30 : 0.14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.20),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              item.rarity.toUpperCase(),
              style: theme.textTheme.labelSmall?.copyWith(
                letterSpacing: 1.1,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          const Spacer(),
          Icon(Icons.auto_awesome, color: Colors.white.withValues(alpha: 0.90)),
          const SizedBox(height: 8),
          Text(
            item.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              height: 1.05,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final _LootDrop legendaryItem = _weightedPool.firstWhere(
      (_LootDrop item) => item.isLegendary,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('loot_reel Module')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: <Widget>[
          Text(
            'Build CS-style case opening reels with a deterministic winner slot.',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'This page demonstrates the main `loot_reel` API surface: '
            '`LootReel`, `LootReelController`, `LootReelDropTable`, '
            '`LootReelDrop`, `itemWeightBuilder`, `reelItemFilter`, '
            '`itemBuilder`, `labelBuilder`, `indicator`, and '
            '`LootReelSpinCurve`.',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          const _CodeSampleCard(
            title: 'Default reel',
            code: r'''
final controller = LootReelController();

LootReel<String>(
  controller: controller,
  items: ['P250', 'USP-S', 'AK-47'],
  winner: 'AK-47',
);

await controller.spin();
''',
          ),
          const SizedBox(height: 16),
          const _CodeSampleCard(
            title: 'Weighted reel with premium filtering',
            code: r'''
final dropTable = LootReelDropTable<Item>(
  items.map((item) => LootReelDrop(
        value: item,
        weight: item.weight,
      )),
);

LootReel<Item>(
  controller: controller,
  items: items,
  winner: dropTable.pick(),
  itemWeightBuilder: (item) => item.weight,
  reelItemFilter: (item, winner) => !item.isLegendary,
  labelBuilder: (item) => item.name,
);
''',
          ),
          const SizedBox(height: 24),
          _SectionCard(
            title: 'Demo A: Default string cards',
            description:
                'Use the built-in tile UI for simple string data. This also shows that the winner can be injected even when it does not already exist inside `items`.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 156,
                  child: LootReel<String>(
                    controller: _starterController,
                    items: _starterPool,
                    winner: _starterWinner,
                    spinDuration: const Duration(milliseconds: 3200),
                    onSpinStart: () {
                      _appendEvent('Default reel started spinning.');
                    },
                    onSpinEnd: (String winner) {
                      _appendEvent('Default reel ended on "$winner".');
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Text(_starterSummary, style: theme.textTheme.bodyMedium),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: <Widget>[
                    FilledButton.icon(
                      onPressed: _starterController.isSpinning
                          ? null
                          : () => _spinStarter(),
                      icon: const Icon(Icons.casino_outlined),
                      label: const Text('Spin Random Winner'),
                    ),
                    OutlinedButton.icon(
                      onPressed: _starterController.isSpinning
                          ? null
                          : () =>
                                _spinStarter(forcedWinner: 'Knife | Sapphire'),
                      icon: const Icon(Icons.auto_awesome_outlined),
                      label: const Text('Inject Hidden Winner'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _SectionCard(
            title: 'Demo B: Weighted drops and filtered premium items',
            description:
                'This reel uses `LootReelDropTable` to choose a winner, `itemWeightBuilder` to shape reel composition, and `reelItemFilter` so legendary items only appear when they are actually the result.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 160,
                  child: LootReel<_LootDrop>(
                    controller: _weightedController,
                    items: _weightedPool,
                    winner: _weightedWinner,
                    labelBuilder: (_LootDrop item) => item.name,
                    itemWeightBuilder: (_LootDrop item) => item.weight,
                    reelItemFilter: _nonWinningFilter,
                    itemExtent: 148,
                    itemSpacing: 10,
                    spinDuration: const Duration(milliseconds: 4200),
                    onSpinStart: () {
                      _appendEvent(
                        'Weighted reel started. Winner seed: ${_weightedWinner.name}.',
                      );
                    },
                    onSpinEnd: (_LootDrop winner) {
                      _appendEvent(
                        'Weighted reel ended on ${winner.name} (${winner.rarity}).',
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _weightedPool
                      .map(
                        (_LootDrop item) => Chip(
                          avatar: CircleAvatar(backgroundColor: item.color),
                          label: Text('${item.name}  x${item.weight}'),
                        ),
                      )
                      .toList(growable: false),
                ),
                const SizedBox(height: 16),
                Text(_weightedSummary, style: theme.textTheme.bodyMedium),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: <Widget>[
                    FilledButton.icon(
                      onPressed: _weightedController.isSpinning
                          ? null
                          : () => _spinWeighted(),
                      icon: const Icon(Icons.casino),
                      label: const Text('Spin Weighted Winner'),
                    ),
                    OutlinedButton.icon(
                      onPressed: _weightedController.isSpinning
                          ? null
                          : () => _spinWeighted(forcedWinner: legendaryItem),
                      icon: const Icon(Icons.workspace_premium_outlined),
                      label: const Text('Force Legendary'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _SectionCard(
            title: 'Demo C: Custom tile builder and indicator',
            description:
                'Use `itemBuilder` to react to `LootReelTileState.idle`, `.winner`, and `.focusedWinner`. This version also customizes `indicator`, `itemExtent`, `itemSpacing`, `height`, `repeatCount`, and the spin curve.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                LootReel<_LootDrop>(
                  controller: _customController,
                  items: _weightedPool,
                  winner: _customWinner,
                  itemBuilder: _buildCustomDropTile,
                  itemWeightBuilder: (_LootDrop item) => item.weight,
                  indicator: const _DiamondIndicator(),
                  itemExtent: 156,
                  itemSpacing: 12,
                  repeatCount: 24,
                  height: 190,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  curve: const LootReelSpinCurve(power: 10),
                  spinDuration: const Duration(milliseconds: 4600),
                  onSpinStart: () {
                    _appendEvent(
                      'Custom reel started. Focus target: ${_customWinner.name}.',
                    );
                  },
                  onSpinEnd: (_LootDrop winner) {
                    _appendEvent(
                      'Custom reel focused ${winner.name} with a custom indicator.',
                    );
                  },
                ),
                const SizedBox(height: 16),
                Text(_customSummary, style: theme.textTheme.bodyMedium),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: <Widget>[
                    FilledButton.icon(
                      onPressed: _customController.isSpinning
                          ? null
                          : () => _spinCustom(),
                      icon: const Icon(Icons.animation_outlined),
                      label: const Text('Spin Styled Reel'),
                    ),
                    OutlinedButton.icon(
                      onPressed: _customController.isSpinning
                          ? null
                          : () => _spinCustom(forcedWinner: _weightedPool[4]),
                      icon: const Icon(Icons.star_outline),
                      label: const Text('Force Legendary Finish'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _SectionCard(
            title: 'Callback log',
            description:
                'Spin callbacks are useful for disabling buttons, tracking analytics, or opening follow-up dialogs after a result resolves.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _eventLog
                  .map(
                    (String item) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(item, style: theme.textTheme.bodyMedium),
                    ),
                  )
                  .toList(growable: false),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.description,
    required this.child,
  });

  final String title;
  final String description;
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
            const SizedBox(height: 8),
            Text(description, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 20),
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
                color: const Color(0xFF111827),
                borderRadius: BorderRadius.circular(16),
              ),
              child: SelectionArea(
                child: Text(
                  code,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFFE5E7EB),
                    fontFamily: 'monospace',
                    height: 1.5,
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

class _DiamondIndicator extends StatelessWidget {
  const _DiamondIndicator();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 18,
          height: 18,
          transform: Matrix4.rotationZ(math.pi / 4),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: <Color>[Color(0xFFFDE68A), Color(0xFFF97316)],
            ),
            borderRadius: BorderRadius.circular(4),
            boxShadow: <BoxShadow>[
              BoxShadow(
                blurRadius: 20,
                color: const Color(0xFFF59E0B).withValues(alpha: 0.45),
              ),
            ],
          ),
        ),
        Container(
          width: 4,
          height: 92,
          margin: const EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFFBBF24),
            borderRadius: BorderRadius.circular(999),
          ),
        ),
      ],
    );
  }
}
