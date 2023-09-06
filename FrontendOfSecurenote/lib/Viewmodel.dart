import 'package:frontendofsecurenote/Model/Note.dart';
import 'package:frontendofsecurenote/NetworkMethod.dart';

class Viewmodel {
  final networkMethod = NetworkMethod();

  Future<List<Note>> getNotes() {
    return networkMethod.fetchNote();
  }
}
