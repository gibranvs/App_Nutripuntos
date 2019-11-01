import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:nutripuntos_app/src/HexToColor.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_charts/flutter_charts.dart' as chart;
import 'newmenu.dart' as newmenu;
import '../src/DBManager.dart' as db;
import 'package:http/http.dart' as http;
import 'package:nutripuntos_app/globals.dart' as global;

final myTextEdit = TextEditingController();
final myTextUpdate = TextEditingController();

class ProgresoPage extends StatefulWidget {
  final int index_tab;
  ProgresoPage(this.index_tab);
  @override
  _ProgresoPage createState() => new _ProgresoPage(index_tab);
}

class _ProgresoPage extends State<ProgresoPage> with TickerProviderStateMixin {
  final int index_tab;
  _ProgresoPage(this.index_tab);
  TabController _tabController;
  @override
  void initState() {
    _tabController =
        new TabController(length: 3, vsync: this, initialIndex: index_tab);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: new newmenu.menu(2),
      appBar: AppBar(
        elevation: 0,
        title: Text("Progreso"),
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
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              title: TabBar(
                controller: _tabController,
                tabs: [
                  Tab(
                    text: "Peso",
                  ),
                  Tab(
                    text: "Historial\nde grasa",
                  ),
                  Tab(
                    text: "Metas",
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
              controller: _tabController,
              children: [
                ///
                /// TAB PESO
                ///
                Stack(
                  children: <Widget>[
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
                    ),
                    Label_titulo("Gráfica de peso"),
                    Cuadro_informacion_peso("Último peso medido"),
                    Back_grafica("Peso en Kg"),
                    PesoChart(),
                    //Grafica_peso("Peso en Kg"),
                  ],
                ),

                ///
                /// TAB HISTORIAL
                ///
                Stack(
                  children: <Widget>[
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
                    ),
                    Label_titulo("Gráfica de Calorías"),
                    Cuadro_informacion_grasa("Última medida"),
                    Back_grafica("Progreso en Kcal"),
                    GrasaChart(),
                    //Grafica_grasa("Progreso en Kcal"),
                  ],
                ),

                ///
                /// TAB METAS
                ///
                Stack(
                  children: <Widget>[
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
                    ),
                    Label_titulo("Próxima Meta"),
                    Circle_image(context),
                    Label_subtitulo("Retos anteriores"),
                    List_metas(context),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Label_titulo extends StatelessWidget {
  final String titulo;
  Label_titulo(this.titulo);
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      margin: EdgeInsets.only(top: 20),
      child: Text(
        titulo,
        style: TextStyle(
            color: hexToColor("#059696"),
            fontWeight: FontWeight.bold,
            fontSize: 16),
      ),
    );
  }
}

class Label_subtitulo extends StatelessWidget {
  final String subtitulo;
  Label_subtitulo(this.subtitulo);
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.only(top: 200, left: 20),
      child: Text(
        subtitulo,
        style: TextStyle(
            color: hexToColor("#059696"),
            fontWeight: FontWeight.bold,
            fontSize: 16),
      ),
    );
  }
}

class Cuadro_informacion_peso extends StatelessWidget {
  final String leyenda;
  Cuadro_informacion_peso(this.leyenda);
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      margin: EdgeInsets.only(top: 60),
      child: Container(
        width: 160,
        height: 70,
        decoration: BoxDecoration(
          color: hexToColor("#059696"),
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Stack(
          children: <Widget>[
            Container(
              alignment: Alignment.topCenter,
              margin: EdgeInsets.only(top: 0),
              child: FutureBuilder<String>(
                  future: GetLastPeso(),
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
                      if (snapshot.data != null) {
                        return Column(
                          children: <Widget>[
                            Container(
                              alignment: Alignment.topCenter,
                              margin: EdgeInsets.only(top: 10),
                              child: Text(
                                snapshot.data + " KG",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22),
                              ),
                            ),
                            Container(
                              alignment: Alignment.topCenter,
                              margin: EdgeInsets.only(top: 5),
                              child: Text(
                                leyenda,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 15),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return new Text("No existe",
                            style: TextStyle(color: hexToColor("#606060")));
                      }
                    } else if (snapshot.hasError) {
                      return new Text("Error al obtener",
                          style: TextStyle(color: hexToColor("#606060")));
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

class Cuadro_informacion_grasa extends StatelessWidget {
  final String leyenda;
  Cuadro_informacion_grasa(this.leyenda);
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      margin: EdgeInsets.only(top: 60),
      child: Container(
        width: 160,
        height: 70,
        decoration: BoxDecoration(
          color: hexToColor("#059696"),
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Stack(
          children: <Widget>[
            Container(
              alignment: Alignment.topCenter,
              margin: EdgeInsets.only(top: 0),
              child: FutureBuilder<String>(
                  future: GetLastGrasa(),
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
                      if (snapshot.data != null) {
                        return Column(
                          children: <Widget>[
                            Container(
                              alignment: Alignment.topCenter,
                              margin: EdgeInsets.only(top: 10),
                              child: Text(
                                snapshot.data + " Kcal",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22),
                              ),
                            ),
                            Container(
                              alignment: Alignment.topCenter,
                              margin: EdgeInsets.only(top: 5),
                              child: Text(
                                leyenda,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 15),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return new Text("No existe",
                            style: TextStyle(color: hexToColor("#606060")));
                      }
                    } else if (snapshot.hasError) {
                      return new Text("Error al obtener",
                          style: TextStyle(color: hexToColor("#606060")));
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

class Back_grafica extends StatelessWidget {
  final String leyenda_y;
  Back_grafica(this.leyenda_y);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.75,
        height: MediaQuery.of(context).size.width * 0.75,
        margin: EdgeInsets.only(top: 130),
        decoration: BoxDecoration(
          color: hexToColor("#78c826"),
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Stack(
          children: <Widget>[
            ///
            /// LABEL AXIS Y
            ///
            RotatedBox(
              quarterTurns: -1,
              child: Container(
                alignment: Alignment.topCenter,
                margin: EdgeInsets.only(top: 10, left: 0),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  width: 115,
                  height: 20,
                  margin: EdgeInsets.only(top: 0, left: 5),
                  child: Text(leyenda_y,
                      style: TextStyle(
                          color: hexToColor("#059696"),
                          fontWeight: FontWeight.bold,
                          fontSize: 13)),
                ),
              ),
            ),

            ///
            /// LABEL AXIS X
            ///
            Container(
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.only(bottom: 10),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                width: 115,
                height: 20,
                margin: EdgeInsets.only(top: 0, left: 5),
                child: Text("Citas por mes",
                    style: TextStyle(
                        color: hexToColor("#059696"),
                        fontWeight: FontWeight.bold,
                        fontSize: 13)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PesoChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      width: MediaQuery.of(context).size.width * 0.65,
      height: MediaQuery.of(context).size.width * 0.65,
      margin: EdgeInsets.only(
          top: 150, left: MediaQuery.of(context).size.width * 0.23),
      child: FutureBuilder<List<Progreso>>(
          future: GetProgreso(),
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
              if (snapshot.data != null) {
                List<charts.Series<Medidas, num>> seriesList;
                var data = [
                  new Medidas(0, 'Enero', double.parse(snapshot.data[0].peso)),
                  new Medidas(
                      1, 'Febrero', double.parse(snapshot.data[1].peso)),
                  new Medidas(2, 'Marzo', double.parse(snapshot.data[2].peso)),
                  new Medidas(3, 'Abril', double.parse(snapshot.data[3].peso)),
                  new Medidas(4, 'Mayo', double.parse(snapshot.data[4].peso)),
                ];
                seriesList = new List<charts.Series<Medidas, num>>();
                seriesList.add(
                  new charts.Series<Medidas, int>(
                    data: data,
                    domainFn: (Medidas sales, _) => sales.mes,
                    measureFn: (Medidas sales, _) => sales.medida,
                    labelAccessorFn: (Medidas sales, _) => sales.nameMes,
                    //hexToColor("#059696"),
                    colorFn: (_, __) =>
                        charts.MaterialPalette.blue.shadeDefault,
                    id: 'Peso',
                  ),
                );
                return charts.LineChart(
                  seriesList,
                  //animate: false,
                  defaultRenderer: new charts.LineRendererConfig(
                    roundEndCaps: false,
                    includePoints: true,
                    strokeWidthPx: 2,
                    includeLine: true,
                    radiusPx: 5,
                  ),
                );
              } else {
                return new Center(
                    child: Text("No hay datos.",
                        style: TextStyle(color: hexToColor("#606060"))));
              }
            } else if (snapshot.hasError) {
              return new Center(
                  child: Text("Error al obtener datos.",
                      style: TextStyle(color: hexToColor("#606060"))));
            }
          }),
    );
  }
}

class GrasaChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      width: MediaQuery.of(context).size.width * 0.65,
      height: MediaQuery.of(context).size.width * 0.65,
      margin: EdgeInsets.only(
          top: 150, left: MediaQuery.of(context).size.width * 0.23),
      child: FutureBuilder<List<Progreso>>(
          future: GetProgreso(),
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
              if (snapshot.data != null) {
                List<charts.Series<Medidas, num>> seriesList;
                var data = [
                  new Medidas(0, 'Enero', double.parse(snapshot.data[0].grasa)),
                  new Medidas(
                      1, 'Febrero', double.parse(snapshot.data[1].grasa)),
                  new Medidas(2, 'Marzo', double.parse(snapshot.data[2].grasa)),
                  new Medidas(3, 'Abril', double.parse(snapshot.data[3].grasa)),
                  new Medidas(4, 'Mayo', double.parse(snapshot.data[4].grasa)),
                ];
                seriesList = new List<charts.Series<Medidas, num>>();
                seriesList.add(
                  new charts.Series<Medidas, int>(
                    data: data,
                    domainFn: (Medidas sales, _) => sales.mes,
                    measureFn: (Medidas sales, _) => sales.medida,
                    labelAccessorFn: (Medidas sales, _) => sales.nameMes,
                    //hexToColor("#059696"),
                    colorFn: (_, __) =>
                        charts.MaterialPalette.blue.shadeDefault,
                    id: 'Grasa',
                  ),
                );
                return charts.LineChart(
                  seriesList,
                  defaultRenderer: new charts.LineRendererConfig(
                    includePoints: true,
                    strokeWidthPx: 2,
                    includeLine: true,
                    radiusPx: 5,
                  ),
                );
              } else {
                return new Center(
                    child: Text("No hay datos.",
                        style: TextStyle(color: hexToColor("#606060"))));
              }
            } else if (snapshot.hasError) {
              return new Center(
                  child: Text("Error al obtener datos.",
                      style: TextStyle(color: hexToColor("#606060"))));
            }
          }),
    );
  }
}

class Medidas {
  final int mes;
  final String nameMes;
  final double medida;

  Medidas(this.mes, this.nameMes, this.medida);
}

class Grafica_peso extends StatelessWidget {
  final String leyenda_y;
  Grafica_peso(this.leyenda_y);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      margin: EdgeInsets.only(top: 170, bottom: 20),
      child: Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(top: 20, left: 40),
            height: 185,
            child: new Image.asset(
              "assets/icons/ejes.png",
            ),
          ),

          ///
          /// LABEL AXIS Y
          ///
          RotatedBox(
            quarterTurns: -1,
            child: Container(
              alignment: Alignment.topCenter,
              margin: EdgeInsets.only(top: 10, left: 0),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                width: 115,
                height: 20,
                margin: EdgeInsets.only(top: 0, left: 5),
                child: Text(leyenda_y,
                    style: TextStyle(
                        color: hexToColor("#059696"),
                        fontWeight: FontWeight.bold,
                        fontSize: 13)),
              ),
            ),
          ),

          ///
          /// LABEL AXIS X
          ///
          Container(
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.only(bottom: 10),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              width: 115,
              height: 20,
              margin: EdgeInsets.only(top: 0, left: 5),
              child: Text("Citas por mes",
                  style: TextStyle(
                      color: hexToColor("#059696"),
                      fontWeight: FontWeight.bold,
                      fontSize: 13)),
            ),
          ),

          ///
          /// MESES GRÁFICA
          ///
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(top: 15, left: 40),
            child: FutureBuilder<List<Progreso>>(
                future: GetProgreso(),
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
                          scrollDirection: Axis.horizontal,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return Container(
                              alignment: Alignment.bottomLeft,
                              margin: EdgeInsets.only(
                                  top: 170, left: 7, bottom: 10),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.bottomLeft,
                                    padding: EdgeInsets.only(left: 10),
                                    child: Text(snapshot.data[index].mes,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                            );
                          });
                    } else {
                      return new Center(
                          child: Text("No hay datos.",
                              style: TextStyle(color: hexToColor("#606060"))));
                    }
                  } else if (snapshot.hasError) {
                    return new Center(
                        child: Text("Error al obtener datos.",
                            style: TextStyle(color: hexToColor("#606060"))));
                  }
                }),
          ),

          ///
          /// DATOS GRÁFICA
          ///
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(top: 10, left: 44),
            child: FutureBuilder<List<Progreso>>(
                future: GetProgreso(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        /*
                        child:
                        CircularProgressIndicator(
                          strokeWidth: 2,
                          semanticsLabel: "Loading",
                          backgroundColor: hexToColor("#cdcdcd"),
                        ),
                        */
                        );
                  } else if (snapshot.hasData) {
                    if (snapshot.data.length > 0) {
                      return new ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            //List<double> heights = [85, 86, 86, 86, 86];
                            double height;
                            String text;
                            if (double.parse(snapshot.data[index].peso) == 0) {
                              height = 1;
                              text = "00.00";
                            } else {
                              height = double.parse(snapshot.data[index].peso);
                              text = snapshot.data[index].peso;
                            }
                            return Container(
                              alignment: Alignment.bottomLeft,
                              margin: EdgeInsets.only(bottom: 0, left: 10),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(
                                      //top: 155 - heights[index],
                                      top: 155 - height,
                                      bottom: 5,
                                    ),
                                    child: Text(text,
                                        style: TextStyle(
                                            fontSize: 10, color: Colors.white)),
                                  ),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    //height: heights[index],
                                    height: height,
                                    width: 20,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                            "assets/icons/barra_graphic.png"),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          });
                    } else {
                      return new Center(
                          child: Text("No hay datos.",
                              style: TextStyle(color: hexToColor("#606060"))));
                    }
                  } else if (snapshot.hasError) {
                    return new Center(
                        child: Text("Error al obtener datos.",
                            style: TextStyle(color: hexToColor("#606060"))));
                  }
                }),
          ),
        ],
      ),
    );
  }
}

