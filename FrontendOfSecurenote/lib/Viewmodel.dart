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

  Future<Note> createNote(String title, String text) {
    return networkMethod.createNote(title, text);
  }

  Future<Note> updateNote(int id, String title, String text) {
    return networkMethod.updateNote(id, title, text);
  }

  Future<http.Response> deleteNote(int id) {
    return networkMethod.deleteNote(id);
  }

  // skal har kigget på alle dem over denne linje
  Future<UserResponse?> createAccount(String username, String password) {
    return networkMethod.CreateAccount(username, password);
  }

  Future<Keys> CreateKey(String key, String user_id, String authorization) {
    return networkMethod.CreateKey(key, user_id, authorization);
  }

  Future<UserResponse?> signin (String username, String password) {
      return networkMethod.signin(username, password);
  }
}
