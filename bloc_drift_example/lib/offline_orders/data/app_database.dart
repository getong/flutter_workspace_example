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
  AppDatabase() : super(driftDatabase(name: 'offline_orders_demo'));

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

  Future<void> upsertOrder({
    required String id,
    required String customerName,
    required double total,
    required bool isSynced,
    required DateTime createdAt,
  }) {
    final now = DateTime.now();

    return into(orders).insertOnConflictUpdate(
      OrdersCompanion(
        id: Value(id),
        customerName: Value(customerName),
        total: Value(total),
        isSynced: Value(isSynced),
        createdAt: Value(createdAt),
        updatedAt: Value(now),
      ),
    );
  }

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

  Future<int> getPendingSyncCount() async {
    final countExpression = syncOperations.id.count();
    final query = selectOnly(syncOperations)
      ..addColumns([countExpression])
      ..where(syncOperations.processed.equals(false));

    final row = await query.getSingle();
    return row.read(countExpression) ?? 0;
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

  Future<void> enqueueCreateOrder({
    required String operationId,
    required String orderId,
    required String customerName,
    required double total,
    required DateTime createdAt,
  }) {
    final payload = jsonEncode({
      'orderId': orderId,
      'customerName': customerName,
      'total': total,
      'createdAt': createdAt.toIso8601String(),
    });

    return into(syncOperations).insertOnConflictUpdate(
      SyncOperationsCompanion(
        id: Value(operationId),
        type: const Value('create_order'),
        payload: Value(payload),
        processed: const Value(false),
        createdAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> markOrderSynced(String orderId) {
    return (update(orders)..where((table) => table.id.equals(orderId))).write(
      OrdersCompanion(
        isSynced: const Value(true),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> markOperationProcessed(String id) {
    return (update(syncOperations)..where((table) => table.id.equals(id)))
        .write(const SyncOperationsCompanion(processed: Value(true)));
  }
}
