import 'dart:typed_data';

import 'package:widget_layout_example2/features/flutter_image_compress/data/services/flutter_image_compress_service.dart';
import 'package:widget_layout_example2/features/flutter_image_compress/domain/entities/image_compression_models.dart';
import 'package:widget_layout_example2/features/flutter_image_compress/domain/repositories/image_compression_repository.dart';

class FlutterImageCompressRepository implements ImageCompressionRepository {
  const FlutterImageCompressRepository({required this.service});

  final FlutterImageCompressService service;

  @override
  Future<ImageCompressionResult> compressAsset(
    ImageCompressionRequest request,
  ) async {
    final Uint8List originalBytes = await service.loadAssetBytes(
      request.assetPath,
    );
    final Uint8List compressedBytes = await service.compressAsset(request);

    return ImageCompressionResult(
      originalBytes: originalBytes.lengthInBytes,
      compressedBytes: compressedBytes,
      request: request,
    );
  }
}
