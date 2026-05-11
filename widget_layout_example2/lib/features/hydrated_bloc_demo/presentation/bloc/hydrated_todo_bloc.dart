import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:widget_layout_example2/features/hydrated_bloc_demo/data/repositories/in_memory_todo_repository.dart';
import 'package:widget_layout_example2/features/hydrated_bloc_demo/domain/entities/todo_item.dart';
import 'package:widget_layout_example2/features/hydrated_bloc_demo/domain/repositories/todo_repository.dart';
import 'package:widget_layout_example2/features/hydrated_bloc_demo/presentation/bloc/hydrated_todo_event.dart';
import 'package:widget_layout_example2/features/hydrated_bloc_demo/presentation/bloc/hydrated_todo_state.dart';

class HydratedTodoBloc
    extends HydratedBloc<HydratedTodoEvent, HydratedTodoState> {
  HydratedTodoBloc({TodoRepository? repository})
    : _repository = repository ?? InMemoryTodoRepository(),
      super(
        HydratedTodoState(
          items: (repository ?? InMemoryTodoRepository()).loadItems(),
        ),
      ) {
    on<DraftChanged>(_onDraftChanged);
    on<TodoAdded>(_onTodoAdded);
    on<TodoRemoved>(_onTodoRemoved);
    on<TodosCleared>(_onTodosCleared);
  }

  final TodoRepository _repository;

  void _onDraftChanged(DraftChanged event, Emitter<HydratedTodoState> emit) {
    emit(state.copyWith(draft: event.draft));
  }

  void _onTodoAdded(TodoAdded event, Emitter<HydratedTodoState> emit) {
    final String text = state.draft.trim();
    if (text.isEmpty) return;

    final String id = DateTime.now().millisecondsSinceEpoch.toString();
    final TodoItem newItem = TodoItem(id: id, text: text);
    final List<TodoItem> updated = List<TodoItem>.of(state.items)..add(newItem);

    _repository.saveItems(updated);
    emit(HydratedTodoState(items: updated));
  }

  void _onTodoRemoved(TodoRemoved event, Emitter<HydratedTodoState> emit) {
    final List<TodoItem> updated = List<TodoItem>.of(state.items)
      ..removeAt(event.index);

    _repository.saveItems(updated);
    emit(HydratedTodoState(items: updated));
  }

  void _onTodosCleared(TodosCleared event, Emitter<HydratedTodoState> emit) {
    _repository.saveItems(<TodoItem>[]);
    emit(const HydratedTodoState());
  }

  @override
  HydratedTodoState? fromJson(Map<String, dynamic> json) {
    return HydratedTodoState.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(HydratedTodoState state_) {
    return state_.toJson();
  }
}
