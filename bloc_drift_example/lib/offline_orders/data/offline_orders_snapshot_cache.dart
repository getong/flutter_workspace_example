import 'dart:convert';

import 'package:bloc_drift_example/offline_orders/data/offline_order_item.dart';
import 'package:bloc_drift_example/offline_orders/data/sync_queue_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OfflineOrdersSnapshotCache {
  OfflineOrdersSnapshotCache({required SharedPreferencesWithCache preferences})
    : _preferences = preferences;

  static const ordersKey = 'offline_orders.cached_orders';
  static const queueKey = 'offline_orders.cached_queue';
  static const preferenceKeys = <String>{ordersKey, queueKey};

  final SharedPreferencesWithCache _preferences;

  Future<OfflineOrdersSnapshot> loadSnapshot() async {
    try {
      final ordersJson = _preferences.getString(ordersKey);
      final queueJson = _preferences.getString(queueKey);

      return OfflineOrdersSnapshot(
        orders: ordersJson == null ? const [] : _decodeOrders(ordersJson),
        queue: queueJson == null ? const [] : _decodeQueue(queueJson),
      );
    } on Object {
      await clear();
      return const OfflineOrdersSnapshot.empty();
    }
  }

  Future<void> saveOrders(List<OfflineOrderItem> orders) async {
    await _preferences.setString(
      ordersKey,
      jsonEncode(orders.map((order) => order.toJson()).toList()),
    );
  }

  Future<void> saveQueue(List<SyncQueueItem> queue) async {
    await _preferences.setString(
      queueKey,
      jsonEncode(queue.map((item) => item.toJson()).toList()),
    );
  }

  Future<void> clear() async {
    await _preferences.remove(ordersKey);
    await _preferences.remove(queueKey);
  }

  List<OfflineOrderItem> _decodeOrders(String rawJson) {
    final decoded = jsonDecode(rawJson) as List<dynamic>;
    return decoded
        .cast<Map<String, dynamic>>()
        .map(OfflineOrderItem.fromJson)
        .toList(growable: false);
  }

  List<SyncQueueItem> _decodeQueue(String rawJson) {
    final decoded = jsonDecode(rawJson) as List<dynamic>;
    return decoded
        .cast<Map<String, dynamic>>()
        .map(SyncQueueItem.fromJson)
        .toList(growable: false);
  }
}

class OfflineOrdersSnapshot {
  const OfflineOrdersSnapshot({required this.orders, required this.queue});

  const OfflineOrdersSnapshot.empty() : orders = const [], queue = const [];

  final List<OfflineOrderItem> orders;
  final List<SyncQueueItem> queue;

  bool get hasData => orders.isNotEmpty || queue.isNotEmpty;
}
