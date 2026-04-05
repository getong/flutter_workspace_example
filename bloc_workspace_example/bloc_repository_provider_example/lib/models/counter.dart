import 'package:equatable/equatable.dart';

class Counter extends Equatable {
  final int value;

  const Counter({required this.value});

  Counter copyWith({int? value}) {
    return Counter(value: value ?? this.value);
  }

  @override
  List<Object> get props => [value];
}
