import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/injectable_get_it_demo/injectable_get_it_demo.dart';
import 'package:widget_layout_example2/app_navigation.dart';

// ===== Code snippets shown in the UI ======================================

const String _approach1Snippet = '''
// Register ONE Dio with a default baseUrl.
getIt.registerSingleton<Dio>(
  Dio(BaseOptions(baseUrl: "https://api.myserver.com")),
  instanceName: 'approach1',
);

// Usage – relative path hits baseUrl:
await getIt<Dio>(instanceName: 'approach1').get('/user/profile');

// Usage – full URL bypasses baseUrl entirely:
await getIt<Dio>(instanceName: 'approach1')
    .get('https://api.other-service.com/data');
''';

const String _approach2Snippet = '''
dio.interceptors.add(InterceptorsWrapper(
  onRequest: (options, handler) {
    final uri = options.uri;
    if (uri.host.contains('myserver.com')) {
      options.headers['Authorization'] = 'Bearer \$token';
    }
    if (uri.host.contains('other-service.com')) {
      options.headers['X-Api-Key'] = 'third-party-key';
    }
    return handler.next(options);
  },
));
''';

const String _approach3Snippet = '''
// Main backend
getIt.registerSingleton<Dio>(
  Dio(BaseOptions(baseUrl: "https://api.myserver.com")),
  instanceName: 'approach3_main',
);

// Other service – completely independent config
getIt.registerSingleton<Dio>(
  Dio(BaseOptions(
    baseUrl: "https://api.other-service.com",
    connectTimeout: Duration(seconds: 30),
    headers: {'X-Api-Key': 'third-party-key'},
  )),
  instanceName: 'approach3_other',
);

// Resolve by name:
final mainDio  = getIt<Dio>(instanceName: 'approach3_main');
final otherDio = getIt<Dio>(instanceName: 'approach3_other');
''';

@RoutePage(name: RouteName.dioMultiUrl)
class DioMultiUrlPage extends StatefulWidget {
  const DioMultiUrlPage({super.key});

  @override
  State<DioMultiUrlPage> createState() => _DioMultiUrlPageState();
}

class _DioMultiUrlPageState extends State<DioMultiUrlPage> {
  late final AuthRepository _authRepository;

  @override
  void initState() {
    super.initState();
    configureInjectableGetItDemo();
    _authRepository = injectableGetIt<AuthRepository>();

    // Register all three demo Dio configurations.
    registerAllDioApproaches(tokenProvider: () => _authRepository.accessToken);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('dio + get_it Multi-URL Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            Text(
              'Three approaches for accessing multiple URLs with a single or '
              'multiple Dio instances managed by get_it.',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 24),

            // ===== Approach 1 =====
            _ApproachCard(
              number: 1,
              title: 'Dynamic Full-URL Override',
              subtitle: 'One Dio, pass full URL for external calls',
              pros: const <String>[
                'Minimal code and setup.',
                'Global interceptors (logging, retry) apply to every request.',
                'Connection pool reused for same-host requests.',
              ],
              cons: const <String>[
                'All hosts share the same interceptor stack.',
                'If headers/timeouts must differ, interceptor gets messy.',
                'No compile-time distinction between services.',
              ],
              snippet: _approach1Snippet,
            ),
            const SizedBox(height: 16),

            // ===== Approach 2 =====
            _ApproachCard(
              number: 2,
              title: 'Interceptor-Based URL Routing',
              subtitle: 'One Dio, branch logic per host in interceptor',
              pros: const <String>[
                'All per-host rules live in one interceptor – easy to audit.',
                'Still only one Dio registration in get_it.',
              ],
              cons: const <String>[
                'Interceptor becomes a "god object" as hosts grow.',
                'Harder to unit-test host-specific behaviour in isolation.',
                'Runtime branching instead of compile-time separation.',
              ],
              snippet: _approach2Snippet,
            ),
            const SizedBox(height: 16),

            // ===== Approach 3 =====
            _ApproachCard(
              number: 3,
              title: 'Multiple Named Instances',
              subtitle: 'N Dio instances, one per service',
              pros: const <String>[
                'Full isolation – changing one service cannot break another.',
                'Each Dio has exactly the interceptors it needs.',
                'Easier to mock / replace in tests via get_it overrides.',
              ],
              cons: const <String>[
                'More registrations and slightly more boilerplate.',
                'Callers must remember (or typedef) the instanceName string.',
                'Common logic (logging) must be added to every instance.',
              ],
              snippet: _approach3Snippet,
            ),
            const SizedBox(height: 16),

            // ===== Comparison table =====
            _ComparisonTable(),
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

// ===== Reusable widgets ===================================================

class _ApproachCard extends StatelessWidget {
  const _ApproachCard({
    required this.number,
    required this.title,
    required this.subtitle,
    required this.pros,
    required this.cons,
    required this.snippet,
  });

  final int number;
  final String title;
  final String subtitle;
  final List<String> pros;
  final List<String> cons;
  final String snippet;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                CircleAvatar(radius: 16, child: Text('$number')),
                const SizedBox(width: 12),
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
                      Text(subtitle, style: theme.textTheme.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Pros
            Text(
              'Pros',
              style: theme.textTheme.labelLarge?.copyWith(
                color: Colors.green.shade700,
              ),
            ),
            const SizedBox(height: 4),
            for (final String pro in pros)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Icon(
                      Icons.check_circle,
                      size: 16,
                      color: Colors.green.shade600,
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Text(pro)),
                  ],
                ),
              ),

