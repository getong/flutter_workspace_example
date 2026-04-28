import 'dart:io';

String resolvePlatformServePemBaseUrl() {
  if (Platform.isAndroid) {
    return 'http://10.0.2.2:3030';
  }

  return 'http://127.0.0.1:3030';
}
