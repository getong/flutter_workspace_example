// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/advice/data/repositories/advice_repository_impl.dart'
    as _i527;
import '../../features/advice/data/services/advice_api_service.dart' as _i554;
import '../../features/advice/data/services/fallback_advice_service.dart'
    as _i876;
import '../../features/advice/domain/repositories/advice_repository.dart'
    as _i86;
import '../../features/advice/domain/usecases/get_random_advice_usecase.dart'
    as _i575;
import '../../features/advice/presentation/bloc/advice_bloc.dart' as _i682;
import 'register_module.dart' as _i291;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule(this);
    gh.lazySingleton<_i361.Dio>(() => registerModule.dio);
    gh.lazySingleton<_i876.FallbackAdviceService>(
      () => registerModule.fallbackAdviceService,
    );
    gh.lazySingleton<_i554.AdviceApiService>(
      () => registerModule.adviceApiService,
    );
    gh.lazySingleton<_i86.AdviceRepository>(
      () => registerModule.adviceRepository,
    );
    gh.factory<_i575.GetRandomAdviceUseCase>(
      () => registerModule.getRandomAdviceUseCase,
    );
    gh.factory<_i682.AdviceBloc>(() => registerModule.adviceBloc);
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {
  _$RegisterModule(this._getIt);

  final _i174.GetIt _getIt;

  @override
  _i876.FallbackAdviceService get fallbackAdviceService =>
      _i876.FallbackAdviceService();

  @override
  _i554.AdviceApiService get adviceApiService =>
      _i554.AdviceApiService(_getIt<_i361.Dio>());

  @override
  _i527.AdviceRepositoryImpl get adviceRepository => _i527.AdviceRepositoryImpl(
    _getIt<_i554.AdviceApiService>(),
    _getIt<_i876.FallbackAdviceService>(),
  );

  @override
  _i575.GetRandomAdviceUseCase get getRandomAdviceUseCase =>
      _i575.GetRandomAdviceUseCase(_getIt<_i86.AdviceRepository>());

  @override
  _i682.AdviceBloc get adviceBloc =>
      _i682.AdviceBloc(_getIt<_i575.GetRandomAdviceUseCase>());
}
