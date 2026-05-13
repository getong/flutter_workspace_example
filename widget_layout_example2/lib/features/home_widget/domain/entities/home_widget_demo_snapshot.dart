import 'package:widget_layout_example2/features/home_widget/domain/entities/installed_home_widget.dart';

const Object _homeWidgetSnapshotUnset = Object();

class HomeWidgetDemoSnapshot {
  const HomeWidgetDemoSnapshot({
    required this.platformLabel,
    required this.isSupported,
    required this.isConfigured,
    required this.isPinSupported,
    required this.statusMessage,
    this.widgetTitle = 'Widget Layout Example',
    this.widgetMessage = 'Update me from Flutter.',
    this.widgetLaunchSummary = 'No widget click detected yet.',
    this.renderedImagePath,
    this.installedWidgets = const <InstalledHomeWidget>[],
    this.logEntries = const <String>[],
  });

  factory HomeWidgetDemoSnapshot.initial({
    required String platformLabel,
    required bool isSupported,
  }) {
    return HomeWidgetDemoSnapshot(
      platformLabel: platformLabel,
      isSupported: isSupported,
      isConfigured: false,
      isPinSupported: false,
      statusMessage: isSupported
          ? 'Plugin has not been configured yet.'
          : 'home_widget works on Android and iOS only.',
    );
  }

  final String platformLabel;
  final bool isSupported;
  final bool isConfigured;
  final bool isPinSupported;
  final String widgetTitle;
  final String widgetMessage;
  final String widgetLaunchSummary;
  final String statusMessage;
  final String? renderedImagePath;
  final List<InstalledHomeWidget> installedWidgets;
  final List<String> logEntries;

  HomeWidgetDemoSnapshot copyWith({
    String? platformLabel,
    bool? isSupported,
    bool? isConfigured,
    bool? isPinSupported,
    String? widgetTitle,
    String? widgetMessage,
    String? widgetLaunchSummary,
    String? statusMessage,
    Object? renderedImagePath = _homeWidgetSnapshotUnset,
    List<InstalledHomeWidget>? installedWidgets,
    List<String>? logEntries,
  }) {
    return HomeWidgetDemoSnapshot(
      platformLabel: platformLabel ?? this.platformLabel,
      isSupported: isSupported ?? this.isSupported,
      isConfigured: isConfigured ?? this.isConfigured,
      isPinSupported: isPinSupported ?? this.isPinSupported,
      widgetTitle: widgetTitle ?? this.widgetTitle,
      widgetMessage: widgetMessage ?? this.widgetMessage,
      widgetLaunchSummary: widgetLaunchSummary ?? this.widgetLaunchSummary,
      statusMessage: statusMessage ?? this.statusMessage,
      renderedImagePath: identical(renderedImagePath, _homeWidgetSnapshotUnset)
          ? this.renderedImagePath
          : renderedImagePath as String?,
      installedWidgets: installedWidgets ?? this.installedWidgets,
      logEntries: logEntries ?? this.logEntries,
    );
  }
}
