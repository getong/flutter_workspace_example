import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:mai_ui_demo/app/state/travel_scope.dart';
import 'package:mai_ui_demo/core/theme/app_colors.dart';
import 'package:mai_ui_demo/core/widgets/landscape_art.dart';
import 'package:mai_ui_demo/core/widgets/tag.dart';

class TripHero extends StatelessWidget {
  const TripHero({super.key});
  @override
  Widget build(BuildContext context) {
    final days = TravelScope.of(context).daysUntilDeparture;
    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'YOUR NEXT CHAPTER',
          style: TextStyle(
            fontSize: 10,
            color: muted,
            letterSpacing: 2.8,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 14),
        const Text(
          '大理 · 去有风的地方',
          style: TextStyle(
            fontSize: 29,
            height: 1.4,
            color: forest,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            const Tag('云南 · 大理'),
            Tag(
              days > 0
                  ? '距出发还有 $days 天'
                  : days >= -3
                  ? '旅途进行中'
                  : '旅程已结束',
              warm: true,
            ),
          ],
        ),
        const SizedBox(height: 18),
        const Text(
          '2026.10.07 — 10.10',
          style: TextStyle(
            fontSize: 15,
            color: forest,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 3),
        const Text(
          '4 天 3 晚  ·  2 人同行',
          style: TextStyle(fontSize: 12, color: muted),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            FilledButton.icon(
              key: const ValueKey('view-trip'),
              onPressed: () => context.tabsRouter.setActiveIndex(1),
              label: const Text('查看行程'),
              icon: const Icon(Icons.arrow_forward, size: 17),
            ),
            const Spacer(),
            const CircleAvatar(
              radius: 16,
              backgroundColor: paleGreen,
              child: Text('A', style: TextStyle(fontSize: 11, color: forest)),
            ),
            const SizedBox(width: 4),
            const CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xFFF1DBC1),
              child: Text('B', style: TextStyle(fontSize: 11, color: forest)),
            ),
          ],
        ),
      ],
    );
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0E5),
        borderRadius: BorderRadius.circular(24),
      ),
      child: LayoutBuilder(
        builder: (_, constraints) => constraints.maxWidth > 670
            ? Row(
                children: [
                  Expanded(child: text),
                  const SizedBox(width: 30),
                  const Expanded(child: LandscapeArt(height: 290)),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  text,
                  const SizedBox(height: 22),
                  const LandscapeArt(height: 190),
                ],
              ),
      ),
    );
  }
}
