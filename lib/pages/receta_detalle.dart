import 'package:flutter/material.dart';
import '../src/HexToColor.dart';
import '../src/ColorCirclesWidget.dart';
import 'dart:convert';
import 'recetas.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:http/http.dart' as http;
import 'package:nutripuntos_app/globals.dart' as global;

void main() {
  runApp(RecetaPage(null, 0, ""));
}

class RecetaPage extends StatelessWidget {
  final BuildContext _context;
  final int idReceta;
  final String nombreReceta;
  RecetaPage(this._context, this.idReceta, this.nombreReceta);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(330.0),
            child: AppBar(
              flexibleSpace: Container(
                height: 350,
                color: Color(0xFF059696),
                child: Stack(
                  children: <Widget>[
                    ///
                    /// BACK
                    ///
                    boton_back(_context),

                    ///
                    /// IMAGE
                    ///
                    imagen_cabecera(),

                    ///
                    /// LABEL NOMBRE
                    ///
                    label_nombre(nombreReceta),

                    ///
                    /// WIDGET
                    ///
                    widget_puntos(idReceta),
                  ],
                ),
              ),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(0),
                child: Container(
                  margin: new EdgeInsets.only(top: 250.0),
                  decoration: BoxDecoration(
                    gradient: new LinearGradient(
                        colors: [
                          hexToColor("#35b9c5"),
                          hexToColor("#34b6a4"),
                          hexToColor("#348cb4")
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: [0.1, 0.5, 1.0],
                        tileMode: TileMode.clamp),
                  ),
                  child: TabBar(
                    tabs: [
                      Tab(
                        text: "Ingredientes",
                      ),
                      Tab(
                        text: "Preparación",
                      ),
                    ],
                    indicatorColor: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          body: TabBarView(
            children: [
              ///
              /// INGREDIENTES
              ///
              card_ingredientes(idReceta),

              ///
              /// PREPARACIÓN
              ///
              card_preparacion(idReceta),
            ],
          ),
        ),
      ),
    );
  }
}

class boton_back extends StatelessWidget {
  BuildContext _context;
  boton_back(this._context);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //print("back");
        global.widget = null;
        Navigator.pop(
            _context, MaterialPageRoute(builder: (context) => RecetasPage()));
      },
      child: Container(
        alignment: Alignment.topLeft,
        margin: EdgeInsets.only(top: 30, left: 10),
        child: Icon(Icons.arrow_back, color: Colors.white),
      ),
    );
  }
}

