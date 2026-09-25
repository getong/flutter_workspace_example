import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:mai_ui_demo/app/state/travel_scope.dart';
import 'package:mai_ui_demo/core/theme/app_colors.dart';
import 'package:mai_ui_demo/core/widgets/landscape_art.dart';
import 'package:mai_ui_demo/core/widgets/surface.dart';
import 'package:mai_ui_demo/features/destinations/models/destination.dart';

class DestinationCard extends StatelessWidget {
  const DestinationCard(this.destination, {super.key});
  final Destination destination;
  @override
  Widget build(BuildContext context) {
    final store = TravelScope.of(context);
    final saved = store.saved.contains(destination.id);
    return Surface(
      padding: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () =>
            context.router.root.pushPath('/destination/${destination.id}'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const SizedBox(
                width: 78,
                child: LandscapeArt(village: true, height: 100),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      destination.name,
                      style: const TextStyle(
                        color: forest,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      destination.subtitle,
                      style: const TextStyle(color: muted, fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 10,
                      children: [
                        Text(
                          '★ ${destination.rating}',
                          style: const TextStyle(
                            color: orange,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '¥${destination.price} / 人',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                key: ValueKey('save-${destination.id}'),
                tooltip: saved
                    ? '取消收藏${destination.name}'
                    : '收藏${destination.name}',
                onPressed: () => store.toggleSaved(destination.id),
                icon: Icon(
                  saved ? Icons.favorite : Icons.favorite_border,
                  color: orange,
                  size: 22,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
