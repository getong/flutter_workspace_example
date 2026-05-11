sealed class HydratedTodoEvent {
  const HydratedTodoEvent();
}

final class DraftChanged extends HydratedTodoEvent {
  const DraftChanged({required this.draft});

  final String draft;
}

final class TodoAdded extends HydratedTodoEvent {
  const TodoAdded();
}

final class TodoRemoved extends HydratedTodoEvent {
  const TodoRemoved({required this.index});

  final int index;
}

final class TodosCleared extends HydratedTodoEvent {
  const TodosCleared();
}
