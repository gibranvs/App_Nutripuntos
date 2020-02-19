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
  ///
  /// Label Título 1
  ///
  Container titulo1(_titulo) {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 20),
      child: Text(
        _titulo,
        style: TextStyle(
          color: hexToColor("#059696"),
          fontWeight: FontWeight.bold,
          fontSize: 17,
        ),
      ),
    );
  }

  ///
  /// Botones puntos
  ///
  Container botones(_comida) {
    return Container(
      height: 70,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 50),
      alignment: Alignment.center,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  //dialog(context, "assets/icons/Recurso_24.png", "GRUPO 1 VERDURAS", comida);
                  show_Dialog(
                    context: context,
                    titulo: "GRUPO 1 LIBRE",
                    imagen: "assets/icons/Recurso_24.png",
                    comida: _comida,
                    grupo: "4",
                  );
                },
                child: Container(
                  height: 70,
                  child: Image.asset("assets/icons/Recurso_24.png"),
                ),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  //dialog(context, "assets/icons/Recurso_23.png", "GRUPO 2 HARINAS", comida);
                  show_Dialog(
                    context: context,
                    titulo: "GRUPO 2 CARBOHIDRATOS",
                    imagen: "assets/icons/Recurso_23.png",
                    comida: _comida,
                    grupo: "1",
                  );
                },
                child: Container(
                  height: 70,
                  margin: EdgeInsets.only(left: 20),
                  child: Image.asset("assets/icons/Recurso_23.png"),
                ),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  //dialog(context, "assets/icons/Recurso_22.png", "GRUPO 3 CARNES", comida);
                  show_Dialog(
                    context: context,
                    titulo: "GRUPO 3 PROTEÍNAS",
                    imagen: "assets/icons/Recurso_22.png",
                    comida: _comida,
                    grupo: "2",
                  );
                },
                child: Container(
                  height: 70,
                  margin: EdgeInsets.only(left: 20),
                  child: Image.asset("assets/icons/Recurso_22.png"),
                ),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  //dialog(context, "assets/icons/Recurso_21.png", "GRUPO 4 LÍQUIDOS", comida);
                  show_Dialog(
                    context: context,
                    titulo: "GRUPO 4 GRASAS",
                    imagen: "assets/icons/Recurso_21.png",
                    comida: _comida,
                    grupo: "3",
                  );
                },
                child: Container(
                  height: 70,
                  margin: EdgeInsets.only(left: 20),
                  child: Image.asset("assets/icons/Recurso_21.png"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  ///
  /// Label Título 2
  ///
  Container titulo2(_titulo) {
    return Container(
      margin: EdgeInsets.only(top: 140, left: 20),
      child: Text(
        _titulo,
        style: TextStyle(
          color: hexToColor("#059696"),
          fontWeight: FontWeight.bold,
          fontSize: 17,
        ),
      ),
    );
  }

  ///
  /// List sugerencias
  ///
  Container sugerencias(_context, _index_comida) {
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
                                            _index_comida,
                                            (index + 1).toString())));
                              },
                              child: Card(
                                margin: EdgeInsets.only(bottom: 15),
                                elevation: 0,
                                color: hexToColor("#f2f2f2"),
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
        home: Container(
          decoration: new BoxDecoration(
            color: const Color(0x00FFCC00),
            image: new DecorationImage(
              image: new AssetImage("assets/images/fondo.jpg"),
              colorFilter: new ColorFilter.mode(
                  Colors.black.withOpacity(0.2), BlendMode.dstATop),
              fit: BoxFit.cover,
            ),
          ),
          child: FutureBuilder(
            future: getPestanas(global.token),
            builder: (_context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    semanticsLabel: "Loading",
                    backgroundColor: hexToColor("#cdcdcd"),
                  ),
                );
              } else if (snapshot.hasData) {
                int items = snapshot.data.length;
                List<Tab> tabs = new List<Tab>();
                List<Container> pages = new List<Container>();
                for (int i = 0; i < items; i++) {
                  tabs.add(Tab(
                    text: snapshot.data[i].nombre,
                  ));
                  pages.add(new Container(
                    decoration: new BoxDecoration(
                      image: new DecorationImage(
                        image: new AssetImage("assets/images/fondo.jpg"),
                        colorFilter: new ColorFilter.mode(
                            Colors.black.withOpacity(0.2), BlendMode.dstATop),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Stack(
                      children: <Widget>[
                        titulo1(snapshot.data[i].titulo1),
                        botones(snapshot.data[i].boton),
                        titulo2(snapshot.data[i].titulo2),
                        sugerencias(context, snapshot.data[i].index),
                      ],
                    ),
                  ));
                }

                return DefaultTabController(
                  length: snapshot.data.length,
                  child: Scaffold(
                    appBar: AppBar(
                      title: TabBar(
                        indicatorSize: TabBarIndicatorSize.tab,
                        isScrollable: true,
                        indicatorColor: Colors.white,
                        tabs: tabs,
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
                      children: pages,
                    ),
                  ),
                );
              }
            },
          ),
        ),

        /*
        DefaultTabController(
          length: 5,
          child: Scaffold(
            appBar: AppBar(
              title:                      
              TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                isScrollable: true,
                indicatorColor: Colors.white,
                tabs: [
                  Tab(
                    text: "Desayunos",
                  ),
                  Tab(
                    text: "CM",
                  ),
                  Tab(
                    text: "Comidas",
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
                      titulo1("Desayuno en puntos"),
                      botones_puntos("desayuno"),
                      titulo2("Sugerencias de desayuno"),
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
                      titulo1("Colación matutina en puntos"),
                      botones_puntos("colación matutina"),
                      titulo2("Sugerencias de colación matutina"),
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
                      titulo1("Almuerzo en puntos"),
                      botones_puntos("almuerzo"),
                      titulo2("Sugerencias de almuerzo"),
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
                      titulo1("Colación vespertina en puntos"),
                      botones_puntos("colación vespertina"),
                      titulo2("Sugerencias de colación vespertina"),
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
                      titulo1("Cena en puntos"),
                      botones_puntos("cena"),
                      titulo2("Sugerencias de cena"),
                      list_sugerencias(context, 4),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        */
      ),
    );
  }
}

