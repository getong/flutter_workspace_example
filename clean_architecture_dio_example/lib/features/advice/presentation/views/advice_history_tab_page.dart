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
      icon: Icons.dashboard_outlined,
      topLabel: 'Pinned',
      mainLabel: 'Overview',
      bottomLabel: 'Static menu',
    ),
    _MenuTileData(
      icon: Icons.access_time_outlined,
      topLabel: 'Pinned',
      mainLabel: 'Recent',
      bottomLabel: 'Static menu',
    ),
    _MenuTileData(
      icon: Icons.archive_outlined,
      topLabel: 'Pinned',
      mainLabel: 'Archive',
      bottomLabel: 'Static menu',
    ),
  ];
  static const List<_MenuTileData> _rightMenuItems = [
    _MenuTileData(
      icon: Icons.search,
      topLabel: 'Action',
      mainLabel: 'Inspect',
      bottomLabel: 'Static menu',
    ),
    _MenuTileData(
      icon: Icons.compare_outlined,
      topLabel: 'Action',
      mainLabel: 'Compare',
      bottomLabel: 'Static menu',
    ),
    _MenuTileData(
      icon: Icons.bookmark_outline,
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 2,
                child: _FloatingMenuPanel(title: 'Menu', items: _leftMenuItems),
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

  const _FloatingMenuPanel({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 12),
            child: Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: items
                  .map((item) => _HistoryMenuCard(data: item))
                  .toList(),
            ),
          ),
        ],
      ),
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
              child: SingleChildScrollView(
                child: Text(advice.message, style: theme.textTheme.bodyLarge),
              ),
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
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(data.icon, size: 20, color: theme.colorScheme.primary),
          const SizedBox(height: 4),
          Text(
            data.mainLabel,
            style: theme.textTheme.labelMedium,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            data.bottomLabel,
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _MenuTileData {
  final IconData icon;
  final String topLabel;
  final String mainLabel;
  final String bottomLabel;

  const _MenuTileData({
    required this.icon,
    required this.topLabel,
    required this.mainLabel,
    required this.bottomLabel,
  });
}
