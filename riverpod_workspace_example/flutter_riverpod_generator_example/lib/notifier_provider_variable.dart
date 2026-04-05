import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notifier_provider_variable.g.dart';

@riverpod
class NotifierCounter extends _$NotifierCounter {
  @override
  int build() {
    return 0;
  }

  void increment() {
    state++;
  }
}
