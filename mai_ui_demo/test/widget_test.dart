import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mai_ui_demo/app/travel_app.dart';
import 'package:mai_ui_demo/app/state/travel_store.dart';

Future<TravelStore> launch(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  SharedPreferences.setMockInitialValues({});
  final store = TravelStore(await SharedPreferences.getInstance());
  await tester.pumpWidget(TravelApp(store: store));
  await tester.pumpAndSettle();
  return store;
}

Future<void> tab(WidgetTester tester, String label) async {
  await tester.tap(
    find.descendant(of: find.byType(NavigationBar), matching: find.text(label)),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets(
    'auto_route tabs, itinerary days and destination back navigation',
    (tester) async {
      await launch(tester, const Size(1100, 900));
      await tester.tap(find.byKey(const ValueKey('view-trip')));
      await tester.pumpAndSettle();
      expect(find.text('我的行程'), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('day-1')));
      await tester.pumpAndSettle();
      expect(find.text('苍山洗马潭'), findsOneWidget);
      expect(find.text('大理古城漫步'), findsNothing);
      await tab(tester, '收藏');
      expect(find.text('收藏目的地'), findsOneWidget);
      await tester.tap(find.text('沙溪古镇'));
      await tester.pumpAndSettle();
      expect(find.text('古镇人文'), findsOneWidget);
      await tester.tap(find.byTooltip('返回'));
      await tester.pumpAndSettle();
      expect(find.text('收藏目的地'), findsOneWidget);
      await tab(tester, '我的');
      expect(find.text('旅行者小A'), findsOneWidget);
      await tab(tester, '首页');
      expect(find.text('苍山洗马潭'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'favorites, checklist, profile changes survive store recreation',
    (tester) async {
      final store = await launch(tester, const Size(1100, 1100));
      await tab(tester, '收藏');
      await tester.tap(find.byKey(const ValueKey('save-shaxi')));
      await tester.pumpAndSettle();
      expect(find.text('沙溪古镇'), findsNothing);
      await tester.enterText(find.byKey(const ValueKey('saved-search')), '不存在');
      await tester.pumpAndSettle();
      expect(find.text('没有找到相关目的地'), findsOneWidget);
      await tab(tester, '首页');
      await tester.ensureVisible(find.byKey(const ValueKey('prep-2')));
      await tester.tap(find.byKey(const ValueKey('prep-2')));
      await tester.pumpAndSettle();
      expect(find.text('3/3 已完成'), findsOneWidget);
      await tab(tester, '我的');
      await tester.tap(find.byTooltip('编辑资料'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), '');
      await tester.tap(find.text('保存'));
      await tester.pumpAndSettle();
      expect(find.text('请输入昵称'), findsOneWidget);
      await tester.enterText(find.byType(TextField), '小风');
      await tester.tap(find.text('保存'));
      await tester.pumpAndSettle();
      expect(find.text('小风'), findsOneWidget);
      final restored = TravelStore(store.preferences);
      expect(restored.saved, {'lijiang'});
      expect(restored.completed, 3);
      expect(restored.name, '小风');
      expect(tester.takeException(), isNull);
    },
  );

  for (final width in [320.0, 390.0, 1100.0]) {
    testWidgets('all tabs fit at width $width', (tester) async {
      await launch(tester, Size(width, 844));
      for (final label in ['首页', '行程', '收藏', '我的']) {
        await tab(tester, label);
        expect(tester.takeException(), isNull);
        await tester.drag(
          find.byType(SingleChildScrollView).first,
          const Offset(0, -1600),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      }
    });
  }
}
