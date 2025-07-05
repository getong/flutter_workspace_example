abstract class CounterEvent {}

class CounterIncremented extends CounterEvent {}

class CounterDecremented extends CounterEvent {}

class CounterReset extends CounterEvent {}

class CounterMultiplied extends CounterEvent {
  final int multiplier;
  CounterMultiplied(this.multiplier);
}

class CounterBatchIncrement extends CounterEvent {
  final int amount;
  CounterBatchIncrement(this.amount);
}
