import 'package:widget_layout_example2/features/segmented_button/domain/entities/segmented_button_demo_snapshot.dart';
import 'package:widget_layout_example2/features/segmented_button/domain/repositories/segmented_button_repository.dart';

class InMemorySegmentedButtonRepository implements SegmentedButtonRepository {
  SegmentedButtonDemoSnapshot _snapshot = _defaultSnapshot();

  @override
  SegmentedButtonDemoSnapshot loadSnapshot() {
    return _snapshot.copyWith();
  }

  @override
  void saveCalendarView(CalendarView calendarView) {
    _snapshot = _snapshot.copyWith(calendarView: calendarView);
  }

  @override
  void saveSelectedSizes(Set<ApparelSize> selectedSizes) {
    _snapshot = _snapshot.copyWith(selectedSizes: selectedSizes);
  }

  @override
  void reset() {
    _snapshot = _defaultSnapshot();
  }

  static SegmentedButtonDemoSnapshot _defaultSnapshot() {
    return SegmentedButtonDemoSnapshot(
      calendarView: CalendarView.day,
      selectedSizes: <ApparelSize>{ApparelSize.large, ApparelSize.extraLarge},
    );
  }
}
