import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';

Future<QueryExecutor> createAdviceQueryExecutor() async {
  final appSupportDirectory = await getApplicationSupportDirectory();
  final databaseDirectory = Directory('${appSupportDirectory.path}/databases');

  if (!databaseDirectory.existsSync()) {
    databaseDirectory.createSync(recursive: true);
  }

  final file = File('${databaseDirectory.path}/advice_cache.sqlite');

  return NativeDatabase.createInBackground(
    file,
    setup: (database) {
      database.execute('PRAGMA journal_mode = WAL;');
      database.execute('PRAGMA synchronous = NORMAL;');
      database.execute('PRAGMA foreign_keys = ON;');
    },
  );
}
