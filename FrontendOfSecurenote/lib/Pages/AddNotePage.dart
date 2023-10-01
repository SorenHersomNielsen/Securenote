import 'package:flutter/material.dart';
import 'package:frontendofsecurenote/Cryptography.dart';
import 'package:frontendofsecurenote/Model/CreateNote.dart';
import 'package:frontendofsecurenote/Model/Keys.dart';
import 'package:frontendofsecurenote/Pages/NotesPage.dart';
import 'package:frontendofsecurenote/Viewmodel.dart';

class AddNotePage extends StatefulWidget {
  const AddNotePage({Key? key, required this.token, required this.user_id, required this.privatekey, required this.password })
      : super(key: key);

  final String token;
  final int user_id;
  final String privatekey; 
  final String password;

  @override
  _AddNotePageState createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final maxLines = 5;
  late String title = "";
  late String text = "";
  late Future<Keys> keys;
  late String keyid;
  late CreateNote encryptdata;
  late List<String> encrypteddata;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    decoration:
                        const InputDecoration(filled: true, hintText: "title"),
                    onChanged: (value) {
                      title = value;
                    },
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.all(12),
            height: maxLines * 24.0,
            child: TextField(
              maxLines: maxLines,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(filled: true, hintText: "text"),
              onChanged: (value) {
                text = value;
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(
                onPressed: () async {
                  if (title.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Manglende title"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } else if (text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Manglende tekst"),
                        backgroundColor: Colors.red));
                  } else {
                    encryptdata = CreateNote(title: title, text: text);
                    encrypteddata =
                        cryptography().EncryptedNote(encryptdata, widget.privatekey);
                    Viewmodel().createNote(encrypteddata[0], encrypteddata[1],
                        widget.token, widget.user_id);
                    await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotesPage(token: widget.token, userid: widget.user_id, password: widget.password,),
                  ),
                );
                  }
                },
                child: const Text('Gem'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
