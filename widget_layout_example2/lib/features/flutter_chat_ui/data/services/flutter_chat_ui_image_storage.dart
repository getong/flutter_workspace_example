import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

import 'flutter_chat_ui_image_storage_stub.dart'
    if (dart.library.io) 'flutter_chat_ui_image_storage_io.dart'
    as impl;

class StoredChatImage {
  const StoredChatImage({required this.source, required this.size, this.bytes});

  final String source;
  final int size;
  final Uint8List? bytes;
}

Future<StoredChatImage> persistPickedChatImage(XFile file) {
  return impl.persistPickedChatImage(file);
}

Future<String> exportChatImageToSystem({
  required String source,
  String? suggestedName,
}) {
  return impl.exportChatImageToSystem(
    source: source,
    suggestedName: suggestedName,
  );
}

ImageProvider<Object> chatImageProvider(String source) {
  return impl.chatImageProvider(source);
}

String? localChatImagePath(String source) {
  return impl.localChatImagePath(source);
}
