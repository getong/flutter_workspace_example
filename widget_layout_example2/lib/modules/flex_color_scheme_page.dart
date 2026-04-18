import 'package:auto_route/auto_route.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

@RoutePage(name: 'FlexColorSchemeRoute')
class FlexColorSchemePage extends StatefulWidget {
  const FlexColorSchemePage({super.key});

  @override
  State<FlexColorSchemePage> createState() => _FlexColorSchemePageState();
}

class _FlexColorSchemePageState extends State<FlexColorSchemePage> {
  FlexScheme _scheme = FlexScheme.deepBlue;
  FlexSchemeVariant _variant = FlexSchemeVariant.expressive;
  bool _useDarkMode = false;
  bool _useKeyColors = true;
  double _radius = 18;
  double _blendLevel = 16;

  ThemeData _buildTheme(Brightness brightness) {
    final FlexSubThemesData subThemesData = FlexSubThemesData(
      interactionEffects: true,
      blendOnLevel: _blendLevel.round(),
      defaultRadius: _radius,
    );

    if (brightness == Brightness.light) {
      return FlexThemeData.light(
        scheme: _scheme,
        variant: _variant,
        useMaterial3: true,
        keyColors: FlexKeyColors(useKeyColors: _useKeyColors),
        subThemesData: subThemesData,
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
      );
    }

    return FlexThemeData.dark(
      scheme: _scheme,
      variant: _variant,
      useMaterial3: true,
      keyColors: FlexKeyColors(useKeyColors: _useKeyColors),
      subThemesData: subThemesData,
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData pageTheme = Theme.of(context);
    final ThemeData previewTheme = _buildTheme(
      _useDarkMode ? Brightness.dark : Brightness.light,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('flex_color_scheme Module')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: <Widget>[
          Text(
            'flex_color_scheme builds richer `ThemeData` from prebuilt schemes, '
            'seed strategies, component subthemes, and adaptive visual density.',
            style: pageTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'This page demonstrates `FlexThemeData.light`, '
            '`FlexThemeData.dark`, `FlexScheme`, `FlexSchemeVariant`, '
            '`FlexKeyColors`, `FlexSubThemesData`, and '
            '`FlexColorScheme.comfortablePlatformDensity`.',
            style: pageTheme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          Card(
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Theme controls',
                    style: pageTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    value: _useDarkMode,
                    title: const Text('Preview dark theme'),
                    subtitle: const Text(
                      'Switch between Flex light and dark builders.',
                    ),
                    onChanged: (bool value) {
                      setState(() => _useDarkMode = value);
                    },
                  ),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    value: _useKeyColors,
                    title: const Text('Use key color seeding'),
                    subtitle: const Text(
                      'Toggle `FlexKeyColors(useKeyColors: ...)` to compare fixed palettes with seeded output.',
                    ),
                    onChanged: (bool value) {
                      setState(() => _useKeyColors = value);
                    },
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Shared radius: ${_radius.toStringAsFixed(0)}',
                    style: pageTheme.textTheme.titleMedium,
                  ),
                  Slider(
                    value: _radius,
                    min: 4,
                    max: 32,
                    divisions: 14,
                    label: _radius.toStringAsFixed(0),
                    onChanged: (double value) {
                      setState(() => _radius = value);
                    },
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Blend level: ${_blendLevel.toStringAsFixed(0)}',
                    style: pageTheme.textTheme.titleMedium,
                  ),
                  Slider(
                    value: _blendLevel,
                    min: 0,
                    max: 40,
                    divisions: 20,
                    label: _blendLevel.toStringAsFixed(0),
                    onChanged: (double value) {
                      setState(() => _blendLevel = value);
                    },
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Built-in schemes',
                    style: pageTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        <FlexScheme>[
                              FlexScheme.deepBlue,
                              FlexScheme.mango,
                              FlexScheme.flutterDash,
                              FlexScheme.shadBlue,
                            ]
                            .map((FlexScheme scheme) {
                              return ChoiceChip(
                                label: Text(scheme.name),
                                selected: _scheme == scheme,
                                onSelected: (_) {
                                  setState(() => _scheme = scheme);
                                },
                              );
                            })
                            .toList(growable: false),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Variant algorithms',
                    style: pageTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        <FlexSchemeVariant>[
                              FlexSchemeVariant.tonalSpot,
                              FlexSchemeVariant.vibrant,
                              FlexSchemeVariant.expressive,
                              FlexSchemeVariant.fidelity,
                            ]
                            .map((FlexSchemeVariant variant) {
                              return ChoiceChip(
                                label: Text(variant.variantName),
                                selected: _variant == variant,
                                onSelected: (_) {
                                  setState(() => _variant = variant);
                                },
                              );
                            })
                            .toList(growable: false),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Live theme preview',
                    style: pageTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'The preview below is wrapped in its own `Theme` so the rest of the app stays unchanged.',
                  ),
                  const SizedBox(height: 20),
                  Theme(
                    data: previewTheme,
                    child: Builder(
                      builder: (BuildContext context) {
                        final ThemeData theme = Theme.of(context);
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: theme.scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: theme.colorScheme.outlineVariant,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Scheme: ${_scheme.name}',
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Variant: ${_variant.variantName}, key colors: $_useKeyColors',
                                style: theme.textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 20),
                              Wrap(
                                spacing: 12,
                                runSpacing: 12,
                                children: <Widget>[
                                  FilledButton(
                                    onPressed: () {},
                                    child: const Text('Primary CTA'),
                                  ),
                                  OutlinedButton(
                                    onPressed: () {},
                                    child: const Text('Secondary Action'),
                                  ),
                                  Chip(
                                    label: const Text('Theme chip'),
                                    avatar: Icon(
                                      Icons.palette_outlined,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                  Switch.adaptive(
                                    value: true,
                                    onChanged: (_) {},
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Component subthemes',
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w800,
                                            ),
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        'Radius, interaction effects, density, and on-color blending are all influenced by the active Flex configuration.',
                                      ),
                                      const SizedBox(height: 16),
                                      TextField(
                                        decoration: const InputDecoration(
                                          labelText: 'Styled text field',
                                          hintText: 'Observe corners and fills',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              NavigationBar(
                                selectedIndex: 1,
                                destinations: const <Widget>[
                                  NavigationDestination(
                                    icon: Icon(Icons.home_outlined),
                                    label: 'Home',
                                  ),
                                  NavigationDestination(
                                    icon: Icon(Icons.widgets_outlined),
                                    label: 'Theme',
                                  ),
                                  NavigationDestination(
                                    icon: Icon(Icons.settings_outlined),
                                    label: 'Settings',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Why use it',
                    style: pageTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'FlexColorScheme is useful when Flutter seed theming is too basic and you want better defaults across cards, buttons, inputs, navigation, radius, and density without hand-styling every component.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.router.replacePath('/'),
        icon: const Icon(Icons.home),
        label: const Text('Home'),
      ),
    );
  }
}
