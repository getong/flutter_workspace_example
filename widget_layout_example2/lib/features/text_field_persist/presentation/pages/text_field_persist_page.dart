import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:widget_layout_example2/app_navigation.dart';
import 'package:widget_layout_example2/features/text_field_persist/presentation/bloc/text_persistence_bloc.dart';
import 'package:widget_layout_example2/features/text_field_persist/presentation/bloc/text_persistence_event.dart';
import 'package:widget_layout_example2/features/text_field_persist/presentation/bloc/text_persistence_state.dart';

@RoutePage(name: RouteName.textFieldPersist)
class TextFieldPersistPage extends StatefulWidget {
  const TextFieldPersistPage({super.key});

  @override
  State<TextFieldPersistPage> createState() => _TextFieldPersistPageState();
}

class _TextFieldPersistPageState extends State<TextFieldPersistPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    final TextPersistenceBloc bloc = context.read<TextPersistenceBloc>();
    if (bloc.state.isLoaded) {
      _controller.text = bloc.state.textOrEmpty;
    }
    bloc.add(const TextPersistenceLoadRequested());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TextPersistenceBloc, TextPersistenceState>(
      listenWhen:
          (TextPersistenceState previous, TextPersistenceState current) =>
              current.isLoaded,
      listener: (BuildContext context, TextPersistenceState state) {
        if (_controller.text != state.textOrEmpty) {
          _controller.text = state.textOrEmpty;
        }
      },
      child: BlocBuilder<TextPersistenceBloc, TextPersistenceState>(
        builder: (BuildContext context, TextPersistenceState state) {
          final String text = state.textOrEmpty;
          return Scaffold(
            appBar: AppBar(title: const Text('Persistent TextField (BLoC)')),
            body: ListView(
              padding: const EdgeInsets.all(24),
              children: <Widget>[
                Text(
                  'This page uses a singleton TextPersistenceBloc (clean '
                  'architecture: domain/data/presentation layers) to persist '
                  'text across page navigations. Navigate away and come back — '
                  'the text is preserved.',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Persistent Text',
                    hintText: 'Type something and navigate away...',
                  ),
                  onChanged: (String value) {
                    context.read<TextPersistenceBloc>().add(
                      TextPersistenceTextChanged(text: value),
                    );
                  },
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Current text:',
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          text.isEmpty ? '(empty)' : text,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Card(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Clean Architecture Layers',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 8),
                        _LayerRow(
                          label: 'Domain',
                          detail:
                              'TextSnapshot entity, '
                              'TextPersistenceRepository interface',
                        ),
                        const SizedBox(height: 4),
                        _LayerRow(
                          label: 'Data',
                          detail:
                              'InMemoryTextPersistenceRepository implements '
                              'the repository interface',
                        ),
                        const SizedBox(height: 4),
                        _LayerRow(
                          label: 'Presentation',
                          detail:
                              'TextPersistenceBloc, events/states, '
                              'and this page',
                        ),
                        const SizedBox(height: 4),
                        _LayerRow(
                          label: 'Persistence',
                          detail:
                              'Singleton BLoC provided at app level — '
                              'text survives page disposal',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () => context.router.replacePath('/'),
              icon: const Icon(Icons.home),
              label: const Text('Home'),
            ),
          );
        },
      ),
    );
  }
}

class _LayerRow extends StatelessWidget {
  const _LayerRow({required this.label, required this.detail});

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
            width: 100,
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
