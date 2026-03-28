import 'package:flutter/material.dart';

import 'back_home_button.dart';

class ListViewSeparatedPage extends StatelessWidget {
  const ListViewSeparatedPage({super.key});

  static const List<String> _topics = <String>[
    'Getting Started',
    'Scrolling Performance',
    'ListTile Customization',
    'Pagination',
    'Pull To Refresh',
    'State Preservation',
    'Error Handling',
    'Accessibility',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ListView.separated')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _topics.length,
        separatorBuilder: (BuildContext context, int index) =>
            const Divider(height: 1),
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 4),
            leading: Icon(Icons.bookmark_border, color: Colors.cyan.shade700),
            title: Text(_topics[index]),
            subtitle: Text('Section ${index + 1}'),
          );
        },
      ),
      persistentFooterButtons: const <Widget>[BackHomeButton()],
    );
  }
}
