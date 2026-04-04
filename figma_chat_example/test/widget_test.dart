import 'package:figma_chat_example/src/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders login screen by default', (tester) async {
    await tester.pumpWidget(const FigmaChatApp());

    expect(find.text('Welcome Back'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text('Sign up'), findsOneWidget);
  });
}
