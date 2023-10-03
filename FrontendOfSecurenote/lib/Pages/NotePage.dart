import 'package:flutter/material.dart';
import 'package:frontendofsecurenote/Cryptography.dart';
import 'package:frontendofsecurenote/Model/Encryptnote.dart';
import 'package:frontendofsecurenote/Viewmodel.dart';

class NotePage extends StatefulWidget {
  NotePage(
      {Key? key,
      required this.id,
      required this.title,
      required this.text,
      required this.token,
      required this.user_id,
      required this.privatekey})
      : super(key: key);

  final int id;
  final String title;
  final String text;
  final String token;
  final int user_id;
  final String privatekey;

  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  final maxLines = 5;
  late String title = widget.title;
  late String text = widget.text;
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
                  child: Text("Id: ${widget.id}"),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    decoration:
                        InputDecoration(filled: true, hintText: widget.title),
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
              decoration: InputDecoration(filled: true, hintText: widget.text),
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
                  encryptdata = Encryptnote(title: title, text: text);
                  encryptdata = cryptography()
                      .encryptNote(encryptdata, widget.privatekey);

                  Viewmodel().updateNote(widget.id, encryptdata.title,
                      encryptdata.text, widget.id, widget.token);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Noter updateret"),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pop(context);
                },
                child: const Text('Gem'),
              ),
              ElevatedButton(
                onPressed: () async {
                  Viewmodel().deleteNote(widget.id, widget.token);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Noter er slettet"),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pop(context);
                },
                child: const Text('Slet'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
