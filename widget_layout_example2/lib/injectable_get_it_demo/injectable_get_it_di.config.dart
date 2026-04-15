// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import 'auth_repository.dart' as _i775;
import 'auth_repository_impl.dart' as _i766;
import 'auto_session_module.dart' as _i190;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt initInjectableGetItDemo({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.lazySingleton<_i775.AuthRepository>(() => _i766.DemoAuthRepository());
    gh.factory<_i190.AutoSessionModule>(
      () => _i190.AutoSessionModule(gh<_i775.AuthRepository>()),
    );
    return this;
  }
}
