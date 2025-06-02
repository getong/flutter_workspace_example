import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme/theme_cubit.dart';
import 'counter/counter_page.dart';
import 'settings/settings_page.dart';
import 'user/user_page.dart';
import 'analytics/analytics_page.dart';
import 'analytics/analytics_widget.dart';
import 'repository/user_repository.dart';
import 'repository/analytics_repository.dart';
import 'repository/cache_repository.dart';
import 'repository/composite_user_repository.dart';

/// {@template app}
/// A [StatelessWidget] that:
/// * uses [bloc](https://pub.dev/packages/bloc) and
/// [flutter_bloc](https://pub.dev/packages/flutter_bloc)
/// to manage the state of a counter and the app theme.
/// * demonstrates MultiBlocProvider and advanced RepositoryProvider usage.
/// {@endtemplate}
class App extends StatelessWidget {
  /// {@macro app}
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        // Base repositories
        RepositoryProvider<CacheRepository>(
          create: (context) => MockCacheRepository(),
        ),
        RepositoryProvider<AnalyticsRepository>(
          create: (context) => MockAnalyticsRepository(),
        ),

        // Base user repository
        RepositoryProvider<UserRepository>(
          create: (context) {
            // Create composite repository that uses other repositories
            return CompositeUserRepository(
              userRepository: MockUserRepository(),
              cacheRepository: context.read<CacheRepository>(),
              analyticsRepository: context.read<AnalyticsRepository>(),
            );
          },
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ThemeCubit>(
            create: (_) => ThemeCubit(),
          ),
          BlocProvider<SettingsCubit>(
            create: (_) => SettingsCubit(),
          ),
        ],
        child: const AppView(),
      ),
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
      appBar: AppBar(
        title: const Text('Counter with BlocSelector'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'users':
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const UserPage()),
                  );
                  break;
                case 'analytics':
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AnalyticsPage()),
                  );
                  break;
                case 'settings':
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const SettingsPage()),
                  );
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'users',
                child: Row(
                  children: [
                    Icon(Icons.people),
                    SizedBox(width: 8),
                    Text('Users'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'analytics',
                child: Row(
                  children: [
                    Icon(Icons.analytics),
                    SizedBox(width: 8),
                    Text('Analytics'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings),
                    SizedBox(width: 8),
                    Text('Settings'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: const CounterPage(),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        color: Theme.of(context).colorScheme.surfaceVariant,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Compact Analytics Widget
            Container(
              constraints:
                  const BoxConstraints(maxHeight: 70), // Reduced from 80
              child: const AnalyticsWidget(),
            ),
            const SizedBox(height: 8),

            // Repository composition info display
            BlocBuilder<ThemeCubit, ThemeState>(
              builder: (context, themeState) {
                final userRepository = context.read<UserRepository>();
                final analyticsRepository = context.read<AnalyticsRepository>();
                final cacheRepository = context.read<CacheRepository>();

                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color:
                        themeState.isDark ? Colors.grey[700] : Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Repository Composition',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '📊 Analytics: ${analyticsRepository.runtimeType}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        '💾 Cache: ${cacheRepository.runtimeType}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        '👥 Users: ${userRepository.runtimeType}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // BlocSelector example: Toggle count
                  BlocSelector<ThemeCubit, ThemeState, int>(
                    selector: (state) => state.toggleCount,
                    builder: (context, toggleCount) {
                      // Track theme toggles in analytics
                      if (toggleCount > 0) {
                        context.read<AnalyticsRepository>().trackEvent(
                          'theme_toggled',
                          {'toggle_count': toggleCount},
                        );
                      }

                      return Text(
                        'Theme toggles: $toggleCount',
                        style: Theme.of(context).textTheme.bodyMedium,
                      );
                    },
                  ),
                  const SizedBox(width: 16),
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
                  const SizedBox(width: 16),
                  // Additional BlocSelector: Font size from SettingsCubit
                  BlocSelector<SettingsCubit, SettingsState, double>(
                    selector: (state) => state.fontSize,
                    builder: (context, fontSize) {
                      return Text(
                        'Font: ${fontSize.toInt()}px',
                        style: Theme.of(context).textTheme.bodyMedium,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
