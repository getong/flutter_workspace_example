enum CustomMultiChildLayoutExampleType {
  profileHeader,
  mediaControls,
  boardingPass,
}

class CustomMultiChildLayoutExample {
  const CustomMultiChildLayoutExample({
    required this.title,
    required this.description,
    required this.api,
    required this.takeaway,
    required this.type,
    required this.previewHeight,
  });

  final String title;
  final String description;
  final String api;
  final String takeaway;
  final CustomMultiChildLayoutExampleType type;
  final double previewHeight;
}
