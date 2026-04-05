import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/analytics_repository.dart';
import 'analytics_cubit.dart';

/// {@template analytics_widget}
/// A compact widget that displays MockAnalyticsRepository data
/// {@endtemplate}
class AnalyticsWidget extends StatefulWidget {
  const AnalyticsWidget({super.key});

  @override
  State<AnalyticsWidget> createState() => _AnalyticsWidgetState();
}

class _AnalyticsWidgetState extends State<AnalyticsWidget> {
  late final AnalyticsCubit _analyticsCubit;

  @override
  void initState() {
    super.initState();
    _analyticsCubit = AnalyticsCubit(context.read<AnalyticsRepository>());
    _analyticsCubit.loadEvents();
  }

  @override
  void dispose() {
    _analyticsCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AnalyticsCubit>.value(
      value: _analyticsCubit,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 2),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row - very compact
              SizedBox(
                height: 24,
                child: Row(
                  children: [
                    const Icon(Icons.analytics, color: Colors.blue, size: 14),
                    const SizedBox(width: 6),
                    Text(
                      'Analytics',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () => _analyticsCubit.loadEvents(),
                      child: const Icon(Icons.refresh, size: 14),
                    ),
                    const SizedBox(width: 4),
                    InkWell(
                      onTap: () => _openFullAnalytics(context),
                      child: const Icon(Icons.open_in_full, size: 14),
                    ),
                  ],
                ),
              ),

              // Content - very compact
              BlocConsumer<AnalyticsCubit, AnalyticsState>(
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
                  if (state.isLoading && state.events.isEmpty) {
                    return const SizedBox(
                      height: 20,
                      child: Center(
                        child: SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    );
                  }

                  return SizedBox(
                    height:
                        26, // Adjusted from 36 to fit within 50px total (24 header + 26 content)
                    child: Stack(
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 16,
                              child: Row(
                                children: [
                                  _buildCompactStat(context,
                                      '${state.totalEvents}', 'Events'),
                                  const SizedBox(width: 12),
                                  _buildCompactStat(
                                      context,
                                      '${state.events.take(3).length}',
                                      'Recent'),
                                  const Spacer(),
                                  SizedBox(
                                    height: 14,
                                    child: ElevatedButton(
                                      onPressed: () =>
                                          _trackTestEvent('quick_action'),
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4, vertical: 0),
                                        minimumSize: Size.zero,
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: const Text('Track',
                                          style: TextStyle(fontSize: 8)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Remove SizedBox(height: 1)
                            // The event list will be absolutely positioned below the stats row
                          ],
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: ClipRect(
                            child: SizedBox(
                              height: 17,
                              child: state.events.isNotEmpty
                                  ? ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: state.events.take(5).length,
                                      itemBuilder: (context, index) {
                                        final event = state.events[index];
                                        return Container(
                                          margin:
                                              const EdgeInsets.only(right: 4),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 3, vertical: 1),
                                          decoration: BoxDecoration(
                                            color: _getEventColor(event.name)
                                                .withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            border: Border.all(
                                              color: _getEventColor(event.name)
                                                  .withOpacity(0.3),
                                              width: 0.5,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                width: 3,
                                                height: 3,
                                                decoration: BoxDecoration(
                                                  color: _getEventColor(
                                                      event.name),
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              const SizedBox(width: 2),
                                              Text(
                                                event.name.length > 6
                                                    ? '${event.name.substring(0, 6)}...'
                                                    : event.name,
                                                style: const TextStyle(
                                                    fontSize: 8),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    )
                                  : Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 1),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Center(
                                        child: Text('No events',
                                            style: TextStyle(fontSize: 8)),
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompactStat(BuildContext context, String value, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 11, // Reduced from 12
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 9), // Reduced from 10
        ),
      ],
    );
  }

  Color _getEventColor(String eventName) {
    switch (eventName) {
      case 'app_started':
        return Colors.green;
      case 'button_clicked':
      case 'widget_interaction':
      case 'quick_action':
        return Colors.blue;
      case 'user_action':
        return Colors.orange;
      case 'page_viewed':
        return Colors.purple;
      case 'users_loaded':
      case 'user_selected':
      case 'user_created':
        return Colors.cyan;
      default:
        return Colors.grey;
    }
  }

  void _trackTestEvent(String eventType) {
    final properties = {
      'timestamp': DateTime.now().toIso8601String(),
      'source': 'analytics_widget',
      'type': eventType,
    };

    _analyticsCubit.trackEvent(eventType, properties);
  }

  void _openFullAnalytics(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider<AnalyticsCubit>.value(
          value: _analyticsCubit,
          child: _FullAnalyticsView(),
        ),
      ),
    );
  }
}

/// Full screen analytics view
class _FullAnalyticsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<AnalyticsCubit>().loadEvents(),
          ),
        ],
      ),
      body: BlocBuilder<AnalyticsCubit, AnalyticsState>(
        builder: (context, state) {
          return Column(
            children: [
              // Stats header
              Container(
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
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
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
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                              const Text('Loaded Events'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Event tracking buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Wrap(
                  spacing: 8,
                  children: [
                    ElevatedButton(
                      onPressed: () => _trackEvent(context, 'button_clicked'),
                      child: const Text('Track Button Click'),
                    ),
                    ElevatedButton(
                      onPressed: () => _trackEvent(context, 'page_viewed'),
                      child: const Text('Track Page View'),
                    ),
                    ElevatedButton(
                      onPressed: () => _trackEvent(context, 'user_action'),
                      child: const Text('Track User Action'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Events list
              Expanded(
                child: state.events.isEmpty
                    ? const Center(child: Text('No events to display'))
                    : ListView.builder(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Event ID: ${event.id}'),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Properties:',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall,
                                      ),
                                      ...event.properties.entries.map(
                                        (entry) => Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 2),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 100,
                                                child: Text(
                                                  '${entry.key}:',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                    entry.value.toString()),
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
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _trackEvent(BuildContext context, String eventType) {
    final properties = {
      'timestamp': DateTime.now().toIso8601String(),
      'source': 'full_analytics_view',
      'type': eventType,
    };

    context.read<AnalyticsCubit>().trackEvent(eventType, properties);
  }
}
