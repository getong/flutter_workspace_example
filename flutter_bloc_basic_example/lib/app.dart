import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme/theme_cubit.dart';
import 'counter/counter_page.dart';

/// {@template app}
/// A [StatelessWidget] that:
/// * uses [bloc](https://pub.dev/packages/bloc) and
/// [flutter_bloc](https://pub.dev/packages/flutter_bloc)
/// to manage the state of a counter and the app theme.
/// {@endtemplate}
class App extends StatelessWidget {
  /// {@macro app}
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ThemeCubit(),
      child: const AppView(),
    );
  }
}

/// {@template app_view}
/// A [StatelessWidget] that:
/// * reacts to state changes in the [ThemeCubit]
/// and updates the theme of the [MaterialApp].
/// * renders the [CounterPage].
/// * demonstrates BlocSelector usage.
/// {@endtemplate}
class AppView extends StatelessWidget {
  /// {@macro app_view}
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ThemeCubit, ThemeState, ThemeData>(
      selector: (state) => state.themeData,
      builder: (context, themeData) {
        return MaterialApp(
          theme: themeData,
          home: const CounterPageWithSelector(),
        );
      },
    );
  }
}

/// {@template counter_page_with_selector}
/// A wrapper that adds BlocSelector examples to the CounterPage.
/// {@endtemplate}
class CounterPageWithSelector extends StatelessWidget {
  /// {@macro counter_page_with_selector}
  const CounterPageWithSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const CounterPage(),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        color: Theme.of(context).colorScheme.surfaceVariant,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // BlocSelector example: Toggle count
            BlocSelector<ThemeCubit, ThemeState, int>(
              selector: (state) => state.toggleCount,
              builder: (context, toggleCount) {
                return Text(
                  'Theme toggles: $toggleCount',
                  style: Theme.of(context).textTheme.bodyMedium,
                );
              },
            ),
            // BlocSelector example: Dark mode status
            BlocSelector<ThemeCubit, ThemeState, bool>(
              selector: (state) => state.isDark,
              builder: (context, isDark) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isDark ? Icons.dark_mode : Icons.light_mode,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isDark ? 'Dark' : 'Light',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
