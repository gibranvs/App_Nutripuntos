import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nutripuntos_app/pages/progreso.dart';
import 'menu.dart' as menu;
import 'newmenu.dart' as newmenu;
import 'package:nutripuntos_app/globals.dart' as global;
import 'recetas.dart';
import 'restaurantes.dart';
import 'plan.dart';
import '../src/HexToColor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../src/DBManager.dart' as db;

class HomePage extends StatefulWidget {
  String prueba;
  HomePage({this.prueba});
  @override
  _HomePageState createState() => new _HomePageState(prueb: prueba);
}

class _HomePageState extends State<HomePage> {
  String prueb;
  _HomePageState({this.prueb});

  showAlertOption() {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Selecciona una fuente..."),
      content: new Container(
        height: 100.0,
        width: MediaQuery.of(context).size.width * 0.9,
        alignment: Alignment.centerLeft,
        margin: new EdgeInsets.only(top: 0.0, left: 20.0),
        child: new Column(
          children: <Widget>[
            FlatButton(
              child: Text(
                "Tomar Foto",
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                pickImageFrom(context, ImageSource.camera);
              },
            ),
            FlatButton(
              child: Text("Seleccionar de galería",
                  style: TextStyle(color: Colors.blue)),
              onPressed: () {
                pickImageFrom(context, ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  pickImageFrom(context, ImageSource source) async {
    try {
      var imageFile =
          await ImagePicker.pickImage(source: source).whenComplete(() {});
      setState(() {
        global.imageFile = imageFile;
        global.imageFilePath = imageFile.path;
        List<int> fileBytes = imageFile.readAsBytesSync();
        String base64File = base64Encode(fileBytes);
        db.DBManager.instance.insertUsuario(global.nombre_user,
            global.apellidos_user, global.token, imageFile.path);
      });
      Navigator.of(context, rootNavigator: true).pop('dialog');
    } catch (e) {
      print("Error pickImageFrom " + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      //drawer: new menu.Menu(),
      drawer: new newmenu.menu(0),
      drawerDragStartBehavior: DragStartBehavior.start,
      appBar: new AppBar(
        centerTitle: true,
        elevation: 0,
        title: Image.asset(
          'assets/icons/recurso_1.png',
          width: MediaQuery.of(context).size.width * 0.22,
        ),
      ),
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
        child: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: Container(
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    ///
                    /// FONDO VERDE
                    ///
                    header(),

                    ///
                    /// FONDO FOTO
                    ///
                    fondo_foto(),

                    ///
                    /// IMAGEN FOTO
                    ///
                    GestureDetector(
                      onTap: () {
                        showAlertOption();
                      },
                      child: foto(),
                    ),

                    ///
                    /// LABEL NOMBRE
                    ///
                    label_nombre(),

                    ///
                    /// LABEL STATUS
                    ///
                    label_status(),

                    Container(
                      padding: EdgeInsets.only(top: 5),
                      margin: const EdgeInsets.only(top: 200),
                      height: 312,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Stack(
                          children: <Widget>[
                            ///
                            /// PROXIMA CITA
                            ///
                            card_proxima_cita(),

                            ///
                            /// BUTONS
                            ///
                            botones(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            width: MediaQuery.of(context).size.width,
          ),
        ),
      ),
    );
  }
}

class header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      margin: new EdgeInsets.only(top: 0.0, left: 0.0),
      decoration: BoxDecoration(
        color: Color(0xFF059696),
        borderRadius: new BorderRadius.vertical(
          bottom: new Radius.elliptical(
              MediaQuery.of(context).size.width * 1.5, 100.0),
        ),
      ),
    );
  }
}

class fondo_foto extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      alignment: Alignment.topCenter,
      margin: EdgeInsets.only(top: 10, left: 30),
      decoration: BoxDecoration(
        image: new DecorationImage(
          image: new AssetImage("assets/icons/recurso_4.png"),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class foto extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: 80,
      alignment: Alignment.topCenter,
      margin: EdgeInsets.only(left: 145, top: 23.5),
      decoration: BoxDecoration(
        border: Border.all(width: 0, color: Colors.white),
        shape: BoxShape.circle,
        image:
            global.returnFileSelected(global.imageFile, global.imageFile.path),
      ),
    );
  }
}

class label_nombre extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.only(top: 0),
      margin: EdgeInsets.only(left: 0, top: 120),
      child: Text(
        global.nombre_user + " " + global.apellidos_user,
        style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}

class label_status extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.only(top: 0),
      margin: EdgeInsets.only(left: 0, top: 150),
      child: Text(
        "Activo" + "     |     " + "10 citas",
        style: TextStyle(fontSize: 14, color: Colors.white),
      ),
    );
  }
}

class card_proxima_cita extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      margin: const EdgeInsets.only(top: 0),
      //padding: EdgeInsets.all(10),
      child: FutureBuilder<List<Citas>>(
        future: getCitasProximas(global.token),
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
                child: Row(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding:
                              EdgeInsets.only(top: 12, left: 15, bottom: 2),
                          child: Text(
                            snapshot.data[0].fecha.toString().split("-")[0] +
                                "\n" +
                                snapshot.data[0].fecha.toString().split("-")[1],
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF059696)),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(top: 2, left: 15, bottom: 12),
                          child: Text(snapshot.data[0].horario.toString()),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding:
                              EdgeInsets.only(top: 12, left: 25, bottom: 4),
                          child: Text(
                            "Próxima cita",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(top: 4, left: 25, bottom: 12),
                          child: Text(snapshot.data[0].objetivo.toString()),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            } else {
              return Container(
                margin: EdgeInsets.all(30),
                child: Center(
                  child: Text(
                    "No tienes citas pendientes.",
                    style: TextStyle(
                      color: hexToColor("#606060"),
                    ),
                  ),
                ),
              );
            }
          } else if (snapshot.hasError) {
            return Container(
                margin: EdgeInsets.all(30),
                child: Center(
                  child: Text(
                    "Error al obtener citas pendientes.",
                    style: TextStyle(
                      color: hexToColor("#606060"),
                    ),
                  ),
                ),
              );
          }
        },
      ),

