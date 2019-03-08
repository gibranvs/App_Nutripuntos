import 'package:flutter/material.dart';
import 'dart:async';
import 'pages/login.dart';

void main() {
  runApp(new MaterialApp(
    home: new MyApp(),
    routes: <String, WidgetBuilder>{
      '/HomeScreen': (BuildContext context) => new LoginPage()
    },
    theme: ThemeData(
      primaryColor: Color(0xFF059696),
      textTheme: TextTheme(
        button: TextStyle(fontSize: 16),
        body1: TextStyle(fontSize: 14),
      ),
    ),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/HomeScreen');
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
          decoration: new BoxDecoration(
            color: const Color(0xFF059696),
            image: new DecorationImage(
              image: new AssetImage("assets/images/fondo.jpg"),
              colorFilter: new ColorFilter.mode(
                  Colors.black.withOpacity(0.2), BlendMode.dstATop),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
              child: Image.asset(
            "assets/images/logo.png",
            width: MediaQuery.of(context).size.width * 0.7,
          ))),
    );
  }
}
