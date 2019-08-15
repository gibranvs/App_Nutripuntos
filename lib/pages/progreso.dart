import 'package:flutter/material.dart';

void main() {
  runApp(ProgresoPage());
}

class ProgresoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: TabBar(
              tabs: [
                Tab(text: "Peso",),
                Tab(text: "Historial\nde grasa",),
                Tab(text: "Metas",),
              ],
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
          body: TabBarView(
            children: [
              Container(
                decoration: new BoxDecoration(
                  color: const Color(0x00FFCC00),
                  image: new DecorationImage(
                    image: new AssetImage("assets/images/fondo.jpg"),
                    colorFilter: new ColorFilter.mode(
                        Colors.black.withOpacity(0.2), BlendMode.dstATop),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                  child: Image.asset("assets/images/gr_peso.png"),
                ),
              ),
              Container(
                decoration: new BoxDecoration(
                  color: const Color(0x00FFCC00),
                  image: new DecorationImage(
                    image: new AssetImage("assets/images/fondo.jpg"),
                    colorFilter: new ColorFilter.mode(
                        Colors.black.withOpacity(0.2), BlendMode.dstATop),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                  child: Image.asset("assets/images/gr_grasa.png"),
                ),
              ),
              Container(
                decoration: new BoxDecoration(
                  color: const Color(0x00FFCC00),
                  image: new DecorationImage(
                    image: new AssetImage("assets/images/fondo.jpg"),
                    colorFilter: new ColorFilter.mode(
                        Colors.black.withOpacity(0.2), BlendMode.dstATop),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                  child: Image.asset("assets/images/gr_metas.png"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void GetProgreso()
{
  
}