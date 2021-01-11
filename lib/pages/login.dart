import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nutripuntos_app/globals.dart' as global;
import 'package:nutripuntos_app/src/usuario.dart';
import 'package:nutripuntos_app/widgets/autocomplete_textfield.dart';
import 'dart:async';
import 'dart:convert';
import 'home.dart';
import 'nutriologos.dart';
import '../src/MessageAlert.dart' as alert;
import '../src/DBManager.dart' as db;

var listDoctores = [];
String currentText = "";
List<String> suggestions = [];
TextEditingController especialista_controller = new TextEditingController();
GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final Data data = new Data(usr: "1", doctor: "2");  

  @override
  void initState() {
    super.initState();
    key = new GlobalKey();
    especialista_controller = new TextEditingController();
    if(suggestions != null) suggestions.clear();
    fetchDoctores().then((_result) {
      setState(() {
        listDoctores = _result;
        //print(listDoctores);
        for (var doc in listDoctores) {
          suggestions.add(doc.nombre);          
        }
      });
    });    
  }

  @override
  void dispose() {    
    super.dispose();
  }

  @override
  Doctor doctorSelect;
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        body: new Container(
          decoration: new BoxDecoration(
            color: const Color(0xFF059696),
            image: new DecorationImage(
              image: new AssetImage("assets/images/fondo.jpg"),
              colorFilter: new ColorFilter.mode(
                  Colors.black.withOpacity(0.2), BlendMode.dstATop),
              fit: BoxFit.cover,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 80.0),
                    child: Image.asset(
                      'assets/icons/recurso_1.png',
                      width: MediaQuery.of(context).size.width * 0.5,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    padding:
                        EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                    decoration: new BoxDecoration(
                      color: Color(0x88FFFFFF),
                      borderRadius: new BorderRadius.circular(12.0),
                    ),
                    child: TextField(
                      controller: global.text_email,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        labelText: "Correo electrónico",
                        labelStyle: TextStyle(
                          color: Colors.white,
                        ),
                        hintText: "Correo electrónico",
                        hintStyle: TextStyle(
                          color: Colors.white,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(5.0),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    margin: EdgeInsets.only(top: 30.0),
                    padding:
                        EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                    decoration: new BoxDecoration(
                      color: Color(0x88FFFFFF),
                      borderRadius: new BorderRadius.circular(12.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                      child: SimpleAutoCompleteTextField(
                        key: key,
                        minLength: 3,                      
                        decoration: new InputDecoration(
                          hintText: "Busca a tu especialista",
                          hintStyle: TextStyle(
                            color: Colors.white,
                          ),
                          border: InputBorder.none,
                        ),
                        controller: especialista_controller,
                        suggestions: suggestions,                        
                        textChanged: (text) {
                          currentText = text;
                        },
                        clearOnSubmit: false,
                        textSubmitted: (text) => setState(() {                          
                          String id;
                          for (var d in listDoctores) {
                            if (d.nombre == text) id = d.id;
                          }
                          Doctor doc = new Doctor(id: id, nombre: text);
                          doctorSelect = doc;
                        }),
                        style: TextStyle(color: Colors.white),
                      ),
/*
                          DropdownButton<Doctor>(
                        iconSize: 0,
                        hint: Text(
                          "Selecciona un especialista",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        items: listDoctores
                            .map(
                              (doctor) => DropdownMenuItem<Doctor>(
                                child: Text(doctor.nombre),
                                value: doctor,
                              ),
                            )
                            .toList(),
                        value: doctorSelect,
                        onChanged: (Doctor _doctor) {
                          setState(() {
                            if (_doctor != null) {
                              doctorSelect = _doctor;
                              print(doctorSelect.nombre);
                            }
                          });
                        },
                      ),
                      */
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    margin: EdgeInsets.only(top: 30.0),
                    child: RaisedButton(
                      child: Text("Acceder"),
                      color: Color(0xFF78C826),
                      textColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 10.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0)),
                      onPressed: () {
                        String id;
                          for (var d in listDoctores) {
                            if (d.nombre == especialista_controller.text) id = d.id;
                          }
                          Doctor doc = new Doctor(id: id, nombre: especialista_controller.text);
                          doctorSelect = doc;

                        check_login(global.text_email.text, doctorSelect);
                      },
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    margin: EdgeInsets.only(top: 100.0),
                    child: RaisedButton(
                      child: Text("Encuentra un especialista"),
                      textColor: Color(0xFF78C826),
                      padding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 10.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0)),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NutriologosPage()));
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  void check_login(_email, _doctorSelected) async {
    if (_email != "") {
      final response = await http.post(global.server + '/aplicacion/api',
          body: {"tipo": "login", "usr": _email, "doc": _doctorSelected.id});
      var responseJson = json.decode(utf8.decode(response.bodyBytes));
      print(responseJson);
      if (responseJson["status"] == 1) {
        db.DBManager.instance.existUsuario(_email).then((usuario) {
          if (usuario != null) {
            global.usuario = usuario;
            db.DBManager.instance.updateLogueado(usuario.id, 1).then((_) {
              setState(() {
                global.text_email.text = "";
                global.selected_index = 0;
              });
              readFileContent().then((_) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              });
            });
          } else {
            db.DBManager.instance
                .insertUsuario(
                    responseJson["response"][0]["nombre"],
                    responseJson["response"][0]["apellidos"],
                    _email,
                    responseJson["response"][0]["token"],
                    "foto",
                    1)
                .then((idUsuario) {
              int id = idUsuario;
              String nombre = responseJson["response"][0]["nombre"];
              String apellidos = responseJson["response"][0]["apellidos"];
              String correo = _email;
              String token = responseJson["response"][0]["token"];
              String foto = "foto";
              int logueado = 1;
              global.usuario = new Usuario(
                  id: id,
                  nombre: nombre,
                  apellidos: apellidos,
                  correo: correo,
                  token: token,
                  foto: foto,
                  logueado: logueado);

              setState(() {
                global.text_email.text = "";
                global.selected_index = 0;
              });

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            });
          }
        });
      } else {
        alert.showMessageDialog(context, "Error en el login",
            "Verifica que tu correo y tu especialista sean correctos.");
      }
    } else {
      alert.showMessageDialog(
          context, "Error en el login", "Ingresa todos los campos.");
    }
  }
}

Future<List<Doctor>> fetchDoctores() async {
  List<Doctor> list = new List();
  final response = await http
      .post(global.server + '/aplicacion/api', body: {'tipo': 'get_doctores'});
  var datos = json.decode(utf8.decode(response.bodyBytes));
  //print(datos);

  for (int i = 0; i < datos.length; i++) {
    String id = datos[i]["id"];
    String nombre = datos[i]["nombre"];

    Doctor doctor = new Doctor(id: id, nombre: nombre);
    list.add(doctor);
  }

  //List responseJson = json.decode(utf8.decode(response.bodyBytes));
  //List<Doctor> doctoresList = createDoctoresList(responseJson);
  return list;
}

/*
List<Doctor> createDoctoresList(List data) {
  List<Doctor> list = new List();

  for (int i = 0; i < data.length; i++) {
    String id = data[i]["id"];
    String nombre = data[i]["nombre"];

    Doctor doctor = new Doctor(id: id, nombre: nombre);
    list.add(doctor);
  }

  if (list.length > 0)
    listDoctores = list;
  else
    listDoctores.add("No se pudo cargar la lista de especialistas.");
  return list;
}
*/

class Doctor {
  String id;
  String nombre;

  Doctor({this.id, this.nombre});
}

class Data {
  String usr;
  String doctor;

  Data({this.usr, this.doctor});
}

class ValidarUsuario extends StatelessWidget {
  final Data data;
  ValidarUsuario({this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Text("\n\naaaaaaaa $data.usr"),
      ),
    );
  }
}
