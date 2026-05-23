import 'package:squadron/squadron.dart';
import 'package:widget_layout_example2/features/squadron/data/services/squadron_worker_service.dart';
import 'package:widget_layout_example2/features/squadron/domain/entities/squadron_models.dart';
import 'package:widget_layout_example2/features/squadron/domain/repositories/squadron_repository.dart';

class SquadronRepositoryImpl implements SquadronRepository {
  @override
  Future<SquadronRunReport> runCpuBatch(List<SquadronWorkItem> items) async {
    final SquadronCpuService service = SquadronCpuService();
    final Stopwatch stopwatch = Stopwatch()..start();
    final List<SquadronWorkResult> results = await Future.wait(
      <Future<SquadronWorkResult>>[
        for (final SquadronWorkItem item in items) _run(service, item),
      ],
    );
    stopwatch.stop();

    return SquadronRunReport(
      mainThreadId: threadId,
      results: results,
      workerCount: 0,
      totalWorkload: results.length,
      totalErrors: 0,
      elapsed: stopwatch.elapsed,
    );
  }

  Future<SquadronWorkResult> _run(
    SquadronCpuService service,
    SquadronWorkItem item,
  ) async {
    final Map<String, Object> map = await service.runDigest(
      item.label,
      item.seed,
    );
    return SquadronWorkResult(
      label: map['label']! as String,
      seed: map['seed']! as int,
      digest: map['digest']! as int,
      threadId: map['threadId']! as String,
    );
  }
}
