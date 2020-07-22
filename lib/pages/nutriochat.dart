import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/scheduler.dart';
import 'package:nutripuntos_app/pages/home.dart';
import 'package:nutripuntos_app/src/HexToColor.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:nutripuntos_app/globals.dart' as global;
import 'package:http/http.dart' as http;
import 'package:nutripuntos_app/src/mensaje.dart';
import '../src/DBManager.dart' as db;
import 'newmenu.dart' as newmenu;
import '../src/bubble.dart';
import '../src/MessageAlert.dart' as alert;

Color colorIcon = hexToColor("#9a9a9a");
bool msgs_doctor_ready = false;
bool msgs_user_ready = false;
bool sending = false;
double opacityDownVisible = 0;

class NutriochatPage extends StatefulWidget {
  @override
  _NutriochatPageState createState() => new _NutriochatPageState();
}

class _NutriochatPageState extends State<NutriochatPage> {
  ScrollController myListView = ScrollController();

  ///
  /// Fondo
  ///
  Positioned fondo() {
    return Positioned(
      left: 0,
      top: 0,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Container(
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
    );
  }

  ///
  /// List Mensajes
  ///
  Widget listMessages() {
    return (global.list_mensajes != null && global.list_mensajes.length > 0)
        ? Container(
            height: MediaQuery.of(context).size.height - 130,
            margin: EdgeInsets.only(bottom: 50),            
            child: ListView(
              controller: myListView,
              shrinkWrap: true,
              //physics: BouncingScrollPhysics(),
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
          )
        : Offstage();
  }

  Widget floatingButton() {
    return AnimatedOpacity(
      opacity: opacityDownVisible,
      duration: Duration(milliseconds: 500),
          child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.bottomRight,
        margin: EdgeInsets.only(
          right: 10,
        ),
        child: GestureDetector(
          onTap: () {
            //myListView.jumpTo(myListView.position.maxScrollExtent);
            Future.delayed(Duration.zero, () {
              myListView.animateTo(myListView.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut);
            });
          },
          child: Container(
            width: 50,
            height: 50,
            margin: EdgeInsets.only(
              bottom: 60,
            ),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: hexToColor("#3DB2C2"),
              borderRadius: BorderRadius.all(
                Radius.circular(50),
              ),
            ),
            child: Icon(
              Icons.arrow_downward,
              color: Colors.white,
            ),
          ),
        ),
          ),
    );
  }

