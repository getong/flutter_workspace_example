import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'streamnotifier_provider_variable.g.dart';

@riverpod
class StreamNotifierCounter extends _$StreamNotifierCounter {
  @override
  Stream<int> build() {
    return Stream.fromIterable([1, 2, 3]);
  }
}
