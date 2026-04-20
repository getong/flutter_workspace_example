import 'package:auto_route/auto_route.dart';
import 'package:flex_seed_scheme/flex_seed_scheme.dart';
import 'package:flutter/material.dart';

@RoutePage()
class FlexSeedSchemePage extends StatefulWidget {
  const FlexSeedSchemePage({super.key});

  @override
  State<FlexSeedSchemePage> createState() => _FlexSeedSchemePageState();
}

class _FlexSeedSchemePageState extends State<FlexSeedSchemePage> {
  static const Color _primaryKey = Color(0xFF2563EB);
  static const Color _secondaryKey = Color(0xFFF97316);
  static const Color _tertiaryKey = Color(0xFF0F766E);
  static const Color _neutralKey = Color(0xFF475569);
  static const Color _neutralVariantKey = Color(0xFF64748B);

  bool _useDarkMode = false;
  double _contrastLevel = 0.0;

  Brightness get _brightness =>
      _useDarkMode ? Brightness.dark : Brightness.light;

  @override
  Widget build(BuildContext context) {
    final ColorScheme flutterSeedScheme = ColorScheme.fromSeed(
      seedColor: _primaryKey,
      brightness: _brightness,
    );
    final ColorScheme multiSeedScheme = SeedColorScheme.fromSeeds(
      brightness: _brightness,
      primaryKey: _primaryKey,
      secondaryKey: _secondaryKey,
      tertiaryKey: _tertiaryKey,
      neutralKey: _neutralKey,
      neutralVariantKey: _neutralVariantKey,
      variant: FlexSchemeVariant.tonalSpot,
      contrastLevel: _contrastLevel,
      useExpressiveOnContainerColors: false,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('flex_seed_scheme Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'flex_seed_scheme extends Flutter seed-generated ColorScheme '
              'creation with multiple seed keys, more generation variants, and '
              'custom tonal mappings. These examples compare it with '
              'ColorScheme.fromSeed and show how different configuration paths '
              'change the resulting Material UI.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              value: _useDarkMode,
              title: const Text('Dark mode preview'),
              subtitle: const Text(
                'All generated schemes below switch brightness together.',
              ),
              onChanged: (bool value) {
                setState(() => _useDarkMode = value);
              },
            ),
            const SizedBox(height: 12),
            _FlexSeedSchemeCard(
              title: 'fromSeed vs fromSeeds',
              description:
                  'Flutter can generate a scheme from one seed. flex_seed_scheme '
                  'can instead seed primary, secondary, tertiary, and neutral '
                  'roles independently.',
              api:
                  'Uses: ColorScheme.fromSeed, SeedColorScheme.fromSeeds, primaryKey, secondaryKey, tertiaryKey, neutralKey',
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: <Widget>[
                  _SchemePreviewTile(
                    title: 'Flutter fromSeed',
                    subtitle: 'Single primary seed',
                    scheme: flutterSeedScheme,
                  ),
                  _SchemePreviewTile(
                    title: 'flex fromSeeds',
                    subtitle: 'Multiple seed keys',
                    scheme: multiSeedScheme,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _FlexSeedSchemeCard(
              title: 'Variant Algorithms',
              description:
                  'Variant mode chooses the underlying scheme algorithm. The '
                  'same seed keys can produce very different surfaces and accent '
                  'relationships.',
              api:
                  'Uses: variant, contrastLevel, FlexSchemeVariant.tonalSpot/fidelity/vibrant/expressive',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Contrast Level: ${_contrastLevel.toStringAsFixed(1)}'),
                  Slider(
                    value: _contrastLevel,
                    min: -1.0,
                    max: 1.0,
                    divisions: 8,
                    label: _contrastLevel.toStringAsFixed(1),
                    onChanged: (double value) {
                      setState(() => _contrastLevel = value);
                    },
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children:
                        <FlexSchemeVariant>[
                          FlexSchemeVariant.tonalSpot,
                          FlexSchemeVariant.fidelity,
                          FlexSchemeVariant.vibrant,
                          FlexSchemeVariant.expressive,
                        ].map((FlexSchemeVariant variant) {
                          return _SchemePreviewTile(
                            title: variant.variantName,
                            subtitle: variant.description,
                            scheme: SeedColorScheme.fromSeeds(
                              brightness: _brightness,
                              primaryKey: _primaryKey,
                              secondaryKey: _secondaryKey,
                              tertiaryKey: _tertiaryKey,
                              neutralKey: _neutralKey,
                              neutralVariantKey: _neutralVariantKey,
                              variant: variant,
                              contrastLevel: _contrastLevel,
                              useExpressiveOnContainerColors: false,
                            ),
                          );
                        }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _FlexSeedSchemeCard(
              title: 'Tone Presets',
              description:
                  'Instead of picking a variant, you can pass FlexTones directly '
                  'to control the tonal mapping strategy for Material roles.',
              api:
                  'Uses: tones, FlexTones.material, FlexTones.soft, FlexTones.vivid, FlexTones.highContrast',
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children:
                    <({String name, FlexTones tones})>[
                      (
                        name: 'Material',
                        tones: FlexTones.material(_brightness),
                      ),
                      (name: 'Soft', tones: FlexTones.soft(_brightness)),
                      (name: 'Vivid', tones: FlexTones.vivid(_brightness)),
                      (
                        name: 'High Contrast',
                        tones: FlexTones.highContrast(_brightness),
                      ),
                    ].map((({String name, FlexTones tones}) entry) {
                      return _SchemePreviewTile(
                        title: entry.name,
                        subtitle: 'Custom FlexTones mapping',
                        scheme: SeedColorScheme.fromSeeds(
                          brightness: _brightness,
                          primaryKey: _primaryKey,
                          secondaryKey: _secondaryKey,
                          tertiaryKey: _tertiaryKey,
                          neutralKey: _neutralKey,
                          neutralVariantKey: _neutralVariantKey,
                          tones: entry.tones,
                          useExpressiveOnContainerColors: false,
                        ),
                      );
                    }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            _FlexSeedSchemeCard(
              title: 'Monochrome Seed Handling',
              description:
                  'When a seed is grayscale, respectMonochromeSeed keeps it '
                  'neutral instead of letting hidden chroma leak into the '
                  'generated palette.',
              api:
                  'Uses: respectMonochromeSeed, primaryKey, neutralKey, variant',
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: <Widget>[
                  _SchemePreviewTile(
                    title: 'Default Gray Seed',
                    subtitle: 'respectMonochromeSeed: false',
                    scheme: SeedColorScheme.fromSeeds(
                      brightness: _brightness,
                      primaryKey: const Color(0xFF7A7A7A),
                      neutralKey: const Color(0xFF7A7A7A),
                      variant: FlexSchemeVariant.tonalSpot,
                    ),
                  ),
                  _SchemePreviewTile(
                    title: 'Respected Gray Seed',
                    subtitle: 'respectMonochromeSeed: true',
                    scheme: SeedColorScheme.fromSeeds(
                      brightness: _brightness,
                      primaryKey: const Color(0xFF7A7A7A),
                      neutralKey: const Color(0xFF7A7A7A),
                      variant: FlexSchemeVariant.tonalSpot,
                      respectMonochromeSeed: true,
                    ),
                  ),
                ],
              ),
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
  }
}

class _FlexSeedSchemeCard extends StatelessWidget {
  const _FlexSeedSchemeCard({
    required this.title,
    required this.description,
    required this.api,
    required this.child,
  });

  final String title;
  final String description;
  final String api;
  final Widget child;

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
            const SizedBox(height: 16),
            child,
            const SizedBox(height: 12),
            Text(
              api,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.blueGrey.shade700),
            ),
          ],
        ),
      ),
    );
  }
}

class _SchemePreviewTile extends StatelessWidget {
  const _SchemePreviewTile({
    required this.title,
    required this.subtitle,
    required this.scheme,
  });

  final String title;
  final String subtitle;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(colorScheme: scheme, useMaterial3: true),
      child: Builder(
        builder: (BuildContext context) {
          final ThemeData theme = Theme.of(context);
          return Container(
            width: 320,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: scheme.outlineVariant),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(subtitle, style: theme.textTheme.bodySmall),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      <_RoleSwatch>[
                        _RoleSwatch(
                          'Primary',
                          scheme.primary,
                          scheme.onPrimary,
                        ),
                        _RoleSwatch(
                          'Secondary',
                          scheme.secondary,
                          scheme.onSecondary,
                        ),
                        _RoleSwatch(
                          'Tertiary',
                          scheme.tertiary,
                          scheme.onTertiary,
                        ),
                        _RoleSwatch(
                          'Surface',
                          scheme.surfaceContainerHigh,
                          scheme.onSurface,
                        ),
                      ].map((_RoleSwatch role) {
                        return _RoleSwatchBox(role: role);
                      }).toList(),
                ),
                const SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    FilledButton(onPressed: () {}, child: const Text('Apply')),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: () {},
                      child: const Text('Preview'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Chip(
                  avatar: Icon(Icons.palette_outlined, color: scheme.primary),
                  label: const Text('Seed-generated roles'),
                ),
                const SizedBox(height: 8),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: scheme.primaryContainer,
                    foregroundColor: scheme.onPrimaryContainer,
                    child: const Icon(Icons.insights_outlined),
                  ),
                  title: const Text('Dashboard Theme'),
                  subtitle: Text(
                    'Primary ${_hexLabel(scheme.primary)}  Surface ${_hexLabel(scheme.surface)}',
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _RoleSwatch {
  const _RoleSwatch(this.label, this.background, this.foreground);

  final String label;
  final Color background;
  final Color foreground;
}

class _RoleSwatchBox extends StatelessWidget {
  const _RoleSwatchBox({required this.role});

  final _RoleSwatch role;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 128,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: role.background,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        role.label,
        style: TextStyle(color: role.foreground, fontWeight: FontWeight.w700),
      ),
    );
  }
}

String _hexLabel(Color color) {
  final String argb = color.toARGB32().toRadixString(16).padLeft(8, '0');
  return '#${argb.substring(2).toUpperCase()}';
}
