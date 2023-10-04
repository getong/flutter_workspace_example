import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'flutter_riverpod futreprovider example',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: MyWidget());
  }
}

// The state of our StateNotifier should be immutable.
// We could also use packages like Freezed to help with the implementation.
@immutable
class Todo {
  Todo({required this.id, required this.description, required this.completed});

  // All properties should be `final` on our class.
  final String id;
  final String description;
  bool completed;

  // Since Todo is immutable, we implement a method that allows cloning the
  // Todo with slightly different content.
  Todo copyWith({String? id, String? description, bool? completed}) {
    return Todo(
      id: id ?? this.id,
      description: description ?? this.description,
      completed: completed ?? this.completed,
    );
  }
}

// The state of our StateNotifier should be immutable.
// We could also use packages like Freezed to help with the implementation.
class TodosNotifier extends ChangeNotifier {
  List<Todo> todos = [];

  void add(Todo todo) {
    todos.add(todo);
    notifyListeners();
  }

  void remove(String todoId) {
    todos.removeWhere((todo) => todo.id == todoId);
    notifyListeners();
  }

  void toggle(String todoId) {
    final todo = todos.firstWhere((todo) => todo.id == todoId);
    todo.completed = !todo.completed;
    notifyListeners();
  }
}

// Finally, we are using StateNotifierProvider to allow the UI to interact with
// our TodosNotifier class.
final todosProvider =
    ChangeNotifierProvider<TodosNotifier>((ref) => TodosNotifier());

class TodoListView extends ConsumerWidget {
  const TodoListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // rebuild the widget when the todo list changes
    List<Todo> todos = ref.watch(todosProvider).todos;

    return ListView(
      children: [
        for (final todo in todos)
          CheckboxListTile(
            value: todo.completed,
            // When tapping on the todo, change its completed status
            onChanged: (value) =>
                ref.read(todosProvider.notifier).toggle(todo.id),
            title: Text(todo.description),
          ),
      ],
    );
  }
}

class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('flutter_riverpod statenotifierprovider example'),
      ),
      body: TodoListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Access the CounterNotifier and call its increment method
          var list = ref.read(todosProvider.notifier);
          final DateTime date1 = DateTime.now();
          final timestamp1 = date1.millisecondsSinceEpoch;
          var t = Todo(
              id: timestamp1.toString(),
              description: timestamp1.toString(),
              completed: false);
          list.add(t);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