class Grafica_grasa extends StatelessWidget {
  final String leyenda_y;
  Grafica_grasa(this.leyenda_y);
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      margin: EdgeInsets.only(top: 170, bottom: 20),
      child: Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(top: 20, left: 40),
            height: 185,
            child: new Image.asset("assets/icons/ejes.png"),
          ),

          ///
          /// LABEL AXIS Y
          ///
          RotatedBox(
            quarterTurns: -1,
            child: Container(
              alignment: Alignment.topCenter,
              margin: EdgeInsets.only(top: 10, left: 0),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                width: 115,
                height: 20,
                margin: EdgeInsets.only(top: 0, left: 5),
                child: Text(leyenda_y,
                    style: TextStyle(
                        color: hexToColor("#059696"),
                        fontWeight: FontWeight.bold,
                        fontSize: 13)),
              ),
            ),
          ),

          ///
          /// LABEL AXIS X
          ///
          Container(
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.only(bottom: 10),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              width: 115,
              height: 20,
              margin: EdgeInsets.only(top: 0, left: 5),
              child: Text("Citas por mes",
                  style: TextStyle(
                      color: hexToColor("#059696"),
                      fontWeight: FontWeight.bold,
                      fontSize: 13)),
            ),
          ),

          ///
          /// MESES GRÁFICA
          ///
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(top: 15, left: 40),
            child: FutureBuilder<List<Progreso>>(
                future: GetProgreso(),
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
                          scrollDirection: Axis.horizontal,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return Container(
                              alignment: Alignment.bottomLeft,
                              margin: EdgeInsets.only(
                                  top: 170, left: 7, bottom: 10),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.bottomLeft,
                                    padding: EdgeInsets.only(left: 10),
                                    child: Text(snapshot.data[index].mes,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                            );
                          });
                    } else {
                      return new Center(
                          child: Text("No hay datos.",
                              style: TextStyle(color: hexToColor("#606060"))));
                    }
                  } else if (snapshot.hasError) {
                    return new Center(
                        child: Text("Error al obtener datos.",
                            style: TextStyle(color: hexToColor("#606060"))));
                  }
                }),
          ),

          ///
          /// DATOS GRÁFICA
          ///
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(top: 10, left: 44),
            child: FutureBuilder<List<Progreso>>(
                future: GetProgreso(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        /*
                        child:
                        CircularProgressIndicator(
                          strokeWidth: 2,
                          semanticsLabel: "Loading",
                          backgroundColor: hexToColor("#cdcdcd"),
                        ),
                        */
                        );
                  } else if (snapshot.hasData) {
                    if (snapshot.data.length > 0) {
                      return new ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            //List<double> heights = [85, 86, 86, 86, 86];
                            double height;
                            String text;
                            if (double.parse(snapshot.data[index].grasa) == 0) {
                              height = 1;
                              text = "00.00";
                            } else {
                              height = double.parse(snapshot.data[index].grasa);
                              text = snapshot.data[index].grasa;
                            }
                            return Container(
                              alignment: Alignment.bottomLeft,
                              margin: EdgeInsets.only(bottom: 0, left: 10),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(
                                      //top: 155 - heights[index],
                                      top: 155 - height,
                                      bottom: 5,
                                    ),
                                    child: Text(text,
                                        style: TextStyle(
                                            fontSize: 10, color: Colors.white)),
                                  ),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    //height: heights[index],
                                    height: height,
                                    width: 20,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                            "assets/icons/barra_graphic.png"),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          });
                    } else {
                      return new Center(
                          child: Text("No hay datos.",
                              style: TextStyle(color: hexToColor("#606060"))));
                    }
                  } else if (snapshot.hasError) {
                    return new Center(
                        child: Text("Error al obtener datos.",
                            style: TextStyle(color: hexToColor("#606060"))));
                  }
                }),
          ),
        ],
      ),
    );
  }
}

