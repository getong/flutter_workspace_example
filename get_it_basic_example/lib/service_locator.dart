import 'package:get_it/get_it.dart';
import 'package:get_it_basic_example/app_model.dart';
import 'package:get_it_basic_example/services/data_repository.dart';
import 'package:get_it_basic_example/services/settings_service.dart';
import 'package:get_it_basic_example/services/logger_service.dart';

// This is our global ServiceLocator
final GetIt getIt = GetIt.instance;

/// Configure all the dependencies for the app
void setupServiceLocator() {
  // Factory registration - creates new instance every time
  getIt.registerFactory<LoggerService>(() => LoggerService());

  // Lazy singleton - created when first accessed
  getIt.registerLazySingleton<SettingsService>(() => SettingsService());

  // Async singleton - for services that need async initialization
  getIt.registerSingletonAsync<DataRepository>(
    () async => DataRepository.create(),
  );

  // Regular singleton with dependencies
  getIt.registerSingletonWithDependencies<AppModel>(
    () => AppModelImplementation(),
    dependsOn: [DataRepository],
  );
}

/// Reset the service locator (useful for testing)
Future<void> resetServiceLocator() async {
  await getIt.reset();
}
