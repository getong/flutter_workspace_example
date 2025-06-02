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
        // BlocListener for ThemeCubit
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
        // BlocListener for SettingsCubit
        BlocListener<SettingsCubit, SettingsState>(
          listener: (context, state) {
            // Log settings changes (in real app, this might be analytics)
            debugPrint('Settings updated: fontSize=${state.fontSize}, '
                'animations=${state.enableAnimations}, language=${state.language}');
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Settings - MultiBlocProvider Demo'),
        ),
        body: BlocListener<SettingsCubit, SettingsState>(
          // Additional BlocListener for specific font size changes
          listenWhen: (previous, current) =>
              previous.fontSize != current.fontSize,
          listener: (context, state) {
            if (state.fontSize > 20) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Large font size selected - Great for accessibility!'),
                  backgroundColor: Colors.blue,
                ),
              );
            }
          },
          child: Padding(
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
