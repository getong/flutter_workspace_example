sealed class HomeWidgetDemoEvent {
  const HomeWidgetDemoEvent();
}

final class HomeWidgetDemoInitializeRequested extends HomeWidgetDemoEvent {
  const HomeWidgetDemoInitializeRequested();
}

final class HomeWidgetDemoRefreshRequested extends HomeWidgetDemoEvent {
  const HomeWidgetDemoRefreshRequested();
}

final class HomeWidgetDemoDraftChanged extends HomeWidgetDemoEvent {
  const HomeWidgetDemoDraftChanged({
    required this.title,
    required this.message,
  });

  final String title;
  final String message;
}

final class HomeWidgetDemoPushRequested extends HomeWidgetDemoEvent {
  const HomeWidgetDemoPushRequested();
}

final class HomeWidgetDemoReadRequested extends HomeWidgetDemoEvent {
  const HomeWidgetDemoReadRequested();
}

final class HomeWidgetDemoRenderImageRequested extends HomeWidgetDemoEvent {
  const HomeWidgetDemoRenderImageRequested();
}

final class HomeWidgetDemoRequestPinRequested extends HomeWidgetDemoEvent {
  const HomeWidgetDemoRequestPinRequested();
}

final class HomeWidgetDemoInstalledWidgetsRequested
    extends HomeWidgetDemoEvent {
  const HomeWidgetDemoInstalledWidgetsRequested();
}
