import 'package:frontendofsecurenote/Model/Note.dart';
import 'package:frontendofsecurenote/NetworkMethod.dart';
import 'package:http/http.dart' as http;

class Viewmodel {
  final networkMethod = NetworkMethod();

  Future<List<Note>> getNotes() {
    return networkMethod.fetchNote();
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
}
