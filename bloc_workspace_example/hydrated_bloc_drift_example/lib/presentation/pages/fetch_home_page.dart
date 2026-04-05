import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../data/local/app_database.dart';
import '../../data/local/drift_hydrated_storage.dart';
import '../fetch_request_bloc.dart';

class FetchHomePage extends StatefulWidget {
  const FetchHomePage({super.key});

  @override
  State<FetchHomePage> createState() => _FetchHomePageState();
}

class _FetchHomePageState extends State<FetchHomePage> {
  late final TextEditingController _urlController;

  @override
  void initState() {
    super.initState();
    final FetchRequestBloc bloc = context.read<FetchRequestBloc>();
    _urlController = TextEditingController(text: bloc.state.currentUrl);
    _urlController.addListener(_onUrlChanged);
  }

  @override
  void dispose() {
    _urlController
      ..removeListener(_onUrlChanged)
      ..dispose();
    super.dispose();
  }

  void _onUrlChanged() {
    context.read<FetchRequestBloc>().add(
      FetchRequestUrlChanged(_urlController.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('URL Fetch With Dio'),
        actions: <Widget>[
          IconButton(
            tooltip: 'Back to original page',
            onPressed: () => context.go('/'),
            icon: const Icon(Icons.home),
          ),
          IconButton(
            tooltip: 'Fetch history',
            onPressed: () => context.go('/history'),
            icon: const Icon(Icons.history),
          ),
          IconButton(
            tooltip: 'Read raw hydrated rows',
            onPressed: () => _showHydratedRows(context),
            icon: const Icon(Icons.storage),
          ),
        ],
      ),
      body: BlocBuilder<FetchRequestBloc, FetchRequestState>(
        builder: (BuildContext context, FetchRequestState state) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              _IntroCard(state: state),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Fetch URL',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _urlController,
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.go,
                        onSubmitted: (_) => _submit(),
                        decoration: const InputDecoration(
                          labelText: 'Absolute URL',
                          hintText:
                              'https://jsonplaceholder.typicode.com/posts/1',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: FilledButton.icon(
                              onPressed:
                                  state.status == FetchRequestStatus.loading
                                  ? null
                                  : _submit,
                              icon: const Icon(Icons.cloud_download),
                              label: const Text('Fetch with Dio'),
                            ),
                          ),
                        ],
                      ),
                      if (state.status ==
                          FetchRequestStatus.loading) ...<Widget>[
                        const SizedBox(height: 12),
                        const LinearProgressIndicator(),
                      ],
                      if (state.errorMessage != null) ...<Widget>[
                        const SizedBox(height: 12),
                        Text(
                          state.errorMessage!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _ResultCard(state: state),
            ],
          );
        },
      ),
    );
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    context.read<FetchRequestBloc>().add(const FetchRequestSubmitted());
  }

  Future<void> _showHydratedRows(BuildContext context) async {
    final DriftHydratedStorage hydratedStorage = context
        .read<DriftHydratedStorage>();
    final List<PersistedHydratedRow> rows = await hydratedStorage.readRows();
    if (!context.mounted) {
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        if (rows.isEmpty) {
          return const SizedBox(
            height: 180,
            child: Center(child: Text('No hydrated rows in Drift yet.')),
          );
        }

        return SafeArea(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: rows.length,
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(height: 20),
            itemBuilder: (BuildContext context, int index) {
              final PersistedHydratedRow row = rows[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(row.key, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 6),
                  Text(
                    'updated: ${row.updatedAt.toIso8601String()}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    row.value,
                    maxLines: 10,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class _IntroCard extends StatelessWidget {
  const _IntroCard({required this.state});

  final FetchRequestState state;

  @override
  Widget build(BuildContext context) {
    final String fetchedAt = state.lastFetchedAt?.toIso8601String() ?? 'n/a';
    final String statusLabel = state.status.name;
    final String statusCode = state.lastStatusCode?.toString() ?? 'n/a';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Current Request State',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            const Text(
              'HydratedBloc keeps the current URL and last result in Drift-backed storage. Each Dio fetch is also written into a dedicated Drift history table.',
            ),
            const SizedBox(height: 10),
            Text('status: $statusLabel'),
            Text('statusCode: $statusCode'),
            Text('lastFetchedAt: $fetchedAt'),
          ],
        ),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.state});

  final FetchRequestState state;

  @override
  Widget build(BuildContext context) {
    final bool hasResult = state.responseBody.trim().isNotEmpty;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    'Latest Response',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                if (hasResult)
                  IconButton(
                    tooltip: 'Copy result',
                    onPressed: () async {
                      await Clipboard.setData(
                        ClipboardData(text: state.responseBody),
                      );
                      if (!context.mounted) {
                        return;
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Response copied')),
                      );
                    },
                    icon: const Icon(Icons.copy),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            if (!hasResult)
              const Text(
                'No response yet. Enter a URL above and fetch it with Dio.',
              )
            else
              SelectableText(state.responseBody),
          ],
        ),
      ),
    );
  }
}
