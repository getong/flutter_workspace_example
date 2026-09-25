import 'package:flutter/material.dart';

import 'package:mai_ui_demo/core/theme/app_colors.dart';
import 'package:mai_ui_demo/core/widgets/landscape_art.dart';
import 'package:mai_ui_demo/core/widgets/page_body.dart';
import 'package:mai_ui_demo/core/widgets/section_title.dart';
import 'package:mai_ui_demo/core/widgets/surface.dart';
import 'package:mai_ui_demo/core/widgets/tag.dart';
import 'package:mai_ui_demo/features/trips/widgets/booking_row.dart';
import 'package:mai_ui_demo/features/trips/widgets/budget_row.dart';
import 'package:mai_ui_demo/features/trips/widgets/preparation_list.dart';
import 'package:mai_ui_demo/features/trips/widgets/schedule.dart';

class TripsPage extends StatelessWidget {
  const TripsPage({super.key});
  @override
  Widget build(BuildContext context) => PageBody(
    children: [
      const SectionTitle('我的行程', trailing: Tag('即将出发', warm: true)),
      const Text(
        '大理 · 去有风的地方',
        style: TextStyle(
          fontSize: 27,
          fontWeight: FontWeight.w700,
          color: forest,
        ),
      ),
      const SizedBox(height: 8),
      const Text(
        '2026.10.07 — 10.10   /   4 天 3 晚 · 两人同行',
        style: TextStyle(color: muted, fontSize: 12),
      ),
      const SizedBox(height: 20),
      const LandscapeArt(height: 180),
      const SizedBox(height: 24),
      const Surface(child: Schedule()),
      const SizedBox(height: 26),
      const SectionTitle('预订与预算', trailing: Tag('已预订 2/3')),
      const Surface(
        child: Column(
          children: [
            BookingRow(
              icon: Icons.hotel_outlined,
              title: '洱海边 · 风居客栈',
              detail: '10.07 入住 · 10.10 离店 · 3 晚',
              amount: '¥2,040',
              status: '已预订',
            ),
            Divider(height: 30),
            BookingRow(
              icon: Icons.train_outlined,
              title: '往返高铁',
              detail: '双人交通预算 · 出发前核对车次',
              amount: '¥520',
              status: '已确认',
            ),
            Divider(height: 30),
            BookingRow(
              icon: Icons.confirmation_number_outlined,
              title: '景点门票',
              detail: '待确认具体景点与游玩时段',
              amount: '¥80',
              status: '待预订',
            ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      const Surface(
        child: Column(
          children: [
            BudgetRow('行程预算', '¥3,600'),
            SizedBox(height: 10),
            BudgetRow('已安排 · 交通与住宿', '¥2,560'),
            Divider(height: 28),
            BudgetRow('剩余可用', '¥1,040'),
          ],
        ),
      ),
      const SizedBox(height: 12),
      const Text(
        '预订信息为本地示例记录，出发前请在实际预订平台核对。',
        style: TextStyle(color: muted, fontSize: 11),
      ),
      const SizedBox(height: 26),
      const PreparationList(),
    ],
  );
}
