import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nutripuntos_app/globals.dart' as global;
import 'dart:async';
import 'restaurantes.dart';
import 'dart:convert';
import '../src/HexToColor.dart';
import '../src/ColorCirclesWidget.dart';

class RestauranteDetallePage extends StatefulWidget {
  @override
  _RestauranteDetallePage createState() => new _RestauranteDetallePage();
}

class _RestauranteDetallePage extends State<RestauranteDetallePage> {
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
            ///
            /// FONDO VERDE
            ///
            Container(
              height: 250,
              margin: new EdgeInsets.only(top: 0.0, left: 0.0),
              decoration: BoxDecoration(
                color: Color(0xFF059696),
                borderRadius: new BorderRadius.vertical(
                  bottom: new Radius.elliptical(
                      MediaQuery.of(context).size.width * 1.5, 80.0),
                ),
              ),
            ),

            ///
            /// BACK
            ///
            GestureDetector(
              onTap: () {
                global.widget = null;
                global.list_platillos_restaurante = null;
                Navigator.pop(                  
                    context,
                    MaterialPageRoute(
                        builder: (context) => RestaurantesPage()));
              },
              child: Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(top: 30, left: 10),
                child: Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),

            ///
            /// FONDO FOTO
            ///
            Container(
              height: 120,
              alignment: Alignment.topCenter,
              margin: EdgeInsets.only(left: 30, top: 50),
              decoration: BoxDecoration(
                image: new DecorationImage(
                  image: new AssetImage("assets/icons/recurso_4.png"),
                  fit: BoxFit.contain,
                ),
              ),
            ),

            ///
            /// IMAGEN FOTO
            ///
            Container(
              height: 100,
              width: 100,
              alignment: Alignment.topCenter,
              margin: EdgeInsets.only(left: 133, top: 63.5),
              decoration: BoxDecoration(
                border: Border.all(width: 0, color: Colors.white),
                shape: BoxShape.circle,
                image: DecorationImage(image: global.foto_restaurante,//global.returnFileSelected(global.imageFile),
                ),
              ),
            ),

            ///
            /// LABEL NOMBRE
            ///
            Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(top: 0),
              margin: EdgeInsets.only(left: 0, top: 180),
              child: Text(
                global.nombre_restaurante,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),

            ///
            /// LABEL PLATILLOS RECOMENDADOS
            ///
            Container(
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
            ),

            ///
            /// LISTA PLATILLOS
            ///
            Container(
              margin: EdgeInsets.only(left: 0, top: 280),
              padding: EdgeInsets.only(top: 0),
              child: new ListView(
                children: global.list_platillos_restaurante.map((platillo) {
                  return Card(
                    margin:
                        new EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    child: ListTile(
                      leading: Container(
                        margin: new EdgeInsets.only(top: 0, left: 20),
                        child: Icon(
                          Icons.fastfood,
                          color: hexToColor("#3f95ac"),
                          size: 30,
                        ),
                      ),
                      title: new Text(
                        platillo.nombre,
                        style: new TextStyle(
                            fontSize: 13.0,
                            fontFamily: "PT Sans",
                            fontWeight: FontWeight.bold,
                            color: hexToColor("#666666")),
                      ),
                      subtitle: new Container(
                        alignment: Alignment.topLeft,
                        margin: new EdgeInsets.only(top: 8.0, left: 0.0),
                        child: new Column(
                          children: <Widget>[
                            new Container(
                              alignment: Alignment.centerLeft,
                              child: new ColorCirclesWidget(
                                  platillo.azul,
                                  platillo.verde,
                                  platillo.naranja,
                                  platillo.amarillo),
                            ),
                          ],
                        ),
                      ),
                      contentPadding: new EdgeInsets.symmetric(
                          horizontal: 0.0, vertical: 0.0),
                      selected: true,
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void getPlatillos(_idRestaurante) async {
  try {
    var response = await http.post(global.server + "/aplicacion/api", body: {
      "tipo": "platillos_restaurante",
      "id_restaurante": _idRestaurante.toString()
    });
    var datos = json.decode(utf8.decode(response.bodyBytes));
    //print(datos.length);

    var azul;
    var verde;
    var naranja;
    var amarillo;
    global.list_platillos_restaurante = null;
    global.list_platillos_restaurante = new List<Platillo>();
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

      global.list_platillos_restaurante.add(Platillo(
          id: int.parse(datos[i]["id"]),
          nombre: datos[i]["nombre"],
          azul: azul,
          verde: verde,
          naranja: naranja,
          amarillo: amarillo));
    }
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
