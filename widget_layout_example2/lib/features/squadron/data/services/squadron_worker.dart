import 'package:squadron/squadron.dart';
import 'package:widget_layout_example2/features/squadron/data/services/squadron_worker_service.dart';
import 'package:widget_layout_example2/features/squadron/domain/entities/squadron_models.dart';

class SquadronCpuWorker extends Worker {
  SquadronCpuWorker(super.entryPoint, {super.exceptionManager});

  @override
  List? getStartArgs() => null;

  Future<SquadronWorkResult> runDigest(SquadronWorkItem item) async {
    final dynamic response = await send(
      SquadronCpuWorkerService.runDigestCommand,
      args: <Object>[item.label, item.seed],
    );
    final Map<Object?, Object?> map = response as Map<Object?, Object?>;

    return SquadronWorkResult(
      label: map['label'] as String,
      seed: map['seed'] as int,
      digest: map['digest'] as int,
      threadId: map['threadId'] as String,
    );
  }
}

class SquadronCpuWorkerPool extends WorkerPool<SquadronCpuWorker> {
  SquadronCpuWorkerPool(EntryPoint entryPoint)
    : super(
        (ExceptionManager exceptionManager) =>
            SquadronCpuWorker(entryPoint, exceptionManager: exceptionManager),
        concurrencySettings: ConcurrencySettings.threeCpuThreads,
      );

  Future<SquadronWorkResult> runDigest(SquadronWorkItem item) {
    return execute((SquadronCpuWorker worker) => worker.runDigest(item));
  }
}
