import 'package:auto_route/auto_route.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_color_utilities/material_color_utilities.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';

enum _BrandPreset { coral, teal, amber }

class _BrandPresetConfig {
  const _BrandPresetConfig({
    required this.label,
    required this.description,
    required this.color,
  });

  final String label;
  final String description;
  final Color color;
}

const Map<_BrandPreset, _BrandPresetConfig>
_brandPresets = <_BrandPreset, _BrandPresetConfig>{
  _BrandPreset.coral: _BrandPresetConfig(
    label: 'Coral',
    description:
        'A warm product color to compare against the platform-provided scheme.',
    color: Color(0xFFD85C63),
  ),
  _BrandPreset.teal: _BrandPresetConfig(
    label: 'Teal',
    description:
        'A cool product color that shows harmonization clearly on dynamic schemes.',
    color: Color(0xFF006C67),
  ),
  _BrandPreset.amber: _BrandPresetConfig(
    label: 'Amber',
    description:
        'A bright accent that stands out before and after harmonization.',
    color: Color(0xFFB26A00),
  ),
};

@RoutePage(name: RouteName.dynamicColor)
class DynamicColorPage extends StatefulWidget {
  const DynamicColorPage({super.key});

  @override
  State<DynamicColorPage> createState() => _DynamicColorPageState();
}

class _DynamicColorPageState extends State<DynamicColorPage> {
  _BrandPreset _selectedPreset = _BrandPreset.coral;
  // ignore: deprecated_member_use
  CorePalette? _corePalette;
  Color? _accentColor;
  String _status =
      'Dynamic color has not been queried yet. The live preview below still works through DynamicColorBuilder.';

  _BrandPresetConfig get _activePreset => _brandPresets[_selectedPreset]!;
  Color get _brandColor => _activePreset.color;

  @override
  void initState() {
    super.initState();
    _refreshPlatformColors();
  }

  Future<void> _refreshPlatformColors() async {
    await _loadCorePalette();
    await _loadAccentColor();
  }

