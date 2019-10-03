import 'dart:convert';
import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nutripuntos_app/pages/progreso.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'newmenu.dart' as newmenu;
import 'package:nutripuntos_app/globals.dart' as global;
import 'recetas.dart';
import 'restaurantes.dart';
import 'plan.dart';
import '../src/HexToColor.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:image_picker_modern/image_picker_modern.dart';
//import 'package:image_crop/image_crop.dart';
//import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:http/http.dart' as http;
import '../src/DBManager.dart' as db;

File croppedFile;

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

/*
  final cropKey = GlobalKey<CropState>();
  File _file;
  File _lastCropped;
*/

  void pickImageFrom(_context, ImageSource source) async {
    
    try {
      ImagePicker.pickImage(source: source).then((File img) {
        setState(() {
          if (img != null) {
            //_file = img;
            //buildCroppingImage();
            global.image_foto = new DecorationImage(image: Image.file(img).image);
            db.DBManager.instance.insertUsuario(
                global.id_user,
                global.nombre_user,
                global.apellidos_user,
                global.token,
                img.path);

            List<int> imageBytes = img.readAsBytesSync();
            writeFileContent(base64Encode(imageBytes));
            readFileContent();

            Navigator.pop(context);
          }
        });
      });
    } catch (e) {
      print("Error pickImageFrom " + e.toString());
      setState(() {
        global.image_foto =
            DecorationImage(image: AssetImage("assets/images/photo.jpg"));
      });
    }
  }

