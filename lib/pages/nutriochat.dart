import 'package:flutter/material.dart';

class NutriochatPage extends StatefulWidget {
  @override
  _NutriochatPageState createState() => new _NutriochatPageState();
}

class _NutriochatPageState extends State<NutriochatPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Nutrio chat'),
      ),
      body: Stack(children: <Widget>[
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
      ],),
    );
  }
}