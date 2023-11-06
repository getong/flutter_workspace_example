import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// Create keys for `root` & `section` navigator avoiding unnecessary rebuilds
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _sectionNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/feed',
  routes: <RouteBase>[
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        // Return the widget that implements the custom shell (e.g a BottomNavigationBar).
        // The [StatefulNavigationShell] is passed to be able to navigate to other branches in a stateful way.
        return ScaffoldWithNavbar(navigationShell);
      },
      branches: [
        // The route branch for the 1º Tab
        StatefulShellBranch(
          navigatorKey: _sectionNavigatorKey,
          // Add this branch routes
          // each routes with its sub routes if available e.g feed/uuid/details
          routes: <RouteBase>[
            GoRoute(
              path: '/feed',
              builder: (context, state) => const FeedPage(),
              routes: <RouteBase>[
                GoRoute(
                  path: 'details',
                  builder: (context, state) {
                    return const DetailsPage(label: 'FeedDetails');
                  },
                ),
                GoRoute(
                  path: 'homepage',
                  builder: (BuildContext context, GoRouterState state) {
                    return BlocProvider(
                      create: (context) => CounterBloc(),
                      child: MyHomePage(),
                    );
                  },
                ),
                GoRoute(
                  path: 'blocdetails/:value',
                  builder: (BuildContext context, GoRouterState state) {
                    final String value = state.pathParameters['value']!;
                    return BlocDetailsPage(value: value);
                  },
                ),
              ],
            ),
          ],
        ),

        // The route branch for 2º Tab
        StatefulShellBranch(routes: <RouteBase>[
          // Add this branch routes
          // each routes with its sub routes if available e.g shope/uuid/details
          GoRoute(
            path: '/shope',
            builder: (context, state) {
              return const DetailsPage(label: 'Shope');
            },
          ),
        ])
      ],
    ),
  ],
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}

class ScaffoldWithNavbar extends StatelessWidget {
  const ScaffoldWithNavbar(this.navigationShell, {super.key});

  /// The navigation shell and container for the branch Navigators.
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shop), label: 'Shope'),
        ],
        onTap: _onTap,
      ),
    );
  }

  void _onTap(index) {
    navigationShell.goBranch(
      index,
      // A common pattern when using bottom navigation bars is to support
      // navigating to the initial location when tapping the item that is
      // already active. This example demonstrates how to support this behavior,
      // using the initialLocation parameter of goBranch.
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key, this.label, this.child});

  final String? label;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: child ??
            Text(
              label ?? '',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
      ),
    );
  }
}

class FeedPage extends StatelessWidget {
  const FeedPage({super.key, this.label, this.child});

  final String? label;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Feed',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: () => context.go('/feed/details'),
              child: const Text('Go to feed/details'),
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: () => context.go('/shope'),
              child: const Text('Go to shope'),
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: () => context.go('/feed/homepage'),
              child: const Text('Go to bloc'),
            ),
          ],
        ),
      ),
    );
  }
}

// Define your BLoC and states/events as needed
enum CounterEvent { increment, decrement }

class CounterBloc extends Bloc<CounterEvent, int> {
  CounterBloc() : super(0) {
    on<CounterEvent>((event, emit) {
      switch (event) {
        case CounterEvent.increment:
          emit(state + 1);
          break;
        case CounterEvent.decrement:
          emit(state - 1);
          break;
      }
    });
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: BlocBuilder<CounterBloc, int>(
        builder: (context, count) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('You have pushed the button this many times: $count'),
                ElevatedButton(
                  child: Text('Go to Details'),
                  onPressed: () {
                    context.push('/feed/blocdetails/$count');
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            BlocProvider.of<CounterBloc>(context).add(CounterEvent.increment),
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

class BlocDetailsPage extends StatelessWidget {
  final String value;

  const BlocDetailsPage({Key? key, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bloc Details')),
      body: Center(
        child: Text('Passed value: $value'),
      ),
    );
  }
}

// copy from https://github.com/antonio-nicolau/flutter-go_router-with-nested-tab-navigation
// also see https://juejin.cn/post/7270343009790853172
