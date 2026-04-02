import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class FontAwesomeFlutterPage extends StatelessWidget {
  const FontAwesomeFlutterPage({super.key});

  static const List<_IconShowcaseItemData> _showcaseItems =
      <_IconShowcaseItemData>[
        _IconShowcaseItemData(
          icon: FontAwesomeIcons.cameraRetro,
          title: 'Hero Icon',
          caption: 'Use FaIcon for package icons.',
          color: Color(0xFF2563EB),
        ),
        _IconShowcaseItemData(
          icon: FontAwesomeIcons.palette,
          title: 'Styling',
          caption: 'Match your ColorScheme and sizing.',
          color: Color(0xFFDB2777),
        ),
        _IconShowcaseItemData(
          icon: FontAwesomeIcons.rocket,
          title: 'Actions',
          caption: 'Works well in buttons and CTAs.',
          color: Color(0xFFEA580C),
        ),
        _IconShowcaseItemData(
          icon: FontAwesomeIcons.mobileScreenButton,
          title: 'Layouts',
          caption: 'Great for cards, grids, and lists.',
          color: Color(0xFF0891B2),
        ),
      ];

  static const List<_StatusItemData> _statusItems = <_StatusItemData>[
    _StatusItemData(
      icon: FontAwesomeIcons.circleCheck,
      title: 'Release Ready',
      subtitle: 'Pair icons with status text in ListTile rows.',
      color: Color(0xFF16A34A),
    ),
    _StatusItemData(
      icon: FontAwesomeIcons.triangleExclamation,
      title: 'Needs Attention',
      subtitle: 'Warning states remain easy to scan.',
      color: Color(0xFFD97706),
    ),
    _StatusItemData(
      icon: FontAwesomeIcons.circleInfo,
      title: 'Extra Context',
      subtitle: 'Informational icons add lightweight guidance.',
      color: Color(0xFF2563EB),
    ),
  ];

  static const List<_BrandItemData> _brandItems = <_BrandItemData>[
    _BrandItemData(
      icon: FontAwesomeIcons.github,
      label: 'GitHub',
      color: Color(0xFF111827),
    ),
    _BrandItemData(
      icon: FontAwesomeIcons.google,
      label: 'Google',
      color: Color(0xFFEA4335),
    ),
    _BrandItemData(
      icon: FontAwesomeIcons.slack,
      label: 'Slack',
      color: Color(0xFF4A154B),
    ),
    _BrandItemData(
      icon: FontAwesomeIcons.apple,
      label: 'Apple',
      color: Color(0xFF374151),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('font_awesome_flutter Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            Text(
              'Font Awesome widgets with Flutter',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Text(
              'This module focuses on current `font_awesome_flutter` usage. '
              'In v11, package icons are rendered with `FaIcon`, which fits '
              'naturally into buttons, chips, cards, rich text, and list rows.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            const _CodeSampleCard(),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Basic FaIcon Examples',
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: _showcaseItems
                    .map(
                      (_IconShowcaseItemData item) => _IconShowcaseTile(
                        data: item,
                        surfaceTint: colorScheme.surfaceContainerHighest,
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Buttons and Actions',
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: <Widget>[
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const FaIcon(FontAwesomeIcons.rocket, size: 18),
                    label: const Text('Launch'),
                  ),
                  FilledButton.icon(
                    onPressed: () {},
                    icon: const FaIcon(
                      FontAwesomeIcons.wandMagicSparkles,
                      size: 18,
                    ),
                    label: const Text('Generate'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const FaIcon(FontAwesomeIcons.codeBranch, size: 18),
                    label: const Text('Compare'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Chips, Tags, and Badges',
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: <Widget>[
                  Chip(
                    avatar: const FaIcon(FontAwesomeIcons.solidBell, size: 16),
                    label: const Text('Notifications'),
                  ),
                  Chip(
                    avatar: const FaIcon(FontAwesomeIcons.comments, size: 16),
                    label: const Text('Feedback'),
                  ),
                  Chip(
                    avatar: const FaIcon(FontAwesomeIcons.bolt, size: 16),
                    label: const Text('Fast Build'),
                  ),
                  Chip(
                    avatar: const FaIcon(FontAwesomeIcons.thumbsUp, size: 16),
                    label: const Text('Approved'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Rich Text and Status Rows',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text.rich(
                    TextSpan(
                      style: Theme.of(context).textTheme.bodyLarge,
                      children: <InlineSpan>[
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FaIcon(
                              FontAwesomeIcons.chartLine,
                              size: 18,
                              color: colorScheme.primary,
                            ),
                          ),
                        ),
                        const TextSpan(
                          text:
                              'You can embed Font Awesome icons inside rich text '
                              'using WidgetSpan for inline callouts.',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ..._statusItems.map((_StatusItemData item) {
                    return _StatusRow(data: item);
                  }),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Brand Icon Showcase',
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: _brandItems
                    .map((_BrandItemData item) => _BrandChip(data: item))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/'),
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
            colors: <Color>[Color(0xFF111827), Color(0xFF1F2937)],
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
              Text('const FaIcon(FontAwesomeIcons.rocket, size: 20)'),
              SizedBox(height: 8),
              Text('ElevatedButton.icon('),
              Text('  onPressed: () {},'),
              Text('  icon: const FaIcon(FontAwesomeIcons.codeBranch),'),
              Text("  label: const Text('Compare'),"),
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

class _IconShowcaseTile extends StatelessWidget {
  const _IconShowcaseTile({required this.data, required this.surfaceTint});

  final _IconShowcaseItemData data;
  final Color surfaceTint;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceTint.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: data.color.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(12),
            ),
            child: FaIcon(data.icon, size: 28, color: data.color),
          ),
          const SizedBox(height: 12),
          Text(
            data.title,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(data.caption),
        ],
      ),
    );
  }
}

class _StatusRow extends StatelessWidget {
  const _StatusRow({required this.data});

  final _StatusItemData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: data.color.withValues(alpha: 0.16)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: FaIcon(data.icon, color: data.color, size: 20),
        title: Text(data.title),
        subtitle: Text(data.subtitle),
      ),
    );
  }
}

class _BrandChip extends StatelessWidget {
  const _BrandChip({required this.data});

  final _BrandItemData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: data.color.withValues(alpha: 0.18)),
        color: data.color.withValues(alpha: 0.08),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FaIcon(data.icon, size: 18, color: data.color),
          const SizedBox(width: 10),
          Text(
            data.label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _IconShowcaseItemData {
  const _IconShowcaseItemData({
    required this.icon,
    required this.title,
    required this.caption,
    required this.color,
  });

  final FaIconData icon;
  final String title;
  final String caption;
  final Color color;
}

class _StatusItemData {
  const _StatusItemData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  final FaIconData icon;
  final String title;
  final String subtitle;
  final Color color;
}

class _BrandItemData {
  const _BrandItemData({
    required this.icon,
    required this.label,
    required this.color,
  });

  final FaIconData icon;
  final String label;
  final Color color;
}
