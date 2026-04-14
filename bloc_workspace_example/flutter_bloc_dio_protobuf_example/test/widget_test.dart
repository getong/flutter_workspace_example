import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_bloc_dio_protobuf_example/main.dart';

void main() {
  testWidgets('sends a protobuf message and renders the mocked response', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MyApp(
        repository: MessageRepository(dio: buildDioClient()),
      ),
    );

    expect(find.text('Send Message'), findsOneWidget);
    expect(
      find.text('Tap the button to send a protobuf message.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Send Message'));
    await tester.pump();
    await tester.pumpAndSettle();

    expect(
      find.text('Response: Mock response for "Hello, Protobuf!"'),
      findsOneWidget,
    );
  });
}
