import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:mai_ui_demo/app/state/travel_scope.dart';
import 'package:mai_ui_demo/core/theme/app_colors.dart';
import 'package:mai_ui_demo/core/widgets/landscape_art.dart';
import 'package:mai_ui_demo/core/widgets/page_body.dart';
import 'package:mai_ui_demo/core/widgets/section_title.dart';
import 'package:mai_ui_demo/core/widgets/tag.dart';
import 'package:mai_ui_demo/features/destinations/data/destination_data.dart';

class DestinationPage extends StatelessWidget {
  const DestinationPage({super.key, required this.id});
  final String id;
  @override
  Widget build(BuildContext context) {
    final destination = destinations.where((d) => d.id == id).firstOrNull;
    final store = TravelScope.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(destination?.name ?? '目的地不存在'),
        leading: IconButton(
          tooltip: '返回',
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.router.back(),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: destination == null
              ? const Center(child: Text('没有找到这个目的地，请返回重新选择。'))
              : PageBody(
                  children: [
                    const LandscapeArt(village: true, height: 280),
                    const SizedBox(height: 24),
                    SectionTitle(
                      destination.name,
                      trailing: Tag(destination.category),
                    ),
                    Text(
                      destination.subtitle,
                      style: const TextStyle(fontSize: 18, color: muted),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '★ ${destination.rating}     人均 ¥${destination.price}',
                      style: const TextStyle(color: orange, fontSize: 17),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      destination.description,
                      style: const TextStyle(height: 1.9),
                    ),
                    const SizedBox(height: 28),
                    FilledButton.icon(
                      onPressed: () => store.toggleSaved(id),
                      icon: Icon(
                        store.saved.contains(id)
                            ? Icons.favorite
                            : Icons.favorite_border,
                      ),
                      label: Text(
                        store.saved.contains(id) ? '已收藏 · 点击取消' : '收藏目的地',
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      '目的地资料为演示参考，出行前请核对开放时间和实际费用。',
                      style: TextStyle(fontSize: 11, color: muted),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
