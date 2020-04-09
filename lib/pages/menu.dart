import 'package:flutter/material.dart';
import 'package:nutripuntos_app/pages/home.dart';
import '../globals.dart' as global;
import 'plan.dart';
import 'progreso.dart';
import 'agenda.dart';
import 'recetas.dart';
import 'restaurantes.dart';
import 'nutriochat.dart';
import 'login.dart';
import '../src/DBManager.dart' as db;

//var drawerOptions = <Widget>[];
//int _selectedDrawerIndex = 0;

class DrawerItem {
  String title;
  String path;
  double size;
  DrawerItem(this.title, this.path, this.size);
}

class Menu extends StatefulWidget {
  final drawerItems = [
    new DrawerItem("Plan de alimentación", "assets/icons/recurso_11.png", 38),
    new DrawerItem("Progreso", "assets/icons/recurso_13.png", 35),
    new DrawerItem("Agenda", "assets/icons/recurso_12.png", 27),
    new DrawerItem("Recetas", "assets/icons/recurso_14.png", 38),
    new DrawerItem("Restaurantes", "assets/icons/recurso_9.png", 35),
    new DrawerItem("Nutriochat", "assets/icons/recurso_10.png", 35),
  ];

  @override
  State<StatefulWidget> createState() {
    return new MenuState();
  }
}

class MenuState extends State<Menu> {
  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        global.selected_index = 0;
        return new PlanPage(0);
      case 1:
        global.selected_index = 0;
        return new ProgresoPage(0);
      case 2:
        global.selected_index = 0;        
        return new AgendaPage();
      case 3:
        global.selected_index = 0;
        return new RecetasPage();
      case 4:
        global.selected_index = 0;
        return new RestaurantesPage();
      case 5:
        global.selected_index = 0;
        return new NutriochatPage();

      default:
        global.selected_index = 0;
        return new Text("Error");
    }
  }

  _onSelectItem(int index) {
    global.selected_index = index;
    setState(() => global.selected_index = index);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    var drawerOptions = <Widget>[];

    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      drawerOptions.add(new Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              i == global.selected_index
                  ? Color(0xFF35B9C5)
                  : Colors.transparent,
              i == global.selected_index
                  ? Color(0xFF348CB4)
                  : Colors.transparent,
            ],
          ),
        ),
        child: new ListTile(
          leading: ImageIcon(
            AssetImage(d.path),
            color: i == global.selected_index
                ? Color(0xFFFFFFFF)
                : Color(0x55FFFFFF),
            size: d.size,
          ),
          title: Text(
            d.title,
            style: TextStyle(
              fontSize: 16,
              color: i == global.selected_index
                  ? Color(0xFFFFFFFF)
                  : Color(0x55FFFFFF),
            ),
          ),
          selected: i == global.selected_index,
          onTap: () => _onSelectItem(i),
        ),
      ));
    }

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.drawerItems[global.selected_index].title),
        centerTitle: true,
        elevation:
              global.selected_index == 4 || global.selected_index == 5 ? 4 : 0,            
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
      drawer: new Drawer(
        child: Container(
          color: Color(0xFF505050),
          child: new Column(
            children: <Widget>[
              DrawerHeader(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 6,
                      child: Container(
                        alignment: AlignmentDirectional(-1.0, 0.0),
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              ///
                              /// LABEL NOMBRE
                              ///
                              Padding(
                                padding: EdgeInsets.only(bottom: 6),
                                child: Text(                                  
                                  global.nombre_user +
                                      " " +
                                      global.apellidos_user,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Color(0xFF059696),
                                  ),
                                ),
                              ),

                              ///
                              /// LABEL CERRAR SESIÓN
                              ///
                              InkWell(
                                child: GestureDetector(
                                  onTap: () {
                                    db.DBManager.instance.deleteAllRegistros();
                                    print("Cerrar sesión");
                                    global.token = "";
                                    global.recovery_token = "";
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => LoginPage()));
                                  },
                                  child: Text(
                                    "Cerrar sesión",
                                    style: TextStyle(
                                      color: Color(0xFF059696),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    ///
                    /// FOTO
                    ///
                    Expanded(
                      flex: 4,
                      child: GestureDetector(
                        onTap: () {
                          print("Back");
                          global.selected_index = 0;
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()));
                        },
                        child: Container(
                          alignment: AlignmentDirectional(1.0, 0.0),
                          child: Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Color(0xFF059696), width: 6),
                              shape: BoxShape.circle,
                              image: global.image_foto,
                                  //global.returnFileSelected(global.imageFile, global.imageFile.path),
                              /*
                            DecorationImage(
                              fit: BoxFit.contain,
                              image: AssetImage("assets/images/perfil.jpg"),
                            ),
                            */
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              new Column(children: drawerOptions)
            ],
          ),
        ),
      ),
      body: _getDrawerItemWidget(global.selected_index),
    );
  }
}
