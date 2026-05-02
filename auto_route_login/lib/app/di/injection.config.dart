// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route_login/app/di/register_module.dart'
    as _i890;
import 'package:auto_route_login/features/auth/data/datasources/auth_remote_data_source.dart'
    as _i931;
import 'package:auto_route_login/features/auth/data/repositories/auth_repository_impl.dart'
    as _i220;
import 'package:auto_route_login/features/auth/domain/repositories/auth_repository.dart'
    as _i726;
import 'package:auto_route_login/features/auth/domain/usecases/login_use_case.dart'
    as _i563;
import 'package:auto_route_login/features/auth/domain/usecases/signup_use_case.dart'
    as _i917;
import 'package:auto_route_login/features/auth/presentation/bloc/auth_form_bloc.dart'
    as _i569;
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i361.Dio>(() => registerModule.dio());
    gh.lazySingleton<_i931.AuthRemoteDataSource>(
      () => _i931.AuthRemoteDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i726.AuthRepository>(
      () => _i220.AuthRepositoryImpl(gh<_i931.AuthRemoteDataSource>()),
    );
    gh.factory<_i563.LoginUseCase>(
      () => _i563.LoginUseCase(gh<_i726.AuthRepository>()),
    );
    gh.factory<_i917.SignupUseCase>(
      () => _i917.SignupUseCase(gh<_i726.AuthRepository>()),
    );
    gh.factory<_i569.AuthFormBloc>(
      () => _i569.AuthFormBloc(
        gh<_i563.LoginUseCase>(),
        gh<_i917.SignupUseCase>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i890.RegisterModule {}
