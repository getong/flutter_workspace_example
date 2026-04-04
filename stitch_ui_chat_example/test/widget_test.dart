import 'package:flutter_test/flutter_test.dart';

import 'package:stitch_ui_chat_example/app.dart';

void main() {
  testWidgets('renders login screen', (tester) async {
    await tester.pumpWidget(const StitchChatApp());
    await tester.pumpAndSettle();

    expect(find.text('Welcome Back'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text('Create Account'), findsOneWidget);
  });
}
