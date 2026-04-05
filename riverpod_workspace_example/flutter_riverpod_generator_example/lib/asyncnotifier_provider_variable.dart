import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'asyncnotifier_provider_variable.g.dart';

@riverpod
class AsyncNotifierCounter extends _$AsyncCounter {
  @override
  Future<int> build() {
    return 0;
  }

  void increment() {
    state++;
  }
}
