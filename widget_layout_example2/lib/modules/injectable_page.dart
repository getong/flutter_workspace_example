import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

const String _injectableSetupSnippet = '''
final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async => getIt.init();

@lazySingleton
class ApiClient {
  ApiClient() : createdAt = DateTime.now();

  final DateTime createdAt;
}

@injectable
class SessionRepository {
  SessionRepository(this.apiClient);

  final ApiClient apiClient;
}
''';

const String _injectableFlowSnippet = '''
@injectable
class DashboardViewModel {
  DashboardViewModel(this.repository, this.analytics);

  final DashboardRepository repository;
  final AnalyticsService analytics;

  Future<void> load() async {
    await repository.fetchCards();
    analytics.track('dashboard_opened');
  }
}
''';

@RoutePage()
class InjectablePage extends StatefulWidget {
  const InjectablePage({super.key});

  @override
  State<InjectablePage> createState() => _InjectablePageState();
}

class _InjectablePageState extends State<InjectablePage> {
  final _InjectablePreviewContainer _container = _InjectablePreviewContainer();
  final List<_DraftSessionController> _factoryControllers =
      <_DraftSessionController>[];

  bool _useProduction = false;

  @override
  void initState() {
    super.initState();
    _factoryControllers.add(_container.newDraftController());
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final _InjectableScreenModel screenModel = _container.buildScreenModel(
      useProduction: _useProduction,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Injectable Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            Text(
              'The `injectable` package helps you describe dependency '
              'relationships with annotations and generate the wiring code with '
              '`build_runner`.',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'This module shows practical `injectable` usage in Flutter: '
              'constructor injection, lazy singletons, factory-style objects, '
              'and swapping implementations for different environments.',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            const _InjectableCard(
              title: 'Bootstrapping Your Container',
              description:
                  'Annotate services and repositories, then let `build_runner` generate the registration code.',
              child: _CodeSnippet(snippet: _injectableSetupSnippet),
            ),
            const SizedBox(height: 16),
            _InjectableCard(
              title: 'Constructor Injection Graph',
              description:
                  'A view model receives its collaborators through the constructor, which keeps classes focused and testable.',
              child: _DependencyGraph(screenModel: screenModel),
            ),
            const SizedBox(height: 16),
            _InjectableCard(
              title: 'Lazy Singleton',
              description:
                  'Use `@lazySingleton` when a shared service should be created only when the app first needs it.',
              child: _LazySingletonPreview(
                analyticsService: _container.analyticsService,
              ),
            ),
            const SizedBox(height: 16),
            _InjectableCard(
              title: 'Factory-Style Objects',
              description:
                  'Temporary screen state often behaves like a factory so each request gets a fresh object.',
              child: _FactoryPreview(
                controllers: _factoryControllers,
                onAddController: _addDraftController,
              ),
            ),
            const SizedBox(height: 16),
            _InjectableCard(
              title: 'Environment-Specific Bindings',
              description:
                  'The container can swap implementations depending on whether the app targets mock, staging, or production infrastructure.',
              child: _EnvironmentPreview(
                useProduction: _useProduction,
                onChanged: (bool value) {
                  setState(() {
                    _useProduction = value;
                  });
                },
                dataSourceName: screenModel.dataSourceName,
                baseUrl: screenModel.baseUrl,
                cardTitles: screenModel.cardTitles,
              ),
            ),
            const SizedBox(height: 16),
            const _InjectableCard(
              title: 'ViewModel Example',
              description:
                  'After registration, the feature code stays small because the container assembles the dependency graph for you.',
              child: _CodeSnippet(snippet: _injectableFlowSnippet),
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

  void _addDraftController() {
    setState(() {
      _factoryControllers.insert(0, _container.newDraftController());
    });
  }
}

class _InjectableCard extends StatelessWidget {
  const _InjectableCard({
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

class _CodeSnippet extends StatelessWidget {
  const _CodeSnippet({required this.snippet});

  final String snippet;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SelectableText(
          snippet,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'monospace',
            height: 1.45,
          ),
        ),
      ),
    );
  }
}

class _DependencyGraph extends StatelessWidget {
  const _DependencyGraph({required this.screenModel});

  final _InjectableScreenModel screenModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const _DependencyNode(
          title: 'DashboardViewModel',
          subtitle: 'Depends on repository + analytics service',
          color: Colors.indigo,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Icon(Icons.arrow_downward_rounded),
        ),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: <Widget>[
            _DependencyNode(
              title: 'DashboardRepository',
              subtitle: screenModel.dataSourceName,
              color: Colors.teal,
            ),
            const _DependencyNode(
              title: 'AnalyticsService',
              subtitle: 'Shared lazy singleton',
              color: Colors.orange,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blueGrey.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Text(
            'Resolved cards: ${screenModel.cardTitles.join(' • ')}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}

class _DependencyNode extends StatelessWidget {
  const _DependencyNode({
    required this.title,
    required this.subtitle,
    required this.color,
  });

  final String title;
  final String subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 220),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 6),
          Text(subtitle),
        ],
      ),
    );
  }
}

class _LazySingletonPreview extends StatefulWidget {
  const _LazySingletonPreview({required this.analyticsService});

  final _InjectableAnalyticsService analyticsService;

