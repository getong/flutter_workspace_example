import 'dart:io';

String resolvePlatformServePemBaseUrl() {
  const override = String.fromEnvironment('SERVE_PEM_BASE_URL');
  if (override.isNotEmpty) {
    return override;
  }

  if (Platform.isAndroid) {
    return 'https://10.0.2.2:3030';
  }

  return 'https://127.0.0.1:3030';
}
