import 'dart:typed_data';

enum ImageCompressionFormat { jpeg, png, webp, heic }

class ImageCompressionRequest {
  const ImageCompressionRequest({
    required this.assetPath,
    required this.minWidth,
    required this.minHeight,
    required this.quality,
    required this.format,
    required this.keepExif,
  });

  final String assetPath;
  final int minWidth;
  final int minHeight;
  final int quality;
  final ImageCompressionFormat format;
  final bool keepExif;

  ImageCompressionRequest copyWith({
    String? assetPath,
    int? minWidth,
    int? minHeight,
    int? quality,
    ImageCompressionFormat? format,
    bool? keepExif,
  }) {
    return ImageCompressionRequest(
      assetPath: assetPath ?? this.assetPath,
      minWidth: minWidth ?? this.minWidth,
      minHeight: minHeight ?? this.minHeight,
      quality: quality ?? this.quality,
      format: format ?? this.format,
      keepExif: keepExif ?? this.keepExif,
    );
  }
}

class ImageCompressionResult {
  const ImageCompressionResult({
    required this.originalBytes,
    required this.compressedBytes,
    required this.request,
  });

  final int originalBytes;
  final Uint8List compressedBytes;
  final ImageCompressionRequest request;

  int get compressedSizeBytes => compressedBytes.lengthInBytes;

  int get savedBytes => originalBytes - compressedSizeBytes;

  double get compressionRatio {
    if (originalBytes == 0) {
      return 0;
    }
    return compressedSizeBytes / originalBytes;
  }

  String get originalSizeLabel => _formatBytes(originalBytes);

  String get compressedSizeLabel => _formatBytes(compressedSizeBytes);

  String get savedSizeLabel => _formatBytes(savedBytes);

  String get ratioLabel => '${(compressionRatio * 100).toStringAsFixed(1)}%';
}

String formatImageCompressionFormat(ImageCompressionFormat format) {
  switch (format) {
    case ImageCompressionFormat.jpeg:
      return 'JPEG';
    case ImageCompressionFormat.png:
      return 'PNG';
    case ImageCompressionFormat.webp:
      return 'WebP';
    case ImageCompressionFormat.heic:
      return 'HEIC';
  }
}

String _formatBytes(int bytes) {
  if (bytes.abs() < 1024) {
    return '$bytes B';
  }

  final double kib = bytes / 1024;
  if (kib.abs() < 1024) {
    return '${kib.toStringAsFixed(1)} KB';
  }

  final double mib = kib / 1024;
  return '${mib.toStringAsFixed(2)} MB';
}
