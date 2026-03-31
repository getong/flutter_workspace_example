import 'package:flutter/material.dart';

import 'key_demo_shell.dart';

class PageStorageKeyDemoPage extends StatefulWidget {
  const PageStorageKeyDemoPage({super.key});

  @override
  State<PageStorageKeyDemoPage> createState() => _PageStorageKeyDemoPageState();
}

class _PageStorageKeyDemoPageState extends State<PageStorageKeyDemoPage> {
  final PageStorageBucket _bucket = PageStorageBucket();
  bool _showNewsFeed = true;

  @override
  Widget build(BuildContext context) {
    return KeyDemoShell(
      title: 'PageStorageKey News List',
      description:
          'Scroll the news feed, switch to the saved list, then switch back. '
          'The PageStorageKey keeps the news list scroll position.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SegmentedButton<bool>(
            segments: const <ButtonSegment<bool>>[
              ButtonSegment<bool>(value: true, label: Text('News')),
              ButtonSegment<bool>(value: false, label: Text('Saved')),
            ],
            selected: <bool>{_showNewsFeed},
            onSelectionChanged: (Set<bool> selection) {
              setState(() {
                _showNewsFeed = selection.first;
              });
            },
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Card(
              child: PageStorage(
                bucket: _bucket,
                child: _showNewsFeed
                    ? ListView.builder(
                        key: const PageStorageKey<String>('news-list'),
                        itemCount: 40,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text('Article $index'),
                            subtitle: const Text(
                              'Scroll away and come back to keep this position.',
                            ),
                          );
                        },
                      )
                    : ListView.builder(
                        key: const PageStorageKey<String>('saved-list'),
                        itemCount: 15,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            leading: const Icon(Icons.bookmark_border),
                            title: Text('Saved item ${index + 1}'),
                          );
                        },
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
