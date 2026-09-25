import 'package:flutter/material.dart';

import 'package:mai_ui_demo/features/trips/models/plan_item.dart';

const plans = [
  [
    PlanItem(
      '09:30',
      '大理古城漫步',
      '约 2 小时',
      '文化体验 · 自由行',
      Icons.temple_buddhist_outlined,
    ),
    PlanItem('14:00', '洱海骑行', '约 2.5 小时', '户外运动 · 自由行', Icons.pedal_bike),
  ],
  [
    PlanItem(
      '08:30',
      '苍山洗马潭',
      '约 4 小时',
      '自然探索 · 索道登山',
      Icons.landscape_outlined,
    ),
    PlanItem(
      '15:00',
      '寂照庵喝茶',
      '约 1.5 小时',
      '山间小憩 · 茶文化',
      Icons.local_cafe_outlined,
    ),
  ],
  [
    PlanItem(
      '09:00',
      '喜洲古镇',
      '约 3 小时',
      '白族文化 · 田野漫步',
      Icons.holiday_village_outlined,
    ),
    PlanItem('15:00', '双廊看日落', '约 2 小时', '湖畔风光 · 摄影', Icons.wb_twilight),
  ],
  [
    PlanItem('09:00', '凤阳邑茶马古道', '约 2 小时', '乡村漫步 · 自由行', Icons.hiking),
    PlanItem(
      '14:30',
      '返程 · 大理站',
      '提前 1 小时到站',
      '高铁出行 · 归途',
      Icons.train_outlined,
    ),
  ],
];
const transfers = [
  '古城 → 洱海 · 5 公里 · 骑行约 40 分钟',
  '洗马潭 → 寂照庵 · 索道下山后打车约 30 分钟',
  '喜洲 → 双廊 · 35 公里 · 驾车约 50 分钟',
  '凤阳邑 → 大理站 · 15 公里 · 驾车约 30 分钟',
];
