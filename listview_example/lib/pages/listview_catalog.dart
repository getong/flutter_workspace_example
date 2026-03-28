import 'package:flutter/material.dart';

enum ListViewKind { feed, chats, cards }

class ListViewPageSpec {
  const ListViewPageSpec({
    required this.slug,
    required this.title,
    required this.color,
    required this.icon,
    required this.message,
    required this.kind,
  });

  final String slug;
  final String title;
  final Color color;
  final IconData icon;
  final String message;
  final ListViewKind kind;
}

const List<ListViewPageSpec> listViewPages = <ListViewPageSpec>[
  ListViewPageSpec(
    slug: 'news-feed',
    title: 'News Feed',
    color: Colors.indigo,
    icon: Icons.newspaper,
    message: 'Use ListView.builder for large feeds loaded lazily.',
    kind: ListViewKind.feed,
  ),
  ListViewPageSpec(
    slug: 'chat-list',
    title: 'Chat List',
    color: Colors.teal,
    icon: Icons.chat_bubble_outline,
    message: 'ListTile-based lists are great for chats and contacts.',
    kind: ListViewKind.chats,
  ),
  ListViewPageSpec(
    slug: 'card-stack',
    title: 'Card Stack',
    color: Colors.deepOrange,
    icon: Icons.view_agenda_outlined,
    message: 'ListView with cards makes scannable long-form content.',
    kind: ListViewKind.cards,
  ),
];

ListViewPageSpec? findListViewPage(String slug) {
  for (final ListViewPageSpec page in listViewPages) {
    if (page.slug == slug) {
      return page;
    }
  }
  return null;
}
