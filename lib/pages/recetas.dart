import 'package:flutter/material.dart';
import '../src/hexToColor.dart';
import 'package:nutripuntos_app/globals.dart' as global;
import 'dart:convert';
import '../src/ColorCirclesWidget.dart';
import 'receta_detalle.dart' as detalle;
import 'package:http/http.dart' as http;
import 'dart:math';

List<dynamic> listRecetas = [];

class RecetasPage extends StatefulWidget {
  @override
  _RecetasPageState createState() => new _RecetasPageState();
}

class _RecetasPageState extends State<RecetasPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
        decoration: new BoxDecoration(
          color: const Color(0x00FFCC00),
          image: new DecorationImage(
            image: new AssetImage("assets/images/fondo.jpg"),
            colorFilter: new ColorFilter.mode(
                Colors.black.withOpacity(0.2), BlendMode.dstATop),
            fit: BoxFit.cover,
          ),
        ),
        alignment: Alignment.topLeft,
        margin: new EdgeInsets.only(top: 0.0, left: 0.0),
        child: new ListView(
          children: listRecetas.map((receta) {
            return Card(
              margin: new EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              child: ListTile(
                leading:
                
                Container(
                  margin: EdgeInsets.only(left:10),         
                  height: 80,
                  child: new Image.asset("assets/icons/Recurso_26.png"),
                ),
                
                /*
                Container(
                  margin: new EdgeInsets.only(top: 0, left: 20),
                  child: Icon(Icons.fastfood, color: hexToColor("#3f95ac"), size: 30,),
                ),
                */
                
                title: new Text(
                  receta.nombre,
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
                        child: new ColorCirclesWidget(receta.azul, receta.verde,
                            receta.naranja, receta.amarillo),
                      ),
                    ],
                  ),
                ),
                contentPadding:
                    new EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
                selected: true,
                trailing: new Icon(
                  Icons.keyboard_arrow_right,
                  color: hexToColor("#3f95ac"),
                  size: 40,
                ),

                onTap: () {
                  receta_press(context, receta.id);
                },
              ),
            );
          }).toList(),
        ),
      ),
      /*
      new Container(
        decoration: new BoxDecoration(
          color: const Color(0x00FFCC00),
          image: new DecorationImage(
            image: new AssetImage("assets/images/fondo.jpg"),
            colorFilter: new ColorFilter.mode(
                Colors.black.withOpacity(0.2), BlendMode.dstATop),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Image.asset("assets/images/gr_recetas.png"),
        ),
      ),
      */
    );
  }
}

void receta_press(_context, _recetaID) {
  //print(_recetaID);
  global.widget = null;
  detalle.getReceta(_recetaID);

  next_window_receta(_context, _recetaID);
}

void next_window_receta(_context, _recetaID) {
  if (global.detalle_receta != null && global.widget != null) {
    Navigator.push(_context,
        MaterialPageRoute(builder: (context) => detalle.RecetaPage()));
  } else {
    Future.delayed(const Duration(milliseconds: 10), () {
      next_window_receta(_context, _recetaID);
    });
  }
}

void getRecetas() async {
  try {
    var response = await http
        .post(global.server + "/aplicacion/api", body: {"tipo": "get_recetas"});
    var datos = json.decode(utf8.decode(response.bodyBytes));
    print(datos["response"].length);
    listRecetas.clear();

    if (datos["status"] == 1) {
      var azul;
      var verde;
      var naranja;
      var amarillo;

      for (int i = 0; i < datos["response"].length; i++) {
        if (datos["response"][i]["azul"] != null) {
          if (datos["response"][i]["azul"].split('.')[1] == "0")
            azul = datos["response"][i]["azul"].split('.')[0];
          else
            azul = datos["response"][i]["azul"];
        } else
          azul = "0";

        if (datos["response"][i]["verde"] != null) {
          if (datos["response"][i]["verde"].split('.')[1] == "0")
            verde = datos["response"][i]["verde"].split('.')[0];
          else
            verde = datos["response"][i]["verde"];
        } else
          verde = "0";

        if (datos["response"][i]["naranja"] != null) {
          if (datos["response"][i]["naranja"].split('.')[1] == "0")
            naranja = datos["response"][i]["naranja"].split('.')[0];
          else
            naranja = datos["response"][i]["naranja"];
        } else
          naranja = "0";

        if (datos["response"][i]["amarillo"] != null) {
          if (datos["response"][i]["amarillo"].split('.')[1] == "0")
            amarillo = datos["response"][i]["amarillo"].split('.')[0];
          else
            amarillo = datos["response"][i]["amarillo"];
        } else
          amarillo = "0";

        listRecetas.add(Receta(
          id: int.parse(datos["response"][i]["id"]),
          nombre: datos["response"][i]["nombre"],
          azul: azul,
          verde: verde,
          naranja: naranja,
          amarillo: amarillo,
        ));
      }
    }
  } catch (e) {
    print("Error getRecetas: " + e.toString());
  }
}

class Receta {
  int id;
  String nombre;
  String azul;
  String verde;
  String naranja;
  String amarillo;

  Receta(
      {this.id,
      this.nombre,
      this.azul,
      this.verde,
      this.naranja,
      this.amarillo});

  factory Receta.fromJson(Map<String, dynamic> json) => new Receta(
      id: json["id"],
      nombre: json["nombre"],
      azul: json["azul"],
      verde: json["verde"],
      naranja: json["naranja"],
      amarillo: json["amarillo"]);
}
