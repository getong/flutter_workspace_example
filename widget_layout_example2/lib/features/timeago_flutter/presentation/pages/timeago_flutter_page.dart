import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:timeago_flutter/timeago_flutter.dart' as fuzzy;
// ignore: implementation_imports
import 'package:timeago_flutter/src/timer_refresh.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';

enum _TimeagoLocale { english, shortEnglish }

class _RefreshOption {
  const _RefreshOption({required this.label, required this.duration});

  final String label;
  final Duration duration;
}

const List<_RefreshOption> _refreshOptions = <_RefreshOption>[
  _RefreshOption(label: '1 sec', duration: Duration(seconds: 1)),
  _RefreshOption(label: '10 sec', duration: Duration(seconds: 10)),
  _RefreshOption(label: '1 min', duration: Duration(minutes: 1)),
];

@RoutePage(name: RouteName.timeagoFlutter)
class TimeagoFlutterPage extends StatefulWidget {
  const TimeagoFlutterPage({super.key});

  @override
  State<TimeagoFlutterPage> createState() => _TimeagoFlutterPageState();
}

class _TimeagoFlutterPageState extends State<TimeagoFlutterPage> {
  static bool _messagesInitialized = false;

  _TimeagoLocale _selectedLocale = _TimeagoLocale.english;
  Duration _refreshRate = const Duration(seconds: 1);
  bool _allowFromNow = true;
  DateTime _anchor = DateTime.now();

  @override
  void initState() {
    super.initState();
    _initializeMessages();
  }

  void _initializeMessages() {
    if (_messagesInitialized) {
      return;
    }

    fuzzy.setLocaleMessages('en_short', fuzzy.EnShortMessages());
    _messagesInitialized = true;
  }

  String get _localeCode => switch (_selectedLocale) {
    _TimeagoLocale.english => 'en',
    _TimeagoLocale.shortEnglish => 'en_short',
  };

  DateTime get _pastShortDate => _anchor.subtract(const Duration(seconds: 45));
  DateTime get _pastMediumDate => _anchor.subtract(const Duration(minutes: 12));
  DateTime get _pastLongDate => _anchor.subtract(const Duration(days: 3));
  DateTime get _futureDate => _anchor.add(const Duration(minutes: 15));

