import 'package:flutter/material.dart';
import 'package:frontendofsecurenote/Cryptography.dart';
import 'package:frontendofsecurenote/Pages/NotesPage.dart';
import 'package:frontendofsecurenote/Viewmodel.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<Login> {
  final viewmodel = Viewmodel();
  late String _username;
  late String _password;
  late int userid;
  final _formkey = GlobalKey<FormState>();

  final snackballfall = const SnackBar(
    content: Text('noget gik galt, prøve igen :('),
    backgroundColor: Colors.red,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          height: 315,
          width: 550,
          color: Colors.white,
          child: Form(
            key: _formkey,
            child: Column(children: <Widget>[
              const Text(
                'Log in',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 40, color: Colors.black),
              ),
              const SizedBox(height: 20),
              TextFormField(
                  key: const Key('username'),
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Brugernavn'),
                  onChanged: (value) {
                    _username = value;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Være venligt at skrive dit brugernavn';
                    }
                    return null;
                  },
                  autofillHints: const [AutofillHints.username],
                  ),
              const SizedBox(height: 20),
              TextFormField(
                key: const Key('password'),
                obscureText: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'password'),
                onChanged: (value) {
                  _password = value;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Være venligt at skrive et password';
                  }
                  return null;
                },
                autofillHints: const [AutofillHints.password],
              ),
              const SizedBox(height: 10),
              SizedBox(
                child: TextButton(
                  key: const Key('button'),
                  style: TextButton.styleFrom(backgroundColor: Colors.black),
                  child: const Text(
                    'Log in',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    if (_formkey.currentState!.validate()) {
                      final passwordhash =
                          cryptography().generateSha256(_password);
                      viewmodel
                          .signin(_username, passwordhash)
                          .then((value) async => {
                                if (value != null)
                                  {
                                    await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => NotesPage(
                                                token: value.token,
                                                userid: value.userid,
                                                password: _password)))
                                  }
                                else
                                  {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackballfall)
                                  }
                              });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(snackballfall);
                    }
                  },
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
