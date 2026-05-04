import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

import 'flutter_chat_ui_image_storage.dart';

Future<StoredChatImage> persistPickedChatImage(XFile file) {
  throw UnsupportedError(
    'Local image persistence is not supported on this platform.',
  );
}

Future<String> exportChatImageToSystem({
  required String source,
  String? suggestedName,
}) async {
  return 'Saving images is not supported on this platform.';
}

ImageProvider<Object> chatImageProvider(String source) {
  return NetworkImage(source);
}

String? localChatImagePath(String source) {
  final Uri? uri = Uri.tryParse(source);
  if (uri != null && (uri.scheme == 'http' || uri.scheme == 'https')) {
    return null;
  }
  return null;
}
