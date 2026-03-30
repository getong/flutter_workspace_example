import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../demo_catalog.dart';
import '../widgets/demo_page_scaffold.dart';

class ShowcaseDetailPage extends StatelessWidget {
  const ShowcaseDetailPage({required this.spec, super.key});

  final ShowcaseSpec spec;

  @override
  Widget build(BuildContext context) {
    final ShadThemeData theme = ShadTheme.of(context);
    return DemoPageScaffold(
      eyebrow: 'Dynamic detail page',
      title: spec.title,
      description: spec.summary,
      actions: <Widget>[
        ShadButton(
          onPressed: () => context.go('/examples'),
          child: const Text('Back To Catalog'),
        ),
        ShadButton.secondary(
          onPressed: () => context.go('/settings'),
          child: const Text('Settings'),
        ),
      ],
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final bool stacked = constraints.maxWidth < 980;
          final Widget previewCard = ShadCard(
            title: const Text('Live preview'),
            description: Text('/layouts/${spec.slug}'),
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: spec.accent.withAlpha(24),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: spec.accent.withAlpha(96)),
                    ),
                    child: SizedBox(
                      height: 260,
                      child: spec.kind == ShowcaseKind.row
                          ? _RowPreview(spec: spec)
                          : _ColumnPreview(spec: spec),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ShadSeparator.horizontal(),
                  const SizedBox(height: 20),
                  Text(spec.message, style: theme.textTheme.lead),
                ],
              ),
            ),
          );

          final Widget detailsColumn = Column(
            children: <Widget>[
              ShadCard(
                title: const Text('Highlights'),
                description: const Text(
                  'Notes carried over from the original row/column teaching angle.',
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: spec.highlights
                        .map(
                          (String highlight) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Icon(spec.icon, size: 18, color: spec.accent),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    highlight,
                                    style: theme.textTheme.p,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(growable: false),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ShadCard(
                title: const Text('Readiness'),
                description: const Text(
                  'A small UI signal to demonstrate additional shadcn_ui components.',
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: spec.tags
                            .map(
                              (String tag) =>
                                  ShadBadge.secondary(child: Text(tag)),
                            )
                            .toList(growable: false),
                      ),
                      const SizedBox(height: 16),
                      ShadProgress(value: spec.readiness),
                      const SizedBox(height: 8),
                      Text(
                        '${(spec.readiness * 100).round()}% fit for demo use',
                        style: theme.textTheme.small,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );

          if (stacked) {
            return Column(
              children: <Widget>[
                previewCard,
                const SizedBox(height: 16),
                detailsColumn,
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(flex: 3, child: previewCard),
              const SizedBox(width: 16),
              Expanded(flex: 2, child: detailsColumn),
            ],
          );
        },
      ),
    );
  }
}

class _RowPreview extends StatelessWidget {
  const _RowPreview({required this.spec});

  final ShowcaseSpec spec;

  @override
  Widget build(BuildContext context) {
    if (spec.slug == 'row-rainbow') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: const <Widget>[
          _PreviewBar(color: Color(0xFFF97316), height: 72, label: 'Plan'),
          _PreviewBar(color: Color(0xFFF59E0B), height: 98, label: 'Build'),
          _PreviewBar(color: Color(0xFF10B981), height: 126, label: 'QA'),
          _PreviewBar(color: Color(0xFF2563EB), height: 152, label: 'Ship'),
        ],
      );
    }

    return Row(
      children: <Widget>[
        _CommandChip(
          label: 'Create',
          icon: Icons.add_rounded,
          color: spec.accent,
        ),
        const SizedBox(width: 10),
        _CommandChip(
          label: 'Share',
          icon: Icons.ios_share_rounded,
          color: spec.accent,
        ),
        const SizedBox(width: 10),
        _CommandChip(
          label: 'Archive',
          icon: Icons.archive_outlined,
          color: spec.accent,
        ),
        const Spacer(),
        Icon(Icons.more_horiz_rounded, color: spec.accent),
      ],
    );
  }
}

class _ColumnPreview extends StatelessWidget {
  const _ColumnPreview({required this.spec});

  final ShowcaseSpec spec;

  @override
  Widget build(BuildContext context) {
    if (spec.slug == 'column-cards') {
      return Column(
        children: const <Widget>[
          _InfoCard(
            title: 'Planning',
            subtitle: 'Three tasks due today',
            color: Color(0xFFDBEAFE),
          ),
          SizedBox(height: 12),
          _InfoCard(
            title: 'Review',
            subtitle: 'Two pull requests waiting',
            color: Color(0xFFD1FAE5),
          ),
          SizedBox(height: 12),
          _InfoCard(
            title: 'Deploy',
            subtitle: 'Staging is green',
            color: Color(0xFFEDE9FE),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: const <Widget>[
        Expanded(
          flex: 2,
          child: _PanelBlock(label: 'Top overview', color: Color(0xFFE9D5FF)),
        ),
        SizedBox(height: 12),
        Expanded(
          child: _PanelBlock(label: 'Middle KPI', color: Color(0xFFDDD6FE)),
        ),
        SizedBox(height: 12),
        Expanded(
          flex: 2,
          child: _PanelBlock(
            label: 'Bottom activity feed',
            color: Color(0xFFC4B5FD),
          ),
        ),
      ],
    );
  }
}

class _PreviewBar extends StatelessWidget {
  const _PreviewBar({
    required this.color,
    required this.height,
    required this.label,
  });

  final Color color;
  final double height;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Text(label),
        const SizedBox(height: 8),
        Container(
          width: 56,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ],
    );
  }
}

class _CommandChip extends StatelessWidget {
  const _CommandChip({
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(225),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withAlpha(64)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.subtitle,
    required this.color,
  });

  final String title;
  final String subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
            const Spacer(),
            Text(subtitle),
          ],
        ),
      ),
    );
  }
}

class _PanelBlock extends StatelessWidget {
  const _PanelBlock({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: Alignment.center,
      child: Text(label),
    );
  }
}
