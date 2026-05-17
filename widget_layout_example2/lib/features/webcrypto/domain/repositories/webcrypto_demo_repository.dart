import 'package:widget_layout_example2/features/webcrypto/domain/entities/webcrypto_demo_result.dart';

abstract interface class WebcryptoDemoRepository {
  Future<WebcryptoDemoResult> runDemo({
    required String plaintext,
    required String additionalData,
  });
}
