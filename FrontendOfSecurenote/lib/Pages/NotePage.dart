import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Column(
        children: <Widget>[
          const Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                   'Note'
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'title'
                  ),
                ),
              ),
            ],
          ),
          // Anden linje: Et stort inputfelt
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Expanded(
              child: TextField(
                maxLines: null,
                decoration: InputDecoration(
                  labelText: 'Stort Input Felt',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
          // Tredje linje: To knapper på samme række
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                },
                child: const Text('Gem'),
              ),
              ElevatedButton(
                onPressed: () {
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
