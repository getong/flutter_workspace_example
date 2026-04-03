import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/app_router.dart';

@RoutePage(name: 'AutoRouteUsageRoute')
class AutoRouteUsagePage extends StatelessWidget {
  const AutoRouteUsagePage({super.key});

  @override
  Widget build(BuildContext context) {
    final StackRouter router = context.router;

    return Scaffold(
      appBar: AppBar(title: const Text('auto_route Module')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: <Widget>[
          const Text(
            'This page explains how to use auto_route in this project. The snippets use the real route classes and paths from this app, and the buttons below trigger the same APIs so you can see how the stack behaves.',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 24),
          const _SectionHeader(
            title: '1. Get the router',
            subtitle:
                'Use the scoped router from the current BuildContext. context.router is usually the shortest form.',
          ),
          const SizedBox(height: 12),
          const _CodeCard(
            title: 'Accessing StackRouter',
            code: '''
final StackRouter router = AutoRouter.of(context);

// shorter extension
final StackRouter router = context.router;
''',
          ),
          const SizedBox(height: 24),
          const _SectionHeader(
            title: '2. push, replace, navigate',
            subtitle:
                'These three APIs sound similar, but they behave differently on the stack.',
          ),
          const SizedBox(height: 12),
          const _InfoCard(
            title: 'push',
            description:
                'Adds a new page on top of the current stack. Use this for normal forward navigation.',
          ),
          const SizedBox(height: 12),
          const _CodeCard(
            title: 'Generated route objects',
            code: '''
router.push(const PaddingRoute());
context.pushRoute(const PaddingRoute());
''',
          ),
          const SizedBox(height: 12),
          const _CodeCard(
            title: 'Path-based push',
            code: '''
router.pushPath('/padding-page');
''',
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: <Widget>[
              FilledButton.icon(
                onPressed: () => router.push(const PaddingRoute()),
                icon: const Icon(Icons.open_in_new),
                label: const Text('Push Padding'),
              ),
              OutlinedButton.icon(
                onPressed: () => router.pushPath('/padding-page'),
                icon: const Icon(Icons.route),
                label: const Text('Push Path'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const _InfoCard(
            title: 'replace',
            description:
                'Removes the current top route and inserts a new one. Use this when the old screen should not stay in back history.',
          ),
          const SizedBox(height: 12),
          const _CodeCard(
            title: 'Replace current page',
            code: '''
router.replace(const FutureBuilderRoute());
router.replacePath('/future-builder-page');
''',
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: <Widget>[
              FilledButton.icon(
                onPressed: () => router.replace(const FutureBuilderRoute()),
                icon: const Icon(Icons.swap_horizontal_circle_outlined),
                label: const Text('Replace FutureBuilder'),
              ),
              OutlinedButton.icon(
                onPressed: () => router.replacePath('/future-builder-page'),
                icon: const Icon(Icons.alt_route),
                label: const Text('Replace Path'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const _InfoCard(
            title: 'navigate',
            description:
                'If the route is already in the stack, auto_route pops back to it. Otherwise it pushes it. This is useful for web-style navigation.',
          ),
          const SizedBox(height: 12),
          const _CodeCard(
            title: 'Navigate to an existing or new route',
            code: '''
router.navigate(const StreamBuilderRoute());
router.navigatePath('/stream-builder-page');
context.navigateTo(const StreamBuilderRoute());
''',
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: <Widget>[
              FilledButton.icon(
                onPressed: () => router.navigate(const StreamBuilderRoute()),
                icon: const Icon(Icons.navigation_outlined),
                label: const Text('Navigate StreamBuilder'),
              ),
              OutlinedButton.icon(
                onPressed: () => router.navigatePath('/stream-builder-page'),
                icon: const Icon(Icons.explore_outlined),
                label: const Text('Navigate Path'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const _SectionHeader(
            title: '3. Push or replace multiple routes',
            subtitle:
                'Use these when you want to build or reset the stack in one call.',
          ),
          const SizedBox(height: 12),
          const _CodeCard(
            title: 'pushAll',
            code: '''
router.pushAll(const <PageRouteInfo>[
  PaddingRoute(),
  FutureBuilderRoute(),
]);
''',
          ),
          const SizedBox(height: 12),
          const _CodeCard(
            title: 'replaceAll',
            code: '''
router.replaceAll(const <PageRouteInfo>[
  HomeRoute(children: <PageRouteInfo>[
    ContentTabRoute(),
  ]),
]);
''',
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: <Widget>[
              FilledButton.icon(
                onPressed: () {
                  router.pushAll(const <PageRouteInfo>[
                    PaddingRoute(),
                    FutureBuilderRoute(),
                  ]);
                },
                icon: const Icon(Icons.layers_outlined),
                label: const Text('PushAll Demo'),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  router.replaceAll(const <PageRouteInfo>[
                    HomeRoute(children: <PageRouteInfo>[ContentTabRoute()]),
                  ]);
                },
                icon: const Icon(Icons.restart_alt),
                label: const Text('ReplaceAll Home'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const _SectionHeader(
            title: '4. Pop and back helpers',
            subtitle:
                'Use these for going back, guarded pops, and popping until a known route.',
          ),
          const SizedBox(height: 12),
          const _CodeCard(
            title: 'Common pop APIs',
            code: '''
context.router.pop();
context.router.popTop();
context.router.maybePop();
context.router.maybePopTop();
context.router.back();
''',
          ),
          const SizedBox(height: 12),
          const _CodeCard(
            title: 'Pop until a route',
            code: '''
context.router.popUntilRouteWithName(HomeRoute.name);
context.router.popUntilRouteWithPath('/');
context.router.popUntilRoot();
''',
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: <Widget>[
              FilledButton.icon(
                onPressed: () => router.maybePop(),
                icon: const Icon(Icons.arrow_back),
                label: const Text('maybePop'),
              ),
              OutlinedButton.icon(
                onPressed: () => router.popUntilRouteWithName(HomeRoute.name),
                icon: const Icon(Icons.home_outlined),
                label: const Text('Pop Until Home'),
              ),
              OutlinedButton.icon(
                onPressed: () => router.popUntilRoot(),
                icon: const Icon(Icons.vertical_align_bottom),
                label: const Text('Pop Until Root'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const _SectionHeader(
            title: '5. Practical advice',
            subtitle:
                'Prefer generated routes when possible because they are typed and safer during refactors.',
          ),
          const SizedBox(height: 12),
          const _InfoCard(
            title: 'Recommended pattern',
            description:
                'Use generated route classes such as PaddingRoute or FutureBuilderRoute for app code. Keep path-based navigation for deep links, manual URL entry, or quick experiments.',
          ),
          const SizedBox(height: 12),
          const _CodeCard(
            title: 'Example from this app',
            code: '''
// preferred
context.pushRoute(const AutoRouteUsageRoute());

// also valid
context.router.pushPath('/auto-route-page');
''',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.router.replacePath('/'),
        icon: const Icon(Icons.home),
        label: const Text('Home'),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text(subtitle),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
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
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: SelectionArea(
                child: Text(
                  code.trim(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontFamily: 'monospace',
                    height: 1.5,
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
