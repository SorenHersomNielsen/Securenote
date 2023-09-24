import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'dart:convert';
import 'package:pointycastle/pointycastle.dart' as pointy;
import 'package:hex/hex.dart';

class cryptography {
  String generateSha256(String input) {
    var bytes = utf8.encode(input);
    var digest = sha256.convert(bytes);

    return digest.toString();
  }

  pointy.AsymmetricKeyPair<pointy.PublicKey, pointy.PrivateKey>
      generateRSAKeyPair() {
    final secureRandom = pointy.SecureRandom('Fortuna')
      ..seed(pointy.KeyParameter(Uint8List(32)));
    final keyGen = pointy.KeyGenerator('RSA')
      ..init(pointy.ParametersWithRandom(
          pointy.RSAKeyGeneratorParameters(BigInt.from(65537), 2048, 64),
          secureRandom));

    final keyPair = keyGen.generateKeyPair();
    return keyPair;
  }

  static Encrypted? encrypted;

  String encryptAES(plaintext, String password) {
    final key = Key.fromUtf8(password);
    String hexString = "1a4b5c8e3f6d7a2b9c4e7f1a2d5b8c9";
    List<int> bytes = HEX.decode(hexString);
    final iv = IV(Uint8List.fromList(bytes));
    final encrypter = Encrypter(AES(key));
    Encrypted? encrypted = encrypter.encrypt(plaintext, iv: iv);
    return encrypted.toString();
  }

  String decryptedAES(text, String password) {
    final key = Key.fromUtf8(password);
    String hexString = "1a4b5c8e3f6d7a2b9c4e7f1a2d5b8c9";
    List<int> bytes = HEX.decode(hexString);
    final iv = IV(Uint8List.fromList(bytes));
    final encrypter = Encrypter(AES(key));
    var decrypted = encrypter.decrypt(encrypted!, iv: iv);
    return decrypted.toString();
  }
}
