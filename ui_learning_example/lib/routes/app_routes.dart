enum AppRoutes {
  home('/'),
  basicScaffold('/basic-scaffold'),
  rowColumn('/row-column');

  const AppRoutes(this.path);
  final String path;
}
