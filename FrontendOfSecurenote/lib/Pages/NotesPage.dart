import 'package:flutter/material.dart';
import 'package:frontendofsecurenote/Model/Note.dart';
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Directionality(
            textDirection: TextDirection.ltr,
            child: Scaffold(
                appBar: AppBar(
                  title: const Text('Securenote'),
                  elevation: 0.0,
                  actions: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.add),
                      iconSize: 30.0,
                      color: Colors.white,
                      onPressed: () {},
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
                                  onTap: () {
                                    Navigator.push(
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
                ))));
  }
}
