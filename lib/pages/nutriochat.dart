import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:nutripuntos_app/src/HexToColor.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:nutripuntos_app/globals.dart' as global;
import 'package:http/http.dart' as http;
import '../src/DBManager.dart' as db;
import 'newmenu.dart' as newmenu;
import '../src/bubble.dart';

final myTextEdit = TextEditingController();
final myListView = ScrollController();

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
    if (global.list_mensajes != null) if (global.list_mensajes.length > 0)
      global.list_mensajes
          .sort((a, b) => a.fecha.toString().compareTo(b.fecha.toString()));
/*
    Future.delayed(const Duration(milliseconds: 1000), () {      
      myListView.animateTo(
        myListView.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    });
    */

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
          list_messages(),
          message_area(),
        ],
      ),
    );
  }
}

class list_messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (global.list_mensajes != null && global.list_mensajes.length > 0) {
      return Container(
        height: MediaQuery.of(context).size.height - 130,
        margin: EdgeInsets.only(bottom: 10),
        child: Scrollbar(
          child: ListView(
            controller: myListView,
            shrinkWrap: true,
            children: global.list_mensajes.map((mensaje) {
              if (mensaje.origen == "doctor") {
                return Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      width: 50,
                      child: Image.asset("assets/icons/recurso_2.png"),
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5)),
                        child: Container(
                          constraints: BoxConstraints(
                              minWidth: 20, maxWidth: 220, minHeight: 40),
                          child: Bubble(
                            color: hexToColor("#bcbcbc"),
                            nip: BubbleNip.leftBottom,
                            nipWidth: 15,
                            nipHeight: 10,
                            radius: Radius.zero,
                            margin: BubbleEdges.only(top: 10),
                            stick: true,
                            child: Text(
                              mensaje.mensaje,
                              style: TextStyle(color: hexToColor("#676767")),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(10),
                      alignment: Alignment.centerRight,
                      child: Container(
                        alignment: Alignment.centerRight,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5)),
                        child: Container(
                          constraints: BoxConstraints(
                              minWidth: 20, maxWidth: 220, minHeight: 40),
                          child: Bubble(
                            color: hexToColor("#059696"),
                            nip: BubbleNip.rightBottom,
                            nipWidth: 15,
                            nipHeight: 10,
                            radius: Radius.zero,
                            margin: BubbleEdges.only(top: 10),
                            stick: true,
                            child: Text(
                              mensaje.mensaje,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 50,
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        image: global.image_foto == null
                            ? DecorationImage(
                                image: AssetImage("assets/images/photo.jpg"))
                            : global.image_foto,
                        //global.returnFileSelected(global.imageFile, global.imageFile.path),
                      ),
                    ),
                  ],
                );
              }
            }).toList(),
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}

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

getMensajesServer(String _token) async {
  try {
    var response = await http.post(global.server + "/aplicacion/api",
        body: {"tipo": "get_mensajes", "token": _token});
    var datos = json.decode(utf8.decode(response.bodyBytes));
    //print(datos);
    for (int i = 0; i < datos["response"].length; i++) {
      global.list_mensajes.add(Mensaje(
          origen: "doctor",
          mensaje: datos["response"][i]["texto"],
          fecha: DateTime.parse(datos["response"][i]["fecha"])));
    }
    //global.list_mensajes.sort((a, b) => a.toString().compareTo(b.toString()));
  } catch (e) {
    print("Error getMensajes " + e.toString());
  }
}

guardarMensajes(String _token, String _mensaje) async {
  try {
    var response = await http.post(global.server + "/aplicacion/api",
        body: {"tipo": "guarda_mensaje", "token": _token, "mensaje": _mensaje});
    var datos = json.decode(utf8.decode(response.bodyBytes));
    //print(datos);
    db.DBManager.instance.insertMensaje(global.id_user, _token, _mensaje);
    global.list_mensajes.add(
        Mensaje(origen: "usuario", mensaje: _mensaje, fecha: DateTime.now()));
    myListView.animateTo(
      myListView.position.maxScrollExtent,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
    myTextEdit.text = "";
  } catch (e) {
    print("Error guardarMensajes " + e.toString());
  }
}

class Mensaje {
  String origen;
  String mensaje;
  DateTime fecha;

  Mensaje({this.origen, this.mensaje, this.fecha});
}
