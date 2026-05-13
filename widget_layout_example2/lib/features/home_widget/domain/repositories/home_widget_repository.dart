import 'package:widget_layout_example2/features/home_widget/domain/entities/home_widget_demo_snapshot.dart';

abstract interface class HomeWidgetRepository {
  HomeWidgetDemoSnapshot get currentSnapshot;

  Stream<HomeWidgetDemoSnapshot> watchSnapshot();

  Future<HomeWidgetDemoSnapshot> initialize();

  Future<HomeWidgetDemoSnapshot> refresh();

  Future<HomeWidgetDemoSnapshot> updateDraft({
    required String title,
    required String message,
  });

  Future<HomeWidgetDemoSnapshot> pushWidgetData();

  Future<HomeWidgetDemoSnapshot> readWidgetData();

  Future<HomeWidgetDemoSnapshot> renderDemoImage();

  Future<HomeWidgetDemoSnapshot> requestPinWidget();

  Future<HomeWidgetDemoSnapshot> loadInstalledWidgets();
}
