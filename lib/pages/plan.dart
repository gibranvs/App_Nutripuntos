import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:nutripuntos_app/globals.dart' as global;
import 'newmenu.dart' as newmenu;
import 'package:nutripuntos_app/pages/opcion_detalle.dart';
import 'package:nutripuntos_app/src/HexToColor.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:nutripuntos_app/src/MessageAlert.dart';
import 'opcion_detalle.dart';

class PlanPage extends StatefulWidget {
  @override
  _PlanPageState createState() => new _PlanPageState();
}

class _PlanPageState extends State<PlanPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: new newmenu.menu(1),
      appBar: AppBar(
        elevation: 0,
        title: Text("Plan de alimentación"),
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
      body: MaterialApp(
        home: DefaultTabController(
          length: 5,
          child: Scaffold(
            appBar: AppBar(
              title: TabBar(
                tabs: [
                  Tab(
                    text: "Desayunos",
                  ),
                  Tab(
                    text: "CM",
                  ),
                  Tab(
                    text: "Almuerzos",
                  ),
                  Tab(
                    text: "CV",
                  ),
                  Tab(
                    text: "Cenas",
                  ),
                ],
              ),
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
            body: TabBarView(
              children: [
                ///
                /// TAB DESAYUNOS
                ///
                Container(
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
                      titulo1("Desayuno En Puntos"),
                      botones_puntos("desayuno"),
                      titulo2("Sugerencias De Desayuno"),
                      list_sugerencias(context, 0),
                    ],
                  ),
                ),

                ///
                /// TAB CM
                ///
                Container(
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
                      titulo1("Colación Matutina En Puntos"),
                      botones_puntos("colación matutina"),
                      titulo2("Sugerencias De Colación Matutina"),
                      list_sugerencias(context, 1),
                    ],
                  ),
                ),

                ///
                /// TAB ALMUERZOS
                ///
                Container(
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
                      titulo1("Almuerzo En Puntos"),
                      botones_puntos("almuerzo"),
                      titulo2("Sugerencias De Almuerzo"),
                      list_sugerencias(context, 2),
                    ],
                  ),
                ),

                ///
                /// TAB CV
                ///
                Container(
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
                      titulo1("Colación Vespertina En Puntos"),
                      botones_puntos("colación vespertina"),
                      titulo2("Sugerencias De Colación Vespertina"),
                      list_sugerencias(context, 3),
                    ],
                  ),
                ),

                /// TAB CENAS
                Container(
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
                      titulo1("Cena En Puntos"),
                      botones_puntos("cena"),
                      titulo2("Sugerencias De Cena"),
                      list_sugerencias(context, 4),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class titulo1 extends StatelessWidget {
  final String titulo;
  titulo1(this.titulo);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 20),
      child: Text(
        titulo,
        style: TextStyle(
          color: hexToColor("#059696"),
          fontWeight: FontWeight.bold,
          fontSize: 17,
        ),
      ),
    );
  }
}

class titulo2 extends StatelessWidget {
  final String titulo;
  titulo2(this.titulo);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 140, left: 20),
      child: Text(
        titulo,
        style: TextStyle(
          color: hexToColor("#059696"),
          fontWeight: FontWeight.bold,
          fontSize: 17,
        ),
      ),
    );
  }
}

class botones_puntos extends StatelessWidget {
  final String comida;
  botones_puntos(this.comida);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            //dialog(context, "assets/icons/Recurso_24.png", "GRUPO 1 VERDURAS", comida);
            show_Dialog(
              context: context,
              titulo: "GRUPO 1 VERDURAS",
              imagen: "assets/icons/Recurso_24.png",
              comida: comida,
            );
          },
          child: Container(
            height: 70,
            margin: EdgeInsets.only(top: 50, left: 20),
            child: Image.asset("assets/icons/Recurso_24.png"),
          ),
        ),
        GestureDetector(
          onTap: () {
            //dialog(context, "assets/icons/Recurso_23.png", "GRUPO 2 HARINAS", comida);
            show_Dialog(
              context: context,
              titulo: "GRUPO 2 HARINAS",
              imagen: "assets/icons/Recurso_23.png",
              comida: comida,
            );
          },
          child: Container(
            height: 70,
            margin: EdgeInsets.only(top: 50, left: 105),
            child: Image.asset("assets/icons/Recurso_23.png"),
          ),
        ),
        GestureDetector(
          onTap: () {
            //dialog(context, "assets/icons/Recurso_22.png", "GRUPO 3 CARNES", comida);
            show_Dialog(
              context: context,
              titulo: "GRUPO 3 PROTEINAS",
              imagen: "assets/icons/Recurso_22.png",
              comida: comida,
            );
          },
          child: Container(
            height: 70,
            margin: EdgeInsets.only(top: 50, left: 185),
            child: Image.asset("assets/icons/Recurso_22.png"),
          ),
        ),
        GestureDetector(
          onTap: () {
            //dialog(context, "assets/icons/Recurso_21.png", "GRUPO 4 LÍQUIDOS", comida);
            show_Dialog(
              context: context,
              titulo: "GRUPO 4 LÍQUIDOS",
              imagen: "assets/icons/Recurso_21.png",
              comida: comida,
            );
          },
          child: Container(
            height: 70,
            margin: EdgeInsets.only(top: 50, left: 270),
            child: Image.asset("assets/icons/Recurso_21.png"),
          ),
        ),
      ],
    );
  }
}

