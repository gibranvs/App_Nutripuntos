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
  final int index_tab;
  PlanPage(this.index_tab);
  @override
  _PlanPageState createState() => new _PlanPageState(index_tab);
}

class _PlanPageState extends State<PlanPage> with TickerProviderStateMixin {
  final int index_tab;
  _PlanPageState(this.index_tab);
  TabController _tabController;

  String valor_naranja = "0";
  String valor_azul = "0";
  String valor_amarillo = "0";
  String valor_verde = "0";
  Colores colores;
  Future<List<Opciones_Dieta>> opciones_dieta;
  Future<List<Data_pestanas>> pestanas;

  ///
  /// Label Título 1
  ///
  Container titulo1(_titulo) {
    return Container(
      margin: EdgeInsets.only(
        top: 20,
      ),
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
      height: 90,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 10),
      alignment: Alignment.center,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  //dialog(context, "assets/icons/Recurso_23.png", "GRUPO 2 HARINAS", comida);
                  show_Dialog(
                    context: context,
                    titulo: "CARBOHIDRATOS",
                    imagen: "assets/icons/Recurso_23.png",
                    comida: _comida,
                    grupo: "1",
                  );
                },
                child: Container(
                  height: 70,
                  child: Image.asset("assets/icons/Recurso_23.png"),
                ),
              ),
              Container(
                width: 20,
                height: 20,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: hexToColor("#EF5D24"), width: 2),
                ),
                child: AutoSizeText(
                  valor_naranja,
                  minFontSize: 2,
                  maxFontSize: 12,
                  wrapWords: false,
                  style: TextStyle(
                    color: hexToColor("#EF5D24"),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  //dialog(context, "assets/icons/Recurso_22.png", "GRUPO 3 CARNES", comida);
                  show_Dialog(
                    context: context,
                    titulo: "PROTEÍNAS",
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
              Row(
                children: <Widget>[
                  Container(
                    width: 15,
                  ),
                  Container(
                    width: 20,
                    height: 20,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                      border:
                          Border.all(color: hexToColor("#30AAD9"), width: 2),
                    ),
                    child: AutoSizeText(
                      valor_azul,
                      minFontSize: 2,
                      maxFontSize: 12,
                      wrapWords: false,
                      style: TextStyle(
                        color: hexToColor("#30AAD9"),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  //dialog(context, "assets/icons/Recurso_21.png", "GRUPO 4 LÍQUIDOS", comida);
                  show_Dialog(
                    context: context,
                    titulo: "GRASAS",
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
              Row(
                children: <Widget>[
                  Container(
                    width: 15,
                  ),
                  Container(
                    width: 20,
                    height: 20,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                      border:
                          Border.all(color: hexToColor("#F9B33A"), width: 2),
                    ),
                    child: AutoSizeText(
                      valor_amarillo,
                      minFontSize: 2,
                      maxFontSize: 12,
                      wrapWords: false,
                      style: TextStyle(
                        color: hexToColor("#F9B33A"),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  //dialog(context, "assets/icons/Recurso_24.png", "GRUPO 1 VERDURAS", comida);
                  show_Dialog(
                    context: context,
                    titulo: "LIBRE",
                    imagen: "assets/icons/Recurso_24.png",
                    comida: _comida,
                    grupo: "4",
                  );
                },
                child: Container(
                  height: 70,
                  margin: EdgeInsets.only(left: 20),
                  child: Image.asset("assets/icons/Recurso_24.png"),
                ),
              ),
              Row(
                children: <Widget>[
                  Container(
                    width: 15,
                  ),
                  Container(
                    width: 20,
                    height: 20,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: hexToColor("#23A246"),
                        width: 2,
                      ),
                    ),
                    child: AutoSizeText(
                      valor_verde,
                      minFontSize: 2,
                      maxFontSize: 12,
                      wrapWords: false,
                      style: TextStyle(
                        color: hexToColor("#23A246"),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
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
      margin: EdgeInsets.only(
        top: 20,
        bottom: 10,
      ),
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
  Widget sugerencias(_context, _index_comida) {
    return (opciones_dieta != null)
        ? Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 350,
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                ),
                child: (opciones_dieta != null)
                    ? FutureBuilder<List<Opciones_Dieta>>(
                        future:
                            opciones_dieta, //getOpcionesDieta(global.usuario.token),
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
                              return new ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, index) {
                                    String asset;
                                    switch (_index_comida) {
                                      case 0:
                                        asset =
                                            "assets/icons/tiempo_desayuno.png";
                                        break;
                                      case 1:
                                        asset = "assets/icons/tiempo_snack.png";
                                        break;
                                      case 2:
                                        asset =
                                            "assets/icons/tiempo_comida.png";
                                        break;
                                      case 3:
                                        asset = "assets/icons/tiempo_snack.png";
                                        break;
                                      case 4:
                                        asset = "assets/icons/tiempo_cena.png";
                                        break;
                                      case 5:
                                        asset =
                                            "assets/icons/tiempo_bebida.png";
                                        break;
                                    }
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          _context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                OpcionDetallePage(
                                                    global.usuario.token,
                                                    _index_comida,
                                                    (index + 1).toString(),
                                                    global.current_tab,
                                                    Colores(
                                                        azul: valor_azul,
                                                        naranja: valor_naranja,
                                                        amarillo:
                                                            valor_amarillo,
                                                        verde: valor_verde)),
                                          ),
                                        );
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
                                                      top: 5,
                                                      left: 5,
                                                      bottom: 3),
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        left: 5),
                                                    height: 80,
                                                    padding: EdgeInsets.all(5),
                                                    child:
                                                        new Image.asset(asset),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 0, left: 20),
                                                  child: Container(
                                                    width: 180,
                                                    child: Text(
                                                      snapshot
                                                          .data[index].nombre
                                                          .toString()
                                                          .toUpperCase(),
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: hexToColor(
                                                              "#505050"),
                                                          fontWeight:
                                                              FontWeight.bold),
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
                                  style:
                                      TextStyle(color: hexToColor("#606060")));
                            }
                          } else if (snapshot.hasError) {
                            return new Text(
                                "Error al obtener sugerencias de comida.",
                                style: TextStyle(color: hexToColor("#606060")));
                          }
                        })
                    : CircularProgressIndicator(),
              ),
            ),
          )
        : Offstage();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    pestanas = getPestanas();
    opciones_dieta = getOpcionesDieta(global.usuario.token);
    getColoresComida(0).then((_colores) {
      if (_colores != null) {
        setState(() {
          colores = _colores[0];
          valor_naranja = colores.naranja;
          valor_azul = colores.azul;
          valor_amarillo = colores.amarillo;
          valor_verde = "L";
        });
      } else {
        setState(() {
          valor_naranja = "0";
          valor_azul = "0";
          valor_amarillo = "0";
          valor_verde = "L";
        });
      }
    });

    setState(() {
      global.current_tab = index_tab;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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
        debugShowCheckedModeBanner: false,
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
            future: pestanas, //getPestanas(global.usuario.token),
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
                _tabController = new TabController(
                    length: snapshot.data.length,
                    vsync: this,
                    initialIndex: global.current_tab);

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
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          titulo1(snapshot.data[i].titulo1),
                          botones(snapshot.data[i].boton),
                          titulo2(snapshot.data[i].titulo2),
                          sugerencias(context, snapshot.data[i].index),
                        ],
                      ),
                    ),
                  ));
                }

                return DefaultTabController(
                  length: snapshot.data.length,
                  child: Scaffold(
                    appBar: AppBar(
                      title: TabBar(
                        controller: _tabController,
                        indicatorSize: TabBarIndicatorSize.tab,
                        isScrollable: true,
                        indicatorColor: Colors.white,
                        tabs: tabs,
                        onTap: (index) async {
                          global.current_tab = index;
                          await getColoresComida(index).then((_colores) {
                            if (_colores != null) {
                              colores = _colores[index];
                              valor_naranja = colores.naranja;
                              valor_azul = colores.azul;
                              valor_amarillo = colores.amarillo;
                              valor_verde = "L";
                            } else {
                              valor_naranja = "0";
                              valor_azul = "0";
                              valor_amarillo = "0";
                              valor_verde = "L";
                            }
                          });
                          setState(() {});
                        },
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
                      controller: _tabController,
                      children: pages,
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Future<List<Data_pestanas>> getPestanas() async {
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
          body: {"tipo": "dieta", "token": global.usuario.token});
      var datos = json.decode(utf8.decode(response.bodyBytes));
      //print(datos);
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
              height: MediaQuery.of(context).size.height - 50, //600,
              alignment: Alignment.center,
              margin: EdgeInsets.only(left: 30, right: 30, top: 50, bottom: 50),
              decoration: new BoxDecoration(
                color: hexToColor("#505050"),
                borderRadius: new BorderRadius.all(
                  const Radius.circular(20.0),
                ),
              ),
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
              margin: EdgeInsets.only(top: 70),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  /// IMAGEN GRUPO ALIMENTICIO
                  Container(
                    height: 90,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 0),
                    child: Image.asset(imagen),
                  ),

                  /// TEXT TÍTULO GRUPO
                  Container(
                    alignment: Alignment.topCenter,
                    margin: EdgeInsets.only(top: 20),
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
                  /*
                  Container(
                    alignment: Alignment.topCenter,
                    margin: EdgeInsets.only(top: 10),
                    child: SizedBox(
                      width: 270,
                      child: AutoSizeText(
                        "Elige un elemento de este grupo para equilibar tu $comida dentro del plan nutrimental",
                        maxLines: 3,
                        textAlign: TextAlign.center,
                        wrapWords: false,
                        style: TextStyle(
                          decoration: TextDecoration.none,
                          fontFamily: "Arial",
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  */

                  /// LIST ALIMENTOS
                  Container(
                    alignment: Alignment.center,
                    child: Container(
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height - 350,
                      margin: EdgeInsets.only(
                          left: 30, right: 30, top: 10, bottom: 50),
                      child: FutureBuilder<List<String>>(
                          future:
                              getAlimentosColor(global.usuario.token, grupo),
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
                                List<Color> coloresElementos = [
                                  hexToColor("#f6871f"),
                                  hexToColor("#22abd6"),
                                  hexToColor("#fcdc28"),
                                  hexToColor("#8acb4b"),
                                ];
                                return Scrollbar(
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      padding: EdgeInsets.all(0),
                                      itemCount: snapshot.data.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          color: Colors.transparent,
                                          child: Container(
                                            height: 40,
                                            alignment: Alignment.center,
                                            child: Text(
                                              snapshot.data[index],
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                decoration: TextDecoration.none,
                                                fontFamily: "Arial",
                                                fontSize: 15,
                                                color: coloresElementos[
                                                    int.parse(grupo) -
                                                        1], //Colors.lightGreen,
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

Future<List<Opciones_Dieta>> getOpcionesDieta(_token) async {
  //print (_token);
  try {
    List<Opciones_Dieta> list = new List<Opciones_Dieta>();

    DateTime time = DateTime.now();
    String weekday = time.weekday.toString();

    var response = await http.post(global.server + "/aplicacion/api",
        body: {"tipo": "dieta", "token": _token});
    var datos = json.decode(utf8.decode(response.bodyBytes));
    //print(datos["response"]["d6"]);
    if (datos["status"] == 1) {
      //for (int dias = 0; dias < datos["response"]["d" + weekday].length; dias++)
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

Future<List<Colores>> getColoresComida(_index_comida) async {
  try {
    DateTime time = DateTime.now();
    String weekday = time.weekday.toString();
    List<Colores> list = new List<Colores>();
    String azul = "0";
    String verde = "L";
    String naranja = "0";
    String amarillo = "0";

    var response = await http.post(global.server + "/aplicacion/api",
        body: {"tipo": "dieta", "token": global.usuario.token});
    var datos = json.decode(utf8.decode(response.bodyBytes));

    if (datos["status"] == 1) {
      //print(datos["puntos"]);
      for (int comida = 0; comida < datos["puntos"].length; comida++) {
        if (datos["puntos"][comida]["azul"] != null) {
          if (datos["puntos"][comida]["azul"].toString().contains('.') ==
              true) {
            if (datos["puntos"][comida]["azul"].split('.')[1] == "0")
              azul = datos["puntos"][comida]["azul"].split('.')[0];
            else
              azul = datos["puntos"][comida]["azul"].toString();
          } else
            azul = datos["puntos"][comida]["azul"].toString();
        } else
          azul = "0";

        if (datos["puntos"][comida]["naranja"] != null) {
          if (datos["puntos"][comida]["naranja"].toString().contains('.') ==
              true) {
            if (datos["puntos"][comida]["naranja"].split('.')[1] == "0")
              naranja = datos["puntos"][comida]["naranja"].split('.')[0];
            else
              naranja = datos["puntos"][comida]["naranja"].toString();
          } else
            naranja = datos["puntos"][comida]["naranja"].toString();
        } else
          naranja = "0";

        if (datos["puntos"][comida]["amarillo"] != null) {
          if (datos["puntos"][comida]["amarillo"].toString().contains('.') ==
              true) {
            if (datos["puntos"][comida]["amarillo"].split('.')[1] == "0")
              amarillo = datos["puntos"][comida]["amarillo"].split('.')[0];
            else
              amarillo = datos["puntos"][comida]["amarillo"].toString();
          } else
            amarillo = datos["puntos"][comida]["amarillo"].toString();
        } else
          amarillo = "0";

        verde = "L";

        list.add(Colores(
            azul: azul, naranja: naranja, amarillo: amarillo, verde: verde));
      }

      return list;
    }
  } catch (ex) {
    print("Error getColorCirclesWidgetValues: $ex");
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
    double porcion;
    String porcion_str;
    String alimento;
    if (datos["status"] == 1) {
      for (int i = 0; i < datos["response"].length; i++) {
        if (_color != "4") {
          porcion = double.parse(datos["response"][i]["porcion"]);
          if (porcion % 1 == 0)
            porcion_str = porcion.toString().split(".")[0];
          else
            porcion_str = porcion.toString();

          if (porcion <= 1) {
            alimento = porcion_str +
                " " +
                datos["response"][i]["medida"].toString().toLowerCase() +
                " de " +
                datos["response"][i]["nombre"].toString().toLowerCase();
          } else {
            if (datos["response"][i]["medida"].toString()[
                    datos["response"][i]["medida"].toString().length - 1] !=
                "s")
              alimento = porcion_str +
                  " " +
                  datos["response"][i]["medida"].toString().toLowerCase() +
                  "s de " +
                  datos["response"][i]["nombre"].toString().toLowerCase();
            else
              alimento = porcion_str +
                  " " +
                  datos["response"][i]["medida"].toString().toLowerCase() +
                  " de " +
                  datos["response"][i]["nombre"].toString().toLowerCase();
          }
          list.add(alimento);
        } else
          list.add(datos["response"][i]["nombre"].toString());
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

class Colores {
  String azul;
  String naranja;
  String amarillo;
  String verde;
  Colores({this.azul, this.naranja, this.amarillo, this.verde});
}
