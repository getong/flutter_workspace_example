import 'package:drift/drift.dart';
import 'package:drift/native.dart';

Future<QueryExecutor> createAdviceQueryExecutor() async {
  return NativeDatabase.memory();
}
