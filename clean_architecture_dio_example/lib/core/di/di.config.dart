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
    as _i431;
import '../../features/advice/data/services/advice_api_service.dart' as _i829;
import '../../features/advice/data/services/fallback_advice_service.dart'
    as _i396;
import '../../features/advice/domain/repositories/advice_repository.dart'
    as _i154;
import '../../features/advice/domain/usecases/get_random_advice_usecase.dart'
    as _i183;
import '../../features/advice/presentation/bloc/advice_bloc.dart' as _i805;
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
    gh.lazySingleton<_i396.FallbackAdviceService>(
      () => registerModule.fallbackAdviceService,
    );
    gh.lazySingleton<_i829.AdviceApiService>(
      () => registerModule.adviceApiService,
    );
    gh.lazySingleton<_i154.AdviceRepository>(
      () => registerModule.adviceRepository,
    );
    gh.factory<_i183.GetRandomAdviceUseCase>(
      () => registerModule.getRandomAdviceUseCase,
    );
    gh.factory<_i805.AdviceBloc>(() => registerModule.adviceBloc);
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {
  _$RegisterModule(this._getIt);

  final _i174.GetIt _getIt;

  @override
  _i396.FallbackAdviceService get fallbackAdviceService =>
      _i396.FallbackAdviceService();

  @override
  _i829.AdviceApiService get adviceApiService =>
      _i829.AdviceApiService(_getIt<_i361.Dio>());

  @override
  _i431.AdviceRepositoryImpl get adviceRepository => _i431.AdviceRepositoryImpl(
    _getIt<_i829.AdviceApiService>(),
    _getIt<_i396.FallbackAdviceService>(),
  );

  @override
  _i183.GetRandomAdviceUseCase get getRandomAdviceUseCase =>
      _i183.GetRandomAdviceUseCase(_getIt<_i154.AdviceRepository>());

  @override
  _i805.AdviceBloc get adviceBloc =>
      _i805.AdviceBloc(_getIt<_i183.GetRandomAdviceUseCase>());
}
