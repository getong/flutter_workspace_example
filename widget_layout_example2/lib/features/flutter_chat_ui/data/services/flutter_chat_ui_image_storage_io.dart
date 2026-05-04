import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:gal/gal.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'flutter_chat_ui_image_storage.dart';

Future<StoredChatImage> persistPickedChatImage(XFile file) async {
  final Uint8List bytes = await file.readAsBytes();
  final Directory baseDirectory = await getApplicationSupportDirectory();
  final Directory imagesDirectory = Directory(
    '${baseDirectory.path}/flutter_chat_ui_images',
  );
  await imagesDirectory.create(recursive: true);

  final String extension = _imageExtension(file);
  final String outputPath =
      '${imagesDirectory.path}/chat_image_'
      '${DateTime.now().microsecondsSinceEpoch}$extension';
  final File outputFile = File(outputPath);
  await outputFile.writeAsBytes(bytes, flush: true);

  return StoredChatImage(
    source: outputFile.path,
    size: bytes.length,
    bytes: bytes,
  );
}

Future<String> exportChatImageToSystem({
  required String source,
  String? suggestedName,
}) async {
  final String? localPath = localChatImagePath(source);
  if (localPath == null) {
    return 'Only local images can be exported.';
  }

  switch (defaultTargetPlatform) {
    case TargetPlatform.android:
    case TargetPlatform.iOS:
      return _saveImageToPhotoLibrary(localPath);
    case TargetPlatform.macOS:
    case TargetPlatform.windows:
    case TargetPlatform.linux:
      return _copyImageToDownloads(localPath, suggestedName: suggestedName);
    case TargetPlatform.fuchsia:
      return 'Saving images is not supported on this platform.';
  }
}

ImageProvider<Object> chatImageProvider(String source) {
  final String? localPath = localChatImagePath(source);
  if (localPath != null) {
    return FileImage(File(localPath));
  }
  return NetworkImage(source);
}

String? localChatImagePath(String source) {
  final Uri? uri = Uri.tryParse(source);
  if (uri != null && uri.scheme == 'file') {
    return uri.toFilePath();
  }

  if (uri != null && uri.hasScheme) {
    return null;
  }

  return source;
}

Future<String> _saveImageToPhotoLibrary(String localPath) async {
  try {
    final bool hasAccess = await Gal.hasAccess();
    if (!hasAccess) {
      final bool granted = await Gal.requestAccess();
      if (!granted) {
        return 'Saving to the system photo library was denied.';
      }
    }

    await Gal.putImage(localPath, album: 'widget_layout_example2');
    return 'Image saved to the system photo library.';
  } on GalException catch (error) {
    return 'Photo library save failed: ${error.type.name}.';
  } catch (error) {
    return 'Photo library save failed: $error';
  }
}

Future<String> _copyImageToDownloads(
  String localPath, {
  String? suggestedName,
}) async {
  final Directory? downloadsDirectory = await getDownloadsDirectory();
  if (downloadsDirectory == null) {
    return 'Downloads folder is not available on this platform.';
  }

  await downloadsDirectory.create(recursive: true);

  final File sourceFile = File(localPath);
  final String extension = _pathExtension(localPath);
  final String baseName = _sanitizeBaseName(
    suggestedName?.trim().isNotEmpty == true ? suggestedName! : 'chat_image',
  );
  final String fileName =
      '${baseName}_${DateTime.now().millisecondsSinceEpoch}$extension';
  final String targetPath = '${downloadsDirectory.path}/$fileName';

  await sourceFile.copy(targetPath);
  return 'Image exported to $targetPath';
}

String _imageExtension(XFile file) {
  final String candidate = file.name.isNotEmpty ? file.name : file.path;
  final int dotIndex = candidate.lastIndexOf('.');
  if (dotIndex == -1) {
    return '.jpg';
  }

  final String extension = candidate.substring(dotIndex).toLowerCase();
  if (extension.length > 8) {
    return '.jpg';
  }

  return extension;
}

String _pathExtension(String path) {
  final int dotIndex = path.lastIndexOf('.');
  if (dotIndex == -1) {
    return '.png';
  }

  final String extension = path.substring(dotIndex);
  return extension.isEmpty ? '.png' : extension;
}

String _sanitizeBaseName(String input) {
  final String sanitized = input
      .replaceAll(RegExp(r'\.[^.]+$'), '')
      .replaceAll(RegExp(r'[\\/:*?"<>|]'), '_')
      .replaceAll(RegExp(r'\s+'), '_');
  return sanitized.isEmpty ? 'chat_image' : sanitized;
}
