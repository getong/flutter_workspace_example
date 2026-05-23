import 'package:widget_layout_example2/features/leak_tracker/domain/entities/leak_tracker_models.dart';

abstract interface class LeakTrackerRepository {
  Future<LeakTrackerRunResult> runScenario(LeakTrackerScenario scenario);
}
