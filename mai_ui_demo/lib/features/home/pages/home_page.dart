import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:mai_ui_demo/app/state/travel_scope.dart';
import 'package:mai_ui_demo/core/theme/app_colors.dart';
import 'package:mai_ui_demo/core/widgets/page_body.dart';
import 'package:mai_ui_demo/core/widgets/section_title.dart';
import 'package:mai_ui_demo/core/widgets/surface.dart';
import 'package:mai_ui_demo/features/destinations/data/destination_data.dart';
import 'package:mai_ui_demo/features/destinations/widgets/destination_card.dart';
import 'package:mai_ui_demo/features/home/widgets/metrics.dart';
import 'package:mai_ui_demo/features/home/widgets/trip_hero.dart';
import 'package:mai_ui_demo/features/trips/widgets/preparation_list.dart';
import 'package:mai_ui_demo/features/trips/widgets/schedule.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    final store = TravelScope.of(context);
    return PageBody(
      children: [
        Row(
          children: [
            const Icon(Icons.explore_outlined, color: forest, size: 30),
            const SizedBox(width: 10),
            const Text(
              '远行',
              style: TextStyle(
                fontSize: 24,
                color: forest,
                fontWeight: FontWeight.w800,
                letterSpacing: 3,
              ),
            ),
            const Spacer(),
            IconButton(
              tooltip: '我的资料',
              onPressed: () => context.tabsRouter.setActiveIndex(3),
              icon: const CircleAvatar(
                radius: 17,
                backgroundColor: paleGreen,
                child: Text('我', style: TextStyle(fontSize: 12, color: forest)),
              ),
            ),
            IconButton(
              tooltip: '通知',
              onPressed: () {
                store.readNotifications();
                context.router.root.pushPath('/notifications');
              },
              icon: Badge(
                isLabelVisible: store.unread && store.notifications,
                backgroundColor: orange,
                smallSize: 7,
                child: const Icon(Icons.notifications_none, color: forest),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          '早安，旅行者。下一段美好，即将出发。',
          style: TextStyle(color: muted, fontSize: 12),
        ),
        const SizedBox(height: 24),
        const TripHero(),
        const SizedBox(height: 18),
        const Metrics(),
        const SizedBox(height: 30),
        LayoutBuilder(
          builder: (context, constraints) {
            final aside = Column(
              children: [
                SectionTitle(
                  '沿途灵感',
                  trailing: TextButton(
                    onPressed: () => context.tabsRouter.setActiveIndex(2),
                    child: const Text('全部收藏 →'),
                  ),
                ),
                DestinationCard(destinations.first),
                const SizedBox(height: 26),
                const Surface(child: PreparationList()),
              ],
            );
            if (constraints.maxWidth >= 760) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(child: Surface(child: Schedule())),
                  const SizedBox(width: 26),
                  Expanded(child: aside),
                ],
              );
            }
            return Column(
              children: [const Schedule(), const SizedBox(height: 30), aside],
            );
          },
        ),
        const SizedBox(height: 26),
        const Center(
          child: Text(
            '把日子交给风，把回忆留给自己。',
            style: TextStyle(fontSize: 11, color: muted, letterSpacing: 1),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
