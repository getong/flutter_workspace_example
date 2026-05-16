import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';

enum _IconlyFamily { light, bold, broken }

class _IconlyPair {
  const _IconlyPair({
    required this.label,
    required this.light,
    required this.bold,
    required this.broken,
    required this.color,
  });

  final String label;
  final IconData light;
  final IconData bold;
  final IconData broken;
  final Color color;
}

class _ActionItem {
  const _ActionItem({
    required this.title,
    required this.caption,
    required this.icon,
    required this.color,
  });

  final String title;
  final String caption;
  final IconData icon;
  final Color color;
}

class _StatusItem {
  const _StatusItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
}

const List<_IconlyPair> _familyPairs = <_IconlyPair>[
  _IconlyPair(
    label: 'Home',
    light: IconlyLight.home,
    bold: IconlyBold.home,
    broken: IconlyBroken.home,
    color: Color(0xFF2563EB),
  ),
  _IconlyPair(
    label: 'Search',
    light: IconlyLight.search,
    bold: IconlyBold.search,
    broken: IconlyBroken.search,
    color: Color(0xFF059669),
  ),
  _IconlyPair(
    label: 'Notification',
    light: IconlyLight.notification,
    bold: IconlyBold.notification,
    broken: IconlyBroken.notification,
    color: Color(0xFFDC2626),
  ),
  _IconlyPair(
    label: 'Chat',
    light: IconlyLight.chat,
    bold: IconlyBold.chat,
    broken: IconlyBroken.chat,
    color: Color(0xFF7C3AED),
  ),
  _IconlyPair(
    label: 'Bag',
    light: IconlyLight.bag,
    bold: IconlyBold.bag,
    broken: IconlyBroken.bag,
    color: Color(0xFFEA580C),
  ),
  _IconlyPair(
    label: 'Ticket',
    light: IconlyLight.ticket,
    bold: IconlyBold.ticket,
    broken: IconlyBroken.ticket,
    color: Color(0xFF0891B2),
  ),
];

const List<_ActionItem> _actionItems = <_ActionItem>[
  _ActionItem(
    title: 'Discovery Feed',
    caption: 'Use Iconly icons in cards and top-level feature entry points.',
    icon: IconlyLight.discovery,
    color: Color(0xFF2563EB),
  ),
  _ActionItem(
    title: 'Message Center',
    caption: 'Light icons fit compact list rows and secondary actions well.',
    icon: IconlyLight.message,
    color: Color(0xFF14B8A6),
  ),
  _ActionItem(
    title: 'Security Check',
    caption:
        'Broken icons work well for softer outline treatment in status UI.',
    icon: IconlyBroken.shield_done,
    color: Color(0xFF16A34A),
  ),
];

const List<_StatusItem> _statusItems = <_StatusItem>[
  _StatusItem(
    title: 'Payment synced',
    subtitle: 'Pair Iconly with ListTile rows and status copy.',
    icon: IconlyBold.wallet,
    color: Color(0xFF16A34A),
  ),
  _StatusItem(
    title: 'Two uploads pending',
    subtitle: 'Use strong bold icons for progress and urgency.',
    icon: IconlyBold.upload,
    color: Color(0xFFD97706),
  ),
  _StatusItem(
    title: 'Profile update required',
    subtitle: 'Broken or light styles read well in neutral settings panels.',
    icon: IconlyBroken.profile,
    color: Color(0xFF2563EB),
  ),
];

@RoutePage(name: RouteName.iconly)
class IconlyPage extends StatefulWidget {
  const IconlyPage({super.key});

  @override
  State<IconlyPage> createState() => _IconlyPageState();
}

class _IconlyPageState extends State<IconlyPage> {
  _IconlyFamily _family = _IconlyFamily.light;

  IconData _pickIcon(_IconlyPair pair) {
    return switch (_family) {
      _IconlyFamily.light => pair.light,
      _IconlyFamily.bold => pair.bold,
      _IconlyFamily.broken => pair.broken,
    };
  }

