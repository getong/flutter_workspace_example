import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widget_layout_example2/features/segmented_button/domain/entities/segmented_button_demo_snapshot.dart';
import 'package:widget_layout_example2/features/segmented_button/presentation/pages/segmented_button_page.dart';

void main() {
  testWidgets('updates single and multi select summaries', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1200, 2200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MaterialApp(home: SegmentedButtonPage()));

    expect(find.text('Active calendar view'), findsOneWidget);

    final Finder singleButtonFinder = find.byKey(
      const Key('segmentedButton.single'),
    );
    final Finder multiButtonFinder = find.byKey(
      const Key('segmentedButton.multi'),
    );
    final Finder resetButtonFinder = find.byKey(
      const Key('segmentedButton.reset'),
    );

    SegmentedButton<CalendarView> singleSelectButton = tester.widget(
      singleButtonFinder,
    );
    expect(
      singleSelectButton.selected,
      equals(<CalendarView>{CalendarView.day}),
    );

    SegmentedButton<ApparelSize> multiSelectButton = tester.widget(
      multiButtonFinder,
    );
    expect(
      multiSelectButton.selected,
      equals(<ApparelSize>{ApparelSize.large, ApparelSize.extraLarge}),
    );

    await tester.tap(find.text('Week').first);
    await tester.pumpAndSettle();

    singleSelectButton = tester.widget(singleButtonFinder);
    expect(
      singleSelectButton.selected,
      equals(<CalendarView>{CalendarView.week}),
    );

    await tester.tap(find.text('L').first);
    await tester.pumpAndSettle();

    multiSelectButton = tester.widget(multiButtonFinder);
    expect(
      multiSelectButton.selected,
      equals(<ApparelSize>{ApparelSize.extraLarge}),
    );

    await tester.tap(resetButtonFinder);
    await tester.pumpAndSettle();

    singleSelectButton = tester.widget(singleButtonFinder);
    expect(
      singleSelectButton.selected,
      equals(<CalendarView>{CalendarView.day}),
    );

    multiSelectButton = tester.widget(multiButtonFinder);
    expect(
      multiSelectButton.selected,
      equals(<ApparelSize>{ApparelSize.large, ApparelSize.extraLarge}),
    );
  });
}
