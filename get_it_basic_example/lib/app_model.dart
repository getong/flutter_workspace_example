import 'package:flutter/material.dart';
import 'package:get_it_basic_example/services/data_repository.dart';
import 'package:get_it_basic_example/service_locator.dart';

abstract class AppModel extends ChangeNotifier {
  void incrementCounter();

  int get counter;

  Future<void> saveData();
}

class AppModelImplementation extends AppModel {
  int _counter = 0;
  late final DataRepository _dataRepository;

  AppModelImplementation() {
    _dataRepository = getIt<DataRepository>();
    _initialize();
  }

  void _initialize() async {
    // Load initial counter value from repository
    final data = await _dataRepository.getData();
    if (data.isNotEmpty) {
      _counter = int.tryParse(data.first) ?? 0;
      notifyListeners();
    }
  }

  @override
  int get counter => _counter;

  @override
  void incrementCounter() {
    _counter++;
    notifyListeners();
    saveData(); // Auto-save on increment
  }

  @override
  Future<void> saveData() async {
    await _dataRepository.saveData(_counter.toString());
  }
}
