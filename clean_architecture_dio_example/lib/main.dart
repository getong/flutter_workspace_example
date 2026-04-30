import 'package:flutter/material.dart';

import 'app_router.dart';
import 'core/di/di.dart';
import 'features/advice/data/local/advice_database.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  late final AppRouter _appRouter;
  late final AdviceDatabase _adviceDatabase;
  bool _isClosingDatabase = false;
  Future<void>? _pendingClose;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _appRouter = getIt<AppRouter>();
    _adviceDatabase = getIt<AdviceDatabase>();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.hidden ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _closeDatabaseIfNeeded();
    }
  }

  Future<void> _closeDatabaseIfNeeded() {
    if (_isClosingDatabase) {
      return _pendingClose ?? Future.value();
    }

    _isClosingDatabase = true;
    _pendingClose = _adviceDatabase.close().whenComplete(() {
      _isClosingDatabase = false;
      _pendingClose = null;
    });
    return _pendingClose!;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Advice Generator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      routerConfig: _appRouter.config(),
    );
  }
}
