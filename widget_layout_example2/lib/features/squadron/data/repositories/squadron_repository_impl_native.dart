import 'package:squadron/squadron.dart';
import 'package:widget_layout_example2/features/squadron/data/services/squadron_worker.dart';
import 'package:widget_layout_example2/features/squadron/data/services/squadron_worker_service.dart';
import 'package:widget_layout_example2/features/squadron/domain/entities/squadron_models.dart';
import 'package:widget_layout_example2/features/squadron/domain/repositories/squadron_repository.dart';

class SquadronRepositoryImpl implements SquadronRepository {
  @override
  Future<SquadronRunReport> runCpuBatch(List<SquadronWorkItem> items) async {
    final SquadronCpuWorkerPool pool = SquadronCpuWorkerPool(
      squadronCpuWorkerEntrypoint,
    );
    final Stopwatch stopwatch = Stopwatch()..start();

    try {
      await pool.start();
      final List<SquadronWorkResult> results = await Future.wait(
        <Future<SquadronWorkResult>>[
          for (final SquadronWorkItem item in items) pool.runDigest(item),
        ],
      );
      stopwatch.stop();

      final List<WorkerStat> stats = pool.fullStats.toList();
      return SquadronRunReport(
        mainThreadId: threadId,
        results: results,
        workerCount: stats.length,
        totalWorkload: stats.totalWorkload,
        totalErrors: stats.totalErrors,
        elapsed: stopwatch.elapsed,
      );
    } finally {
      pool.stop();
    }
  }
}
