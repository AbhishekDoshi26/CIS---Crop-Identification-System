import 'package:flutter/material.dart';

import 'home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      routes: <String, WidgetBuilder>{
        '/homepage': (BuildContext context) => HomePage(),
      },
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        accentColor: Colors.lightBlueAccent,
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(fontSize: 30.0),
          hintStyle: TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }
}
