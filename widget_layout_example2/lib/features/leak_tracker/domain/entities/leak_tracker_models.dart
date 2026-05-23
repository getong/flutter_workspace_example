class LeakTrackerScenario {
  const LeakTrackerScenario({
    required this.name,
    required this.disposeObject,
    required this.description,
  });

  final String name;
  final bool disposeObject;
  final String description;
}

class LeakTrackerRunResult {
  const LeakTrackerRunResult({
    required this.scenario,
    required this.assertsEnabled,
    required this.trackedClass,
    required this.createdObjects,
    required this.disposedObjects,
    required this.notDisposedLeaks,
    required this.notGcedLeaks,
    required this.gcedLateLeaks,
    required this.details,
  });

  final LeakTrackerScenario scenario;
  final bool assertsEnabled;
  final String trackedClass;
  final int createdObjects;
  final int disposedObjects;
  final int notDisposedLeaks;
  final int notGcedLeaks;
  final int gcedLateLeaks;
  final List<String> details;

  int get totalLeaks => notDisposedLeaks + notGcedLeaks + gcedLateLeaks;

  String get summaryLabel {
    if (!assertsEnabled) {
      return 'Leak tracking is inactive outside debug/profile assertions.';
    }
    if (totalLeaks == 0) {
      return 'No leaks detected for this scenario.';
    }
    return '$totalLeaks leak(s) detected.';
  }
}

const LeakTrackerScenario disposedLeakTrackerScenario = LeakTrackerScenario(
  name: 'Correct disposal',
  disposeObject: true,
  description:
      'The tracked object dispatches both creation and disposal events, so the '
      'collector should not report a not-disposed leak.',
);

const LeakTrackerScenario leakedLeakTrackerScenario = LeakTrackerScenario(
  name: 'Missing disposal',
  disposeObject: false,
  description:
      'The tracked object dispatches a creation event but skips disposal. The '
      'repository asks leak_tracker to declare current not-disposed objects as '
      'leaks, which mirrors a focused test teardown check.',
);
