import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
import 'package:nutripuntos_app/pages/home.dart';
import 'newmenu.dart' as newmenu;
import '../globals.dart' as globals;

class PDFMaterialPage extends StatefulWidget {
  @override
  PDFMaterialPageState createState() => new PDFMaterialPageState();
}

class PDFMaterialPageState extends State<PDFMaterialPage> {
  bool isLoading = false;
  bool isInit = true;
  PDFDocument document = null;

  loadFromURL() async {
    await PDFDocument.fromURL(globals.server + globals.url_pdf).then((result) {
      print("Result: " + result.toString());
      setState(() {
        globals.pdf_loaded = true;
        document = result;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      globals.pdf_loaded = false;
      isLoading = false;
      isInit = true;      
      if (globals.pdf_loaded == false) loadFromURL();
    });    
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //drawer: new newmenu.menu(7),
      appBar: AppBar(
        elevation: 4,
        title: Text("Material de apoyo"),
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
        child: document != null
            ? PDFViewer(
                document: document,
                showPicker: false,
                showNavigation: true,
              )
            : Offstage(),
      ),
    );
  }
}
