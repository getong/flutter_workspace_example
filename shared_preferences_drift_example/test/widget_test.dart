import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:shared_preferences_drift_example/catalog/bloc/catalog_bloc.dart';
import 'package:shared_preferences_drift_example/catalog/data/models/catalog_cache_snapshot.dart';
import 'package:shared_preferences_drift_example/catalog/data/models/catalog_item.dart';
import 'package:shared_preferences_drift_example/catalog/data/models/catalog_refresh_result.dart';
import 'package:shared_preferences_drift_example/catalog/data/repositories/catalog_repository.dart';
import 'package:shared_preferences_drift_example/catalog/view/catalog_page.dart';

void main() {
  testWidgets('renders cache studio shell', (WidgetTester tester) async {
    final items = <CatalogItem>[
      CatalogItem(
        id: 'tea-01',
        title: 'Paper Lantern Tea',
        summary: 'Citrus blend stored locally for instant startup.',
        category: 'Pantry',
        price: 16.0,
        stock: 12,
        isPopular: true,
        remoteUpdatedAt: DateTime(2026, 4, 10, 9),
        cachedAt: DateTime(2026, 4, 10, 9, 5),
      ),
      CatalogItem(
        id: 'lamp-01',
        title: 'Tokyo Desk Lamp',
        summary: 'Warm aluminum lamp from the fake remote catalogue.',
        category: 'Home Office',
        price: 74.0,
        stock: 4,
        isPopular: false,
        remoteUpdatedAt: DateTime(2026, 4, 10, 9),
        cachedAt: DateTime(2026, 4, 10, 9, 5),
      ),
    ];
    final repository = _FakeCatalogRepository(items);
    final bloc = CatalogBloc(repository: repository);

    addTearDown(repository.dispose);
    addTearDown(bloc.close);

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(value: bloc, child: const CatalogPage()),
      ),
    );

    await tester.pump();

    expect(find.text('Cache Studio'), findsOneWidget);
    expect(find.text('Pull-through cache demo'), findsOneWidget);
    expect(find.text('Force Refresh'), findsOneWidget);
  });
}

class _FakeCatalogRepository implements CatalogRepository {
  _FakeCatalogRepository(this._items);

  final List<CatalogItem> _items;

  @override
  Future<void> dispose() async {}

  @override
  Future<CatalogRefreshResult> ensureHydrated() async {
    return CatalogRefreshResult(
      didRefresh: false,
      servedFromCache: true,
      message: 'Loaded ${_items.length} cached items.',
    );
  }

  @override
  Future<CatalogCacheSnapshot> getCacheSnapshot() async {
    return CatalogCacheSnapshot(
      lastSyncAt: DateTime(2026, 4, 10, 9, 5),
      isExpired: false,
      localItemCount: _items.length,
      cacheTtl: const Duration(minutes: 5),
    );
  }

  @override
  Future<CatalogRefreshResult> refresh({bool force = false}) async {
    return CatalogRefreshResult(
      didRefresh: true,
      servedFromCache: false,
      message: 'Refreshed ${_items.length} items from the demo source.',
    );
  }

  @override
  Stream<List<CatalogItem>> watchItems() async* {
    yield _items;
  }
}
