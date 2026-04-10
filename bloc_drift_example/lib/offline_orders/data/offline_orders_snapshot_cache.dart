import 'dart:async';
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

  static const _debounceDuration = Duration(milliseconds: 500);

  final SharedPreferencesWithCache _preferences;
  Timer? _ordersDebounce;
  Timer? _queueDebounce;

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

  /// Debounced save — only the last call within the window actually writes.
  void saveOrdersDebounced(List<OfflineOrderItem> orders) {
    _ordersDebounce?.cancel();
    _ordersDebounce = Timer(_debounceDuration, () {
      _preferences.setString(
        ordersKey,
        jsonEncode(orders.map((order) => order.toJson()).toList()),
      );
    });
  }

  /// Debounced save — only the last call within the window actually writes.
  void saveQueueDebounced(List<SyncQueueItem> queue) {
    _queueDebounce?.cancel();
    _queueDebounce = Timer(_debounceDuration, () {
      _preferences.setString(
        queueKey,
        jsonEncode(queue.map((item) => item.toJson()).toList()),
      );
    });
  }

  /// Force-flush any pending debounced writes (call on app pause/dispose).
  Future<void> flush(
    List<OfflineOrderItem> orders,
    List<SyncQueueItem> queue,
  ) async {
    _ordersDebounce?.cancel();
    _queueDebounce?.cancel();
    await Future.wait([
      _preferences.setString(
        ordersKey,
        jsonEncode(orders.map((o) => o.toJson()).toList()),
      ),
      _preferences.setString(
        queueKey,
        jsonEncode(queue.map((q) => q.toJson()).toList()),
      ),
    ]);
  }

  Future<void> clear() async {
    _ordersDebounce?.cancel();
    _queueDebounce?.cancel();
    await _preferences.remove(ordersKey);
    await _preferences.remove(queueKey);
  }

  void dispose() {
    _ordersDebounce?.cancel();
    _queueDebounce?.cancel();
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
