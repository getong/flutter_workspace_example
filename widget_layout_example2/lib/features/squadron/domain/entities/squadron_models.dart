class SquadronWorkItem {
  const SquadronWorkItem({required this.label, required this.seed});

  final String label;
  final int seed;
}

class SquadronWorkResult {
  const SquadronWorkResult({
    required this.label,
    required this.seed,
    required this.digest,
    required this.threadId,
  });

  final String label;
  final int seed;
  final int digest;
  final String threadId;
}

class SquadronRunReport {
  SquadronRunReport({
    required this.mainThreadId,
    required this.results,
    required this.workerCount,
    required this.totalWorkload,
    required this.totalErrors,
    required this.elapsed,
  }) : workerThreadIds = Set<String>.unmodifiable(
         results.map((SquadronWorkResult result) => result.threadId),
       );

  final String mainThreadId;
  final List<SquadronWorkResult> results;
  final Set<String> workerThreadIds;
  final int workerCount;
  final int totalWorkload;
  final int totalErrors;
  final Duration elapsed;

  String get elapsedLabel => '${elapsed.inMilliseconds} ms';

  String get workerThreadsLabel {
    if (workerThreadIds.isEmpty) {
      return 'No worker thread completed work.';
    }
    return workerThreadIds.join(', ');
  }
}

const List<SquadronWorkItem> defaultSquadronWorkItems = <SquadronWorkItem>[
  SquadronWorkItem(label: 'Resize metadata', seed: 4201),
  SquadronWorkItem(label: 'Hash preview bytes', seed: 8843),
  SquadronWorkItem(label: 'Prepare upload batch', seed: 12097),
  SquadronWorkItem(label: 'Score cache candidates', seed: 24031),
  SquadronWorkItem(label: 'Normalize palette', seed: 37139),
  SquadronWorkItem(label: 'Build search index', seed: 53189),
];
