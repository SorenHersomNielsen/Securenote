import 'package:flutter/material.dart';
import 'package:frontendofsecurenote/Cryptography.dart';
import 'package:frontendofsecurenote/Model/Encryptnote.dart';
import 'package:frontendofsecurenote/Model/Keys.dart';
import 'package:frontendofsecurenote/Model/Note.dart';
import 'package:frontendofsecurenote/Pages/AddNotePage.dart';
import 'package:frontendofsecurenote/Pages/NotePage.dart';
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

    for (var note in notes) {
      Note notes = Note(id: note.id, title: note.title, text: note.text);
      listofnotes.add(notes);
    }
    decryptedNotes = await cryptography().decryptObjects(notes, decryptedkey);
    setState(() {
      decryptedNotes = decryptedNotes;
    });
  }

  void _showDialog(BuildContext context, String title, String text) {
    late String username;
    late Keys key;
    late Encryptnote encryptdata;

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('del noter'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  key: const Key('Brugernavn'),
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Brugernavn'),
                  onChanged: (value) {
                    username = value;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Være venligt at skrive et password';
                    }
                    return null;
                  },
                ),
                const Text(
                    'Du kan dele denne noter ved at skrive brugernavn på personen, du ønsker at dele noteren med.')
              ],
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () => Navigator.pop(context, 'Annuller'),
                  child: const Text('Annuller')),
              TextButton(
                onPressed: () async {
                  key =
                      await viewmodel.getKeyByUsername(username, widget.token);
                  encryptdata = Encryptnote(title: title, text: text);
                  encryptdata =
                      cryptography().encryptNote(encryptdata, key.key);
                  Viewmodel().createNote(encryptdata.title, encryptdata.text,
                      widget.token, key.user_id);
                  Navigator.pop(context, 'Annuller');
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Noter er delt"),
                    backgroundColor: Colors.green,
                  ));
                },
                child: const Text('del'),
              )
            ],
          );
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
                              _showDialog(context, decryptedNotes![index].title,
                                  decryptedNotes![index].text);
                            },
                          ),
                          onTap: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NotePage(
                                        id: decryptedNotes![index].id,
                                        title: decryptedNotes![index].title,
                                        text: decryptedNotes![index].text,
                                        token: widget.token,
                                        user_id: widget.userid,
                                        privatekey: key.key)));
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
                        )));
          },
          tooltip: 'Tilføj noter',
          child: const Icon(Icons.add)),
    );
  }
}
