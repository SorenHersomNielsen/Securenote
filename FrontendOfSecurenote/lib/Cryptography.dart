import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:frontendofsecurenote/Model/CreateNote.dart';
import 'package:frontendofsecurenote/Model/Note.dart';
import 'dart:convert';

import 'package:crypton/crypton.dart';

class cryptography {
  String generateSha256(String input) {
    var bytes = utf8.encode(input);
    var digest = sha256.convert(bytes);

    return digest.toString();
  }

  static Encrypted? encrypted;

  String encryptAES(String data, String password) {
    final key = Uint8List.fromList(sha256.convert(utf8.encode(password)).bytes);
    final iv = IV(Uint8List(16)); // Initialiseringsvektoren
    final encrypter = Encrypter(AES(Key(key)));
    final encrypted = encrypter.encrypt(data, iv: iv);
    return encrypted.base64;
  }

  String decryptAES(String encryptedData, String password) {
    final key = Uint8List.fromList(sha256.convert(utf8.encode(password)).bytes);
    final iv = IV(Uint8List(16)); // Initialiseringsvektoren
    final encrypter = Encrypter(AES(Key(key)));
    final decrypted = encrypter.decrypt64(encryptedData, iv: iv);
    return decrypted;
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

    for (var encryptedObject in encryptedObjects) {
      String id = privateKey.decrypt(encryptedObject.id.toString());
      String title = privateKey.decrypt(encryptedObject.title);
      String text = privateKey.decrypt(encryptedObject.text);
      int intvalue = int.parse(id);

      Note note = Note(id: intvalue, title: title, text: text);
      decryptedObjects.add(note);
    }

    return decryptedObjects;
  }

  List<String> EncryptedNote(CreateNote note, String key) {
    final publicKey = RSAPublicKey.fromString(key);

    final title = publicKey.encrypt(note.title);
    final text = publicKey.encrypt(note.text);

    List<String> list = [title, text];

    return list;
  }
}
