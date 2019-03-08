import 'package:flutter/material.dart';
import 'menu.dart';
import 'recetas.dart';
import 'restaurantes.dart';
import 'plan.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Image.asset(
          'assets/icons/recurso_1.png',
          width: MediaQuery.of(context).size.width * 0.22,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      drawer: new Menu(),
      body: new Container(
        decoration: new BoxDecoration(
          color: const Color(0x00FFCC00),
          image: new DecorationImage(
            image: new AssetImage("assets/images/fondo.jpg"),
            colorFilter: new ColorFilter.mode(
                Colors.black.withOpacity(0.2), BlendMode.dstATop),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 120,
                    margin: EdgeInsets.only(left: 30),
                    decoration: BoxDecoration(
                      image: new DecorationImage(
                        image: new AssetImage("assets/icons/recurso_4.png"),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                    child: Text(
                      "Sasha Sokol",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 30),
                    child: Text(
                      "Activo" + "     |     " + "10 citas",
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ),
                ],
              ),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Color(0xFF059696),
                borderRadius: new BorderRadius.vertical(
                    bottom: new Radius.elliptical(
                        MediaQuery.of(context).size.width * 1.5, 100.0)),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                  top: 20, right: 15, bottom: 50, left: 15),
              child: Card(
                child: Row(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding:
                              EdgeInsets.only(top: 12, left: 15, bottom: 2),
                          child: Text(
                            "11\nOCT",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF059696)),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(top: 2, left: 15, bottom: 12),
                          child: Text("10:00 AM"),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding:
                              EdgeInsets.only(top: 12, left: 25, bottom: 4),
                          child: Text(
                            "Próxima cita",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(top: 4, left: 25, bottom: 12),
                          child: Text("Seguimiento de peso"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              decoration: new BoxDecoration(boxShadow: [
                new BoxShadow(
                    color: Color(0x88505050),
                    blurRadius: 2.0,
                    offset: Offset(2, 2),
                    spreadRadius: -5),
              ]),
            ),
            Flexible(
              child: GridView.count(
                primary: false,
                padding: const EdgeInsets.all(0),
                crossAxisSpacing: 0,
                mainAxisSpacing: 0,
                crossAxisCount: 2,
                children: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RecetasPage()));
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 50),
                      child: Column(
                        children: <Widget>[
                          Image.asset(
                            "assets/icons/recurso_5.png",
                            width: MediaQuery.of(context).size.width * 0.2,
                          ),
                          Text(
                            "Nuevas recetas disponibles",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RestaurantesPage()));
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 50),
                      child: Column(
                        children: <Widget>[
                          Image.asset(
                            "assets/icons/recurso_6.png",
                            width: MediaQuery.of(context).size.width * 0.2,
                          ),
                          Text(
                            "Restaurantes disponibles en tu zona",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => PlanPage()));
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 50),
                      child: Column(
                        children: <Widget>[
                          Image.asset(
                            "assets/icons/recurso_7.png",
                            width: MediaQuery.of(context).size.width * 0.2,
                          ),
                          Text(
                            "Nuevo plan de alimentación disponible",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  FlatButton(
                    onPressed: () {},
                    child: Container(
                      margin: EdgeInsets.only(right: 50),
                      child: Column(
                        children: <Widget>[
                          Image.asset(
                            "assets/icons/recurso_8.png",
                            width: MediaQuery.of(context).size.width * 0.2,
                          ),
                          Text(
                            "Baja 2 kg",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                          Text(
                            "meta cumplida",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
