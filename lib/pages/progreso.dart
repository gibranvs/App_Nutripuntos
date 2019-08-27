import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:nutripuntos_app/src/HexToColor.dart';
import 'newmenu.dart' as newmenu;
import 'package:http/http.dart' as http;
import 'package:nutripuntos_app/globals.dart' as global;

void main() {
  runApp(ProgresoPage());
}

class ProgresoPage extends StatelessWidget {
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
                    label_titulo("Gráfica de peso"),
                    cuadro_informacion("52 KG", "Último peso medido"),
                    cuadro_grafica(),
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
                    label_titulo("Gráfica de Calorías"),
                    cuadro_informacion("350 Kcal", "Última medida"),
                  ],
                ),

                ///
                /// TAB METAS
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
                  child: Center(
                    child: Image.asset("assets/images/gr_metas.png"),
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

class label_titulo extends StatelessWidget {
  final String titulo;
  label_titulo(this.titulo);
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      margin: EdgeInsets.only(top: 20),
      child: Text(titulo,
          style: TextStyle(
              color: hexToColor("#059696"),
              fontWeight: FontWeight.bold,
              fontSize: 16)),
    );
  }
}

class cuadro_informacion extends StatelessWidget {
  final String dato;
  final String leyenda;
  cuadro_informacion(this.dato, this.leyenda);
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
              margin: EdgeInsets.only(top: 10),
              child: Text(
                dato,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22),
              ),
            ),
            Container(
              alignment: Alignment.topCenter,
              margin: EdgeInsets.only(top: 40),
              child: Text(
                leyenda,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w200,
                    fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class cuadro_grafica extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      margin: EdgeInsets.only(top: 170),
      child: Container(
        width: MediaQuery.of(context).size.width *0.8,
        height: 70,
        decoration: BoxDecoration(
          color: hexToColor("#059696"),
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Stack(
          children: <Widget>[
            
          ],
        ),
      ),
    );
  }
}

void GetProgreso() {}
