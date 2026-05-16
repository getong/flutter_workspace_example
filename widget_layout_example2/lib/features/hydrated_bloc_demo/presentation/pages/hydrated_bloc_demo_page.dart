import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';
import 'package:widget_layout_example2/features/hydrated_bloc_demo/presentation/bloc/hydrated_todo_bloc.dart';
import 'package:widget_layout_example2/features/hydrated_bloc_demo/presentation/bloc/hydrated_todo_event.dart';
import 'package:widget_layout_example2/features/hydrated_bloc_demo/presentation/bloc/hydrated_todo_state.dart';

@RoutePage(name: RouteName.hydratedBlocDemo)
class HydratedBlocDemoPage extends StatefulWidget {
  const HydratedBlocDemoPage({super.key});

  @override
  State<HydratedBlocDemoPage> createState() => _HydratedBlocDemoPageState();
}

class _HydratedBlocDemoPageState extends State<HydratedBlocDemoPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    final HydratedTodoBloc bloc = context.read<HydratedTodoBloc>();
    if (bloc.state.draft.isNotEmpty) {
      _controller.text = bloc.state.draft;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HydratedTodoBloc, HydratedTodoState>(
      listenWhen: (HydratedTodoState previous, HydratedTodoState current) =>
          previous.draft != current.draft,
      listener: (BuildContext context, HydratedTodoState state) {
        if (_controller.text != state.draft) {
          _controller.text = state.draft;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('HydratedBloc Demo'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              tooltip: 'Clear all',
              onPressed: () {
                context.read<HydratedTodoBloc>().add(const TodosCleared());
                _controller.clear();
              },
            ),
          ],
        ),
        body: BlocBuilder<HydratedTodoBloc, HydratedTodoState>(
          builder: (BuildContext context, HydratedTodoState state) {
            return ListView(
              padding: const EdgeInsets.all(24),
              children: <Widget>[
                Text(
                  'HydratedBloc automatically serializes bloc state to disk '
                  'via fromJson / toJson and restores it on app restart. '
                  'Add items below, then kill and reopen the app — '
                  'they will still be here.',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'New todo item',
                          hintText: 'Type something...',
                        ),
                        onChanged: (String value) {
                          context.read<HydratedTodoBloc>().add(
                            DraftChanged(draft: value),
                          );
                        },
                        onSubmitted: (_) {
                          context.read<HydratedTodoBloc>().add(
                            const TodoAdded(),
                          );
                          _controller.clear();
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    FilledButton(
                      onPressed: () {
                        context.read<HydratedTodoBloc>().add(const TodoAdded());
                        _controller.clear();
                      },
                      child: const Text('Add'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                if (state.items.isEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Center(
                        child: Text(
                          'No items yet. Add one above!',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ),
                  )
                else
                  ...List.generate(state.items.length, (int i) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Text(state.items[i].text),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () {
                            context.read<HydratedTodoBloc>().add(
                              TodoRemoved(index: i),
                            );
                          },
                        ),
                      ),
                    );
                  }),
                const SizedBox(height: 32),
                Card(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'How HydratedBloc works',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 8),
                        _InfoRow(
                          label: 'extends',
                          detail: 'HydratedBloc<Event, State> instead of Bloc',
                        ),
                        _InfoRow(
                          label: 'fromJson',
                          detail: 'Deserializes saved state on bloc creation',
                        ),
                        _InfoRow(
                          label: 'toJson',
                          detail: 'Auto-serializes on every state change',
                        ),
                        _InfoRow(
                          label: 'Storage',
                          detail:
                              'File system / SharedPreferences / '
                              'localStorage (auto-detected)',
                        ),
                        _InfoRow(
                          label: 'Restart test',
                          detail:
                              'Add items, close app, reopen — '
                              'data survives!',
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Items: ${state.items.length}, '
                          'Draft: "${state.draft.isEmpty ? '(empty)' : state.draft}"',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => context.router.replacePath('/'),
          icon: const Icon(Icons.home),
          label: const Text('Home'),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.detail});

  final String label;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(detail)),
        ],
      ),
    );
  }
}
