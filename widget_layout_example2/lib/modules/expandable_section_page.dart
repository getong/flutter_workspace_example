import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ExpandableSectionPage extends StatefulWidget {
  const ExpandableSectionPage({super.key});

  @override
  State<ExpandableSectionPage> createState() => _ExpandableSectionPageState();
}

class _ExpandableSectionPageState extends State<ExpandableSectionPage> {
  final Set<int> _openFaqs = <int>{0};
  bool _settingsExpanded = true;

  @override
  Widget build(BuildContext context) {
    final List<({String question, String answer})>
    faqs = <({String question, String answer})>[
      (
        question: 'When should I use ExpandableSection?',
        answer:
            'Use it when content needs a compact summary first and detailed body only on demand.',
      ),
      (
        question: 'Can it host complex widgets?',
        answer:
            'Yes. The child can be forms, tables, chips, controls, or any other widget tree.',
      ),
      (
        question: 'Why not just hide the widget?',
        answer:
            'This widget animates layout changes and preserves context for the user instead of abruptly adding or removing content.',
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('ExpandableSection Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'ExpandableSection is useful for progressive disclosure, FAQ blocks, settings groups, and other content that benefits from a summary-to-detail transition.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 24),
            _ExampleCard(
              title: 'FAQ Accordion',
              description:
                  'Use multiple ExpandableSection widgets together to build an accordion-style list of questions and answers.',
              child: Column(
                children: List<Widget>.generate(faqs.length, (int index) {
                  final ({String question, String answer}) faq = faqs[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index == faqs.length - 1 ? 0 : 12,
                    ),
                    child: ExpandableSection(
                      title: faq.question,
                      subtitle:
                          'Tap to ${_openFaqs.contains(index) ? 'collapse' : 'expand'}',
                      expanded: _openFaqs.contains(index),
                      leading: const Icon(Icons.help_outline),
                      onToggle: () {
                        setState(() {
                          if (_openFaqs.contains(index)) {
                            _openFaqs.remove(index);
                          } else {
                            _openFaqs.add(index);
                          }
                        });
                      },
                      child: Text(faq.answer),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'Settings Group',
              description:
                  'The widget also works well for larger section bodies that contain several controls and summary labels.',
              child: ExpandableSection(
                title: 'Release automation settings',
                subtitle: _settingsExpanded ? 'Expanded' : 'Collapsed',
                expanded: _settingsExpanded,
                leading: const Icon(Icons.settings_suggest_outlined),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text(
                    '3 enabled',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                onToggle: () {
                  setState(() {
                    _settingsExpanded = !_settingsExpanded;
                  });
                },
                child: Column(
                  children: <Widget>[
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      value: true,
                      onChanged: (_) {},
                      title: const Text('Run smoke tests before deploy'),
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      value: true,
                      onChanged: (_) {},
                      title: const Text('Notify QA channel automatically'),
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      value: false,
                      onChanged: (_) {},
                      title: const Text('Require manual approval'),
                    ),
                  ],
                ),
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

class ExpandableSection extends StatelessWidget {
  const ExpandableSection({
    super.key,
    required this.title,
    required this.subtitle,
    required this.expanded,
    required this.onToggle,
    required this.child,
    this.leading,
    this.trailing,
  });

  final String title;
  final String subtitle;
  final bool expanded;
  final VoidCallback onToggle;
  final Widget child;
  final Widget? leading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          color: expanded
              ? theme.colorScheme.primary.withValues(alpha: 0.08)
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: expanded
                ? theme.colorScheme.primary.withValues(alpha: 0.45)
                : theme.colorScheme.outlineVariant,
          ),
        ),
        child: Column(
          children: <Widget>[
            InkWell(
              onTap: onToggle,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(18),
                bottom: Radius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: <Widget>[
                    if (leading != null) ...<Widget>[
                      leading!,
                      const SizedBox(width: 12),
                    ],
                    Expanded(
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
                          Text(subtitle),
                        ],
                      ),
                    ),
                    if (trailing != null) ...<Widget>[
                      trailing!,
                      const SizedBox(width: 8),
                    ],
                    AnimatedRotation(
                      turns: expanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 220),
                      child: const Icon(Icons.expand_more),
                    ),
                  ],
                ),
              ),
            ),
            ClipRect(
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 220),
                alignment: Alignment.topCenter,
                heightFactor: expanded ? 1 : 0,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: child,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExampleCard extends StatelessWidget {
  const _ExampleCard({
    required this.title,
    required this.description,
    required this.child,
  });

  final String title;
  final String description;
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
          ],
        ),
      ),
    );
  }
}
