import 'package:flutter/material.dart';
import 'package:frontendofsecurenote/Model/Note.dart';
import 'package:frontendofsecurenote/Viewmodel.dart';


class NotesPage extends StatefulWidget {
  
  const NotesPage({Key? key}) : super(key: key);
  
  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<NotesPage> {

  late Future <List<Note>> futureNote;
  final viewmodel = Viewmodel();

  @override
  void initState(){
    super.initState();
    futureNote = viewmodel.getNotes();
  }

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: Directionality(textDirection: TextDirection.ltr,
      child: Scaffold(
      appBar: AppBar(

      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: FutureBuilder<List<Note>>(
          future: futureNote,
          builder: (context, snapshot) {
            if(snapshot.hasData) {
              List<Note> notes = snapshot.data!;
              return ListView.builder(
                itemCount: notes.length,
                itemBuilder: (BuildContext context, int index) {
                   return GestureDetector(
                  // TODO mangle at lave navi.
                  onTap: () {},
                   child: Container(
                    margin: const EdgeInsets.only(
                        top: 5.0, bottom: 5.0, right: 20.0),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              notes[index].id.toString(),
                               style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 5.0),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.45,
                              child: Text(
                                notes[index].title,
                                style: const TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w600
                              )
                            )
                          )
                        ]
                      )
                    ]
                  )
                  )
                   );
                }
              );
            } else if(snapshot.hasError) {
              return Text('${snapshot.error}');
          }
          return CircularProgressIndicator();
          } 
        ), 
      )
      )
      )
    );
  }
}