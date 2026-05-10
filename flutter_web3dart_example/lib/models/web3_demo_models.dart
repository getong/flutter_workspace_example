class Web3DemoField {
  const Web3DemoField({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;
}

class Web3DemoSection {
  const Web3DemoSection({
    required this.id,
    required this.title,
    this.subtitle = '',
    this.fields = const [],
    this.lines = const [],
  });

  final String id;
  final String title;
  final String subtitle;
  final List<Web3DemoField> fields;
  final List<String> lines;
}
