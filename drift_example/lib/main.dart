import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'app_router.dart';
import 'data/app_database.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const DriftExampleApp());
}

class DriftExampleApp extends StatefulWidget {
  const DriftExampleApp({super.key, this.database});

  final AppDatabase? database;

  @override
  State<DriftExampleApp> createState() => _DriftExampleAppState();
}

class _DriftExampleAppState extends State<DriftExampleApp> {
  late final bool _ownsDatabase = widget.database == null;
  late final AppDatabase _database = widget.database ?? AppDatabase();
  late final GoRouter _router = createAppRouter(_database);

  @override
  void dispose() {
    _router.dispose();
    if (_ownsDatabase) {
      _database.close();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      title: 'Drift Todo Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
    );
  }
}
