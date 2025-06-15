enum AppRoutes {
  home('/'),
  basicScaffold('/basic-scaffold'),
  rowColumn('/row-column'),
  popupMenu('/popup-menu');

  const AppRoutes(this.path);
  final String path;
}