class imagen_cabecera extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      margin: new EdgeInsets.only(top: 50.0),
      decoration: BoxDecoration(
        image: new DecorationImage(
          image: new AssetImage("assets/icons/Recurso_25.png"),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class label_nombre extends StatelessWidget {
  final String nombreReceta;
  label_nombre(this.nombreReceta);
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      margin: new EdgeInsets.only(top: 175.0),
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Text(
        nombreReceta,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}

class widget_puntos extends StatelessWidget {
  final int idReceta;
  widget_puntos(this.idReceta);
  @override
  Widget build(BuildContext context) {
    return new Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 150),
      child: FutureBuilder<Valores_Puntos>(
          future: getColorCirclesWidgetValues(idReceta),
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
                    snapshot.data.verde,
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

class card_ingredientes extends StatelessWidget {
  final int idReceta;
  card_ingredientes(this.idReceta);
  @override
  Widget build(BuildContext context) {
    print(idReceta);
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 0),
          decoration: new BoxDecoration(
            //color: Colors.white,
            image: new DecorationImage(
              image: new AssetImage("assets/images/fondo.jpg"),
              colorFilter: new ColorFilter.mode(
                  Colors.black.withOpacity(0.2), BlendMode.dstATop),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Column(
          children: <Widget>[
            Flexible(
              child: FutureBuilder<List<Ingrediente>>(
                  future: getIngredientesReceta(idReceta),
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
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          elevation: 0,
                          margin: EdgeInsets.all(20),
                          color: hexToColor("#f2f2f2"),
                          child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.all(15),
                                      child: SizedBox(
                                        width: 270,
                                        child: AutoSizeText(
                                          snapshot.data[index].cantidad +
                                              " " +
                                              snapshot.data[index].unidad
                                                  .toString() +
                                              " de " +
                                              snapshot.data[index].nombre
                                                  .toString(),
                                          maxLines: 3,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: hexToColor("#78c826"),
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                        );
                      } else {
                        return new Text("No existen ingredientes.",
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
                                  child: Text("Error al obtener ingredientes."),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }
                  }),
            ),
          ],
        )
      ],
    );
  }
}

class card_preparacion extends StatelessWidget {
  final int idReceta;
  card_preparacion(this.idReceta);
  @override
  Widget build(BuildContext context) {
    print(idReceta);
    return Container(
      margin: EdgeInsets.only(top: 0),
      decoration: new BoxDecoration(
        color: Colors.white,
        image: new DecorationImage(
          image: new AssetImage("assets/images/fondo.jpg"),
          colorFilter: new ColorFilter.mode(
              Colors.black.withOpacity(0.2), BlendMode.dstATop),
          fit: BoxFit.cover,
        ),
      ),
      child: FutureBuilder<Detalle_Receta>(
          future: getDetallesReceta(idReceta),
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
                return new Container(
                  //width: MediaQuery.of(context).size.width * 0.8,
                  padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    elevation: 0,
                    color: hexToColor("#f2f2f2"),
                    child: Container(
                      padding: EdgeInsets.all(15),
                      child: Text(
                        snapshot.data.preparacion.toString(),
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            color: hexToColor("#78c826"),
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                    ),
                  ),
                );
              } else {
                return new Text("No existe preparación para la receta.",
                    style: TextStyle(color: hexToColor("#606060")));
              }
            } else if (snapshot.hasError) {
              return new Text("Error al obtener preparación para la receta.",
                  style: TextStyle(color: hexToColor("#606060")));
            }
          }),
    );
  }
}

Future<Valores_Puntos> getColorCirclesWidgetValues(_idReceta) async {
  try {
    var response = await http.post(global.server + "/aplicacion/api",
        body: {"tipo": "detalle_recetas", "id_receta": _idReceta.toString()});
    var datos = json.decode(utf8.decode(response.bodyBytes));
    //print(datos);

    if (datos["status"] == 1) {
      Valores_Puntos valores_puntos;
      var azul;
      var verde;
      var naranja;
      var amarillo;
      if (datos["response"][0]["azul"] != null) {
        if (datos["response"][0]["azul"].split('.')[1] == "0")
          azul = datos["response"][0]["azul"].split('.')[0];
        else
          azul = datos["response"][0]["azul"];
      } else
        azul = "0";

      if (datos["response"][0]["verde"] != null) {
        if (datos["response"][0]["verde"].split('.')[1] == "0")
          verde = datos["response"][0]["verde"].split('.')[0];
        else
          verde = datos["response"][0]["verde"];
      } else
        verde = "0";

      if (datos["response"][0]["naranja"] != null) {
        if (datos["response"][0]["naranja"].split('.')[1] == "0")
          naranja = datos["response"][0]["naranja"].split('.')[0];
        else
          naranja = datos["response"][0]["naranja"];
      } else
        naranja = "0";

      if (datos["response"][0]["amarillo"] != null) {
        if (datos["response"][0]["amarillo"].split('.')[1] == "0")
          amarillo = datos["response"][0]["amarillo"].split('.')[0];
        else
          amarillo = datos["response"][0]["amarillo"];
      } else
        amarillo = "0";

      return valores_puntos = new Valores_Puntos(
          azul: azul, verde: verde, naranja: naranja, amarillo: amarillo);
    }
  } catch (e) {
    print("Error getColorCirclesWidgetValues: " + e.toString());
  }
}

Future<List<Ingrediente>> getIngredientesReceta(_idReceta) async {
  try {
    var response = await http.post(global.server + "/aplicacion/api",
        body: {"tipo": "detalle_recetas", "id_receta": _idReceta.toString()});
    var datos = json.decode(utf8.decode(response.bodyBytes));
    //print(datos);

    if (datos["status"] == 1) {
      List<Ingrediente> list = new List<Ingrediente>();

      var cantidad;
      for (int i = 0; i < datos["response"][0]["ingredientes"].length; i++) {
        if (datos["response"][0]["ingredientes"][i]["cantidad"]
                .toString()
                .split('.')[1] ==
            "00")
          cantidad =
              datos["response"][0]["ingredientes"][i]["cantidad"].split('.')[0];
        else
          cantidad =
              datos["response"][0]["ingredientes"][i]["cantidad"].toString();

        list.add(Ingrediente(
            cantidad: cantidad,
            unidad: datos["response"][0]["ingredientes"][i]["medida"],
            nombre: datos["response"][0]["ingredientes"][i]["nombre"]));
      }
      return list;
    }
  } catch (e) {
    print("Error getIngredientesReceta: " + e.toString());
  }
}

Future<Detalle_Receta> getDetallesReceta(_idReceta) async {
  try {
    var response = await http.post(global.server + "/aplicacion/api",
        body: {"tipo": "detalle_recetas", "id_receta": _idReceta.toString()});
    var datos = json.decode(utf8.decode(response.bodyBytes));
    //print(datos);

    if (datos["status"] == 1) {
      Detalle_Receta detalle_receta;

      return detalle_receta = new Detalle_Receta(
        id: int.parse(datos["response"][0]["id"]),
        nombre: datos["response"][0]["nombre"],
        preparacion: datos["response"][0]["receta"],
      );
    }
  } catch (e) {
    print("Error getDetallesReceta: " + e.toString());
  }
}

class Valores_Puntos {
  String azul;
  String verde;
  String naranja;
  String amarillo;

  Valores_Puntos({this.azul, this.verde, this.naranja, this.amarillo});
}

class Detalle_Receta {
  int id;
  String nombre;
  String preparacion;

  Detalle_Receta({this.id, this.nombre, this.preparacion});
}

class Ingrediente {
  String cantidad;
  String unidad;
  String nombre;

  Ingrediente({this.cantidad, this.unidad, this.nombre});
}
