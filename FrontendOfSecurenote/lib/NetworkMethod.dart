import 'dart:convert';

import 'package:frontendofsecurenote/Model/Note.dart';
import 'package:http/http.dart' as http;

class NetworkMethod {

  Future<List<Note>> fetchNote() async {
    var uri = Uri.https('localhost:7195','api/Note');
    final response = await http.get(Uri.parse('https://localhost:7195/api/Note'));

    if(response.statusCode == 200) {
      List jsonresponse = jsonDecode(response.body);
      return jsonresponse.map((note) => Note.fromJson(note)).toList();
    } else {
      throw Exception('Failed to load notes');
    }
  }
}