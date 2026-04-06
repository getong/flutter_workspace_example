import 'package:flutter_test/flutter_test.dart';

import 'package:web_socket_channel_example/main.dart';
import 'package:web_socket_channel_example/service_locator.dart';

void main() {
  setupServiceLocator();

  testWidgets('renders auth and websocket navigation', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Axum Auth'), findsWidgets);
    expect(find.text('Auth'), findsOneWidget);
    expect(find.text('WebSocket'), findsOneWidget);
  });
}
