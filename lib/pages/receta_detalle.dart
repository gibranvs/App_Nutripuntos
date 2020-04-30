import 'package:flutter/material.dart';
import '../src/HexToColor.dart';
import '../src/ColorCirclesWidget.dart';
import 'dart:convert';
import 'recetas.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:http/http.dart' as http;
import 'package:nutripuntos_app/globals.dart' as global;

Future<Detalle_Receta> detalle;
Future<List<Ingrediente>> ingredientesReceta;
Future<Valores_Puntos> puntosValores;

class RecetaPage extends StatefulWidget {
  final BuildContext context;
  final int idReceta;
  final String nombreReceta;
  RecetaPage(this.context, this.idReceta, this.nombreReceta);
  @override
  _RecetaPageState createState() =>
      new _RecetaPageState(context, idReceta, nombreReceta);
}

class _RecetaPageState extends State<RecetaPage> {
  final BuildContext _context;
  final int idReceta;
  final String nombreReceta;
  _RecetaPageState(this._context, this.idReceta, this.nombreReceta);

  ///
  /// Botón regresar
  ///
  GestureDetector back() {
    return GestureDetector(
      onTap: () {
        //print("back");
        global.widget = null;
        Navigator.pop(
            _context, MaterialPageRoute(builder: (_context) => RecetasPage()));
      },
      child: Container(
        alignment: Alignment.topLeft,
        margin: EdgeInsets.only(top: 30, left: 10),
        child: Icon(Icons.arrow_back, color: Colors.white),
      ),
    );
  }

  ///
  /// Imagen cabecera
  ///
  Container icono() {
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

  ///
  /// Label nombre receta
  ///
  Container nombre() {
    return Container(
      alignment: Alignment.topCenter,
      margin: new EdgeInsets.only(top: 175.0),
      padding: EdgeInsets.only(left: 10, right: 10),
      child: SizedBox(
        width: 320,
        child: AutoSizeText(
          nombreReceta,
          maxLines: 3,
          textAlign: TextAlign.center,
          wrapWords: false,
          style: TextStyle(
              fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  ///
  /// Widget puntos
  ///
  Container puntos() {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 170),
      child: FutureBuilder<Valores_Puntos>(
          future: puntosValores, //getColorCirclesWidgetValues(idReceta),
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
                    azul: snapshot.data.azul,
                    verde: snapshot.data.verde,
                    naranja: snapshot.data.naranja,
                    amarillo: snapshot.data.amarillo);
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

  ///
  /// Card ingredientes
  ///
  Stack ingredientes() {
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 0),
          decoration: new BoxDecoration(
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
                  future: ingredientesReceta, //getIngredientesReceta(idReceta),
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
                                          wrapWords: false,
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

  ///
  /// Card preparación
  ///
  Stack preparacion() {
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 0),
          decoration: new BoxDecoration(
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
              child: FutureBuilder<Detalle_Receta>(
                  future: detalle, //getDetallesReceta(idReceta),
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
                        return Card(
                          margin: EdgeInsets.all(20),
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
                        );
                      } else {
                        return new Text("No existe preparación para la receta.",
                            style: TextStyle(color: hexToColor("#606060")));
                      }
                    } else if (snapshot.hasError) {
                      return new Text(
                          "Error al obtener preparación para la receta.",
                          style: TextStyle(color: hexToColor("#606060")));
                    }
                  }),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    puntosValores = getColorCirclesWidgetValues(idReceta);
    detalle = getDetallesReceta(idReceta);
    ingredientesReceta = getIngredientesReceta(idReceta);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

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
                    back(),
                    icono(),
                    nombre(),
                    puntos(),
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
              ingredientes(),
              preparacion(),
            ],
          ),
        ),
      ),
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
