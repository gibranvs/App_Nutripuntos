import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:nutripuntos_app/src/mensaje.dart';
import 'package:nutripuntos_app/src/meta.dart';
import 'package:nutripuntos_app/src/usuario.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path_provider_macos/path_provider_macos.dart' as path_ios;
import '../globals.dart' as globals;
import 'package:intl/intl.dart';

///
/// TABLA REGISTRO
///
final String tableRegistro = "REGISTRO";
final String columnID = "ID";
final String columnNombre = "NOMBRE";
final String columnApellido = "APELLIDO";
final String columnCorreo = "CORREO";
final String columnToken = "TOKEN";
final String columnFoto = "FOTO";
final String columnLog = "LOGUEADO";

///
/// TABLA RETOS
///
final String tableRetos = "RETOS";
final String columnIDReto = "ID";
final String columnIDUsuarioReto = "ID_USUARIO";
final String columnReto = "RETO";
final String columnFecha = "FECHA";
final String columnStatus = "ESTATUS";

///
/// TABLA CHAT
///
final String tableChat = "CHAT";
final String columnIDMensaje = "ID";
final String columnIDUsuarioChat = "ID_USUARIO";
final String columnMensaje = "MENSAJE";
final String columnFechaEnviado = "FECHA";

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
    await db.execute('''CREATE TABLE $tableRegistro (    
                $columnID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,     
                $columnNombre VARCHAR(100) NOT NULL,
                $columnApellido VARCHAR(100) NOT NULL,
                $columnCorreo VARCHAR(200) NOT NULL,
                $columnToken VARCHAR(200) NOT NULL,
                $columnFoto BLOB NOT NULL,
                $columnLog INT NOT NULL)''');

    await db.execute('''CREATE TABLE $tableRetos (
            $columnIDReto INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,            
            $columnIDUsuarioReto INT NOT NULL,
            $columnReto VARCHAR(200) NOT NULL,
            $columnFecha VARCHAR(100) NOT NULL,
            $columnStatus VARCHAR(2) NOT NULL)''');

    await db.execute('''CREATE TABLE $tableChat (            
            $columnIDMensaje INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            $columnIDUsuarioChat INT NOT NULL,
            $columnMensaje TEXT NOT NULL,            
            $columnFechaEnviado VARCHAR(100) NOT NULL)''');
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) {
    if (oldVersion != newVersion) {
      db.execute("DROP TABLE IF EXISTS $tableRegistro");
      db.execute('DROP TABLE IF EXISTS $tableRetos');
      db.execute('DROP TABLE IF EXISTS $tableChat');

      db.execute('''CREATE TABLE $tableRegistro (    
                $columnID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,     
                $columnNombre VARCHAR(100) NOT NULL,
                $columnApellido VARCHAR(100) NOT NULL,
                $columnCorreo VARCHAR(200) NOT NULL,
                $columnToken VARCHAR(200) NOT NULL,
                $columnFoto BLOB NOT NULL,
                $columnLog INT NOT NULL)''');

      db.execute('''CREATE TABLE $tableRetos (
            $columnIDReto INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,            
            $columnIDUsuarioReto INT NOT NULL,
            $columnReto VARCHAR(200) NOT NULL,
            $columnFecha VARCHAR(100) NOT NULL,
            $columnStatus VARCHAR(2) NOT NULL)''');

      db.execute('''CREATE TABLE $tableChat (            
            $columnIDMensaje INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            $columnIDUsuarioChat INT NOT NULL,
            $columnMensaje TEXT NOT NULL,            
            $columnFechaEnviado VARCHAR(100) NOT NULL)''');
    }
  }

  ///
  /// Database helper methods:
  ///

  ///
  /// MÉTODOS PARA USO DE USUARIO:
  ///
  Future<int> insertUsuario(
      _nombre, _apellido, _correo, _token, _foto, _logueado) async {
    Database db = await database;
    var result = await db.rawInsert(
        "INSERT Into $tableRegistro($columnNombre, $columnApellido, $columnCorreo, $columnToken, $columnFoto, $columnLog) VALUES (?,?,?,?,?,?);",
        [_nombre, _apellido, _correo, _token, _foto, _logueado]);
    return result;
  }

  Future<bool> updateLogueado(_id, _logueado) async {
    Database db = await database;
    var result = await db.rawQuery(
        "UPDATE $tableRegistro SET $columnLog = ? WHERE $columnID = ?",
        [_logueado, _id]);
    return true;
  }

  Future<bool> updateFoto(_id, _foto) async {
    Database db = await database;
    var result = await db.rawQuery(
        "UPDATE $tableRegistro SET $columnFoto = ? WHERE $columnID = ?",
        [_foto, _id]);
    return true;
  }

  Future<Usuario> getUsuarioLogueado() async {
    Usuario usuario = new Usuario();
    Database db = await database;
    var res = await db
        .rawQuery("SELECT * FROM $tableRegistro WHERE $columnLog = ?", [1]);
    if (res.isEmpty == false) {
      int id = res[res.length - 1]["ID"];
      String nombre = res[res.length - 1]["NOMBRE"];
      String apellido = res[res.length - 1]["APELLIDO"];
      String correo = res[res.length - 1]["CORREO"];
      String token = res[res.length - 1]["TOKEN"];
      String foto = res[res.length - 1]["FOTO"];
      int logueado = res[res.length - 1]["LOGUEADO"];
      usuario = new Usuario(
          id: id,
          nombre: nombre,
          apellidos: apellido,
          correo: correo,
          token: token,
          foto: foto,
          logueado: logueado);
      return usuario;
    } else {
      return null;
    }
  }

  Future<Usuario> existUsuario(_correo) async {
    Usuario usuario;
    Database db = await database;
    var res = await db.rawQuery(
        "SELECT * FROM $tableRegistro WHERE $columnCorreo = ?", [_correo]);
    if (res.isEmpty == false) {
      int id = res[res.length - 1]["ID"];
      String nombre = res[res.length - 1]["NOMBRE"];
      String apellido = res[res.length - 1]["APELLIDO"];
      String token = res[res.length - 1]["TOKEN"];
      String foto = res[res.length - 1]["FOTO"];
      int logueado = res[res.length - 1]["LOGUEADO"];
      usuario = new Usuario(
          id: id,
          nombre: nombre,
          apellidos: apellido,
          correo: _correo,
          token: token,
          foto: foto,
          logueado: logueado);
      return usuario;
    } else {
      return null;
    }
  }

  Future<bool> deleteAllRegistros() async {
    Database db = await database;
    var result = await db.rawQuery("DELETE FROM $tableRegistro");
    return true;
  }

  ///
  /// MÉTODOS PARA USO DE CHAT:
  ///
  Future<int> insertMensaje(_idUsuario, _mensaje) async {
    Database db = await database;
    var result = await db.rawInsert(
        'INSERT Into $tableChat($columnIDUsuarioChat, $columnMensaje, $columnFechaEnviado) VALUES(?,?,?);',
        [_idUsuario, _mensaje, DateTime.now().toString()]);

    return result;
  }

  Future<List<Mensaje>> getMensajes(int _id) async {
    List<Mensaje> list = new List<Mensaje>();
    Database db = await database;
    var result = await db.rawQuery(
        'SELECT * FROM $tableChat WHERE $columnIDUsuarioChat = ?', [_id]);

    for (int i = 0; i < result.length; i++) {
      list.add(Mensaje(
          origen: "usuario",
          mensaje: result[i]["MENSAJE"],
          fecha: DateTime.parse(result[i]["FECHA"])));
    }
    return list;
  }

  Future<bool> deleteAllMensajes() async {
    Database db = await database;
    var result = await db.rawQuery("DELETE FROM $tableChat");
    return true;
  }

  ///
  /// MÉTODOS PARA USO DE RETOS:
  ///
  Future<int> insertReto(_idUsuario, _reto) async {
    Database db = await database;
    var result = await db.rawInsert(
        'INSERT Into $tableRetos($columnIDUsuarioReto, $columnReto, $columnFecha, $columnStatus) VALUES(?,?,?,?)',
        [_idUsuario, _reto, DateTime.now().toString(), "Ok"]);
    return result;
  }

  Future<Meta> getReto(_idUsuario) async {
    Meta meta = new Meta();
    Database db = await database;
    var res = await db.rawQuery(
        'SELECT * FROM $tableRetos WHERE $columnIDUsuarioChat = ?',
        [_idUsuario]);
    if (res.length > 0) {
      meta.meta = res[res.length - 1]["RETO"];
    } else {
      meta.meta = "NA";
    }

    return meta;
  }

  Future<List<Meta>> getAllRetosPasados(_idUsuario) async {
    List<Meta> list = new List<Meta>();
    Database db = await database;
    var res = await db.rawQuery(
        'SELECT * FROM $tableRetos WHERE $columnIDUsuarioReto = ?',
        [_idUsuario]);

    for (int i = 0; i < res.length - 1; i++) {
      list.add(Meta(
        id: res[i]["ID"],
          meta: res[i]["RETO"],
          status: res[i]["ESTATUS"],
          fecha: new DateFormat("dd-MM-yyyy")
              .format(DateTime.parse(res[i]["FECHA"]))
              .toString()));
    }
    return list;
  }

  Future<bool> deleteReto(_idReto) async {
    Database db = await database;
    var result = await db
        .rawQuery("DELETE FROM $tableRetos WHERE $columnIDReto = ?", [_idReto]);
    return true;
  }

  Future<bool> updateReto(_idReto, _newReto) async {
    Database db = await database;
    var result = await db.rawQuery(
        "UPDATE $tableRetos SET $columnReto = ? WHERE $columnIDReto = ?",
        [_newReto, _idReto]);
    return true;
  }

  Future<bool> deleteAllRetos() async {
    Database db = await database;
    var result = await db.rawQuery("DELETE FROM $tableRetos");
    return true;
  }
}
