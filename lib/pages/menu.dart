import 'package:flutter/material.dart';
import 'plan.dart';
import 'progreso.dart';
import 'agenda.dart';
import 'recetas.dart';
import 'restaurantes.dart';
import 'nutriochat.dart';

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
  int _selectedDrawerIndex = 0;

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return new PlanPage();
      case 1:
        return new ProgresoPage();
      case 2:
        return new AgendaPage();
      case 3:
        return new RecetasPage();
      case 4:
        return new RestaurantesPage();
      case 5:
        return new NutriochatPage();

      default:
        return new Text("Error");
    }
  }

  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
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
              i == _selectedDrawerIndex
                  ? Color(0xFF35B9C5)
                  : Colors.transparent,
              i == _selectedDrawerIndex
                  ? Color(0xFF348CB4)
                  : Colors.transparent,
            ],
          ),
        ),
        child: new ListTile(
          leading: ImageIcon(
            AssetImage(d.path),
            color: i == _selectedDrawerIndex
                ? Color(0xFFFFFFFF)
                : Color(0x55FFFFFF),
            size: d.size,
          ),
          title: Text(
            d.title,
            style: TextStyle(
              fontSize: 16,
              color: i == _selectedDrawerIndex
                  ? Color(0xFFFFFFFF)
                  : Color(0x55FFFFFF),
            ),
          ),
          selected: i == _selectedDrawerIndex,
          onTap: () => _onSelectItem(i),
        ),
      ));
    }

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.drawerItems[_selectedDrawerIndex].title),
        centerTitle: true,
        elevation: _selectedDrawerIndex == 1 || _selectedDrawerIndex == 2 ? 0 : 4,
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
                              Padding(
                                padding: EdgeInsets.only(bottom: 6),
                                child: Text(
                                  "Sasha Sokol",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Color(0xFF059696),
                                  ),
                                ),
                              ),
                              InkWell(
                                child: Text(
                                  "Cerrar sesión",
                                  style: TextStyle(
                                    color: Color(0xFF059696),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Container(
                        alignment: AlignmentDirectional(1.0, 0.0),
                        child: Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            border:
                            Border.all(color: Color(0xFF059696), width: 6),
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.contain,
                              image: AssetImage("assets/images/perfil.jpg"),
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
      body: _getDrawerItemWidget(_selectedDrawerIndex),
    );
  }
}
