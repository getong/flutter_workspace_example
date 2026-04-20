import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

@RoutePage()
class InfiniteScrollPaginationPage extends StatefulWidget {
  const InfiniteScrollPaginationPage({super.key});

  @override
  State<InfiniteScrollPaginationPage> createState() =>
      _InfiniteScrollPaginationPageState();
}

class _InfiniteScrollPaginationPageState
    extends State<InfiniteScrollPaginationPage> {
  static const int _pageSize = 8;
  static const List<String> _categories = <String>[
    'All',
    'Layout',
    'Content',
    'Animation',
  ];
  static final List<_FeedItem> _catalog = List<_FeedItem>.generate(36, (
    int index,
  ) {
    final List<String> categories = <String>['Layout', 'Content', 'Animation'];
    final String category = categories[index % categories.length];

    return _FeedItem(
      id: 'demo-$index',
      title: '$category Demo ${index + 1}',
      category: category,
      summary:
          'Page ${index + 1} showcases how pagination widgets stay responsive while new chunks are loaded lazily.',
      color: _palette[index % _palette.length],
    );
  });

  static const List<Color> _palette = <Color>[
    Color(0xFF2563EB),
    Color(0xFF0F766E),
    Color(0xFF7C3AED),
    Color(0xFFEA580C),
  ];

  late final PagingController<int, _FeedItem> _pagingController =
      PagingController<int, _FeedItem>(
        getNextPageKey: (PagingState<int, _FeedItem> state) =>
            state.lastPageIsEmpty ? null : state.nextIntPageKey,
        fetchPage: _fetchPage,
      );

  final TextEditingController _searchController = TextEditingController();

  String _selectedCategory = 'All';
  bool _failNextPage = false;
  String _status =
      'Scroll the list to fetch more content, then change filters to refresh the feed.';

  @override
  void dispose() {
    _pagingController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<List<_FeedItem>> _fetchPage(int pageKey) async {
    await Future<void>.delayed(const Duration(milliseconds: 550));

    if (_failNextPage && pageKey > 1) {
      _failNextPage = false;
      throw Exception('Injected demo error while loading page $pageKey.');
    }

    final List<_FeedItem> filtered = _catalog.where((_FeedItem item) {
      final bool matchesCategory =
          _selectedCategory == 'All' || item.category == _selectedCategory;
      final String query = _searchController.text.trim().toLowerCase();
      final bool matchesQuery =
          query.isEmpty ||
          item.title.toLowerCase().contains(query) ||
          item.summary.toLowerCase().contains(query);
      return matchesCategory && matchesQuery;
    }).toList();

    final int start = (pageKey - 1) * _pageSize;
    if (start >= filtered.length) {
      return const <_FeedItem>[];
    }

    final int end = (start + _pageSize).clamp(0, filtered.length);
    return filtered.sublist(start, end);
  }

  void _refreshFeed([String? status]) {
    setState(() {
      if (status != null) {
        _status = status;
      }
    });
    _pagingController.refresh();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('infinite_scroll_pagination Module')),
      body: SelectionArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: <Widget>[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'infinite_scroll_pagination keeps large feeds responsive by loading pages on demand.',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'This module demonstrates `PagingController`, `PagingListener`, `PagedListView.separated`, first-page refresh, query filters, and custom empty/error states.',
                        style: theme.textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 12),
                      Text(_status),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: 'Search demos',
                          suffixIcon: IconButton(
                            onPressed: () {
                              _searchController.clear();
                              _refreshFeed('Cleared the search filter.');
                            },
                            icon: const Icon(Icons.clear),
                          ),
                        ),
                        onSubmitted: (_) {
                          _refreshFeed(
                            'Applied a text filter and restarted pagination.',
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _categories.map((String category) {
                          return ChoiceChip(
                            label: Text(category),
                            selected: _selectedCategory == category,
                            onSelected: (_) {
                              setState(() {
                                _selectedCategory = category;
                              });
                              _refreshFeed(
                                'Changed category to $category and refreshed the paging controller.',
                              );
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: <Widget>[
                          FilledButton.icon(
                            onPressed: () {
                              _refreshFeed('Manual refresh requested.');
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text('Refresh'),
                          ),
                          OutlinedButton.icon(
                            onPressed: () {
                              setState(() {
                                _failNextPage = true;
                                _status =
                                    'The next non-initial page load will throw a demo error.';
                              });
                            },
                            icon: const Icon(Icons.warning_amber_outlined),
                            label: const Text('Inject Next-Page Error'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: PagingListener<int, _FeedItem>(
                  controller: _pagingController,
                  builder:
                      (
                        BuildContext context,
                        PagingState<int, _FeedItem> state,
                        NextPageCallback fetchNextPage,
                      ) {
                        return PagedListView<int, _FeedItem>.separated(
                          state: state,
                          fetchNextPage: fetchNextPage,
                          padding: EdgeInsets.zero,
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(height: 12);
                          },
                          builderDelegate: PagedChildBuilderDelegate<_FeedItem>(
                            animateTransitions: true,
                            itemBuilder:
                                (
                                  BuildContext context,
                                  _FeedItem item,
                                  int index,
                                ) {
                                  return _FeedCard(item: item, index: index);
                                },
                            firstPageErrorIndicatorBuilder: (BuildContext context) {
                              return _PagingMessageCard(
                                title: 'Initial Load Failed',
                                description:
                                    'Check the query or refresh the list to retry the first page.',
                                actionLabel: 'Retry',
                                onPressed: _pagingController.fetchNextPage,
                              );
                            },
                            newPageErrorIndicatorBuilder: (BuildContext context) {
                              return _PagingMessageCard(
                                title: 'A Later Page Failed',
                                description:
                                    'The controller kept the already-loaded items. Retry to continue paging.',
                                actionLabel: 'Retry Page',
                                onPressed: _pagingController.fetchNextPage,
                              );
                            },
                            noItemsFoundIndicatorBuilder: (BuildContext context) {
                              return _PagingMessageCard(
                                title: 'No Matching Demos',
                                description:
                                    'Try a different category or remove the search filter.',
                                actionLabel: 'Reset Filters',
                                onPressed: () {
                                  setState(() {
                                    _selectedCategory = 'All';
                                    _searchController.clear();
                                  });
                                  _refreshFeed('Reset all filters.');
                                },
                              );
                            },
                            noMoreItemsIndicatorBuilder:
                                (BuildContext context) {
                                  return const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 18),
                                    child: Center(
                                      child: Text('No more items to load.'),
                                    ),
                                  );
                                },
                          ),
                        );
                      },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.router.replacePath('/'),
        icon: const Icon(Icons.home),
        label: const Text('Home'),
      ),
    );
  }
}

class _FeedItem {
  const _FeedItem({
    required this.id,
    required this.title,
    required this.category,
    required this.summary,
    required this.color,
  });

  final String id;
  final String title;
  final String category;
  final String summary;
  final Color color;
}

class _FeedCard extends StatelessWidget {
  const _FeedCard({required this.item, required this.index});

  final _FeedItem item;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: item.color.withValues(alpha: 0.14),
          foregroundColor: item.color,
          child: Text('${index + 1}'),
        ),
        title: Text(item.title),
        subtitle: Text('${item.category} · ${item.summary}'),
        trailing: Chip(label: Text(item.id)),
      ),
    );
  }
}

class _PagingMessageCard extends StatelessWidget {
  const _PagingMessageCard({
    required this.title,
    required this.description,
    required this.actionLabel,
    required this.onPressed,
  });

  final String title;
  final String description;
  final String actionLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(description),
            const SizedBox(height: 12),
            FilledButton(onPressed: onPressed, child: Text(actionLabel)),
          ],
        ),
      ),
    );
  }
}
