import 'package:widget_layout_example2/features/home_widget/domain/entities/home_widget_demo_snapshot.dart';

class HomeWidgetDemoState {
  const HomeWidgetDemoState({required this.snapshot, this.isBusy = false});

  factory HomeWidgetDemoState.initial({
    required HomeWidgetDemoSnapshot snapshot,
  }) {
    return HomeWidgetDemoState(snapshot: snapshot);
  }

  final HomeWidgetDemoSnapshot snapshot;
  final bool isBusy;

  HomeWidgetDemoState copyWith({
    HomeWidgetDemoSnapshot? snapshot,
    bool? isBusy,
  }) {
    return HomeWidgetDemoState(
      snapshot: snapshot ?? this.snapshot,
      isBusy: isBusy ?? this.isBusy,
    );
  }
}
