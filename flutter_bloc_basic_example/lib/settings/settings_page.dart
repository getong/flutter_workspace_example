import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme/theme_cubit.dart';

/// {@template settings_page}
/// A page that demonstrates MultiBlocProvider usage by consuming
/// both ThemeCubit and SettingsCubit provided by the ancestor MultiBlocProvider.
/// {@endtemplate}
class SettingsPage extends StatelessWidget {
  /// {@macro settings_page}
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings - MultiBlocProvider Demo'),
      ),
      body: Padding(
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

            // App Settings Section
            Card(
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

                    // Animations toggle
                    BlocSelector<SettingsCubit, SettingsState, bool>(
                      selector: (state) => state.enableAnimations,
                      builder: (context, enableAnimations) {
                        return SwitchListTile(
                          title: const Text('Enable Animations'),
                          value: enableAnimations,
                          onChanged: (_) {
                            context.read<SettingsCubit>().toggleAnimations();
                          },
                        );
                      },
                    ),

                    // Language dropdown
                    BlocBuilder<SettingsCubit, SettingsState>(
                      builder: (context, settingsState) {
                        return ListTile(
                          title: const Text('Language'),
                          trailing: DropdownButton<String>(
                            value: settingsState.language,
                            items: ['English', 'Spanish', 'French', 'German']
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
                            return BlocSelector<SettingsCubit, SettingsState,
                                String>(
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
    );
  }
}
