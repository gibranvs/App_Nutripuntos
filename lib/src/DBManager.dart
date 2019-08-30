import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../globals.dart' as globals;
import '../pages/home.dart';

final String tableRegistro = "REGISTRO";
final String columnNombre = "NOMBRE";
final String columnApellido = "APELLIDO";
final String columnToken = "TOKEN";
final String columnFoto = "FOTO";

// singleton class to manage the database
class DBManager {
  // This is the actual database filename that is saved in the docs directory.
  static final _databaseName = "RegistroUsuario.db";
  // Increment this version when you need to change the schema.
  static final _databaseVersion = 4;

  // Make this a singleton class.
  DBManager._privateConstructor();
  static final DBManager instance = DBManager._privateConstructor();

  // Only allow a single open connection to the database.
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // open the database
  _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  // SQL string to create the database
  Future _onCreate(Database db, int version) async {
    await db.execute('''
              CREATE TABLE $tableRegistro (                
                $columnNombre VARCHAR(100) NOT NULL,
                $columnApellido VARCHAR(100) NOT NULL,
                $columnToken VARCHAR(200) NOT NULL,
                $columnFoto TEXT NOT NULL
                )
              ''');
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) {
    if (oldVersion < newVersion) {
      //db.execute("DROP TABLE IF EXISTS $tableRegistro");
    }
  }

  ///
  /// Database helper methods:
  ///
  insertUsuario(_nombre, _apellido, _token, _foto) async {
    Database db = await database;

    var queryResult = await db.rawQuery("SELECT * FROM $tableRegistro");

    if (queryResult.isEmpty == true) {
      await db.rawInsert(
          "INSERT Into $tableRegistro($columnNombre, $columnApellido, $columnToken, $columnFoto) VALUES (?,?,?,?);",
          [_nombre, _apellido, _token, _foto]);
    } else {
      print("update");
      await db.rawQuery(
          "UPDATE $tableRegistro SET $columnNombre = ?, $columnApellido = ?, $columnToken = ?, $columnFoto = ?",
          [_nombre, _apellido, _token, _foto]);
    }
  }

  getUsuario(_context) async {
    try {
      Database db = await database;
      var res = await db.rawQuery("SELECT * FROM $tableRegistro");
      print("res=" + res.toString());
      if (res.isEmpty == true) {
        globals.user_exist = false;
        Navigator.of(_context).pushReplacementNamed('/HomeScreen');
      } else {
        globals.nombre_user = res[res.length - 1]["NOMBRE"].toString();
        globals.apellidos_user = res[res.length - 1]["APELLIDO"].toString();
        globals.token = res[res.length - 1]["TOKEN"].toString();
        globals.imageFilePath = res[res.length - 1]["FOTO"].toString();
        //print(globals.imageFilePath);

        Future.delayed(const Duration(milliseconds: 300), () {
          Navigator.push(
            _context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        });
      }
    } catch (_ex) {
      globals.imageFilePath = "assets/images/photo.jpg";
    }
  }

  deleteAll() async {
    Database db = await database;
    db.rawQuery("DELETE FROM $tableRegistro");
  }
}

class Usuario {
  String nombre;
  String token;
  String foto;

  Usuario({this.nombre, this.token, this.foto});
}
