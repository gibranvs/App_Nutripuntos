import 'package:flutter/material.dart';
import 'plan.dart';
import 'progreso.dart';
import 'agenda.dart';
import 'recetas.dart';
import 'restaurantes.dart';
import 'nutriochat.dart';

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Sasha Sokol'),
            decoration: BoxDecoration(
              color: Color(0xFF505050),
            ),
          ),
          ListTile(
            //leading: Icon(Icons.access_alarm),
            title: Text('Plan de alimentación'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PlanPage()),
              );
            },
          ),
          ListTile(
            title: Text('Progreso'),
            onTap: () {
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProgresoPage()),
              );
            },
          ),
          ListTile(
            title: Text('Agenda'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AgendaPage()),
              );
            },
          ),
          ListTile(
            title: Text('Recetas'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RecetasPage()),
              );
            },
          ),
          ListTile(
            title: Text('Restaurantes'),
            onTap: () {
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RestaurantesPage()),
              );
            },
          ),
          ListTile(
            title: Text('Nutriochat'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NutriochatPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}