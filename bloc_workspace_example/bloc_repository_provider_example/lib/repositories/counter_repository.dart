import '../models/counter.dart';

abstract class CounterRepository {
  Future<Counter> getCounter();
  Future<Counter> incrementCounter();
  Future<Counter> decrementCounter();
  Future<void> resetCounter();
}

class CounterRepositoryImpl implements CounterRepository {
  Counter _counter = const Counter(value: 0);

  @override
  Future<Counter> getCounter() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    return _counter;
  }

  @override
  Future<Counter> incrementCounter() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _counter = _counter.copyWith(value: _counter.value + 1);
    return _counter;
  }

  @override
  Future<Counter> decrementCounter() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _counter = _counter.copyWith(value: _counter.value - 1);
    return _counter;
  }

  @override
  Future<void> resetCounter() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _counter = const Counter(value: 0);
  }
}
