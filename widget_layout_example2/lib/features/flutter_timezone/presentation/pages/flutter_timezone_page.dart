import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';

@RoutePage(name: RouteName.flutterTimezone)
class FlutterTimezonePage extends StatefulWidget {
  const FlutterTimezonePage({super.key});

  @override
  State<FlutterTimezonePage> createState() => _FlutterTimezonePageState();
}

class _FlutterTimezonePageState extends State<FlutterTimezonePage> {
  final TextEditingController _localeController = TextEditingController(
    text: 'en_US',
  );

  TimezoneInfo? _localTimezone;
  List<TimezoneInfo> _availableTimezones = <TimezoneInfo>[];
  String _status =
      'Run one of the actions below to request timezone information from the native platform.';
  bool _busy = false;
  double _visibleCount = 6;

  @override
  void initState() {
    super.initState();
    _loadLocalTimezone();
  }

  @override
  void dispose() {
    _localeController.dispose();
    super.dispose();
  }

  String? get _localeOrNull {
    final String locale = _localeController.text.trim();
    return locale.isEmpty ? null : locale;
  }

  Future<void> _runBusy(Future<void> Function() action) async {
    if (_busy) {
      return;
    }

    setState(() {
      _busy = true;
    });

    try {
      await action();
    } on PlatformException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _status =
            'PlatformException(${error.code}): ${error.message ?? 'No message'}';
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _status = 'Unexpected error: $error';
      });
    } finally {
      if (mounted) {
        setState(() {
          _busy = false;
        });
      }
    }
  }

  Future<void> _loadLocalTimezone({bool localized = false}) async {
    await _runBusy(() async {
      final TimezoneInfo timezone = await FlutterTimezone.getLocalTimezone(
        localized ? _localeOrNull : null,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _localTimezone = timezone;
        _status = localized
            ? 'Loaded the local timezone with locale "${_localeOrNull ?? 'default'}".'
            : 'Loaded the local timezone identifier from the native platform.';
      });
    });
  }

  Future<void> _loadAvailableTimezones({bool localized = false}) async {
    await _runBusy(() async {
      final List<TimezoneInfo> timezones =
          await FlutterTimezone.getAvailableTimezones(
            localized ? _localeOrNull : null,
          );

      if (!mounted) {
        return;
      }

      setState(() {
        _availableTimezones = timezones;
        _status = localized
            ? 'Loaded ${timezones.length} available timezones with locale "${_localeOrNull ?? 'default'}".'
            : 'Loaded ${timezones.length} available timezone identifiers.';
      });
    });
  }

  String _formatTimezoneInfo(TimezoneInfo? timezone) {
    if (timezone == null) {
      return 'No timezone data loaded yet.';
    }

    final ({String name, String locale})? localizedName =
        timezone.localizedName;
    if (localizedName == null) {
      return 'identifier=${timezone.identifier}\nlocalizedName=not provided on this platform/locale';
    }

    return 'identifier=${timezone.identifier}\nlocalizedName=${localizedName.name}\nlocale=${localizedName.locale}';
  }

  @override
  Widget build(BuildContext context) {
    final int maxVisibleItems = _availableTimezones.isEmpty
        ? 0
        : _availableTimezones.length.clamp(0, _visibleCount.round());

    return Scaffold(
      appBar: AppBar(title: const Text('flutter_timezone Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'flutter_timezone reads the current platform timezone and can also return a list of available timezone identifiers, with localized names when the platform provides them.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            const _TimezoneCodeCard(
              title: 'Get the local timezone',
              code: '''
final TimezoneInfo timezone = await FlutterTimezone.getLocalTimezone();

final TimezoneInfo localizedTimezone =
    await FlutterTimezone.getLocalTimezone('en_US');
''',
            ),
            const SizedBox(height: 16),
            const _TimezoneCodeCard(
              title: 'List available timezones',
              code: '''
final List<TimezoneInfo> timezones =
    await FlutterTimezone.getAvailableTimezones();

final List<TimezoneInfo> localizedTimezones =
    await FlutterTimezone.getAvailableTimezones('de');
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
                      'Locale Input',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Enter a locale code if you want the native layer to try returning localized timezone names.',
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _localeController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Locale',
                        hintText: 'Examples: en_US, de, zh_CN',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: <Widget>[
                        FilledButton.icon(
                          onPressed: _busy
                              ? null
                              : () => _loadLocalTimezone(localized: false),
                          icon: const Icon(Icons.my_location_outlined),
                          label: const Text('Local Timezone'),
                        ),
                        OutlinedButton.icon(
                          onPressed: _busy
                              ? null
                              : () => _loadLocalTimezone(localized: true),
                          icon: const Icon(Icons.translate_outlined),
                          label: const Text('Localized Local'),
                        ),
                        OutlinedButton.icon(
                          onPressed: _busy
                              ? null
                              : () => _loadAvailableTimezones(localized: false),
                          icon: const Icon(Icons.list_alt_outlined),
                          label: const Text('Available List'),
                        ),
                        OutlinedButton.icon(
                          onPressed: _busy
                              ? null
                              : () => _loadAvailableTimezones(localized: true),
                          icon: const Icon(Icons.public_outlined),
                          label: const Text('Localized List'),
                        ),
                      ],
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
                      'Current Result',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _StatusBlock(title: 'Status', value: _status),
                    const SizedBox(height: 12),
                    _StatusBlock(
                      title: 'Local Timezone',
                      value: _formatTimezoneInfo(_localTimezone),
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
                      'Available Timezone Preview',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _availableTimezones.isEmpty
                          ? 'Load the available timezone list to inspect platform results.'
                          : 'Showing the first $maxVisibleItems of ${_availableTimezones.length} results.',
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Visible rows: ${_visibleCount.round()}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Slider(
                      value: _visibleCount,
                      min: 3,
                      max: 12,
                      divisions: 9,
                      label: _visibleCount.round().toString(),
                      onChanged: (double value) {
                        setState(() {
                          _visibleCount = value;
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    if (_availableTimezones.isEmpty)
                      const Text('No available timezone list loaded yet.')
                    else
                      ..._availableTimezones.take(maxVisibleItems).map((
                        TimezoneInfo timezone,
                      ) {
                        final ({String name, String locale})? localizedName =
                            timezone.localizedName;
                        final String subtitle = localizedName == null
                            ? 'Localized name unavailable'
                            : '${localizedName.name} (${localizedName.locale})';

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.schedule_outlined),
                            title: Text(timezone.identifier),
                            subtitle: Text(subtitle),
                          ),
                        );
                      }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const _TimezoneInfoCard(
              title: 'Platform notes',
              description:
                  'The package returns IANA timezone identifiers such as "Asia/Shanghai" or "America/Los_Angeles". Localized names depend on platform support and the locale you request, so some platforms may only return identifiers even when a locale code is provided.',
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

class _TimezoneInfoCard extends StatelessWidget {
  const _TimezoneInfoCard({required this.title, required this.description});

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

class _TimezoneCodeCard extends StatelessWidget {
  const _TimezoneCodeCard({required this.title, required this.code});

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

class _StatusBlock extends StatelessWidget {
  const _StatusBlock({required this.title, required this.value});

  final String title;
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
            title,
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
