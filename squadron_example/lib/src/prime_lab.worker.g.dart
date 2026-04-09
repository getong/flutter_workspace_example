// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'prime_lab.dart';

// **************************************************************************
// Generator: WorkerGenerator 9.0.0+2 (Squadron 7.4.3)
// **************************************************************************

// dart format width=80
/// Command ids used in operations map
const int _$scanPrimesId = 1;

/// WorkerService operations for PrimeLab
extension on PrimeLab {
  OperationsMap _$getOperations() => OperationsMap({
    _$scanPrimesId: ($req) async {
      final Map<String, Object> $res;
      try {
        final $dsr = _$Deser(contextAware: false);
        $res = await scanPrimes($dsr.$0($req.args[0]));
      } finally {}
      return $res;
    },
  });
}

/// Invoker for PrimeLab, implements the public interface to invoke the
/// remote service.
base mixin _$PrimeLab$Invoker on Invoker implements PrimeLab {
  @override
  Future<Map<String, Object>> scanPrimes(int limit) async {
    final dynamic $res = await send(_$scanPrimesId, args: [limit]);
    try {
      final $dsr = _$Deser(contextAware: false);
      return $dsr.$3($res);
    } finally {}
  }
}

/// Facade for PrimeLab, implements other details of the service unrelated to
/// invoking the remote service.
base mixin _$PrimeLab$Facade implements PrimeLab {
  @override
  bool _isPrime(int candidate) => throw UnimplementedError();
}

/// WorkerClient for PrimeLab
final class $PrimeLab$Client extends WorkerClient
    with _$PrimeLab$Invoker, _$PrimeLab$Facade
    implements PrimeLab {
  $PrimeLab$Client(PlatformChannel channelInfo)
    : super(Channel.deserialize(channelInfo)!);
}

/// Local worker extension for PrimeLab
extension $PrimeLabLocalWorkerExt on PrimeLab {
  // Get a fresh local worker instance.
  LocalWorker<PrimeLab> getLocalWorker([ExceptionManager? exceptionManager]) =>
      LocalWorker.create(this, _$getOperations(), exceptionManager);
}

/// WorkerService class for PrimeLab
base class _$PrimeLab$WorkerService extends PrimeLab implements WorkerService {
  _$PrimeLab$WorkerService() : super();

  @override
  OperationsMap get operations => _$getOperations();
}

/// Service initializer for PrimeLab
WorkerService $PrimeLabInitializer(WorkerRequest $req) =>
    _$PrimeLab$WorkerService();

/// Worker for PrimeLab
base class PrimeLabWorker extends Worker
    with _$PrimeLab$Invoker, _$PrimeLab$Facade
    implements PrimeLab {
  PrimeLabWorker({
    PlatformThreadHook? threadHook,
    ExceptionManager? exceptionManager,
  }) : super(
         $PrimeLabActivator(Squadron.platformType),
         threadHook: threadHook,
         exceptionManager: exceptionManager,
       );

  PrimeLabWorker.vm({
    PlatformThreadHook? threadHook,
    ExceptionManager? exceptionManager,
  }) : super(
         $PrimeLabActivator(SquadronPlatformType.vm),
         threadHook: threadHook,
         exceptionManager: exceptionManager,
       );

  @override
  List? getStartArgs() => null;
}

/// Worker pool for PrimeLab
base class PrimeLabWorkerPool extends WorkerPool<PrimeLabWorker>
    with _$PrimeLab$Facade
    implements PrimeLab {
  PrimeLabWorkerPool({
    PlatformThreadHook? threadHook,
    ExceptionManager? exceptionManager,
    ConcurrencySettings? concurrencySettings,
  }) : super(
         (ExceptionManager exceptionManager) => PrimeLabWorker(
           threadHook: threadHook,
           exceptionManager: exceptionManager,
         ),
         concurrencySettings: concurrencySettings,
         exceptionManager: exceptionManager,
       );

  PrimeLabWorkerPool.vm({
    PlatformThreadHook? threadHook,
    ExceptionManager? exceptionManager,
    ConcurrencySettings? concurrencySettings,
  }) : super(
         (ExceptionManager exceptionManager) => PrimeLabWorker.vm(
           threadHook: threadHook,
           exceptionManager: exceptionManager,
         ),
         concurrencySettings: concurrencySettings,
         exceptionManager: exceptionManager,
       );

  @override
  Future<Map<String, Object>> scanPrimes(int limit) =>
      execute((w) => w.scanPrimes(limit));
}

final class _$Deser extends MarshalingContext {
  _$Deser({super.contextAware});
  late final $0 = value<int>();
  late final $1 = value<String>();
  late final $2 = value<Object>();
  late final $3 = map<String, Object>(kcast: $1, vcast: $2);
}
