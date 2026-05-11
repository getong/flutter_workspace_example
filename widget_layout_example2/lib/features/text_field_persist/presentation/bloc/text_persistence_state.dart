sealed class TextPersistenceState {
  const TextPersistenceState();

  bool get isLoaded => this is TextPersistenceLoaded;
  String get textOrEmpty => switch (this) {
    TextPersistenceLoaded(:final String text) => text,
    _ => '',
  };
}

final class TextPersistenceInitial extends TextPersistenceState {
  const TextPersistenceInitial();
}

final class TextPersistenceLoaded extends TextPersistenceState {
  const TextPersistenceLoaded({required this.text});

  final String text;
}
