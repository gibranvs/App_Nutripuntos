import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:async';
import 'pages/login.dart' as login;
import 'pages/recetas.dart' as recetas;
import 'pages/menu.dart' as menu;
import 'globals.dart' as global;
import 'pages/home.dart';
import 'src/DBManager.dart' as db;

void main() {
  runApp(new MaterialApp(
    title: "Nutripuntos",
    home: new MyApp(),
    //routes: <String, WidgetBuilder>{'/HomeScreen': (BuildContext context) => new login.LoginPage()},
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
    var _duration = new Duration(seconds: 5);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    db.DBManager.instance.getUsuario(context);
  }

  @override
  Future initState() {
    //db.DBManager.instance.deleteAllRegistros();
    //db.DBManager.instance.deleteAllMensajes();
    //db.DBManager.instance.deleteAllRetos();
    super.initState();
    login.fetchDoctores();
    recetas.getRecetas();
    db.DBManager.instance.getUsuario(context);
    //startTime();
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
