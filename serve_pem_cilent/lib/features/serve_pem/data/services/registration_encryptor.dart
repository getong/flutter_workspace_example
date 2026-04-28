import 'dart:convert';
import 'dart:typed_data';

import 'package:basic_utils/basic_utils.dart';
import 'package:injectable/injectable.dart';
import 'package:pointycastle/export.dart';

@lazySingleton
class RegistrationEncryptor {
  String encrypt({
    required String publicKeyPem,
    required int maxPlaintextBytes,
    required String clientPublicKey,
    required String password,
  }) {
    final plaintext = jsonEncode(<String, String>{
      'client_public_key': clientPublicKey,
      'password': password,
    });
    final plaintextBytes = Uint8List.fromList(utf8.encode(plaintext));

    if (plaintextBytes.length > maxPlaintextBytes) {
      throw Exception(
        'Registration payload is ${plaintextBytes.length} bytes, but the server limit is $maxPlaintextBytes bytes. Keep the client public key and password shorter.',
      );
    }

    final publicKey = CryptoUtils.rsaPublicKeyFromPem(publicKeyPem);
    final encryptor = OAEPEncoding.withSHA256(RSAEngine());

    encryptor.init(true, PublicKeyParameter<RSAPublicKey>(publicKey));

    final ciphertext = encryptor.process(plaintextBytes);
    return base64Encode(ciphertext);
  }
}
