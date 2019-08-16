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
    getOpcionesDieta(global.token, "desayunos");
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
                    titulo1("Desayuno En Puntos"),
                    botones_puntos("desayunos"),
                    titulo2("Sugerencias De Desayuno"),
                    list_sugerencias("desayunos"),
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
                child: Stack(
                  children: <Widget>[
                    titulo1("CM En Puntos"),
                    botones_puntos("cm"),
                    titulo2("Sugerencias De CM"),
                    list_sugerencias("cm"),
                  ],
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
                child: Stack(
                  children: <Widget>[
                    titulo1("Almuerzo En Puntos"),
                    botones_puntos("almuerzos"),
                    titulo2("Sugerencias De Almuerzo"),
                    list_sugerencias("almuerzos"),
                  ],
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
                child: Stack(
                  children: <Widget>[
                    titulo1("CV En Puntos"),
                    botones_puntos("cv"),
                    titulo2("Sugerencias De CV"),
                    list_sugerencias("cv"),
                  ],
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
                child: Stack(
                  children: <Widget>[
                    titulo1("Cena En Puntos"),
                    botones_puntos("cenas"),
                    titulo2("Sugerencias De Cena"),
                    list_sugerencias("cenas"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class titulo1 extends StatelessWidget {
  final String titulo;
  titulo1(this.titulo);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 20),
      child: Text(
        titulo,
        style: TextStyle(
          color: hexToColor("#059696"),
          fontWeight: FontWeight.bold,
          fontSize: 17,
        ),
      ),
    );
  }
}

class titulo2 extends StatelessWidget {
  final String titulo;
  titulo2(this.titulo);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 140, left: 20),
      child: Text(
        titulo,
        style: TextStyle(
          color: hexToColor("#059696"),
          fontWeight: FontWeight.bold,
          fontSize: 17,
        ),
      ),
    );
  }
}

class botones_puntos extends StatelessWidget {
  final String tipo;
  botones_puntos(this.tipo);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: 70,
          margin: EdgeInsets.only(top: 50, left: 20),
          child: Image.asset("assets/icons/Recurso_24.png"),
        ),
        Container(
          height: 70,
          margin: EdgeInsets.only(top: 50, left: 105),
          child: Image.asset("assets/icons/Recurso_23.png"),
        ),
        Container(
          height: 70,
          margin: EdgeInsets.only(top: 50, left: 185),
          child: Image.asset("assets/icons/Recurso_22.png"),
        ),
        Container(
          height: 70,
          margin: EdgeInsets.only(top: 50, left: 270),
          child: Image.asset("assets/icons/Recurso_21.png"),
        ),
      ],
    );
  }
}

class list_sugerencias extends StatelessWidget
{
  final String tipo;
  list_sugerencias(this.tipo);
  @override 
  Widget build (BuildContext context)
  {
    return Center(child:Text("Sugerencias"));
  }
}

getOpcionesDieta(_token, _tipo) async {
  try {
    var response = await http.post(global.server + "/aplicacion/api",
        body: {"tipo": "dieta", "token": _token});
    var datos = json.decode(utf8.decode(response.bodyBytes));
    if(datos["status"] == 1)
    {
      for(int i = 0; i < datos["response"].length; i++)
      {        
        var dieta = json.decode(datos["response"][i]["dieta"]);
        print(dieta["dieta"].length);

      }

    }
  } catch (e) {
    print("Error getDieta" + e.toString());
  }
}

class Receta_Dieta 
{
  int id;
  String nombre;
  String azul;
  String verde;
  String naranja;
  String amarillo;

  Receta_Dieta({this.id, this.nombre, this.azul, this.verde, this.naranja, this.amarillo});
}
