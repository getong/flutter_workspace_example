import 'package:flutter_test/flutter_test.dart';
import 'package:widget_layout_example2/features/segmented_button/data/repositories/in_memory_segmented_button_repository.dart';
import 'package:widget_layout_example2/features/segmented_button/domain/entities/segmented_button_demo_snapshot.dart';

void main() {
  group('InMemorySegmentedButtonRepository', () {
    late InMemorySegmentedButtonRepository repository;

    setUp(() {
      repository = InMemorySegmentedButtonRepository();
    });

    test('loads the default demo snapshot', () {
      final SegmentedButtonDemoSnapshot snapshot = repository.loadSnapshot();

      expect(snapshot.calendarView, CalendarView.day);
      expect(
        snapshot.selectedSizes,
        equals(<ApparelSize>{ApparelSize.large, ApparelSize.extraLarge}),
      );
    });

    test('saves calendar mode and selected sizes', () {
      repository.saveCalendarView(CalendarView.month);
      repository.saveSelectedSizes(<ApparelSize>{
        ApparelSize.small,
        ApparelSize.medium,
      });

      final SegmentedButtonDemoSnapshot snapshot = repository.loadSnapshot();

      expect(snapshot.calendarView, CalendarView.month);
      expect(
        snapshot.selectedSizes,
        equals(<ApparelSize>{ApparelSize.small, ApparelSize.medium}),
      );
    });

    test('resets the demo snapshot', () {
      repository.saveCalendarView(CalendarView.year);
      repository.saveSelectedSizes(<ApparelSize>{ApparelSize.extraSmall});

      repository.reset();

      final SegmentedButtonDemoSnapshot snapshot = repository.loadSnapshot();

      expect(snapshot.calendarView, CalendarView.day);
      expect(
        snapshot.selectedSizes,
        equals(<ApparelSize>{ApparelSize.large, ApparelSize.extraLarge}),
      );
    });
  });
}
