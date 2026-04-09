import 'dart:convert';

import 'package:bloc_drift_example/offline_orders/data/app_database.dart';
import 'package:bloc_drift_example/offline_orders/data/fake_orders_api.dart';
import 'package:bloc_drift_example/offline_orders/data/network_info.dart';
import 'package:bloc_drift_example/offline_orders/data/offline_order_item.dart';
import 'package:bloc_drift_example/offline_orders/data/offline_orders_snapshot_cache.dart';
import 'package:bloc_drift_example/offline_orders/data/sync_queue_item.dart';

class OfflineOrdersRepository {
  OfflineOrdersRepository({
    required AppDatabase database,
    required FakeOrdersApi api,
    required NetworkInfo networkInfo,
    OfflineOrdersSnapshotCache? snapshotCache,
  }) : _database = database,
       _api = api,
       _networkInfo = networkInfo,
       _snapshotCache = snapshotCache ?? OfflineOrdersSnapshotCache();

  final AppDatabase _database;
  final FakeOrdersApi _api;
  final NetworkInfo _networkInfo;
  final OfflineOrdersSnapshotCache _snapshotCache;

  Stream<List<OfflineOrderItem>> watchOrders() {
    return _database.watchOrders().asyncMap((orders) async {
      await _snapshotCache.saveOrders(orders);
      return orders;
    });
  }

  Stream<List<SyncQueueItem>> watchSyncQueue() {
    return _database.watchPendingSyncOperations().asyncMap((queue) async {
      await _snapshotCache.saveQueue(queue);
      return queue;
    });
  }

  Stream<bool> get connectivityChanges => _networkInfo.onStatusChange;

  Future<bool> get isOnline => _networkInfo.isConnected;

  Future<OfflineOrdersSnapshot> loadCachedSnapshot() {
    return _snapshotCache.loadSnapshot();
  }

  Future<SaveOrderResult> createOrder({
    required String customerName,
    required double total,
  }) async {
    final orderId = _newId('order');
    final createdAt = DateTime.now();
    final online = await _networkInfo.isConnected;

    if (online) {
      try {
        await _api.createOrder(customerName: customerName, total: total);
        await _database.upsertOrder(
          id: orderId,
          customerName: customerName,
          total: total,
          isSynced: true,
          createdAt: createdAt,
        );

        return const SaveOrderResult(
          isOnlineSave: true,
          message: 'Saved through API and cached in Drift.',
        );
      } on FakeOrdersApiException {
        rethrow;
      } on Exception {
        if (await _networkInfo.isConnected) {
          rethrow;
        }
      }
    }

    await _saveOrderLocally(
      orderId: orderId,
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
    var processedCount = 0;

    for (final operation in pending) {
      if (operation.type != 'create_order') {
        continue;
      }

      try {
        final payload = jsonDecode(operation.payload) as Map<String, dynamic>;
        await _api.createOrder(
          customerName: payload['customerName'] as String,
          total: (payload['total'] as num).toDouble(),
        );
        await _database.markOrderSynced(payload['orderId'] as String);
        await _database.markOperationProcessed(operation.id);
        processedCount++;
      } on FakeOrdersApiException {
        rethrow;
      } on Exception catch (error) {
        return SyncOrdersResult(
          processedCount: processedCount,
          message: processedCount == 0
              ? 'Sync stopped before completing the queue: $error'
              : 'Synced $processedCount queued operation(s) before sync stopped: $error',
        );
      }
    }

    return SyncOrdersResult(
      processedCount: processedCount,
      message: processedCount == 0
          ? 'Nothing to sync, local data is already up to date.'
          : 'Synced $processedCount queued operation(s) to the API.',
    );
  }

  Future<void> dispose() async {
    _networkInfo.dispose();
    await _database.close();
  }

  Future<void> _saveOrderLocally({
    required String orderId,
    required String customerName,
    required double total,
    required DateTime createdAt,
  }) async {
    await _database.upsertOrder(
      id: orderId,
      customerName: customerName,
      total: total,
      isSynced: false,
      createdAt: createdAt,
    );
    await _database.enqueueCreateOrder(
      operationId: _newId('sync'),
      orderId: orderId,
      customerName: customerName,
      total: total,
      createdAt: createdAt,
    );
  }

  String _newId(String prefix) {
    return '$prefix-${DateTime.now().microsecondsSinceEpoch}';
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
