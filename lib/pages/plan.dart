import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:nutripuntos_app/globals.dart' as global;
import 'package:nutripuntos_app/src/HexToColor.dart';

class PlanPage extends StatefulWidget {
  @override
  _PlanPageState createState() => new _PlanPageState();
}

class _PlanPageState extends State<PlanPage> {
  @override
  Widget build(BuildContext context) {
    getDieta(global.token);
    return MaterialApp(
      home: DefaultTabController(
        length: 5,
        child: Scaffold(
          appBar: AppBar(
            title: TabBar(
              tabs: [
                Tab(
                  text: "Desayunos",
                ),
                Tab(
                  text: "CM",
                ),
                Tab(
                  text: "Almuerzos",
                ),
                Tab(
                  text: "CV",
                ),
                Tab(
                  text: "Cenas",
                ),
              ],
            ),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF35B9C5),
                    Color(0xFF348CB4),
                  ],
                ),
              ),
            ),
          ),
          body: TabBarView(
            children: [
              ///
              /// TAB DESAYUNOS
              ///
              Container(
                decoration: new BoxDecoration(
                  color: const Color(0x00FFCC00),
                  image: new DecorationImage(
                    image: new AssetImage("assets/images/fondo.jpg"),
                    colorFilter: new ColorFilter.mode(
                        Colors.black.withOpacity(0.2), BlendMode.dstATop),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 20, left: 20),
                      child: Text(
                        "Desayuno En Puntos",
                        style: TextStyle(
                          color: hexToColor("#059696"),
                          fontWeight: FontWeight.bold, fontSize: 17,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top:30, left:20),
                      child: Image.asset("assets/icons/Recurso_24.png"),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 140, left: 20),
                      child: Text(
                        "Sugerencias De Desayuno",
                        style: TextStyle(
                          color: hexToColor("#059696"),
                          fontWeight: FontWeight.bold, fontSize: 17,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              ///
              /// TAB CM
              ///
              Container(
                decoration: new BoxDecoration(
                  color: const Color(0x00FFCC00),
                  image: new DecorationImage(
                    image: new AssetImage("assets/images/fondo.jpg"),
                    colorFilter: new ColorFilter.mode(
                        Colors.black.withOpacity(0.2), BlendMode.dstATop),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              ///
              /// TAB ALMUERZOS
              ///
              Container(
                decoration: new BoxDecoration(
                  color: const Color(0x00FFCC00),
                  image: new DecorationImage(
                    image: new AssetImage("assets/images/fondo.jpg"),
                    colorFilter: new ColorFilter.mode(
                        Colors.black.withOpacity(0.2), BlendMode.dstATop),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              ///
              /// TAB CV
              ///
              Container(
                decoration: new BoxDecoration(
                  color: const Color(0x00FFCC00),
                  image: new DecorationImage(
                    image: new AssetImage("assets/images/fondo.jpg"),
                    colorFilter: new ColorFilter.mode(
                        Colors.black.withOpacity(0.2), BlendMode.dstATop),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              /// TAB CENAS
              Container(
                decoration: new BoxDecoration(
                  color: const Color(0x00FFCC00),
                  image: new DecorationImage(
                    image: new AssetImage("assets/images/fondo.jpg"),
                    colorFilter: new ColorFilter.mode(
                        Colors.black.withOpacity(0.2), BlendMode.dstATop),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

getDieta(_token) async {
  try {
    var response = await http.post(global.server + "/aplicacion/api",
        body: {"tipo": "dieta", "token": _token});
    var datos = json.decode(utf8.decode(response.bodyBytes));
    print(datos);
  } catch (e) {
    print("Error getDieta" + e.toString());
  }
}
