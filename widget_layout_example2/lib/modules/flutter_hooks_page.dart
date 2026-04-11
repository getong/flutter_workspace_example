import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

@RoutePage(name: 'FlutterHooksRoute')
class FlutterHooksPage extends StatelessWidget {
  const FlutterHooksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('flutter_hooks Module')),
      body: const SelectionArea(child: _FlutterHooksPlayground()),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.router.replacePath('/'),
        icon: const Icon(Icons.home),
        label: const Text('Home'),
      ),
    );
  }
}

class _FlutterHooksPlayground extends HookWidget {
  const _FlutterHooksPlayground();

  static const List<String> _catalog = <String>[
    'HookWidget',
    'HookBuilder',
    'useState',
    'useTextEditingController',
    'useListenable',
    'useMemoized',
    'useEffect',
    'useAnimationController',
  ];

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ValueNotifier<int> counter = useState<int>(0);
    final ValueNotifier<int> step = useState<int>(1);
    final ValueNotifier<String> status = useState<String>(
      'Use the controls below to see hooks update local UI state.',
    );
    final TextEditingController controller = useTextEditingController(
      text: 'hook',
    );
    useListenable(controller);

    final String query = controller.text.trim().toLowerCase();
    final List<String> filteredCatalog = useMemoized(
      () => _catalog
          .where((String item) => item.toLowerCase().contains(query))
          .toList(),
      <Object>[query],
    );

    final AnimationController pulseController = useAnimationController(
      duration: const Duration(milliseconds: 360),
    );
    final Animation<double> pulse = Tween<double>(begin: 1, end: 1.06).animate(
      CurvedAnimation(parent: pulseController, curve: Curves.easeOutBack),
    );

    useEffect(() {
      pulseController.forward(from: 0);
      return null;
    }, <Object>[counter.value, step.value]);

    return ListView(
      padding: const EdgeInsets.all(24),
      children: <Widget>[
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Build local state, controller wiring, and animation lifecycles without a StatefulWidget.',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'This module demonstrates `HookWidget`, `HookBuilder`, `useState`, '
                  '`useTextEditingController`, `useListenable`, `useMemoized`, '
                  '`useEffect`, and `useAnimationController`.',
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _catalog
                      .map((String item) => Chip(label: Text(item)))
                      .toList(),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Interactive Hook Playground',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    labelText: 'Filter the hook catalog',
                    hintText: 'Type "state", "effect", or "animation"',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: <Widget>[
                    ChoiceChip(
                      label: const Text('Step 1'),
                      selected: step.value == 1,
                      onSelected: (_) {
                        step.value = 1;
                        status.value = 'Increment step changed to 1.';
                      },
                    ),
                    ChoiceChip(
                      label: const Text('Step 2'),
                      selected: step.value == 2,
                      onSelected: (_) {
                        step.value = 2;
                        status.value = 'Increment step changed to 2.';
                      },
                    ),
                    ChoiceChip(
                      label: const Text('Step 3'),
                      selected: step.value == 3,
                      onSelected: (_) {
                        step.value = 3;
                        status.value = 'Increment step changed to 3.';
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ScaleTransition(
                  scale: pulse,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDBEAFE),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Counter: ${counter.value}',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('Status: ${status.value}'),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: <Widget>[
                            FilledButton.icon(
                              onPressed: () {
                                counter.value += step.value;
                                status.value =
                                    'Counter changed with useState and animated with useEffect.';
                              },
                              icon: const Icon(Icons.add),
                              label: const Text('Add'),
                            ),
                            OutlinedButton.icon(
                              onPressed: counter.value == 0
                                  ? null
                                  : () {
                                      counter.value = 0;
                                      status.value =
                                          'Counter reset to zero using local hook state.';
                                    },
                              icon: const Icon(Icons.replay),
                              label: const Text('Reset'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: filteredCatalog
                      .map((String item) => Chip(label: Text(item)))
                      .toList(),
                ),
                if (filteredCatalog.isEmpty) ...<Widget>[
                  const SizedBox(height: 12),
                  Text(
                    'No hooks matched the current filter. That result is cached with `useMemoized` until the query changes.',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Nested HookBuilder',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'HookBuilder is useful when only a small part of the tree needs hook state.',
                ),
                const SizedBox(height: 16),
                HookBuilder(
                  builder: (BuildContext context) {
                    final ValueNotifier<bool> expanded = useState<bool>(false);
                    final ValueNotifier<Color> swatch = useState<Color>(
                      const Color(0xFF0F766E),
                    );

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: <Widget>[
                            FilledButton.tonalIcon(
                              onPressed: () {
                                expanded.value = !expanded.value;
                              },
                              icon: Icon(
                                expanded.value
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                              ),
                              label: Text(
                                expanded.value
                                    ? 'Hide Details'
                                    : 'Show Details',
                              ),
                            ),
                            OutlinedButton.icon(
                              onPressed: () {
                                swatch.value =
                                    swatch.value == const Color(0xFF0F766E)
                                    ? const Color(0xFFB45309)
                                    : const Color(0xFF0F766E);
                              },
                              icon: const Icon(Icons.palette_outlined),
                              label: const Text('Swap Color'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 240),
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: swatch.value.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: swatch.value),
                          ),
                          child: Text(
                            expanded.value
                                ? 'This inner section owns its own hook state without introducing another StatefulWidget.'
                                : 'Tap Show Details to expand this HookBuilder section.',
                            style: TextStyle(
                              color: swatch.value,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _HooksCodeCard(
          title: 'Core flutter_hooks Pattern',
          code: r'''
class CounterPanel extends HookWidget {
  const CounterPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<int> count = useState<int>(0);
    final TextEditingController controller = useTextEditingController();
    useListenable(controller);

    final List<String> results = useMemoized(
      () => source.where((item) => item.contains(controller.text)).toList(),
      <Object>[controller.text],
    );

    final AnimationController animationController =
        useAnimationController(duration: const Duration(milliseconds: 300));

    useEffect(() {
      animationController.forward(from: 0);
      return null;
    }, <Object>[count.value]);

    return Text('count=${count.value}, matches=${results.length}');
  }
}
''',
        ),
      ],
    );
  }
}

class _HooksCodeCard extends StatelessWidget {
  const _HooksCodeCard({required this.title, required this.code});

  final String title;
  final String code;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            SelectableText(
              code,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontFamily: 'monospace',
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
