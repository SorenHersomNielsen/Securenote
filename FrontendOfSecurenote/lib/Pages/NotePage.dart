import 'package:flutter/material.dart';
import 'package:frontendofsecurenote/Viewmodel.dart';

class NotePage extends StatefulWidget {
  NotePage(
      {Key? key, required this.id, required this.title, required this.text})
      : super(key: key);

  final int id;
  final String title;
  final String text;

  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  final maxLines = 5;
  late String title = widget.title;
  late String text = widget.text;

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
                  child: Text(widget.id.toString()),
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
                onPressed: () {
                  Viewmodel().updateNote(widget.id, title, text);
                  Navigator.pop(context, true);
                },
                child: const Text('Gem'),
              ),
              ElevatedButton(
                onPressed: () {
                  Viewmodel().deleteNote(widget.id);
                  Navigator.pop(context, true);
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
