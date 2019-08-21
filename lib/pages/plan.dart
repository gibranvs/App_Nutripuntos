import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:nutripuntos_app/globals.dart' as global;
import 'package:nutripuntos_app/pages/opcion_detalle.dart';
import 'package:nutripuntos_app/src/HexToColor.dart';
import 'opcion_detalle.dart';

class PlanPage extends StatefulWidget {
  @override
  _PlanPageState createState() => new _PlanPageState();
}

class _PlanPageState extends State<PlanPage> {
  @override
  Widget build(BuildContext context) {
    //getOpcionesDieta(global.token, "desayunos");
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
                    list_sugerencias(0),
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
                    list_sugerencias(1),
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
                    list_sugerencias(2),
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
                    list_sugerencias(3),
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
                    list_sugerencias(4),
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
  final int index_comida;
  list_sugerencias(this.index_comida);
  @override
  Widget build(BuildContext context) {
    return //Center(child: Text("Sugerencias"));
        Container(
      padding: EdgeInsets.only(top: 170),
      child: SingleChildScrollView(
        child: Align(
          alignment: Alignment.center,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            child: FutureBuilder<List<Opciones_Dieta>>(
                future: getOpcionesDieta(global.token),
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
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            new OpcionDetallePage(global.token, index_comida,
                                                (index + 1).toString())));
                              },
                              child: Card(
                                margin: EdgeInsets.only(bottom: 15),
                                elevation: 4,
                                child: Row(
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 5, left: 5, bottom: 3),
                                          child: Container(
                                            margin: EdgeInsets.only(left: 5),
                                            height: 80,
                                            child: new Image.asset(
                                                "assets/icons/Recurso_26.png"),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding:
                                              EdgeInsets.only(top: 0, left: 20),
                                          child: Container(
                                            width: 180,
                                            child: Text(
                                              snapshot.data[index].nombre
                                                  .toString()
                                                  .toUpperCase(),
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: hexToColor("#505050"),
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                    } else {
                      return new Text("No hay sugerencias de comida.",
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
                                padding: EdgeInsets.only(
                                    top: 4, left: 25, bottom: 12),
                                child: Text(
                                    "Error al obtener sugerencias de comida."),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
                }),
          ),
        ),
      ),
    );
  }
}

Future<List<Opciones_Dieta>> getOpcionesDieta(_token) async {
  try {
    List<Opciones_Dieta> list = new List<Opciones_Dieta>();

    var response = await http.post(global.server + "/aplicacion/api",
        body: {"tipo": "dieta", "token": _token});
    var datos = json.decode(utf8.decode(response.bodyBytes));
    //print(datos);
    if (datos["status"] == 1) {
      for (int dias = 0; dias < datos["response"].length; dias++) {
        list.add(Opciones_Dieta(
          id: (dias + 1).toString(),
          nombre: "Día " + (dias + 1).toString(),
        ));
      }
      return list;
    }
  } catch (e) {
    print("Error getOpcionesDieta " + e.toString());
  }
}

class Opciones_Dieta {
  String id;
  String nombre;

  Opciones_Dieta({this.id, this.nombre});
}