/*
  @override
  void dispose() {
    super.dispose();
    _file?.delete();
    _lastCropped?.delete();
  }

  @override
  Widget buildCroppingImage() {
    return Column(
      children: <Widget>[
        Expanded(
          child: Crop.file(_file, key: cropKey),
        ),
        Container(
          //padding: const EdgeInsets.only(top: 20.0),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          alignment: AlignmentDirectional.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              FlatButton(
                child: Text(
                  'Crop Image',
                  style: Theme.of(context)
                      .textTheme
                      .button
                      .copyWith(color: Colors.white),
                ),
                onPressed: () => _cropImage(),
              ),
            ],
          ),
        )
      ],
    );
  }

  Future<void> _cropImage() async {
    final scale = cropKey.currentState.scale;
    final area = cropKey.currentState.area;
    if (area == null) {
      return;
    }
    final sample = await ImageCrop.sampleImage(
      file: _file,
      preferredSize: (2000 / scale).round(),
    );

    final file = await ImageCrop.cropImage(
      file: sample,
      area: area,
    );

    sample.delete();
    _lastCropped?.delete();
    _lastCropped = file;
    debugPrint('$file');
  }
*/

  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () {
        //SystemNavigator.pop();
        exit(0);
      },
      child: Scaffold(
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
        body: Stack(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: new BoxDecoration(
                color: const Color(0x00FFCC00),
                image: new DecorationImage(
                  image: new AssetImage("assets/images/fondo.jpg"),
                  colorFilter: new ColorFilter.mode(
                      Colors.black.withOpacity(0.2), BlendMode.dstATop),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Stack(
              children: <Widget>[
                ///
                /// SCROLLEABLE AREA
                ///
                Container(
                  margin: EdgeInsets.only(top: 170),
                  child: ListView(
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

                ///
                /// FONDO VERDE
                ///
                header(),

                Container(
                  alignment: Alignment.topLeft,
                  width: MediaQuery.of(context).size.width,
                  child: GestureDetector(
                    onTap: () {
                      //showAlertOption();
                      pickImageFrom(context, ImageSource.gallery);
                    },
                    child: Stack(
                      children: <Widget>[
                        ///
                        /// FONDO FOTO
                        ///
                        fondo_foto(),

                        ///
                        /// IMAGEN FOTO
                        ///
                        foto(),
                      ],
                    ),
                  ),
                ),

                ///
                /// LABEL NOMBRE
                ///
                label_nombre(),

                ///
                /// LABEL STATUS
                ///
                label_status(),
              ],
            ),
          ],
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
      alignment: Alignment.topLeft,
      margin: EdgeInsets.only(
          left: 10), //MediaQuery.of(context).size.width * 0.5 - 150),
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
      width: 80,
      height: 80,
      alignment: Alignment.topLeft,
      margin: EdgeInsets.only(
          top: 14, left: MediaQuery.of(context).size.width * 0.5 - 45), //130),
      decoration: BoxDecoration(
        //border: Border.all(width: 1, color: Colors.black),
        shape: BoxShape.circle,
        image: global.image_foto == null
            ? DecorationImage(
                image: AssetImage("assets/images/photo.jpg"),
                fit: BoxFit.contain)
            : global.image_foto,
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
        "Activo     |     " + global.num_citas + " citas",
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
      margin: const EdgeInsets.only(top: 40),
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
              global.num_citas = snapshot.data.length.toString();
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
    );
  }
}

class botones extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(left: 0, top: 20, bottom: 20),
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
                  MaterialPageRoute(builder: (context) => new ProgresoPage(2)));
            },
            child: Container(
              margin: EdgeInsets.only(left: 175, top: 10),
              child: Column(
                children: <Widget>[
                  Image.asset(
                    "assets/icons/recurso_8.png",
                    width: MediaQuery.of(context).size.width * 0.2,
                  ),
                  FutureBuilder<Meta>(
                      future: db.DBManager.instance.getReto(global.token),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              semanticsLabel: "Loading",
                              backgroundColor: hexToColor("#cdcdcd"),
                            ),
                          );
                        } else if (snapshot.hasData) {
                          if (snapshot.data != null) {
                            if (snapshot.data.meta == "NA") {
                              return new Container(
                                alignment: Alignment.center,
                                child: Container(
                                  alignment: Alignment.topLeft,
                                  margin: EdgeInsets.only(top: 0),
                                  constraints: BoxConstraints(
                                      minWidth: 100, maxWidth: 100),
                                  child: AutoSizeText(
                                    "Presiona para agregar reto",
                                    textAlign: TextAlign.center,
                                    maxFontSize: 16,
                                    maxLines: 2,
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16),
                                  ),
                                ),
                              );
                            } else {
                              return new Container(
                                alignment: Alignment.center,
                                child: Container(
                                  alignment: Alignment.topCenter,
                                  margin: EdgeInsets.only(top: 0),
                                  constraints: BoxConstraints(
                                      minWidth: 100,
                                      maxWidth: 100,
                                      maxHeight: 80,
                                      minHeight: 80),
                                  child: AutoSizeText(
                                    snapshot.data.meta,
                                    maxLines: 3,
                                    maxFontSize: 16,
                                    wrapWords: false,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16),
                                  ),
                                ),
                              );
                            }
                          } else {
                            return new Center(
                                child: Text("No hay méta próxima.",
                                    style: TextStyle(
                                        color: hexToColor("#606060"))));
                          }
                        } else if (snapshot.hasError) {
                          return new Center(
                              child: Text("Error al obtener meta próxima.",
                                  style:
                                      TextStyle(color: hexToColor("#606060"))));
                        }
                      }),
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

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/fotoBase64.txt');
}

//Future<File> writeFileContent(String _base64) async {
writeFileContent(String _base64) async {
  final file = await _localFile;
  file.writeAsString(_base64).then((_) {
    readFileContent();
  });
  //return file.writeAsString(_base64);
}

//Future<String> readFileContent() async {
readFileContent() async {
  try {
    final file = await _localFile;
    String contents = await file.readAsString();
    Image img = Image.memory(base64Decode(contents));
    global.image_foto = new DecorationImage(image: img.image);
    //return contents;
  } catch (e) {
    return 'Error';
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
      timeCita = DateTime.parse(datos["response"][i]["fecha"]);
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
