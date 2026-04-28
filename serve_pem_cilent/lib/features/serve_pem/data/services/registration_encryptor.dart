import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:basic_utils/basic_utils.dart';
import 'package:injectable/injectable.dart';
import 'package:pointycastle/export.dart';

import '../../domain/entities/encrypted_auth_payload.dart';
import '../../domain/entities/public_key_info.dart';

@lazySingleton
class RegistrationEncryptor {
  EncryptedAuthPayload encrypt({
    required PublicKeyInfo publicKeyInfo,
    required String clientPublicKey,
    required String password,
  }) {
    final plaintext = jsonEncode(<String, String>{
      'client_public_key': clientPublicKey,
      'password': password,
    });
    final plaintextBytes = Uint8List.fromList(utf8.encode(plaintext));

    const aesKeyBytes = 32;
    if (publicKeyInfo.maxWrappedKeyPlaintextBytes < aesKeyBytes) {
      throw Exception(
        'Server RSA wrapping limit is ${publicKeyInfo.maxWrappedKeyPlaintextBytes} bytes, which is too small for a 32-byte AES key.',
      );
    }

    final publicKey = CryptoUtils.rsaPublicKeyFromPem(
      publicKeyInfo.publicKeyPem,
    );
    final encryptor = OAEPEncoding.withSHA256(RSAEngine());
    encryptor.init(true, PublicKeyParameter<RSAPublicKey>(publicKey));

    final contentEncryptionKey = _randomBytes(aesKeyBytes);
    final wrappedContentKey = encryptor.process(contentEncryptionKey);
    if (wrappedContentKey.length != publicKeyInfo.wrappedKeyBytes) {
      throw Exception(
        'Wrapped AES key length ${wrappedContentKey.length} did not match the server metadata value ${publicKeyInfo.wrappedKeyBytes}.',
      );
    }

    final nonceBytes = _randomBytes(publicKeyInfo.nonceBytes);
    final gcmCipher = GCMBlockCipher(AESEngine())
      ..init(
        true,
        AEADParameters(
          KeyParameter(contentEncryptionKey),
          128,
          nonceBytes,
          Uint8List(0),
        ),
      );
    final ciphertext = gcmCipher.process(plaintextBytes);

    return EncryptedAuthPayload(
      wrappedKeyBase64: base64Encode(wrappedContentKey),
      nonceBase64: base64Encode(nonceBytes),
      ciphertextBase64: base64Encode(ciphertext),
    );
  }

  Uint8List _randomBytes(int length) {
    final random = Random.secure();
    return Uint8List.fromList(
      List<int>.generate(length, (_) => random.nextInt(256)),
    );
  }
}
