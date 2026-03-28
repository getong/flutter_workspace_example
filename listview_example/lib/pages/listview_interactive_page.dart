import 'package:flutter/material.dart';

import 'back_home_button.dart';

class ListViewInteractivePage extends StatefulWidget {
  const ListViewInteractivePage({super.key});

  @override
  State<ListViewInteractivePage> createState() =>
      _ListViewInteractivePageState();
}

class _ListViewInteractivePageState extends State<ListViewInteractivePage> {
  final List<_TaskItem> _tasks = List<_TaskItem>.generate(
    12,
    (int index) => _TaskItem(title: 'Task ${index + 1}', done: index.isEven),
  );

  void _toggleTask(int index, bool? value) {
    setState(() {
      _tasks[index] = _tasks[index].copyWith(done: value ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final int completed = _tasks.where((task) => task.done).length;

    return Scaffold(
      appBar: AppBar(title: const Text('Interactive ListView')),
      body: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.green.shade50,
            child: Text('Completed: $completed / ${_tasks.length}'),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _tasks.length,
              itemBuilder: (BuildContext context, int index) {
                final _TaskItem task = _tasks[index];
                return Card(
                  child: CheckboxListTile(
                    value: task.done,
                    onChanged: (bool? value) => _toggleTask(index, value),
                    title: Text(task.title),
                    subtitle: Text(
                      task.done ? 'Done' : 'Pending',
                      style: TextStyle(
                        color: task.done ? Colors.green : Colors.orange,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      persistentFooterButtons: const <Widget>[BackHomeButton()],
    );
  }
}

class _TaskItem {
  const _TaskItem({required this.title, required this.done});

  final String title;
  final bool done;

  _TaskItem copyWith({String? title, bool? done}) {
    return _TaskItem(title: title ?? this.title, done: done ?? this.done);
  }
}
