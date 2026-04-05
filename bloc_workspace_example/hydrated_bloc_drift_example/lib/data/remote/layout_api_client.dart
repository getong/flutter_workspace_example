import 'package:dio/dio.dart';

import '../../domain/layout_item.dart';

class LayoutApiClient {
  LayoutApiClient(this._dio);

  final Dio _dio;

  Future<List<LayoutItem>> fetchLayouts({int limit = 8}) async {
    try {
      final Response<List<dynamic>> response = await _dio.get<List<dynamic>>(
        '/posts',
        queryParameters: <String, dynamic>{'_limit': limit},
      );
      return _toLayoutItems(response.data ?? <dynamic>[]);
    } on DioException catch (error) {
      if (error.response?.statusCode != 403) {
        rethrow;
      }
    }

    final Response<Map<String, dynamic>> fallbackResponse = await _dio
        .get<Map<String, dynamic>>(
          'https://dummyjson.com/posts',
          queryParameters: <String, dynamic>{'limit': limit},
        );

    final dynamic posts = fallbackResponse.data?['posts'];
    if (posts is! List) {
      return <LayoutItem>[];
    }
    return _toLayoutItems(posts);
  }

  List<LayoutItem> _toLayoutItems(List<dynamic> data) {
    final List<LayoutItem> items = <LayoutItem>[];
    for (final dynamic item in data) {
      if (item is! Map) {
        continue;
      }
      final Map<String, dynamic> map = Map<String, dynamic>.from(item);
      final int id = (map['id'] as num?)?.toInt() ?? 0;
      final String title = (map['title'] ?? '').toString();
      final String body = (map['body'] ?? map['description'] ?? '').toString();
      final LayoutKind kind = id.isEven ? LayoutKind.column : LayoutKind.row;

      items.add(
        LayoutItem(
          id: id,
          slug: '${kind.name}-$id-${_slugify(title)}',
          title: title,
          message: body,
          kind: kind,
        ),
      );
    }
    return items;
  }

  String _slugify(String value) {
    final String normalized = value
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
    return normalized.isEmpty ? 'item' : normalized;
  }
}
