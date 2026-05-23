import 'package:widget_layout_example2/features/flutter_image_compress/domain/entities/image_compression_models.dart';

abstract interface class ImageCompressionRepository {
  Future<ImageCompressionResult> compressAsset(ImageCompressionRequest request);
}
