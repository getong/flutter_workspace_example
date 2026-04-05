enum LayoutKind { row, column }

class LayoutItem {
  const LayoutItem({
    required this.id,
    required this.slug,
    required this.title,
    required this.message,
    required this.kind,
  });

  final int id;
  final String slug;
  final String title;
  final String message;
  final LayoutKind kind;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'slug': slug,
      'title': title,
      'message': message,
      'kind': kind.name,
    };
  }

  factory LayoutItem.fromJson(Map<String, dynamic> json) {
    final String rawKind = (json['kind'] ?? LayoutKind.row.name).toString();

    return LayoutItem(
      id: (json['id'] as num?)?.toInt() ?? 0,
      slug: (json['slug'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      message: (json['message'] ?? '').toString(),
      kind: rawKind == LayoutKind.column.name
          ? LayoutKind.column
          : LayoutKind.row,
    );
  }
}
