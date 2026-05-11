import 'package:widget_layout_example2/features/hydrated_bloc_demo/domain/entities/todo_item.dart';

class HydratedTodoState {
  const HydratedTodoState({this.items = const <TodoItem>[], this.draft = ''});

  final List<TodoItem> items;
  final String draft;

  HydratedTodoState copyWith({List<TodoItem>? items, String? draft}) {
    return HydratedTodoState(
      items: items ?? this.items,
      draft: draft ?? this.draft,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'items': items.map((TodoItem e) => e.toJson()).toList(),
    'draft': draft,
  };

  factory HydratedTodoState.fromJson(Map<String, dynamic> json) {
    return HydratedTodoState(
      items: (json['items'] as List<dynamic>? ?? <dynamic>[])
          .map((dynamic e) => TodoItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      draft: json['draft'] as String? ?? '',
    );
  }
}
