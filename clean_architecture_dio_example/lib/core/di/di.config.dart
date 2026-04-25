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

import '../../data/repositories/advice_repository_impl.dart' as _i527;
import '../../data/repositories/post_repository_impl.dart' as _i704;
import '../../data/services/advice_api_service.dart' as _i554;
import '../../data/services/fallback_advice_service.dart' as _i876;
import '../../domain/repositories/advice_repository.dart' as _i86;
import '../../domain/repositories/post_repository.dart' as _i856;
import '../../domain/usecases/get_posts_usecase.dart' as _i972;
import '../../domain/usecases/get_random_advice_usecase.dart' as _i575;
import '../../presentation/bloc/advice_bloc.dart' as _i682;
import '../../presentation/bloc/post_bloc.dart' as _i616;
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
    gh.lazySingleton<_i856.PostRepository>(() => registerModule.postRepository);
    gh.factory<_i972.GetPostsUseCase>(() => registerModule.getPostsUseCase);
    gh.lazySingleton<_i554.AdviceApiService>(
      () => registerModule.adviceApiService,
    );
    gh.lazySingleton<_i86.AdviceRepository>(
      () => registerModule.adviceRepository,
    );
    gh.factory<_i616.PostBloc>(() => registerModule.postBloc);
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
  _i704.PostRepositoryImpl get postRepository => _i704.PostRepositoryImpl();

  @override
  _i972.GetPostsUseCase get getPostsUseCase =>
      _i972.GetPostsUseCase(_getIt<_i856.PostRepository>());

  @override
  _i554.AdviceApiService get adviceApiService =>
      _i554.AdviceApiService(_getIt<_i361.Dio>());

  @override
  _i527.AdviceRepositoryImpl get adviceRepository => _i527.AdviceRepositoryImpl(
    _getIt<_i554.AdviceApiService>(),
    _getIt<_i876.FallbackAdviceService>(),
  );

  @override
  _i616.PostBloc get postBloc =>
      _i616.PostBloc(_getIt<_i972.GetPostsUseCase>());

  @override
  _i575.GetRandomAdviceUseCase get getRandomAdviceUseCase =>
      _i575.GetRandomAdviceUseCase(_getIt<_i86.AdviceRepository>());

  @override
  _i682.AdviceBloc get adviceBloc =>
      _i682.AdviceBloc(_getIt<_i575.GetRandomAdviceUseCase>());
}
