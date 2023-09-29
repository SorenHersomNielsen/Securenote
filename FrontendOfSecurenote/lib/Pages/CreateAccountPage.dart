import 'package:flutter/material.dart';
import 'package:frontendofsecurenote/Cookie.dart';
import 'package:frontendofsecurenote/Cryptography.dart';
import 'package:frontendofsecurenote/Pages/NotesPage.dart';
import 'package:frontendofsecurenote/Viewmodel.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final viewmodel = Viewmodel();
  final cookie = Cookie();
  late String _username;
  late String _password;
  late String _token;
  late int userid;
  late String encryptAES;
  final _formkey = GlobalKey<FormState>();
  late String publickey;
  late String privateKey;
  late List<String> keypair;

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
                'Opret bruger',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 40, color: Colors.black),
              ),
              const SizedBox(height: 20),
              TextFormField(
                  key: const Key('Brugernavn'),
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
                  }),
              const SizedBox(height: 20),
              TextFormField(
                key: const Key('password'),
                obscureText: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'password'),
                minLines: 16,
                onChanged: (value) {
                  _password = value;
                },
                validator: (value) {
                  if (value!.length < 16) {
                    return null;
                  }
                  return 'Være at skrive et password';
                },
              ),
              const SizedBox(height: 10),
              SizedBox(
                child: TextButton(
                  key: const Key('button'),
                  style: TextButton.styleFrom(backgroundColor: Colors.black),
                  child: const Text(
                    'Opret bruger',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    if (_formkey.currentState!.validate()) {
                      final passwordhash =
                          cryptography().generateSha256(_password);

                      viewmodel
                          .createAccount(_username, passwordhash)
                          .then((value) async => {
                                if (value != null)
                                  {
                                    _token = value.token,
                                    userid = value.userid,
                                    keypair = cryptography().keypair(),
                                    viewmodel.CreateKey(
                                        keypair[0], userid.toString(), _token),
                                    encryptAES = cryptography()
                                        .encryptAES(keypair[0], _password),
                                    cookie.setCookie(
                                        userid.toString(), encryptAES),
                                    await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => NotesPage(
                                              token: _token,
                                              userid: userid,
                                              password: _password),
                                        ))
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
