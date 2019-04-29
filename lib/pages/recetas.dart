import 'package:flutter/material.dart';

class RecetasPage extends StatefulWidget {
  @override
  _RecetasPageState createState() => new _RecetasPageState();
}

class _RecetasPageState extends State<RecetasPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
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
          child: Image.asset("assets/images/gr_recetas.png"),
        ),
      ),
    );
  }
}