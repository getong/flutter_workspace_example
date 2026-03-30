import 'package:flutter/material.dart';

enum ShowcaseKind {
  row('Row'),
  column('Column');

  const ShowcaseKind(this.label);

  final String label;
}

class ShowcaseSpec {
  const ShowcaseSpec({
    required this.slug,
    required this.title,
    required this.summary,
    required this.message,
    required this.kind,
    required this.icon,
    required this.accent,
    required this.readiness,
    required this.tags,
    required this.highlights,
  });

  final String slug;
  final String title;
  final String summary;
  final String message;
  final ShowcaseKind kind;
  final IconData icon;
  final Color accent;
  final double readiness;
  final List<String> tags;
  final List<String> highlights;
}

const List<ShowcaseSpec> showcaseSpecs = <ShowcaseSpec>[
  ShowcaseSpec(
    slug: 'row-rainbow',
    title: 'Row Rainbow',
    summary: 'Balanced horizontal spacing with cards that grow by intent.',
    message: 'Use even spacing when every item deserves equal visual weight.',
    kind: ShowcaseKind.row,
    icon: Icons.view_week_rounded,
    accent: Color(0xFFF97316),
    readiness: 0.78,
    tags: <String>['Row', 'Even spacing', 'Status strip'],
    highlights: <String>[
      'Spreads four blocks across one line without nested layout noise.',
      'Changes in height still read clearly because the bottom edge stays aligned.',
      'Maps well to KPI bands, release stages, or dashboard headers.',
    ],
  ),
  ShowcaseSpec(
    slug: 'row-chips',
    title: 'Row Chips',
    summary: 'Compact command rows that keep primary actions visible.',
    message: 'A row works well when actions should scan left-to-right quickly.',
    kind: ShowcaseKind.row,
    icon: Icons.tune_rounded,
    accent: Color(0xFF0F766E),
    readiness: 0.86,
    tags: <String>['Row', 'Toolbar', 'Actions'],
    highlights: <String>[
      'Mixes fixed-width chips with a trailing overflow affordance.',
      'Good fit for filters, quick actions, and command bars.',
      'Keeps interaction density high without reaching for a full app bar.',
    ],
  ),
  ShowcaseSpec(
    slug: 'column-cards',
    title: 'Column Cards',
    summary: 'Stacked cards for short summaries, checklists, or inbox views.',
    message: 'Columns shine when the reading order needs to stay explicit.',
    kind: ShowcaseKind.column,
    icon: Icons.view_agenda_rounded,
    accent: Color(0xFF2563EB),
    readiness: 0.72,
    tags: <String>['Column', 'Cards', 'Feed'],
    highlights: <String>[
      'Natural top-to-bottom reading order for task lists and notifications.',
      'Easy to mix fixed spacing with flexible content height.',
      'Useful when each block contains different detail density.',
    ],
  ),
  ShowcaseSpec(
    slug: 'column-dashboard',
    title: 'Column Dashboard',
    summary:
        'Expanded sections create a vertical dashboard with clear priority.',
    message:
        'Expanded children help columns express hierarchy without custom math.',
    kind: ShowcaseKind.column,
    icon: Icons.dashboard_customize_rounded,
    accent: Color(0xFF7C3AED),
    readiness: 0.91,
    tags: <String>['Column', 'Expanded', 'Dashboard'],
    highlights: <String>[
      'Distributes available height according to section importance.',
      'A reliable pattern for mobile dashboards and operations panels.',
      'Keeps major panels visible while still reserving space for activity details.',
    ],
  ),
];

ShowcaseSpec? findShowcase(String slug) {
  for (final ShowcaseSpec spec in showcaseSpecs) {
    if (spec.slug == slug) {
      return spec;
    }
  }
  return null;
}

List<ShowcaseSpec> showcasesByKind(ShowcaseKind kind) {
  return showcaseSpecs
      .where((ShowcaseSpec spec) => spec.kind == kind)
      .toList(growable: false);
}
