import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:widget_layout_example2/app_bootstrap.dart';
import 'package:widget_layout_example2/auto_route_demo_support.dart';

void main() {
  patrolTest(
    'login, open choice chip demo, and logout',
    config: const PatrolTesterConfig(
      settleTimeout: Duration(seconds: 20),
      visibleTimeout: Duration(seconds: 20),
    ),
    ($) async {
      demoAuthController.logout();

      await $.pumpWidgetAndSettle(createWidgetLayoutApp());

      expect($(const Key('login.username')), findsOneWidget);
      expect($(const Key('login.password')), findsOneWidget);
      expect($(const Key('login.submit')), findsOneWidget);

      await $(const Key('login.username')).enterText('gerald');
      await $(const Key('login.password')).enterText('secret');
      await $(const Key('login.submit')).tap();

      expect($(const Key('home.activeTabTitle')), findsOneWidget);
      expect($(const Key('home.activeTabTitle')).text, 'Layout Modules');

      await $('Content').tap();
      expect($(const Key('home.activeTabTitle')).text, 'Content Modules');

      await $(const Key('module.ChoiceChip Module')).tap();

      expect($('ChoiceChip Module'), findsOneWidget);
      expect(
        $(const Key('choiceChip.selectedFramework')).text,
        'Selected framework: auto_route',
      );

      await $(const Key('choiceChip.framework.go_router')).tap();
      expect(
        $(const Key('choiceChip.selectedFramework')).text,
        'Selected framework: go_router',
      );

      await $(const Key('choiceChip.theme.Sunset')).tap();
      expect(
        $(const Key('choiceChip.activeTheme')).$('Active theme preset: Sunset'),
        findsOneWidget,
      );

      await $(const Key('choiceChip.homeFab')).tap();
      expect($(const Key('home.activeTabTitle')).text, 'Content Modules');

      await $(const Key('home.logout')).tap();
      expect($(const Key('login.username')), findsOneWidget);
      expect($(const Key('login.password')), findsOneWidget);
    },
  );
}
