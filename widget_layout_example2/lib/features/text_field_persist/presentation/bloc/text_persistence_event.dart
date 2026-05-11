sealed class TextPersistenceEvent {
  const TextPersistenceEvent();
}

final class TextPersistenceLoadRequested extends TextPersistenceEvent {
  const TextPersistenceLoadRequested();
}

final class TextPersistenceTextChanged extends TextPersistenceEvent {
  const TextPersistenceTextChanged({required this.text});

  final String text;
}
