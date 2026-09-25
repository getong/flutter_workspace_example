import 'package:flutter/material.dart';

import 'package:mai_ui_demo/app/state/travel_scope.dart';
import 'package:mai_ui_demo/core/theme/app_colors.dart';
import 'package:mai_ui_demo/core/widgets/section_title.dart';

class PreparationList extends StatelessWidget {
  const PreparationList({super.key});
  @override
  Widget build(BuildContext context) {
    final store = TravelScope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          '出发前准备',
          trailing: Text(
            '${store.completed}/3 已完成',
            style: const TextStyle(fontSize: 12, color: muted),
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: store.completed / 3,
            minHeight: 6,
            color: orange,
            backgroundColor: line,
          ),
        ),
        const SizedBox(height: 14),
        for (var i = 0; i < 3; i++)
          CheckboxListTile(
            key: ValueKey('prep-$i'),
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            value: store.preparations[i],
            onChanged: (_) => store.togglePreparation(i),
            title: Text(
              ['交通方式', '住宿安排', '行李整理'][i],
              style: const TextStyle(fontSize: 14),
            ),
            secondary: Text(
              store.preparations[i] ? '已完成' : '待完成',
              style: TextStyle(
                fontSize: 12,
                color: store.preparations[i] ? forest : orange,
              ),
            ),
          ),
      ],
    );
  }
}
