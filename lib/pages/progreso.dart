import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:nutripuntos_app/pages/home.dart';
import 'dart:math';
import 'package:nutripuntos_app/src/HexToColor.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:nutripuntos_app/src/meta.dart';
//import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'newmenu.dart' as newmenu;
import '../src/DBManager.dart' as db;
import 'package:http/http.dart' as http;
import 'package:nutripuntos_app/globals.dart' as global;

final myTextEdit = TextEditingController();
final myTextUpdate = TextEditingController();

Future<String> lastPeso;
Future<String> lastGrasa;
Future<List<Progreso>> progreso;

LineChartBarData lineChartBarDataPeso;
LineChartBarData lineChartBarDataGrasa;

bool pendientes_selected = false;
bool completos_selected = false;

double min_peso = 0;
double max_peso = 0;
double min_grasa = 0;
double max_grasa = 0;

class ProgresoPage extends StatefulWidget {
  final int index_tab;
  ProgresoPage(this.index_tab);
  @override
  _ProgresoPageState createState() => new _ProgresoPageState(index_tab);
}

class _ProgresoPageState extends State<ProgresoPage>
    with TickerProviderStateMixin {
  final int index_tab;
  _ProgresoPageState(this.index_tab);
  TabController _tabController;

  ///
  /// Label Título
  ///
  Container titulo(_titulo) {
    return Container(
      alignment: Alignment.topCenter,
      margin: EdgeInsets.only(top: 20),
      child: Text(
        _titulo,
        style: TextStyle(
            color: hexToColor("#059696"),
            fontWeight: FontWeight.bold,
            fontSize: 16),
      ),
    );
  }

  ///
  /// Widget información peso
  ///
  Container informacionPeso(_leyenda) {
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
                  future: lastPeso, //getLastPeso(),
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
                                snapshot.data + " kg",
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
                                _leyenda,
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

  ///
  /// Widget Información grasa
  ///
  Container informacionGrasa(_leyenda) {
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
                  future: lastGrasa, // getLastGrasa(),
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
                                snapshot.data + " kg",
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
                                _leyenda,
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

  ///
  /// Gráfica Peso
  ///
  Container historialPeso(_leyenda_y) {
    return Container(
      margin: EdgeInsets.only(top: 40),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width * 1.3,
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.width * 0.9,
              margin: EdgeInsets.only(
                top: 100,
              ),
              child: Card(
                color: Colors.transparent,
                elevation: 0,
                child: Stack(
                  children: <Widget>[
                    /// BACK GRÁFICA
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                          color: hexToColor("#78c826"),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Stack(
                          children: <Widget>[
                            /// LABEL AXIS Y
                            RotatedBox(
                              quarterTurns: -1,
                              child: Container(
                                alignment: Alignment.topCenter,
                                margin: EdgeInsets.only(top: 10, left: 0),
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  width: 115,
                                  height: 20,
                                  margin: EdgeInsets.only(top: 0, left: 5),
                                  child: Text(_leyenda_y,
                                      style: TextStyle(
                                          color: hexToColor("#059696"),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13)),
                                ),
                              ),
                            ),

                            /// LABEL AXIS X
                            Container(
                              alignment: Alignment.bottomCenter,
                              margin: EdgeInsets.only(bottom: 10),
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                                width: 115,
                                height: 20,
                                margin: EdgeInsets.only(top: 0, left: 5),
                                child: Text("Fecha de cita",
                                    style: TextStyle(
                                        color: hexToColor("#059696"),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    /// CHART
                    Container(
                      padding: EdgeInsets.only(
                        left: 50,
                        right: 30,
                        top: 30,
                        bottom: 70,
                      ),
                      child: FutureBuilder<List<Progreso>>(
                          future: progreso, //getProgreso(),
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
                                var pesos = [];
                                var spots = [];
                                for (int p = 0; p < snapshot.data.length; p++) {
                                  pesos.add(snapshot.data[p].peso);
                                  spots.add(FlSpot(
                                      double.parse((p + 1).toString()),
                                      double.parse(snapshot.data[p].peso)));
                                }
                                /*                  
                                var pesos = [
                                  double.parse(snapshot.data[0].peso),
                                  double.parse(snapshot.data[1].peso),
                                  double.parse(snapshot.data[2].peso),
                                  double.parse(snapshot.data[3].peso)
                                ];
                               */
                                min_peso = pesos[0];
                                max_peso = pesos[0];
                                pesos.forEach((element) {
                                  if (element > max_peso) max_peso = element;
                                  if (element < min_peso) min_peso = element;
                                });
                                print(pesos);
                                print("min peso: " + min_peso.toString());
                                print("max peso: " + max_peso.toString());
                                lineChartBarDataPeso = LineChartBarData(
                                  spots: spots,
                                  /*
                                  spots: [
                                    FlSpot(1, pesos[0]),
                                    FlSpot(2, pesos[1]),
                                    FlSpot(3, pesos[2]),
                                    FlSpot(4, pesos[3]),
                                  ],
                                  */
                                  isCurved: false,
                                  colors: [
                                    hexToColor("#059696"),
                                  ],
                                  barWidth: 2,
                                  isStrokeCapRound: true,
                                  dotData: FlDotData(
                                    show: true,
                                  ),
                                  belowBarData: BarAreaData(
                                    show: true,
                                    applyCutOffY: true,
                                    cutOffY: 10,
                                    colors: [
                                      Colors.transparent,
                                    ],
                                    gradientColorStops: [0.5, 1.0],
                                    gradientFrom: const Offset(0, 0),
                                    gradientTo: const Offset(0, 1),
                                    spotsLine: BarAreaSpotsLine(
                                      show: true,
                                      flLineStyle: FlLine(
                                        color: Colors.blue,
                                        strokeWidth: 0.5,
                                      ),
                                      checkToShowSpotLine: (spot) {
                                        if (spot.x == 0 || spot.x == 6) {
                                          return false;
                                        }
                                        return true;
                                      },
                                    ),
                                  ),
                                );

                                return LineChart(
                                  LineChartData(
                                    lineTouchData: LineTouchData(
                                      touchTooltipData: LineTouchTooltipData(
                                        tooltipBgColor: Colors.white,
                                      ),
                                      touchCallback:
                                          (LineTouchResponse touchResponse) {},
                                      handleBuiltInTouches: true,
                                    ),
                                    gridData: FlGridData(
                                      show: true,
                                    ),
                                    titlesData: FlTitlesData(
                                      bottomTitles: SideTitles(
                                        showTitles: true,
                                        margin: 20,
                                        /*
                                        textStyle: TextStyle(
                                          color: hexToColor("#676767"),
                                          fontSize: 12,
                                        ),
                                        */
                                        reservedSize: 30,
                                        getTextStyles: (value) {
                                          TextStyle(
                                              color: hexToColor("#676767"),
                                              fontSize: 9);
                                        },
                                        getTitles: (value) {
                                          switch (value.toInt()) {
                                            case 1:
                                              return snapshot.data[0].fecha;
                                            case 2:
                                              return snapshot.data[1].fecha;
                                            case 3:
                                              return snapshot.data[2].fecha;
                                            case 4:
                                              return snapshot.data[3].fecha;
                                              break;
                                          }
                                          return '';
                                        },
                                        rotateAngle: 90,
                                      ),
                                      leftTitles: SideTitles(
                                        showTitles: false,
                                        getTextStyles: (value) {
                                          TextStyle(
                                              color: hexToColor("#676767"),
                                              fontSize: 9);
                                        },
                                        /*
                                        textStyle: TextStyle(
                                          color: hexToColor("#676767"),
                                          fontSize: 10,
                                        ),
                                        */
                                        rotateAngle: 0,
                                        margin: 10,
                                      ),
                                    ),
                                    borderData: FlBorderData(
                                      show: true,
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.black,
                                          width: 1,
                                        ),
                                        left: BorderSide(
                                          color: Colors.black,
                                          width: 1,
                                        ),
                                        right: BorderSide(
                                          color: Colors.transparent,
                                        ),
                                        top: BorderSide(
                                          color: Colors.transparent,
                                        ),
                                      ),
                                    ),
                                    //minX: 0,
                                    //maxX: 4,
                                    //maxY: 4,
                                    minY: (min_peso > 0)
                                        ? min_peso - 1
                                        : min_peso,
                                    maxY: max_peso + 1,
                                    lineBarsData: [lineChartBarDataPeso],
                                  ),
                                  swapAnimationDuration:
                                      const Duration(milliseconds: 250),
                                );

                                /*
                                var data = [
                                  new TimeSeriesDatos(
                                    new DateTime(
                                      int.tryParse(
                                          snapshot.data[0].fecha.split('-')[2]),
                                      int.tryParse(
                                          snapshot.data[0].fecha.split('-')[1]),
                                      int.tryParse(
                                          snapshot.data[0].fecha.split('-')[0]),
                                    ),
                                    double.parse(snapshot.data[0].peso),
                                  ),
                                  new TimeSeriesDatos(
                                    new DateTime(
                                      int.tryParse(
                                          snapshot.data[1].fecha.split('-')[2]),
                                      int.tryParse(
                                          snapshot.data[1].fecha.split('-')[1]),
                                      int.tryParse(
                                          snapshot.data[1].fecha.split('-')[0]),
                                    ),
                                    double.parse(snapshot.data[1].peso),
                                  ),
                                  new TimeSeriesDatos(
                                    new DateTime(
                                      int.tryParse(
                                          snapshot.data[2].fecha.split('-')[2]),
                                      int.tryParse(
                                          snapshot.data[2].fecha.split('-')[1]),
                                      int.tryParse(
                                          snapshot.data[2].fecha.split('-')[0]),
                                    ),
                                    double.parse(snapshot.data[2].peso),
                                  ),
                                  new TimeSeriesDatos(
                                    new DateTime(
                                      int.tryParse(
                                          snapshot.data[3].fecha.split('-')[2]),
                                      int.tryParse(
                                          snapshot.data[3].fecha.split('-')[1]),
                                      int.tryParse(
                                          snapshot.data[3].fecha.split('-')[0]),
                                    ),
                                    double.parse(snapshot.data[3].peso),
                                  ),
                                ];                                
                                
                                return SfCartesianChart(
                                  plotAreaBorderWidth: 1,
                                  tooltipBehavior: TooltipBehavior(
                                    enable: true,
                                    elevation: 3,
                                    textAlignment: ChartAlignment.center,
                                    format: 'point.y kg  [point.x]',
                                    header: "Peso",
                                  ),
                                  primaryXAxis: CategoryAxis(
                                    labelRotation: 90,
                                    labelPosition:
                                        ChartDataLabelPosition.outside,
                                    tickPosition: TickPosition.outside,
                                    edgeLabelPlacement: EdgeLabelPlacement.none,
                                    axisLine: AxisLine(
                                      color: Colors.black,
                                    ),
                                    minorTickLines: MinorTickLines(
                                      size: 6,
                                      width: 2,
                                      color: hexToColor("#059696"),
                                    ),
                                    majorTickLines: MajorTickLines(
                                      size: 6,
                                      width: 2,
                                      color: hexToColor("#b0b0b0"),
                                    ),
                                  ),
                                  primaryYAxis: NumericAxis(
                                    interval: 1,
                                    rangePadding: ChartRangePadding.auto,
                                    tickPosition: TickPosition.outside,
                                    axisLine: AxisLine(
                                      color: Colors.black,
                                    ),
                                  ),
                                  series: <ChartSeries>[
                                    LineSeries<TimeSeriesDatos, String>(
                                      dataSource: data,
                                      width: 4,
                                      pointColorMapper: (TimeSeriesDatos, _) =>
                                          hexToColor("#059696"),
                                      xValueMapper:
                                          (TimeSeriesDatos datos, _) =>
                                              DateFormat("dd/MM/yyyy")
                                                  .format(datos.time),
                                      yValueMapper:
                                          (TimeSeriesDatos datos, _) =>
                                              datos.dato,
                                      markerSettings: MarkerSettings(
                                        isVisible: true,
                                        width: 12,
                                        height: 12,
                                      ),
                                    )
                                  ],
                                );
                                */
                              } else {
                                return new Center(
                                    child: Text("No hay datos.",
                                        style: TextStyle(
                                            color: hexToColor("#606060"))));
                              }
                            } else if (snapshot.hasError) {
                              return new Center(
                                  child: Text("Error al obtener datos.",
                                      style: TextStyle(
                                          color: hexToColor("#606060"))));
                            }
                          }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///
  /// Gráfica Grasa
  ///
  Container historialGrasa(_leyenda_y) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width * 1.3,
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.width * 0.9,
              margin: EdgeInsets.only(
                top: 100,
              ),
              child: Card(
                elevation: 0,
                color: Colors.transparent,
                child: Stack(
                  children: <Widget>[
                    /// BACK GRÁFICA
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                          color: hexToColor("#78c826"),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Stack(
                          children: <Widget>[
                            /// LABEL AXIS Y
                            RotatedBox(
                              quarterTurns: -1,
                              child: Container(
                                alignment: Alignment.topCenter,
                                margin: EdgeInsets.only(top: 10, left: 0),
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  width: 115,
                                  height: 20,
                                  margin: EdgeInsets.only(top: 0, left: 5),
                                  child: Text(_leyenda_y,
                                      style: TextStyle(
                                          color: hexToColor("#059696"),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13)),
                                ),
                              ),
                            ),

                            /// LABEL AXIS X
                            Container(
                              alignment: Alignment.bottomCenter,
                              margin: EdgeInsets.only(bottom: 10),
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                                width: 115,
                                height: 20,
                                margin: EdgeInsets.only(top: 0, left: 5),
                                child: Text("Fecha de cita",
                                    style: TextStyle(
                                        color: hexToColor("#059696"),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    /// CHART
                    Container(
                      padding: EdgeInsets.only(
                        left: 50,
                        right: 30,
                        top: 30,
                        bottom: 70,
                      ),
                      child: FutureBuilder<List<Progreso>>(
                          future: progreso, //getProgreso(),
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
                                var grasas = [];
                                var spots = [];
                                for (int g = 0; g < snapshot.data.length; g++) {
                                  grasas.add(snapshot.data[g].grasa);
                                  spots.add(FlSpot(
                                      double.parse((g + 1).toString()),
                                      double.parse(snapshot.data[g].grasa)));
                                }
                                /*
                                var grasas = [
                                  double.parse(snapshot.data[0].grasa),
                                  double.parse(snapshot.data[1].grasa),
                                  double.parse(snapshot.data[2].grasa),
                                  double.parse(snapshot.data[3].grasa)
                                ];
                                */
                                min_grasa = grasas[0];
                                max_grasa = grasas[0];
                                grasas.forEach((element) {
                                  if (element > max_grasa) max_grasa = element;
                                  if (element < min_grasa) min_grasa = element;
                                });
                                print(grasas);
                                print("min grasa: " + min_grasa.toString());
                                print("max grasa: " + max_grasa.toString());
                                lineChartBarDataGrasa = LineChartBarData(
                                  spots: spots,
                                  /*
                                  [
                                    FlSpot(1,
                                        double.parse(snapshot.data[0].grasa)),
                                    FlSpot(2,
                                        double.parse(snapshot.data[1].grasa)),
                                    FlSpot(3,
                                        double.parse(snapshot.data[2].grasa)),
                                    FlSpot(4,
                                        double.parse(snapshot.data[3].grasa)),
                                  ],
                                  */
                                  isCurved: false,
                                  colors: [
                                    hexToColor("#059696"),
                                  ],
                                  barWidth: 2,
                                  isStrokeCapRound: true,
                                  dotData: FlDotData(
                                    show: true,
                                  ),
                                  belowBarData: BarAreaData(
                                    show: true,
                                    applyCutOffY: true,
                                    cutOffY: 10,
                                    colors: [
                                      Colors.transparent,
                                    ],
                                    gradientColorStops: [0.5, 1.0],
                                    gradientFrom: const Offset(0, 0),
                                    gradientTo: const Offset(0, 1),
                                    spotsLine: BarAreaSpotsLine(
                                      show: true,
                                      flLineStyle: FlLine(
                                        color: Colors.blue,
                                        strokeWidth: 0.5,
                                      ),
                                      checkToShowSpotLine: (spot) {
                                        if (spot.x == 0 || spot.x == 6) {
                                          return false;
                                        }
                                        return true;
                                      },
                                    ),
                                  ),
                                );

                                return LineChart(
                                  LineChartData(
                                    lineTouchData: LineTouchData(
                                      touchTooltipData: LineTouchTooltipData(
                                        tooltipBgColor: Colors.white,
                                      ),
                                      touchCallback:
                                          (LineTouchResponse touchResponse) {},
                                      handleBuiltInTouches: true,
                                    ),
                                    gridData: FlGridData(
                                      show: true,
                                    ),
                                    titlesData: FlTitlesData(
                                      bottomTitles: SideTitles(
                                        showTitles: true,
                                        margin: 20,
                                        /*
                                        textStyle: TextStyle(
                                          color: hexToColor("#676767"),
                                          fontSize: 12,
                                        ),
                                        */
                                        getTitles: (value) {
                                          switch (value.toInt()) {
                                            case 1:
                                              return snapshot.data[0].fecha;
                                            case 2:
                                              return snapshot.data[1].fecha;
                                            case 3:
                                              return snapshot.data[2].fecha;
                                            case 4:
                                              return snapshot.data[3].fecha;
                                              break;
                                          }
                                          return '';
                                        },
                                        rotateAngle: 90,
                                        getTextStyles: (value) {
                                          TextStyle(
                                              color: hexToColor("#676767"),
                                              fontSize: 9);
                                        },
                                        reservedSize: 30,
                                      ),
                                      leftTitles: SideTitles(
                                        interval: 10,
                                        showTitles: false,
                                        getTextStyles: (value) {
                                          TextStyle(
                                              color: hexToColor("#676767"),
                                              fontSize: 9);
                                        },
                                        /*
                                        textStyle: TextStyle(
                                          color: hexToColor("#676767"),
                                          fontSize: 10,
                                        ),
                                        */
                                        rotateAngle: 0,
                                        margin: 10,
                                      ),
                                    ),
                                    borderData: FlBorderData(
                                      show: true,
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.black,
                                          width: 1,
                                        ),
                                        left: BorderSide(
                                          color: Colors.black,
                                          width: 1,
                                        ),
                                        right: BorderSide(
                                          color: Colors.transparent,
                                        ),
                                        top: BorderSide(
                                          color: Colors.transparent,
                                        ),
                                      ),
                                    ),
                                    //minX: 0,
                                    //maxX: 4,
                                    //maxY: 4,
                                    minY: (min_grasa > 0)
                                        ? min_grasa - 1
                                        : min_grasa,
                                    maxY: max_grasa + 1,
                                    lineBarsData: [lineChartBarDataGrasa],
                                  ),
                                  swapAnimationDuration:
                                      const Duration(milliseconds: 250),
                                );

/*
                                var data = [
                                  new TimeSeriesDatos(
                                    new DateTime(
                                      int.tryParse(
                                          snapshot.data[0].fecha.split('-')[2]),
                                      int.tryParse(
                                          snapshot.data[0].fecha.split('-')[1]),
                                      int.tryParse(
                                          snapshot.data[0].fecha.split('-')[0]),
                                    ),
                                    double.parse(snapshot.data[0].grasa),
                                  ),
                                  new TimeSeriesDatos(
                                    new DateTime(
                                      int.tryParse(
                                          snapshot.data[1].fecha.split('-')[2]),
                                      int.tryParse(
                                          snapshot.data[1].fecha.split('-')[1]),
                                      int.tryParse(
                                          snapshot.data[1].fecha.split('-')[0]),
                                    ),
                                    double.parse(snapshot.data[1].grasa),
                                  ),
                                  new TimeSeriesDatos(
                                    new DateTime(
                                      int.tryParse(
                                          snapshot.data[2].fecha.split('-')[2]),
                                      int.tryParse(
                                          snapshot.data[2].fecha.split('-')[1]),
                                      int.tryParse(
                                          snapshot.data[2].fecha.split('-')[0]),
                                    ),
                                    double.parse(snapshot.data[2].grasa),
                                  ),
                                  new TimeSeriesDatos(
                                    new DateTime(
                                      int.tryParse(
                                          snapshot.data[3].fecha.split('-')[2]),
                                      int.tryParse(
                                          snapshot.data[3].fecha.split('-')[1]),
                                      int.tryParse(
                                          snapshot.data[3].fecha.split('-')[0]),
                                    ),
                                    double.parse(snapshot.data[3].grasa),
                                  ),
                                ];
                                                            
                                return SfCartesianChart(
                                  plotAreaBorderWidth: 1,
                                  tooltipBehavior: TooltipBehavior(
                                    enable: true,
                                    format: 'point.y kg  [point.x]',
                                    header: "Grasa",
                                  ),
                                  primaryXAxis: CategoryAxis(
                                    labelRotation: 90,
                                    labelPosition:
                                        ChartDataLabelPosition.outside,
                                    tickPosition: TickPosition.outside,
                                    edgeLabelPlacement: EdgeLabelPlacement.none,
                                    axisLine: AxisLine(
                                      color: Colors.black,
                                    ),
                                    minorTickLines: MinorTickLines(
                                      size: 6,
                                      width: 2,
                                      color: hexToColor("#059696"),
                                    ),
                                    majorTickLines: MajorTickLines(
                                      size: 6,
                                      width: 2,
                                      color: hexToColor("#b0b0b0"),
                                    ),
                                  ),
                                  primaryYAxis: NumericAxis(
                                    interval: 1,
                                    rangePadding: ChartRangePadding.auto,
                                    tickPosition: TickPosition.outside,
                                    axisLine: AxisLine(
                                      color: Colors.black,
                                    ),
                                  ),
                                  series: <ChartSeries>[
                                    LineSeries<TimeSeriesDatos, String>(
                                      dataSource: data,
                                      width: 4,
                                      pointColorMapper: (TimeSeriesDatos, _) =>
                                          hexToColor("#059696"),
                                      xValueMapper:
                                          (TimeSeriesDatos datos, _) =>
                                              DateFormat("dd/MM/yyyy")
                                                  .format(datos.time),
                                      yValueMapper:
                                          (TimeSeriesDatos datos, _) =>
                                              datos.dato,
                                      markerSettings: MarkerSettings(
                                        isVisible: true,
                                        width: 12,
                                        height: 12,
                                      ),
                                    )
                                  ],
                                );
                                */
                              } else {
                                return new Center(
                                    child: Text("No hay datos.",
                                        style: TextStyle(
                                            color: hexToColor("#606060"))));
                              }
                            } else if (snapshot.hasError) {
                              return new Center(
                                  child: Text("Error al obtener datos.",
                                      style: TextStyle(
                                          color: hexToColor("#606060"))));
                            }
                          }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///
  /// Widget Reto
  ///
  GestureDetector retoActual() {
    return GestureDetector(
      onTap: () {
        _showDialog();
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

                Container(
              alignment: Alignment.center,
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 0),
                constraints: BoxConstraints(minWidth: 80, maxWidth: 80),
                child: AutoSizeText(
                  "Presiona para agregar meta",
                  textAlign: TextAlign.center,
                  maxFontSize: 25,
                  maxLines: 3,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
              ),
            ),
            /*
                FutureBuilder<Meta>(
                    future: db.DBManager.instance.getReto(global.usuario.id),
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
                                  "Presiona para agregar meta",
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
                    */
          ),
        ],
      ),
    );
  }

  ///
  /// Label Subtítulo
  ///
  Container subtitulo(_subtitulo) {
    return Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.only(top: 20, left: 20),
      child: Text(
        _subtitulo,
        style: TextStyle(
            color: hexToColor("#898989"),
            fontWeight: FontWeight.bold,
            fontSize: 16),
      ),
    );
  }

  ///
  /// Row botones
  ///
  Widget row_botones() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 50),
      padding: EdgeInsets.only(left: 20),
      alignment: Alignment.topLeft,
      //height: 80,
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              _showDialog();
            },
            child: Container(
              width: 60,
              height: 60,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: hexToColor("#439495"),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.add_circle,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                completos_selected = false;
                (pendientes_selected == false)
                    ? pendientes_selected = true
                    : pendientes_selected = false;
              });
            },
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: hexToColor("#F9FAFA"),
                borderRadius: BorderRadius.circular(10),
                boxShadow: (pendientes_selected == true)
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 8,
                          offset: Offset(0, 0), // changes position of shadow
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                Icons.track_changes,
                color: hexToColor("#888888"),
                size: 30,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                pendientes_selected = false;
                (completos_selected == false)
                    ? completos_selected = true
                    : completos_selected = false;
              });
            },
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: hexToColor("#67AD5C"),
                borderRadius: BorderRadius.circular(10),
                boxShadow: (completos_selected == true)
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 8,
                          offset: Offset(0, 0), // changes position of shadow
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                Icons.star,
                color: Colors.yellow,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///
  /// List Metas
  ///
  Container metas() {
    return Container(
      width: MediaQuery.of(context).size.width,
      //height: MediaQuery.of(context).size.height,
      margin: EdgeInsets.only(top: 140),
      child: SingleChildScrollView(
        child: Align(
          alignment: Alignment.center,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            child: FutureBuilder<List<Meta>>(
                future:
                    db.DBManager.instance.getAllRetosPasados(global.usuario.id),
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
                            //final item = snapshot.data[index];
                            return Slidable(
                              key: Key('s'),
                              actionExtentRatio: 0.25,
                              actionPane: Card(
                                margin: EdgeInsets.only(bottom: 15),
                                elevation: 0,
                                color: (snapshot.data[index].status == "Ok")
                                    ? hexToColor("#67AD5C")
                                    : hexToColor("#f2f2f2"),
                                child: Stack(
                                  alignment: Alignment.centerLeft,
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          //width: 180,
                                          margin: EdgeInsets.only(
                                            top: 10,
                                            left: 20,
                                          ),
                                          child: Text(
                                            snapshot.data[index].meta
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: (snapshot.data[index]
                                                            .status ==
                                                        "Ok")
                                                    ? hexToColor("#ffffff")
                                                    : hexToColor("#505050"),
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Container(
                                          //width: 200,
                                          margin: EdgeInsets.only(
                                            top: 10,
                                            bottom: 10,
                                            left: 20,
                                          ),
                                          child: Text(
                                            snapshot.data[index].fecha
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: (snapshot.data[index]
                                                            .status ==
                                                        "Ok")
                                                    ? hexToColor("#ffffff")
                                                    : hexToColor("#ababab"),
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                        right: 20,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          (snapshot.data[index].status != "Ok")
                                              ? GestureDetector(
                                                  onTap: () {
                                                    myTextUpdate.text = snapshot
                                                        .data[index].meta;
                                                    _showUpdateDialog(
                                                        snapshot.data[index].id,
                                                        snapshot
                                                            .data[index].meta);
                                                  },
                                                  child: Container(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    //width: MediaQuery.of(context).size.width * 0,
                                                    height: 20,
                                                    child: Icon(
                                                      Icons.edit,
                                                      color:
                                                          hexToColor("#888888"),
                                                    ),
                                                  ),
                                                )
                                              : Offstage(),
                                          GestureDetector(
                                            onTap: () {
                                              if (snapshot.data[index].status ==
                                                  "Incompleta") {
                                                db.DBManager.instance
                                                    .setEstatusRetoOk(
                                                        snapshot.data[index].id)
                                                    .then((value) {
                                                  setState(() {});
                                                });
                                              }
                                            },
                                            child: Container(
                                              alignment: Alignment.centerRight,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.1,
                                              height: 20,
                                              child: (snapshot
                                                          .data[index].status ==
                                                      "Incompleta")
                                                  ? Icon(
                                                      Icons.thumb_up,
                                                      color:
                                                          hexToColor("#888888"),
                                                    )
                                                  : Icon(
                                                      Icons.star,
                                                      color: Colors.yellow,
                                                    ),
                                            ),
                                          ),
                                        ],
                                      ),
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
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                closeOnCanceled: true,
                                dragDismissible: true,
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
                                            '¿Seguro que desea borrar la meta "' +
                                                snapshot.data[index].meta +
                                                '"?',
                                            textAlign: TextAlign.center),
                                        actions: <Widget>[
                                          FlatButton(
                                              child: Text('Cancelar'),
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(false);
                                                setState(() {});
                                              }),
                                          FlatButton(
                                              child: Text('Borrar'),
                                              onPressed: () {
                                                db.DBManager.instance
                                                    .deleteReto(snapshot
                                                        .data[index].id);
                                                setState(() {});
                                                Navigator.of(context).pop(true);
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
                                color: (snapshot.data[index].status == "Ok")
                                    ? hexToColor("#67AD5C")
                                    : hexToColor("#f2f2f2"),
                                child: Stack(
                                  alignment: Alignment.centerLeft,
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          //width: 180,
                                          margin: EdgeInsets.only(
                                            top: 10,
                                            left: 20,
                                          ),
                                          child: Text(
                                            snapshot.data[index].meta
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: (snapshot.data[index]
                                                            .status ==
                                                        "Ok")
                                                    ? hexToColor("#ffffff")
                                                    : hexToColor("#505050"),
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Container(
                                          //width: 200,
                                          margin: EdgeInsets.only(
                                            top: 10,
                                            bottom: 10,
                                            left: 20,
                                          ),
                                          child: Text(
                                            snapshot.data[index].fecha
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: (snapshot.data[index]
                                                            .status ==
                                                        "Ok")
                                                    ? hexToColor("#ffffff")
                                                    : hexToColor("#ababab"),
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                        right: 20,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          (snapshot.data[index].status != "Ok")
                                              ? GestureDetector(
                                                  onTap: () {
                                                    myTextUpdate.text = snapshot
                                                        .data[index].meta;
                                                    _showUpdateDialog(
                                                        snapshot.data[index].id,
                                                        snapshot
                                                            .data[index].meta);
                                                  },
                                                  child: Container(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    //width: MediaQuery.of(context).size.width * 0,
                                                    height: 20,
                                                    child: Icon(
                                                      Icons.edit,
                                                      color:
                                                          hexToColor("#888888"),
                                                    ),
                                                  ),
                                                )
                                              : Offstage(),
                                          GestureDetector(
                                            onTap: () {
                                              if (snapshot.data[index].status ==
                                                  "Incompleta") {
                                                db.DBManager.instance
                                                    .setEstatusRetoOk(
                                                        snapshot.data[index].id)
                                                    .then((value) {
                                                  setState(() {});
                                                });
                                              }
                                            },
                                            child: Container(
                                              alignment: Alignment.centerRight,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.1,
                                              height: 20,
                                              child: (snapshot
                                                          .data[index].status ==
                                                      "Incompleta")
                                                  ? Icon(
                                                      Icons.thumb_up,
                                                      color:
                                                          hexToColor("#888888"),
                                                    )
                                                  : Icon(
                                                      Icons.star,
                                                      color: Colors.yellow,
                                                    ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                    } else {
                      return new Text(
                        "Aun no tienes metas.",
                        style: TextStyle(
                          color: hexToColor("#606060"),
                        ),
                      );
                    }
                  } else if (snapshot.hasError) {
                    return new Text(
                      "Error al obtener metas.",
                      style: TextStyle(
                        color: hexToColor("#606060"),
                      ),
                    );
                  }
                }),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    min_peso = 0;
    max_peso = 0;
    min_grasa = 0;
    max_grasa = 0;
    pendientes_selected = false;
    completos_selected = false;

    //db.DBManager.instance.deleteAllRetos();

    lastGrasa = getLastGrasa();
    lastPeso = getLastPeso();
    progreso = getProgreso();

    _tabController =
        new TabController(length: 3, vsync: this, initialIndex: index_tab);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      //drawer: new newmenu.menu(2),
      appBar: AppBar(
        elevation: 0,
        title: Text("Progreso"),
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
                    text: "Grasa",
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
              physics: NeverScrollableScrollPhysics(),
              children: [
                /// TAB PESO
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
                    SingleChildScrollView(
                      child: Stack(
                        children: <Widget>[
                          titulo("Gráfica de peso"),
                          informacionPeso("Último peso medido"),
                          historialPeso("Peso en kg"),
                        ],
                      ),
                    ),
                  ],
                ),

                /// TAB GRASA
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
                    SingleChildScrollView(
                      child: Stack(
                        children: <Widget>[
                          titulo("Gráfica de grasa"),
                          informacionGrasa("Última medida"),
                          historialGrasa("Progreso en kg"),
                        ],
                      ),
                    ),
                  ],
                ),

                /// TAB METAS
                Stack(
                  children: <Widget>[
                    Positioned(
                      child: Container(
                        decoration: new BoxDecoration(
                          color: const Color(0x00FFCC00),
                          image: new DecorationImage(
                            image: new AssetImage("assets/images/fondo.jpg"),
                            colorFilter: new ColorFilter.mode(
                                Colors.black.withOpacity(0.2),
                                BlendMode.dstATop),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    //titulo("Próxima meta"),
                    //retoActual(),
                    subtitulo("Metas"),
                    row_botones(),
                    metas(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDialog() async {
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
                  labelText: 'Meta',
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
              child: Text('GUARDAR',
                  style: TextStyle(color: hexToColor("#059696"))),
              onPressed: () {
                if (myTextEdit.text != "") {
                  db.DBManager.instance
                      .insertReto(global.usuario.id, myTextEdit.text);
                  setState(() {
                    myTextEdit.text = "";
                  });
                  Navigator.pop(context);
                }
              })
        ],
      ),
    );
  }

  void _showUpdateDialog(_idReto, _oldReto) async {
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
                  labelText: 'Meta',
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
              child: Text('EDITAR',
                  style: TextStyle(color: hexToColor("#059696"))),
              onPressed: () {
                if (myTextUpdate.text != "") {
                  db.DBManager.instance.updateReto(_idReto, myTextUpdate.text);
                  setState(() {
                    myTextUpdate.text = "";
                  });
                  Navigator.pop(context);
                }
              })
        ],
      ),
    );
  }
}

Future<String> getLastPeso() async {
  try {
    String peso;

    var response = await http.post(global.server + "/aplicacion/api",
        body: {"tipo": "record", "token": global.usuario.token});
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

Future<String> getLastGrasa() async {
  try {
    String grasa;

    var response = await http.post(global.server + "/aplicacion/api",
        body: {"tipo": "record", "token": global.usuario.token});
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

Future<List<Progreso>> getProgreso() async {
  try {
    List<Progreso> list = new List<Progreso>();

    var response = await http.post(global.server + "/aplicacion/api",
        body: {"tipo": "record", "token": global.usuario.token});
    var datos = json.decode(utf8.decode(response.bodyBytes));
    print(datos);

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
              fecha: new DateFormat("dd-MM-yyyy")
                  .format(DateTime.parse(datos["response"][i]["fecha"]))
                  .toString(),
              dia: DateTime.parse(datos["response"][i]["fecha"]).day,
              mes: DateFormat("MM")
                  .format(DateTime.parse(datos["response"][i]["fecha"]))
                  .toString(),
              anio: DateTime.parse(datos["response"][i]["fecha"]).year));
        } else {
          if (DateFormat("MM")
                  .format(DateTime.parse(datos["response"][i]["fecha"]))
                  .toString() !=
              list[list.length - 1].mes) {
            list.add(Progreso(
                peso: datos["response"][i]["peso"].toString(),
                grasa: datos["response"][i]["grasa"].toString(),
                fecha: new DateFormat("dd-MM-yyyy")
                    .format(DateTime.parse(datos["response"][i]["fecha"]))
                    .toString(),
                dia: DateTime.parse(datos["response"][i]["fecha"]).day,
                mes: DateFormat("MM")
                    .format(DateTime.parse(datos["response"][i]["fecha"]))
                    .toString(),
                anio: DateTime.parse(datos["response"][i]["fecha"]).year));
          } else {
            list.removeAt(list.length - 1);
            list.add(Progreso(
                peso: datos["response"][i]["peso"].toString(),
                grasa: datos["response"][i]["grasa"].toString(),
                fecha: new DateFormat("dd-MM-yyyy")
                    .format(DateTime.parse(datos["response"][i]["fecha"]))
                    .toString(),
                dia: DateTime.parse(datos["response"][i]["fecha"]).day,
                mes: DateFormat("MM")
                    .format(DateTime.parse(datos["response"][i]["fecha"]))
                    .toString(),
                anio: DateTime.parse(datos["response"][i]["fecha"]).year));
          }
        }
      }

      for (int i = list.length; i > 0; i--) {
        if (list.length > 4)
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

class Medidas {
  final int mes;
  final String nameMes;
  final double medida;

  Medidas(this.mes, this.nameMes, this.medida);
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

class TimeSeriesDatos {
  final DateTime time;
  final double dato;

  TimeSeriesDatos(this.time, this.dato);
}
