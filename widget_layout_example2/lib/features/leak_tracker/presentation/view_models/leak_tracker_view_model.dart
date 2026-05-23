import 'package:flutter/foundation.dart';
import 'package:widget_layout_example2/features/leak_tracker/domain/entities/leak_tracker_models.dart';
import 'package:widget_layout_example2/features/leak_tracker/domain/repositories/leak_tracker_repository.dart';

class LeakTrackerViewModel extends ChangeNotifier {
  LeakTrackerViewModel({required LeakTrackerRepository repository})
    : _repository = repository;

  final LeakTrackerRepository _repository;

  LeakTrackerRunResult? _result;
  LeakTrackerRunResult? get result => _result;

  bool _isRunning = false;
  bool get isRunning => _isRunning;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> runScenario(LeakTrackerScenario scenario) async {
    _isRunning = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _result = await _repository.runScenario(scenario);
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isRunning = false;
      notifyListeners();
    }
  }
}