            const SizedBox(height: 12),

            // Cons
            Text(
              'Cons',
              style: theme.textTheme.labelLarge?.copyWith(
                color: Colors.red.shade700,
              ),
            ),
            const SizedBox(height: 4),
            for (final String con in cons)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Icon(Icons.cancel, size: 16, color: Colors.red.shade400),
                    const SizedBox(width: 8),
                    Expanded(child: Text(con)),
                  ],
                ),
              ),

            const SizedBox(height: 12),

            // Code snippet
            DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xFF111827),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SelectableText(
                  snippet,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'monospace',
                    fontSize: 12,
                    height: 1.45,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ComparisonTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Comparison Summary',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Table(
              border: TableBorder.all(
                color: theme.dividerColor,
                borderRadius: BorderRadius.circular(8),
              ),
              columnWidths: const <int, TableColumnWidth>{
                0: FixedColumnWidth(80),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(1),
                3: FlexColumnWidth(1),
              },
              children: <TableRow>[
                _headerRow(theme),
                _dataRow(
                  theme,
                  approach: '1',
                  instances: '1',
                  bestWhen: 'Rarely call external URL',
                  tradeOff: 'Shared interceptors may not suit every host',
                ),
                _dataRow(
                  theme,
                  approach: '2',
                  instances: '1',
                  bestWhen: 'Multiple hosts need different headers',
                  tradeOff: 'Interceptor grows linearly with host count',
                ),
                _dataRow(
                  theme,
                  approach: '3',
                  instances: 'N',
                  bestWhen: 'Services have very different configs',
                  tradeOff: 'More boilerplate; caller needs instanceName',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TableRow _headerRow(ThemeData theme) {
    Widget cell(String text) {
      return Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
          text,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }

    return TableRow(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
      ),
      children: <Widget>[
        cell('Approach'),
        cell('Instances'),
        cell('Best When'),
        cell('Trade-off'),
      ],
    );
  }

  TableRow _dataRow(
    ThemeData theme, {
    required String approach,
    required String instances,
    required String bestWhen,
    required String tradeOff,
  }) {
    Widget cell(String text) {
      return Padding(
        padding: const EdgeInsets.all(8),
        child: Text(text, style: theme.textTheme.bodySmall),
      );
    }

    return TableRow(
      children: <Widget>[
        cell(approach),
        cell(instances),
        cell(bestWhen),
        cell(tradeOff),
      ],
    );
  }
}
