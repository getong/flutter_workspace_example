enum AppRoutes {
  home('/'),
  basicScaffold('/basic-scaffold'),
  container('/container'),
  rowColumn('/row-column'),
  popupMenu('/popup-menu'),
  tabBar('/tab-bar'),
  stack('/stack'),
  listView('/list-view'),
  gridView('/grid-view');

  const AppRoutes(this.path);
  final String path;
}
