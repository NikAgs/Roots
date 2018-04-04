import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'Menus.dart';

class KidGrid extends StatelessWidget {
  final List<Kid> kids;
  KidGrid(this.kids);

  @override
  Widget build(BuildContext context) {
    return new Wrap(
        alignment: WrapAlignment.center,
        direction: Axis.horizontal,
        children: this.kids);
  }
}

class Kid extends StatelessWidget {
  final String _id;
  final String _name;
  final String _school;
  final List _checkinStatus;

  String get school => this._school;
  String get name => this._name;

  Kid(this._id, this._name, this._school, this._checkinStatus);

  void _updateCheckinStatus(bool value, int checkinIndex) {
    List copy = _checkinStatus;
    copy[checkinIndex] = value;
    print(copy);
    Firestore.instance
        .collection('kids')
        .document(_id)
        .setData({'checkinStatus': copy, 'name': _name, 'school': _school});
  }

  @override
  String toString({DiagnosticLevel minLevel: DiagnosticLevel.debug}) =>
      '$_name' + ' : ' + '$_school';

  @override
  Widget build(BuildContext context) {
    return new Container(
        width: 350.0,
        padding: new EdgeInsets.only(left: 25.0, right: 25.0, top: 20.0),
        child: new Card(
            child:
                new Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Container(
                    padding:
                        new EdgeInsets.only(left: 25.0, right: 25.0, top: 10.0),
                    child: new Text("$_name",
                        style: new TextStyle(fontSize: 18.0))),
                kidItem()
              ]),
          new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new IconCheckBox(_checkinStatus[0], 0, _updateCheckinStatus),
                new IconCheckBox(_checkinStatus[1], 1, _updateCheckinStatus),
                new IconCheckBox(_checkinStatus[2], 2, _updateCheckinStatus),
              ])
        ])));
  }
}

class IconCheckBox extends StatelessWidget {
  final bool _isChecked;
  final int _checkinIndex;
  final _callback;

  Icon getIcon(int index) {
    switch (index) {
      case 0:
        return new Icon(Icons.location_city, color: Colors.black54);
      case 1:
        return new Icon(Icons.airport_shuttle, color: Colors.black54);
      case 2:
        return new Icon(Icons.home, color: Colors.black54);
    }
    return new Icon(Icons.not_interested);
  }

  IconCheckBox(this._isChecked, this._checkinIndex, this._callback);

  void _callCallback(bool value) {
    _callback(value, _checkinIndex);
  }

  @override
  Widget build(BuildContext context) {
    return new Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
      getIcon(_checkinIndex),
      new Checkbox(
        value: _isChecked,
        onChanged: (bool value) {
          _callCallback(value);
        },
      )
    ]);
  }
}
