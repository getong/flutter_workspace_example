enum AppRoutes {
  home('/'),
  basicScaffold('/basic-scaffold'),
  rowColumn('/row-column'),
  popupMenu('/popup-menu'),
  tabBar('/tab-bar');

  const AppRoutes(this.path);
  final String path;
}
