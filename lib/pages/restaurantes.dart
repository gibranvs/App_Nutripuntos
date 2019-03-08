import 'package:flutter/material.dart';

class RestaurantesPage extends StatefulWidget {
  @override
  _RestaurantesPageState createState() => new _RestaurantesPageState();
}

class _RestaurantesPageState extends State<RestaurantesPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Restaurantes'),
      ),
    );
  }
}