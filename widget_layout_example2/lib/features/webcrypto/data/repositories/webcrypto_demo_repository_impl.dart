import 'dart:convert';
import 'dart:typed_data';

import 'package:webcrypto/webcrypto.dart';
import 'package:widget_layout_example2/features/webcrypto/domain/entities/webcrypto_demo_result.dart';
import 'package:widget_layout_example2/features/webcrypto/domain/repositories/webcrypto_demo_repository.dart';

class WebcryptoDemoRepositoryImpl implements WebcryptoDemoRepository {
  @override
  Future<WebcryptoDemoResult> runDemo({
    required String plaintext,
    required String additionalData,
  }) async {
    final Uint8List randomBytes = Uint8List(16);
    fillRandomBytes(randomBytes);

    final List<int> plaintextBytes = utf8.encode(plaintext);
    final List<int> additionalDataBytes = utf8.encode(additionalData);

    final List<int> sha256Digest = await Hash.sha256.digestBytes(
      plaintextBytes,
    );

    final HmacSecretKey hmacKey = await HmacSecretKey.generateKey(Hash.sha256);
    final List<int> hmacSignature = await hmacKey.signBytes(plaintextBytes);
    final bool hmacVerified = await hmacKey.verifyBytes(
      hmacSignature,
      plaintextBytes,
    );

    final AesGcmSecretKey aesKey = await AesGcmSecretKey.generateKey(256);
    final Uint8List iv = Uint8List(12);
    fillRandomBytes(iv);
    final List<int> ciphertext = await aesKey.encryptBytes(
      plaintextBytes,
      iv,
      additionalData: additionalDataBytes,
    );
    final List<int> decryptedBytes = await aesKey.decryptBytes(
      ciphertext,
      iv,
      additionalData: additionalDataBytes,
    );

    return WebcryptoDemoResult(
      randomBytesBase64: base64.encode(randomBytes),
      sha256Base64: base64.encode(sha256Digest),
      hmacKeyBase64: base64.encode(await hmacKey.exportRawKey()),
      hmacSignatureBase64: base64.encode(hmacSignature),
      hmacVerified: hmacVerified,
      aesKeyBase64: base64.encode(await aesKey.exportRawKey()),
      ivBase64: base64.encode(iv),
      ciphertextBase64: base64.encode(ciphertext),
      decryptedText: utf8.decode(decryptedBytes),
      additionalData: additionalData,
      plaintext: plaintext,
    );
  }
}
