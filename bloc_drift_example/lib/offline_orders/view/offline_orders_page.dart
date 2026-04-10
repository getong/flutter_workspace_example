import 'package:bloc_drift_example/offline_orders/bloc/offline_orders_bloc.dart';
import 'package:bloc_drift_example/offline_orders/bloc/offline_orders_event.dart';
import 'package:bloc_drift_example/offline_orders/bloc/offline_orders_state.dart';
import 'package:bloc_drift_example/offline_orders/data/offline_order_item.dart';
import 'package:bloc_drift_example/offline_orders/data/offline_orders_repository.dart';
import 'package:bloc_drift_example/offline_orders/data/offline_orders_snapshot_cache.dart';
import 'package:bloc_drift_example/offline_orders/data/sync_queue_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OfflineOrdersPage extends StatelessWidget {
  const OfflineOrdersPage({super.key, required this.repository});

  final OfflineOrdersRepository repository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          OfflineOrdersBloc(repository: repository)
            ..add(const OfflineOrdersStarted()),
      child: const _OfflineOrdersView(),
    );
  }
}

class _OfflineOrdersView extends StatefulWidget {
  const _OfflineOrdersView();

  @override
  State<_OfflineOrdersView> createState() => _OfflineOrdersViewState();
}

class _OfflineOrdersViewState extends State<_OfflineOrdersView> {
  final _customerController = TextEditingController();
  final _totalController = TextEditingController(text: '149.99');
  late final OfflineOrdersRepository _repository;
  late final Future<OfflineOrdersSnapshot> _snapshotFuture;
  late final Stream<List<OfflineOrderItem>> _ordersStream;
  late final Stream<List<SyncQueueItem>> _queueStream;

  @override
  void initState() {
    super.initState();
    _repository = context.read<OfflineOrdersRepository>();
    _snapshotFuture = _repository.loadCachedSnapshot();
    _ordersStream = _repository.watchOrders();
    _queueStream = _repository.watchSyncQueue();
  }

