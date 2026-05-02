import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:widget_layout_example2/app_navigation.dart';

@RoutePage(name: RouteName.cookieJar)
class CookieJarPage extends StatefulWidget {
  const CookieJarPage({super.key});

  @override
  State<CookieJarPage> createState() => _CookieJarPageState();
}

class _CookieJarPageState extends State<CookieJarPage> {
  final List<String> _memoryTimeline = <String>[
    'Ready. Save sample cookies to inspect host, path, expiry, and domain rules.',
  ];
  final _DebugStorage _debugStorage = _DebugStorage();

  late CookieJar _memoryJar;

  bool _isBusy = false;
  bool _ignoreExpires = false;
  bool _persistSession = true;

  String _memoryStatus = 'No cookies saved in the in-memory jar yet.';
  String _persistStatus =
      'PersistCookieJar demo has not been run yet. It will use FileStorage.';
  String _serializationStatus =
      'SerializableCookie converts Cookie values into a persistable string.';
  String _customStorageStatus =
      'Custom Storage demo has not been run yet. It will log read/write calls.';
  String? _persistPath;
  String? _serializedCookie;
  String? _restoredCookie;

  List<Cookie> _memoryHomeCookies = const <Cookie>[];
  List<Cookie> _memoryPathsCookies = const <Cookie>[];
  List<Cookie> _persistedCookies = const <Cookie>[];
  List<Cookie> _customStorageCookies = const <Cookie>[];

  @override
  void initState() {
    super.initState();
    _memoryJar = CookieJar(ignoreExpires: _ignoreExpires);
  }

  Future<void> _runBusyAction(Future<void> Function() action) async {
    if (_isBusy) {
      return;
    }

    setState(() {
      _isBusy = true;
    });

    try {
      await action();
    } finally {
      if (mounted) {
        setState(() {
          _isBusy = false;
        });
      }
    }
  }

  void _appendTimeline(String message) {
    final DateTime now = DateTime.now();
    final String stamp =
        '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}:'
        '${now.second.toString().padLeft(2, '0')}';

    setState(() {
      _memoryTimeline.insert(0, '$stamp  $message');
      if (_memoryTimeline.length > 12) {
        _memoryTimeline.removeRange(12, _memoryTimeline.length);
      }
    });
  }

  List<Cookie> _sampleCookies() {
    final Cookie session = Cookie('session_id', 'pkg-demo-001')..path = '/';
    final Cookie pathScoped = Cookie('docs_theme', 'dark')..path = '/paths';
    final Cookie domainScoped = Cookie('region', 'asia')
      ..domain = '.pub.dev'
      ..path = '/';
    final Cookie expired = Cookie('expired_token', 'remove-me')
      ..path = '/'
      ..maxAge = -1;
    return <Cookie>[session, pathScoped, domainScoped, expired];
  }

