class CounterState {
  final int count;
  final bool isLoading;
  final List<String> operations;
  final DateTime lastUpdated;
  final int pendingOperations;
  final String? error;
  final Map<String, dynamic> metadata;

  const CounterState({
    required this.count,
    this.isLoading = false,
    this.operations = const [],
    required this.lastUpdated,
    this.pendingOperations = 0,
    this.error,
    this.metadata = const {},
  });

  CounterState copyWith({
    int? count,
    bool? isLoading,
    List<String>? operations,
    DateTime? lastUpdated,
    int? pendingOperations,
    String? error,
    Map<String, dynamic>? metadata,
  }) {
    return CounterState(
      count: count ?? this.count,
      isLoading: isLoading ?? this.isLoading,
      operations: operations ?? this.operations,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      pendingOperations: pendingOperations ?? this.pendingOperations,
      error: error ?? this.error,
      metadata: metadata ?? this.metadata,
    );
  }

  String get formattedTime => '${lastUpdated.hour.toString().padLeft(2, '0')}:'
      '${lastUpdated.minute.toString().padLeft(2, '0')}:'
      '${lastUpdated.second.toString().padLeft(2, '0')}';
}
