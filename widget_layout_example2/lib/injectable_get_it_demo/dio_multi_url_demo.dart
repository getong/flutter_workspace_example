import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'dio_multi_url_module.dart';

// ---------------------------------------------------------------------------
// Demo class that exercises all three Dio-via-GetIt approaches.
//
// ┌──────────┬──────────────────────┬──────────────┬──────────────────────────┐
// │ Approach │ # of Dio instances   │ Best when    │ Trade-off                │
// ├──────────┼──────────────────────┼──────────────┼──────────────────────────┤
// │ 1        │ 1                    │ Rarely call  │ Shared interceptors may  │
// │          │                      │ external URL │ not suit every host      │
// ├──────────┼──────────────────────┼──────────────┼──────────────────────────┤
// │ 2        │ 1                    │ Several hosts│ Interceptor logic grows  │
// │          │                      │ need custom  │ linearly with host count │
// │          │                      │ headers      │                          │
// ├──────────┼──────────────────────┼──────────────┼──────────────────────────┤
// │ 3        │ N (one per service)  │ Services are │ More boilerplate; caller │
// │          │                      │ very differ- │ must know instanceName   │
// │          │                      │ ent in config│                          │
// └──────────┴──────────────────────┴──────────────┴──────────────────────────┘
// ---------------------------------------------------------------------------

final GetIt _getIt = GetIt.instance;

class DioMultiUrlDemo {
  // ===== Approach 1: Dynamic Full-URL Override =============================
  //
  // Use a SINGLE Dio from get_it. For internal APIs use relative paths;
  // for external APIs pass the full URL – Dio automatically ignores baseUrl
  // when the path starts with "http(s)://".
  //
  // Pros:
  //   - Minimal code and setup.
  //   - Global interceptors (logging, retry) apply to every request.
  //   - Connection pool is reused for requests to the same host.
  //
  // Cons:
  //   - All hosts share the same interceptor stack.
  //   - If headers/timeouts must differ per host the interceptor gets messy.
  //   - No compile-time distinction between "main" and "other" requests.

  Future<void> demoApproach1() async {
    final dio = _getIt<Dio>(instanceName: 'approach1');

    // 1a. Hit the default backend using a relative path.
    //     Effective URL → https://api.myserver.com/user/profile
    final profileResponse = await dio.get<Map<String, dynamic>>(
      '/user/profile',
    );
    _log('Approach 1 – internal', profileResponse.statusCode);

    // 1b. Hit an external service by passing a FULL URL.
    //     Dio sees "https://..." and skips baseUrl entirely.
    final externalResponse = await dio.get<Map<String, dynamic>>(
      'https://api.other-service.com/data',
    );
    _log('Approach 1 – external', externalResponse.statusCode);
  }

  // ===== Approach 2: Interceptor-Based URL Routing =========================
  //
  // Still a SINGLE Dio, but an InterceptorsWrapper inspects each request's
  // URI and applies host-specific logic (auth headers, API keys, etc.).
  //
  // Pros:
  //   - All per-host rules live in one interceptor – easy to audit.
  //   - Still only one Dio registration in get_it.
  //
  // Cons:
  //   - Interceptor becomes a "god object" as hosts increase.
  //   - Harder to unit-test host-specific behaviour in isolation.
  //   - Runtime branching instead of compile-time separation.

  Future<void> demoApproach2() async {
    final dio = _getIt<Dio>(instanceName: 'approach2');

    // 2a. Internal request → interceptor attaches "Authorization: Bearer ...".
    final internalResponse = await dio.get<Map<String, dynamic>>(
      '/user/profile',
    );
    _log(
      'Approach 2 – internal (with Bearer token)',
      internalResponse.statusCode,
    );

    // 2b. External request → interceptor attaches "X-Api-Key: ...".
    final externalResponse = await dio.get<Map<String, dynamic>>(
      'https://api.other-service.com/data',
    );
    _log('Approach 2 – external (with API key)', externalResponse.statusCode);
  }

  // ===== Approach 3: Multiple Named Instances ==============================
  //
  // Each service gets its OWN Dio singleton registered under a unique
  // instanceName. Configuration (baseUrl, timeouts, interceptors) is
  // completely independent.
  //
  // Pros:
  //   - Full isolation – changing one service cannot break another.
  //   - Each Dio has exactly the interceptors it needs – no branching.
  //   - Easier to mock / replace in tests via get_it overrides.
  //
  // Cons:
  //   - More registrations and slightly more boilerplate.
  //   - Callers must remember (or typedef) the instanceName string.
  //   - No shared interceptor stack – common logic (logging) must be added
  //     to every instance or extracted into a factory helper.

  Future<void> demoApproach3() async {
    // Resolve by name.
    final mainDio = _getIt<Dio>(instanceName: 'approach3_main');
    final otherDio = _getIt<Dio>(instanceName: 'approach3_other');

    // 3a. Internal request via the "main" instance.
    final mainResponse = await mainDio.get<Map<String, dynamic>>(
      '/user/profile',
    );
    _log('Approach 3 – main instance', mainResponse.statusCode);

    // 3b. External request via the "other" named instance.
    final otherResponse = await otherDio.get<Map<String, dynamic>>('/data');
    _log('Approach 3 – other instance', otherResponse.statusCode);
  }

  // ===== Helper ============================================================

  // ignore: avoid_print
  void _log(String label, int? statusCode) {
    // ignore: avoid_print
    print('[$label] status: $statusCode');
  }
}
