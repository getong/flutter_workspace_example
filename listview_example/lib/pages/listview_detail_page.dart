import 'package:flutter/material.dart';

import 'back_home_button.dart';
import 'listview_catalog.dart';

class ListViewDetailPage extends StatelessWidget {
  const ListViewDetailPage({required this.page, super.key});

  final ListViewPageSpec page;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(page.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Text(
              'Dynamic route: /showcase/${page.slug}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: page.color.withAlpha(31),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: page.color, width: 2),
                ),
                child: _buildPreview(page),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(page.message)));
        },
        child: Icon(page.icon),
      ),
      persistentFooterButtons: const <Widget>[BackHomeButton()],
    );
  }

  Widget _buildPreview(ListViewPageSpec spec) {
    switch (spec.kind) {
      case ListViewKind.feed:
        return ListView.builder(
          itemCount: 8,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.indigo.shade300,
                child: const Icon(Icons.article_outlined, color: Colors.white),
              ),
              title: Text('Headline ${index + 1}'),
              subtitle: const Text('This is a feed-like lazy list item.'),
            );
          },
        );
      case ListViewKind.chats:
        return ListView.separated(
          itemCount: 7,
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(height: 1),
          itemBuilder: (BuildContext context, int index) {
            final int unread = (index % 3) + 1;
            return ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text('Teammate ${index + 1}'),
              subtitle: Text('Last message preview for chat ${index + 1}.'),
              trailing: unread == 1
                  ? null
                  : CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      child: Text('$unread'),
                    ),
            );
          },
        );
      case ListViewKind.cards:
        return ListView.separated(
          itemCount: 6,
          separatorBuilder: (BuildContext context, int index) =>
              const SizedBox(height: 10),
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Article ${index + 1}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Cards in ListView help users scan long content blocks.',
                    ),
                  ],
                ),
              ),
            );
          },
        );
    }
  }
}
