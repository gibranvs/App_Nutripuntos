import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nutripuntos_app/pages/home.dart';
import 'dart:async';
import 'pages/login.dart';
import 'globals.dart' as global;
import 'src/DBManager.dart' as db;

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  runApp(new MaterialApp(
    title: "Nutripuntos",
    home: new MyApp(),
    debugShowCheckedModeBanner: false,    
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
  @override
  Future<void> checkDevice() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    try {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      print(androidInfo.device);
      global.dispositivo_utilizado = "android";
    } catch (_) {}
    try {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      print(iosInfo.name);
      global.dispositivo_utilizado = "ios";
    } catch (_) {}
  }

  void splashEnd() {
    Timer.periodic(Duration(seconds: 4), (timer) {
      if (timer.tick > 0) timer.cancel();
      db.DBManager.instance.getUsuarioLogueado().then((usuario) {
        if (usuario != null) {
          setState(() {
            global.usuario = usuario;
          });
          readFileContent().then((_) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          });
        } else {
          global.user_exist = false;
          fetchDoctores().then((_) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          });
        }
      });
    });
  }

  @override
  void initState() {
    //db.DBManager.instance.deleteAllRegistros();
    //db.DBManager.instance.deleteAllMensajes();
    //db.DBManager.instance.deleteAllRetos();
    super.initState();
    checkDevice().then((_){
      splashEnd();
    });        
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
          ),
        ),
      ),
    );
  }
}
