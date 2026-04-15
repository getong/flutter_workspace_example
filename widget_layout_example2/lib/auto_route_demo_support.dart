import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:widget_layout_example2/auth/auth.dart';

final AppAuthBloc appAuthBloc = AppAuthBloc();
final DemoAuthController demoAuthController = DemoAuthController(appAuthBloc);
final DemoNavigationLog demoNavigationLog = DemoNavigationLog();

class DemoAuthController extends ChangeNotifier {
  DemoAuthController(this._bloc) {
    _subscription = _bloc.stream.listen((AppAuthState _) {
      notifyListeners();
    });
  }

  final AppAuthBloc _bloc;
  late final StreamSubscription<AppAuthState> _subscription;

  bool get isLoggedIn => _bloc.state.isAuthenticated;

  void login({String username = 'Guest', String password = 'password'}) {
    if (isLoggedIn) {
      return;
    }

    _bloc.add(AppAuthLoginRequested(username: username, password: password));
  }

  void logout() {
    if (!isLoggedIn) {
      return;
    }

    _bloc.add(const AppAuthLogoutRequested());
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

class DemoNavigationLog extends ChangeNotifier {
  final List<String> _entries = <String>[];
  bool _notifyScheduled = false;

  List<String> get entries => List<String>.unmodifiable(_entries);

  void add(String message) {
    final DateTime now = DateTime.now();
    final String timestamp =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
    _entries.insert(0, '$timestamp  $message');
    if (_entries.length > 60) {
      _entries.removeRange(60, _entries.length);
    }
    _notifySafely();
  }

  void clear() {
    _entries.clear();
    _notifySafely();
  }

  void _notifySafely() {
    final SchedulerPhase phase = SchedulerBinding.instance.schedulerPhase;
    if (phase == SchedulerPhase.idle) {
      notifyListeners();
      return;
    }

    if (_notifyScheduled) {
      return;
    }

    _notifyScheduled = true;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _notifyScheduled = false;
      notifyListeners();
    });
  }
}

class DemoAutoRouterObserver extends AutoRouterObserver {
  DemoAutoRouterObserver(this._log);

  final DemoNavigationLog _log;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _log.add(
      'push ${route.settings.name} <- ${previousRoute?.settings.name ?? 'none'}',
    );
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _log.add(
      'pop ${route.settings.name} -> ${previousRoute?.settings.name ?? 'none'}',
    );
    super.didPop(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    _log.add(
      'replace ${oldRoute?.settings.name ?? 'none'} -> ${newRoute?.settings.name ?? 'none'}',
    );
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  @override
  void didInitTabRoute(TabPageRoute route, TabPageRoute? previousRoute) {
    _log.add('tab init ${route.name} <- ${previousRoute?.name ?? 'none'}');
    super.didInitTabRoute(route, previousRoute);
  }

  @override
  void didChangeTabRoute(TabPageRoute route, TabPageRoute previousRoute) {
    _log.add('tab change ${previousRoute.name} -> ${route.name}');
    super.didChangeTabRoute(route, previousRoute);
  }
}
