import 'dart:convert';

import 'package:bloc_drift_example/offline_orders/data/offline_order_item.dart';
import 'package:bloc_drift_example/offline_orders/data/sync_queue_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OfflineOrdersSnapshotCache {
  static const _ordersKey = 'offline_orders.cached_orders';
  static const _queueKey = 'offline_orders.cached_queue';

  Future<OfflineOrdersSnapshot> loadSnapshot() async {
    final preferences = await SharedPreferences.getInstance();

    try {
      final ordersJson = preferences.getString(_ordersKey);
      final queueJson = preferences.getString(_queueKey);

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
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(
      _ordersKey,
      jsonEncode(orders.map((order) => order.toJson()).toList()),
    );
  }

  Future<void> saveQueue(List<SyncQueueItem> queue) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(
      _queueKey,
      jsonEncode(queue.map((item) => item.toJson()).toList()),
    );
  }

  Future<void> clear() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_ordersKey);
    await preferences.remove(_queueKey);
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
