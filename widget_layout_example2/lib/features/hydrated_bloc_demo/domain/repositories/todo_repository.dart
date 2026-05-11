import 'package:widget_layout_example2/features/hydrated_bloc_demo/domain/entities/todo_item.dart';

abstract interface class TodoRepository {
  List<TodoItem> loadItems();
  void saveItems(List<TodoItem> items);
}
