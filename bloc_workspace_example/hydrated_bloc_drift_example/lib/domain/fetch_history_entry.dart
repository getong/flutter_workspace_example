class FetchHistoryEntry {
  const FetchHistoryEntry({
    required this.id,
    required this.url,
    required this.statusCode,
    required this.isSuccess,
    required this.responseBody,
    required this.fetchedAt,
  });

  final int id;
  final String url;
  final int? statusCode;
  final bool isSuccess;
  final String responseBody;
  final DateTime fetchedAt;
}
