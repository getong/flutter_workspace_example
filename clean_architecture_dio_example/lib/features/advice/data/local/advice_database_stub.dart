import 'package:drift/drift.dart';
import 'package:drift/native.dart';

QueryExecutor createAdviceQueryExecutor() {
  return NativeDatabase.memory();
}
