import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/app_database.dart';

class TodoDetailPage extends StatelessWidget {
  const TodoDetailPage({
    required this.database,
    required this.todoId,
    super.key,
  });

  final AppDatabase database;
  final int todoId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todo Detail')),
      body: StreamBuilder<Todo?>(
        stream: database.watchTodoById(todoId),
        builder: (BuildContext context, AsyncSnapshot<Todo?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              !snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final Todo? todo = snapshot.data;
          if (todo == null) {
            return _MissingTodo(todoId: todoId);
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              Card(
                child: CheckboxListTile(
                  value: todo.isDone,
                  title: const Text('Completed'),
                  subtitle: Text(
                    todo.isDone ? 'This task is done.' : 'This task is active.',
                  ),
                  onChanged: (bool? checked) {
                    database.setTodoDone(id: todo.id, isDone: checked ?? false);
                  },
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        todo.title,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 10),
                      Text(todo.description ?? 'No description'),
                      const SizedBox(height: 16),
                      Text(
                        'Created: ${todo.createdAt.toLocal()}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'ID: ${todo.id}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      persistentFooterButtons: <Widget>[
        TextButton.icon(
          onPressed: () => context.go('/'),
          icon: const Icon(Icons.home_outlined),
          label: const Text('Home'),
        ),
        FilledButton.tonalIcon(
          onPressed: () => context.go('/todos/$todoId/edit'),
          icon: const Icon(Icons.edit_outlined),
          label: const Text('Edit'),
        ),
        FilledButton.icon(
          onPressed: () => _deleteTodo(context),
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.errorContainer,
            foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
          ),
          icon: const Icon(Icons.delete_outline),
          label: const Text('Delete'),
        ),
      ],
    );
  }

  Future<void> _deleteTodo(BuildContext context) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete todo'),
          content: const Text('This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    await database.deleteTodo(todoId);
    if (context.mounted) {
      context.go('/');
    }
  }
}

class _MissingTodo extends StatelessWidget {
  const _MissingTodo({required this.todoId});

  final int todoId;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.search_off, size: 56),
            const SizedBox(height: 8),
            Text('Todo #$todoId was not found.'),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => context.go('/'),
              child: const Text('Back Home'),
            ),
          ],
        ),
      ),
    );
  }
}
