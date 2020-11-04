import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nutripuntos_app/pages/home.dart';
import '../src/HexToColor.dart';
import 'package:nutripuntos_app/flutter_calendar_carousel.dart' as calendar;
import 'package:nutripuntos_app/globals.dart' as global;
import 'package:expandable/expandable.dart';
import '../classes/event.dart';
import '../classes/event_list.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'newmenu.dart' as newmenu;
import 'package:http/http.dart' as http;

CalendarData data_calendario;
Citas cita_seleccionada;
DateTime selectedDatetime;

class AgendaPage extends StatefulWidget {
  @override
  _AgendaPageState createState() => new _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  ///
  /// Calendario
  ///
  calendar.CalendarCarousel calendarCarousel() {
    return calendar.CalendarCarousel(
      leftButtonIcon:
          Icon(Icons.arrow_back, color: hexToColor("#059696"), size: 20),
      rightButtonIcon:
          Icon(Icons.arrow_forward, color: hexToColor("#059696"), size: 20),
      childAspectRatio: 1.5,
      showHeader: true,
      markedDateShowIcon: false,
      selectedDateTime: selectedDatetime,
      markedDates: (data_calendario != null) ? data_calendario.fechas : [],
      locale: "es_ES",
      markedDateWidget: Container(
        margin: EdgeInsets.only(top: 22, left: 19.5),
        child: Icon(
          Icons.brightness_1,
          size: 9,
          color: hexToColor("#059696"),
        ),
      ),
      headerMargin: EdgeInsets.only(top: 0),
      width: MediaQuery.of(context).size.width,
      todayBorderColor: hexToColor("#059696"),
      todayButtonColor: hexToColor("#059696"),
      weekendTextStyle: TextStyle(fontSize: 12, color: hexToColor("#666666")),
      iconColor: hexToColor("#059696"),
      selectedDayButtonColor: hexToColor("#cdcdcd"),
      headerTextStyle: TextStyle(
          fontSize: 18,
          color: hexToColor("#059696"),
          fontWeight: FontWeight.bold),
      weekdayTextStyle: TextStyle(
        fontSize: 14,
        color: hexToColor("#059696"),
      ),
      daysTextStyle: TextStyle(
        fontSize: 14,
        color: hexToColor("#666666"),
      ),
      nextDaysTextStyle: TextStyle(fontSize: 14, color: Colors.transparent),
      prevDaysTextStyle: TextStyle(fontSize: 14, color: Colors.transparent),
      onDayPressed: (date, list) async {
        var fecha = date.toString().split(" ")[0];
        //print(fecha);
        setState(() {
          cita_seleccionada = null;
          selectedDatetime = date;
        });
        getCita(fecha).then((_cita) {
          setState(() {
            cita_seleccionada = _cita;
          });
        });
      },
    );
  }

