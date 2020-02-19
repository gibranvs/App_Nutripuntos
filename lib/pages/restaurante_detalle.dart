import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nutripuntos_app/globals.dart' as global;
import 'dart:async';
import 'restaurantes.dart';
import 'dart:convert';
import '../src/HexToColor.dart';
import '../src/ColorCirclesWidget.dart';

class RestauranteDetallePage extends StatefulWidget {
  final String idRestaurante;
  RestauranteDetallePage(this.idRestaurante);
  @override
  _RestauranteDetallePage createState() =>
      new _RestauranteDetallePage(idRestaurante);
}

class _RestauranteDetallePage extends State<RestauranteDetallePage> {
  final String idRestaurante;
  _RestauranteDetallePage(this.idRestaurante);

  ///
  /// Header
  ///
  Container header() {
    return Container(
      height: 250,
      margin: new EdgeInsets.only(top: 0.0, left: 0.0),
      decoration: BoxDecoration(
        color: Color(0xFF059696),
        borderRadius: new BorderRadius.vertical(
          bottom: new Radius.elliptical(
              MediaQuery.of(context).size.width * 1.5, 80.0),
        ),
      ),
    );
  }

  ///
  /// Botón regresar
  ///
  GestureDetector back() {
    return GestureDetector(
      onTap: () {
        global.widget = null;
        global.list_platillos_restaurante = null;
        Navigator.pop(
            context, MaterialPageRoute(builder: (_) => RestaurantesPage()));
      },
      child: Container(
        alignment: Alignment.topLeft,
        margin: EdgeInsets.only(top: 30, left: 10),
        child: Icon(Icons.arrow_back, color: Colors.white),
      ),
    );
  }

  ///
  /// Fondo foto
  ///
  Container fondoFoto() {
    return Container(
      alignment: Alignment.topCenter,
      width: MediaQuery.of(context).size.width,
      child: Container(
        height: 120,
        alignment: Alignment.topCenter,
        margin: EdgeInsets.only(left: 25, top: 50),
        decoration: BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage("assets/icons/recurso_4.png"),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  ///
  /// Foto
  ///
  Container foto() {
    return Container(
      alignment: Alignment.topCenter,
      width: MediaQuery.of(context).size.width,
      child: Container(
        height: 100,
        width: 100,
        margin: EdgeInsets.only(top: 63.5),
        decoration: BoxDecoration(
          border: Border.all(width: 0, color: Colors.white),
          shape: BoxShape.circle,
          image: DecorationImage(
            image: global
                .foto_restaurante, //global.returnFileSelected(global.imageFile),
          ),
        ),
      ),
    );
  }

  ///
  /// Label nombre
  ///
  Container nombre() {
    return Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.only(top: 0),
      margin: EdgeInsets.only(left: 0, top: 180),
      child: Text(
        global.nombre_restaurante,
        style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  ///
  /// Label subtítulo
  ///
  Container subtitulo() {
    return Container(
      alignment: Alignment.topCenter,
      margin: const EdgeInsets.only(
        top: 255,
      ),
      child: Text(
        "Platillos recomendados",
        style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF059696)),
      ),
    );
  }

  ///
  /// List platillos
  ///
  Container platillos() {
    return Container(
      margin: EdgeInsets.only(left: 0, top: 280),
      padding: EdgeInsets.only(top: 0),
      child: SingleChildScrollView(
        child: Align(
          alignment: Alignment.center,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            child: FutureBuilder<List<Platillo>>(
                future: getPlatillos(idRestaurante),
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
                              margin: EdgeInsets.only(bottom: 15),
                              color: hexToColor("#f2f2f2"),
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
                                          margin: new EdgeInsets.only(
                                              top: 0, left: 0),
                                          child: Container(
                                            margin: EdgeInsets.only(left: 5),
                                            height: 80,
                                            child: new Image.asset(
                                                "assets/icons/Recurso_26.png"),
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
                                            top: 0, bottom: 10, left: 10),
                                        child: Container(
                                          width: 180,
                                          child: Text(
                                            snapshot.data[index].nombre,
                                            style: new TextStyle(
                                                fontSize: 18.0,
                                                fontFamily: "PT Sans",
                                                fontWeight: FontWeight.bold,
                                                color: hexToColor("#666666")),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 0, bottom: 5, left: 10),
                                        child: Container(
                                          width: 180,
                                          child: ColorCirclesWidget(
                                              snapshot.data[index].azul,
                                              snapshot.data[index].verde,
                                              snapshot.data[index].naranja,
                                              snapshot.data[index].amarillo),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          });
                    } else {
                      return new Center(
                          child: Text("No hay platillos recomendados.",
                              style: TextStyle(color: hexToColor("#606060"))));
                    }
                  } else if (snapshot.hasError) {
                    return new Center(
                        child: Text("Error al obtener platillos recomendados.",
                            style: TextStyle(color: hexToColor("#606060"))));
                  }
                }),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
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
            header(),
            back(),
            fondoFoto(),
            foto(),
            nombre(),
            subtitulo(),
            platillos(),
          ],
        ),
      ),
    );
  }
}

Future<List<Platillo>> getPlatillos(_idRestaurante) async {
  try {
    var response = await http.post(global.server + "/aplicacion/api", body: {
      "tipo": "platillos_restaurante",
      "id_restaurante": _idRestaurante.toString()
    });
    var datos = json.decode(utf8.decode(response.bodyBytes));

    var azul;
    var verde;
    var naranja;
    var amarillo;
    List<Platillo> list = new List<Platillo>();
    for (int i = 0; i < datos.length; i++) {
      if (datos[i]["azul"] != null) {
        if (datos[i]["azul"].split('.')[1] == "0")
          azul = datos[i]["azul"].split('.')[0];
        else
          azul = datos[i]["azul"];
      } else
        azul = "0";

      if (datos[i]["verde"] != null) {
        if (datos[i]["verde"].split('.')[1] == "0")
          verde = datos[i]["verde"].split('.')[0];
        else
          verde = datos[i]["verde"];
      } else
        verde = "0";

      if (datos[i]["naranja"] != null) {
        if (datos[i]["naranja"].split('.')[1] == "0")
          naranja = datos[i]["naranja"].split('.')[0];
        else
          naranja = datos[i]["naranja"];
      } else
        naranja = "0";

      if (datos[i]["amarillo"] != null) {
        if (datos[i]["amarillo"].split('.')[1] == "0")
          amarillo = datos[i]["amarillo"].split('.')[0];
        else
          amarillo = datos[i]["amarillo"];
      } else
        amarillo = "0";

      list.add(Platillo(
          id: int.parse(datos[i]["id"]),
          nombre: datos[i]["nombre"].toString(),
          azul: azul,
          verde: verde,
          naranja: naranja,
          amarillo: amarillo));
    }
    return list;
  } catch (e) {
    print("Error getPlatillos: " + e.toString());
  }
}

class Platillo {
  int id;
  String nombre;
  String azul;
  String verde;
  String naranja;
  String amarillo;

  Platillo(
      {this.id,
      this.nombre,
      this.azul,
      this.verde,
      this.naranja,
      this.amarillo});

  factory Platillo.fromJson(Map<String, dynamic> json) => new Platillo(
      id: json["id"],
      nombre: json["nombre"],
      azul: json["azul"],
      verde: json["verde"],
      naranja: json["naranja"],
      amarillo: json["amarillo"]);
}
