import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../data/network/dio_factory.dart';
import '../../data/repositories/advice_repository_impl.dart';
import '../../data/repositories/post_repository_impl.dart';
import '../../data/services/advice_api_service.dart';
import '../../data/services/fallback_advice_service.dart';
import '../../domain/repositories/advice_repository.dart';
import '../../domain/repositories/post_repository.dart';
import '../../domain/usecases/get_posts_usecase.dart';
import '../../domain/usecases/get_random_advice_usecase.dart';
import '../../presentation/bloc/advice_bloc.dart';
import '../../presentation/bloc/post_bloc.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  Dio get dio => createConfiguredDio();

  // --- Data Layer Registration (LazySingleton) ---
  @LazySingleton()
  AdviceApiService get adviceApiService;

  @LazySingleton()
  FallbackAdviceService get fallbackAdviceService;

  @LazySingleton(as: AdviceRepository)
  AdviceRepositoryImpl get adviceRepository;

  @LazySingleton(as: PostRepository)
  PostRepositoryImpl get postRepository;

  // --- Domain Layer Registration (Injectable - factory) ---
  @injectable
  GetRandomAdviceUseCase get getRandomAdviceUseCase;

  @injectable
  GetPostsUseCase get getPostsUseCase;

  // --- Presentation Layer Registration (Injectable - factory) ---
  @injectable
  AdviceBloc get adviceBloc;

  @injectable
  PostBloc get postBloc;
}
