import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../globals.dart' as globals;
import 'package:intl/intl.dart';
import '../pages/home.dart';
import '../pages/login.dart';
import '../pages/progreso.dart' as progreso;
import '../pages/nutriochat.dart' as chat;

///
/// TABLA REGISTRO
///
final String tableRegistro = "REGISTRO";
final String columnID = "ID";
final String columnNombre = "NOMBRE";
final String columnApellido = "APELLIDO";
final String columnToken = "TOKEN";
final String columnFoto = "FOTO";

///
/// TABLA RETOS
///
final String tableRetos = "RETOS";
final String columnTokenReto = "TOKEN";
final String columnReto = "RETO";
final String columnFecha = "FECHA";
final String columnStatus = "ESTATUS";

///
/// TABLA CHAT
///
final String tableChat = "CHAT";
final String columnTokenMsj = "TOKEN";
final String columnMensaje = "MENSAJE";
final String columnEnviado = "FECHA";

// singleton class to manage the database
class DBManager {
  // This is the actual database filename that is saved in the docs directory.
  static final _databaseName = "RegistroUsuario.db";
  // Increment this version when you need to change the schema.
  static final _databaseVersion = 15;

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
                $columnFoto BLOB NOT NULL
                )
              ''');
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) {
    if (oldVersion < newVersion) {
      db.execute("DROP TABLE IF EXISTS $tableRegistro");
      db.execute('DROP TABLE IF EXISTS $tableRetos');
      db.execute('DROP TABLE IF EXISTS $tableChat');

      db.execute('''CREATE TABLE $tableRetos (
            $columnID INT NOT NULL,
            $columnTokenReto VARCHAR(200) NOT NULL,
            $columnReto VARCHAR(200) NOT NULL,
            $columnFecha VARCHAR(100) NOT NULL,
            $columnStatus VARCHAR(2) NOT NULL)''');

      db.execute('''CREATE TABLE $tableChat (
            $columnID INT NOT NULL,
            $columnTokenMsj VARCHAR(200) NOT NULL,
            $columnMensaje TEXT NOT NULL,            
            $columnEnviado VARCHAR(100) NOT NULL)''');

      db.execute('''
              CREATE TABLE $tableRegistro (    
                $columnID INT NOT NULL,     
                $columnNombre VARCHAR(100) NOT NULL,
                $columnApellido VARCHAR(100) NOT NULL,
                $columnToken VARCHAR(200) NOT NULL,
                $columnFoto BLOB NOT NULL
                )
              ''');
    }
  }

  ///
  /// Database helper methods:
  ///

  ///
  /// MÉTODOS PARA USO DE USUARIO:
  ///
  insertUsuario(_id, _nombre, _apellido, _token, _foto) async {
    Database db = await database;
    var queryResult = await db.rawQuery("SELECT * FROM $tableRegistro");

    if (queryResult.isEmpty == true) {
      await db.rawInsert(
          "INSERT Into $tableRegistro($columnID, $columnNombre, $columnApellido, $columnToken, $columnFoto) VALUES (?,?,?,?,?);",
          [_id, _nombre, _apellido, _token, _foto]);
    } else {
      //print("update");
      await db.rawQuery(
          "UPDATE $tableRegistro SET $columnNombre = ?, $columnApellido = ?, $columnToken = ?, $columnFoto = ?",
          [_nombre, _apellido, _token, _foto]);
    }
  }

  getUsuario(_context) async {
    try {
      Database db = await database;
      var res = await db.rawQuery("SELECT * FROM $tableRegistro");
      if (res.isEmpty == true) {
        print("No hay usuario");
        globals.user_exist = false;
        //Navigator.of(_context).pushReplacementNamed('/HomeScreen');
        Navigator.push(
          _context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        //print(res);
        globals.id_user = int.parse(res[res.length - 1]["ID"].toString());
        globals.nombre_user = res[res.length - 1]["NOMBRE"].toString();
        globals.apellidos_user = res[res.length - 1]["APELLIDO"].toString();
        globals.token = res[res.length - 1]["TOKEN"].toString();

        getMensajes(globals.id_user, globals.token);
        chat.getMensajesServer(globals.token);

        readFileContent();

        Future.delayed(const Duration(milliseconds: 5000), () {
          Navigator.push(
            _context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        });
      }
    } catch (_ex) {
      //globals.imageFilePath = "assets/images/photo.jpg";
      globals.image_foto =
          new DecorationImage(image: AssetImage("assets/images/photo.jpg"));
    }
  }

  deleteAllRegistros() async {
    Database db = await database;
    db.rawQuery("DELETE FROM $tableRegistro");
  }

  ///
  /// MÉTODOS PARA USO DE CHAT:
  ///
  insertMensaje(int _id, String _token, String _mensaje) async {
    Database db = await database;
    db.rawQuery(
        'INSERT Into $tableChat($columnID, $columnTokenMsj, $columnMensaje, $columnEnviado) VALUES(?,?,?,?);',
        [_id, _token, _mensaje, DateTime.now().toString()]);
  }

  getMensajes(int _id, String _token) async {
    Database db = await database;
    var res = await db
        .rawQuery('SELECT * FROM $tableChat WHERE $columnID = ?', [_id]);
    globals.list_mensajes = new List<chat.Mensaje>();
    for (int i = 0; i < res.length; i++) {
      globals.list_mensajes.add(chat.Mensaje(
          origen: "usuario",
          mensaje: res[i]["MENSAJE"],
          fecha: DateTime.parse(res[i]["FECHA"])));
    }
  }

  deleteAllMensajes() async {
    Database db = await database;
    db.rawQuery("DELETE FROM $tableChat");
  }

  ///
  /// MÉTODOS PARA USO DE RETOS:
  ///
  Future<progreso.Meta> getReto(String _token) async {
    Database db = await database;
    var res = await db.rawQuery(
        'SELECT * FROM $tableRetos WHERE $columnTokenReto = ?', [_token]);
    progreso.Meta meta = new progreso.Meta();
    if (res.length > 0) {
      meta.meta = res[res.length - 1]["RETO"];
    } else {
      meta.meta = "NA";
    }

    return meta;
  }

  Future<List<progreso.Meta>> getAllRetosPasados(String _token) async {
    Database db = await database;
    var res = await db.rawQuery(
        'SELECT * FROM $tableRetos WHERE $columnTokenReto = ?', [_token]);

    List<progreso.Meta> list = new List<progreso.Meta>();
    for (int i = 0; i < res.length - 1; i++) {
      list.add(progreso.Meta(
          meta: res[i]["RETO"],
          status: res[i]["ESTATUS"],
          fecha: new DateFormat("dd-MM-yyyy")
              .format(DateTime.parse(res[i]["FECHA"]))
              .toString()));
    }
    return list;
  }

  insertReto(int _id, String _token, String _reto) async {
    Database db = await database;
    db.rawQuery(
        'INSERT Into $tableRetos($columnID, $columnTokenReto, $columnReto, $columnFecha, $columnStatus) VALUES(?,?,?,?,?)',
        [_id, _token, _reto, DateTime.now().toString(), "Ok"]);
  }

  deleteReto(String _reto) async {
    Database db = await database;
    db.rawQuery("DELETE FROM $tableRetos WHERE $columnReto = ?", [_reto]);
  }

  updateReto(String _oldReto, String _newReto) async {
    Database db = await database;
    db.rawQuery("UPDATE $tableRetos SET $columnReto = ? WHERE $columnReto = ?", [_newReto, _oldReto]);
  }

  deleteAllRetos() async {
    Database db = await database;
    db.rawQuery("DELETE FROM $tableRetos");
  }
}

class Usuario {
  String nombre;
  String token;
  String foto;

  Usuario({this.nombre, this.token, this.foto});
}
