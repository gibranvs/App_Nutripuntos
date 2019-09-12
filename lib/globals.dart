library nutripuntos.globals;

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'src/ColorCirclesWidget.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:typed_data';
import 'pages/receta_detalle.dart';
import 'pages/restaurante_detalle.dart';
import 'pages/agenda.dart';
import 'pages/nutriochat.dart';
import 'src/DBManager.dart' as db;

String server = "http://c1370875.ferozo.com";

bool user_exist;
String token;
String recovery_token;
String nombre_user;
String apellidos_user;

///
/// MENU
///
int selected_index = 0;

///
/// HOME
///
DecorationImage image_foto =
    new DecorationImage(image: AssetImage("assets/images/photo.jpg"));
/*
File imageFile = new File("assets/images/photo.jpg");
String imageFilePath;
DecorationImage returnFileSelected(File file, String filePath) {
  try {
    image_foto = new DecorationImage(
      fit: BoxFit.contain,
      image: file == null
          ? new AssetImage("assets/images/photo.jpg")
          : new AssetImage(imageFilePath),
    );
    return image_foto;
  } catch (e) {
    print("Error returnFileSelected " + e.toString());
    return new DecorationImage(
      fit: BoxFit.contain,
      image: new AssetImage("assets/images/photo.jpg"),
    );
  }
}
*/

///
/// RECETAS
///
dynamic detalle_receta;
ColorCirclesWidget widget = new ColorCirclesWidget(detalle_receta.azul,
    detalle_receta.verde, detalle_receta.naranja, detalle_receta.amarillo);
List<Ingrediente> list_ingredientes;

///
/// RESTAURANTES
///
var foto_restaurante;
String nombre_restaurante;
List<Platillo> list_platillos_restaurante;

///
/// AGENDA
///
List<Citas> list_citas;

///
/// MENSAJES
///
List<Mensaje> list_mensajes;
