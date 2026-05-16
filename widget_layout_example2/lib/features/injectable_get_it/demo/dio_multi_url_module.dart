import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

// ---------------------------------------------------------------------------
// This module demonstrates THREE approaches for using a single or multiple
// Dio instances via get_it to access different base URLs.
//
// Approach 1 – Dynamic Full-URL Override (simplest, recommended for occasional use)
//   Register ONE Dio with a default baseUrl.  When calling an external API,
//   pass a full URL (starting with "http") to bypass the baseUrl.
//   Pros:  Minimal code; global interceptors (logging, retry) still apply.
//   Cons:  If different servers need completely different headers/timeouts,
//          interceptor logic gets messy.
//
// Approach 2 – Interceptor-Based URL Routing (fine-grained control)
//   Register ONE Dio but add an interceptor that inspects the request URL
//   and applies different headers / auth tokens per host.
//   Pros:  Single instance, clear per-host logic in one place.
//   Cons:  Interceptor grows when more hosts are added; harder to unit-test
//          individual host behaviors in isolation.
//
// Approach 3 – Multiple Named Instances (best isolation)
//   Register MULTIPLE Dio singletons with distinct instanceName values.
//   Each instance owns its own baseUrl, timeout, and interceptors.
//   Pros:  Complete isolation; each service can evolve independently.
//   Cons:  More registrations; callers must know the instanceName.
// ---------------------------------------------------------------------------

final GetIt _getIt = GetIt.instance;

// ===== Constants =====
const String kMainBaseUrl = 'https://api.myserver.com';
const String kOtherServiceBaseUrl = 'https://api.other-service.com';
const String kOtherServiceInstanceName = 'otherService';

// ===== Approach 1: Single Dio – Dynamic Full-URL Override =================

/// Register a single Dio instance with a default [baseUrl].
/// Callers can still hit any URL by passing a full "http(s)://..." path.
void registerDioApproach1() {
  if (_getIt.isRegistered<Dio>(instanceName: 'approach1')) return;

  final dio = Dio(
    BaseOptions(
      baseUrl: kMainBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  // A simple logging interceptor shared across ALL requests.
  dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

  _getIt.registerSingleton<Dio>(dio, instanceName: 'approach1');
}

// ===== Approach 2: Single Dio – Interceptor-Based URL Routing =============

/// Register a single Dio instance whose interceptor conditionally attaches
/// headers based on the target host.
void registerDioApproach2({required String Function() tokenProvider}) {
  if (_getIt.isRegistered<Dio>(instanceName: 'approach2')) return;

  final dio = Dio(
    BaseOptions(
      baseUrl: kMainBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        // Resolve the effective host (could be from baseUrl or a full URL).
        final uri = options.uri;

        if (uri.host.contains('myserver.com')) {
          // Only attach auth header for our own backend.
          options.headers['Authorization'] = 'Bearer ${tokenProvider()}';
        }

        if (uri.host.contains('other-service.com')) {
          // Third-party service uses a different API-key scheme.
          options.headers['X-Api-Key'] = 'third-party-key';
        }

        return handler.next(options);
      },
      onError: (error, handler) {
        // Centralised error handling – e.g. refresh token for myserver.com only.
        return handler.next(error);
      },
    ),
  );

  dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

  _getIt.registerSingleton<Dio>(dio, instanceName: 'approach2');
}

// ===== Approach 3: Multiple Named Instances ===============================

/// Register two completely independent Dio instances with different
/// base URLs, timeouts, and interceptor stacks.
void registerDioApproach3({required String Function() tokenProvider}) {
  // --- Main backend instance (default) ---
  if (!_getIt.isRegistered<Dio>(instanceName: 'approach3_main')) {
    final mainDio = Dio(
      BaseOptions(
        baseUrl: kMainBaseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    mainDio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers['Authorization'] = 'Bearer ${tokenProvider()}';
          return handler.next(options);
        },
      ),
    );

    mainDio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );

    _getIt.registerSingleton<Dio>(mainDio, instanceName: 'approach3_main');
  }

  // --- Other-service instance (named) ---
  if (!_getIt.isRegistered<Dio>(instanceName: 'approach3_other')) {
    final otherDio = Dio(
      BaseOptions(
        baseUrl: kOtherServiceBaseUrl,
        connectTimeout: const Duration(seconds: 30), // longer timeout
        receiveTimeout: const Duration(seconds: 30),
        headers: {'X-Api-Key': 'third-party-key'},
      ),
    );

    otherDio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );

    _getIt.registerSingleton<Dio>(otherDio, instanceName: 'approach3_other');
  }
}

// ===== Convenience registration entry point ===============================

/// Call once at app startup to register ALL three demo configurations.
/// In a real app you would pick ONE approach and register only that.
void registerAllDioApproaches({required String Function() tokenProvider}) {
  registerDioApproach1();
  registerDioApproach2(tokenProvider: tokenProvider);
  registerDioApproach3(tokenProvider: tokenProvider);
}
