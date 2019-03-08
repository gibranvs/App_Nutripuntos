import 'package:flutter/material.dart';
import 'menu.dart';

class AgendaPage extends StatefulWidget {
  @override
  _AgendaPageState createState() => new _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Agenda'),
      ),
      drawer: new Menu(),
    );
  }
}