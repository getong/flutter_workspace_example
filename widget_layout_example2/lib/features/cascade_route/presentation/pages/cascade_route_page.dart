import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/core/config/router/app_router.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';

void _navigateToCascadeHome(BuildContext context) {
  context.router.popUntil((route) => route.settings.name == CascadeRoute.name);
}

void _navigateToCascadeCategories(BuildContext context) {
  context.router.popUntil(
    (route) => route.settings.name == CascadeCategoriesRoute.name,
  );
}

void _navigateToCascadeCategoryDetails(
  BuildContext context, {
  required String categoryId,
  required String categoryName,
}) {
  context.router.popUntil(
    (route) => route.settings.name == CascadeCategoryDetailsRoute.name,
  );
}

void _navigateToCascadeSubcategoryItems(
  BuildContext context, {
  required String categoryId,
  required String categoryName,
  required String subcategoryName,
}) {
  context.router.popUntil(
    (route) => route.settings.name == CascadeSubcategoryItemsRoute.name,
  );
}

// Breadcrumb Navigation Widget
class _BreadcrumbNavigation extends StatelessWidget {
  const _BreadcrumbNavigation({
    required this.breadcrumbs,
    required this.onTap,
    this.isTappable,
  });

  final List<_Breadcrumb> breadcrumbs;
  final Function(int index) onTap;
  final bool Function(int index)? isTappable;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: <Widget>[
            for (int i = 0; i < breadcrumbs.length; i++) ...[
              Builder(
                builder: (BuildContext context) {
                  final bool canTap =
                      isTappable?.call(i) ?? i < breadcrumbs.length - 1;

                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: canTap ? () => onTap(i) : null,
                      borderRadius: BorderRadius.circular(4),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: i == breadcrumbs.length - 1
                              ? Colors.blue
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          breadcrumbs[i].label,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: i == breadcrumbs.length - 1
                                ? Colors.white
                                : canTap
                                ? Colors.blue
                                : Colors.grey,
                            decoration: canTap
                                ? TextDecoration.underline
                                : null,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              if (i < breadcrumbs.length - 1)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: Colors.grey[400],
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Breadcrumb {
  const _Breadcrumb({required this.label});
  final String label;
}

@RoutePage(name: RouteName.cascade)
class CascadePage extends StatelessWidget {
  const CascadePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cascade Route Demo'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: <Widget>[
          _BreadcrumbNavigation(
            breadcrumbs: const <_Breadcrumb>[_Breadcrumb(label: 'Home')],
            isTappable: (int index) => index == 0,
            onTap: (_) => _navigateToCascadeHome(context),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Icon(Icons.category, size: 64, color: Colors.blue),
                  const SizedBox(height: 24),
                  const Text(
                    'Cascade Routing Demo',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Navigate through multiple levels of nested routes',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 48),
                  ElevatedButton.icon(
                    onPressed: () =>
                        context.pushRoute(CascadeCategoriesRoute()),
                    icon: const Icon(Icons.navigate_next),
                    label: const Text('View Categories'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

@RoutePage(name: RouteName.cascadeCategories)
class CascadeCategoriesPage extends StatelessWidget {
  const CascadeCategoriesPage({super.key});

  final List<Map<String, String>> categories = const <Map<String, String>>[
    {'id': 'electronics', 'name': 'Electronics', 'icon': '📱'},
    {'id': 'books', 'name': 'Books', 'icon': '📚'},
    {'id': 'clothing', 'name': 'Clothing', 'icon': '👕'},
    {'id': 'sports', 'name': 'Sports', 'icon': '⚽'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Column(
        children: <Widget>[
          _BreadcrumbNavigation(
            breadcrumbs: const <_Breadcrumb>[
              _Breadcrumb(label: 'Home'),
              _Breadcrumb(label: 'Categories'),
            ],
            onTap: (index) {
              if (index == 0) {
                _navigateToCascadeHome(context);
              }
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (BuildContext context, int index) {
                final category = categories[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: ListTile(
                    leading: Text(
                      category['icon']!,
                      style: const TextStyle(fontSize: 24),
                    ),
                    title: Text(category['name']!),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => context.pushRoute(
                      CascadeCategoryDetailsRoute(
                        categoryId: category['id']!,
                        categoryName: category['name']!,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

@RoutePage(name: RouteName.cascadeCategoryDetails)
class CascadeCategoryDetailsPage extends StatelessWidget {
  const CascadeCategoryDetailsPage({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  final String categoryId;
  final String categoryName;

  Map<String, List<String>> _getSubcategories() {
    return <String, List<String>>{
      'electronics': <String>['Phones', 'Laptops', 'Tablets', 'Headphones'],
      'books': <String>['Fiction', 'Science', 'History', 'Biography'],
      'clothing': <String>['Shirts', 'Pants', 'Shoes', 'Accessories'],
      'sports': <String>['Equipment', 'Apparel', 'Footwear', 'Accessories'],
    };
  }

  @override
  Widget build(BuildContext context) {
    final subcategories = _getSubcategories()[categoryId] ?? <String>[];

    return Scaffold(
      appBar: AppBar(title: Text(categoryName), backgroundColor: Colors.green),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _BreadcrumbNavigation(
            breadcrumbs: <_Breadcrumb>[
              const _Breadcrumb(label: 'Home'),
              const _Breadcrumb(label: 'Categories'),
              _Breadcrumb(label: categoryName),
            ],
            onTap: (index) {
              if (index == 0) {
                _navigateToCascadeHome(context);
              } else if (index == 1) {
                _navigateToCascadeCategories(context);
              }
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: subcategories.length,
              itemBuilder: (BuildContext context, int index) {
                final subcategory = subcategories[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    title: Text(subcategory),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => context.pushRoute(
                      CascadeSubcategoryItemsRoute(
                        categoryId: categoryId,
                        categoryName: categoryName,
                        subcategoryName: subcategory,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

@RoutePage(name: RouteName.cascadeSubcategoryItems)
class CascadeSubcategoryItemsPage extends StatelessWidget {
  const CascadeSubcategoryItemsPage({
    super.key,
    required this.categoryId,
    required this.categoryName,
    required this.subcategoryName,
  });

  final String categoryId;
  final String categoryName;
  final String subcategoryName;

  List<Map<String, String>> _generateItems() {
    return <Map<String, String>>[
      {'id': '1', 'name': '$subcategoryName Item 1', 'price': '\$99.99'},
      {'id': '2', 'name': '$subcategoryName Item 2', 'price': '\$149.99'},
      {'id': '3', 'name': '$subcategoryName Item 3', 'price': '\$199.99'},
      {'id': '4', 'name': '$subcategoryName Item 4', 'price': '\$249.99'},
      {'id': '5', 'name': '$subcategoryName Item 5', 'price': '\$299.99'},
    ];
  }

  @override
  Widget build(BuildContext context) {
    final items = _generateItems();

    return Scaffold(
      appBar: AppBar(
        title: Text(subcategoryName),
        backgroundColor: Colors.purple,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _BreadcrumbNavigation(
            breadcrumbs: <_Breadcrumb>[
              const _Breadcrumb(label: 'Home'),
              const _Breadcrumb(label: 'Categories'),
              _Breadcrumb(label: categoryName),
              _Breadcrumb(label: subcategoryName),
            ],
            onTap: (index) {
              if (index == 0) {
                _navigateToCascadeHome(context);
              } else if (index == 1) {
                _navigateToCascadeCategories(context);
              } else if (index == 2) {
                _navigateToCascadeCategoryDetails(
                  context,
                  categoryId: categoryId,
                  categoryName: categoryName,
                );
              }
            },
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1,
              ),
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                final item = items[index];
                return GestureDetector(
                  onTap: () => context.pushRoute(
                    CascadeItemDetailsRoute(
                      categoryId: categoryId,
                      categoryName: categoryName,
                      subcategoryName: subcategoryName,
                      itemId: item['id']!,
                      itemName: item['name']!,
                      itemPrice: item['price']!,
                    ),
                  ),
                  child: Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.purple[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            item['name']!.split(' ').sublist(0, 2).join(' '),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['price']!,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.purple[600],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

@RoutePage(name: RouteName.cascadeItemDetails)
class CascadeItemDetailsPage extends StatelessWidget {
  const CascadeItemDetailsPage({
    super.key,
    required this.categoryId,
    required this.categoryName,
    required this.subcategoryName,
    required this.itemId,
    required this.itemName,
    required this.itemPrice,
  });

  final String categoryId;
  final String categoryName;
  final String subcategoryName;
  final String itemId;
  final String itemName;
  final String itemPrice;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Details'),
        backgroundColor: Colors.indigo,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _BreadcrumbNavigation(
              breadcrumbs: <_Breadcrumb>[
                const _Breadcrumb(label: 'Home'),
                const _Breadcrumb(label: 'Categories'),
                _Breadcrumb(label: categoryName),
                _Breadcrumb(label: subcategoryName),
                const _Breadcrumb(label: 'Item'),
              ],
              onTap: (index) {
                if (index == 0) {
                  _navigateToCascadeHome(context);
                } else if (index == 1) {
                  _navigateToCascadeCategories(context);
                } else if (index == 2) {
                  _navigateToCascadeCategoryDetails(
                    context,
                    categoryId: categoryId,
                    categoryName: categoryName,
                  );
                } else if (index == 3) {
                  _navigateToCascadeSubcategoryItems(
                    context,
                    categoryId: categoryId,
                    categoryName: categoryName,
                    subcategoryName: subcategoryName,
                  );
                }
              },
            ),
            Container(
              height: 200,
              color: Colors.indigo[100],
              child: Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.indigo[300],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      itemId,
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    itemName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    itemPrice,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.indigo[600],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Route Hierarchy',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _RouteInfo(level: 1, name: 'Cascade', path: '/cascade'),
                        _RouteInfo(
                          level: 2,
                          name: 'Categories',
                          path: '/cascade/categories',
                        ),
                        _RouteInfo(
                          level: 3,
                          name: 'Category Details',
                          path: '/cascade/categories/$categoryId',
                        ),
                        _RouteInfo(
                          level: 4,
                          name: 'Subcategory Items',
                          path:
                              '/cascade/categories/$categoryId/$subcategoryName',
                        ),
                        _RouteInfo(
                          level: 5,
                          name: 'Item Details',
                          path:
                              '/cascade/categories/$categoryId/$subcategoryName/$itemId',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => context.router.pop(),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Back'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RouteInfo extends StatelessWidget {
  const _RouteInfo({
    required this.level,
    required this.name,
    required this.path,
  });

  final int level;
  final String name;
  final String path;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: <Widget>[
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.indigo[level * 100],
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Text(
                'L$level',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                Text(
                  path,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                    fontFamily: 'monospace',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
