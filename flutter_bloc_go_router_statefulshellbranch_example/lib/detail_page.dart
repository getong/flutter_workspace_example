import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
