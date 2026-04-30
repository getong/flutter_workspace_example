import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';

QueryExecutor createAdviceQueryExecutor() {
  final file = File('${Directory.systemTemp.path}/advice_cache.sqlite');
  return NativeDatabase.createInBackground(file);
}
