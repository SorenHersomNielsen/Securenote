import 'dart:html';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:frontendofsecurenote/Model/Note.dart';
import 'dart:convert';
import 'package:hex/hex.dart';

import 'package:crypton/crypton.dart';

class cryptography {
  String generateSha256(String input) {
    var bytes = utf8.encode(input);
    var digest = sha256.convert(bytes);

    return digest.toString();
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

  List<String> keypair() {
    RSAKeypair rsaKeypair =
        RSAKeypair.fromRandom(); // Skift bitLength til din ønskede nøglelængde

    final publicKey = rsaKeypair.publicKey;
    final privateKey = rsaKeypair.privateKey;

    String publicKeyString = publicKey.toString();
    String privateKeyString = privateKey.toString();

    List<String> list = [publicKeyString, privateKeyString];

    return list;
  }

  Future<List<Note>> decryptObjects(List<Note> encryptedObjects, RSAkey) async {
    List<Note> decryptedObjects = [];
    final privateKey = RSAPrivateKey.fromString(RSAkey);

    for (var encryptedObjects in encryptedObjects) {
      String id = privateKey.decrypt(encryptedObjects.id.toString());
      String title = privateKey.decrypt(encryptedObjects.title);
      String text = privateKey.decrypt(encryptedObjects.text);
      int intvalue = int.parse(id);

      Note note = Note(id: intvalue, title: title, text: text);
      decryptedObjects.add(note);
    }

    return decryptedObjects;
  }

  List<String> EncryptedNote(Note note, String key) {
    final publicKey = RSAPublicKey.fromString(key);

    final title = publicKey.encrypt(note.title);
    final text = publicKey.encrypt(note.text);

    List<String> list = [title, text];

    return list;
  }
}
