import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nutripuntos_app/globals.dart' as global;
import 'dart:async';
import 'dart:convert';
import 'restaurante_detalle.dart' as restaurante;

class RestaurantesPage extends StatefulWidget {
  @override
  _RestaurantesPageState createState() => new _RestaurantesPageState();
}

class _RestaurantesPageState extends State<RestaurantesPage> {
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
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(top: 30),
            child: FutureBuilder<List<Restaurante>>(
                future: fetchRestaurantes(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return new ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return Card(
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
                                restaurante_press(
                                    context, snapshot.data[index].id);
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
                                            border:
                                                Border.all(color: Colors.white),
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              fit: BoxFit.contain,
                                              image: NetworkImage(global
                                                      .server +
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
                      padding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                      child: Text(
                          "En este momento no se pudo obtener la lista de restaurantes disponibles."),
                    );
                  }

                  // By default, show a loading spinner
                  return new CircularProgressIndicator();
                }),
          ),
        ),
      ),
    );
  }
}

void restaurante_press(context, _idRestaurante) {
  //print(_idRestaurante);
  global.list_platillos_restaurante = null;
  restaurante.getPlatillos(_idRestaurante);
  next_window_restaurante(context, _idRestaurante);
}

void next_window_restaurante(_context, _recetaID) {
  if (global.list_platillos_restaurante != null &&
      global.list_platillos_restaurante.length > 0) {
    Navigator.push(
        _context,
        MaterialPageRoute(
            builder: (context) => restaurante.RestauranteDetallePage()));
  } else {
    Future.delayed(const Duration(milliseconds: 10), () {
      next_window_restaurante(_context, _recetaID);
    });
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
