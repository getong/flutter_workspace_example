import 'dart:math' as math;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:material_color_utilities/material_color_utilities.dart';
import 'package:widget_layout_example2/app_navigation.dart';

@RoutePage(name: RouteName.materialColorUtilities)
class MaterialColorUtilitiesPage extends StatefulWidget {
  const MaterialColorUtilitiesPage({super.key});

  @override
  State<MaterialColorUtilitiesPage> createState() =>
      _MaterialColorUtilitiesPageState();
}

class _MaterialColorUtilitiesPageState
    extends State<MaterialColorUtilitiesPage> {
  static const List<_SeedSample> _seedSamples = <_SeedSample>[
    _SeedSample('Ocean', Color(0xFF2563EB)),
    _SeedSample('Coral', Color(0xFFF97316)),
    _SeedSample('Forest', Color(0xFF15803D)),
    _SeedSample('Berry', Color(0xFFBE185D)),
  ];

  static const List<int> _demoTones = <int>[20, 35, 50, 65, 80, 95];

  int _selectedSeedIndex = 0;
  double _blendAmount = 0.35;

  Color get _selectedColor => _seedSamples[_selectedSeedIndex].color;

  Hct get _selectedHct => Hct.fromInt(_selectedColor.toARGB32());

  @override
  Widget build(BuildContext context) {
    final Hct selectedHct = _selectedHct;
    final TonalPalette palette = TonalPalette.fromHct(selectedHct);
    final TonalPalette companionPalette = TonalPalette.of(
      (selectedHct.hue + 42.0) % 360.0,
      math.max(18.0, selectedHct.chroma * 0.55),
    );

    final Color designColor = const Color(0xFFDB2777);
    final int designArgb = designColor.toARGB32();
    final int sourceArgb = _selectedColor.toARGB32();

    final Color harmonized = Color(Blend.harmonize(designArgb, sourceArgb));
    final Color hueShifted = Color(
      Blend.hctHue(designArgb, sourceArgb, _blendAmount),
    );
    final Color ucsBlend = Color(
      Blend.cam16Ucs(designArgb, sourceArgb, _blendAmount),
    );

    final Hct dimRoom = selectedHct.inViewingConditions(
      ViewingConditions.make(backgroundLstar: 18.0, surround: 0.8),
    );
    final Hct brightStudio = selectedHct.inViewingConditions(
      ViewingConditions.make(backgroundLstar: 85.0, surround: 2.0),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('material_color_utilities Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'material_color_utilities powers Material 3 color generation. '
              'These examples use HCT, TonalPalette, Blend, and '
              'ViewingConditions to show how Flutter-friendly colors can be '
              'analyzed, transformed, and adapted.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            _MaterialColorUtilitiesCard(
              title: 'HCT Inspector And Tone Editing',
              description:
                  'HCT represents hue, chroma, and tone. You can read a seed '
                  'color into HCT, then derive lighter or darker colors by '
                  'changing tone while preserving its perceived identity.',
              api: 'Uses: Hct.fromInt, Hct.from, hue/chroma/tone, toInt()',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: List<Widget>.generate(_seedSamples.length, (
                      int index,
                    ) {
                      final _SeedSample sample = _seedSamples[index];
                      return ChoiceChip(
                        selected: index == _selectedSeedIndex,
                        avatar: CircleAvatar(backgroundColor: sample.color),
                        label: Text(sample.label),
                        onSelected: (_) {
                          setState(() => _selectedSeedIndex = index);
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: <Widget>[
                      _MetricChip(
                        label: 'Hue',
                        value: selectedHct.hue.toStringAsFixed(1),
                      ),
                      _MetricChip(
                        label: 'Chroma',
                        value: selectedHct.chroma.toStringAsFixed(1),
                      ),
                      _MetricChip(
                        label: 'Tone',
                        value: selectedHct.tone.toStringAsFixed(1),
                      ),
                      _MetricChip(
                        label: 'ARGB',
                        value: _hexLabel(_selectedColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _demoTones.map((int tone) {
                      final Color swatch = Color(
                        Hct.from(
                          selectedHct.hue,
                          selectedHct.chroma,
                          tone.toDouble(),
                        ).toInt(),
                      );
                      return _ColorSwatchTile(
                        title: 'Tone $tone',
                        subtitle: _hexLabel(swatch),
                        color: swatch,
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _MaterialColorUtilitiesCard(
              title: 'TonalPalette Ramps',
              description:
                  'TonalPalette keeps hue and chroma stable while varying tone. '
                  'This is useful when building a full role palette from a '
                  'single source color.',
              api: 'Uses: TonalPalette.fromHct, TonalPalette.of, get(tone)',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _PaletteStrip(
                    title: 'Palette From Selected HCT',
                    tones: _demoTones,
                    palette: palette,
                  ),
                  const SizedBox(height: 16),
                  _PaletteStrip(
                    title: 'Companion Accent Palette',
                    tones: _demoTones,
                    palette: companionPalette,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _MaterialColorUtilitiesCard(
              title: 'Blend And Harmonize',
              description:
                  'Blend can pull an existing UI color toward a brand color. '
                  'Harmonize preserves recognizability, while HCT hue and '
                  'CAM16-UCS blending provide stronger interpolation options.',
              api: 'Uses: Blend.harmonize, Blend.hctHue, Blend.cam16Ucs',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: <Widget>[
                      _ColorSwatchTile(
                        title: 'Design Color',
                        subtitle: _hexLabel(designColor),
                        color: designColor,
                      ),
                      _ColorSwatchTile(
                        title: 'Brand Seed',
                        subtitle: _hexLabel(_selectedColor),
                        color: _selectedColor,
                      ),
                      _ColorSwatchTile(
                        title: 'Harmonized',
                        subtitle: _hexLabel(harmonized),
                        color: harmonized,
                      ),
                      _ColorSwatchTile(
                        title: 'HCT Hue',
                        subtitle: _hexLabel(hueShifted),
                        color: hueShifted,
                      ),
                      _ColorSwatchTile(
                        title: 'CAM16-UCS',
                        subtitle: _hexLabel(ucsBlend),
                        color: ucsBlend,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text('Blend Amount: ${_blendAmount.toStringAsFixed(2)}'),
                  Slider(
                    value: _blendAmount,
                    min: 0.0,
                    max: 1.0,
                    divisions: 10,
                    label: _blendAmount.toStringAsFixed(2),
                    onChanged: (double value) {
                      setState(() => _blendAmount = value);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _MaterialColorUtilitiesCard(
              title: 'Viewing Conditions',
              description:
                  'The same underlying color can appear differently in dim or '
                  'bright surroundings. HCT can model that shift by moving '
                  'through CAM16 viewing conditions.',
              api: 'Uses: ViewingConditions.make, Hct.inViewingConditions',
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: <Widget>[
                  _ColorSwatchTile(
                    title: 'sRGB Default',
                    subtitle: _hexLabel(_selectedColor),
                    color: _selectedColor,
                  ),
                  _ColorSwatchTile(
                    title: 'Dim Room',
                    subtitle: _hexLabel(Color(dimRoom.toInt())),
                    color: Color(dimRoom.toInt()),
                  ),
                  _ColorSwatchTile(
                    title: 'Bright Studio',
                    subtitle: _hexLabel(Color(brightStudio.toInt())),
                    color: Color(brightStudio.toInt()),
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

class _MaterialColorUtilitiesCard extends StatelessWidget {
  const _MaterialColorUtilitiesCard({
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

class _MetricChip extends StatelessWidget {
  const _MetricChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text('$label: $value'),
      backgroundColor: Theme.of(
        context,
      ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.55),
    );
  }
}

class _PaletteStrip extends StatelessWidget {
  const _PaletteStrip({
    required this.title,
    required this.tones,
    required this.palette,
  });

  final String title;
  final List<int> tones;
  final TonalPalette palette;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: tones.map((int tone) {
            final Color swatch = Color(palette.get(tone));
            return _ColorSwatchTile(
              title: 'Tone $tone',
              subtitle: _hexLabel(swatch),
              color: swatch,
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _ColorSwatchTile extends StatelessWidget {
  const _ColorSwatchTile({
    required this.title,
    required this.subtitle,
    required this.color,
  });

  final String title;
  final String subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = ThemeData.estimateBrightnessForColor(color);

    return Container(
      width: 132,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              color: brightness == Brightness.dark
                  ? Colors.white70
                  : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}

class _SeedSample {
  const _SeedSample(this.label, this.color);

  final String label;
  final Color color;
}

String _hexLabel(Color color) {
  final String argb = color.toARGB32().toRadixString(16).padLeft(8, '0');
  return '#${argb.substring(2).toUpperCase()}';
}
