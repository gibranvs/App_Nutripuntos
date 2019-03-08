import 'package:flutter/material.dart';

class RecetasPage extends StatefulWidget {
  @override
  _RecetasPageState createState() => new _RecetasPageState();
}

class _RecetasPageState extends State<RecetasPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Recetas'),
      ),
    );
  }
}