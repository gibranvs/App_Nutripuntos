import 'package:flutter/material.dart';

showMessageDialog(BuildContext context, _titulo, _texto) {
  // set up the buttons
  Widget continueButton = FlatButton(
    child: Text("OK"),
    onPressed: () {
      continue_press(context);      
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(_titulo),
    content: new Container(
      height: 40.0,
      width: MediaQuery.of(context).size.width * 0.9,
      alignment: Alignment.centerLeft,
      margin: new EdgeInsets.only(top: 0.0, left: 0.0),
      child: new Column(        
        children: <Widget>[
          Text(_texto),
        ],
      ),
    ),
    actions: [
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

void continue_press(_context)
{
  Navigator.of(_context, rootNavigator: true).pop('dialog');
}
