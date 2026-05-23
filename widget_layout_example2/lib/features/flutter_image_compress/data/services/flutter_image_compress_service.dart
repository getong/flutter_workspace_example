import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:widget_layout_example2/features/flutter_image_compress/domain/entities/image_compression_models.dart';

class FlutterImageCompressService {
  Future<Uint8List> loadAssetBytes(String assetPath) async {
    final ByteData data = await rootBundle.load(assetPath);
    return data.buffer.asUint8List();
  }

  Future<Uint8List> compressAsset(ImageCompressionRequest request) async {
    final Uint8List? result = await FlutterImageCompress.compressAssetImage(
      request.assetPath,
      minWidth: request.minWidth,
      minHeight: request.minHeight,
      quality: request.quality,
      format: _toCompressFormat(request.format),
      keepExif: request.keepExif,
    );

    if (result == null) {
      throw StateError('flutter_image_compress returned null for asset input.');
    }

    return result;
  }

  CompressFormat _toCompressFormat(ImageCompressionFormat format) {
    switch (format) {
      case ImageCompressionFormat.jpeg:
        return CompressFormat.jpeg;
      case ImageCompressionFormat.png:
        return CompressFormat.png;
      case ImageCompressionFormat.webp:
        return CompressFormat.webp;
      case ImageCompressionFormat.heic:
        return CompressFormat.heic;
    }
  }
}