      /*
      Card(
        child: Row(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 12, left: 15, bottom: 2),
                  child: Text(
                    "11\nOCT",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF059696)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 2, left: 15, bottom: 12),
                  child: Text("10:00 AM"),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 12, left: 25, bottom: 4),
                  child: Text(
                    "Próxima cita",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 4, left: 25, bottom: 12),
                  child: Text("Seguimiento de peso"),
                ),
              ],
            ),
          ],
        ),
      ),
      */
    );
  }
}

class botones extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(left: 0, top: 100, bottom: 10),
      child: Stack(
        children: <Widget>[
          ///
          /// BOTON 1
          ///
          GestureDetector(
            onTap: () {
              global.selected_index = 4;
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => new RecetasPage()));
            },
            child: Container(
              margin: EdgeInsets.only(left: 30),
              child: Column(
                children: <Widget>[
                  Image.asset(
                    "assets/icons/recurso_5.png",
                    width: MediaQuery.of(context).size.width * 0.2,
                  ),
                  Container(
                    width: 150,
                    child: SizedBox(
                      child: Text(
                        "Nuevas recetas disponibles",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          ///
          /// BOTON 2
          ///
          GestureDetector(
            onTap: () {             
              global.selected_index = 2; 
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => new ProgresoPage()));
            },
            child: Container(
              margin: EdgeInsets.only(left: 210),
              child: Column(
                children: <Widget>[
                  Image.asset(
                    "assets/icons/recurso_8.png",
                    width: MediaQuery.of(context).size.width * 0.2,
                  ),
                  Text(
                    "Baja 2 kg",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  Text(
                    "meta cumplida",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),

          ///
          /// BOTON 3
          ///
          GestureDetector(
            onTap: () {   
              global.selected_index = 1;           
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => new PlanPage()));
            },
            child: Container(
              margin: EdgeInsets.only(left: 30.0, top: 150),
              child: Column(
                children: <Widget>[
                  Image.asset(
                    "assets/icons/recurso_7.png",
                    width: MediaQuery.of(context).size.width * 0.2,
                  ),
                  Container(
                    width: 150,
                    child: SizedBox(
                      child: Text(
                        "Nuevo plan de alimentación disponible",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          ///
          /// BOTON 4
          ///
          GestureDetector(
            onTap: () {    
              global.selected_index = 5;          
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => new RestaurantesPage()));
            },
            child: Container(
              margin: EdgeInsets.only(left: 190, top: 150),
              child: Column(
                children: <Widget>[
                  Image.asset(
                    "assets/icons/recurso_6.png",
                    width: MediaQuery.of(context).size.width * 0.2,
                  ),
                  Container(
                    width: 150,
                    child: SizedBox(
                      child: Text(
                        "Restaurantes disponibles en tu zona",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<List<Citas>> getCitasProximas(_token) async {
  var timeNow = DateTime.now();
  var timeCita;

  try {
    var response = await http.post(global.server + "/aplicacion/api",
        body: {"tipo": "consultas", "token": _token});
    var datos = json.decode(utf8.decode(response.bodyBytes));
    //print(datos);
    List<Citas> list_citas = new List<Citas>();
    for (int i = 0; i < datos["response"].length; i++) {
      //print(datos["response"][i]);
      timeCita = DateTime.parse(datos["response"][i]["fecha"]);
      //print(timeNow);
      //print(timeCita);
      //print(timeNow.difference(timeCita).inDays.toString());
      if (timeNow.difference(timeCita).inDays < 0) {
        list_citas.add(Citas(
            objetivo: datos["response"][i]["objetivo"],
            horario: new DateFormat("h:mm a")
                .format(DateTime.parse(datos["response"][i]["fecha"]))
                .toString(),
            fecha: new DateFormat("dd-MMM-yyyy G")
                .format(DateTime.parse(datos["response"][i]["fecha"]))
                .toString()
                .toUpperCase()));
      }
    }
    return list_citas;
  } catch (e) {
    print("Error getCitasPasadas " + e.toString());
  }
}

class Citas {
  String objetivo;
  String horario;
  String fecha;

  Citas({this.objetivo, this.horario, this.fecha});
}
