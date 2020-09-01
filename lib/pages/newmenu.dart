import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nutripuntos_app/pages/pdf_material.dart';
import 'package:nutripuntos_app/src/HexToColor.dart';
import 'package:nutripuntos_app/src/mensaje.dart';
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

  ///
  /// Stack datos
  ///
  Stack datos(_context) {
    return Stack(
      children: <Widget>[
        Row(
          children: <Widget>[
            Column(
              children: <Widget>[
                /// LABEL NOMBRE
                Container(
                  padding: EdgeInsets.only(top: 70, left: 20),
                  child: Text(
                    global.usuario.nombre + " " + global.usuario.apellidos,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF059696),
                    ),
                  ),
                ),

                /// LABEL CERRAR SESIÓN
                /*
                Container(
                  padding: EdgeInsets.only(top: 5, left: 20),
                  child: GestureDetector(
                    onTap: () {
                      db.DBManager.instance
                          .updateLogueado(global.usuario.id, 0)
                          .then((_) {
                        print("Cerrar sesión");
                        global.usuario.token = "";
                        Navigator.push(
                            _context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()));
                      });
                    },
                    child: Text(
                      "Cerrar sesión",
                      style: TextStyle(
                        color: Color(0xFF059696),
                      ),
                    ),
                  ),
                ),
                */
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
                  Navigator.pop(_context);
                else {
                  global.selected_index = 0;
                  Navigator.push(_context,
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
                            image: AssetImage("assets/images/photo.jpg"),
                            fit: BoxFit.cover,
                          )
                        : global.image_foto,
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: hexToColor("#505050"),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            datos(context),
            ItemMenu(selected_index, 1, "Plan de alimentación",
                "assets/icons/recurso_11.png", 30),
            ItemMenu(selected_index, 2, "Progreso",
                "assets/icons/recurso_13.png", 28),
            ItemMenu(
                selected_index, 3, "Agenda", "assets/icons/recurso_12.png", 27),
            ItemMenu(selected_index, 4, "Recetas",
                "assets/icons/recurso_14.png", 38),
            ItemMenu(selected_index, 5, "Restaurantes",
                "assets/icons/recurso_9.png", 35),
            ItemMenu(selected_index, 6, "Nutrichat",
                "assets/icons/recurso_10.png", 35),
            ItemMenu(selected_index, 7, "Material de apoyo",
                "assets/icons/material.png", 35),
            ItemMenu(selected_index, 8, "Cerrar sesión",
                "assets/icons/exit.png", 28),
          ],
        ),
      ),
    );
  }
}

class ItemMenu extends StatelessWidget {
  final int selected_index;
  final int index_item;
  final String titulo;
  final String path_imagen;
  final double size_imagen;
  ItemMenu(this.selected_index, this.index_item, this.titulo, this.path_imagen,
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
                context,
                MaterialPageRoute(
                  builder: (context) => PlanPage(0),
                ),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProgresoPage(0),
                ),
              );
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AgendaPage(),
                ),
              );
              break;
            case 4:
              global.text_busqueda_receta.text = "";
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecetasPage(),
                ),
              );
              break;
            case 5:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RestaurantesPage(),
                ),
              );
              break;
            case 6:
              //global.list_mensajes = new List<Mensaje>();
              global.text_mensaje.text = "";
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NutriochatPage(),
                ),
              );
              break;
            case 7:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PDFMaterialPage(),
                ),
              );
              break;
            case 8:
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
                ModalRoute.withName('/'),
              );
              break;
          }
        },
      ),
    );
  }
}
