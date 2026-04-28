class Advice {
  final int id;
  final String message;
  final String source;
  final String? author;

  const Advice({
    required this.id,
    required this.message,
    required this.source,
    this.author,
  });
}
