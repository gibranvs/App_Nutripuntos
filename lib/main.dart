import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
  title: 'Nutripuntos',
  home: MyApp(),
));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nutripuntos',
      home: Scaffold(

        body:new Container(
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage("images/fondo.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: ListView(
              padding: EdgeInsets.only(top:200),
              children:[
                Center(
                    child: Image.asset(
                          'images/puntos-colores.png',
                          width: 200,
                          fit: BoxFit.cover,
                        )
                ),
                Center(
                    child:new Container(
                      width:230,
                        child:TextField(
                          decoration: InputDecoration(
                            hintText:"Correo electrónico"
                          ),
                        )
                    ),
                ),
                Center(
                  child: RaisedButton(
                    child: Text('Acceder'),
                    color: Colors.green[400],
                    onPressed: () {
                      // Navigate to second screen when tapped!
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Perfil()),
                      );
                    },
                  ),
                ),

                Center(
                  child: RaisedButton(
                    child: Text('Encuentra un nutriólogo'),
                    onPressed: () {
                      // Navigate to second screen when tapped!
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Nutriologos()),
                      );
                    },
                  ),
                ),
              ]

          ) /* add child content here */,
        ),
      ),
    );
  }
}

class Nutriologos extends StatelessWidget {
  final _nutris=<String>["Luis Méndez de la Rosa","Arturo Santillan","Erika Linares Hernández","Ángel Gabriel Salinas","Paola Zarza","Gibrán Vázquez","Raúl Medina","Juanito Pérez"];
  // #docregion _buildSuggestions
  Widget _buildNutriologos() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: /*1*/ (context, i) {
          if (i.isOdd) return Divider(); /*2*/

          final index = i ~/ 2; /*3*/
          if (index < _nutris.length) {
            return _buildRow(_nutris[index]);
          }
        });
  }
  // #enddocregion _buildSuggestions

  // #docregion _buildRow
  Widget _buildRow(String pair) {
    return ListTile(
      leading: Icon(Icons.photo_camera),
      title: Text(
        pair,
      ),
      subtitle:Text("doctor@nutri.com"),
    );
  }
  // #enddocregion _buildRow

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nutriólogos'),
        backgroundColor: Colors.green[400],
      ),
      body: _buildNutriologos(),
    );
  }
}

class Perfil extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Mi Perfil'),
          backgroundColor: Colors.green[400],
        ),
        drawer:Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text('Sasha Sokol'),
                decoration: BoxDecoration(
                  color: Colors.green[400],
                ),
              ),
              ListTile(
                title: Text('Plan de alimentación'),
                onTap: () {
                  // Update the state of the app
                  // ...
                },
              ),
              ListTile(
                title: Text('Progreso'),
                onTap: () {
                  // Update the state of the app
                  // ...
                },
              ),
              ListTile(
                title: Text('Agenda'),
                onTap: () {
                  // Update the state of the app
                  // ...
                },
              ),
              ListTile(
                title: Text('Recetas'),
                onTap: () {
                  // Update the state of the app
                  // ...
                },
              ),
              ListTile(
                title: Text('Restaurantes'),
                onTap: () {
                  // Update the state of the app
                  // ...
                },
              ),
              ListTile(
                title: Text('Nutriochat'),
                onTap: () {
                  // Update the state of the app
                  // ...
                },
              ),
            ],
          ),
        ),
        body:new Container(
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage("images/pantalla-inicio2.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: null /* add child content here */,
        ),
      ),
    );
  }
}

