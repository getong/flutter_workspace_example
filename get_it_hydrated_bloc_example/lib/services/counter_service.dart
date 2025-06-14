class CounterService {
  int _count = 0;

  int get count => _count;
  set count(int value) => _count = value;

  void increment() => _count++;
  void decrement() => _count--;
  void reset() => _count = 0;
}