void dialog(_context, _imagen, _titulo, _comida) async {
  showDialog(
      context: _context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
          ),
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
  @required String grupo,
}) {
  return showGeneralDialog(
    context: context,
    pageBuilder: (BuildContext buildContext, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return Builder(builder: (BuildContext context) {
        return Stack(
          children: <Widget>[
            /// BACK POPUP
            Container(
              width: 400,
              height: 600,
              alignment: Alignment.center,
              margin: EdgeInsets.only(left: 30, right: 30, top: 50, bottom: 50),
              decoration: new BoxDecoration(
                  color: hexToColor("#505050"),
                  borderRadius:
                      new BorderRadius.all(const Radius.circular(20.0))),
            ),

            /// BOTÓN CERRAR
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                margin: EdgeInsets.only(
                    top: 70, left: MediaQuery.of(context).size.width * 0.8),
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),

            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  /// IMAGEN GRUPO ALIMENTICIO
                  Container(
                    height: 90,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 30),
                    child: Image.asset(imagen),
                  ),

                  /// TEXT TÍTULO GRUPO
                  Container(
                    alignment: Alignment.topCenter,
                    margin: EdgeInsets.only(top: 10),
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

                  /// TEXT INTRUCCIÓN
                  Container(
                    alignment: Alignment.topCenter,
                    margin: EdgeInsets.only(top: 10),
                    child: SizedBox(
                      width: 270,
                      child: AutoSizeText(
                        "Elige un elemento de este grupo para equilibrar tu $comida dentro del plan nutrimental",
                        maxLines: 3,
                        textAlign: TextAlign.center,
                        wrapWords: false,
                        style: TextStyle(
                            decoration: TextDecoration.none,
                            fontFamily: "Arial",
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),

                  /// LIST ALIMENTOS
                  Container(
                    alignment: Alignment.center,
                    child: Container(
                      alignment: Alignment.center,
                      width: 270,
                      height: 300,
                      margin: EdgeInsets.only(top: 10),
                      padding: EdgeInsets.only(top: 0, bottom: 20),
                      child: FutureBuilder<List<String>>(
                          future: getAlimentosColor(global.token, grupo),
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
                              if (snapshot.data.length > 0) {
                                return Scrollbar(
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      padding: EdgeInsets.all(0),
                                      itemCount: snapshot.data.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          color: Colors.transparent,
                                          child: Container(
                                            height: 50,
                                            alignment: Alignment.center,
                                            child: Text(
                                              snapshot.data[index],
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                decoration: TextDecoration.none,
                                                fontFamily: "Arial",
                                                fontSize: 15,
                                                color: Colors.lightGreen,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                );
                              } else {
                                return new Text(
                                    "No hay sugerencias de alimentos para este grupo.",
                                    style: TextStyle(
                                        color: hexToColor("#606060")));
                              }
                            } else if (snapshot.hasError) {
                              return new Text(
                                  "Error al obtener sugerencias de alimentos del grupo.",
                                  style:
                                      TextStyle(color: hexToColor("#606060")));
                            }
                          }),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      });
    },
    barrierDismissible: true,
    barrierLabel: "",
    barrierColor: null,
    transitionDuration: const Duration(milliseconds: 150),
  );
}

Future<List<Data_pestanas>> getPestanas(_token) async {
  List<Data_pestanas> list_pestanas = new List<Data_pestanas>();
  list_pestanas.add(Data_pestanas(0, "Desayunos", "Desayuno en puntos",
      "Sugerencias de desayuno", "desayuno"));
  list_pestanas.add(Data_pestanas(1, "CM", "Colación matutina en puntos",
      "Sugerencias de colación matutina", "colación matutina"));
  list_pestanas.add(Data_pestanas(2, "Comidas", "Almuerzo en puntos",
      "Sugerencias de almuerzo", "almuerzo"));
  list_pestanas.add(Data_pestanas(3, "CV", "Colación vespertina en puntos",
      "Sugerencias de colación vespertina", "colación vespertina"));
  list_pestanas.add(Data_pestanas(
      4, "Cenas", "Cena en puntos", "Sugerencias de cena", "cena"));
  List<Data_pestanas> list = new List<Data_pestanas>();

  DateTime time = DateTime.now();
  String weekday = time.weekday.toString();

  try {
    var response = await http.post(global.server + "/aplicacion/api",
        body: {"tipo": "dieta", "token": _token});
    var datos = json.decode(utf8.decode(response.bodyBytes));
    if (datos["status"] == 1) {
      for (int i = 0; i < datos["response"]["d" + weekday].length; i++) {
        list.add(list_pestanas[i]);
      }
      return list;
    }
  } catch (e) {
    print("Error getPestañas " + e.toString());
  }
}

Future<List<Opciones_Dieta>> getOpcionesDieta(_token) async {
  //print (_token);
  try {
    List<Opciones_Dieta> list = new List<Opciones_Dieta>();

    DateTime time = DateTime.now();
    String weekday = time.weekday.toString();

    var response = await http.post(global.server + "/aplicacion/api",
        body: {"tipo": "dieta", "token": _token});
    var datos = json.decode(utf8.decode(response.bodyBytes));
    if (datos["status"] == 1) {
      for (int dias = 0;
          dias < datos["response"]["d" + weekday].length;
          dias++) {
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

Future<List<String>> getAlimentosColor(_token, _color) async {
// 1 - carbohidratos
// 2 - proteínas
// 3 - grasas
// 4 - libre
  try {
    List<String> list = new List<String>();
    var response = await http.post(global.server + "/aplicacion/api", body: {
      "tipo": "get_alimentos_color",
      "token": _token,
      "color": _color
    });
    var datos = json.decode(utf8.decode(response.bodyBytes));
    //print(datos);
    if (datos["status"] == 1) {
      for (int i = 0; i < datos["response"].length; i++) {
        list.add(datos["response"][i]["nombre"]);
      }
    }
    return list;
  } catch (e) {
    print("Error getAlimentosGrupo " + e.toString());
  }
}

class Opciones_Dieta {
  String id;
  String nombre;

  Opciones_Dieta({this.id, this.nombre});
}

class Data_pestanas {
  int index;
  String nombre;
  String titulo1;
  String titulo2;
  String boton;
  Data_pestanas(
      this.index, this.nombre, this.titulo1, this.titulo2, this.boton);
}
