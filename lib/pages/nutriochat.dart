import 'package:flutter/material.dart';
import 'newmenu.dart' as newmenu;

class NutriochatPage extends StatefulWidget {
  @override
  _NutriochatPageState createState() => new _NutriochatPageState();
}

class _NutriochatPageState extends State<NutriochatPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: new newmenu.menu(6),
      appBar: AppBar(
        elevation: 0,
        title: Text("Nutriochat"),
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
      body: Stack(
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
        ],
      ),
    );
  }
}
