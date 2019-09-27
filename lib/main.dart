import 'package:desapega_jipa_master/ui/signup_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ui/login_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DesapegaJipa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal, //--------cor aqui
      ),
      //home: LoginPage(),
      home: SignupPage(),
    );
  }
}