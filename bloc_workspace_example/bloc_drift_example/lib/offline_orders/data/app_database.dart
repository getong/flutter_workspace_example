import 'dart:convert';

import 'package:bloc_drift_example/offline_orders/data/offline_order_item.dart';
import 'package:bloc_drift_example/offline_orders/data/sync_queue_item.dart';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

class Orders extends Table {
  TextColumn get id => text()();

  TextColumn get customerName => text()();

  RealColumn get total => real()();

  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}

class SyncOperations extends Table {
  TextColumn get id => text()();

  TextColumn get type => text()();

  TextColumn get payload => text()();

  BoolColumn get processed => boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}

@DriftDatabase(tables: [Orders, SyncOperations])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'offline_orders_v2'));

  @override
  int get schemaVersion => 1;

  Stream<List<OfflineOrderItem>> watchOrders() {
    final query = select(orders)
      ..orderBy([
        (table) =>
            OrderingTerm(expression: table.createdAt, mode: OrderingMode.desc),
      ]);

    return query.watch().map(
      (rows) => rows
          .map(
            (row) => OfflineOrderItem(
              id: row.id,
              customerName: row.customerName,
              total: row.total,
              isSynced: row.isSynced,
              createdAt: row.createdAt,
            ),
          )
          .toList(),
    );
  }

  Stream<List<SyncQueueItem>> watchPendingSyncOperations() {
    final query = select(syncOperations)
      ..where((table) => table.processed.equals(false))
      ..orderBy([
        (table) =>
            OrderingTerm(expression: table.createdAt, mode: OrderingMode.asc),
        (table) => OrderingTerm(expression: table.id, mode: OrderingMode.asc),
      ]);

    return query.watch().map(
      (rows) => rows.map((row) {
        final payload = jsonDecode(row.payload) as Map<String, dynamic>;
        return SyncQueueItem(
          operationId: row.id,
          orderId: payload['orderId'] as String,
          customerName: payload['customerName'] as String,
          total: (payload['total'] as num).toDouble(),
          createdAt: DateTime.parse(payload['createdAt'] as String),
          queuedAt: row.createdAt,
        );
      }).toList(),
    );
  }

  Future<bool> hasPendingSyncOperations() async {
    final countExpression = syncOperations.id.count();
    final query = selectOnly(syncOperations)
      ..addColumns([countExpression])
      ..where(syncOperations.processed.equals(false));

    final row = await query.getSingle();
    return (row.read(countExpression) ?? 0) > 0;
  }

  /// Saves an order and enqueues a sync operation in a single transaction.
  Future<void> saveOrderLocallyAndEnqueue({
    required String orderId,
    required String operationId,
    required String customerName,
    required double total,
    required DateTime createdAt,
  }) {
    return transaction(() async {
      final now = DateTime.now();
      await into(orders).insertOnConflictUpdate(
        OrdersCompanion(
          id: Value(orderId),
          customerName: Value(customerName),
          total: Value(total),
          isSynced: const Value(false),
          createdAt: Value(createdAt),
          updatedAt: Value(now),
        ),
      );

      final payload = jsonEncode({
        'orderId': orderId,
        'customerName': customerName,
        'total': total,
        'createdAt': createdAt.toIso8601String(),
      });

      await into(syncOperations).insertOnConflictUpdate(
        SyncOperationsCompanion(
          id: Value(operationId),
          type: const Value('create_order'),
          payload: Value(payload),
          processed: const Value(false),
          createdAt: Value(now),
        ),
      );
    });
  }

  /// Saves an already-synced order (online path).
  Future<void> saveOnlineOrder({
    required String id,
    required String customerName,
    required double total,
    required DateTime createdAt,
  }) {
    final now = DateTime.now();
    return into(orders).insertOnConflictUpdate(
      OrdersCompanion(
        id: Value(id),
        customerName: Value(customerName),
        total: Value(total),
        isSynced: const Value(true),
        createdAt: Value(createdAt),
        updatedAt: Value(now),
      ),
    );
  }

  /// Returns pending sync operations in FIFO order.
  Future<List<SyncOperation>> getPendingSyncOperations() {
    return (select(syncOperations)
          ..where((table) => table.processed.equals(false))
          ..orderBy([
            (table) => OrderingTerm(
              expression: table.createdAt,
              mode: OrderingMode.asc,
            ),
            (table) =>
                OrderingTerm(expression: table.id, mode: OrderingMode.asc),
          ]))
        .get();
  }

  /// Marks an order as synced and its sync operation as processed atomically.
  Future<void> completeSyncOperation({
    required String orderId,
    required String operationId,
  }) {
    return transaction(() async {
      final now = DateTime.now();
      await (update(orders)..where((t) => t.id.equals(orderId))).write(
        OrdersCompanion(isSynced: const Value(true), updatedAt: Value(now)),
      );
      await (update(syncOperations)..where((t) => t.id.equals(operationId)))
          .write(const SyncOperationsCompanion(processed: Value(true)));
    });
  }

  /// Batch-completes multiple sync operations in one transaction.
  /// Only triggers Drift stream watchers once for the whole batch.
  Future<void> completeSyncOperationsBatch(
    List<({String orderId, String operationId})> completed,
  ) {
    if (completed.isEmpty) return Future.value();
    return transaction(() async {
      final now = DateTime.now();
      for (final item in completed) {
        await (update(orders)..where((t) => t.id.equals(item.orderId))).write(
          OrdersCompanion(isSynced: const Value(true), updatedAt: Value(now)),
        );
        await (update(syncOperations)
              ..where((t) => t.id.equals(item.operationId)))
            .write(const SyncOperationsCompanion(processed: Value(true)));
      }
    });
  }
}
