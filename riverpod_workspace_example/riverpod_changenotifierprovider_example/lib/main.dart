import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Todo {
  Todo({
    required this.id,
    required this.description,
    required this.completed,
  });

  String id;
  String description;
  bool completed;
}

class TodosNotifier extends ChangeNotifier {
  final todos = <Todo>[];

  int get length => todos.length;

  Todo operator [](int index) => todos[index];

  void addTodo(Todo todo) {
    todos.add(todo);
    notifyListeners();
  }

  void removeTodo(String todoId) {
    todos.remove(todos.firstWhere((element) => element.id == todoId));
    notifyListeners();
  }
}

final todosProvider = ChangeNotifierProvider<TodosNotifier>(
  (ref) => TodosNotifier(),
);

class MyHomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todosProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Todos'),
      ),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          final todo = todos[index];

          return CheckboxListTile(
            title: Text(todo.description),
            value: todo.completed,
            onChanged: (value) {
              ref.read(todosProvider).removeTodo(todo.id);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(todosProvider).addTodo(
                Todo(
                  id: '${DateTime.now().millisecondsSinceEpoch}',
                  description: 'Enter a new todo item',
                  completed: false,
                ),
              );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

void main() {
  runApp(ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}
