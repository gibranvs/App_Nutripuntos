library nutripuntos.globals;

import 'dart:convert';
import 'package:flutter/material.dart';
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
int id_user;
String token;
String recovery_token;
String nombre_user;
String apellidos_user;
String num_citas = "0";

String dispositivo_utilizado = "";

///
/// MENU
///
int selected_index = 0;

///
/// HOME
///
DecorationImage image_foto = null;

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
