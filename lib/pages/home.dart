import 'dart:convert';
import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nutripuntos_app/pages/progreso.dart';
import 'package:flutter/services.dart';
import 'package:nutripuntos_app/src/meta.dart';
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
String recomendaciones = "";
bool validada = false;

class HomePage extends StatefulWidget {
  String prueba;
  HomePage({this.prueba});
  @override
  _HomePageState createState() => new _HomePageState(prueb: prueba);
}

class _HomePageState extends State<HomePage> {
  String prueb;
  _HomePageState({this.prueb});

  ///
  /// Header
  ///
  Container header() {
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

  ///
  /// Foto
  ///
  Container foto() {
    return Container(
      alignment: Alignment.topLeft,
      width: MediaQuery.of(context).size.width,
      child: GestureDetector(
        onTap: () {
          showAlertOption();
          //pickImageFrom(context, ImageSource.gallery);
        },
        child: Stack(
          children: <Widget>[
            Container(
              /// Fondo foto
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
            ),
            Container(
              /// Foto
              width: 80,
              height: 80,
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(
                  top: 14,
                  left: MediaQuery.of(context).size.width * 0.5 - 45), //130),
              decoration: BoxDecoration(
                //border: Border.all(width: 1, color: Colors.black),
                shape: BoxShape.circle,
                image: global.image_foto == null
                    ? DecorationImage(
                        image: AssetImage("assets/images/photo.jpg"),
                        fit: BoxFit.cover)
                    : global.image_foto,
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///
  /// Label Nombre
  ///
  Container nombre() {
    return Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.only(top: 0),
      margin: EdgeInsets.only(left: 0, top: 120),
      child: Text(
        global.usuario.nombre + " " + global.usuario.apellidos,
        style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  ///
  /// Label Status
  ///
  Container estatus() {
    return Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.only(top: 0),
      margin: EdgeInsets.only(left: 0, top: 150),
      child: Text(
        validada ? "Activo" : "Inactivo",
        style: TextStyle(fontSize: 14, color: Colors.white),
      ),
    );
  }

  ///
  /// Card Próxima cita
  ///
  Container proximaCita() {
    return Container(
      alignment: Alignment.topCenter,
      margin: const EdgeInsets.only(top: 40),
      child: FutureBuilder<List<Citas>>(
        future: getCitasProximas(global.usuario.token),
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

  ///
  /// Grid Botones
  ///
  Container botones() {
    return Container(
      alignment: Alignment.centerLeft,
      width: MediaQuery.of(context).size.width,
      height: 300,
      margin: const EdgeInsets.only(left: 0, top: 0, bottom: 20),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ///
              /// BOTON 1
              ///
              GestureDetector(
                onTap: () {
                  /*
                        global.selected_index = 4;
                        getReceta("").then((recetas) {
                          global.list_recetas = recetas;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => new RecetasPage(),
                            ),
                          );
                        });
                        */
                  show_Dialog(
                      context: context,
                      titulo: "Recomendaciones",
                      mensaje: recomendaciones);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width / 2.25,//150,
                  height: 150,
                  color: Colors.transparent,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Image.asset(
                        "assets/icons/recomendaciones.png",                        
                        height: 80,
                      ),
                      Container(
                        width: 150,
                        child: SizedBox(
                          child: Text(
                            "Recomendaciones",
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => new ProgresoPage(2)));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width / 2.25,//150,
                  height: 150,
                  color: Colors.transparent,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Image.asset(
                        "assets/icons/recurso_6.png",                        
                        height: 80,
                      ),
                      FutureBuilder<Meta>(
                          future:
                              db.DBManager.instance.getReto(global.usuario.id),
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
                                        "Presiona para agregar meta",
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
                                          minWidth: 150,
                                          maxWidth: 150,
                                          //maxHeight: 50,
                                          minHeight: 30),
                                      child: AutoSizeText(
                                        snapshot.data.meta,
                                        maxLines: 3,
                                        maxFontSize: 16,
                                        minFontSize: 16,
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
                                      style: TextStyle(
                                          color: hexToColor("#606060"))));
                            }
                          }),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ///
              /// BOTON 3
              ///
              GestureDetector(
                onTap: () {
                  global.selected_index = 1;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => new PlanPage(0),
                    ),
                  );
                },
                child: Container(
                  width: MediaQuery.of(context).size.width / 2.25,//150,
                  height: 150,
                  margin: EdgeInsets.only(left: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Image.asset(
                        "assets/icons/recurso_7.png",                        
                        height: 80,
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
                  width: MediaQuery.of(context).size.width / 2.25,//150,
                  height: 150,
                  margin: EdgeInsets.only(left: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Image.asset(
                        "assets/icons/recurso_8.png",                        
                        height: 80,
                      ),
                      Container(
                        width: 150,
                        child: SizedBox(
                          child: Text(
                            "Restaurantes",
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
        ],
      ),
    );
  }

  Future<T> show_Dialog<T>({
    @required BuildContext context,
    @required String titulo,
    @required String mensaje,
  }) {
    return showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return Builder(builder: (BuildContext context) {
          return Container(
            width: 400,
            height: 600,
            alignment: Alignment.center,
            margin: EdgeInsets.only(
              left: 30,
              right: 30,
              top: MediaQuery.of(context).size.height * 0.3,
              bottom: MediaQuery.of(context).size.height * 0.3,
            ),
            decoration: new BoxDecoration(
              color: hexToColor("#505050"),
              borderRadius: new BorderRadius.all(
                const Radius.circular(20.0),
              ),
            ),
            child: Column(
              children: <Widget>[
                /// BOTÓN CERRAR
                Container(
                  width: double.infinity,
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                        top: 20,
                        right: 20,
                      ),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ),

                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      /// TEXT TÍTULO GRUPO
                      Container(
                        alignment: Alignment.topCenter,
                        child: Text(
                          titulo,
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            fontFamily: "Arial",
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      /// TEXT INTRUCCIÓN
                      Container(
                        alignment: Alignment.topCenter,
                        margin: EdgeInsets.only(top: 30),
                        child: SizedBox(
                          width: 270,
                          child: AutoSizeText(
                            mensaje,
                            //maxLines: 3,
                            textAlign: TextAlign.center,
                            wrapWords: false,
                            style: TextStyle(
                              decoration: TextDecoration.none,
                              fontFamily: "Arial",
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
      },
      barrierDismissible: true,
      barrierLabel: "",
      barrierColor: null,
      transitionDuration: const Duration(milliseconds: 150),
    );
  }

  void showAlertOption() {
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
              child: Text(
                "Seleccionar de galería",
                style: TextStyle(color: Colors.blue),
              ),
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
            global.image_foto = new DecorationImage(
              image: Image.file(img).image,
              fit: BoxFit.cover,
            );
            db.DBManager.instance.updateFoto(global.usuario.id, img.path);
            List<int> imageBytes = img.readAsBytesSync();
            writeFileContent(base64Encode(imageBytes));
            readFileContent();
            //Navigator.pop(context);
          }
        });
      });
    } catch (e) {
      print("Error pickImageFrom " + e.toString());
      setState(() {
        global.image_foto = DecorationImage(
          image: AssetImage("assets/images/photo.jpg"),
          fit: BoxFit.cover,
        );
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

  @override
  void initState() {
    super.initState();    
    validaCuenta(global.usuario.token).then((_validada) {
      setState(() {
        validada = _validada;
      });
      if (validada == false)
        show_Dialog(
            context: context,
            titulo: "¡Lo sentimos! :(",
            mensaje:
                "Tu plan de alimentación ya no está disponible, ponte en contacto con tu especialista para obtener uno nuevo.");
    });

    getRecomendacion(global.usuario.token).then((_recomendaciones) {
      setState(() {
        recomendaciones = _recomendaciones;
      });
    });    
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {    
    return new WillPopScope(
      onWillPop: () {
        exit(0);
      },
      child: Stack(
        children: <Widget>[
          Scaffold(
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
                          proximaCita(),
                          botones(),
                        ],
                      ),
                    ),

                    header(),
                    foto(),
                    nombre(),
                    estatus(),
                  ],
                ),
              ],
            ),
          ),
          (validada == false)
              ? GestureDetector(
                  onTap: () {
                    show_Dialog(
                        context: context,
                        titulo: "¡Lo sentimos! :(",
                        mensaje:
                            "Tu plan de alimentación ya no está disponible, ponte en contacto con tu especialista para obtener uno nuevo.");
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: Colors.transparent,
                  ),
                )
              : Offstage(),
        ],
      ),
    );
  }
}

Future<String> get localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> get localFile async {
  final path = await localPath;
  return File('$path/fotoBase64.txt');
}

//Future<File> writeFileContent(String _base64) async {
void writeFileContent(String _base64) async {
  final file = await localFile;
  file.writeAsString(_base64).then((_) {
    readFileContent();
  });
  //return file.writeAsString(_base64);
}

//Future<String> readFileContent() async {
Future<String> readFileContent() async {
  try {
    final file = await localFile;
    String contents = await file.readAsString();
    Image img = Image.memory(base64Decode(contents));
    global.image_foto = new DecorationImage(image: img.image);
    //return contents;
  } catch (e) {
    return 'Error';
  }
}

Future<String> getRecomendacion(_token) async {
  try {
    String recomendacion;
    var response = await http.post(global.server + "/aplicacion/api",
        body: {"tipo": "recomendaciones", "token": _token});
    var datos = json.decode(utf8.decode(response.bodyBytes));
    //print(datos);
    if (datos["status"] == 1) {
      if (datos["response"].toString() != "" && datos["response"] != null)
        recomendacion = datos["response"].toString();
      else
        recomendacion =
            "En este momento el especialista no ha hecho ninguna recomendación";
    }
    return recomendacion;
  } catch (ex) {
    print("Error geRecomendacion " + ex.toString());
  }
}

Future<bool> validaCuenta(_token) async {
  try {
    bool vailda = false;
    var response = await http.post(global.server + "/aplicacion/api",
        body: {"tipo": "validar_cuenta", "token": _token});
    var datos = json.decode(utf8.decode(response.bodyBytes));
    print(datos);
    if (datos["status"] == 0)
      return false;
    else
      return true;
  } catch (ex) {
    print("Error validaCuenta " + ex.toString());
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
