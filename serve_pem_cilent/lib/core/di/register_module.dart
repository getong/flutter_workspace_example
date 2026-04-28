import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../network/dio_factory.dart';
import '../../features/advice/data/repositories/advice_repository_impl.dart';
import '../../features/advice/data/services/advice_api_service.dart';
import '../../features/advice/data/services/fallback_advice_service.dart';
import '../../features/advice/domain/repositories/advice_repository.dart';
import '../../features/advice/domain/usecases/get_random_advice_usecase.dart';
import '../../features/advice/presentation/bloc/advice_bloc.dart';
import '../../features/serve_pem/data/services/serve_pem_chat_socket.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  Dio get dio => createConfiguredDio();

  @lazySingleton
  ServePemWebSocketChannelFactory get servePemWebSocketChannelFactory =>
      const ServePemWebSocketChannelFactory();

  // --- Data Layer Registration (LazySingleton) ---
  @LazySingleton()
  AdviceApiService get adviceApiService;

  @LazySingleton()
  FallbackAdviceService get fallbackAdviceService;

  @LazySingleton(as: AdviceRepository)
  AdviceRepositoryImpl get adviceRepository;

  // --- Domain Layer Registration (Injectable - factory) ---
  @injectable
  GetRandomAdviceUseCase get getRandomAdviceUseCase;

  // --- Presentation Layer Registration (Injectable - factory) ---
  @injectable
  AdviceBloc get adviceBloc;
}
