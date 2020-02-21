import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../src/hexToColor.dart';
import 'package:nutripuntos_app/globals.dart' as global;
import 'dart:convert';
import '../src/ColorCirclesWidget.dart';
import 'newmenu.dart' as newmenu;
import 'receta_detalle.dart' as detalle;
import 'package:http/http.dart' as http;
import 'dart:math';

class RecetasPage extends StatefulWidget {
  @override
  _RecetasPageState createState() => new _RecetasPageState();
}

class _RecetasPageState extends State<RecetasPage> {
  ///
  /// Text buscar
  ///
  Container buscar() {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF35B9C5),
            Color(0xFF348CB4),
          ],
        ),
      ),
      width: MediaQuery.of(context).size.width,
      height: 50,
      margin: EdgeInsets.only(top: 0),
      child: Container(
        height: 35,
        width: MediaQuery.of(context).size.width * 0.9,
        alignment: Alignment.topLeft,
        child: Stack(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.white,
              ),
              child: TextField(
                controller: global.text_busqueda_receta,
                onChanged: (value) {
                  setState(() {
                    global.list_recetas = null;
                    global.list_recetas = getReceta(value);
                  });
                },
                decoration: InputDecoration(
                  labelText: "Filtrar recetas...",
                  suffixIcon: GestureDetector(
                    onTap: () {                      
                      FocusScope.of(context).requestFocus(new FocusNode());
                    },
                    child: Icon(
                      Icons.search,
                      color: hexToColor("#059696"),
                    ),
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///
  /// List recetas
  ///
  Container recetas() {
    return Container(
      padding: EdgeInsets.only(top: 50),
      child: Scrollbar(
        child: FutureBuilder<List<Receta>>(
            future: global.list_recetas,
            //getReceta(global.text_busqueda_receta.text),
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
                      padding: EdgeInsets.only(top: 5),
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return Card(
                          color: hexToColor("#f2f2f2"),
                          elevation: 0,
                          margin: new EdgeInsets.symmetric(
                              vertical: 5, horizontal: 15),
                          child: ListTile(
                            leading: Container(
                              margin: EdgeInsets.only(left: 10),
                              height: 80,
                              child: new Image.asset(
                                  "assets/icons/Recurso_26.png"),
                            ),
                            title: new Text(
                              snapshot.data[index].nombre,
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
                                        snapshot.data[index].azul,
                                        snapshot.data[index].verde,
                                        snapshot.data[index].naranja,
                                        snapshot.data[index].amarillo),
                                  ),
                                ],
                              ),
                            ),
                            contentPadding: new EdgeInsets.symmetric(
                                horizontal: 0.0, vertical: 0.0),
                            selected: true,
                            trailing: new Icon(
                              Icons.keyboard_arrow_right,
                              color: hexToColor("#3f95ac"),
                              size: 40,
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => detalle.RecetaPage(
                                          context,
                                          snapshot.data[index].id,
                                          snapshot.data[index].nombre)));
                            },
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      drawer: new newmenu.menu(4),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text("Recetas"),
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
      body: Container(
        padding: EdgeInsets.only(top: 0),
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
        child: Stack(
          children: <Widget>[
            buscar(),
            recetas(),
          ],
        ),
      ),
    );
  }
}

Future<List<Receta>> getReceta(_receta) async {
  try {
    var response = await http.post(global.server + "/aplicacion/api",
        body: {"tipo": "busqueda_recetas", "texto": _receta});
    var datos = json.decode(utf8.decode(response.bodyBytes));
    //print(datos["response"]);

    List<Receta> list = new List<Receta>();
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

        list.add(Receta(
          id: int.parse(datos["response"][i]["id"]),
          nombre: datos["response"][i]["nombre"],
          azul: azul,
          verde: verde,
          naranja: naranja,
          amarillo: amarillo,
        ));
      }
      return list;
    }
  } catch (e) {
    print("Error getReceta: " + e.toString());
  }
}

Future<List<Receta>> getRecetas() async {
  try {
    var response = await http
        .post(global.server + "/aplicacion/api", body: {"tipo": "get_recetas"});
    var datos = json.decode(utf8.decode(response.bodyBytes));
    //print(datos["response"].length);
    List<Receta> list = new List<Receta>();
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

        list.add(Receta(
          id: int.parse(datos["response"][i]["id"]),
          nombre: datos["response"][i]["nombre"],
          azul: azul,
          verde: verde,
          naranja: naranja,
          amarillo: amarillo,
        ));
      }
      return list;
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
