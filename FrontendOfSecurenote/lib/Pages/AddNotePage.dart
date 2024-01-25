import 'package:flutter/material.dart';
import 'package:frontendofsecurenote/Cryptography.dart';
import 'package:frontendofsecurenote/Model/Encryptnote.dart';
import 'package:frontendofsecurenote/Model/Keys.dart';
import 'package:frontendofsecurenote/Viewmodel.dart';

class AddNotePage extends StatefulWidget {
  const AddNotePage(
      {Key? key,
      required this.token,
      required this.user_id,
      required this.privatekey})
      : super(key: key);

  final String token;
  final int user_id;
  final String privatekey;

  @override
  _AddNotePageState createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final maxLines = 5;
  late String title = "";
  late String text = "";
  late Future<Keys> keys;
  late String keyid;
  late Encryptnote encryptdata;

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
                    encryptdata = Encryptnote(title: title, text: text);
                    encryptdata = cryptography()
                        .encryptNote(encryptdata, widget.privatekey);

                    Viewmodel().createNote(encryptdata.title, encryptdata.text,
                        widget.token, widget.user_id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Noter er oprettet"),
                        backgroundColor: Colors.green,
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
