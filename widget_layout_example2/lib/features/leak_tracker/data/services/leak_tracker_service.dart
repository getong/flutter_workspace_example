import 'package:leak_tracker/leak_tracker.dart';
import 'package:widget_layout_example2/features/leak_tracker/domain/entities/leak_tracker_models.dart';

class LeakTrackerService {
  Future<LeakTrackerRunResult> runScenario(LeakTrackerScenario scenario) async {
    final bool assertsEnabled = _assertsEnabled();
    const String trackedClass = 'TrackedDemoController';

    if (!assertsEnabled) {
      return LeakTrackerRunResult(
        scenario: scenario,
        assertsEnabled: false,
        trackedClass: trackedClass,
        createdObjects: 0,
        disposedObjects: 0,
        notDisposedLeaks: 0,
        notGcedLeaks: 0,
        gcedLateLeaks: 0,
        details: const <String>[
          'LeakTracking.start() is implemented behind assertions.',
          'Run the app in debug/profile mode to collect leak events.',
        ],
      );
    }

    final TrackedDemoController controller = TrackedDemoController(
      scenario.name,
    );
    final List<String> details = <String>[];

    LeakTracking.start(
      config: LeakTrackingConfig.passive(disposalTime: Duration.zero),
      resetIfAlreadyStarted: true,
    );
    LeakTracking.phase = PhaseSettings(name: scenario.name);

    try {
      LeakTracking.dispatchObjectCreated(
        library: 'widget_layout_example2.features.leak_tracker',
        className: trackedClass,
        object: controller,
        context: <String, Object>{
          'scenario': scenario.name,
          'ownerLayer': 'data service',
        },
      );
      details.add('dispatchObjectCreated() recorded one $trackedClass.');

      if (scenario.disposeObject) {
        controller.dispose();
        LeakTracking.dispatchObjectDisposed(
          object: controller,
          context: const <String, Object>{'method': 'dispose'},
        );
        details.add('dispatchObjectDisposed() marked the object as released.');
      } else {
        details.add('dispose() was intentionally skipped for the demo.');
        LeakTracking.declareNotDisposedObjectsAsLeaks();
        details.add(
          'declareNotDisposedObjectsAsLeaks() promoted it to a leak.',
        );
      }

      final Leaks leaks = await LeakTracking.collectLeaks();
      details.addAll(_formatLeakDetails(leaks));

      return LeakTrackerRunResult(
        scenario: scenario,
        assertsEnabled: true,
        trackedClass: trackedClass,
        createdObjects: 1,
        disposedObjects: scenario.disposeObject ? 1 : 0,
        notDisposedLeaks: leaks.notDisposed.length,
        notGcedLeaks: leaks.notGCed.length,
        gcedLateLeaks: leaks.gcedLate.length,
        details: details,
      );
    } finally {
      LeakTracking.phase = const PhaseSettings();
      LeakTracking.stop();
    }
  }

  List<String> _formatLeakDetails(Leaks leaks) {
    if (leaks.total == 0) {
      return const <String>['collectLeaks() returned an empty leak set.'];
    }

    return <String>[
      for (final LeakReport report in leaks.all)
        '${report.type} -> ${report.trackedClass} '
            '(${report.phase ?? 'no phase'})',
    ];
  }

  bool _assertsEnabled() {
    var enabled = false;
    assert(() {
      enabled = true;
      return true;
    }());
    return enabled;
  }
}

class TrackedDemoController {
  TrackedDemoController(this.label);

  final String label;
  bool isDisposed = false;

  void dispose() {
    isDisposed = true;
  }
}
