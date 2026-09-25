import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:mai_ui_demo/app/state/travel_scope.dart';
import 'package:mai_ui_demo/core/theme/app_colors.dart';
import 'package:mai_ui_demo/core/widgets/landscape_art.dart';
import 'package:mai_ui_demo/core/widgets/page_body.dart';
import 'package:mai_ui_demo/core/widgets/section_title.dart';
import 'package:mai_ui_demo/core/widgets/surface.dart';
import 'package:mai_ui_demo/core/widgets/tag.dart';
import 'package:mai_ui_demo/features/destinations/data/destination_data.dart';
import 'package:mai_ui_demo/features/destinations/widgets/destination_card.dart';

class SavedPage extends StatefulWidget {
  const SavedPage({super.key});
  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  String query = '';
  @override
  Widget build(BuildContext context) {
    final store = TravelScope.of(context);
    final items = destinations
        .where(
          (d) =>
              store.saved.contains(d.id) &&
              '${d.name}${d.category}'.contains(query.trim()),
        )
        .toList();
    return PageBody(
      children: [
        SectionTitle('收藏目的地', trailing: Tag('${store.saved.length} 个心动地点')),
        const Text('先收藏心动，再把它变成出发。', style: TextStyle(color: muted)),
        const SizedBox(height: 22),
        TextField(
          key: const ValueKey('saved-search'),
          onChanged: (value) => setState(() => query = value),
          decoration: const InputDecoration(
            hintText: '搜索目的地或分类',
            prefixIcon: Icon(Icons.search),
          ),
        ),
        const SizedBox(height: 24),
        if (items.isEmpty)
          Surface(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  const Icon(Icons.favorite_border, size: 42, color: orange),
                  const SizedBox(height: 16),
                  Text(query.isNotEmpty ? '没有找到相关目的地' : '还没有收藏目的地'),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () => context.tabsRouter.setActiveIndex(0),
                    child: const Text('去首页发现灵感 →'),
                  ),
                ],
              ),
            ),
          ),
        for (final destination in items) ...[
          DestinationCard(destination),
          const SizedBox(height: 16),
        ],
        const SizedBox(height: 24),
        const Text(
          '心愿地图',
          style: TextStyle(
            color: forest,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          '从大理出发，沿着山与湖慢慢探索云南。',
          style: TextStyle(color: muted, fontSize: 12),
        ),
        const SizedBox(height: 16),
        const LandscapeArt(village: true),
      ],
    );
  }
}
