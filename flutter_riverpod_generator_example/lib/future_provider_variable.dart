import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'future_provider_variable.g.dart';

@riverpod
Future<int> futureCounter(ref) {
  // await Future.delayed(Duration(seconds: 1));
  return 1;
}
