import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/repositories/fetch_history_repository.dart';
import '../../domain/fetch_history_entry.dart';

class FetchHistoryDetailPage extends StatelessWidget {
  const FetchHistoryDetailPage({
    required this.historyId,
    required this.repository,
    super.key,
  });

  final int historyId;
  final FetchHistoryRepository repository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History #$historyId'),
        leading: IconButton(
          tooltip: 'Go back',
          onPressed: () {
            if (context.canPop()) {
              context.pop();
              return;
            }
            context.go('/history');
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: FutureBuilder<FetchHistoryEntry?>(
        future: repository.readHistoryEntry(historyId),
        builder:
            (BuildContext context, AsyncSnapshot<FetchHistoryEntry?> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      'Failed to load history entry: ${snapshot.error}',
                    ),
                  ),
                );
              }

              final FetchHistoryEntry? entry = snapshot.data;
              if (entry == null) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Text('History entry not found.'),
                  ),
                );
              }

              return ListView(
                padding: const EdgeInsets.all(16),
                children: <Widget>[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            entry.url,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'statusCode: ${entry.statusCode?.toString() ?? 'n/a'}',
                          ),
                          Text('success: ${entry.isSuccess}'),
                          Text(
                            'fetchedAt: ${entry.fetchedAt.toIso8601String()}',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: SelectableText(entry.responseBody),
                    ),
                  ),
                ],
              );
            },
      ),
    );
  }
}
