import 'package:widget_layout_example2/features/hydrated_bloc_demo/domain/entities/todo_item.dart';
import 'package:widget_layout_example2/features/hydrated_bloc_demo/domain/repositories/todo_repository.dart';

class InMemoryTodoRepository implements TodoRepository {
  List<TodoItem> _items = <TodoItem>[];

  @override
  List<TodoItem> loadItems() => List<TodoItem>.unmodifiable(_items);

  @override
  void saveItems(List<TodoItem> items) {
    _items = List<TodoItem>.of(items);
  }
}
