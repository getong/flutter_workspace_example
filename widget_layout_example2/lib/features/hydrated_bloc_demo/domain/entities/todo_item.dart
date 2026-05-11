class TodoItem {
  const TodoItem({required this.id, required this.text});

  final String id;
  final String text;

  Map<String, dynamic> toJson() => <String, dynamic>{'id': id, 'text': text};

  factory TodoItem.fromJson(Map<String, dynamic> json) =>
      TodoItem(id: json['id'] as String, text: json['text'] as String);
}
