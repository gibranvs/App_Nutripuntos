import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nutripuntos_app/globals.dart' as global;
import 'package:nutripuntos_app/pages/plan.dart';
import 'package:nutripuntos_app/src/HexToColor.dart';
import '../src/ColorCirclesWidget.dart';
import 'dart:convert';

void main() {
  runApp(OpcionDetallePage("", 0, ""));
}

class OpcionDetallePage extends StatelessWidget {
  final String token;
  final int index_comida;
  final String opcion;

  OpcionDetallePage(this.token, this.index_comida, this.opcion);

  @override
  Widget build(BuildContext context) {
    //getDetallesOpcion(token, index_comida, opcion);
    return MaterialApp(
      home: new Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: AppBar(
            elevation: 4,
            flexibleSpace: Container(
              height: 100,
              decoration: BoxDecoration(
                gradient: new LinearGradient(
                  colors: [
                    Color(0xFF35B9C5),
                    Color(0xFF348CB4)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0.1, 1.0],
                  tileMode: TileMode.clamp,
                ),
              ),
              child: Stack(
                children: <Widget>[
                  ///
                  /// BACK
                  ///
                  GestureDetector(
                    onTap: () {
                      global.widget = null;
                      Navigator.pop(context,
                          MaterialPageRoute(builder: (context) => PlanPage()));
                    },
                    child: Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(top: 40, left: 10),
                      child: Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),

                  ///
                  /// LABEL NOMBRE
                  ///
                  Container(
                    alignment: Alignment.topCenter,
                    margin: new EdgeInsets.only(top: 40.0),
                    child: Text(
                      "Plan de alimentación",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Stack(
          children: <Widget>[
            ///
            /// FONDO
            ///
            Container(
              margin: EdgeInsets.only(top: 0),
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
            /// LABEL TÍTULO
            ///
            label_titulo("Opción $opcion"),

            ///
            /// CIRCLE WIDGET
            ///
            circle_widget(index_comida, opcion),

            ///
            /// LIST RECETAS
            ///
            list_recetas(index_comida, opcion),
          ],
        ),
      ),
    );
  }
}

class label_titulo extends StatelessWidget {
  final String titulo;
  label_titulo(this.titulo);
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.only(left: 20, top: 30),
      child: Text(
        titulo,
        style: TextStyle(
            fontSize: 20,
            color: hexToColor("#059696"),
            fontWeight: FontWeight.bold),
      ),
    );
  }
}

class circle_widget extends StatelessWidget {
  final int index_comida;
  final String opcion;
  circle_widget(this.index_comida, this.opcion);
  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: EdgeInsets.only(
          top: 30, left: MediaQuery.of(context).size.width * 0.52),
      child: FutureBuilder<Valores_Puntos>(
          future:
              getColorCirclesWidgetValues(global.token, index_comida, opcion),
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
              if (snapshot.data != null) {
                return ColorCirclesWidget(
                    snapshot.data.azul,
                    "L", //snapshot.data.verde,
                    snapshot.data.naranja,
                    snapshot.data.amarillo);
              } else {
                return new Text("No hay puntajes.",
                    style: TextStyle(color: hexToColor("#606060")));
              }
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Error al obtener puntajes."),
              );
            }
          }),
    );
  }
}

class list_recetas extends StatelessWidget {
  final int index_comida;
  final String opcion;
  list_recetas(this.index_comida, this.opcion);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 90),
      alignment: Alignment.topCenter,
      padding: EdgeInsets.only(top: 0),
      child: SingleChildScrollView(
        child: Align(
          alignment: Alignment.center,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: FutureBuilder<List<Detalle_Opcion>>(
                future: getDetallesOpcion(global.token, index_comida, opcion),
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
                              color: hexToColor("#f2f2f2"),
                              margin: EdgeInsets.only(top: 0, bottom: 15),
                              elevation: 0,
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
                                              "assets/icons/Recurso_25.png"),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 0, left: 45, bottom: 3),
                                        child: Container(
                                          child: Text(
                                            snapshot.data[index].index,
                                            style: TextStyle(
                                                color: hexToColor("#dedede"),
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 10, bottom: 10, left: 20),
                                        child: Container(
                                          width: 173,
                                          child: Text(
                                            snapshot.data[index].nombre
                                                .toString()
                                                .toUpperCase(),
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: hexToColor("#059696"),
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 0, bottom: 10, left: 20),
                                        child: Container(
                                          width: 173,
                                          child: Text(
                                            snapshot.data[index].preparacion
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: hexToColor("#78c826"),
                                                fontStyle: FontStyle.italic,
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
                      return new Text("No hay sugerencias de comida.",
                          style: TextStyle(color: hexToColor("#606060")));
                    }
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text("Error al obtener sugerencias de comida."),
                    );
                  }
                }),
          ),
        ),
      ),
    );
  }
}