  String get _familyLabel {
    return switch (_family) {
      _IconlyFamily.light => 'IconlyLight',
      _IconlyFamily.bold => 'IconlyBold',
      _IconlyFamily.broken => 'IconlyBroken',
    };
  }

  IconData get _primaryActionIcon {
    return switch (_family) {
      _IconlyFamily.light => IconlyLight.send,
      _IconlyFamily.bold => IconlyBold.send,
      _IconlyFamily.broken => IconlyBroken.send,
    };
  }

  IconData get _secondaryActionIcon {
    return switch (_family) {
      _IconlyFamily.light => IconlyLight.filter,
      _IconlyFamily.bold => IconlyBold.filter,
      _IconlyFamily.broken => IconlyBroken.filter,
    };
  }

  IconData get _chipActionIcon {
    return switch (_family) {
      _IconlyFamily.light => IconlyLight.tick_square,
      _IconlyFamily.bold => IconlyBold.tick_square,
      _IconlyFamily.broken => IconlyBroken.tick_square,
    };
  }

  IconData get _navHomeIcon {
    return switch (_family) {
      _IconlyFamily.light => IconlyLight.home,
      _IconlyFamily.bold => IconlyBold.home,
      _IconlyFamily.broken => IconlyBroken.home,
    };
  }

  IconData get _navChartIcon {
    return switch (_family) {
      _IconlyFamily.light => IconlyLight.chart,
      _IconlyFamily.bold => IconlyBold.chart,
      _IconlyFamily.broken => IconlyBroken.chart,
    };
  }

  IconData get _navProfileIcon {
    return switch (_family) {
      _IconlyFamily.light => IconlyLight.profile,
      _IconlyFamily.bold => IconlyBold.profile,
      _IconlyFamily.broken => IconlyBroken.profile,
    };
  }

