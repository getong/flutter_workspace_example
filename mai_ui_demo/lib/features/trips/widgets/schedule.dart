import 'package:flutter/material.dart';

import 'package:mai_ui_demo/app/state/travel_scope.dart';
import 'package:mai_ui_demo/core/theme/app_colors.dart';
import 'package:mai_ui_demo/core/widgets/section_title.dart';
import 'package:mai_ui_demo/core/widgets/tag.dart';
import 'package:mai_ui_demo/features/trips/data/itinerary_data.dart';

class Schedule extends StatelessWidget {
  const Schedule({super.key});
  @override
  Widget build(BuildContext context) {
    final store = TravelScope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          '每日安排',
          trailing: Text(
            '10 月 ${7 + store.day} 日',
            style: const TextStyle(color: muted, fontSize: 12),
          ),
        ),
        Row(
          children: List.generate(
            4,
            (i) => Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: i == 3 ? 0 : 8),
                child: Semantics(
                  selected: store.day == i,
                  child: TextButton(
                    key: ValueKey('day-$i'),
                    style: TextButton.styleFrom(
                      backgroundColor: store.day == i
                          ? forest
                          : paleGreen.withValues(alpha: .5),
                      foregroundColor: store.day == i ? Colors.white : forest,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => store.selectDay(i),
                    child: Text('Day ${i + 1}'),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 22),
        for (var i = 0; i < plans[store.day].length; i++) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 48,
                child: Padding(
                  padding: const EdgeInsets.only(top: 14),
                  child: Text(
                    plans[store.day][i].time,
                    style: const TextStyle(fontSize: 12, color: muted),
                  ),
                ),
              ),
              Container(
                width: 45,
                height: 48,
                margin: const EdgeInsets.only(right: 14),
                decoration: BoxDecoration(
                  color: paleGreen,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(plans[store.day][i].icon, color: forest),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plans[store.day][i].title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: forest,
                      ),
                    ),
                    Text(
                      plans[store.day][i].category,
                      style: const TextStyle(fontSize: 12, color: muted),
                    ),
                    const SizedBox(height: 6),
                    Tag(plans[store.day][i].duration),
                  ],
                ),
              ),
            ],
          ),
          if (i == 0)
            Padding(
              padding: const EdgeInsets.fromLTRB(59, 14, 0, 16),
              child: Text(
                '↳  ${transfers[store.day]}',
                style: const TextStyle(fontSize: 11, color: muted),
              ),
            ),
        ],
      ],
    );
  }
}
