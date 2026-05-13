enum CalendarView { day, week, month, year }

enum ApparelSize { extraSmall, small, medium, large, extraLarge }

class SegmentedButtonDemoSnapshot {
  SegmentedButtonDemoSnapshot({
    required this.calendarView,
    required Set<ApparelSize> selectedSizes,
  }) : selectedSizes = Set<ApparelSize>.unmodifiable(selectedSizes);

  final CalendarView calendarView;
  final Set<ApparelSize> selectedSizes;

  SegmentedButtonDemoSnapshot copyWith({
    CalendarView? calendarView,
    Set<ApparelSize>? selectedSizes,
  }) {
    return SegmentedButtonDemoSnapshot(
      calendarView: calendarView ?? this.calendarView,
      selectedSizes: selectedSizes ?? this.selectedSizes,
    );
  }
}
