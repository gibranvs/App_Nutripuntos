import 'package:flutter/material.dart';
import 'home.dart';
import 'nutriologos.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
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
                padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                decoration: new BoxDecoration(
                  color: Color(0x88FFFFFF),
                  borderRadius: new BorderRadius.circular(12.0),
                ),
                child: TextField(
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
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                margin: EdgeInsets.only(top: 30.0),
                padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                decoration: new BoxDecoration(
                  color: Color(0x88FFFFFF),
                  borderRadius: new BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                  child: DropdownButton(
                      iconSize: 0,
                      hint: Text(
                        "Selecciona un nutriólogo",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      items: [
                        DropdownMenuItem<String>(
                          value: '1',
                          child: Text("aaa"),
                        ),
                      ],
                      onChanged: (_) {}),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                margin: EdgeInsets.only(top: 30.0),
                child: RaisedButton(
                  child: Text("Acceder"),
                  color: Color(0xFF78C826),
                  textColor: Colors.white,
                  padding:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
                  },
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                margin: EdgeInsets.only(top: 100.0),
                child: RaisedButton(
                  child: Text("Encuentra un nutriólogo"),
                  textColor: Color(0xFF78C826),
                  padding:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
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
