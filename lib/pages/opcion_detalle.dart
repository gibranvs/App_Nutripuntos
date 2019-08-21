import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nutripuntos_app/globals.dart' as global;
import 'package:nutripuntos_app/src/HexToColor.dart';
import 'dart:convert';

class OpcionDetallePage extends StatelessWidget {
  final String token;
  final int index_comida;
  final String opcion;
  OpcionDetallePage(this.token, this.index_comida, this.opcion);

  @override
  Widget build(BuildContext context) {
    getDetallesOpcion(token, index_comida, opcion);
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('DÍA $opcion'),
      ),
      body: Stack(
        children: <Widget>[
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
          Container(
            alignment: Alignment.topCenter,
            child:
                //Text("Hola")),
                list_recetas(index_comida, opcion),
          ),
        ],
      ),
    );
  }
}

class list_recetas extends StatelessWidget {
  final int index_comida;
  final String opcion;

  list_recetas(this.index_comida, this.opcion);

  @override
  Widget build(BuildContext context) {
    return //Center(child: Text("Sugerencias"));
        Container(
      padding: EdgeInsets.only(top: 0),
      child: SingleChildScrollView(
        child: Align(
          alignment: Alignment.center,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
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
                    //print(snapshot.data.length);
                    if (snapshot.data.length > 0) {
                      return new ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return Card(
                              color: hexToColor("#f2f2f2"),
                              margin: EdgeInsets.only(top: 8, bottom: 8),
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
                                            top: 0, left: 47, bottom: 3),
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
                                          width: 180,
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
                                          width: 180,
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

Future<List<Detalle_Opcion>> getDetallesOpcion(
    _token, _index_comida, _dia) async {
  try {
    List<Detalle_Opcion> list = new List<Detalle_Opcion>();
    Valores_Puntos valores_puntos;
    String preparacion;

    var response = await http.post(global.server + "/aplicacion/api",
        body: {"tipo": "dieta", "token": _token});
    var datos = json.decode(utf8.decode(response.bodyBytes));
    //print(datos);
    if (datos["status"] == 1) {
      for (int receta = 0;
          receta < datos["response"]["d$_dia"][_index_comida].length;
          receta++) {
        //print(datos["response"]["d$_dia"][_index_comida][receta]);

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

      String azul = "0";
      String verde = "0";
      String naranja = "0";
      String amarillo = "0";

      if (datos["response"]["d$_dia"][0][0]["azul"] != null) {
        if (datos["response"]["d$_dia"][0][0]["azul"]
                .toString()
                .contains('.') ==
            true) {
          if (datos["response"]["d$_dia"][0][0]["azul"].split('.')[1] == "0")
            azul = datos["response"]["d$_dia"][0][0]["azul"].split('.')[0];
          else
            azul = datos["response"]["d$_dia"][0][0]["azul"].toString();
        } else
          azul = datos["response"]["d$_dia"][0][0]["azul"].toString();
      } else
        azul = "0";

      if (datos["response"]["d$_dia"][0][0]["verde"] != null) {
        if (datos["response"]["d$_dia"][0][0]["verde"]
                .toString()
                .contains('.') ==
            true) {
          if (datos["response"]["d$_dia"][0][0]["verde"].split('.')[1] == "0")
            verde = datos["response"]["d$_dia"][0][0]["verde"].split('.')[0];
          else
            verde = datos["response"]["d$_dia"][0][0]["verde"].toString();
        } else
          verde = datos["response"]["d$_dia"][0][0]["verde"].toString();
      } else
        verde = "0";

      if (datos["response"]["d$_dia"][0][0]["naranja"] != null) {
        if (datos["response"]["d$_dia"][0][0]["naranja"]
                .toString()
                .contains('.') ==
            true) {
          if (datos["response"]["d$_dia"][0][0]["naranja"].split('.')[1] == "0")
            naranja =
                datos["response"]["d$_dia"][0][0]["naranja"].split('.')[0];
          else
            naranja = datos["response"]["d$_dia"][0][0]["naranja"].toString();
        } else
          naranja = datos["response"]["d$_dia"][0][0]["naranja"].toString();
      } else
        naranja = "0";

      if (datos["response"]["d$_dia"][0][0]["amarillo"] != null) {
        if (datos["response"]["d$_dia"][0][0]["amarillo"]
                .toString()
                .contains('.') ==
            true) {
          if (datos["response"]["d$_dia"][0][0]["amarillo"].split('.')[1] ==
              "0")
            amarillo =
                datos["response"]["d$_dia"][0][0]["amarillo"].split('.')[0];
          else
            amarillo = datos["response"]["d$_dia"][0][0]["amarillo"].toString();
        } else
          amarillo = datos["response"]["d$_dia"][0][0]["amarillo"].toString();
      } else
        amarillo = "0";

      valores_puntos = new Valores_Puntos(
          azul: azul, verde: verde, naranja: naranja, amarillo: amarillo);
    }
    return list;
  } catch (e) {
    print("Error getDetallesOpcion " + e.toString());
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
