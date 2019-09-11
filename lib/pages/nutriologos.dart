import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nutripuntos_app/globals.dart' as global;
import 'dart:async';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart' as urlLauncher;

String _img;
final myTextEdit = TextEditingController();
final myListView = ScrollController();

class NutriologosPage extends StatefulWidget {
  @override
  _NutriologosPageState createState() => new _NutriologosPageState();
}

class _NutriologosPageState extends State<NutriologosPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Especialistas'),
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

        ///
        /// FONDO
        ///
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
          child: Column(
            children: <Widget>[
              ///
              /// BUSQUEDA
              ///
              Container(
                decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.circular(12),
                ),
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: TextField(
                  controller: myTextEdit,
                  onChanged: (_) {
                    fetchDoctores(myTextEdit);
                  },
                  decoration: InputDecoration(
                    labelText: "Buscar",
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(0),
                  ),
                ),
              ),

              ///
              /// LEYENDA
              ///
              Padding(
                padding: const EdgeInsets.only(
                    top: 10, right: 15, bottom: 25, left: 15),
                child: Text(
                  "Para usar la app Nutripuntos deberás contactar a uno de nuestros especialistas afiliados",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF059696),
                  ),
                ),
              ),

              ///
              /// LIST DOCTORES
              ///
              Flexible(
                child: FutureBuilder<List<Doctor>>(
                  future: fetchDoctores(myTextEdit),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return new ListView.builder(
                          controller: myListView,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                call_press(snapshot.data[index].telefono);
                              },
                              child: Card(
                                margin: new EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 6),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 25),
                                  child: Row(
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 15),
                                        child: Image.asset(
                                          _setImage(snapshot.data[index].sexo),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.18,
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            snapshot.data[index].nombre,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              height: 1.6,
                                            ),
                                          ),
                                          Text(
                                            snapshot.data[index].correo,
                                            style: TextStyle(
                                              height: 1.1,
                                            ),
                                          ),
                                          Text(
                                            snapshot.data[index].telefono,
                                            style: TextStyle(
                                              height: 1.3,
                                            ),
                                          ),
                                        ],
                                      )
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
                            "En este momento no se pudo obtener la lista de especialistas disponibles."),
                      );
                    }

                    // By default, show a loading spinner
                    return new CircularProgressIndicator();
                  },
                ),
              ),
            ],
          ),
        ));
  }
}

void call_press(_telefono) {
  urlLauncher.launch("tel://" + _telefono);
}

Future<List<Doctor>> fetchDoctores(controller) async {
  print(controller.text);
  List<Doctor> doctoresList;
  if (controller.text == "") {
    final response =
        await http.post(global.server + '/aplicacion/api/', body: {"tipo": "get_doctores"});
    List responseJson = json.decode(utf8.decode(response.bodyBytes));
    doctoresList = createDoctoresList(responseJson);
  } else {
    final response = await http.post(global.server + '/aplicacion/api',
        body: {"tipo": "busqueda", "texto": controller.text.toString()});
    List responseJson = json.decode(utf8.decode(response.bodyBytes));
    //print(responseJson);
    doctoresList = createDoctoresList(responseJson);
  }

  return doctoresList;
}

List<Doctor> createDoctoresList(List data) {
  List<Doctor> list = new List();

  for (int i = 0; i < data.length; i++) {
    String id = data[i]["id"];
    String nombre = data[i]["nombre"];
    String sexo = data[i]["sexo"];
    String correo = data[i]["correo"];
    String telefono = data[i]["telefono"];

    Doctor doctor = new Doctor(
        id: id, nombre: nombre, sexo: sexo, correo: correo, telefono: telefono);
    list.add(doctor);
  }
  return list;
}

String _setImage(String sexo) {
  String _sexo = sexo;

  if (_sexo == "1") {
    _img = 'assets/icons/recurso_2.png';
  } else if (_sexo == "0") {
    _img = 'assets/icons/recurso_3.png';
  }
  return _img;
}

class Doctor {
  String id;
  String nombre;
  String sexo;
  String correo;
  String telefono;

  Doctor({this.id, this.nombre, this.sexo, this.correo, this.telefono});
}
