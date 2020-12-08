import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
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
  Widget datos(_context) {
    double width_drawer = double.infinity;
    print(width_drawer);
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 40, left: 0),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: <Widget>[
          Container(
            width: MediaQuery.of(_context).size.width * 0.55,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 20),
            child: Text(
              global.usuario.nombre + " " + global.usuario.apellidos,
              overflow: TextOverflow.clip,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF059696),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 10),
            child: GestureDetector(
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
          ),
        ],
      ),
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

    Future<T> show_Dialog<T>({
      @required BuildContext context,
      @required String titulo,
      @required String mensaje,
    }) {
      return showGeneralDialog(
        context: context,
        pageBuilder: (BuildContext buildContext, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return Builder(builder: (BuildContext context) {
            return Container(
              width: 400,
              height: 600,
              alignment: Alignment.center,
              margin: EdgeInsets.only(
                left: 30,
                right: 30,
                top: MediaQuery.of(context).size.height * 0.3,
                bottom: MediaQuery.of(context).size.height * 0.3,
              ),
              decoration: new BoxDecoration(
                color: hexToColor("#505050"),
                borderRadius: new BorderRadius.all(
                  const Radius.circular(20.0),
                ),
              ),
              child: Column(
                children: <Widget>[
                  /// BOTÓN CERRAR
                  Container(
                    width: double.infinity,
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                          top: 20,
                          right: 20,
                        ),
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ),

                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        /// TEXT TÍTULO GRUPO
                        Container(
                          alignment: Alignment.topCenter,
                          child: Text(
                            titulo,
                            style: TextStyle(
                              decoration: TextDecoration.none,
                              fontFamily: "Arial",
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        /// TEXT INTRUCCIÓN
                        Container(
                          alignment: Alignment.topCenter,
                          margin: EdgeInsets.only(top: 30),
                          child: SizedBox(
                            width: 270,
                            child: AutoSizeText(
                              mensaje,
                              //maxLines: 3,
                              textAlign: TextAlign.center,
                              wrapWords: false,
                              style: TextStyle(
                                decoration: TextDecoration.none,
                                fontFamily: "Arial",
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
        },
        barrierDismissible: true,
        barrierLabel: "",
        barrierColor: null,
        transitionDuration: const Duration(milliseconds: 150),
      );
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
              if (global.validada == true) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlanPage(0),
                  ),
                );
              } else {
                Scaffold.of(context).openEndDrawer();
                show_Dialog(
                    context: context,
                    titulo: "¡Lo sentimos! :(",
                    mensaje:
                        "Tu plan de alimentación ya no está disponible, ponte en contacto con tu especialista para obtener uno nuevo.");
              }
              break;
            case 2:
              if (global.validada == true) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProgresoPage(0),
                  ),
                );
              } else {
                Scaffold.of(context).openEndDrawer();
                show_Dialog(
                    context: context,
                    titulo: "¡Lo sentimos! :(",
                    mensaje:
                        "Tu plan de alimentación ya no está disponible, ponte en contacto con tu especialista para obtener uno nuevo.");
              }
              break;
            case 3:
              if (global.validada == true) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AgendaPage(),
                  ),
                );
              } else {
                Scaffold.of(context).openEndDrawer();
                show_Dialog(
                    context: context,
                    titulo: "¡Lo sentimos! :(",
                    mensaje:
                        "Tu plan de alimentación ya no está disponible, ponte en contacto con tu especialista para obtener uno nuevo.");
              }
              break;
            case 4:
              if (global.validada == true) {
                global.text_busqueda_receta.text = "";
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecetasPage(),
                  ),
                );
              } else {
                Scaffold.of(context).openEndDrawer();
                show_Dialog(
                    context: context,
                    titulo: "¡Lo sentimos! :(",
                    mensaje:
                        "Tu plan de alimentación ya no está disponible, ponte en contacto con tu especialista para obtener uno nuevo.");
              }
              break;
            case 5:
              if (global.validada == true) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RestaurantesPage(),
                  ),
                );
              } else {
                Scaffold.of(context).openEndDrawer();
                show_Dialog(
                    context: context,
                    titulo: "¡Lo sentimos! :(",
                    mensaje:
                        "Tu plan de alimentación ya no está disponible, ponte en contacto con tu especialista para obtener uno nuevo.");
              }
              break;
            case 6:
              if (global.validada == true) {
                //global.list_mensajes = new List<Mensaje>();
                global.text_mensaje.text = "";
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NutriochatPage(),
                  ),
                );
              } else {
                Scaffold.of(context).openEndDrawer();
                show_Dialog(
                    context: context,
                    titulo: "¡Lo sentimos! :(",
                    mensaje:
                        "Tu plan de alimentación ya no está disponible, ponte en contacto con tu especialista para obtener uno nuevo.");
              }
              break;
            case 7:
              if (global.validada == true) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PDFMaterialPage(),
                  ),
                );
              } else {
                Scaffold.of(context).openEndDrawer();
                show_Dialog(
                    context: context,
                    titulo: "¡Lo sentimos! :(",
                    mensaje:
                        "Tu plan de alimentación ya no está disponible, ponte en contacto con tu especialista para obtener uno nuevo.");
              }
              break;
            case 8:
              db.DBManager.instance
                  .updateLogueado(global.usuario.id, 0)
                  .then((_) {
                print("Cerrar sesión");
                global.usuario.token = "";
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  ModalRoute.withName('/'),
                );
              });
              break;
          }
        },
      ),
    );
  }
}