  @override
  void dispose() {
    _customerController.dispose();
    _totalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OfflineOrdersBloc, OfflineOrdersState>(
      listenWhen: (previous, current) {
        return previous.message != current.message ||
            previous.errorMessage != current.errorMessage;
      },
      listener: (context, state) {
        final messenger = ScaffoldMessenger.of(context);
        if (state.message case final message?) {
          messenger.showSnackBar(SnackBar(content: Text(message)));
        }
        if (state.errorMessage case final error?) {
          messenger.showSnackBar(
            SnackBar(
              backgroundColor: Theme.of(context).colorScheme.error,
              content: Text(error),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Bloc + Drift Orders'),
          actions: [
            IconButton(
              tooltip: 'Reload state',
              onPressed: () {
                context.read<OfflineOrdersBloc>().add(
                  const OfflineOrdersStarted(),
                );
              },
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
        body: BlocBuilder<OfflineOrdersBloc, OfflineOrdersState>(
          builder: (context, state) {
            return FutureBuilder<OfflineOrdersSnapshot>(
              future: _snapshotFuture,
              initialData: const OfflineOrdersSnapshot.empty(),
              builder: (context, snapshot) {
                final cachedSnapshot =
                    snapshot.data ?? const OfflineOrdersSnapshot.empty();

                return StreamBuilder<List<SyncQueueItem>>(
                  stream: _queueStream,
                  initialData: cachedSnapshot.queue,
                  builder: (context, queueSnapshot) {
                    final queue = queueSnapshot.data ?? cachedSnapshot.queue;

                    return StreamBuilder<List<OfflineOrderItem>>(
                      stream: _ordersStream,
                      initialData: cachedSnapshot.orders,
                      builder: (context, ordersSnapshot) {
                        final orders =
                            ordersSnapshot.data ?? cachedSnapshot.orders;

                        if (state.status == OfflineOrdersStatus.loading &&
                            orders.isEmpty &&
                            queue.isEmpty) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return ListView(
                          padding: const EdgeInsets.all(20),
                          children: [
                            _FlowCard(state: state),
                            const SizedBox(height: 16),
                            _ComposerCard(
                              customerController: _customerController,
                              totalController: _totalController,
                              isSaving: state.isSaving,
                            ),
                            const SizedBox(height: 16),
                            _SummaryRow(
                              orderCount: orders.length,
                              pendingCount: queue.length,
                              isSyncing: state.isSyncing,
                            ),
                            const SizedBox(height: 16),
                            _SyncQueueCard(
                              queue: queue,
                              isSyncing: state.isSyncing,
                              isOnline: state.isOnline,
                            ),
                            const SizedBox(height: 12),
                            if (orders.isEmpty)
                              const _EmptyOrders()
                            else
                              ...orders.map(
                                (order) => _OrderTile(order: order),
                              ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _FlowCard extends StatelessWidget {
  const _FlowCard({required this.state});

  final OfflineOrdersState state;

  @override
  Widget build(BuildContext context) {
    final onlineColor = state.isOnline
        ? const Color(0xFF166534)
        : const Color(0xFF9A3412);
    final onlineLabel = state.isOnline ? 'Online' : 'Offline';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  'Article pattern',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Chip(
                  label: Text(onlineLabel),
                  backgroundColor: onlineColor.withValues(alpha: 0.12),
                  labelStyle: TextStyle(color: onlineColor),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text('User Action'),
            const Icon(Icons.arrow_downward_rounded),
            const Text('Bloc'),
            const Icon(Icons.arrow_downward_rounded),
            const Text('Repository'),
            const Icon(Icons.arrow_downward_rounded),
            const Text('Check Network State (NetworkInfo)'),
            const SizedBox(height: 12),
            Text(
              state.isOnline
                  ? 'Online path: API + save locally to Drift.'
                  : 'Offline path: save locally to Drift + queue for sync.',
            ),
          ],
        ),
      ),
    );
  }
}

class _ComposerCard extends StatelessWidget {
  const _ComposerCard({
    required this.customerController,
    required this.totalController,
    required this.isSaving,
  });

  final TextEditingController customerController;
  final TextEditingController totalController;
  final bool isSaving;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Create order', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            TextField(
              controller: customerController,
              decoration: const InputDecoration(
                labelText: 'Customer name',
                hintText: 'Ada Lovelace',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: totalController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Order total',
                hintText: '149.99',
                prefixText: '\$',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                FilledButton.icon(
                  onPressed: isSaving ? null : () => _submit(context),
                  icon: isSaving
                      ? const SizedBox.square(
                          dimension: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.add_circle_outline),
                  label: const Text('Create order'),
                ),
                OutlinedButton.icon(
                  onPressed: isSaving
                      ? null
                      : () {
                          context.read<OfflineOrdersBloc>().add(
                            const OfflineOrdersSyncRequested(),
                          );
                        },
                  icon: const Icon(Icons.sync),
                  label: const Text('Sync queue'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _submit(BuildContext context) {
    final total = double.tryParse(totalController.text.trim());
    if (customerController.text.trim().isEmpty || total == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter a customer name and a valid total.'),
        ),
      );
      return;
    }

    context.read<OfflineOrdersBloc>().add(
      OfflineOrderSubmitted(
        customerName: customerController.text.trim(),
        total: total,
      ),
    );
    customerController.clear();
    totalController.text = '149.99';
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.orderCount,
    required this.pendingCount,
    required this.isSyncing,
  });

  final int orderCount;
  final int pendingCount;
  final bool isSyncing;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _SummaryChip(label: 'Orders', value: '$orderCount'),
        _SummaryChip(label: 'Pending sync', value: '$pendingCount'),
        _SummaryChip(label: 'Syncing', value: isSyncing ? 'Yes' : 'No'),
      ],
    );
  }
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Chip(label: Text('$label: $value'));
  }
}

class _SyncQueueCard extends StatelessWidget {
  const _SyncQueueCard({
    required this.queue,
    required this.isSyncing,
    required this.isOnline,
  });

  final List<SyncQueueItem> queue;
  final bool isSyncing;
  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sync queue', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              queue.isEmpty
                  ? 'No queued work. New offline writes will appear here.'
                  : isOnline
                  ? 'Queued operations are ready to sync in FIFO order.'
                  : 'Offline writes are stored locally and will replay in order when the network returns.',
            ),
            if (isSyncing) ...[
              const SizedBox(height: 12),
              const LinearProgressIndicator(),
            ],
            if (queue.isNotEmpty) ...[
              const SizedBox(height: 16),
              ...queue.asMap().entries.map(
                (entry) =>
                    _SyncQueueTile(index: entry.key + 1, item: entry.value),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SyncQueueTile extends StatelessWidget {
  const _SyncQueueTile({required this.index, required this.item});

  final int index;
  final SyncQueueItem item;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: CircleAvatar(child: Text('$index')),
      title: Text(item.customerName),
      subtitle: Text(
        'Created ${_formatDateTime(item.createdAt)}\nQueued ${_formatDateTime(item.queuedAt)}',
      ),
      trailing: Text(
        '\$${item.total.toStringAsFixed(2)}',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      isThreeLine: true,
    );
  }
}

class _EmptyOrders extends StatelessWidget {
  const _EmptyOrders();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          'No orders yet. Create one while online or offline to see Drift persistence and sync state.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}

class _OrderTile extends StatelessWidget {
  const _OrderTile({required this.order});

  final OfflineOrderItem order;

  @override
  Widget build(BuildContext context) {
    final syncedColor = order.isSynced
        ? const Color(0xFF166534)
        : const Color(0xFF9A3412);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: syncedColor.withValues(alpha: 0.12),
          foregroundColor: syncedColor,
          child: Icon(order.isSynced ? Icons.cloud_done : Icons.cloud_upload),
        ),
        title: Text(order.customerName),
        subtitle: Text('${order.createdAt.toLocal()}'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '\$${order.total.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 6),
            Text(
              order.isSynced ? 'Synced' : 'Queued',
              style: TextStyle(color: syncedColor),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatDateTime(DateTime value) {
  final local = value.toLocal();
  final month = local.month.toString().padLeft(2, '0');
  final day = local.day.toString().padLeft(2, '0');
  final hour = local.hour.toString().padLeft(2, '0');
  final minute = local.minute.toString().padLeft(2, '0');

  return '${local.year}-$month-$day $hour:$minute';
}
