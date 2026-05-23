import 'package:flutter/foundation.dart';
import 'package:widget_layout_example2/features/flutter_image_compress/domain/entities/image_compression_models.dart';
import 'package:widget_layout_example2/features/flutter_image_compress/domain/repositories/image_compression_repository.dart';

class FlutterImageCompressViewModel extends ChangeNotifier {
  FlutterImageCompressViewModel({
    required ImageCompressionRepository repository,
  }) : _repository = repository;

  final ImageCompressionRepository _repository;

  ImageCompressionRequest _request = const ImageCompressionRequest(
    assetPath: 'assets/images/image_module_demo.png',
    minWidth: 900,
    minHeight: 600,
    quality: 72,
    format: ImageCompressionFormat.jpeg,
    keepExif: false,
  );

  ImageCompressionRequest get request => _request;

  ImageCompressionResult? _result;
  ImageCompressionResult? get result => _result;

  bool _isCompressing = false;
  bool get isCompressing => _isCompressing;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> compress() async {
    _isCompressing = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _result = await _repository.compressAsset(_request);
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isCompressing = false;
      notifyListeners();
    }
  }

  void updateQuality(double value) {
    _request = _request.copyWith(quality: value.round());
    notifyListeners();
  }

  void updateMaxSize(double value) {
    final int size = value.round();
    _request = _request.copyWith(minWidth: size, minHeight: size);
    notifyListeners();
  }

  void updateFormat(ImageCompressionFormat format) {
    _request = _request.copyWith(format: format);
    notifyListeners();
  }

  void updateKeepExif(bool keepExif) {
    _request = _request.copyWith(keepExif: keepExif);
    notifyListeners();
  }
}
