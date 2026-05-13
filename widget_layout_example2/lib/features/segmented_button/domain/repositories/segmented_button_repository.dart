import 'package:widget_layout_example2/features/segmented_button/domain/entities/segmented_button_demo_snapshot.dart';

abstract interface class SegmentedButtonRepository {
  SegmentedButtonDemoSnapshot loadSnapshot();
  void saveCalendarView(CalendarView calendarView);
  void saveSelectedSizes(Set<ApparelSize> selectedSizes);
  void reset();
}
