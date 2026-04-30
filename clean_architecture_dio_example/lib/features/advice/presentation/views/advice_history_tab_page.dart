import 'dart:math' as math;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/advice.dart';
import '../../domain/repositories/advice_repository.dart';

@RoutePage()
class AdviceHistoryTabPage extends StatefulWidget {
  const AdviceHistoryTabPage({super.key});

  @override
  State<AdviceHistoryTabPage> createState() => _AdviceHistoryTabPageState();
}

class _AdviceHistoryTabPageState extends State<AdviceHistoryTabPage>
    with AutoRouteAwareStateMixin<AdviceHistoryTabPage> {
  static const double _rowHeight = 132;
  static const double _rowGap = 12;
  static const List<_MenuTileData> _leftMenuItems = [
    _MenuTileData(
      topLabel: 'Pinned',
      mainLabel: 'Overview',
      bottomLabel: 'Static menu',
    ),
    _MenuTileData(
      topLabel: 'Pinned',
      mainLabel: 'Recent',
      bottomLabel: 'Static menu',
    ),
    _MenuTileData(
      topLabel: 'Pinned',
      mainLabel: 'Archive',
      bottomLabel: 'Static menu',
    ),
  ];
  static const List<_MenuTileData> _rightMenuItems = [
    _MenuTileData(
      topLabel: 'Action',
      mainLabel: 'Inspect',
      bottomLabel: 'Static menu',
    ),
    _MenuTileData(
      topLabel: 'Action',
      mainLabel: 'Compare',
      bottomLabel: 'Static menu',
    ),
    _MenuTileData(
      topLabel: 'Action',
      mainLabel: 'Bookmark',
      bottomLabel: 'Static menu',
    ),
  ];

  late Future<List<Advice>> _savedAdviceFuture;
  late final ScrollController _centerScrollController;

  @override
  void initState() {
    super.initState();
    _centerScrollController = ScrollController();
    _refreshSavedAdvice();
  }

  @override
  void dispose() {
    _centerScrollController.dispose();
    super.dispose();
  }

  @override
  void didInitTabRoute(TabPageRoute? previousRoute) {
    _refreshSavedAdvice();
  }

  @override
  void didChangeTabRoute(TabPageRoute previousRoute) {
    _refreshSavedAdvice();
  }

  void _refreshSavedAdvice() {
    _savedAdviceFuture = context.read<AdviceRepository>().getSavedAdvice();

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Advice>>(
      future: _savedAdviceFuture,
      builder: (context, snapshot) {
        final items = snapshot.data ?? const <Advice>[];

        if (snapshot.connectionState == ConnectionState.waiting &&
            items.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (items.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'Fetched advice will appear here after it is stored in Drift.',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: _FloatingMenuPanel(
                  title: 'Menu',
                  items: _leftMenuItems,
                  scrollController: _centerScrollController,
                  driftDirection: -1,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 5,
                child: _HistoryColumn(
                  title: 'Advice',
                  controller: _centerScrollController,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return _HistoryAdviceCard(advice: items[index]);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 3,
                child: _FloatingMenuPanel(
                  title: 'Actions',
                  items: _rightMenuItems,
                  scrollController: _centerScrollController,
                  driftDirection: 1,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HistoryColumn extends StatelessWidget {
  final String title;
  final ScrollController controller;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  const _HistoryColumn({
    required this.title,
    required this.controller,
    required this.itemCount,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, right: 4, bottom: 8),
          child: Text(title, style: theme.textTheme.titleMedium),
        ),
        Expanded(
          child: Scrollbar(
            controller: controller,
            thumbVisibility: true,
            child: ListView.separated(
              controller: controller,
              padding: EdgeInsets.zero,
              itemCount: itemCount,
              separatorBuilder: (_, _) =>
                  const SizedBox(height: _AdviceHistoryTabPageState._rowGap),
              itemBuilder: (context, index) => SizedBox(
                height: _AdviceHistoryTabPageState._rowHeight,
                child: itemBuilder(context, index),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FloatingMenuPanel extends StatelessWidget {
  final String title;
  final List<_MenuTileData> items;
  final ScrollController scrollController;
  final double driftDirection;

  const _FloatingMenuPanel({
    required this.title,
    required this.items,
    required this.scrollController,
    required this.driftDirection,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListenableBuilder(
      listenable: scrollController,
      builder: (context, child) {
        final scrollOffset = scrollController.hasClients
            ? scrollController.offset
            : 0.0;

        return LayoutBuilder(
          builder: (context, constraints) {
            const headerHeight = 32.0;
            const itemGap = 12.0;
            final totalGapHeight = itemGap * (items.length - 1);
            final availableHeight =
                constraints.maxHeight - headerHeight - totalGapHeight;
            final itemHeight = (availableHeight / items.length).clamp(
              84.0,
              120.0,
            );
            final headerShift =
                math.sin(scrollOffset / 120) * 6 * driftDirection;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Transform.translate(
                  offset: Offset(0, headerShift),
                  child: SizedBox(
                    height: headerHeight,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 4,
                        right: 4,
                        bottom: 8,
                      ),
                      child: Text(title, style: theme.textTheme.titleMedium),
                    ),
                  ),
                ),
                ...items.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  final verticalDrift =
                      math.sin((scrollOffset / 92) + (index * 0.85)) *
                      (18 + index * 4) *
                      driftDirection;
                  final horizontalDrift =
                      math.cos((scrollOffset / 140) + (index * 0.65)) * 4;
                  final scale =
                      1 + (math.sin((scrollOffset / 180) + index) * 0.012);

                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index == items.length - 1 ? 0 : itemGap,
                    ),
                    child: Transform.translate(
                      offset: Offset(horizontalDrift, verticalDrift),
                      child: Transform.scale(
                        scale: scale,
                        alignment: Alignment.center,
                        child: SizedBox(
                          height: itemHeight,
                          child: _HistoryMenuCard(data: item),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            );
          },
        );
      },
    );
  }
}

class _HistoryAdviceCard extends StatelessWidget {
  final Advice advice;

  const _HistoryAdviceCard({required this.advice});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Advice #${advice.id}', style: theme.textTheme.labelLarge),
            const SizedBox(height: 10),
            Expanded(
              child: Text(
                advice.message,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryMetaCard extends StatelessWidget {
  final String topLabel;
  final String mainLabel;
  final String bottomLabel;

  const _HistoryMetaCard({
    required this.topLabel,
    required this.mainLabel,
    required this.bottomLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              topLabel,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelMedium,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Text(
                mainLabel,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              bottomLabel,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryMenuCard extends StatelessWidget {
  final _MenuTileData data;

  const _HistoryMenuCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return _HistoryMetaCard(
      topLabel: data.topLabel,
      mainLabel: data.mainLabel,
      bottomLabel: data.bottomLabel,
    );
  }
}

class _MenuTileData {
  final String topLabel;
  final String mainLabel;
  final String bottomLabel;

  const _MenuTileData({
    required this.topLabel,
    required this.mainLabel,
    required this.bottomLabel,
  });
}
