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
                    //list_sugerencias("desayunos"),
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
                    //list_sugerencias("cm"),
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
                    //list_sugerencias("almuerzos"),
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
                    //list_sugerencias("cv"),
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
                    //list_sugerencias("cenas"),
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

class list_sugerencias extends StatelessWidget {
  final String tipo;
  list_sugerencias(this.tipo);
  @override
  Widget build(BuildContext context) {
    return //Center(child: Text("Sugerencias"));
        Flexible(
      child: FutureBuilder<List<Receta_Dieta>>(
          future: getOpcionesDieta(global.token, tipo),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  semanticsLabel: "Loading",
                  backgroundColor: hexToColor("#cdcdcd"),
                ),
              );
            } else if (snapshot.hasData) {
              if (snapshot.data.length > 0) {
                return new ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 0,
                        child: Row(
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 15, left: 15, bottom: 15),
                                  child: Container(
                                    margin: EdgeInsets.only(left: 10),
                                    height: 80,
                                    child: new Image.asset(
                                        "assets/icons/Recurso_26.png"),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(top: 0, left: 25),
                                  child: Container(
                                    width: 180,
                                    child: Text(
                                      snapshot.data[index].nombre.toString(),
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: hexToColor("#505050"),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    });
              } else {
                return new Text("No hay sugerencias de $tipo.",
                    style: TextStyle(color: hexToColor("#606060")));
              }
            } else if (snapshot.hasError) {
              return Card(
                child: Row(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding:
                              EdgeInsets.only(top: 4, left: 25, bottom: 12),
                          child: Text("Error al obtener sugerencias de $tipo."),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }
}

Future<List<Receta_Dieta>> getOpcionesDieta(_token, _tipo) async {
  try {
    List<Receta_Dieta> list = new List<Receta_Dieta>();
    int index_comida = 0;
    int counter_opciones = 1;
    switch (_tipo) {
      case 'desayunos':
        index_comida = 1;
        break;
      case 'cm':
        index_comida = 2;
        break;
      case 'almuerzos':
        index_comida = 3;
        break;
      case 'cv':
        index_comida = 4;
        break;
      case 'cenas':
        index_comida = 5;
        break;
    }

    var response = await http.post(global.server + "/aplicacion/api",
        body: {"tipo": "dieta", "token": _token});
    var datos = json.decode(utf8.decode(response.bodyBytes));
    //print(datos);
    if (datos["status"] == 1) {
      String weekday = "d" + DateTime.now().weekday.toString();      
      //print(datos["response"][weekday]);
      for (int opciones = 0;
          opciones < datos["response"][weekday].length;
          opciones++) {
        //print(datos["response"][weekday][opciones]);
        for (int comida = 0;
            comida < datos["response"][weekday][opciones].length;
            comida++) {
          print(datos["response"][weekday][opciones][comida]);
          list.add(Receta_Dieta(
              id: datos["response"][weekday][opciones][comida]["id"],
              cantidad: datos["response"][weekday][opciones]["porcion"],
              unidad: datos["response"][weekday][opciones][comida]["medida"],
              nombre: datos["response"][weekday][opciones][comida]["nombre"],
              azul: datos["response"][weekday][opciones][comida]["azul"],
              verde: datos["response"][weekday][opciones][comida]["verde"],
              naranja: datos["response"][weekday][opciones][comida]
                  ["naranja"],
              amarillo: datos["response"][weekday][opciones][comida]
                  ["amarillo"]));
        }

        if (counter_opciones == index_comida)
          break;
        else
          counter_opciones++;
      }
      return list;
    }
  } catch (e) {
    print("Error getDieta" + e.toString());
  }
}

class Receta_Dieta {
  int id;
  String cantidad;
  String unidad;
  String nombre;
  String azul;
  String verde;
  String naranja;
  String amarillo;

  Receta_Dieta(
      {this.id,
      this.cantidad,
      this.unidad,
      this.nombre,
      this.azul,
      this.verde,
      this.naranja,
      this.amarillo});
}
