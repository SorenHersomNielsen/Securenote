import 'package:frontendofsecurenote/Model/Keys.dart';
import 'package:frontendofsecurenote/Model/Note.dart';
import 'package:frontendofsecurenote/Model/UserResponse.dart';
import 'package:frontendofsecurenote/NetworkMethod.dart';
import 'package:http/http.dart' as http;

class Viewmodel {
  final networkMethod = NetworkMethod();

  Future<List<Note>> getNotes(int user_id, String authorization) {
    return networkMethod.fetchNote(user_id, authorization);
  }

  Future<Note> createNote(
      String title, String text, String token, int user_id) {
    return networkMethod.createNote(title, text, token, user_id);
  }

  Future<Note> updateNote(
      int id, String title, String text, int user_id, String token) {
    return networkMethod.updateNote(id, title, text, user_id, token);
  }

  Future<http.Response> deleteNote(int id, String token) {
    return networkMethod.deleteNote(id, token);
  }

  Future<UserResponse?> createAccount(String username, String password) {
    return networkMethod.CreateAccount(username, password);
  }

  Future<Keys> CreateKey(
      String key, String Aes, String user_id, String authorization) {
    return networkMethod.CreateKey(key, Aes, user_id, authorization);
  }

  Future<UserResponse?> signin(String username, String password) {
    return networkMethod.signin(username, password);
  }

  Future<Keys> getkey(int user_id, String token) {
    return networkMethod.getKey(user_id, token);
  }

  Future<Keys> getKeyByUsername(String username, String token) {
    return networkMethod.getKeyByUsername(username, token);
  }
}
