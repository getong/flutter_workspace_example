import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/analytics_repository.dart';
import '../repository/cache_repository.dart';
import 'analytics_cubit.dart';

/// {@template analytics_page}
/// Page demonstrating advanced RepositoryProvider usage with analytics
/// {@endtemplate}
class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AnalyticsCubit(context.read<AnalyticsRepository>())..loadEvents(),
      child: const AnalyticsView(),
    );
  }
}

/// {@template analytics_view}
/// View showing analytics events and repository usage
/// {@endtemplate}
class AnalyticsView extends StatelessWidget {
  const AnalyticsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics - Advanced RepositoryProvider'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<AnalyticsCubit>().loadEvents(),
          ),
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: () => context.read<AnalyticsCubit>().clearEvents(),
          ),
        ],
      ),
      body: BlocConsumer<AnalyticsCubit, AnalyticsState>(
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error!),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              // Repository info and cache management
              _buildRepositoryInfo(context),

              // Analytics summary
              _buildAnalyticsSummary(context, state),

              // Event tracking buttons
              _buildEventTrackingButtons(context),

              // Events list
              Expanded(
                child: _buildEventsList(context, state),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRepositoryInfo(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Repository Information',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Analytics: ${context.read<AnalyticsRepository>().runtimeType}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Text(
            'Cache: ${context.read<CacheRepository>().runtimeType}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () async {
                  final cache = context.read<CacheRepository>();
                  await cache.clear();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cache cleared!')),
                  );
                },
                icon: const Icon(Icons.clear_all, size: 16),
                label: const Text('Clear Cache'),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () async {
                  final cache = context.read<CacheRepository>();
                  final keys = await cache.getKeys();
                  if (context.mounted) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Cache Keys'),
                        content: SizedBox(
                          width: double.maxFinite,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: keys.length,
                            itemBuilder: (context, index) => ListTile(
                              title: Text(keys[index]),
                              dense: true,
                            ),
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Close'),
                          ),
                        ],
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.key, size: 16),
                label: const Text('View Cache Keys'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsSummary(BuildContext context, AnalyticsState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      '${state.totalEvents}',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const Text('Total Events'),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      '${state.events.length}',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const Text('Loaded Events'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventTrackingButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          ElevatedButton(
            onPressed: () {
              context.read<AnalyticsCubit>().trackEvent('button_clicked', {
                'button': 'test_button_1',
                'timestamp': DateTime.now().toIso8601String(),
              });
            },
            child: const Text('Track Button Click'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<AnalyticsCubit>().trackEvent('page_viewed', {
                'page': 'analytics_page',
                'timestamp': DateTime.now().toIso8601String(),
              });
            },
            child: const Text('Track Page View'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<AnalyticsCubit>().trackEvent('user_action', {
                'action': 'custom_event',
                'value': DateTime.now().millisecondsSinceEpoch,
              });
            },
            child: const Text('Track Custom Event'),
          ),
        ],
      ),
    );
  }

  Widget _buildEventsList(BuildContext context, AnalyticsState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.events.isEmpty) {
      return const Center(
        child: Text('No analytics events. Track some events to see them here.'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.events.length,
      itemBuilder: (context, index) {
        final event = state.events[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ExpansionTile(
            title: Text(event.name),
            subtitle: Text(
              '${event.timestamp.hour}:${event.timestamp.minute.toString().padLeft(2, '0')}:${event.timestamp.second.toString().padLeft(2, '0')}',
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Properties:',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    ...event.properties.entries.map(
                      (entry) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 100,
                              child: Text(
                                '${entry.key}:',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              child: Text(entry.value.toString()),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