  ///
  /// Text mensaje
  ///
  Container messageArea() {
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
              controller: global.text_mensaje,
              onChanged: (value) {
                if (value != "")
                  setState(() {
                    colorIcon = hexToColor("#059696");
                  });
                else
                  setState(() {
                    colorIcon = hexToColor("#9a9a9a");
                  });
              },
              decoration: InputDecoration(
                labelText: "Escribe aquí tus dudas",
                suffixIcon: (sending == false)
                    ? GestureDetector(
                        onTap: () {
                          if (global.text_mensaje.text.length > 0) {
                            print("Send message: " + global.text_mensaje.text);
                            guardarMensajes(context, global.usuario.token,
                                global.text_mensaje.text);
                          }
                        },
                        child: Icon(
                          Icons.send,
                          color: colorIcon,
                        ),
                      )
                    : Container(
                        padding: EdgeInsets.all(15),
                        child: SizedBox(
                          width: 10,
                          height: 10,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
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

  @override
  void initState() {
    super.initState();

    myListView = new ScrollController();
    setState(() {
      msgs_user_ready = false;
      msgs_doctor_ready = false;
      sending = false;
    });

    getMensajesServer(global.usuario.token).then((_mensajesDoctor) {
      if (_mensajesDoctor != null) {
        setState(() {
          msgs_doctor_ready = true;
        });
      }

      db.DBManager.instance
          .getMensajes(global.usuario.id)
          .then((_mensajesUsuario) {
        setState(() {
          msgs_user_ready = true;
          global.list_mensajes = _mensajesDoctor +
              _mensajesUsuario; //new List.from(_mensajesDoctor)..addAll(_mensajesUsuario);
          global.list_mensajes
              .sort((a, b) => a.fecha.toString().compareTo(b.fecha.toString()));
        });

        if (global.list_mensajes == null || global.list_mensajes.length == 0) {
          Timer.periodic(Duration(seconds: 2), (timer) {
            alert.showMessageDialog(context, "Hola",
                "Escribe a un nutriólogo a través de Nutrichat, un espacio creado para contactar a tu doctor, fácilmente.");
            if (timer.tick > 0) timer.cancel();
          });
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {          
          myListView.jumpTo(myListView.position.maxScrollExtent);

          myListView.addListener(scrollListener);          
        });        
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    myListView.dispose();
  }

  scrollListener() {
    if (myListView.offset >= myListView.position.maxScrollExtent &&
        !myListView.position.outOfRange) {
          //print("reach the bottom");
      setState(() {
        opacityDownVisible = 0;
      });
    }
    if (myListView.offset <= myListView.position.minScrollExtent &&
        !myListView.position.outOfRange) {
          //print("reach the top");
      setState(() {
        opacityDownVisible = 1;
      });
    }
    if (myListView.offset < myListView.position.maxScrollExtent) {
          //print("scrolled");
      setState(() {
        opacityDownVisible = 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: true,
      resizeToAvoidBottomPadding: true,
      //drawer: new newmenu.menu(6),
      appBar: AppBar(
        elevation: 4,
        title: Text("Nutrichat"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
              ModalRoute.withName('/'),
            );
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
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
      body: Container(
        child: Stack(
          children: <Widget>[
            fondo(),
            (msgs_user_ready == true && msgs_doctor_ready == true)
                ? listMessages()
                : Container(
                    height: MediaQuery.of(context).size.height - 130,
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        semanticsLabel: "Loading",
                        backgroundColor: hexToColor("#cdcdcd"),
                      ),
                    ),
                  ),
            floatingButton(),
            messageArea(),
          ],
        ),
      ),
    );
  }

  void guardarMensajes(
      BuildContext _context, String _token, String _mensaje) async {
    setState(() {
      sending = true;
    });
    try {
      //FocusScope.of(_context).requestFocus(new FocusNode());
      var response = await http.post(global.server + "/aplicacion/api", body: {
        "tipo": "guarda_mensaje",
        "token": _token,
        "mensaje": _mensaje
      });
      var datos = json.decode(utf8.decode(response.bodyBytes));
      //print(datos);
      await db.DBManager.instance.insertMensaje(global.usuario.id, _mensaje);

      setState(() {
        global.list_mensajes.add(Mensaje(
            origen: "usuario", mensaje: _mensaje, fecha: DateTime.now()));
        sending = false;
        global.text_mensaje.text = "";
        colorIcon = hexToColor("#9a9a9a");                
      });
      Future.delayed(Duration.zero, () {
            myListView.animateTo(myListView.position.maxScrollExtent + 70,
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOut);
          });
    } catch (e) {
      print("Error guardarMensajes " + e.toString());
    }
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

Future<List<Mensaje>> getMensajesServer(String _token) async {
  List<Mensaje> list = new List<Mensaje>();
  try {
    var response = await http.post(global.server + "/aplicacion/api",
        body: {"tipo": "get_mensajes", "token": _token});
    var datos = json.decode(utf8.decode(response.bodyBytes));
    //print(datos);
    for (int i = 0; i < datos["response"].length; i++) {
      list.add(Mensaje(
          origen: "doctor",
          mensaje: datos["response"][i]["texto"],
          fecha: DateTime.parse(datos["response"][i]["fecha"])));
    }
    return list;
    //global.list_mensajes.sort((a, b) => a.toString().compareTo(b.toString()));
  } catch (e) {
    print("Error getMensajes " + e.toString());
    return null;
  }
}
