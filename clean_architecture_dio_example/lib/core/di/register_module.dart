import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../app_router.dart';
import '../../features/advice/data/local/advice_database.dart';
import '../network/dio_factory.dart';
import '../../features/advice/data/services/advice_api_service.dart';
import '../../features/advice/data/services/fallback_advice_service.dart';
import '../../features/advice/domain/usecases/get_random_advice_usecase.dart';
import '../../features/advice/presentation/bloc/advice_bloc.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  Dio get dio => createConfiguredDio();

  @lazySingleton
  AppRouter get appRouter => AppRouter();

  @lazySingleton
  AdviceDatabase get adviceDatabase => AdviceDatabase();

  // --- Data Layer Registration (LazySingleton) ---
  @LazySingleton()
  AdviceApiService get adviceApiService;

  @LazySingleton()
  FallbackAdviceService get fallbackAdviceService;

  // --- Domain Layer Registration (Injectable - factory) ---
  @injectable
  GetRandomAdviceUseCase get getRandomAdviceUseCase;

  // --- Presentation Layer Registration (Injectable - factory) ---
  @injectable
  AdviceBloc get adviceBloc;
}
