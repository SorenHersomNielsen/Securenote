import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:frontendofsecurenote/Pages/CreateAccountPage.dart';
import 'package:frontendofsecurenote/Pages/LoginPage.dart';

class Routes {
  static final router = FluroRouter();

  static var signin = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return Login();
  });

  static var createaccount = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return CreateAccount();
  });

  static dynamic defineRoutes() {
    router.define("signin",
        handler: signin, transitionType: TransitionType.fadeIn);
    router.define("createaccount",
        handler: createaccount, transitionType: TransitionType.fadeIn);
  }
}