class Circle_image extends StatelessWidget {
  final BuildContext _context;
  Circle_image(this._context);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showDialog(_context);
      },
      child: Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.topCenter,
            margin: EdgeInsets.only(top: 50),
            height: 130,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: Image.asset("assets/icons/Recurso_27.png").image)),
            child: //new Image.asset("assets/icons/Recurso_27.png"),
                FutureBuilder<Meta>(
                    future: db.DBManager.instance.getReto(global.token),
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
                        if (snapshot.data != null) {
                          if (snapshot.data.meta == "NA") {
                            return new Container(
                              alignment: Alignment.center,
                              child: Container(
                                alignment: Alignment.topLeft,
                                margin: EdgeInsets.only(top: 50),
                                constraints:
                                    BoxConstraints(minWidth: 80, maxWidth: 80),
                                child: AutoSizeText(
                                  "Presiona para agregar reto",
                                  textAlign: TextAlign.center,
                                  maxFontSize: 20,
                                  maxLines: 2,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 23),
                                ),
                              ),
                            );
                          } else {
                            return new Container(
                              alignment: Alignment.center,
                              child: Container(
                                alignment: Alignment.center,
                                constraints: BoxConstraints(
                                    minWidth: 70,
                                    maxWidth: 70,
                                    maxHeight: 80,
                                    minHeight: 80),
                                child: AutoSizeText(
                                  snapshot.data.meta,
                                  maxLines: 3,
                                  maxFontSize: 20,
                                  wrapWords: false,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ),
                            );
                          }
                        } else {
                          return new Center(
                              child: Text("No hay méta próxima.",
                                  style:
                                      TextStyle(color: hexToColor("#606060"))));
                        }
                      } else if (snapshot.hasError) {
                        return new Center(
                            child: Text("Error al obtener meta próxima.",
                                style:
                                    TextStyle(color: hexToColor("#606060"))));
                      }
                    }),
          ),
        ],
      ),
    );
  }
}