  IconData get _navBuyIcon {
    return switch (_family) {
      _IconlyFamily.light => IconlyLight.buy,
      _IconlyFamily.bold => IconlyBold.buy,
      _IconlyFamily.broken => IconlyBroken.buy,
    };
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('iconly Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            Text(
              'Iconly icon families in Flutter',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'The `iconly` package exposes three icon families for the same '
              'set of glyphs: `IconlyLight`, `IconlyBold`, and '
              '`IconlyBroken`. This module shows side-by-side comparisons and '
              'real UI usage in buttons, chips, cards, list rows, and a '
              'navigation-style footer.',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            const _CodeSampleCard(),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Icon Family Comparison',
              description:
                  'Use the same semantic icon across all three families to '
                  'match the tone of the screen.',
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: _familyPairs
                    .map((_IconlyPair pair) => _FamilyTile(pair: pair))
                    .toList(),
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Interactive Family Switcher',
              description:
                  'Switch the active family and reuse the same UI structure '
                  'with a different icon treatment.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SegmentedButton<_IconlyFamily>(
                    segments: const <ButtonSegment<_IconlyFamily>>[
                      ButtonSegment<_IconlyFamily>(
                        value: _IconlyFamily.light,
                        label: Text('Light'),
                      ),
                      ButtonSegment<_IconlyFamily>(
                        value: _IconlyFamily.bold,
                        label: Text('Bold'),
                      ),
                      ButtonSegment<_IconlyFamily>(
                        value: _IconlyFamily.broken,
                        label: Text('Broken'),
                      ),
                    ],
                    selected: <_IconlyFamily>{_family},
                    onSelectionChanged: (Set<_IconlyFamily> selection) {
                      setState(() {
                        _family = selection.first;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withValues(
                        alpha: 0.55,
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Current family: $_familyLabel',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: <Widget>[
                            FilledButton.icon(
                              onPressed: () {},
                              icon: Icon(_primaryActionIcon, size: 18),
                              label: const Text('Send Update'),
                            ),
                            OutlinedButton.icon(
                              onPressed: () {},
                              icon: Icon(_secondaryActionIcon, size: 18),
                              label: const Text('Filter'),
                            ),
                            Chip(
                              avatar: Icon(_chipActionIcon, size: 18),
                              label: const Text('Ready to ship'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Wrap(
                          spacing: 20,
                          runSpacing: 20,
                          children: _familyPairs.take(4).map((
                            _IconlyPair pair,
                          ) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Container(
                                  width: 68,
                                  height: 68,
                                  decoration: BoxDecoration(
                                    color: pair.color.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Icon(
                                    _pickIcon(pair),
                                    color: pair.color,
                                    size: 30,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(pair.label),
                              ],
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Cards and Feature Entry Points',
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: _actionItems
                    .map((_ActionItem item) => _ActionCard(item: item))
                    .toList(),
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Status Rows and Settings Lists',
              child: Column(
                children: _statusItems
                    .map((_StatusItem item) => _StatusRow(item: item))
                    .toList(),
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Navigation and Toolbar Usage',
              description:
                  'Iconly works directly with `Icon`, `IconButton`, '
                  '`BottomNavigationBarItem`, and custom nav rows.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHighest
                                .withValues(alpha: 0.55),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: <Widget>[
                              IconButton(
                                onPressed: () {},
                                icon: Icon(_navHomeIcon),
                              ),
                              const Spacer(),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(_secondaryActionIcon),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(_navProfileIcon),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        _NavPill(
                          label: 'Home',
                          icon: _navHomeIcon,
                          selected: true,
                        ),
                        _NavPill(label: 'Stats', icon: _navChartIcon),
                        _NavPill(label: 'Shop', icon: _navBuyIcon),
                        _NavPill(label: 'Me', icon: _navProfileIcon),
                      ],
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
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const <Widget>[
            Text(
              'Basic usage',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 12),
            _CodeBlock(
              code: '''
import 'package:iconly/iconly.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';

Icon(IconlyLight.home)
Icon(IconlyBold.notification)
Icon(IconlyBroken.search)

FilledButton.icon(
  onPressed: () {},
  icon: const Icon(IconlyBold.send, size: 18),
  label: const Text('Send'),
)
''',
            ),
          ],
        ),
      ),
    );
  }
}

class _CodeBlock extends StatelessWidget {
  const _CodeBlock({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        code.trim(),
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(fontFamily: 'monospace', height: 1.5),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.child,
    this.description,
  });

  final String title;
  final String? description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            if (description case final String description) ...<Widget>[
              const SizedBox(height: 8),
              Text(description, style: theme.textTheme.bodyMedium),
            ],
            const SizedBox(height: 18),
            child,
          ],
        ),
      ),
    );
  }
}

class _FamilyTile extends StatelessWidget {
  const _FamilyTile({required this.pair});

  final _IconlyPair pair;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: pair.color.withValues(alpha: 0.08),
        border: Border.all(color: pair.color.withValues(alpha: 0.18)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            pair.label,
            style: TextStyle(
              color: pair.color,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _PreviewGlyph(
                label: 'Light',
                icon: pair.light,
                color: pair.color,
              ),
              _PreviewGlyph(label: 'Bold', icon: pair.bold, color: pair.color),
              _PreviewGlyph(
                label: 'Broken',
                icon: pair.broken,
                color: pair.color,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PreviewGlyph extends StatelessWidget {
  const _PreviewGlyph({
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({required this.item});

  final _ActionItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: item.color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: item.color.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(item.icon, color: item.color, size: 28),
          ),
          const SizedBox(height: 16),
          Text(
            item.title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(item.caption),
        ],
      ),
    );
  }
}

class _StatusRow extends StatelessWidget {
  const _StatusRow({required this.item});

  final _StatusItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: item.color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(item.icon, color: item.color, size: 22),
        ),
        title: Text(item.title),
        subtitle: Text(item.subtitle),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}

class _NavPill extends StatelessWidget {
  const _NavPill({
    required this.label,
    required this.icon,
    this.selected = false,
  });

  final String label;
  final IconData icon;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final Color activeColor = selected ? Colors.white : Colors.white70;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: selected
                ? Colors.white.withValues(alpha: 0.14)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: activeColor, size: 22),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: activeColor,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