Future<Valores_Puntos> getColorCirclesWidgetValues(
    _token, _index_comida, _dia) async {
  try {
    Valores_Puntos valores_puntos;
    String azul = "0";
    String verde = "0";
    String naranja = "0";
    String amarillo = "0";

    var response = await http.post(global.server + "/aplicacion/api",
        body: {"tipo": "dieta", "token": _token});
    var datos = json.decode(utf8.decode(response.bodyBytes));

    if (datos["status"] == 1) {
      int receta = datos["response"]["d$_dia"][_index_comida].length - 1;

      if (datos["response"]["d$_dia"][_index_comida][receta]["azul"] != null) {
        if (datos["response"]["d$_dia"][_index_comida][receta]["azul"]
                .toString()
                .contains('.') ==
            true) {
          if (datos["response"]["d$_dia"][_index_comida][receta]["azul"]
                  .split('.')[1] ==
              "0")
            azul = datos["response"]["d$_dia"][_index_comida][receta]["azul"]
                .split('.')[0];
          else
            azul = datos["response"]["d$_dia"][_index_comida][receta]["azul"]
                .toString();
        } else
          azul = datos["response"]["d$_dia"][_index_comida][receta]["azul"]
              .toString();
      } else
        azul = "0";

      if (datos["response"]["d$_dia"][_index_comida][receta]["verde"] != null) {
        if (datos["response"]["d$_dia"][_index_comida][receta]["verde"]
                .toString()
                .contains('.') ==
            true) {
          if (datos["response"]["d$_dia"][_index_comida][receta]["verde"]
                  .split('.')[1] ==
              "0")
            verde = datos["response"]["d$_dia"][_index_comida][receta]["verde"]
                .split('.')[0];
          else
            verde = datos["response"]["d$_dia"][_index_comida][receta]["verde"]
                .toString();
        } else
          verde = datos["response"]["d$_dia"][_index_comida][receta]["verde"]
              .toString();
      } else
        verde = "0";

      if (datos["response"]["d$_dia"][_index_comida][receta]["naranja"] !=
          null) {
        if (datos["response"]["d$_dia"][_index_comida][receta]["naranja"]
                .toString()
                .contains('.') ==
            true) {
          if (datos["response"]["d$_dia"][_index_comida][receta]["naranja"]
                  .split('.')[1] ==
              "0")
            naranja = datos["response"]["d$_dia"][_index_comida][receta]
                    ["naranja"]
                .split('.')[0];
          else
            naranja = datos["response"]["d$_dia"][_index_comida][receta]
                    ["naranja"]
                .toString();
        } else
          naranja = datos["response"]["d$_dia"][_index_comida][receta]
                  ["naranja"]
              .toString();
      } else
        naranja = "0";

      if (datos["response"]["d$_dia"][_index_comida][receta]["amarillo"] !=
          null) {
        if (datos["response"]["d$_dia"][_index_comida][receta]["amarillo"]
                .toString()
                .contains('.') ==
            true) {
          if (datos["response"]["d$_dia"][_index_comida][receta]["amarillo"]
                  .split('.')[1] ==
              "0")
            amarillo = datos["response"]["d$_dia"][_index_comida][receta]
                    ["amarillo"]
                .split('.')[0];
          else
            amarillo = datos["response"]["d$_dia"][_index_comida][receta]
                    ["amarillo"]
                .toString();
        } else
          amarillo = datos["response"]["d$_dia"][_index_comida][receta]
                  ["amarillo"]
              .toString();
      } else
        amarillo = "0";

      valores_puntos = new Valores_Puntos(
          azul: azul, verde: verde, naranja: naranja, amarillo: amarillo);

      return valores_puntos;
    }
  } catch (ex) {
    print("Error getColorCirclesWidgetValues: $ex");
  }
}

Future<List<Detalle_Opcion>> getDetallesOpcion(
    _token, _index_comida, _dia) async {
  try {
    List<Detalle_Opcion> list = new List<Detalle_Opcion>();
    String preparacion;

    var response = await http.post(global.server + "/aplicacion/api",
        body: {"tipo": "dieta", "token": _token});
    var datos = json.decode(utf8.decode(response.bodyBytes));
    //print(datos);
    if (datos["status"] == 1) {
      for (int receta = 0;
          receta < datos["response"]["d$_dia"][_index_comida].length;
          receta++) {
        if (datos["response"]["d$_dia"][_index_comida][receta]["receta"] !=
            null) {
          preparacion = datos["response"]["d$_dia"][_index_comida][receta]
                  ["receta"]
              .toString();
        } else {
          preparacion = "";
        }

        list.add(Detalle_Opcion(
          id: datos["response"]["d$_dia"][_index_comida][receta]["id"]
              .toString(),
          index: datos["response"]["d$_dia"][_index_comida][receta]["index"]
              .toString(),
          cantidad: datos["response"]["d$_dia"][_index_comida][receta]
                  ["porcion"]
              .toString(),
          unidad: datos["response"]["d$_dia"][_index_comida][receta]["medida"]
              .toString(),
          nombre: datos["response"]["d$_dia"][_index_comida][receta]["nombre"]
              .toString(),
          preparacion: preparacion,
        ));
      }
    }
    return list;
  } catch (e) {
    print("Error getDetallesOpcion " + e.toString());
    return null;
  }
}

class Valores_Puntos {
  String azul;
  String verde;
  String naranja;
  String amarillo;

  Valores_Puntos({this.azul, this.verde, this.naranja, this.amarillo});
}

class Detalle_Opcion {
  String id;
  String index;
  String nombre;
  String cantidad;
  String unidad;
  String preparacion;

  Detalle_Opcion(
      {this.id,
      this.index,
      this.nombre,
      this.cantidad,
      this.unidad,
      this.preparacion});
}
