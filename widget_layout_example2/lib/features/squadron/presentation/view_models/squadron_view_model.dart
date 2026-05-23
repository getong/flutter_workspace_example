import 'package:flutter/foundation.dart';
import 'package:widget_layout_example2/features/squadron/domain/entities/squadron_models.dart';
import 'package:widget_layout_example2/features/squadron/domain/repositories/squadron_repository.dart';

class SquadronViewModel extends ChangeNotifier {
  SquadronViewModel({required SquadronRepository repository})
    : _repository = repository;

  final SquadronRepository _repository;

  SquadronRunReport? _report;
  SquadronRunReport? get report => _report;

  bool _isRunning = false;
  bool get isRunning => _isRunning;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> runBatch() async {
    _isRunning = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _report = await _repository.runCpuBatch(defaultSquadronWorkItems);
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isRunning = false;
      notifyListeners();
    }
  }
}
