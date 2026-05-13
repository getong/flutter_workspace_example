class InstalledHomeWidget {
  const InstalledHomeWidget({
    this.iOSFamily,
    this.iOSKind,
    this.androidWidgetId,
    this.androidClassName,
    this.androidLabel,
  });

  final String? iOSFamily;
  final String? iOSKind;
  final int? androidWidgetId;
  final String? androidClassName;
  final String? androidLabel;

  String get summary {
    if (androidWidgetId != null) {
      return 'Android widgetId=$androidWidgetId, '
          'class=${androidClassName ?? '-'}, '
          'label=${androidLabel ?? '-'}';
    }
    return 'iOS family=${iOSFamily ?? '-'}, kind=${iOSKind ?? '-'}';
  }
}
