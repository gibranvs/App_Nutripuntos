import 'package:flutter/material.dart';
import '../src/HexToColor.dart';
import '../src/ColorCirclesWidget.dart';
import 'dart:convert';
import 'recetas.dart';
import 'package:http/http.dart' as http;
import 'package:nutripuntos_app/globals.dart' as global;

void main() {
  runApp(RecetaPage());
}

class RecetaPage extends StatelessWidget {
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
                    GestureDetector(
                      onTap: () {
                        print("back");
                        global.widget = null;
                        Navigator.pop(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RecetasPage()));
                      },
                      child: Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(top: 30, left: 10),
                        child: Icon(Icons.arrow_back, color: Colors.white),
                      ),
                    ),

                    ///
                    /// IMAGE
                    ///
                    Container(
                      height: 120,
                      margin: new EdgeInsets.only(top: 50.0),
                      decoration: BoxDecoration(
                        image: new DecorationImage(
                          image: new AssetImage("assets/icons/Recurso_25.png"),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    ///
                    /// LABEL NOMBRE
                    ///
                    Container(
                      alignment: Alignment.topCenter,
                      margin: new EdgeInsets.only(top: 170.0),
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Text(
                        global.detalle_receta.nombre,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),

                    ///
                    /// WIDGET
                    ///
                    Container(
                      alignment: Alignment.topCenter,
                      margin: new EdgeInsets.only(top: 220.0),
                      padding: EdgeInsets.only(top: 0),
                      child: global.widget,
                    ),
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
              Container(
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
                child: Card(
                  margin:
                      new EdgeInsets.symmetric(vertical: 30, horizontal: 18),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  child: Container(
                    padding: EdgeInsets.only(
                        top: 10, bottom: 10, left: 20, right: 20),
                    child: ListView(
                      padding: new EdgeInsets.all(0),                                                          
                      children: global.list_ingredientes.map((ingrediente) {
                        return ListTile(                                                                              
                          contentPadding: new EdgeInsets.all(0.0),
                          leading: Text(
                                ingrediente.cantidad +
                                    "  " +
                                    ingrediente.unidad +
                                    " de " +
                                    ingrediente.nombre,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 12, color: hexToColor("#78c826"), fontWeight: FontWeight.bold),
                              ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),

              ///
              /// PREPARACIÓN
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
                child: Card(
                  margin:
                      new EdgeInsets.symmetric(vertical: 30, horizontal: 18),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  child: Container(
                    padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: Text(
                      global.detalle_receta.preparacion.toString(),
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: hexToColor("#78c826"),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void getReceta(_idReceta) async {
  try {
    var response = await http.post(global.server + "/aplicacion/api",
        body: {"tipo": "detalle_recetas", "id_receta": _idReceta.toString()});
    var datos = json.decode(utf8.decode(response.bodyBytes));
    //print(datos);

    if (datos["status"] == 1) {
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

      global.widget = new ColorCirclesWidget(azul, verde, naranja, amarillo);

      global.detalle_receta = null;
      global.detalle_receta = new Detalle_Receta(
        id: int.parse(datos["response"][0]["id"]),
        nombre: datos["response"][0]["nombre"],
        preparacion: datos["response"][0]["receta"],
      );

      global.list_ingredientes = new List<Ingrediente>();
      var cantidad;     
      for (int i = 0; i < datos["response"][0]["ingredientes"].length; i++) {
        if (datos["response"][0]["ingredientes"][i]["cantidad"].toString().split('.')[1] == "00")
          cantidad = datos["response"][0]["ingredientes"][i]["cantidad"].split('.')[0];
        else
          cantidad = datos["response"][0]["ingredientes"][i]["cantidad"].toString();


        global.list_ingredientes.add(Ingrediente(
            cantidad: cantidad,                
            unidad: datos["response"][0]["ingredientes"][i]["medida"],
            nombre: datos["response"][0]["ingredientes"][i]["nombre"]));
      }
    }
  } catch (e) {
    print("Error getReceta: " + e.toString());
  }
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
