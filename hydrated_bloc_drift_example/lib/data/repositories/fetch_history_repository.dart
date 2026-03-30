import 'dart:convert';

import 'package:dio/dio.dart';

import '../../domain/fetch_history_entry.dart';
import '../local/app_database.dart';

class FetchHistoryRepository {
  FetchHistoryRepository({required Dio dio, required AppDatabase database})
    : _dio = dio,
      _database = database;

  final Dio _dio;
  final AppDatabase _database;

  Future<FetchHistoryEntry> fetchAndStore(String rawUrl) async {
    final Uri uri = _parseUrl(rawUrl);
    final DateTime fetchedAt = DateTime.now();

    try {
      final Response<String> response = await _dio.getUri<String>(
        uri,
        options: Options(
          responseType: ResponseType.plain,
          validateStatus: (_) => true,
        ),
      );
      final int? statusCode = response.statusCode;
      final bool isSuccess =
          statusCode != null && statusCode >= 200 && statusCode < 300;
      final String responseBody = _normalizeBody(response.data);
      final int historyId = await _database.insertFetchHistory(
        url: uri.toString(),
        statusCode: statusCode,
        isSuccess: isSuccess,
        responseBody: responseBody,
        fetchedAt: fetchedAt,
      );

      return FetchHistoryEntry(
        id: historyId,
        url: uri.toString(),
        statusCode: statusCode,
        isSuccess: isSuccess,
        responseBody: responseBody,
        fetchedAt: fetchedAt,
      );
    } on DioException catch (error) {
      final int? statusCode = error.response?.statusCode;
      final String responseBody = _normalizeBody(
        error.response?.data?.toString() ?? error.message ?? error.toString(),
      );
      final int historyId = await _database.insertFetchHistory(
        url: uri.toString(),
        statusCode: statusCode,
        isSuccess: false,
        responseBody: responseBody,
        fetchedAt: fetchedAt,
      );

      return FetchHistoryEntry(
        id: historyId,
        url: uri.toString(),
        statusCode: statusCode,
        isSuccess: false,
        responseBody: responseBody,
        fetchedAt: fetchedAt,
      );
    }
  }

  Future<List<FetchHistoryEntry>> readHistory() async {
    final List<PersistedFetchHistoryRow> rows = await _database
        .readFetchHistoryRows();
    return rows.map(_mapRow).toList();
  }

  Future<FetchHistoryEntry?> readHistoryEntry(int id) async {
    final PersistedFetchHistoryRow? row = await _database
        .readFetchHistoryRowById(id);
    if (row == null) {
      return null;
    }
    return _mapRow(row);
  }

  FetchHistoryEntry _mapRow(PersistedFetchHistoryRow row) {
    return FetchHistoryEntry(
      id: row.id,
      url: row.url,
      statusCode: row.statusCode,
      isSuccess: row.isSuccess,
      responseBody: row.responseBody,
      fetchedAt: row.fetchedAt,
    );
  }

  Uri _parseUrl(String rawUrl) {
    final Uri? uri = Uri.tryParse(rawUrl.trim());
    if (uri == null ||
        !(uri.isScheme('http') || uri.isScheme('https')) ||
        uri.host.isEmpty) {
      throw const FormatException(
        'Please enter a valid absolute http or https URL.',
      );
    }
    return uri;
  }

  String _normalizeBody(String? body) {
    if (body == null || body.trim().isEmpty) {
      return '(empty response body)';
    }

    final String trimmed = body.trim();
    if (trimmed.startsWith('{') || trimmed.startsWith('[')) {
      try {
        return const JsonEncoder.withIndent('  ').convert(jsonDecode(trimmed));
      } catch (_) {
        return body;
      }
    }
    return body;
  }
}
