import 'package:widget_layout_example2/features/segmented_button/domain/entities/segmented_button_demo_snapshot.dart';

class SegmentedButtonDemoState {
  const SegmentedButtonDemoState({required this.snapshot});

  final SegmentedButtonDemoSnapshot snapshot;

  CalendarView get calendarView => snapshot.calendarView;
  Set<ApparelSize> get selectedSizes => snapshot.selectedSizes;
}
