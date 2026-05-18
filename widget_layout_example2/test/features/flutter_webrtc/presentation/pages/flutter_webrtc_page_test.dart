import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widget_layout_example2/features/flutter_webrtc/presentation/pages/flutter_webrtc_page.dart';

void main() {
  testWidgets('renders flutter_webrtc explanation and controls', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1280, 2200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MaterialApp(home: FlutterWebRtcPage()));
    await tester.pump();

    expect(find.text('flutter_webrtc Module'), findsOneWidget);
    expect(find.text('Why This Package Matters'), findsOneWidget);
    expect(find.text('Loopback Demo'), findsOneWidget);
    expect(find.text('Start Loopback'), findsOneWidget);
    expect(find.text('Switch Camera'), findsOneWidget);
    expect(find.text('Local capture'), findsOneWidget);
    expect(find.text('Remote loopback'), findsOneWidget);
    expect(find.text('Clean Architecture In This Module'), findsOneWidget);
  });
}
