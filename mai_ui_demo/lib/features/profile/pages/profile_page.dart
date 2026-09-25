import 'package:flutter/material.dart';

import 'package:mai_ui_demo/app/state/travel_scope.dart';
import 'package:mai_ui_demo/core/theme/app_colors.dart';
import 'package:mai_ui_demo/core/widgets/page_body.dart';
import 'package:mai_ui_demo/core/widgets/section_title.dart';
import 'package:mai_ui_demo/core/widgets/surface.dart';
import 'package:mai_ui_demo/core/widgets/tag.dart';
import 'package:mai_ui_demo/features/profile/widgets/edit_name_dialog.dart';
import 'package:mai_ui_demo/features/trips/widgets/budget_row.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    final store = TravelScope.of(context);
    return PageBody(
      children: [
        const SectionTitle('我的'),
        const SizedBox(height: 14),
        Row(
          children: [
            const CircleAvatar(
              radius: 35,
              backgroundColor: paleGreen,
              child: Icon(Icons.person_outline, size: 36, color: forest),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    store.name,
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w700,
                      color: forest,
                    ),
                  ),
                  const Text(
                    '山川湖海，都是生活的另一面。',
                    style: TextStyle(fontSize: 12, color: muted),
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: '编辑资料',
              onPressed: () => showDialog<void>(
                context: context,
                builder: (_) => EditNameDialog(store: store),
              ),
              icon: const Icon(Icons.edit_outlined, size: 20),
            ),
          ],
        ),
        const SizedBox(height: 28),
        Surface(
          child: Row(
            children: [
              for (final stat in [
                ('1', '行程'),
                ('4', '计划天数'),
                ('${store.saved.length}', '收藏地点'),
              ])
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        stat.$1,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: forest,
                        ),
                      ),
                      Text(
                        stat.$2,
                        style: const TextStyle(fontSize: 12, color: muted),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        const SectionTitle('旅行搭子'),
        const Surface(
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Color(0xFFF1DBC1),
                child: Text('B', style: TextStyle(color: forest)),
              ),
              SizedBox(width: 16),
              Expanded(child: Text('小B\n一起去有风的地方')),
              Tag('已确认'),
            ],
          ),
        ),
        const SizedBox(height: 28),
        const SectionTitle('旅行账本'),
        const Surface(
          child: Column(
            children: [
              BudgetRow('计划总预算', '¥3,600'),
              SizedBox(height: 14),
              BudgetRow('已安排', '¥2,560'),
              SizedBox(height: 14),
              BudgetRow('剩余预算', '¥1,040'),
            ],
          ),
        ),
        const SizedBox(height: 28),
        const SectionTitle('偏好设置'),
        Surface(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Column(
            children: [
              SwitchListTile(
                title: const Text('行程提醒', style: TextStyle(fontSize: 14)),
                subtitle: const Text(
                  '显示应用内提醒标记',
                  style: TextStyle(fontSize: 12),
                ),
                value: store.notifications,
                onChanged: store.setNotifications,
              ),
              ListTile(
                leading: const Icon(Icons.info_outline, color: forest),
                title: const Text('关于远行', style: TextStyle(fontSize: 14)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => showAboutDialog(
                  context: context,
                  applicationName: '远行',
                  applicationVersion: '1.0.0',
                  children: [
                    const Text(
                      '记录旅行灵感，规划每一天。\n当前为离线演示，收藏、清单与资料保存在本机。天气、评分和价格均为参考稿示例。',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