  ///
  /// Card Próxima
  ///
  Container cardProximaCita() {
    return Container(
      height: 120,
      alignment: Alignment.topCenter,
      margin: const EdgeInsets.only(top: 10),
      padding: EdgeInsets.all(10),
      child: (cita_seleccionada != null)
          ? Card(
              color: hexToColor("#f2f2f2"),
              elevation: 0,
              child: Row(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 12, left: 15, bottom: 2),
                        child: Text(
                          cita_seleccionada.fecha.toString().split("-")[0] +
                              "\n" +
                              cita_seleccionada.fecha.toString().split("-")[1],
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF059696)),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 2, left: 15, bottom: 12),
                        child: Text(cita_seleccionada.horario.toString()),
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
                        child: Text(cita_seleccionada.objetivo.toString()),
                      ),
                    ],
                  ),
                ],
              ),
            )
          : Card(
              color: hexToColor("#f2f2f2"),
              elevation: 0,
              child: Center(
                child: Text(
                  "No tienes citas pendientes.",
                  style: TextStyle(
                    color: hexToColor("#606060"),
                  ),
                ),
              ),
            ),
    );
  }

  ///
  /// Expandible citas anteriores
  ///
  ExpandableNotifier citasAnteriores() {
    return ExpandableNotifier(
      child: ScrollOnExpand(
        scrollOnExpand: false,
        scrollOnCollapse: true,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Card(
            color: hexToColor("#f2f2f2"),
            elevation: 0,
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: <Widget>[
                ScrollOnExpand(
                  scrollOnExpand: true,
                  scrollOnCollapse: false,
                  child: ExpandablePanel(
                    iconPlacement: ExpandablePanelIconPlacement.right,
                    hasIcon: false,
                    tapHeaderToExpand: true,
                    headerAlignment: ExpandablePanelHeaderAlignment.top,
                    header: Padding(
                      padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                      child: Container(
                        child: Stack(
                          children: <Widget>[
                            Container(
                              alignment: Alignment.topLeft,
                              margin: EdgeInsets.only(top: 10),
                              child: Text(
                                "Anteriores",
                                style: TextStyle(
                                    color: hexToColor("#059696"),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              alignment: Alignment.topRight,
                              margin: EdgeInsets.only(top: 0, right: 0),
                              child: Icon(
                                Icons.keyboard_arrow_down,
                                size: 40,
                                color: hexToColor("#059696"),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    expanded: FutureBuilder<List<Citas>>(
                        future: getCitasPasadas(global.usuario.token),
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
                                    return Card(
                                      color: hexToColor("#f2f2f2"),
                                      elevation: 0,
                                      child: Row(
                                        children: <Widget>[
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    top: 15,
                                                    left: 15,
                                                    bottom: 15),
                                                child: Text(
                                                  snapshot.data[index].fecha
                                                          .toString()
                                                          .split("-")[0] +
                                                      "\n" +
                                                      snapshot.data[index].fecha
                                                          .toString()
                                                          .split("-")[1],
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color(0xFF059696)),
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
                                                    top: 0, left: 25),
                                                child: Text(
                                                  snapshot.data[index].objetivo
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color:
                                                          hexToColor("#505050"),
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    top: 0, left: 25),
                                                child: Text(
                                                  snapshot.data[index].horario
                                                      .toString(),
                                                  style: TextStyle(
                                                      color:
                                                          hexToColor("#606060"),
                                                      fontSize: 14),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                            } else {
                              return new Text("No tienes citas anteriores.",
                                  style:
                                      TextStyle(color: hexToColor("#606060")));
                            }
                          } else if (snapshot.hasError) {
                            return Card(
                              color: hexToColor("#f2f2f2"),
                              elevation: 0,
                              child: Row(
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 4, left: 25, bottom: 12),
                                        child: Text(
                                            "Error al obtener citas anteriores."),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }
                        }),
                    builder: (_, collapsed, expanded) {
                      return Padding(
                        padding:
                            EdgeInsets.only(left: 10, right: 10, bottom: 10),
                        child: Expandable(
                          collapsed: collapsed,
                          expanded: expanded,
                          crossFadePoint: 0,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ExpandableNotifier citasProximas() {
    return ExpandableNotifier(
      child: ScrollOnExpand(
        scrollOnExpand: false,
        scrollOnCollapse: true,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Card(
            color: hexToColor("#f2f2f2"),
            elevation: 0,
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: <Widget>[
                ScrollOnExpand(
                  scrollOnExpand: true,
                  scrollOnCollapse: false,
                  child: ExpandablePanel(
                    iconPlacement: ExpandablePanelIconPlacement.right,
                    hasIcon: false,
                    tapHeaderToExpand: true,
                    headerAlignment: ExpandablePanelHeaderAlignment.top,
                    header: Padding(
                      padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                      child: Container(
                        child: Stack(
                          children: <Widget>[
                            Container(
                              alignment: Alignment.topLeft,
                              margin: EdgeInsets.only(top: 10),
                              child: Text(
                                "Próximas",
                                style: TextStyle(
                                    color: hexToColor("#059696"),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              alignment: Alignment.topRight,
                              margin: EdgeInsets.only(top: 0, right: 0),
                              child: Icon(
                                Icons.keyboard_arrow_down,
                                size: 40,
                                color: hexToColor("#059696"),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    expanded: FutureBuilder<List<Citas>>(
                        future: getCitasProximas(global.usuario.token),
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
                                    return Card(
                                      color: hexToColor("#f2f2f2"),
                                      elevation: 0,
                                      child: Row(
                                        children: <Widget>[
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    top: 15,
                                                    left: 15,
                                                    bottom: 15),
                                                child: Text(
                                                  snapshot.data[index].fecha
                                                          .toString()
                                                          .split("-")[0] +
                                                      "\n" +
                                                      snapshot.data[index].fecha
                                                          .toString()
                                                          .split("-")[1],
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color(0xFF059696)),
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
                                                    top: 0, left: 25),
                                                child: Container(
                                                  width: 180,
                                                  child: Text(
                                                    snapshot
                                                        .data[index].objetivo
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: hexToColor(
                                                            "#505050"),
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    top: 0, left: 25),
                                                child: Text(
                                                  snapshot.data[index].horario
                                                      .toString(),
                                                  style: TextStyle(
                                                      color:
                                                          hexToColor("#606060"),
                                                      fontSize: 14),
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
                                                  top: 0,
                                                ),
                                                child: Icon(
                                                  Icons.notifications,
                                                  size: 28,
                                                  color: hexToColor("#78c826"),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    );
                                  });
                            } else {
                              return new Text("No tienes citas próximas.",
                                  style:
                                      TextStyle(color: hexToColor("#606060")));
                            }
                          } else if (snapshot.hasError) {
                            return Card(
                              color: hexToColor("#f2f2f2"),
                              elevation: 0,
                              child: Row(
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 4, left: 25, bottom: 12),
                                        child: Text(
                                            "Error al obtener citas próximas."),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }
                        }),
                    builder: (_, collapsed, expanded) {
                      return Padding(
                        padding:
                            EdgeInsets.only(left: 10, right: 10, bottom: 10),
                        child: Expandable(
                          collapsed: collapsed,
                          expanded: expanded,
                          crossFadePoint: 0,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cita_seleccionada = null;
    getAllMarkers(global.usuario.token).then((_data) {
      setState(() {
        data_calendario = _data;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //getAllCitas(global.token);
    global.list_citas = null;
    return Scaffold(
      //drawer: new newmenu.menu(3),
      appBar: AppBar(
        elevation: 0,
        title: Text("Agenda"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
              ModalRoute.withName('/'),
            );
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
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
      body: MaterialApp(
        title: "Nutripuntos",
        debugShowCheckedModeBanner: false,
        home: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: TabBar(
                tabs: [
                  Tab(
                    text: "Calendario",
                  ),
                  Tab(
                    text: "Citas",
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
                /// TAB CALENDARIO
                ///
                Stack(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 0),
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
                    Column(
                      children: <Widget>[
                        Container(
                          height: 70,
                          color: hexToColor("#efefef"),
                        ),
                        Container(
                          height: 220,
                          color: hexToColor("#ffffff"),
                        ),
                        cardProximaCita(),
                      ],
                    ),
                    calendarCarousel(),
                  ],
                ),

                ///
                /// TAB CITAS
                ///
                Stack(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 0),
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
                    ListView(
                      children: <Widget>[
                        citasAnteriores(),
                        citasProximas(),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<CalendarData> getAllMarkers(_token) async {
    try {
      var response = await http.post(global.server + "/aplicacion/api",
          body: {"tipo": "consultas", "token": _token});
      var datos = json.decode(utf8.decode(response.bodyBytes));
      //print(datos);
      List<Citas> list_citas = new List<Citas>();
      List<DateTime> list_markers = new List<DateTime>();
      CalendarData data;
      for (int i = 0; i < datos["response"].length; i++) {
        //print(datos["response"][i]);
        list_citas.add(Citas(
            objetivo: datos["response"][i]["objetivo"],
            horario: new DateFormat("h:mm a")
                .format(DateTime.parse(datos["response"][i]["fecha"]))
                .toString(),
            fecha: new DateFormat("dd-MMM-yyyy G")
                .format(DateTime.parse(datos["response"][i]["fecha"]))
                .toString()
                .toUpperCase()));

        list_markers.add(new DateTime(
            int.parse(new DateFormat("dd-MM-yyyy")
                .format(DateTime.parse(datos["response"][i]["fecha"]))
                .toString()
                .split("-")[2]),
            int.parse(new DateFormat("dd-MM-yyyy")
                .format(DateTime.parse(datos["response"][i]["fecha"]))
                .toString()
                .split("-")[1]),
            int.parse(new DateFormat("dd-MM-yyyy")
                .format(DateTime.parse(datos["response"][i]["fecha"]))
                .toString()
                .split("-")[0])));
      }
      data = new CalendarData(fechas: list_markers, citas: list_citas);
      return data;
    } catch (e) {
      print("Error getAllMarkers " + e.toString());
    }
  }

  Future<Citas> getCita(_fecha) async {
    try {
      for (var c in data_calendario.citas) {
        var f = new DateFormat("dd-MMM-yyyy G")
            .format(DateTime.parse(_fecha))
            .toString()
            .toUpperCase();
        //print("F1 : " + f + "  F2: " + c.fecha);
        if (f == c.fecha) {
          //print(c.fecha);
          return c;
        }
      }
    } catch (e) {
      print("Error getCita " + e.toString());
    }
  }

  Future<List<Citas>> getCitasPasadas(_token) async {
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
        if (timeNow.difference(timeCita).inDays > 0) {
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
        //sprint(datos["response"][i]);
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
}

class Citas {
  String objetivo;
  String horario;
  String fecha;

  Citas({this.objetivo, this.horario, this.fecha});
}

class CalendarData {
  List<DateTime> fechas;
  List<Citas> citas;
  CalendarData({this.fechas, this.citas});
}