  @override
  Widget build(BuildContext context) {
    final String directPast = fuzzy.format(
      _pastMediumDate,
      clock: _anchor,
      locale: _localeCode,
    );
    final String directFuture = fuzzy.format(
      _futureDate,
      clock: _anchor,
      locale: _localeCode,
      allowFromNow: _allowFromNow,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('timeago_flutter Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'timeago_flutter wraps fuzzy relative-time formatting in Flutter widgets so labels can refresh themselves over time without manual timer wiring in every screen.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            const _TimeagoCodeCard(
              title: 'Basic Timeago widget',
              code: '''
Timeago(
  date: createdAt,
  builder: (context, value) => Text(value),
);
''',
            ),
            const SizedBox(height: 16),
            const _TimeagoCodeCard(
              title: 'Custom refresh rate and locale',
              code: '''
Timeago(
  date: createdAt,
  locale: 'en_short',
  refreshRate: const Duration(seconds: 10),
  builder: (context, value) => Chip(label: Text(value)),
);
''',
            ),
            const SizedBox(height: 16),
            const _TimeagoCodeCard(
              title: 'TimerRefresh for any widget subtree',
              code: '''
TimerRefresh(
  refreshRate: const Duration(seconds: 1),
  builder: (context, child) {
    return Text(DateTime.now().toIso8601String());
  },
);
''',
            ),
            const SizedBox(height: 16),
            Card(
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Demo Controls',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Switch locale and refresh cadence to see the widgets rebuild with different fuzzy-time strings.',
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: _TimeagoLocale.values.map((
                        _TimeagoLocale locale,
                      ) {
                        final bool selected = locale == _selectedLocale;
                        final String label = switch (locale) {
                          _TimeagoLocale.english => 'en',
                          _TimeagoLocale.shortEnglish => 'en_short',
                        };

                        return ChoiceChip(
                          label: Text(label),
                          selected: selected,
                          onSelected: (bool value) {
                            if (!value) {
                              return;
                            }

                            setState(() {
                              _selectedLocale = locale;
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: _refreshOptions.map((_RefreshOption option) {
                        return ChoiceChip(
                          label: Text(option.label),
                          selected: option.duration == _refreshRate,
                          onSelected: (bool value) {
                            if (!value) {
                              return;
                            }

                            setState(() {
                              _refreshRate = option.duration;
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 12),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      value: _allowFromNow,
                      title: const Text('Allow future dates'),
                      subtitle: const Text(
                        'Turn this off to compare default formatting versus "from now" strings.',
                      ),
                      onChanged: (bool value) {
                        setState(() {
                          _allowFromNow = value;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: () {
                        setState(() {
                          _anchor = DateTime.now();
                        });
                      },
                      icon: const Icon(Icons.refresh_outlined),
                      label: const Text('Reset Anchor To Now'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Timeago Widget Examples',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _ExampleRow(
                      label: '45 seconds ago',
                      child: fuzzy.Timeago(
                        date: _pastShortDate,
                        locale: _localeCode,
                        refreshRate: _refreshRate,
                        builder: (BuildContext context, String value) {
                          return Chip(label: Text(value));
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    _ExampleRow(
                      label: '12 minutes ago',
                      child: fuzzy.Timeago(
                        date: _pastMediumDate,
                        locale: _localeCode,
                        refreshRate: _refreshRate,
                        builder: (BuildContext context, String value) {
                          return Text(
                            value,
                            style: Theme.of(context).textTheme.titleLarge,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    _ExampleRow(
                      label: '3 days ago',
                      child: fuzzy.Timeago(
                        date: _pastLongDate,
                        locale: _localeCode,
                        refreshRate: _refreshRate,
                        builder: (BuildContext context, String value) {
                          return DecoratedBox(
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: 0.10),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              child: Text(value),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    _ExampleRow(
                      label: '15 minutes in the future',
                      child: fuzzy.Timeago(
                        date: _futureDate,
                        locale: _localeCode,
                        allowFromNow: _allowFromNow,
                        refreshRate: _refreshRate,
                        builder: (BuildContext context, String value) {
                          return Text(
                            value,
                            style: Theme.of(context).textTheme.titleMedium,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Direct format() Output',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _TimeagoValueTile(
                      label: 'format() for past date',
                      value: directPast,
                    ),
                    const SizedBox(height: 12),
                    _TimeagoValueTile(
                      label: 'format() for future date',
                      value: directFuture,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'TimerRefresh Example',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'TimerRefresh can rebuild any widget subtree at a fixed cadence, not only fuzzy-time labels.',
                    ),
                    const SizedBox(height: 12),
                    TimerRefresh(
                      refreshRate: _refreshRate,
                      builder: (BuildContext context, Widget? child) {
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.timer_outlined),
                          title: const Text('Current clock sample'),
                          subtitle: Text(DateTime.now().toIso8601String()),
                          trailing: child,
                        );
                      },
                      child: Chip(
                        label: Text('refresh ${_refreshRate.inSeconds}s'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const _TimeagoInfoCard(
              title: 'Platform notes',
              description:
                  'timeago_flutter is UI-focused and works everywhere Flutter runs because the relative-time formatting is pure Dart. Locale-specific short formats such as en_short may require message registration before use, which this demo performs in initState.',
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

class _TimeagoInfoCard extends StatelessWidget {
  const _TimeagoInfoCard({required this.title, required this.description});

  final String title;
  final String description;

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
          ],
        ),
      ),
    );
  }
}

class _TimeagoCodeCard extends StatelessWidget {
  const _TimeagoCodeCard({required this.title, required this.code});

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

class _ExampleRow extends StatelessWidget {
  const _ExampleRow({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(flex: 3, child: child),
      ],
    );
  }
}

class _TimeagoValueTile extends StatelessWidget {
  const _TimeagoValueTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(value),
        ],
      ),
    );
  }
}
