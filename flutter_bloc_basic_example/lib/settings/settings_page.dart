import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme/theme_cubit.dart';

/// {@template settings_page}
/// A page that demonstrates MultiBlocProvider usage by consuming
/// both ThemeCubit and SettingsCubit provided by the ancestor MultiBlocProvider.
/// Also demonstrates BlocListener and MultiBlocListener usage.
/// {@endtemplate}
class SettingsPage extends StatelessWidget {
  /// {@macro settings_page}
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // BlocListener for ThemeCubit - listen to theme changes
        BlocListener<ThemeCubit, ThemeState>(
          listenWhen: (previous, current) => previous.isDark != current.isDark,
          listener: (context, state) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Theme changed to ${state.isDark ? 'Dark' : 'Light'} mode',
                ),
                duration: const Duration(seconds: 1),
              ),
            );
          },
        ),
        // BlocListener for SettingsCubit - general settings changes
        BlocListener<SettingsCubit, SettingsState>(
          listener: (context, state) {
            // Log all settings changes (in real app, this might be analytics)
            debugPrint('Settings updated: fontSize=${state.fontSize}, '
                'animations=${state.enableAnimations}, language=${state.language}, '
                'notifications=${state.notificationsEnabled}, sound=${state.soundEnabled}');
          },
        ),
        // BlocListener for SettingsCubit - specific notification changes
        BlocListener<SettingsCubit, SettingsState>(
          listenWhen: (previous, current) =>
              previous.notificationsEnabled != current.notificationsEnabled,
          listener: (context, state) {
            final message = state.notificationsEnabled
                ? 'Notifications enabled - You will receive app updates'
                : 'Notifications disabled - You will not receive updates';
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor:
                    state.notificationsEnabled ? Colors.green : Colors.orange,
                action: SnackBarAction(
                  label: 'UNDO',
                  onPressed: () =>
                      context.read<SettingsCubit>().toggleNotifications(),
                ),
              ),
            );
          },
        ),
        // BlocListener for SettingsCubit - sound settings
        BlocListener<SettingsCubit, SettingsState>(
          listenWhen: (previous, current) =>
              previous.soundEnabled != current.soundEnabled,
          listener: (context, state) {
            if (state.soundEnabled && !state.notificationsEnabled) {
              // Show warning if sound is enabled but notifications are disabled
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Sound Settings'),
                  content: const Text(
                    'Sound is enabled but notifications are disabled. '
                    'Enable notifications to hear sound alerts.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<SettingsCubit>().toggleNotifications();
                        Navigator.of(context).pop();
                      },
                      child: const Text('Enable Notifications'),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Settings - MultiBlocListener Demo'),
        ),
        body: MultiBlocListener(
          listeners: [
            // Additional MultiBlocListener for complex state combinations
            BlocListener<ThemeCubit, ThemeState>(
              listenWhen: (previous, current) =>
                  current.toggleCount > 0 && current.toggleCount % 3 == 0,
              listener: (context, themeState) {
                // Listen for theme toggle patterns
                final settingsState = context.read<SettingsCubit>().state;
                if (settingsState.enableAnimations) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Theme Toggle Achievement!'),
                      content: Text(
                          'You\'ve toggled the theme ${themeState.toggleCount} times!'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cool!'),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
            BlocListener<SettingsCubit, SettingsState>(
              listenWhen: (previous, current) =>
                  previous.fontSize != current.fontSize &&
                  current.fontSize > 20,
              listener: (context, state) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                        'Large font size selected - Great for accessibility!'),
                    backgroundColor: Colors.blue,
                  ),
                );
              },
            ),
          ],
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Theme Settings Section
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Theme Settings',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 16),

                        // Theme toggle with BlocBuilder
                        BlocBuilder<ThemeCubit, ThemeState>(
                          builder: (context, themeState) {
                            return SwitchListTile(
                              title: const Text('Dark Mode'),
                              subtitle: Text(
                                  'Currently: ${themeState.isDark ? 'Dark' : 'Light'}'),
                              value: themeState.isDark,
                              onChanged: (_) {
                                context.read<ThemeCubit>().toggleTheme();
                              },
                            );
                          },
                        ),

                        // Theme toggle count display
                        BlocSelector<ThemeCubit, ThemeState, int>(
                          selector: (state) => state.toggleCount,
                          builder: (context, toggleCount) {
                            return ListTile(
                              title: const Text('Theme Toggles'),
                              trailing: Text('$toggleCount'),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // App Settings Section with BlocListener for language changes
                BlocListener<SettingsCubit, SettingsState>(
                  listenWhen: (previous, current) =>
                      previous.language != current.language,
                  listener: (context, state) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Language Changed'),
                        content: Text('Language updated to ${state.language}'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'App Settings',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 16),

                          // Font size slider
                          BlocBuilder<SettingsCubit, SettingsState>(
                            builder: (context, settingsState) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'Font Size: ${settingsState.fontSize.toInt()}px'),
                                  Slider(
                                    value: settingsState.fontSize,
                                    min: 12.0,
                                    max: 24.0,
                                    divisions: 12,
                                    onChanged: (value) {
                                      context
                                          .read<SettingsCubit>()
                                          .updateFontSize(value);
                                    },
                                  ),
                                ],
                              );
                            },
                          ),

                          // Animations toggle with BlocListener
                          BlocListener<SettingsCubit, SettingsState>(
                            listenWhen: (previous, current) =>
                                previous.enableAnimations !=
                                current.enableAnimations,
                            listener: (context, state) {
                              final message = state.enableAnimations
                                  ? 'Animations enabled'
                                  : 'Animations disabled';
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(message)),
                              );
                            },
                            child: BlocSelector<SettingsCubit, SettingsState,
                                bool>(
                              selector: (state) => state.enableAnimations,
                              builder: (context, enableAnimations) {
                                return SwitchListTile(
                                  title: const Text('Enable Animations'),
                                  value: enableAnimations,
                                  onChanged: (_) {
                                    context
                                        .read<SettingsCubit>()
                                        .toggleAnimations();
                                  },
                                );
                              },
                            ),
                          ),

                          // Language dropdown
                          BlocBuilder<SettingsCubit, SettingsState>(
                            builder: (context, settingsState) {
                              return ListTile(
                                title: const Text('Language'),
                                trailing: DropdownButton<String>(
                                  value: settingsState.language,
                                  items:
                                      ['English', 'Spanish', 'French', 'German']
                                          .map((lang) => DropdownMenuItem(
                                                value: lang,
                                                child: Text(lang),
                                              ))
                                          .toList(),
                                  onChanged: (language) {
                                    if (language != null) {
                                      context
                                          .read<SettingsCubit>()
                                          .changeLanguage(language);
                                    }
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // New Notification Settings Section
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Notification Settings',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 16),

                        // Notifications toggle
                        BlocBuilder<SettingsCubit, SettingsState>(
                          builder: (context, state) {
                            return SwitchListTile(
                              title: const Text('Enable Notifications'),
                              subtitle: Text(state.notificationsEnabled
                                  ? 'You will receive updates'
                                  : 'Updates are disabled'),
                              value: state.notificationsEnabled,
                              onChanged: (_) {
                                context
                                    .read<SettingsCubit>()
                                    .toggleNotifications();
                              },
                            );
                          },
                        ),

                        // Sound toggle with dependency on notifications
                        BlocConsumer<SettingsCubit, SettingsState>(
                          listenWhen: (previous, current) =>
                              previous.soundEnabled != current.soundEnabled,
                          listener: (context, state) {
                            if (state.soundEnabled) {
                              // Simulate playing a test sound
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('🔊 Test sound played!'),
                                  duration: Duration(milliseconds: 500),
                                ),
                              );
                            }
                          },
                          buildWhen: (previous, current) =>
                              previous.soundEnabled != current.soundEnabled ||
                              previous.notificationsEnabled !=
                                  current.notificationsEnabled,
                          builder: (context, state) {
                            return SwitchListTile(
                              title: const Text('Sound Alerts'),
                              subtitle: Text(state.soundEnabled
                                  ? 'Sound enabled'
                                  : 'Silent mode'),
                              value: state.soundEnabled,
                              onChanged: state.notificationsEnabled
                                  ? (_) => context
                                      .read<SettingsCubit>()
                                      .toggleSound()
                                  : null, // Disabled if notifications are off
                              secondary: Icon(
                                state.soundEnabled
                                    ? Icons.volume_up
                                    : Icons.volume_off,
                                color: state.notificationsEnabled
                                    ? (state.soundEnabled
                                        ? Colors.blue
                                        : Colors.grey)
                                    : Colors.grey[400],
                              ),
                            );
                          },
                        ),

                        // BlocConsumer for font size with live preview
                        const SizedBox(height: 16),
                        BlocConsumer<SettingsCubit, SettingsState>(
                          listenWhen: (previous, current) =>
                              previous.fontSize != current.fontSize,
                          listener: (context, state) {
                            // Provide haptic feedback for font size changes
                            if (state.fontSize >= 20) {
                              // Show accessibility tip
                              if (state.fontSize == 20) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        '💡 Large fonts improve readability!'),
                                    backgroundColor: Colors.blue,
                                  ),
                                );
                              }
                            }
                          },
                          builder: (context, state) {
                            return Card(
                              elevation: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.format_size),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Font Size Preview',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'This is how your text will look',
                                      style:
                                          TextStyle(fontSize: state.fontSize),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                        'Current size: ${state.fontSize.toInt()}px'),
                                    Slider(
                                      value: state.fontSize,
                                      min: 12.0,
                                      max: 24.0,
                                      divisions: 12,
                                      onChanged: (value) {
                                        context
                                            .read<SettingsCubit>()
                                            .updateFontSize(value);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Combined state display using MultiBlocBuilder pattern
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Combined State (MultiBlocProvider Demo)',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 16),

                        // Using multiple BlocSelector widgets to combine state
                        Builder(
                          builder: (context) {
                            return BlocSelector<ThemeCubit, ThemeState, bool>(
                              selector: (themeState) => themeState.isDark,
                              builder: (context, isDark) {
                                return BlocSelector<SettingsCubit,
                                    SettingsState, String>(
                                  selector: (settingsState) =>
                                      '${settingsState.language} - ${settingsState.fontSize.toInt()}px - ${settingsState.enableAnimations ? 'Animated' : 'Static'}',
                                  builder: (context, settingsInfo) {
                                    return Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: isDark
                                            ? Colors.grey[800]
                                            : Colors.grey[200],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Current Configuration:',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                              'Theme: ${isDark ? 'Dark' : 'Light'}'),
                                          Text('Settings: $settingsInfo'),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                // Multi-BlocConsumer example - combining theme and settings
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Multi-BlocConsumer Demo',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 16),

                        // BlocConsumer combining theme and settings state
                        BlocConsumer<ThemeCubit, ThemeState>(
                          listener: (context, themeState) {
                            // Listen to theme changes and check settings compatibility
                            final settingsState =
                                context.read<SettingsCubit>().state;
                            if (themeState.isDark &&
                                settingsState.fontSize < 16) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                      '💡 Consider larger fonts in dark mode for better readability'),
                                  action: SnackBarAction(
                                    label: 'Increase',
                                    onPressed: () {
                                      context
                                          .read<SettingsCubit>()
                                          .updateFontSize(18.0);
                                    },
                                  ),
                                ),
                              );
                            }
                          },
                          builder: (context, themeState) {
                            return BlocConsumer<SettingsCubit, SettingsState>(
                              listenWhen: (previous, current) =>
                                  previous.language != current.language,
                              listener: (context, settingsState) {
                                // Announce language changes with current theme context
                                final themeMode =
                                    themeState.isDark ? 'dark' : 'light';
                                debugPrint(
                                    'Language changed to ${settingsState.language} in $themeMode mode');
                              },
                              builder: (context, settingsState) {
                                return Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: themeState.isDark
                                          ? [
                                              Colors.grey[800]!,
                                              Colors.grey[700]!
                                            ]
                                          : [
                                              Colors.blue[50]!,
                                              Colors.blue[100]!
                                            ],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: themeState.isDark
                                          ? Colors.grey[600]!
                                          : Colors.blue[200]!,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Combined State Display',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.copyWith(
                                              fontSize:
                                                  settingsState.fontSize + 2,
                                            ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        '🎨 Theme: ${themeState.isDark ? 'Dark' : 'Light'} (${themeState.toggleCount} toggles)',
                                        style: TextStyle(
                                            fontSize: settingsState.fontSize),
                                      ),
                                      Text(
                                        '🌍 Language: ${settingsState.language}',
                                        style: TextStyle(
                                            fontSize: settingsState.fontSize),
                                      ),
                                      Text(
                                        '🔤 Font Size: ${settingsState.fontSize.toInt()}px',
                                        style: TextStyle(
                                            fontSize: settingsState.fontSize),
                                      ),
                                      Text(
                                        '${settingsState.enableAnimations ? '✨' : '⚡'} Animations: ${settingsState.enableAnimations ? 'Enabled' : 'Disabled'}',
                                        style: TextStyle(
                                            fontSize: settingsState.fontSize),
                                      ),
                                      Text(
                                        '${settingsState.notificationsEnabled ? '🔔' : '🔕'} Notifications: ${settingsState.notificationsEnabled ? 'On' : 'Off'}',
                                        style: TextStyle(
                                            fontSize: settingsState.fontSize),
                                      ),
                                      Text(
                                        '${settingsState.soundEnabled ? '🔊' : '🔇'} Sound: ${settingsState.soundEnabled ? 'On' : 'Off'}',
                                        style: TextStyle(
                                            fontSize: settingsState.fontSize),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
