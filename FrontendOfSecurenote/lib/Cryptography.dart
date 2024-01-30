import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:frontendofsecurenote/Model/Encryptnote.dart';
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
    AESMode.cbc;
    final key = Key.fromUtf8(password);
    final iv = IV(Uint8List(16));
    final encrypter = Encrypter(AES(key));
    final encrypted = encrypter.encrypt(data, iv: iv);
    return encrypted.base64;
  }

  String decryptAES(String encryptedData, String password) {
    AESMode.cbc;
    final key = Key.fromUtf8(password);
    final iv = IV(Uint8List(16));
    final encrypter = Encrypter(AES(key));
    final decrypted = encrypter.decrypt64(encryptedData, iv: iv);
    return decrypted;
  }

  List<String> keypair() {
    RSAKeypair rsaKeypair = RSAKeypair.fromRandom();

    final publicKey = rsaKeypair.publicKey;
    final privateKey = rsaKeypair.privateKey;

    String publicKeyString = publicKey.toString();
    String privateKeyString = privateKey.toString();

    List<String> list = [publicKeyString, privateKeyString];

    return list;
  }

  Future<List<Note>?> decryptObjects(
    List<Note> encryptedObjects, String RSAkey) async {
    List<Note> decryptedObjects = [];
    final privateKey = RSAPrivateKey.fromString(RSAkey);

    if (encryptedObjects.isEmpty) {
      return null;
    } else {
      for (var encryptedObject in encryptedObjects) {
        String title = privateKey.decrypt(encryptedObject.title);
        String text = privateKey.decrypt(encryptedObject.text);
        Note note = Note(id: encryptedObject.id, title: title, text: text);
        decryptedObjects.add(note);
      }
      return decryptedObjects;
    }
  }

  Encryptnote encryptNote(Encryptnote note, String key) {
    final publicKey = RSAPublicKey.fromString(key);

    final title = publicKey.encrypt(note.title);

    final text = publicKey.encrypt(note.text);

    Encryptnote encryptdata = Encryptnote(title: title, text: text);

    return encryptdata;
  }

  

}
