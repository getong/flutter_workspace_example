import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:widget_layout_example2/auto_route_demo_support.dart';
import 'package:widget_layout_example2/auth/auth.dart';
import 'package:widget_layout_example2/main.dart';

void main() {
  testWidgets('Login gates the app before showing the home tabs', (
    WidgetTester tester,
  ) async {
    Future<void> dragUntilTextVisible(String text) async {
      for (int i = 0; i < 20; i += 1) {
        if (find.text(text).evaluate().isNotEmpty) {
          return;
        }

        await tester.drag(find.byType(ListView).last, const Offset(0, -300));
        await tester.pumpAndSettle();
      }
    }

    demoAuthController.logout();

    await tester.pumpWidget(
      BlocProvider<AppAuthBloc>.value(value: appAuthBloc, child: MyApp()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Username'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);

    await tester.enterText(find.byType(TextField).at(0), 'gerald');
    await tester.enterText(find.byType(TextField).at(1), 'secret');
    await tester.tap(find.text('Log In'));
    await tester.pumpAndSettle();

    expect(find.text('Layout Modules'), findsOneWidget);
    expect(find.byTooltip('Logout'), findsOneWidget);
    expect(find.text('Center Box Module'), findsOneWidget);
    await dragUntilTextVisible('Constrained Box Module');
    expect(find.text('Constrained Box Module'), findsOneWidget);
    expect(find.text('Layout'), findsOneWidget);
    expect(find.text('Content'), findsOneWidget);
    expect(find.text('Animation'), findsOneWidget);

    await tester.tap(find.text('Content'));
    await tester.pumpAndSettle();

    expect(find.text('Content Modules'), findsOneWidget);
    expect(find.text('auto_route Module'), findsOneWidget);
    await dragUntilTextVisible('cue Module');
    expect(find.text('cue Module'), findsOneWidget);
    await dragUntilTextVisible('encrypter_plus Module');
    expect(find.text('encrypter_plus Module'), findsOneWidget);
    await dragUntilTextVisible('flutter_bloc Module');
    expect(find.text('flutter_bloc Module'), findsOneWidget);
    await dragUntilTextVisible('flutter_dotenv Module');
    expect(find.text('flutter_dotenv Module'), findsOneWidget);
    await dragUntilTextVisible('flutter_hooks Module');
    expect(find.text('flutter_hooks Module'), findsOneWidget);
    await dragUntilTextVisible('flutter_tts Module');
    expect(find.text('flutter_tts Module'), findsOneWidget);
    await dragUntilTextVisible('fluttertoast Module');
    expect(find.text('fluttertoast Module'), findsOneWidget);
    await dragUntilTextVisible('freezed_annotation Module');
    expect(find.text('freezed_annotation Module'), findsOneWidget);
    await dragUntilTextVisible('FutureBuilder Module');
    expect(find.text('FutureBuilder Module'), findsOneWidget);
    await dragUntilTextVisible('introduction_screen Module');
    expect(find.text('introduction_screen Module'), findsOneWidget);
    await dragUntilTextVisible('Intl Module');
    expect(find.text('Intl Module'), findsOneWidget);
    await dragUntilTextVisible('json_annotation Module');
    expect(find.text('json_annotation Module'), findsOneWidget);
    await dragUntilTextVisible('open_file Module');
    expect(find.text('open_file Module'), findsOneWidget);
    await dragUntilTextVisible('permission_handler Module');
    expect(find.text('permission_handler Module'), findsOneWidget);
    await dragUntilTextVisible('Semantics Module');
    expect(find.text('Semantics Module'), findsOneWidget);
    await dragUntilTextVisible('speech_to_text Module');
    expect(find.text('speech_to_text Module'), findsOneWidget);
    await dragUntilTextVisible('StreamBuilder Module');
    expect(find.text('StreamBuilder Module'), findsOneWidget);
    await dragUntilTextVisible('Text.rich Module');
    expect(find.text('Text.rich Module'), findsOneWidget);
    await dragUntilTextVisible('url_launcher Module');
    expect(find.text('url_launcher Module'), findsOneWidget);
    await dragUntilTextVisible('webview_flutter Module');
    expect(find.text('webview_flutter Module'), findsOneWidget);

    await tester.tap(find.text('Animation'));
    await tester.pumpAndSettle();

    expect(find.text('Animation Modules'), findsOneWidget);
    expect(find.text('AnimatedSwitcher Module'), findsOneWidget);
    expect(find.text('AnimatedDefaultTextStyle Module'), findsOneWidget);
    expect(find.text('CustomPaint Module'), findsOneWidget);

    await tester.tap(find.byTooltip('Logout'));
    await tester.pumpAndSettle();

    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Username'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
  });
}
