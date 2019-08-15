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
File imageFile = new File("assets/images/photo.jpg");
String imageFilePath;
DecorationImage returnFileSelected(File file, String filePath) {
  try {
    //_save(file);
    //print(file.path);

    return new DecorationImage(
      fit: BoxFit.contain,
      image: file == null
          ? new AssetImage("assets/images/photo.jpg")
          : new AssetImage(imageFilePath),
    );
  } catch (e) {
    print("Error returnFileSelected " + e.toString());
  }
}

_save(File file) async {
  try {
    final filename = 'photo.jpg';
    print(file.path);
    var bytes = await rootBundle.load(file.path);
    String dir = (await getApplicationDocumentsDirectory()).path;
    //print(dir);
    writeToFile(bytes, '$dir/$filename');
  } catch (e) {
    print("Error _save " + e.toString());
  }
}

Future<void> writeToFile(ByteData data, String path) {
  final buffer = data.buffer;
  return new File(path)
      .writeAsBytes(buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
}

_read() async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/photo.jpg');
    imageFile = file;
    return '${directory.path}/photo.jpg';
  } catch (e) {
    print("Couldn't read file");
  }
}

read() {
  _read();
}

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
