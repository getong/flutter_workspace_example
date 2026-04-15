import 'package:flutter_test/flutter_test.dart';

import 'package:isolate_flutter_bloc_example/main.dart';

void main() {
  testWidgets('renders websocket isolate screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Isolate WebSocket Feed'), findsOneWidget);
    expect(find.text('Connection'), findsOneWidget);
    expect(find.text('Send Message'), findsOneWidget);
    expect(
      find.text(
        'No messages yet. Connect to your websocket server and send a payload.',
      ),
      findsOneWidget,
    );
  });
}
