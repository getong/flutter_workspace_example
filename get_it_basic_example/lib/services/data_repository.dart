import 'dart:async';

class DataRepository {
  List<String> _data = [];
  bool _isInitialized = false;

  DataRepository._();

  static Future<DataRepository> create() async {
    final repository = DataRepository._();
    await repository._initialize();
    return repository;
  }

  Future<void> _initialize() async {
    // Simulate async initialization (e.g., loading from database)
    await Future.delayed(const Duration(seconds: 2));
    _data = ['Item 1', 'Item 2', 'Item 3'];
    _isInitialized = true;
  }

  Future<List<String>> getData() async {
    if (!_isInitialized) {
      throw StateError('Repository not initialized');
    }
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_data);
  }

  Future<void> saveData(String item) async {
    if (!_isInitialized) {
      throw StateError('Repository not initialized');
    }
    _data.insert(0, 'Counter: $item');
    // Simulate save delay
    await Future.delayed(const Duration(milliseconds: 200));
  }

  Future<void> clearData() async {
    if (!_isInitialized) {
      throw StateError('Repository not initialized');
    }
    _data.clear();
  }
}