class List_metas extends StatelessWidget {
  final BuildContext _context;
  List_metas(this._context);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      //height: MediaQuery.of(context).size.height,
      margin: EdgeInsets.only(top: 230),
      child: SingleChildScrollView(
        child: Align(
          alignment: Alignment.center,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            child: FutureBuilder<List<Meta>>(
                future: db.DBManager.instance.getAllRetosPasados(global.token),
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
                            final item = snapshot.data[index];
                            return GestureDetector(
                              onTap: () {
                                myTextUpdate.text = snapshot.data[index].meta;
                                _showUpdateDialog(
                                    _context, snapshot.data[index].meta);
                              },
                              child: Slidable(
                                key: Key('s'),
                                actionExtentRatio: 0.25,
                                actionPane: Card(
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
                                                top: 0, left: 20),
                                            child: Container(
                                              width: 180,
                                              margin: EdgeInsets.only(top: 15),
                                              child: Text(
                                                snapshot.data[index].meta
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color:
                                                        hexToColor("#505050"),
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: 0, left: 20),
                                            child: Container(
                                              width: 200,
                                              margin: EdgeInsets.all(10),
                                              child: Text(
                                                snapshot.data[index].fecha
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color:
                                                        hexToColor("#ababab"),
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            alignment: Alignment.centerRight,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.18,
                                            height: 20,
                                            child: Icon(
                                              Icons.edit,
                                              color: hexToColor("#888888"),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                secondaryActions: <Widget>[
                                  Card(
                                    margin: EdgeInsets.only(bottom: 15),
                                    elevation: 0,
                                    color: Colors.red,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          'Borrar',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                dismissal: SlidableDismissal(
                                  child: SlidableDrawerDismissal(),
                                  onWillDismiss: (actionType) {
                                    return showDialog<bool>(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text(
                                            'Advertencia',
                                            textAlign: TextAlign.center,
                                          ),
                                          content: Text(
                                              '¿Seguro que desea borrar el reto "' +
                                                  snapshot.data[index].meta +
                                                  '"?',
                                              textAlign: TextAlign.center),
                                          actions: <Widget>[
                                            FlatButton(
                                                child: Text('Cancelar'),
                                                onPressed: () => {
                                                      Navigator.of(context)
                                                          .pop(false),
                                                    }),
                                            FlatButton(
                                                child: Text('Borrar'),
                                                onPressed: () {
                                                  db.DBManager.instance
                                                      .deleteReto(snapshot
                                                          .data[index].meta);
                                                  Navigator.of(context)
                                                      .pop(true);
                                                }),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
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
                                                top: 0, left: 20),
                                            child: Container(
                                              width: 180,
                                              margin: EdgeInsets.only(top: 15),
                                              child: Text(
                                                snapshot.data[index].meta
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color:
                                                        hexToColor("#505050"),
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: 0, left: 20),
                                            child: Container(
                                              width: 200,
                                              margin: EdgeInsets.all(10),
                                              child: Text(
                                                snapshot.data[index].fecha
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color:
                                                        hexToColor("#ababab"),
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            alignment: Alignment.centerRight,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.18,
                                            height: 20,
                                            child: Icon(
                                              Icons.edit,
                                              color: hexToColor("#888888"),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    } else {
                      return new Text("No hay retos anteriores.",
                          style: TextStyle(color: hexToColor("#606060")));
                    }
                  } else if (snapshot.hasError) {
                    return new Text("Error al obtener retos anteriores.",
                        style: TextStyle(color: hexToColor("#606060")));
                  }
                }),
          ),
        ),
      ),
    );
  }
}

_showDialog(context) async {
  await showDialog<String>(
    context: context,
    child: new AlertDialog(
      elevation: 4,
      contentPadding: const EdgeInsets.all(16.0),
      content: new Row(
        children: <Widget>[
          new Expanded(
            child: new TextField(
              controller: myTextEdit,
              autofocus: true,
              cursorColor: hexToColor("#059696"),
              decoration: new InputDecoration(
                labelText: 'Reto',
                hintText: 'ej. -3 KG en un mes',
              ),
            ),
          )
        ],
      ),
      actions: <Widget>[
        new FlatButton(
            child: Text('CANCELAR',
                style: TextStyle(color: hexToColor("#059696"))),
            onPressed: () {
              myTextEdit.text = "";
              Navigator.pop(context);
            }),
        new FlatButton(
            child:
                Text('GUARDAR', style: TextStyle(color: hexToColor("#059696"))),
            onPressed: () {
              if (myTextEdit.text != "") {
                db.DBManager.instance
                    .insertReto(global.id_user, global.token, myTextEdit.text);
                myTextEdit.text = "";
                Navigator.pop(context);
              }
            })
      ],
    ),
  );
}

_showUpdateDialog(context, _oldReto) async {
  await showDialog<String>(
    context: context,
    child: new AlertDialog(
      elevation: 4,
      contentPadding: const EdgeInsets.all(16.0),
      content: new Row(
        children: <Widget>[
          new Expanded(
            child: new TextField(
              controller: myTextUpdate,
              autofocus: true,
              cursorColor: hexToColor("#059696"),
              decoration: new InputDecoration(
                labelText: 'Reto',
                hintText: 'ej. -3 KG en un mes',
              ),
            ),
          )
        ],
      ),
      actions: <Widget>[
        new FlatButton(
            child: Text('CANCELAR',
                style: TextStyle(color: hexToColor("#059696"))),
            onPressed: () {
              myTextUpdate.text = "";
              Navigator.pop(context);
            }),
        new FlatButton(
            child:
                Text('EDITAR', style: TextStyle(color: hexToColor("#059696"))),
            onPressed: () {
              if (myTextUpdate.text != "") {
                db.DBManager.instance.updateReto(_oldReto, myTextUpdate.text);
                myTextUpdate.text = "";
                Navigator.pop(context);
              }
            })
      ],
    ),
  );
}

Future<String> GetLastPeso() async {
  try {
    String peso;

    var response = await http.post(global.server + "/aplicacion/api",
        body: {"tipo": "record", "token": global.token});
    var datos = json.decode(utf8.decode(response.bodyBytes));
    //print(datos);

    if (datos["status"] == 1) {
      for (int i = 0; i < datos["response"].length; i++) {
        if (datos["response"][i]["peso"] != null) {
          if (datos["response"][i]["peso"].toString().contains('.') == true) {
            if (datos["response"][i]["peso"].split('.')[1] == "00")
              peso = datos["response"][i]["peso"].split('.')[0];
            else
              peso = datos["response"][i]["peso"].toString();
          } else
            peso = datos["response"][i]["peso"].toString();
        } else
          peso = "0";
      }
    }
    return peso;
  } catch (e) {
    print("Error GetLastPeso " + e.toString());
  }
}

Future<String> GetLastGrasa() async {
  try {
    String grasa;

    var response = await http.post(global.server + "/aplicacion/api",
        body: {"tipo": "record", "token": global.token});
    var datos = json.decode(utf8.decode(response.bodyBytes));
    //print(datos);

    if (datos["status"] == 1) {
      for (int i = 0; i < datos["response"].length; i++) {
        if (datos["response"][i]["grasa"] != null) {
          if (datos["response"][i]["grasa"].toString().contains('.') == true) {
            if (datos["response"][i]["grasa"].split('.')[1] == "00")
              grasa = datos["response"][i]["grasa"].split('.')[0];
            else
              grasa = datos["response"][i]["grasa"].toString();
          } else
            grasa = datos["response"][i]["grasa"].toString();
        } else
          grasa = "0";
      }
    }
    return grasa;
  } catch (e) {
    print("Error GetLastGrasa " + e.toString());
  }
}

Future<List<Progreso>> GetProgreso() async {
  try {
    List<Progreso> list = new List<Progreso>();

    var response = await http.post(global.server + "/aplicacion/api",
        body: {"tipo": "record", "token": global.token});
    var datos = json.decode(utf8.decode(response.bodyBytes));
    //print(datos);

    if (datos["status"] == 1) {
      list.clear();
      for (int i = 0; i < datos["response"].length; i++) {
        //print(DateTime.parse(datos["response"][i]["fecha"]).month);
        String peso;
        if (datos["response"][i]["peso"] != null) {
          if (datos["response"][i]["peso"].toString().contains('.') == true) {
            if (datos["response"][i]["peso"].split('.')[1] == "00")
              peso = datos["response"][i]["peso"].split('.')[0];
            else
              peso = datos["response"][i]["peso"].toString();
          } else
            peso = datos["response"][i]["peso"].toString();
        } else
          peso = "0";
        String grasa;
        if (datos["response"][i]["grasa"] != null) {
          if (datos["response"][i]["grasa"].toString().contains('.') == true) {
            if (datos["response"][i]["grasa"].split('.')[1] == "00")
              grasa = datos["response"][i]["grasa"].split('.')[0];
            else
              grasa = datos["response"][i]["grasa"].toString();
          } else
            grasa = datos["response"][i]["grasa"].toString();
        } else
          grasa = "0";

        if (list.length == 0) {
          list.add(Progreso(
              peso: datos["response"][i]["peso"].toString(),
              grasa: datos["response"][i]["grasa"].toString(),
              fecha: new DateFormat("dd-MMM-yyyy")
                  .format(DateTime.parse(datos["response"][i]["fecha"]))
                  .toString(),
              dia: DateTime.parse(datos["response"][i]["fecha"]).day,
              mes: DateFormat("MMM")
                  .format(DateTime.parse(datos["response"][i]["fecha"]))
                  .toString(),
              anio: DateTime.parse(datos["response"][i]["fecha"]).year));
        } else {
          if (DateFormat("MMM")
                  .format(DateTime.parse(datos["response"][i]["fecha"]))
                  .toString() !=
              list[list.length - 1].mes) {
            list.add(Progreso(
                peso: datos["response"][i]["peso"].toString(),
                grasa: datos["response"][i]["grasa"].toString(),
                fecha: new DateFormat("dd-MMM-yyyy")
                    .format(DateTime.parse(datos["response"][i]["fecha"]))
                    .toString(),
                dia: DateTime.parse(datos["response"][i]["fecha"]).day,
                mes: DateFormat("MMM")
                    .format(DateTime.parse(datos["response"][i]["fecha"]))
                    .toString(),
                anio: DateTime.parse(datos["response"][i]["fecha"]).year));
          } else {
            list.removeAt(list.length - 1);
            list.add(Progreso(
                peso: datos["response"][i]["peso"].toString(),
                grasa: datos["response"][i]["grasa"].toString(),
                fecha: new DateFormat("dd-MMM-yyyy")
                    .format(DateTime.parse(datos["response"][i]["fecha"]))
                    .toString(),
                dia: DateTime.parse(datos["response"][i]["fecha"]).day,
                mes: DateFormat("MMM")
                    .format(DateTime.parse(datos["response"][i]["fecha"]))
                    .toString(),
                anio: DateTime.parse(datos["response"][i]["fecha"]).year));
          }
        }
      }

      for (int i = list.length; i > 0; i--) {
        if (list.length > 5)
          list.removeAt(0);
        else
          break;
      }
    }
    return list;
  } catch (e) {
    print("Error GetProgreso " + e.toString());
  }
}

class Progreso {
  String peso;
  String grasa;
  String fecha;
  int dia;
  String mes;
  int anio;

  Progreso({this.peso, this.grasa, this.fecha, this.dia, this.mes, this.anio});
}

class Meta {
  String meta;
  String status;
  String fecha;

  Meta({this.meta, this.status, this.fecha});
}
