import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/app_database.dart';

class TodoHomePage extends StatelessWidget {
  const TodoHomePage({required this.database, super.key});

  final AppDatabase database;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Drift Todo Home')),
      body: StreamBuilder<List<Todo>>(
        stream: database.watchAllTodos(),
        builder: (BuildContext context, AsyncSnapshot<List<Todo>> snapshot) {
          final List<Todo> items = snapshot.data ?? const <Todo>[];
          if (snapshot.connectionState == ConnectionState.waiting &&
              items.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (items.isEmpty) {
            return const _EmptyState();
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemBuilder: (BuildContext context, int index) {
              final Todo todo = items[index];
              return Card(
                child: ListTile(
                  onTap: () => context.go('/todos/${todo.id}'),
                  leading: Checkbox(
                    value: todo.isDone,
                    onChanged: (bool? checked) {
                      database.setTodoDone(
                        id: todo.id,
                        isDone: checked ?? false,
                      );
                    },
                  ),
                  title: Text(
                    todo.title,
                    style: TextStyle(
                      decoration: todo.isDone
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  subtitle: Text(
                    todo.description ?? 'No description',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(height: 12),
            itemCount: items.length,
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/todos/new'),
        icon: const Icon(Icons.add),
        label: const Text('New Todo'),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.inbox_outlined, size: 56),
            const SizedBox(height: 8),
            Text(
              'No todos yet',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'Tap "New Todo" to insert your first Drift record.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