  Future<void> _loadCorePalette() async {
    try {
      // ignore: deprecated_member_use
      final CorePalette? palette = await DynamicColorPlugin.getCorePalette();
      if (!mounted) {
        return;
      }

      setState(() {
        _corePalette = palette;
        _status = palette == null
            ? 'getCorePalette() returned null. This usually means the current platform does not expose Android 12+ dynamic colors.'
            : 'getCorePalette() returned a CorePalette from the platform.';
      });
    } on PlatformException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _status =
            'getCorePalette() failed: ${error.code} ${error.message ?? ''}'
                .trim();
      });
    }
  }

  Future<void> _loadAccentColor() async {
    try {
      final Color? accentColor = await DynamicColorPlugin.getAccentColor();
      if (!mounted) {
        return;
      }

      setState(() {
        _accentColor = accentColor;
        if (accentColor != null) {
          _status =
              'getAccentColor() returned ${_hex(accentColor)} from the platform.';
        } else if (_corePalette == null) {
          _status =
              'No dynamic accent color was returned on this platform. The page is showing a seeded fallback preview.';
        }
      });
    } on PlatformException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _status =
            'getAccentColor() failed: ${error.code} ${error.message ?? ''}'
                .trim();
      });
    }
  }

  String _hex(Color color) =>
      '#${color.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase()}';

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        final bool hasDynamicColor =
            lightDynamic != null || darkDynamic != null || _accentColor != null;
        final ColorScheme fallbackLight = ColorScheme.fromSeed(
          seedColor: _brandColor,
        );
        final ColorScheme fallbackDark = ColorScheme.fromSeed(
          seedColor: _brandColor,
          brightness: Brightness.dark,
        );
        final ColorScheme lightScheme = lightDynamic ?? fallbackLight;
        final ColorScheme darkScheme = darkDynamic ?? fallbackDark;
        final Color harmonizedBrand = _brandColor.harmonizeWith(
          lightScheme.primary,
        );
        final Color accentForPreview = _accentColor ?? lightScheme.primary;

        return Scaffold(
          appBar: AppBar(title: const Text('dynamic_color Module')),
          body: SelectionArea(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: <Widget>[
                const Text(
                  'dynamic_color reads the operating system color palette when it is available and helps you harmonize your own brand colors with it.',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 20),
                const _DynamicColorCodeCard(
                  title: 'DynamicColorBuilder',
                  code: '''
DynamicColorBuilder(
  builder: (lightDynamic, darkDynamic) {
    final lightScheme =
        lightDynamic ?? ColorScheme.fromSeed(seedColor: Colors.blue);
    final darkScheme = darkDynamic ??
        ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        );

    return MaterialApp(
      theme: ThemeData(colorScheme: lightScheme),
      darkTheme: ThemeData(colorScheme: darkScheme),
    );
  },
);
''',
                ),
                const SizedBox(height: 16),
                const _DynamicColorCodeCard(
                  title: 'Direct plugin calls',
                  code: '''
final CorePalette? palette = await DynamicColorPlugin.getCorePalette();
final Color? accentColor = await DynamicColorPlugin.getAccentColor();
''',
                ),
                const SizedBox(height: 16),
                const _DynamicColorCodeCard(
                  title: 'Harmonizing brand colors',
                  code: '''
final Color harmonizedBrand =
    const Color(0xFFD85C63).harmonizeWith(lightScheme.primary);

final ColorScheme adjustedScheme = lightScheme.harmonized();
''',
                ),
                const SizedBox(height: 16),
                Card(
                  clipBehavior: Clip.antiAlias,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Brand Color Playground',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 8),
                        Text(_activePreset.description),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: _brandPresets.entries.map((
                            MapEntry<_BrandPreset, _BrandPresetConfig> entry,
                          ) {
                            return ChoiceChip(
                              label: Text(entry.value.label),
                              selected: entry.key == _selectedPreset,
                              avatar: CircleAvatar(
                                backgroundColor: entry.value.color,
                              ),
                              onSelected: (bool selected) {
                                if (!selected) {
                                  return;
                                }
                                setState(() {
                                  _selectedPreset = entry.key;
                                });
                              },
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: <Widget>[
                            _ColorChip(
                              label: 'Original brand',
                              color: _brandColor,
                              value: _hex(_brandColor),
                            ),
                            _ColorChip(
                              label: 'Harmonized brand',
                              color: harmonizedBrand,
                              value: _hex(harmonizedBrand),
                            ),
                            _ColorChip(
                              label: 'Platform accent',
                              color: accentForPreview,
                              value: _hex(accentForPreview),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  clipBehavior: Clip.antiAlias,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Platform Query Status',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 8),
                        Text(_status),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: <Widget>[
                            FilledButton.icon(
                              onPressed: _loadCorePalette,
                              icon: const Icon(Icons.palette_outlined),
                              label: const Text('Load CorePalette'),
                            ),
                            OutlinedButton.icon(
                              onPressed: _loadAccentColor,
                              icon: const Icon(Icons.colorize_outlined),
                              label: const Text('Load Accent Color'),
                            ),
                            OutlinedButton.icon(
                              onPressed: _refreshPlatformColors,
                              icon: const Icon(Icons.refresh_outlined),
                              label: const Text('Refresh Both'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  clipBehavior: Clip.antiAlias,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Live Scheme Preview',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          hasDynamicColor
                              ? 'This device exposed a platform palette or accent color, so the preview uses that as the base scheme.'
                              : 'This device did not expose a dynamic palette, so the preview falls back to ColorScheme.fromSeed using the selected brand color.',
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: <Widget>[
                            Chip(
                              label: Text(
                                hasDynamicColor
                                    ? 'Dynamic color available'
                                    : 'Fallback seed scheme',
                              ),
                            ),
                            Chip(
                              label: Text(
                                'Platform: ${Theme.of(context).platform.name}',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        LayoutBuilder(
                          builder: (BuildContext context, BoxConstraints constraints) {
                            final bool stacked = constraints.maxWidth < 760;
                            final Widget lightPreview = _SchemePreviewCard(
                              title: 'Light Scheme',
                              description:
                                  'Primary, secondary, tertiary, surface, and error roles from the active light scheme.',
                              scheme: lightScheme,
                            );
                            final Widget darkPreview = _SchemePreviewCard(
                              title: 'Dark Scheme',
                              description:
                                  'The matching dark scheme provided by DynamicColorBuilder or a seeded fallback.',
                              scheme: darkScheme,
                            );

                            if (stacked) {
                              return Column(
                                children: <Widget>[
                                  lightPreview,
                                  const SizedBox(height: 16),
                                  darkPreview,
                                ],
                              );
                            }

                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(child: lightPreview),
                                const SizedBox(width: 16),
                                Expanded(child: darkPreview),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  clipBehavior: Clip.antiAlias,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'CorePalette Tones',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _corePalette == null
                              ? 'No CorePalette is loaded yet. On Android 12+ this call returns the platform tonal palettes directly.'
                              : 'The rows below visualize a few tones from the primary, secondary, tertiary, and neutral tonal palettes.',
                        ),
                        const SizedBox(height: 16),
                        if (_corePalette == null)
                          const Text(
                            'Press "Load CorePalette" to populate this section.',
                          )
                        else
                          Column(
                            children: <Widget>[
                              _TonePaletteRow(
                                title: 'Primary',
                                palette: _corePalette!.primary,
                              ),
                              const SizedBox(height: 12),
                              _TonePaletteRow(
                                title: 'Secondary',
                                palette: _corePalette!.secondary,
                              ),
                              const SizedBox(height: 12),
                              _TonePaletteRow(
                                title: 'Tertiary',
                                palette: _corePalette!.tertiary,
                              ),
                              const SizedBox(height: 12),
                              _TonePaletteRow(
                                title: 'Neutral',
                                palette: _corePalette!.neutral,
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const _DynamicColorInfoCard(
                  title: 'Platform notes',
                  description:
                      'Android 12 and later can provide a full CorePalette. On macOS, Windows, and Linux the package can read the system accent color and derive a Material color scheme from it. On unsupported platforms the examples on this page fall back to a seeded ColorScheme so the widget structure still demonstrates the API usage.',
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => context.router.replacePath('/'),
            icon: const Icon(Icons.home),
            label: const Text('Home'),
          ),
        );
      },
    );
  }
}

class _DynamicColorInfoCard extends StatelessWidget {
  const _DynamicColorInfoCard({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(description),
          ],
        ),
      ),
    );
  }
}

class _DynamicColorCodeCard extends StatelessWidget {
  const _DynamicColorCodeCard({required this.title, required this.code});

  final String title;
  final String code;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                code.trim(),
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontFamily: 'monospace'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SchemePreviewCard extends StatelessWidget {
  const _SchemePreviewCard({
    required this.title,
    required this.description,
    required this.scheme,
  });

  final String title;
  final String description;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: scheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: scheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(description, style: TextStyle(color: scheme.onSurfaceVariant)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: <Widget>[
                _ColorChip(
                  label: 'Primary',
                  color: scheme.primary,
                  value: '',
                  foreground: scheme.onPrimary,
                ),
                _ColorChip(
                  label: 'Secondary',
                  color: scheme.secondary,
                  value: '',
                  foreground: scheme.onSecondary,
                ),
                _ColorChip(
                  label: 'Tertiary',
                  color: scheme.tertiary,
                  value: '',
                  foreground: scheme.onTertiary,
                ),
                _ColorChip(
                  label: 'Surface',
                  color: scheme.surfaceContainerHighest,
                  value: '',
                  foreground: scheme.onSurface,
                ),
                _ColorChip(
                  label: 'Error',
                  color: scheme.error,
                  value: '',
                  foreground: scheme.onError,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TonePaletteRow extends StatelessWidget {
  const _TonePaletteRow({required this.title, required this.palette});

  final String title;
  final TonalPalette palette;

  @override
  Widget build(BuildContext context) {
    const List<int> tones = <int>[10, 30, 50, 70, 90];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: tones.map((int tone) {
            final Color swatch = Color(palette.get(tone));
            return _ColorChip(
              label: 'Tone $tone',
              color: swatch,
              value:
                  '#${swatch.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase()}',
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _ColorChip extends StatelessWidget {
  const _ColorChip({
    required this.label,
    required this.color,
    required this.value,
    this.foreground,
  });

  final String label;
  final Color color;
  final String value;
  final Color? foreground;

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = ThemeData.estimateBrightnessForColor(color);
    final Color textColor =
        foreground ??
        (brightness == Brightness.dark ? Colors.white : Colors.black87);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            label,
            style: TextStyle(color: textColor, fontWeight: FontWeight.w700),
          ),
          if (value.isNotEmpty) ...<Widget>[
            const SizedBox(height: 4),
            Text(value, style: TextStyle(color: textColor)),
          ],
        ],
      ),
    );
  }
}
