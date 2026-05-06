import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/app_navigation.dart';

@RoutePage(name: RouteName.refreshIndicator)
class RefreshIndicatorPage extends StatefulWidget {
  const RefreshIndicatorPage({super.key});

  @override
  State<RefreshIndicatorPage> createState() => _RefreshIndicatorPageState();
}

class _RefreshIndicatorPageState extends State<RefreshIndicatorPage> {
  final List<String> _newsItems = <String>[
    'Flutter 3.29 widget notes',
    'Layout constraints quick review',
    'StatefulWidget lifecycle summary',
    'BuildContext navigation tips',
    'Async UI refresh checklist',
  ];

  final List<String> _shortItems = <String>['Only one item', 'Still can pull'];

  int _refreshCount = 0;
  DateTime? _lastRefreshAt;
  bool _isRefreshingPrimary = false;
  bool _isRefreshingShortList = false;

  Future<void> _refreshPrimaryList() async {
    setState(() {
      _isRefreshingPrimary = true;
    });

    await Future<void>.delayed(const Duration(milliseconds: 1100));

    if (!mounted) {
      return;
    }

    final int nextRefreshCount = _refreshCount + 1;
    setState(() {
      _refreshCount = nextRefreshCount;
      _lastRefreshAt = DateTime.now();
      _newsItems.insert(0, 'Pulled new item #$nextRefreshCount');
      _isRefreshingPrimary = false;
    });
  }

  Future<void> _refreshShortList() async {
    setState(() {
      _isRefreshingShortList = true;
    });

    await Future<void>.delayed(const Duration(milliseconds: 900));

    if (!mounted) {
      return;
    }

    setState(() {
      _lastRefreshAt = DateTime.now();
      _shortItems.add('Extra item loaded at ${_formatTime(_lastRefreshAt!)}');
      _isRefreshingShortList = false;
    });
  }

  String _formatTime(DateTime value) {
    final String hour = value.hour.toString().padLeft(2, '0');
    final String minute = value.minute.toString().padLeft(2, '0');
    final String second = value.second.toString().padLeft(2, '0');
    return '$hour:$minute:$second';
  }

  @override
  Widget build(BuildContext context) {
    final String lastRefreshLabel = _lastRefreshAt == null
        ? 'Never refreshed yet'
        : 'Last refresh: ${_formatTime(_lastRefreshAt!)}';

    return Scaffold(
      appBar: AppBar(title: const Text('RefreshIndicator Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'RefreshIndicator wraps a vertical scrollable widget and shows a pull-to-refresh spinner. It is useful when the user should drag down to reload remote data, fetch newer items, or manually retry a request.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Text(
              lastRefreshLabel,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade700),
            ),
            const SizedBox(height: 20),
            _ExampleCard(
              title: 'Default Pull To Refresh',
              description:
                  'Pull down from the top of this list. When the gesture passes the threshold, RefreshIndicator calls onRefresh and waits for the returned Future to finish.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _StatusBanner(
                    icon: Icons.refresh,
                    label: _isRefreshingPrimary
                        ? 'Refreshing list data...'
                        : 'Idle. Pull down to request new content.',
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 320,
                    child: RefreshIndicator(
                      onRefresh: _refreshPrimaryList,
                      child: ListView.separated(
                        itemCount: _newsItems.length,
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(height: 1),
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            leading: CircleAvatar(child: Text('${index + 1}')),
                            title: Text(_newsItems[index]),
                            subtitle: const Text(
                              'Simulates refreshing a feed or result list.',
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'Short Content + AlwaysScrollableScrollPhysics',
              description:
                  'If the list content is shorter than the viewport, the drag gesture may not trigger by default. Adding AlwaysScrollableScrollPhysics keeps pull-to-refresh available even with very little content.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _StatusBanner(
                    icon: Icons.swipe_down,
                    label: _isRefreshingShortList
                        ? 'Refreshing short list...'
                        : 'This demo stays refreshable even when the list is short.',
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 220,
                    child: RefreshIndicator(
                      onRefresh: _refreshShortList,
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: _shortItems.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            leading: const Icon(Icons.label_outline),
                            title: Text(_shortItems[index]),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'When To Use It',
              description:
                  'RefreshIndicator fits pages where the main body is already scrollable and users expect a manual reload gesture.',
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _BulletLine(
                    text:
                        'News feeds, chat lists, order history, and API-backed tables.',
                  ),
                  SizedBox(height: 8),
                  _BulletLine(
                    text:
                        'Retrying after stale data, failed fetches, or expired cache.',
                  ),
                  SizedBox(height: 8),
                  _BulletLine(
                    text:
                        'Works best with ListView, CustomScrollView, or other vertical scrollables.',
                  ),
                  SizedBox(height: 8),
                  _BulletLine(
                    text:
                        'Avoid wrapping non-scrollable content unless you intentionally add scroll physics.',
                  ),
                ],
              ),
            ),
          ],
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

class _ExampleCard extends StatelessWidget {
  const _ExampleCard({
    required this.title,
    required this.description,
    required this.child,
  });

  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(description),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class _StatusBanner extends StatelessWidget {
  const _StatusBanner({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blueGrey.shade100),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: <Widget>[
            Icon(icon, size: 20, color: Colors.blueGrey.shade700),
            const SizedBox(width: 10),
            Expanded(child: Text(label)),
          ],
        ),
      ),
    );
  }
}

class _BulletLine extends StatelessWidget {
  const _BulletLine({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text('• '),
        Expanded(child: Text(text)),
      ],
    );
  }
}
