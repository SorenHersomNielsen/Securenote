import 'package:flutter/material.dart';
import 'package:frontendofsecurenote/Model/Note.dart';
import 'package:frontendofsecurenote/Pages/AddNotePage.dart';
import 'package:frontendofsecurenote/Viewmodel.dart';
import 'package:frontendofsecurenote/Pages/NotePage.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<NotesPage> {
  late Future<List<Note>> futureNote;
  final viewmodel = Viewmodel();

  @override
  void initState() {
    super.initState();
    futureNote = viewmodel.getNotes();
  }

  void refreshNotes() {
    setState(() {
      futureNote = viewmodel.getNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Securenote'),
          automaticallyImplyLeading: false,
          elevation: 0.0,
          actions: <Widget>[
            RawMaterialButton(
              child: const Icon(Icons.add),
              padding: const EdgeInsets.all(15.0),
              shape: const CircleBorder(),
              onPressed: () async {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddNotePage(),
                  ),
                );
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: FutureBuilder<List<Note>>(
              future: futureNote,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Note> notes = snapshot.data!;
                  return ListView.builder(
                      itemCount: notes.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          onTap: () async {
                           await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NotePage(
                                          id: notes[index].id,
                                          title: notes[index].title,
                                          text: notes[index].text,
                                        )));
                          },
                          title: Text(notes[index].title),
                        );
                      });
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return CircularProgressIndicator();
              }),
        ));
  }
}
