import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../data/network/dio_factory.dart';
import '../../data/repositories/advice_repository_impl.dart';
import '../../data/services/advice_api_service.dart';
import '../../data/services/fallback_advice_service.dart';
import '../../domain/repositories/advice_repository.dart';
import '../../domain/usecases/get_random_advice_usecase.dart';
import '../../presentation/bloc/advice_bloc.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  Dio get dio => createConfiguredDio();

  @LazySingleton()
  AdviceApiService get adviceApiService;

  @LazySingleton()
  FallbackAdviceService get fallbackAdviceService;

  @LazySingleton(as: AdviceRepository)
  AdviceRepositoryImpl get adviceRepository;

  @injectable
  GetRandomAdviceUseCase get getRandomAdviceUseCase;

  @injectable
  AdviceBloc get adviceBloc;
}
