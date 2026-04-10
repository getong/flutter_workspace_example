import '../models/catalog_item.dart';

class CatalogRemoteDataSource {
  const CatalogRemoteDataSource();

  Future<List<CatalogItem>> fetchCatalog() async {
    await Future<void>.delayed(const Duration(milliseconds: 900));

    final fetchedAt = DateTime.now();
    const seedData =
        <
          ({
            String id,
            String title,
            String summary,
            String category,
            double price,
            int stock,
            bool isPopular,
            int freshnessOffsetMinutes,
          })
        >[
          (
            id: 'tea-01',
            title: 'Paper Lantern Tea',
            summary: 'Bright yuzu black tea for quick afternoon resets.',
            category: 'Pantry',
            price: 16.0,
            stock: 12,
            isPopular: true,
            freshnessOffsetMinutes: 3,
          ),
          (
            id: 'lamp-01',
            title: 'Tokyo Desk Lamp',
            summary: 'Warm aluminum desk lamp with a soft amber bounce.',
            category: 'Home Office',
            price: 74.0,
            stock: 4,
            isPopular: true,
            freshnessOffsetMinutes: 9,
          ),
          (
            id: 'notebook-01',
            title: 'Signal Grid Notebook',
            summary: 'Dot-grid pages tuned for sketching flows and schemas.',
            category: 'Stationery',
            price: 22.5,
            stock: 27,
            isPopular: false,
            freshnessOffsetMinutes: 14,
          ),
          (
            id: 'speaker-01',
            title: 'Moss Pocket Speaker',
            summary:
                'Compact Bluetooth speaker with a deliberately warm profile.',
            category: 'Audio',
            price: 89.0,
            stock: 6,
            isPopular: false,
            freshnessOffsetMinutes: 22,
          ),
        ];

    return seedData
        .map((seed) {
          return CatalogItem(
            id: seed.id,
            title: seed.title,
            summary: seed.summary,
            category: seed.category,
            price: seed.price,
            stock: seed.stock,
            isPopular: seed.isPopular,
            remoteUpdatedAt: fetchedAt.subtract(
              Duration(minutes: seed.freshnessOffsetMinutes),
            ),
            cachedAt: fetchedAt,
          );
        })
        .toList(growable: false);
  }
}
