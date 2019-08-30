import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:nutripuntos_app/src/HexToColor.dart';
import 'package:nutripuntos_app/globals.dart' as global;
import 'package:http/http.dart' as http;
import '../src/DBManager.dart' as db;
import 'newmenu.dart' as newmenu;

class NutriochatPage extends StatefulWidget {
  @override
  _NutriochatPageState createState() => new _NutriochatPageState();
}

class _NutriochatPageState extends State<NutriochatPage> {
  @override
  Widget build(BuildContext context) {
    /*
    show_Dialog(
        context: context,
        titulo: '¿Tienes dudas?',
        mensaje:
            'Escribe a un nutriólogo a través de nutrio chat, un espacio creado para contactar a tu doctor, fácilmente');
            */
    getMensajes(global.token);
    db.DBManager.instance.getMensajes(global.token);
    return new Scaffold(
      drawer: new newmenu.menu(6),
      appBar: AppBar(
        elevation: 4,
        title: Text("Nutriochat"),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF35B9C5),
                Color(0xFF348CB4),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 0),
            decoration: new BoxDecoration(
              color: const Color(0x00FFCC00),
              image: new DecorationImage(
                image: new AssetImage("assets/images/fondo.jpg"),
                colorFilter: new ColorFilter.mode(
                    Colors.black.withOpacity(0.2), BlendMode.dstATop),
                fit: BoxFit.cover,
              ),
            ),
          ),
          message_area(),
        ],
      ),
    );
  }
}

final myTextEdit = TextEditingController();

class message_area extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.bottomCenter,
      child: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            color: Colors.white,
            child: TextField(
              controller: myTextEdit,
              decoration: InputDecoration(
                labelText: "Escribe aquí tus dudas",
                suffixIcon: GestureDetector(
                  onTap: () {
                    print("Send message: " + myTextEdit.text);
                    guardarMensajes(global.token, myTextEdit.text);
                  },
                  child: Icon(
                    Icons.send,
                    color: hexToColor("#059696"),
                  ),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
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
      return Container(
        child: Builder(builder: (BuildContext context) {
          return Container(
            alignment: Alignment.topCenter,
            color: Colors.transparent,
            child: Stack(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  width: 400,
                  height: 600,
                  margin: EdgeInsets.only(
                      left: 30, right: 30, top: 170, bottom: 10),
                  decoration: new BoxDecoration(
                      color: hexToColor("#505050"),
                      borderRadius:
                          new BorderRadius.all(const Radius.circular(20.0))),
                ),
                Container(
                  alignment: Alignment.topCenter,
                  margin: EdgeInsets.only(top: 300),
                  child: Text(
                    titulo,
                    style: TextStyle(
                        decoration: TextDecoration.none,
                        fontFamily: "Arial",
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  alignment: Alignment.topCenter,
                  margin: EdgeInsets.only(top: 340),
                  child: SizedBox(
                    width: 270,
                    child: AutoSizeText(
                      mensaje,
                      maxLines: 3,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          fontFamily: "Arial",
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      );
    },
    barrierDismissible: true,
    barrierLabel: "",
    barrierColor: null,
    transitionDuration: const Duration(milliseconds: 150),
  );
}

void getMensajes(String _token) async {
  try {
    var response = await http.post(global.server + "/aplicacion/api",
        body: {"tipo": "get_mensajes", "token": _token});
    var datos = json.decode(utf8.decode(response.bodyBytes));
    print(datos);
  } catch (e) {
    print("Error getMensajes " + e.toString());
  }
}

guardarMensajes(String _token, String _mensaje) async {
  try {
    var response = await http.post(global.server + "/aplicacion/api", body: {
      "tipo": "guarda_mensaje",
      "token": _token,
      "mensaje": _mensaje
    });
    var datos = json.decode(utf8.decode(response.bodyBytes));
    //print(datos);
    db.DBManager.instance.insertMensaje(_token, _mensaje);
    myTextEdit.text = "";
  } catch (e) {
    print("Error guardarMensajes " + e.toString());
  }
}