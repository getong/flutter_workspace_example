import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/repositories/fetch_history_repository.dart';
import '../../domain/fetch_history_entry.dart';

class FetchHistoryPage extends StatefulWidget {
  const FetchHistoryPage({super.key, required this.repository});

  final FetchHistoryRepository repository;

  @override
  State<FetchHistoryPage> createState() => _FetchHistoryPageState();
}

class _FetchHistoryPageState extends State<FetchHistoryPage> {
  late Future<List<FetchHistoryEntry>> _historyFuture;

  @override
  void initState() {
    super.initState();
    _historyFuture = widget.repository.readHistory();
  }

  Future<void> _reload() async {
    setState(() {
      _historyFuture = widget.repository.readHistory();
    });
    await _historyFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fetch History'),
        leading: IconButton(
          tooltip: 'Go back',
          onPressed: () {
            if (context.canPop()) {
              context.pop();
              return;
            }
            context.go('/fetch');
          },
          icon: const Icon(Icons.arrow_back),
        ),
        actions: <Widget>[
          IconButton(
            tooltip: 'Refresh history',
            onPressed: _reload,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder<List<FetchHistoryEntry>>(
        future: _historyFuture,
        builder:
            (
              BuildContext context,
              AsyncSnapshot<List<FetchHistoryEntry>> snapshot,
            ) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      'Failed to load Drift history: ${snapshot.error}',
                    ),
                  ),
                );
              }

              final List<FetchHistoryEntry> entries =
                  snapshot.data ?? <FetchHistoryEntry>[];
              if (entries.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Text(
                      'No fetch history yet. Run a Dio request from the home page first.',
                    ),
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: _reload,
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: entries.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(height: 10),
                  itemBuilder: (BuildContext context, int index) {
                    final FetchHistoryEntry entry = entries[index];
                    final String preview = entry.responseBody.replaceAll(
                      '\n',
                      ' ',
                    );

                    return Card(
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        title: Text(
                          entry.url,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            'status: ${entry.statusCode?.toString() ?? 'n/a'} | saved: ${entry.fetchedAt.toIso8601String()}\n$preview',
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        trailing: Icon(
                          entry.isSuccess
                              ? Icons.check_circle
                              : Icons.error_outline,
                          color: entry.isSuccess
                              ? Colors.teal
                              : Theme.of(context).colorScheme.error,
                        ),
                        onTap: () => context.go('/history/${entry.id}'),
                      ),
                    );
                  },
                ),
              );
            },
      ),
    );
  }
}
