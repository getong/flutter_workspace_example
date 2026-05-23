import 'package:squadron/squadron.dart';

class SquadronCpuService {
  Future<Map<String, Object>> runDigest(String label, int seed) async {
    var value = seed;

    for (var index = 0; index < 90000; index += 1) {
      value = (value * 1664525 + 1013904223 + index) & 0x7fffffff;
      value ^= value >> 13;
    }

    return <String, Object>{
      'label': label,
      'seed': seed,
      'digest': value,
      'threadId': threadId,
    };
  }
}

class SquadronCpuWorkerService extends SquadronCpuService
    implements WorkerService {
  static const int runDigestCommand = 1;

  @override
  late final OperationsMap operations = OperationsMap(<int, CommandHandler>{
    runDigestCommand: (WorkerRequest request) {
      return runDigest(request.args[0] as String, request.args[1] as int);
    },
  });
}

void squadronCpuWorkerEntrypoint(WorkerRequest command) {
  run((WorkerRequest request) => SquadronCpuWorkerService(), command);
}
