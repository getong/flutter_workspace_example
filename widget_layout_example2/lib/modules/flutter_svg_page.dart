import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:auto_route/auto_route.dart';

class FlutterSvgPage extends StatelessWidget {
  const FlutterSvgPage({super.key});

  static const String _assetPath = 'assets/svg/analytics_badge.svg';

  static const String _sparkSvg = '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 120 120">
  <path d="M60 8 L73 43 L112 60 L73 77 L60 112 L47 77 L8 60 L47 43 Z" fill="#111827"/>
</svg>
''';

  static const String _bannerSvg = '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 240 120">
  <rect x="10" y="18" width="220" height="84" rx="22" fill="#F97316"/>
  <circle cx="58" cy="60" r="24" fill="#FFFFFF"/>
  <path d="M102 42 H188" stroke="#FFFFFF" stroke-width="14" stroke-linecap="round"/>
  <path d="M102 74 H162" stroke="#FED7AA" stroke-width="14" stroke-linecap="round"/>
</svg>
''';

  static const String _multiColorSvg = '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 120 120">
  <rect x="12" y="12" width="96" height="96" rx="24" fill="#FF0000"/>
  <circle cx="60" cy="60" r="22" fill="#00FF00"/>
  <path d="M36 90 L60 30 L84 90 Z" fill="#FFFFFF"/>
</svg>
''';

  static final Uint8List _memoryBytes = Uint8List.fromList(
    utf8.encode(_bannerSvg),
  );

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('flutter_svg Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            Text(
              'Render SVG widgets in Flutter',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'This module demonstrates several `flutter_svg` patterns: '
              '`SvgPicture.asset`, `SvgPicture.string`, `SvgPicture.memory`, '
              '`colorFilter`, `placeholderBuilder`, `WidgetSpan`, and a custom '
              '`ColorMapper` for palette remapping.',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            const _CodeSampleCard(),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Asset Rendering',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: <Widget>[
                      _DemoTile(
                        title: 'SvgPicture.asset',
                        subtitle: 'Load and render a local SVG asset.',
                        child: SvgPicture.asset(
                          _assetPath,
                          width: 120,
                          height: 120,
                          fit: BoxFit.contain,
                          semanticsLabel: 'Analytics badge',
                          placeholderBuilder: (BuildContext context) {
                            return const SizedBox(
                              width: 120,
                              height: 120,
                              child: Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      _DemoTile(
                        title: 'Tinted Asset',
                        subtitle: 'Apply a colorFilter to a monochrome result.',
                        child: SvgPicture.asset(
                          _assetPath,
                          width: 120,
                          height: 120,
                          colorFilter: ColorFilter.mode(
                            colorScheme.primary,
                            BlendMode.srcIn,
                          ),
                          semanticsLabel: 'Tinted analytics badge',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: <Widget>[
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: SvgPicture.asset(
                          _assetPath,
                          width: 18,
                          height: 18,
                          colorFilter: const ColorFilter.mode(
                            Colors.indigo,
                            BlendMode.srcIn,
                          ),
                        ),
                        label: const Text('Asset Icon Button'),
                      ),
                      Chip(
                        avatar: SvgPicture.asset(
                          _assetPath,
                          width: 18,
                          height: 18,
                        ),
                        label: const Text('Asset Avatar'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Inline SVG Strings',
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: <Widget>[
                  _DemoTile(
                    title: 'Raw String',
                    subtitle: 'Useful for dynamic SVGs generated in code.',
                    child: SvgPicture.string(_sparkSvg, width: 86, height: 86),
                  ),
                  _DemoTile(
                    title: 'String + ColorFilter',
                    subtitle: 'Recolor a single-path icon on the fly.',
                    child: SvgPicture.string(
                      _sparkSvg,
                      width: 86,
                      height: 86,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF0F766E),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  _DemoTile(
                    title: 'String in RichText',
                    subtitle: 'Embed SVG widgets inline with text.',
                    child: Text.rich(
                      TextSpan(
                        style: theme.textTheme.bodyLarge,
                        children: <InlineSpan>[
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: SvgPicture.string(
                                _sparkSvg,
                                width: 20,
                                height: 20,
                                colorFilter: ColorFilter.mode(
                                  colorScheme.tertiary,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                          const TextSpan(
                            text:
                                'SVG output can live inside text layouts when '
                                'you need branded or custom inline icons.',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Memory Bytes and UI Composition',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withValues(
                        alpha: 0.55,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: <Widget>[
                        SvgPicture.memory(
                          _memoryBytes,
                          width: 88,
                          height: 44,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            'SvgPicture.memory works when SVG data comes from '
                            'an API, local cache, or generated bytes.',
                            style: theme.textTheme.bodyLarge,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: SizedBox(
                      width: 28,
                      height: 28,
                      child: SvgPicture.string(
                        _sparkSvg,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF7C3AED),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    title: const Text('Leading SVG Widget'),
                    subtitle: const Text(
                      'SVG widgets can be dropped into ListTile, buttons, cards, and chips.',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'ColorMapper Example',
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: <Widget>[
                  _DemoTile(
                    title: 'Original Colors',
                    subtitle: 'The SVG keeps its authored palette.',
                    child: SvgPicture.string(
                      _multiColorSvg,
                      width: 92,
                      height: 92,
                    ),
                  ),
                  _DemoTile(
                    title: 'Mapped Colors',
                    subtitle:
                        'A custom ColorMapper swaps colors at parse time.',
                    child: SvgPicture.string(
                      _multiColorSvg,
                      width: 92,
                      height: 92,
                      colorMapper: _DemoColorMapper(
                        primary: colorScheme.primary,
                        accent: colorScheme.tertiary,
                      ),
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

class _CodeSampleCard extends StatelessWidget {
  const _CodeSampleCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[Color(0xFF0F172A), Color(0xFF1E293B)],
          ),
        ),
        child: DefaultTextStyle(
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'monospace',
            height: 1.5,
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("SvgPicture.asset('assets/svg/analytics_badge.svg')"),
              SizedBox(height: 8),
              Text('SvgPicture.string('),
              Text("  rawSvg,"),
              Text('  colorFilter: ColorFilter.mode('),
              Text('    Colors.teal,'),
              Text('    BlendMode.srcIn,'),
              Text('  ),'),
              Text(')'),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
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
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class _DemoTile extends StatelessWidget {
  const _DemoTile({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 210,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 110, child: Center(child: child)),
          const SizedBox(height: 12),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(subtitle),
        ],
      ),
    );
  }
}

class _DemoColorMapper extends ColorMapper {
  const _DemoColorMapper({required this.primary, required this.accent});

  final Color primary;
  final Color accent;

  @override
  Color substitute(
    String? id,
    String elementName,
    String attributeName,
    Color color,
  ) {
    if (color == const Color(0xFFFF0000)) {
      return primary;
    }
    if (color == const Color(0xFF00FF00)) {
      return accent;
    }
    return color;
  }
}
