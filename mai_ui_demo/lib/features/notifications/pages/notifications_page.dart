import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:mai_ui_demo/core/theme/app_colors.dart';
import 'package:mai_ui_demo/core/widgets/page_body.dart';
import 'package:mai_ui_demo/core/widgets/surface.dart';
import 'package:mai_ui_demo/core/widgets/tag.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('旅行提醒'),
      leading: IconButton(
        tooltip: '返回',
        icon: const Icon(Icons.arrow_back),
        onPressed: () => context.router.back(),
      ),
    ),
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760),
        child: const PageBody(
          children: [
            Surface(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Tag('出发准备', warm: true),
                  SizedBox(height: 16),
                  Text(
                    '大理的风，在等你',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: forest,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text('10 月 7 日出发前，记得核对车次、住宿信息，带好证件、防晒用品和薄外套。'),
                  SizedBox(height: 16),
                  Text(
                    '在首页或行程页勾选准备清单，轻装出发。',
                    style: TextStyle(color: muted, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
