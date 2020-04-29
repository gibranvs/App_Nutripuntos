import 'package:flutter/material.dart';
import 'hexToColor.dart';
import 'dart:math';

class ColorCirclesWidget extends StatelessWidget {
  final String azul;
  final String verde;
  final String naranja;
  final String amarillo;
  ColorCirclesWidget({this.azul, this.verde, this.naranja, this.amarillo});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
      children: <Widget>[
        ///
        /// VERDE
        ///
        new Container(
          margin: new EdgeInsets.only(top: 0.0, left: 0.0),
          child: CircularButton(verde, hexToColor("#78c826")),
        ),

        ///
        /// NARANJA
        ///
        new Container(
          margin: new EdgeInsets.only(top: 0.0, left: 40.0),
          child: CircularButton(naranja, hexToColor("#ff6718")),
        ),

        ///
        /// AZUL
        ///
        new Container(
          margin: new EdgeInsets.only(top: 0.0, left: 80.0),
          child: CircularButton(azul, hexToColor("#00b9c6")),
        ),

        ///
        /// AMARILLO
        ///
        new Container(
          margin: new EdgeInsets.only(top: 0.0, left: 120.0),
          child: CircularButton(amarillo, hexToColor("#ffcc00")),
        ),
      ],
    );
  }
}

class CircularButton extends StatelessWidget {
  final String text;
  final Color color;
  CircularButton(this.text, this.color);
  
  @override 

  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        color: color,
        height: 25.0, // height of the button
        width: 25.0, // width of the button
        child: Center(
            child: Text(
          text.toString(),
          style: TextStyle(color: Colors.white, fontSize: 10.0, fontWeight: FontWeight.bold),
        )),
      ),
    );
  }
}
