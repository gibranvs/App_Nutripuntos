import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nutripuntos_app/pages/menu.dart';
import 'package:nutripuntos_app/src/HexToColor.dart';
import '../globals.dart' as global;
import '../src/DBManager.dart' as db;
import 'home.dart';
import 'plan.dart';
import 'progreso.dart';
import 'agenda.dart';
import 'recetas.dart';
import 'restaurantes.dart';
import 'nutriochat.dart';
import 'login.dart';

class menu extends StatelessWidget {
  final int selected_index;
  menu(this.selected_index);
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: hexToColor("#505050"),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            datos(),
            item_menu(selected_index, 1, "Plan de alimentación",
                "assets/icons/recurso_11.png", 30),
            item_menu(selected_index, 2, "Progreso",
                "assets/icons/recurso_13.png", 28),
            item_menu(
                selected_index, 3, "Agenda", "assets/icons/recurso_12.png", 27),
            item_menu(selected_index, 4, "Recetas",
                "assets/icons/recurso_14.png", 38),
            item_menu(selected_index, 5, "Restaurantes",
                "assets/icons/recurso_9.png", 35),
            item_menu(selected_index, 6, "Nutriochat",
                "assets/icons/recurso_10.png", 35),
          ],
        ),
      ),
    );
  }
}

class datos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Row(
          children: <Widget>[
            Column(
              children: <Widget>[
                ///
                /// LABEL NOMBRE
                ///
                Container(
                  padding: EdgeInsets.only(top: 70, left: 20),
                  child: Text(
                    global.nombre_user + " " + global.apellidos_user,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF059696),
                    ),
                  ),
                ),

                ///
                /// LABEL CERRAR SESIÓN
                ///
                Container(
                  padding: EdgeInsets.only(top: 5, left: 20),
                  child: GestureDetector(
                    onTap: () {
                      db.DBManager.instance.deleteAllRegistros();
                      print("Cerrar sesión");
                      global.token = "";
                      global.recovery_token = "";
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    child: Text(
                      "Cerrar sesión",
                      style: TextStyle(
                        color: Color(0xFF059696),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
        Row(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                //print("Back");
                if (global.selected_index == 0)
                  Navigator.pop(context);
                else {
                  global.selected_index = 0;
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                }
              },
              child: Padding(
                padding: EdgeInsets.only(top: 50, left: 180, bottom: 50),
                child: Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFF059696), width: 6),
                    color: Colors.white,
                    shape: BoxShape.circle,
                    image: global.image_foto == null
                        ? DecorationImage(
                            image: AssetImage("assets/images/photo.jpg"))
                        : global.image_foto,
                    //global.returnFileSelected(global.imageFile, global.imageFile.path),
                    /*
                  DecorationImage(
                fit: BoxFit.contain,
                image: AssetImage("assets/images/photo.jpg"),
              ),
              */
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}

class item_menu extends StatelessWidget {
  final int selected_index;
  final int index_item;
  final String titulo;
  final String path_imagen;
  final double size_imagen;
  item_menu(this.selected_index, this.index_item, this.titulo, this.path_imagen,
      this.size_imagen);
  @override
  Widget build(BuildContext context) {
    Decoration decoration;
    Color color_font;
    if (selected_index == index_item) {
      decoration = BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF35B9C5),
            Color(0xFF348CB4),
          ],
        ),
      );
      color_font = Colors.white;
    } else {
      decoration = null;
      color_font = hexToColor("#888888");
    }

    return Container(
      decoration: decoration,
      child: ListTile(
        leading: Container(
          height: size_imagen,
          child: new Image.asset(
            path_imagen,
            color: color_font,
          ),
        ),
        title: Text(
          titulo,
          style: TextStyle(fontSize: 17, color: color_font),
        ),
        onTap: () {
          //print(index);
          global.selected_index = index_item;
          switch (index_item) {
            case 1:
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => PlanPage()));
              break;
            case 2:
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProgresoPage(0)));
              break;
            case 3:
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AgendaPage()));
              break;
            case 4:
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RecetasPage()));
              break;
            case 5:
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RestaurantesPage()));
              break;
            case 6:
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NutriochatPage()));
              break;
          }
        },
      ),
    );
  }
}
