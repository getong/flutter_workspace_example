import 'package:flutter/material.dart';

import 'key_demo_shell.dart';

class ValueKeyDemoPage extends StatefulWidget {
  const ValueKeyDemoPage({super.key});

  @override
  State<ValueKeyDemoPage> createState() => _ValueKeyDemoPageState();
}

class _ValueKeyDemoPageState extends State<ValueKeyDemoPage> {
  final List<_TodoItem> _todoItems = <_TodoItem>[
    _TodoItem(id: 101, title: 'Write release notes'),
    _TodoItem(id: 102, title: 'Review pull requests'),
    _TodoItem(id: 103, title: 'Update roadmap'),
    _TodoItem(id: 104, title: 'Refine onboarding copy'),
  ];

  void _rotateItems() {
    setState(() {
      final _TodoItem first = _todoItems.removeAt(0);
      _todoItems.add(first);
    });
  }

  void _reverseItems() {
    setState(() {
      _todoItems.replaceRange(
        0,
        _todoItems.length,
        _todoItems.reversed.toList(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyDemoShell(
      title: 'ValueKey Todo List',
      description:
          'These rows are keyed by a stable primitive id. Reordering the list '
          'keeps each todo associated with the same logical item.',
      child: Column(
        children: <Widget>[
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: <Widget>[
              FilledButton.tonal(
                onPressed: _rotateItems,
                child: const Text('Rotate items'),
              ),
              OutlinedButton(
                onPressed: _reverseItems,
                child: const Text('Reverse order'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Card(
              child: ListView.builder(
                itemCount: _todoItems.length,
                itemBuilder: (BuildContext context, int index) {
                  final _TodoItem todo = _todoItems[index];
                  return CheckboxListTile(
                    key: ValueKey<int>(todo.id),
                    value: todo.isDone,
                    title: Text(todo.title),
                    subtitle: Text('Todo id: ${todo.id}'),
                    onChanged: (bool? value) {
                      setState(() {
                        todo.isDone = value ?? false;
                      });
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TodoItem {
  _TodoItem({required this.id, required this.title, this.isDone = false});

  final int id;
  final String title;
  bool isDone;
}
