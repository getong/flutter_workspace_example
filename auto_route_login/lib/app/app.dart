import 'package:auto_route_login/app/di/injection.dart';
import 'package:auto_route_login/app/router/app_router.dart';
import 'package:auto_route_login/app/router/auth_guard.dart';
import 'package:auto_route_login/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final AuthCubit _authCubit = getIt<AuthCubit>();
  late final AppRouter _appRouter = AppRouter(AuthGuard(_authCubit));

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>.value(
      value: _authCubit,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Auth Flow Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF0F766E),
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: const Color(0xFFF4F7F5),
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(),
          ),
        ),
        routerConfig: _appRouter.config(),
      ),
    );
  }
}