  Future<void> _saveToMemoryJar() async {
    await _runBusyAction(() async {
      final Uri responseUri = Uri.parse('https://pub.dev/paths/get-started');
      await _memoryJar.deleteAll();
      await _memoryJar.saveFromResponse(responseUri, _sampleCookies());
      final List<Cookie> homeCookies = await _memoryJar.loadForRequest(
        Uri.parse('https://pub.dev/'),
      );
      final List<Cookie> pathsCookies = await _memoryJar.loadForRequest(
        Uri.parse('https://pub.dev/paths/details'),
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _memoryHomeCookies = homeCookies;
        _memoryPathsCookies = pathsCookies;
        _memoryStatus =
            'Saved four cookies into `CookieJar()`. The expired cookie was '
            '${_ignoreExpires ? 'kept because ignoreExpires is enabled' : 'discarded'}, '
            'and `/paths` requests receive the path-scoped cookie.';
      });

      _appendTimeline(
        'Saved sample cookies for https://pub.dev/paths/get-started and loaded request views for `/` and `/paths/details`.',
      );
    });
  }

  Future<void> _clearMemoryJar() async {
    await _runBusyAction(() async {
      _memoryJar = CookieJar(ignoreExpires: _ignoreExpires);
      await _memoryJar.deleteAll();

      if (!mounted) {
        return;
      }

      setState(() {
        _memoryHomeCookies = const <Cookie>[];
        _memoryPathsCookies = const <Cookie>[];
        _memoryStatus = 'Cleared all in-memory cookies.';
      });

      _appendTimeline('Called deleteAll() on the in-memory jar.');
    });
  }

  Future<void> _deletePubDevCookies() async {
    await _runBusyAction(() async {
      final Uri pubDevUri = Uri.parse('https://pub.dev/paths/details');
      await _memoryJar.delete(pubDevUri, true);
      final List<Cookie> homeCookies = await _memoryJar.loadForRequest(
        Uri.parse('https://pub.dev/'),
      );
      final List<Cookie> pathsCookies = await _memoryJar.loadForRequest(
        pubDevUri,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _memoryHomeCookies = homeCookies;
        _memoryPathsCookies = pathsCookies;
        _memoryStatus =
            'Deleted cookies for `pub.dev` and included domain-shared cookies via `delete(uri, true)`.';
      });

      _appendTimeline('Deleted host and domain-shared cookies for pub.dev.');
    });
  }

  Future<void> _runPersistDemo() async {
    await _runBusyAction(() async {
      if (kIsWeb) {
        setState(() {
          _persistStatus =
              'This demo uses FileStorage, so it is intended for Flutter IO '
              'targets rather than the browser.';
          _persistedCookies = const <Cookie>[];
          _persistPath = null;
        });
        return;
      }

      final tempDir = await getTemporaryDirectory();
      final String storagePath =
          '${tempDir.path}/widget_layout_example2_cookie_jar_demo';
      final FileStorage storage = FileStorage(storagePath);
      final Uri uri = Uri.parse('https://pub.dev/packages/cookie_jar');

      final PersistCookieJar writerJar = PersistCookieJar(
        persistSession: _persistSession,
        ignoreExpires: false,
        storage: storage,
      );
      await writerJar.deleteAll();
      await writerJar.saveFromResponse(uri, <Cookie>[
        Cookie('remember_me', 'true')
          ..path = '/'
          ..expires = DateTime.now().add(const Duration(days: 7)),
        Cookie('session_mode', 'interactive')..path = '/',
      ]);

      final PersistCookieJar readerJar = PersistCookieJar(
        persistSession: _persistSession,
        ignoreExpires: false,
        storage: FileStorage(storagePath),
      );
      final List<Cookie> reloaded = await readerJar.loadForRequest(uri);

      if (!mounted) {
        return;
      }

      setState(() {
        _persistPath = storagePath;
        _persistedCookies = reloaded;
        _persistStatus =
            'Saved cookies with one PersistCookieJar instance and loaded them '
            'with a fresh instance. '
            '${_persistSession ? 'Session cookies were persisted too.' : 'Session cookies were skipped because persistSession is false.'}';
      });
    });
  }

  Future<void> _clearPersistedCookies() async {
    await _runBusyAction(() async {
      if (kIsWeb || _persistPath == null) {
        if (mounted) {
          setState(() {
            _persistedCookies = const <Cookie>[];
            _persistStatus =
                'Nothing to clear yet. Run the persisted demo first on an IO target.';
          });
        }
        return;
      }

      final PersistCookieJar jar = PersistCookieJar(
        persistSession: _persistSession,
        storage: FileStorage(_persistPath),
      );
      await jar.deleteAll();

      if (!mounted) {
        return;
      }

      setState(() {
        _persistedCookies = const <Cookie>[];
        _persistStatus = 'Cleared FileStorage-backed cookies with deleteAll().';
      });
    });
  }

  void _runSerializableCookieDemo() {
    final SerializableCookie serializable = SerializableCookie(
      Cookie('package', 'cookie_jar')
        ..path = '/'
        ..expires = DateTime.now().add(const Duration(days: 3)),
    );
    final String value = serializable.toJson();
    final Cookie restored = SerializableCookie.fromJson(value).cookie;

    setState(() {
      _serializedCookie = value;
      _restoredCookie =
          'Cookie(name: ${restored.name}, value: ${restored.value}, '
          'path: ${restored.path}, expires: ${restored.expires})';
      _serializationStatus =
          'Serialized a Cookie into a string and restored it with `SerializableCookie.fromJson(...)`.';
    });
  }

  Future<void> _runCustomStorageDemo() async {
    await _runBusyAction(() async {
      _debugStorage.reset();

      final PersistCookieJar jar = PersistCookieJar(
        persistSession: true,
        storage: _debugStorage,
      );
      final Uri uri = Uri.parse('https://pub.dev/api/packages');

      await jar.saveFromResponse(uri, <Cookie>[
        Cookie('api_token', 'demo-token')..path = '/api',
      ]);
      final List<Cookie> cookies = await jar.loadForRequest(
        Uri.parse('https://pub.dev/api/packages/cookie_jar'),
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _customStorageCookies = cookies;
        _customStorageStatus =
            'PersistCookieJar wrote into a custom Storage implementation instead of FileStorage.';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('cookie_jar Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            Text(
              'cookie_jar manages HTTP cookies for Dart and Flutter. This page '
              'demonstrates the real package API using `CookieJar`, '
              '`PersistCookieJar`, `SerializableCookie`, and custom `Storage`.',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: const <Widget>[
                Chip(label: Text('CookieJar()')),
                Chip(label: Text('PersistCookieJar')),
                Chip(label: Text('FileStorage')),
                Chip(label: Text('SerializableCookie')),
                Chip(label: Text('Storage')),
                Chip(label: Text('saveFromResponse')),
                Chip(label: Text('loadForRequest')),
                Chip(label: Text('delete / deleteAll')),
              ],
            ),
            const SizedBox(height: 24),
            const _CodeCard(
              title: 'Basic Usage',
              code: '''
final jar = CookieJar();
await jar.saveFromResponse(
  Uri.parse('https://pub.dev/'),
  <Cookie>[Cookie('name', 'wendux')..path = '/'],
);
final cookies = await jar.loadForRequest(
  Uri.parse('https://pub.dev/paths'),
);''',
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'In-Memory CookieJar',
              description:
                  'This mirrors the package README flow, but also shows path '
                  'scoping, domain cookies, expiry filtering, and deletion.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('ignoreExpires'),
                    subtitle: const Text(
                      'Keep expired cookies when saving and loading.',
                    ),
                    value: _ignoreExpires,
                    onChanged: _isBusy
                        ? null
                        : (bool value) {
                            setState(() {
                              _ignoreExpires = value;
                              _memoryJar = CookieJar(ignoreExpires: value);
                              _memoryHomeCookies = const <Cookie>[];
                              _memoryPathsCookies = const <Cookie>[];
                              _memoryStatus =
                                  'Recreated CookieJar(ignoreExpires: $value).';
                            });
                          },
                  ),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: <Widget>[
                      FilledButton.icon(
                        onPressed: _isBusy ? null : _saveToMemoryJar,
                        icon: const Icon(Icons.save_outlined),
                        label: const Text('Save Sample Cookies'),
                      ),
                      OutlinedButton.icon(
                        onPressed: _isBusy ? null : _deletePubDevCookies,
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('Delete pub.dev Cookies'),
                      ),
                      OutlinedButton.icon(
                        onPressed: _isBusy ? null : _clearMemoryJar,
                        icon: const Icon(Icons.layers_clear_outlined),
                        label: const Text('Clear Memory Jar'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(_memoryStatus),
                  const SizedBox(height: 14),
                  _CookieBucket(
                    title: 'loadForRequest(https://pub.dev/)',
                    cookies: _memoryHomeCookies,
                  ),
                  const SizedBox(height: 12),
                  _CookieBucket(
                    title: 'loadForRequest(https://pub.dev/paths/details)',
                    cookies: _memoryPathsCookies,
                  ),
                  const SizedBox(height: 12),
                  _TimelineCard(entries: _memoryTimeline),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'PersistCookieJar + FileStorage',
              description:
                  'This simulates an app restart by saving cookies with one jar '
                  'instance and loading them with a new one from the same storage path.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('persistSession'),
                    subtitle: const Text(
                      'When false, session cookies are not persisted to storage.',
                    ),
                    value: _persistSession,
                    onChanged: _isBusy
                        ? null
                        : (bool value) {
                            setState(() {
                              _persistSession = value;
                            });
                          },
                  ),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: <Widget>[
                      FilledButton.icon(
                        onPressed: _isBusy ? null : _runPersistDemo,
                        icon: const Icon(Icons.folder_open_outlined),
                        label: const Text('Run Persist Demo'),
                      ),
                      OutlinedButton.icon(
                        onPressed: _isBusy ? null : _clearPersistedCookies,
                        icon: const Icon(Icons.delete_sweep_outlined),
                        label: const Text('Clear Persisted Cookies'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(_persistStatus),
                  if (_persistPath != null) ...<Widget>[
                    const SizedBox(height: 12),
                    SelectableText(
                      'Storage path: $_persistPath',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                  const SizedBox(height: 12),
                  _CookieBucket(
                    title: 'Cookies reloaded from FileStorage',
                    cookies: _persistedCookies,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'SerializableCookie',
              description:
                  'The package wraps `Cookie` because the original type is not JSON serializable.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FilledButton.tonalIcon(
                    onPressed: _runSerializableCookieDemo,
                    icon: const Icon(Icons.code_outlined),
                    label: const Text('Serialize Cookie'),
                  ),
                  const SizedBox(height: 14),
                  Text(_serializationStatus),
                  if (_serializedCookie != null) ...<Widget>[
                    const SizedBox(height: 12),
                    _CodeBlock(label: 'toJson()', value: _serializedCookie!),
                  ],
                  if (_restoredCookie != null) ...<Widget>[
                    const SizedBox(height: 12),
                    _CodeBlock(
                      label: 'Restored Cookie',
                      value: _restoredCookie!,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Custom Storage',
              description:
                  'PersistCookieJar accepts any `Storage` implementation. This '
                  'example logs each storage operation into an in-memory map.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FilledButton.icon(
                    onPressed: _isBusy ? null : _runCustomStorageDemo,
                    icon: const Icon(Icons.storage_outlined),
                    label: const Text('Run Storage Demo'),
                  ),
                  const SizedBox(height: 14),
                  Text(_customStorageStatus),
                  const SizedBox(height: 12),
                  _CookieBucket(
                    title: 'Cookies loaded back from custom storage',
                    cookies: _customStorageCookies,
                  ),
                  const SizedBox(height: 12),
                  _CodeBlock(
                    label: 'Storage keys',
                    value: _debugStorage.values.keys.join(', '),
                  ),
                  const SizedBox(height: 12),
                  _TimelineCard(entries: _debugStorage.operations),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.secondaryContainer.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Integration Notes',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'The package works well with `HttpClient` directly, and it is commonly paired with Dio through `dio_cookie_manager` when requests should automatically send and store cookies.',
                  ),
                  const SizedBox(height: 12),
                  const _CodeCard(
                    title: 'HttpClient Pattern',
                    code: '''
request = await httpClient.openUrl(method, uri);
request.cookies.addAll(await cookieJar.loadForRequest(uri));
response = await request.close();
await cookieJar.saveFromResponse(uri, response.cookies);''',
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

class _SectionCard extends StatelessWidget {
  const _SectionCard({
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

class _CodeCard extends StatelessWidget {
  const _CodeCard({required this.title, required this.code});

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
            _CodeBlock(label: 'Example', value: code),
          ],
        ),
      ),
    );
  }
}

class _CodeBlock extends StatelessWidget {
  const _CodeBlock({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.56),
        borderRadius: BorderRadius.circular(14),
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
          const SizedBox(height: 8),
          SelectableText(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontFamily: 'monospace',
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _CookieBucket extends StatelessWidget {
  const _CookieBucket({required this.title, required this.cookies});

  final String title;
  final List<Cookie> cookies;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.38),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          if (cookies.isEmpty)
            Text(
              'No cookies returned.',
              style: Theme.of(context).textTheme.bodySmall,
            )
          else
            Column(
              children: cookies
                  .map((Cookie cookie) => _CookieTile(cookie: cookie))
                  .toList(growable: false),
            ),
        ],
      ),
    );
  }
}

class _CookieTile extends StatelessWidget {
  const _CookieTile({required this.cookie});

  final Cookie cookie;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      dense: true,
      leading: const Icon(Icons.cookie_outlined),
      title: Text('${cookie.name} = ${cookie.value}'),
      subtitle: Text(
        'domain: ${cookie.domain ?? '(host-only)'}  '
        'path: ${cookie.path ?? '/'}  '
        'expires: ${cookie.expires ?? '(session)'}',
      ),
    );
  }
}

class _TimelineCard extends StatelessWidget {
  const _TimelineCard({required this.entries});

  final List<String> entries;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Timeline',
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          if (entries.isEmpty)
            Text(
              'No log entries yet.',
              style: Theme.of(context).textTheme.bodySmall,
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: entries
                  .map(
                    (String entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(entry),
                    ),
                  )
                  .toList(growable: false),
            ),
        ],
      ),
    );
  }
}

class _DebugStorage implements Storage {
  final Map<String, String> values = <String, String>{};
  final List<String> operations = <String>[];

  bool? persistSession;
  bool? ignoreExpires;

  void reset() {
    values.clear();
    operations.clear();
    persistSession = null;
    ignoreExpires = null;
  }

  @override
  Future<void> delete(String key) async {
    operations.add('delete($key)');
    values.remove(key);
  }

  @override
  Future<void> deleteAll(List<String> keys) async {
    operations.add('deleteAll(${keys.join(', ')})');
    values.clear();
  }

  @override
  Future<void> init(bool persistSession, bool ignoreExpires) async {
    this.persistSession = persistSession;
    this.ignoreExpires = ignoreExpires;
    operations.add(
      'init(persistSession: $persistSession, ignoreExpires: $ignoreExpires)',
    );
  }

  @override
  Future<String?> read(String key) async {
    operations.add('read($key)');
    return values[key];
  }

  @override
  Future<void> write(String key, String value) async {
    operations.add('write($key)');
    values[key] = value;
  }
}
