import 'package:widget_layout_example2/features/leak_tracker/data/services/leak_tracker_service.dart';
import 'package:widget_layout_example2/features/leak_tracker/domain/entities/leak_tracker_models.dart';
import 'package:widget_layout_example2/features/leak_tracker/domain/repositories/leak_tracker_repository.dart';

class LeakTrackerRepositoryImpl implements LeakTrackerRepository {
  const LeakTrackerRepositoryImpl({required this.service});

  final LeakTrackerService service;

  @override
  Future<LeakTrackerRunResult> runScenario(LeakTrackerScenario scenario) {
    return service.runScenario(scenario);
  }
}
