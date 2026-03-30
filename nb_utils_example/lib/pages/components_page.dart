import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';

class ComponentsPage extends StatelessWidget {
  const ComponentsPage({super.key});

  static const List<_ComponentCardSpec> _cards = <_ComponentCardSpec>[
    _ComponentCardSpec(
      title: 'Flexible spacing',
      subtitle: 'Use `HorizontalList` when cards should size to content.',
      color: Color(0xFFE0F2FE),
      icon: Icons.view_carousel_outlined,
    ),
    _ComponentCardSpec(
      title: 'Readable typography',
      subtitle:
          'Helpers like `boldTextStyle` and `secondaryTextStyle` keep UI consistent.',
      color: Color(0xFFDCFCE7),
      icon: Icons.text_fields_outlined,
    ),
    _ComponentCardSpec(
      title: 'Compact actions',
      subtitle: '`AppButton` gives a quick path to branded buttons.',
      color: Color(0xFFFFF1D6),
      icon: Icons.smart_button_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Components Gallery')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          Text('Reusable widgets', style: boldTextStyle(size: 24)),
          8.height,
          Text(
            'This page focuses on small, reusable building blocks from `nb_utils`.',
            style: secondaryTextStyle(),
          ),
          18.height,
          HorizontalList(
            itemCount: _cards.length,
            padding: EdgeInsets.zero,
            spacing: 12,
            itemBuilder: (BuildContext context, int index) {
              final _ComponentCardSpec card = _cards[index];

              return Container(
                width: 250,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: card.color,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(card.icon, color: colorScheme.primary),
                    ),
                    16.height,
                    Text(card.title, style: boldTextStyle(size: 18)),
                    8.height,
                    Text(card.subtitle, style: secondaryTextStyle(size: 13)),
                  ],
                ),
              );
            },
          ),
          24.height,
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Quick actions', style: boldTextStyle(size: 18)),
                  8.height,
                  Text(
                    'The buttons below demonstrate package widgets and route transitions.',
                    style: secondaryTextStyle(),
                  ),
                  18.height,
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: AppButton(
                          text: 'Show toast',
                          color: colorScheme.primary,
                          textColor: Colors.white,
                          onTap: () {
                            toast('nb_utils toast helper is active');
                          },
                        ),
                      ),
                      12.width,
                      Expanded(
                        child: AppButton(
                          color: colorScheme.surface,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.route_outlined,
                                size: 18,
                                color: colorScheme.primary,
                              ),
                              8.width,
                              Text(
                                'Open recipe',
                                style: boldTextStyle(
                                  color: colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                          onTap: () => context.goNamed(
                            'recipe',
                            pathParameters: const <String, String>{
                              'slug': 'starter-kit',
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          16.height,
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Design notes', style: boldTextStyle(size: 18)),
                  12.height,
                  _InlineNote(
                    icon: Icons.check_circle_outline,
                    text: 'Keep page-to-page navigation in go_router.',
                  ),
                  10.height,
                  _InlineNote(
                    icon: Icons.check_circle_outline,
                    text:
                        'Use nb_utils for the small repetitive UI primitives.',
                  ),
                  10.height,
                  _InlineNote(
                    icon: Icons.check_circle_outline,
                    text:
                        'Prefer a few clear widgets over a page full of disconnected package samples.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InlineNote extends StatelessWidget {
  const _InlineNote({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        10.width,
        Expanded(child: Text(text, style: secondaryTextStyle(size: 14))),
      ],
    );
  }
}

class _ComponentCardSpec {
  const _ComponentCardSpec({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;
}
