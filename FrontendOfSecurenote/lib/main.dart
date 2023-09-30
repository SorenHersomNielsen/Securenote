import 'package:flutter/material.dart';
import 'package:frontendofsecurenote/Pages/CreateAccountPage.dart';
import 'package:frontendofsecurenote/Routes.dart';

void main() {
  runApp(MaterialApp(home: CreateAccount()));
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    Routes.defineRoutes();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'signin',
      onGenerateRoute: Routes.router.generator,
    );
  }
}
