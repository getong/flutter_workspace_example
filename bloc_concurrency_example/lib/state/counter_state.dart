class CounterState {
  final int count;
  final bool isLoading;
  final List<String> operations;
  final DateTime lastUpdated;
  final int pendingOperations;
  final String? error;

  const CounterState({
    required this.count,
    this.isLoading = false,
    this.operations = const [],
    required this.lastUpdated,
    this.pendingOperations = 0,
    this.error,
  });

  CounterState copyWith({
    int? count,
    bool? isLoading,
    List<String>? operations,
    DateTime? lastUpdated,
    int? pendingOperations,
    String? error,
  }) {
    return CounterState(
      count: count ?? this.count,
      isLoading: isLoading ?? this.isLoading,
      operations: operations ?? this.operations,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      pendingOperations: pendingOperations ?? this.pendingOperations,
      error: error ?? this.error,
    );
  }
}
