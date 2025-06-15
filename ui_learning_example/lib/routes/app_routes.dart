enum AppRoutes {
  home('/'),
  basicScaffold('/basic-scaffold'),
  rowColumn('/row-column'),
  popupMenu('/popup-menu'),
  tabBar('/tab-bar'),
  stack('/stack'),
  listView('/list-view');

  const AppRoutes(this.path);
  final String path;
}