  @override
  State<_LazySingletonPreview> createState() => _LazySingletonPreviewState();
}

class _LazySingletonPreviewState extends State<_LazySingletonPreview> {
  int _tapCount = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        FilledButton.icon(
          onPressed: () {
            setState(() {
              _tapCount += 1;
            });
            widget.analyticsService.track('injectable_demo_opened_$_tapCount');
          },
          icon: const Icon(Icons.analytics_outlined),
          label: const Text('Use analytics service'),
        ),
        const SizedBox(height: 12),
        Text('Instances created: ${_InjectableAnalyticsService.createdCount}'),
        Text('Events tracked: ${widget.analyticsService.trackedEvents.length}'),
        const SizedBox(height: 12),
        Text(
          widget.analyticsService.trackedEvents.isEmpty
              ? 'No analytics event tracked yet.'
              : widget.analyticsService.trackedEvents.join('\n'),
        ),
      ],
    );
  }
}

class _FactoryPreview extends StatelessWidget {
  const _FactoryPreview({
    required this.controllers,
    required this.onAddController,
  });

  final List<_DraftSessionController> controllers;
  final VoidCallback onAddController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        FilledButton.icon(
          onPressed: onAddController,
          icon: const Icon(Icons.add_circle_outline),
          label: const Text('Create another controller'),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: controllers.map((controller) {
            return Container(
              width: 200,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.deepPurple.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: Colors.deepPurple.withValues(alpha: 0.28),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    controller.name,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('id: ${controller.id}'),
                  Text('created: ${controller.createdAtLabel}'),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _EnvironmentPreview extends StatelessWidget {
  const _EnvironmentPreview({
    required this.useProduction,
    required this.onChanged,
    required this.dataSourceName,
    required this.baseUrl,
    required this.cardTitles,
  });

  final bool useProduction;
  final ValueChanged<bool> onChanged;
  final String dataSourceName;
  final String baseUrl;
  final List<String> cardTitles;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Use production binding'),
          subtitle: Text(
            useProduction
                ? 'Container resolves the live data source.'
                : 'Container resolves the mock development data source.',
          ),
          value: useProduction,
          onChanged: onChanged,
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Resolved binding: $dataSourceName',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text('Base URL: $baseUrl'),
              const SizedBox(height: 8),
              Text('Cards: ${cardTitles.join(', ')}'),
            ],
          ),
        ),
      ],
    );
  }
}

@lazySingleton
class _InjectableAnalyticsService {
  _InjectableAnalyticsService() {
    createdCount += 1;
  }

  static int createdCount = 0;

  final List<String> trackedEvents = <String>[];

  void track(String event) {
    trackedEvents.add(event);
  }
}

@injectable
class _DraftSessionController {
  _DraftSessionController(this.id, this.createdAtLabel);

  final int id;
  final String createdAtLabel;

  String get name => 'Draft Controller';
}

class _InjectablePreviewContainer {
  _InjectablePreviewContainer()
    : analyticsService = _InjectableAnalyticsService();

  final _InjectableAnalyticsService analyticsService;

  _DraftSessionController newDraftController() {
    final DateTime now = DateTime.now();
    return _DraftSessionController(
      now.microsecondsSinceEpoch,
      _formatTime(now),
    );
  }

  _InjectableScreenModel buildScreenModel({required bool useProduction}) {
    final _DashboardDataSource dataSource = useProduction
        ? _ProductionDashboardDataSource()
        : _DevelopmentDashboardDataSource();
    final _DashboardRepository repository = _DashboardRepository(dataSource);
    final _DashboardViewModel viewModel = _DashboardViewModel(
      repository,
      analyticsService,
    );
    return _InjectableScreenModel(
      dataSourceName: dataSource.name,
      baseUrl: dataSource.baseUrl,
      cardTitles: viewModel.loadCards(),
    );
  }

  String _formatTime(DateTime dateTime) {
    final String hour = dateTime.hour.toString().padLeft(2, '0');
    final String minute = dateTime.minute.toString().padLeft(2, '0');
    final String second = dateTime.second.toString().padLeft(2, '0');
    return '$hour:$minute:$second';
  }
}

class _InjectableScreenModel {
  const _InjectableScreenModel({
    required this.dataSourceName,
    required this.baseUrl,
    required this.cardTitles,
  });

  final String dataSourceName;
  final String baseUrl;
  final List<String> cardTitles;
}

abstract class _DashboardDataSource {
  String get name;
  String get baseUrl;

  List<String> fetchCards();
}

class _DevelopmentDashboardDataSource implements _DashboardDataSource {
  @override
  String get name => 'DevelopmentDashboardDataSource';

  @override
  String get baseUrl => 'https://dev.api.example.com';

  @override
  List<String> fetchCards() => const <String>[
    'Local Banner',
    'Seeded Stats',
    'Preview Tasks',
  ];
}

class _ProductionDashboardDataSource implements _DashboardDataSource {
  @override
  String get name => 'ProductionDashboardDataSource';

  @override
  String get baseUrl => 'https://api.example.com';

  @override
  List<String> fetchCards() => const <String>[
    'Revenue Summary',
    'Active Users',
    'Retention Trend',
  ];
}

@injectable
class _DashboardRepository {
  const _DashboardRepository(this.dataSource);

  final _DashboardDataSource dataSource;

  List<String> fetchCards() => dataSource.fetchCards();
}

@injectable
class _DashboardViewModel {
  const _DashboardViewModel(this.repository, this.analytics);

  final _DashboardRepository repository;
  final _InjectableAnalyticsService analytics;

  List<String> loadCards() => repository.fetchCards();
}
