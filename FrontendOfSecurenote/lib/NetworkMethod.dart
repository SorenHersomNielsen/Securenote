import 'dart:convert';
import 'package:frontendofsecurenote/Model/Note.dart';
import 'package:http/http.dart' as http;

class NetworkMethod {
  Future<List<Note>> fetchNote() async {
    final response =
        await http.get(Uri.parse('https://localhost:7195/api/Note'));

    if (response.statusCode == 200) {
      List jsonresponse = jsonDecode(response.body);
      return jsonresponse.map((note) => Note.fromJson(note)).toList();
    } else {
      throw Exception('Failed to load notes');
    }
  }

  Future<Note> createNote(String title, String text) async {
    final response =
        await http.post(Uri.parse("https://localhost:7195/api/Note"),
            headers: <String, String>{
              'Content-Type': 'application/json',
            },
            body: jsonEncode(<String, String>{'title': title, 'text': text}));
    if (response.statusCode == 201) {
      return Note.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failded to create note");
    }
  }

  Future<Note> updateNote(int id, String title, String text) async {
    var body = jsonEncode({"title": title, "text": text});

    final response =
        await http.put(Uri.parse("https://localhost:7195/api/Note/$id"),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: body);

    if (response.statusCode == 200) {
      return Note.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("fail to update note");
    }
  }

  Future<http.Response> deleteNote(int id) async {
    final http.Response response =
        await http.delete(Uri.parse("https://localhost:7195/api/Note/$id"));

    return response;
  }
}
