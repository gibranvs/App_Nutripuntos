import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nutripuntos_app/globals.dart' as global;
import 'newmenu.dart' as newmenu;
import '../src/HexToColor.dart';
import 'dart:async';
import 'dart:convert';
import 'restaurante_detalle.dart' as restaurante;

class RestaurantesPage extends StatefulWidget {
  @override
  _RestaurantesPageState createState() => new _RestaurantesPageState();
}

class _RestaurantesPageState extends State<RestaurantesPage> {
  ///
  /// List restaurantes
  ///
  Center restaurantes() {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 0),
        child: FutureBuilder<List<Restaurante>>(
            future: fetchRestaurantes(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return new ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: hexToColor("#f2f2f2"),
                        elevation: 0,
                        margin: new EdgeInsets.symmetric(
                            horizontal: 15, vertical: 6),
                        child: new InkWell(
                          onTap: () {
                            global.foto_restaurante = NetworkImage(
                                global.server +
                                    "/aplicacion/media/restaurantes/logo/" +
                                    snapshot.data[index].logo);
                            global.nombre_restaurante =
                                snapshot.data[index].nombre;
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        restaurante.RestauranteDetallePage(
                                            snapshot.data[index].id)));
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 25),
                            child: Row(
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Container(
                                      height: 70,
                                      width: 70,
                                      margin: EdgeInsets.only(right: 15),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.white),
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          fit: BoxFit.contain,
                                          image: NetworkImage(global.server +
                                              "/aplicacion/media/restaurantes/logo/" +
                                              snapshot.data[index].logo),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    snapshot.data[index].nombre,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      height: 1.6,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    child: Icon(
                                      Icons.keyboard_arrow_right,
                                      size: 40,
                                      color: Color(0xFF059696),
                                    ),
                                    alignment: Alignment(1, 0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              } else if (snapshot.hasError) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                  child: Text(
                      "En este momento no se pudo obtener la lista de restaurantes disponibles."),
                );
              }
              return new CircularProgressIndicator(
                strokeWidth: 2,
                semanticsLabel: "Loading",
                backgroundColor: hexToColor("#cdcdcd"),
              );
            }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: new newmenu.menu(5),
      appBar: AppBar(
        elevation: 4,
        title: Text("Restaurantes"),
        centerTitle: true,
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
        child: restaurantes(),
      ),
    );
  }
}

Future<List<Restaurante>> fetchRestaurantes() async {
  final response = await http
      .post(global.server + '/aplicacion/api', body: {"tipo": "restaurantes"});
  List responseJson = json.decode(utf8.decode(response.bodyBytes));
  List<Restaurante> restaurantesList = createRestaurantesList(responseJson);
  return restaurantesList;
}

List<Restaurante> createRestaurantesList(List data) {
  List<Restaurante> list = new List();

  for (int i = 0; i < data.length; i++) {
    String id = data[i]["id"];
    String nombre = data[i]["nombre"];
    String logo = data[i]["logo"];
    String descripcion = data[i]["descripcion"];

    Restaurante restaurante = new Restaurante(
        id: id, nombre: nombre, logo: logo, descripcion: descripcion);
    list.add(restaurante);
  }
  return list;
}

class Restaurante {
  String id;
  String nombre;
  String logo;
  String descripcion;

  Restaurante({this.id, this.nombre, this.logo, this.descripcion});
}
