import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/injectable_get_it_demo/injectable_get_it_demo.dart';

const String _bootstrapSnippet = '''
final injectableGetIt = GetIt.instance;

@InjectableInit(
  initializerName: 'initInjectableGetItDemo',
  asExtension: true,
)
void configureInjectableGetItDemo() {
  if (injectableGetIt.isRegistered<AuthRepository>()) {
    return;
  }

  injectableGetIt.initInjectableGetItDemo();
}
''';

const String _repositorySnippet = '''
abstract interface class AuthRepository {
  String get currentUsername;
}

@LazySingleton(as: AuthRepository)
class DemoAuthRepository implements AuthRepository {
  @override
  String get currentUsername => 'injectable_user';
}
''';

const String _autoModuleSnippet = '''
@injectable
class AutoSessionModule {
  AutoSessionModule(this.authRepository);

  final AuthRepository authRepository;
}
''';

@RoutePage(name: 'InjectableGetItRoute')
class InjectableGetItPage extends StatefulWidget {
  const InjectableGetItPage({super.key});

  @override
  State<InjectableGetItPage> createState() => _InjectableGetItPageState();
}

class _InjectableGetItPageState extends State<InjectableGetItPage> {
  late final AuthRepository _authRepository;
  late final AutoSessionModule _autoSessionModule;

  @override
  void initState() {
    super.initState();
    configureInjectableGetItDemo();
    _authRepository = injectableGetIt<AuthRepository>();
    _autoSessionModule = injectableGetIt<AutoSessionModule>();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String createdAt = _authRepository.createdAt.toIso8601String();

    return Scaffold(
      appBar: AppBar(title: const Text('injectable + get_it Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            Text(
              'This module uses generated `injectable` wiring on top of the shared `GetIt.instance` locator.',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'The first registration binds an implementation to the `AuthRepository` interface with `@LazySingleton(as: AuthRepository)`. The second class is resolved automatically from the same locator just by asking for it.',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            const _DemoCard(
              title: 'Bootstrap',
              description:
                  'Run the generated initializer once, then keep using the same global GetIt instance.',
              child: _CodeSnippet(snippet: _bootstrapSnippet),
            ),
            const SizedBox(height: 16),
            const _DemoCard(
              title: 'Interface Binding',
              description:
                  'The implementation is registered as the base interface, not as the concrete class.',
              child: _CodeSnippet(snippet: _repositorySnippet),
            ),
            const SizedBox(height: 16),
            _DemoCard(
              title: 'Resolved Result',
              description:
                  'The page resolves `AuthRepository` directly from GetIt and shows the lazy singleton state.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _FactRow(
                    label: 'Runtime type',
                    value: _authRepository.runtimeType.toString(),
                  ),
                  _FactRow(
                    label: 'Username',
                    value: _authRepository.currentUsername,
                  ),
                  _FactRow(
                    label: 'Access token',
                    value: _authRepository.accessToken,
                  ),
                  _FactRow(label: 'Created at', value: createdAt),
                  _FactRow(
                    label: 'Singleton hash',
                    value: _authRepository.hashCode.toString(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const _DemoCard(
              title: 'Auto-Resolved Dependent Module',
              description:
                  'This second module has no manual binding declaration. Injectable sees the constructor, grabs the same `AuthRepository` from GetIt, and builds it automatically.',
              child: _CodeSnippet(snippet: _autoModuleSnippet),
            ),
            const SizedBox(height: 16),
            _DemoCard(
              title: 'Second Module Output',
              description:
                  'The repository hash below matches the singleton hash above, which proves both modules use the same GetIt registration.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    _autoSessionModule.headline,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(_autoSessionModule.summary),
                  const SizedBox(height: 12),
                  _FactRow(
                    label: 'Injected repository hash',
                    value: _autoSessionModule.repositoryIdentity.toString(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DemoCard extends StatelessWidget {
  const _DemoCard({
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
            height: 1.45,
          ),
        ),
      ),
    );
  }
}

class _FactRow extends StatelessWidget {
  const _FactRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 152,
            child: Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
