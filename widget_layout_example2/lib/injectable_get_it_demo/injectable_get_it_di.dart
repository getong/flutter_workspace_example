import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:widget_layout_example2/injectable_get_it_demo/auth_repository.dart';

import 'injectable_get_it_di.config.dart';

final GetIt injectableGetIt = GetIt.instance;

@InjectableInit(
  initializerName: 'initInjectableGetItDemo',
  asExtension: true,
  preferRelativeImports: true,
  generateForDir: <String>['lib/injectable_get_it_demo'],
)
void configureInjectableGetItDemo() {
  if (injectableGetIt.isRegistered<AuthRepository>()) {
    return;
  }

  injectableGetIt.initInjectableGetItDemo();
}
