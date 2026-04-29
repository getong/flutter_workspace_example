import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/app_navigation.dart';

class _PanelItem {
  const _PanelItem({
    required this.title,
    required this.summary,
    required this.details,
  });

  final String title;
  final String summary;
  final String details;
}

const List<_PanelItem> _faqPanels = <_PanelItem>[
  _PanelItem(
    title: 'What does ExpansionPanelList solve?',
    summary:
        'It reveals more content without pushing everything on screen at once.',
    details:
        'ExpansionPanelList is useful for FAQs, settings groups, onboarding notes, and any layout where the user only needs one section at a time.',
  ),
  _PanelItem(
    title: 'When should I use the radio variant?',
    summary: 'Use it when only one panel should remain open.',
    details:
        'ExpansionPanelList.radio handles the open-panel state by value, which is convenient when your UX should always collapse the previously opened section.',
  ),
  _PanelItem(
    title: 'Can each panel body contain complex widgets?',
    summary: 'Yes. The body can be any widget subtree.',
    details:
        'You can place forms, buttons, images, chips, rows, and any other widgets inside the expanded body, not only plain text.',
  ),
];

@RoutePage(name: RouteName.expansionPanelList)
class ExpansionPanelListPage extends StatefulWidget {
  const ExpansionPanelListPage({super.key});

  @override
  State<ExpansionPanelListPage> createState() => _ExpansionPanelListPageState();
}

class _ExpansionPanelListPageState extends State<ExpansionPanelListPage> {
  final Set<int> _openPanels = <int>{0};
  bool _notificationsExpanded = true;
  bool _privacyExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ExpansionPanelList Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'ExpansionPanelList shows collapsible sections that let users scan headings first and expand details only when needed.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            const _ExpansionPanelCodeCard(
              title: 'Basic ExpansionPanelList',
              code: '''
ExpansionPanelList(
  expansionCallback: (index, isExpanded) {
    setState(() {
      _isOpen[index] = !isExpanded;
    });
  },
  children: items.map((item) {
    return ExpansionPanel(
      headerBuilder: (context, isExpanded) => ListTile(title: Text(item.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(item.details),
      ),
      isExpanded: item.isExpanded,
    );
  }).toList(),
)
''',
            ),
            const SizedBox(height: 16),
            const _ExpansionPanelCodeCard(
              title: 'ExpansionPanelList.radio',
              code: '''
ExpansionPanelList.radio(
  children: items.map((item) {
    return ExpansionPanelRadio(
      value: item.id,
      headerBuilder: (context, isExpanded) => ListTile(title: Text(item.title)),
      body: ListTile(title: Text(item.details)),
    );
  }).toList(),
)
''',
            ),
            const SizedBox(height: 16),
            _ExpansionPanelExampleCard(
              title: 'Multiple Open Panels',
              description:
                  'This example uses ExpansionPanelList with explicit state so more than one panel can stay open at the same time.',
              child: ExpansionPanelList(
                expansionCallback: (int index, bool isExpanded) {
                  setState(() {
                    if (isExpanded) {
                      _openPanels.remove(index);
                    } else {
                      _openPanels.add(index);
                    }
                  });
                },
                children: List<ExpansionPanel>.generate(_faqPanels.length, (
                  int index,
                ) {
                  final _PanelItem panel = _faqPanels[index];
                  final bool isExpanded = _openPanels.contains(index);

                  return ExpansionPanel(
                    isExpanded: isExpanded,
                    canTapOnHeader: true,
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(
                        title: Text(panel.title),
                        subtitle: Text(panel.summary),
                      );
                    },
                    body: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Text(panel.details),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 16),
            const _ExpansionPanelExampleCard(
              title: 'Radio Behavior',
              description:
                  'ExpansionPanelList.radio automatically keeps only one panel open, which is useful for accordions and section pickers.',
              child: _RadioExpansionPreview(),
            ),
            const SizedBox(height: 16),
            _ExpansionPanelExampleCard(
              title: 'Rich Panel Bodies',
              description:
                  'The body of each panel can contain more than text. This demo mixes switches, chips, and buttons to show a more realistic settings layout.',
              child: ExpansionPanelList(
                expandedHeaderPadding: EdgeInsets.zero,
                expansionCallback: (int index, bool isExpanded) {
                  setState(() {
                    if (index == 0) {
                      _notificationsExpanded = !isExpanded;
                    } else {
                      _privacyExpanded = !isExpanded;
                    }
                  });
                },
                children: <ExpansionPanel>[
                  ExpansionPanel(
                    isExpanded: _notificationsExpanded,
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return const ListTile(
                        leading: Icon(Icons.notifications_active_outlined),
                        title: Text('Notifications'),
                        subtitle: Text('Delivery methods and quiet hours'),
                      );
                    },
                    body: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: const <Widget>[
                              Chip(label: Text('Push enabled')),
                              Chip(label: Text('Email digest')),
                              Chip(label: Text('Mentions only')),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Quiet hours are currently configured for 10:00 PM to 7:00 AM.',
                          ),
                          const SizedBox(height: 12),
                          FilledButton(
                            onPressed: () {},
                            child: const Text('Manage Notification Rules'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ExpansionPanel(
                    isExpanded: _privacyExpanded,
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return const ListTile(
                        leading: Icon(Icons.lock_outline),
                        title: Text('Privacy'),
                        subtitle: Text(
                          'Profile visibility and access controls',
                        ),
                      );
                    },
                    body: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const <Widget>[
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Icon(Icons.public_outlined),
                            title: Text('Profile visibility'),
                            subtitle: Text('Visible to teammates only'),
                          ),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Icon(Icons.shield_outlined),
                            title: Text('Two-factor authentication'),
                            subtitle: Text('Required for all admin actions'),
                          ),
                        ],
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

class _RadioExpansionPreview extends StatelessWidget {
  const _RadioExpansionPreview();

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList.radio(
      children: List<ExpansionPanelRadio>.generate(_faqPanels.length, (
        int index,
      ) {
        final _PanelItem panel = _faqPanels[index];
        return ExpansionPanelRadio(
          value: panel.title,
          canTapOnHeader: true,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(panel.title),
              subtitle: Text(panel.summary),
            );
          },
          body: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(panel.details),
          ),
        );
      }),
    );
  }
}

class _ExpansionPanelExampleCard extends StatelessWidget {
  const _ExpansionPanelExampleCard({
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

class _ExpansionPanelCodeCard extends StatelessWidget {
  const _ExpansionPanelCodeCard({required this.title, required this.code});

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
