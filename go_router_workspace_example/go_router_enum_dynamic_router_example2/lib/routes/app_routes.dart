enum AppRoute {
  home('/'),
  profile('/profile'),
  settings('/settings'),
  userDetail('/user/:id'),
  productDetail('/product/:productId'),
  category('/category/:categoryName');

  const AppRoute(this.path);
  final String path;

  String get name => toString().split('.').last;
}

extension AppRouteExtension on AppRoute {
  String location({Map<String, String> pathParameters = const {}}) {
    String result = path;
    for (final entry in pathParameters.entries) {
      result = result.replaceAll(':${entry.key}', entry.value);
    }
    return result;
  }
}
