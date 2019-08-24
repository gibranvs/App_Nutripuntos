import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nutripuntos_app/globals.dart' as global;
import 'dart:async';
import 'dart:convert';
import 'home.dart';
import 'nutriologos.dart';
import '../src/MessageAlert.dart' as alert;
import '../src/DBManager.dart' as db;

var myControllerUser = TextEditingController();
var listDoctores = [];

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  
  final Data data = new Data(usr: "1", doctor: "2");

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
                      controller: myControllerUser,
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
                      child: 
                      //FutureBuilder<List<Doctor>>(                    
                          //future: fetchDoctores(),                          
                          //builder: (context, snapshot) {                            
                            //if (snapshot.hasData) {
                              //if(listDoctores.length > 0) {
                               DropdownButton<Doctor>(
                                iconSize: 0,
                                hint: Text(
                                  "Selecciona un especialista",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                                items:                                 

                                listDoctores
                                    .map((doctor) => DropdownMenuItem<Doctor>(
                                          child: Text(doctor.nombre),
                                          value: doctor,
                                        ))
                                    .toList(),
                                    
                                value: doctorSelect,
                                onChanged: (Doctor _doctor) {
                                  setState(() {
                                    if(_doctor != null)
                                    {
                                    doctorSelect = _doctor;
                                    print(doctorSelect.nombre);
                                    }
                                  });
                                },                                
                              ),
                              /*
                            } else if (snapshot.hasError) {
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 15),
                                child: Text(
                                    "En este momento no se pudo obtener la lista de especialistas disponibles." +
                                        snapshot.error.toString()),
                              );
                            }
                            */
                            // By default, show a loading spinner
                            //return new CircularProgressIndicator();
                          //},),
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
                        check_login(context, myControllerUser, doctorSelect);
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
}

void check_login(_context, _controller, _doctorSelected) async {
  if (_controller.text != "") {
    final response = await http.post(global.server + '/aplicacion/api', body:{"tipo": "login", "usr": _controller.text, "doc": _doctorSelected.id});        
    var responseJson = json.decode(utf8.decode(response.bodyBytes));
    //print(responseJson);
    if (responseJson["status"] == 1) {
      global.nombre_user = responseJson["response"][0]["nombre"];
      global.apellidos_user = responseJson["response"][0]["apellidos"];
      global.token = responseJson["response"][0]["token"];
      global.recovery_token = responseJson["response"][0]["recoverytk"];
      db.DBManager.instance.insertUsuario(responseJson["response"][0]["nombre"].toString(), responseJson["response"][0]["apellidos"].toString(), responseJson["response"][0]["token"].toString(), "");
      _controller.text = "";    
      global.selected_index = 0;  
      Navigator.push(
        _context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );  
    }
    else
    {
      alert.showMessageDialog(_context, "Error en el login", "Verifica que tu correo y tu especialista sean correctos.");
    }
  }
  else
  {
    alert.showMessageDialog(_context, "Error en el login", "Ingresa todos los campos.");
  }
}

Future<List<Doctor>> fetchDoctores() async {
  final response =
      await http.get(global.server + '/aplicacion/api/get_doctores');
  List responseJson = json.decode(utf8.decode(response.bodyBytes));
  List<Doctor> doctoresList = createDoctoresList(responseJson);
  return doctoresList;
}

List<Doctor> createDoctoresList(List data) {
  List<Doctor> list = new List();

  for (int i = 0; i < data.length; i++) {
    String id = data[i]["id"];
    String nombre = data[i]["nombre"];

    Doctor doctor = new Doctor(id: id, nombre: nombre);
    list.add(doctor);
  }
  
  if(list.length > 0)
    listDoctores = list;
    else
    listDoctores.add("No se pudo cargar la lista de especialistas.");
  return list;
}

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
