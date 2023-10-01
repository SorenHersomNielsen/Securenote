import 'package:flutter/material.dart';
import 'package:frontendofsecurenote/Cryptography.dart';
import 'package:frontendofsecurenote/Model/Keys.dart';
import 'package:frontendofsecurenote/Model/Note.dart';
import 'package:frontendofsecurenote/Pages/AddNotePage.dart';
import 'package:frontendofsecurenote/Viewmodel.dart';
import 'dart:async';

class NotesPage extends StatefulWidget {
  const NotesPage(
      {Key? key,
      required this.token,
      required this.userid,
      required this.password})
      : super(key: key);

  final String token;
  final int userid;
  final String password;

  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<NotesPage> {
  late Future<List<Note>> encryptednotes;
  late Future<Keys> keys;
  late List<Note>? decryptedNotes = [];
  final viewmodel = Viewmodel();
  late Keys key;
  late String encryptetkey;
  late String decryptedkey = "";
  late List<Note> listofnotes = [];

  @override
  void initState() {
    super.initState();

    getkey();
  }



  void getkey() async {
    keys = viewmodel.getkey(widget.userid, widget.token);
    key = await keys.then((value) => value);
    encryptetkey = key.aes;

    decryptedkey = cryptography().decryptAES(encryptetkey, widget.password);
    _loadNotes();
  }

  void _loadNotes() async {
    encryptednotes = viewmodel.getNotes(widget.userid, widget.token);

    List<Note> notes = await encryptednotes;

    for(var note in notes) {
      Note notes = Note(id: note.id, title: note.title, text: note.title);
      listofnotes.add(notes);
    }
     decryptedNotes =
          await cryptography().decryptObjects(listofnotes, decryptedkey);
          setState(() {
            decryptedNotes = decryptedNotes;
          });
  }

  void refreshNotes() {
    setState(() {
      //futureNote = viewmodel.getNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: FutureBuilder<List<Note>>(
            future: Future.value(decryptedNotes),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (decryptedNotes!.isEmpty) {
                  return const Center(
                    child: Text('Intet data'),
                  );
                } else {
                  return ListView.builder(
                      itemCount: decryptedNotes!.length,
                      itemBuilder: (context, int index) {
                        return ListTile(
                          title: Text(decryptedNotes![index].title),
                          trailing: IconButton(
                            icon: const Icon(Icons.share),
                            onPressed: () {
                              // TODO bygge delning funktion
                            },
                          ),
                          onTap: () async {
                            // TODO bygge vejen til at ændre data;
                          },
                        );
                      });
                }
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return const CircularProgressIndicator();
            }),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddNotePage(
                          token: widget.token,
                          user_id: widget.userid,
                          privatekey: key.key,
                          password: widget.password,
                        )));
          },
          tooltip: 'Tilføj noter',
          child: const Icon(Icons.add)),
    );
  }
}