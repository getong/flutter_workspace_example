import 'package:flutter/foundation.dart';

String defaultHttpBaseUrl() {
  if (kIsWeb) {
    return 'https://127.0.0.1:3000';
  }

  return switch (defaultTargetPlatform) {
    TargetPlatform.android => 'https://10.0.2.2:3000',
    _ => 'https://127.0.0.1:3000',
  };
}

String defaultWebSocketUrl() {
  return webSocketUrlFromHttpBaseUrl(defaultHttpBaseUrl());
}

String normalizeBaseUrl(String baseUrl) {
  return Uri.parse(baseUrl.trim()).replace(path: '').toString();
}

String normalizeWebSocketUrl(String webSocketUrl) {
  final uri = Uri.parse(webSocketUrl.trim());
  final normalizedPath = uri.path.isEmpty ? '/ws' : uri.path;
  return uri.replace(path: normalizedPath).toString();
}

String webSocketUrlFromHttpBaseUrl(String baseUrl) {
  final uri = Uri.parse(baseUrl.trim());
  final scheme = switch (uri.scheme) {
    'https' => 'wss',
    'http' => 'ws',
    _ => uri.scheme,
  };

  return uri.replace(scheme: scheme, path: '/ws').toString();
}

Uri authenticatedWebSocketUri(String baseUrl, {String? accessToken}) {
  final uri = Uri.parse(baseUrl.trim());
  final token = accessToken?.trim();

  if (token == null || token.isEmpty) {
    return uri;
  }

  final query = Map<String, String>.from(uri.queryParameters);
  query['access_token'] = token;
  return uri.replace(queryParameters: query);
}
