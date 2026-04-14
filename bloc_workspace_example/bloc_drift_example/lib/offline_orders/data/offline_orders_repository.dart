import 'dart:convert';

import 'package:bloc_drift_example/offline_orders/data/app_database.dart';
import 'package:bloc_drift_example/offline_orders/data/fake_orders_api.dart';
import 'package:bloc_drift_example/offline_orders/data/network_info.dart';
import 'package:bloc_drift_example/offline_orders/data/offline_order_item.dart';
import 'package:bloc_drift_example/offline_orders/data/sync_queue_item.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class OfflineOrdersRepository {
  OfflineOrdersRepository({
    required AppDatabase database,
    required FakeOrdersApi api,
    required NetworkInfo networkInfo,
  }) : _database = database,
       _api = api,
       _networkInfo = networkInfo;

  final AppDatabase _database;
  final FakeOrdersApi _api;
  final NetworkInfo _networkInfo;

  /// Pure Drift stream — no side-effect caching. BLoC handles snapshot.
  Stream<List<OfflineOrderItem>> watchOrders() => _database.watchOrders();

  /// Pure Drift stream — no side-effect caching.
  Stream<List<SyncQueueItem>> watchSyncQueue() =>
      _database.watchPendingSyncOperations();

  Stream<bool> get connectivityChanges => _networkInfo.onStatusChange;

  Future<bool> get isOnline => _networkInfo.isConnected;

  Future<bool> hasPendingSyncOperations() =>
      _database.hasPendingSyncOperations();

  Future<SaveOrderResult> createOrder({
    required String customerName,
    required double total,
  }) async {
    final orderId = _uuid.v4();
    final createdAt = DateTime.now();
    final online = await _networkInfo.isConnected;

    if (online) {
      try {
        await _api.createOrder(customerName: customerName, total: total);
        await _database.saveOnlineOrder(
          id: orderId,
          customerName: customerName,
          total: total,
          createdAt: createdAt,
        );

        return const SaveOrderResult(
          isOnlineSave: true,
          message: 'Saved through API and cached in Drift.',
        );
      } on FakeOrdersApiException {
        rethrow;
      } on Exception {
        // Network may have dropped between the check and the API call.
        // Fall through to offline path.
      }
    }

    await _database.saveOrderLocallyAndEnqueue(
      orderId: orderId,
      operationId: _uuid.v4(),
      customerName: customerName,
      total: total,
      createdAt: createdAt,
    );

    return const SaveOrderResult(
      isOnlineSave: false,
      message: 'Saved in Drift and queued for sync.',
    );
  }

  Future<SyncOrdersResult> syncPendingOrders() async {
    if (!await _networkInfo.isConnected) {
      return const SyncOrdersResult(
        processedCount: 0,
        message: 'Still offline, pending operations remain queued.',
      );
    }

    final pending = await _database.getPendingSyncOperations();
    final completed = <({String orderId, String operationId})>[];

    for (final operation in pending) {
      if (operation.type != 'create_order') continue;

      final payload = jsonDecode(operation.payload) as Map<String, dynamic>;
      try {
        await _api.createOrder(
          customerName: payload['customerName'] as String,
          total: (payload['total'] as num).toDouble(),
        );
        completed.add((
          orderId: payload['orderId'] as String,
          operationId: operation.id,
        ));
      } on FakeOrdersApiException {
        // API validation error — stop immediately, don't retry.
        break;
      } on Exception {
        // Network / transient error — stop and keep remaining queued.
        break;
      }
    }

    // Batch-update DB in a single transaction → one Drift stream notification.
    await _database.completeSyncOperationsBatch(completed);

    final count = completed.length;
    final remaining = pending.length - count;

    return SyncOrdersResult(
      processedCount: count,
      message: switch ((count, remaining)) {
        (0, _) => 'Nothing to sync, local data is already up to date.',
        (_, 0) => 'Synced $count queued operation(s) to the API.',
        _ =>
          'Synced $count of ${pending.length} operation(s). $remaining remain queued.',
      },
    );
  }

  Future<void> dispose() async {
    _networkInfo.dispose();
    await _database.close();
  }
}

class SaveOrderResult {
  const SaveOrderResult({required this.isOnlineSave, required this.message});

  final bool isOnlineSave;
  final String message;
}

class SyncOrdersResult {
  const SyncOrdersResult({required this.processedCount, required this.message});

  final int processedCount;
  final String message;
}