class list_sugerencias extends StatelessWidget {
  final BuildContext _context;
  final int index_comida;
  list_sugerencias(this._context, this.index_comida);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 170),
      child: SingleChildScrollView(
        child: Align(
          alignment: Alignment.center,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            child: FutureBuilder<List<Opciones_Dieta>>(
                future: getOpcionesDieta(global.token),
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
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    _context,
                                    MaterialPageRoute(
                                        builder: (context) => OpcionDetallePage(
                                            global.token,
                                            index_comida,
                                            (index + 1).toString())));
                              },
                              child: Card(
                                margin: EdgeInsets.only(bottom: 15),
                                elevation: 4,
                                child: Row(
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 5, left: 5, bottom: 3),
                                          child: Container(
                                            margin: EdgeInsets.only(left: 5),
                                            height: 80,
                                            child: new Image.asset(
                                                "assets/icons/Recurso_26.png"),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding:
                                              EdgeInsets.only(top: 0, left: 20),
                                          child: Container(
                                            width: 180,
                                            child: Text(
                                              snapshot.data[index].nombre
                                                  .toString()
                                                  .toUpperCase(),
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: hexToColor("#505050"),
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                    } else {
                      return new Text("No hay sugerencias de comida.",
                          style: TextStyle(color: hexToColor("#606060")));
                    }
                  } else if (snapshot.hasError) {
                    return new Text("Error al obtener sugerencias de comida.",
                        style: TextStyle(color: hexToColor("#606060")));
                  }
                }),
          ),
        ),
      ),
    );
  }
}

dialog(_context, _imagen, _titulo, _comida) async {
  showDialog(
      context: _context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          backgroundColor: hexToColor("#505050"),
          content: Container(
            padding: EdgeInsets.only(top: 0),
            height: 380,
            child: Stack(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                        top: 0, left: MediaQuery.of(context).size.width * 0.58),
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
                Container(
                  height: 90,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 25),
                  child: Image.asset(_imagen),
                ),
                Container(
                  alignment: Alignment.topCenter,
                  margin: EdgeInsets.only(top: 130),
                  child: Text(
                    _titulo,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  alignment: Alignment.topCenter,
                  margin: EdgeInsets.only(top: 180),
                  child: SizedBox(
                    width: 270,
                    child: AutoSizeText(
                      "Elige un elemento de este grupo para equilibrar tu $_comida dentro del plan nutrimental",
                      maxLines: 3,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      });
}

Future<T> show_Dialog<T>({
  @required BuildContext context,
  @required String imagen,
  @required String titulo,
  @required String comida,
}) {
  return showGeneralDialog(
    context: context,
    pageBuilder: (BuildContext buildContext, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return Container(
        child: Builder(builder: (BuildContext context) {
          return Container(
            alignment: Alignment.topCenter,
            color: Colors.transparent,
            child: Stack(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  width: 400,
                  height: 600,
                  margin: EdgeInsets.only(
                      left: 30, right: 30, top: 170, bottom: 10),
                  decoration: new BoxDecoration(
                      color: hexToColor("#505050"),
                      borderRadius:
                          new BorderRadius.all(const Radius.circular(20.0))),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                        top: 190,
                        left: MediaQuery.of(context).size.width * 0.78),
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
                Container(
                  height: 90,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 195),
                  child: Image.asset(imagen),
                ),
                Container(
                  alignment: Alignment.topCenter,
                  margin: EdgeInsets.only(top: 300),
                  child: Text(
                    titulo,
                    style: TextStyle(
                        decoration: TextDecoration.none,
                        fontFamily: "Arial",
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  alignment: Alignment.topCenter,
                  margin: EdgeInsets.only(top: 340),
                  child: SizedBox(
                    width: 270,
                    child: AutoSizeText(
                      "Elige un elemento de este grupo para equilibrar tu $comida dentro del plan nutrimental",
                      maxLines: 3,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          fontFamily: "Arial",
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      );
    },
    barrierDismissible: true,
    barrierLabel: "",
    barrierColor: null,
    transitionDuration: const Duration(milliseconds: 150),
  );
}

Future<List<Opciones_Dieta>> getOpcionesDieta(_token) async {
  try {
    List<Opciones_Dieta> list = new List<Opciones_Dieta>();

    var response = await http.post(global.server + "/aplicacion/api",
        body: {"tipo": "dieta", "token": _token});
    var datos = json.decode(utf8.decode(response.bodyBytes));
    //print(datos);
    if (datos["status"] == 1) {
      for (int dias = 0; dias < datos["response"].length; dias++) {
        list.add(Opciones_Dieta(
          id: (dias + 1).toString(),
          nombre: "Opción " + (dias + 1).toString(),
        ));
      }
      return list;
    }
  } catch (e) {
    print("Error getOpcionesDieta " + e.toString());
  }
}

class Opciones_Dieta {
  String id;
  String nombre;

  Opciones_Dieta({this.id, this.nombre});
}
