import 'package:flutter/material.dart';

import 'back_home_button.dart';

class ListViewBasicsPage extends StatelessWidget {
  const ListViewBasicsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ListView Basics')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const <Widget>[
          Text('Example 1: static children'),
          SizedBox(height: 10),
          _InfoTile(
            color: Colors.teal,
            title: 'Profile',
            subtitle: 'Tap avatars, names, and actions in a fixed list.',
            icon: Icons.person_outline,
          ),
          _InfoTile(
            color: Colors.indigo,
            title: 'Messages',
            subtitle: 'Simple way to stack repeated UI sections.',
            icon: Icons.message_outlined,
          ),
          _InfoTile(
            color: Colors.deepOrange,
            title: 'Settings',
            subtitle: 'Great for short menus and grouped options.',
            icon: Icons.settings_outlined,
          ),
          SizedBox(height: 20),
          Text('Example 2: shrinkWrap in nested content'),
          SizedBox(height: 10),
          Card(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Inside a Card',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  _TagList(),
                ],
              ),
            ),
          ),
        ],
      ),
      persistentFooterButtons: const <Widget>[BackHomeButton()],
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.color,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final MaterialColor color;
  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color.shade50,
      child: ListTile(
        leading: Icon(icon, color: color.shade700),
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }
}

class _TagList extends StatelessWidget {
  const _TagList();

  static const List<String> _tags = <String>[
    'Builder',
    'Separated',
    'Horizontal',
    'Infinite Scroll',
    'Pull to Refresh',
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _tags.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: <Widget>[
              const Icon(Icons.label_important_outline, size: 18),
              const SizedBox(width: 8),
              Text(_tags[index]),
            ],
          ),
        );
      },
    );
  }
}
