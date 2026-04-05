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
  const Todo({required this.id, required this.description, required this.completed});

  // All properties should be `final` on our class.
  final String id;
  final String description;
  final bool completed;

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

// The StateNotifier class that will be passed to our StateNotifierProvider.
// This class should not expose state outside of its "state" property, which means
// no public getters/properties!
// The public methods on this class will be what allow the UI to modify the state.
class TodosNotifier extends StateNotifier<List<Todo>> {
  // We initialize the list of todos to an empty list
  TodosNotifier(): super([]);

  // Let's allow the UI to add todos.
  void addTodo(Todo todo) {
    // Since our state is immutable, we are not allowed to do `state.add(todo)`.
    // Instead, we should create a new list of todos which contains the previous
    // items and the new one.
    // Using Dart's spread operator here is helpful!
    state = [...state, todo];
    // No need to call "notifyListeners" or anything similar. Calling "state ="
    // will automatically rebuild the UI when necessary.
  }

  // Let's allow removing todos
  void removeTodo(String todoId) {
    // Again, our state is immutable. So we're making a new list instead of
    // changing the existing list.
    state = [
      for (final todo in state)
      if (todo.id != todoId) todo,
    ];
  }

  // Let's mark a todo as completed
  void toggle(String todoId) {
    state = [
      for (final todo in state)
      // we're marking only the matching todo as completed
      if (todo.id == todoId)
      // Once more, since our state is immutable, we need to make a copy
      // of the todo. We're using our `copyWith` method implemented before
      // to help with that.
      todo.copyWith(completed: !todo.completed)
      else
      // other todos are not modified
      todo,
    ];
  }
}

// Finally, we are using StateNotifierProvider to allow the UI to interact with
// our TodosNotifier class.
final todosProvider = StateNotifierProvider<TodosNotifier, List<Todo>>((ref) {
    TodosNotifier notifierList =TodosNotifier();
    Todo t1 = Todo(id: 'a', description: "1", completed: false);
    Todo t2 = Todo(id: 'b', description: "2", completed: false);
    Todo t3 = Todo(id: 'c', description: "3", completed: false);
    Todo t4 = Todo(id: 'd', description: "4", completed: false);

     notifierList.addTodo(t1);
     notifierList.addTodo(t2);
     notifierList.addTodo(t3);
     notifierList.addTodo(t4);
     return notifierList;
});

class TodoListView extends ConsumerWidget {
  const TodoListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // rebuild the widget when the todo list changes
    List<Todo> todos = ref.watch(todosProvider);

    // Let's render the todos in a scrollable list view
    return ListView(
      children: [
        for (final todo in todos)
        CheckboxListTile(
          value: todo.completed,
          // When tapping on the todo, change its completed status
          onChanged: (value) => ref.read(todosProvider.notifier).toggle(todo.id),
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
          var t = Todo(id: timestamp1.toString(), description: timestamp1.toString(), completed: false);
          list.addTodo(t);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
