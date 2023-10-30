import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stream_provider_variable.g.dart';

@riverpod
Stream<int> streamValue(ValuesRef ref) {
  return Stream.fromIterable([1, 2, 3]);
}
