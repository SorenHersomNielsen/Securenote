import 'package:flutter/material.dart';
import 'package:frontendofsecurenote/Cookie.dart';
import 'package:frontendofsecurenote/Cryptography.dart';
import 'package:frontendofsecurenote/Model/Note.dart';
import 'package:frontendofsecurenote/Pages/AddNotePage.dart';
import 'package:frontendofsecurenote/Viewmodel.dart';

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
  late List<Note> decryptedNotes;
  final viewmodel = Viewmodel();
  late String key;

  @override
  void initState() async {
    super.initState();
    Future<String?> cookie = Cookie().readCookie(widget.userid.toString());
    key = cryptography().decryptedAES(cookie, widget.password);
    encryptednotes = viewmodel.getNotes(widget.userid, widget.token);
  }

  void decrypteddata(String key) async {
    decryptedNotes =
        await cryptography().decryptObjects(await encryptednotes, key);
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
            future: encryptednotes,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                decrypteddata(key);
                return ListView.builder(
                    itemCount: decryptedNotes.length,
                    itemBuilder: (context, int index) {
                      return ListTile(
                        title: Text(decryptedNotes[index].title),
                        trailing: IconButton(
                          icon: const Icon(Icons.share),
                          onPressed: () {},
                        ),
                        onTap: () async {},
                      );
                    });
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              } else if (snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('Intet data'),
                );
              }
              return CircularProgressIndicator();
            }),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddNotePage()));
          },
          tooltip: 'Tilføj noter',
          child: const Icon(Icons.add)),
    );
  }
}
