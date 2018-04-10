import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'Menus.dart';

class KidCardGrid extends StatelessWidget {
  final List<KidCard> kids;
  KidCardGrid(this.kids);

  @override
  Widget build(BuildContext context) {
    return new Wrap(
        alignment: WrapAlignment.center,
        direction: Axis.horizontal,
        children: this.kids);
  }
}

class KidCard extends StatelessWidget {
  final String _id;
  final String _date;
  final String _name;
  final String _school;
  final String _grade;
  final List
      _checkinStatus; // [0] -> at school, [1] -> at van, [2] -> at center, [3] absent?

  String get school => this._school;
  String get name => this._name;

  KidCard(this._id, this._date, this._name, this._school, this._grade,
      this._checkinStatus);

  void _updateCheckinStatus(bool value, int checkinIndex) {
    List copy = _checkinStatus;
    copy[checkinIndex] = value;
    Firestore.instance
        .collection('calendar')
        .document(_date)
        .getCollection('checkins')
        .document(_id)
        .updateData({'checkinStatus': copy});
  }

  Widget _buildLine(bool visible) {
    return new Container(
      width: 30.0,
      height: visible ? 1.0 : 0.0,
      color: Colors.grey.shade400,
    );
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
            color: _checkinStatus[3] ? new Color(0xFFFFB3B3) : null,
            child:
                new Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Container(
                        padding: new EdgeInsets.only(left: 25.0, top: 10.0),
                        child: new Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              new Text("$_name",
                                  style: new TextStyle(
                                      fontSize: 18.0, color: Colors.black87)),
                              new Padding(
                                  padding: new EdgeInsets.only(left: 15.0)),
                              new Text("$_grade",
                                  style: new TextStyle(
                                      fontSize: 15.0, color: Colors.black54))
                            ])),
                    kidItem(_checkinStatus[3], _updateCheckinStatus)
                  ]),
              new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    new IconCheckBox(
                        _checkinStatus[0], 0, _updateCheckinStatus),
                    _buildLine(_checkinStatus[0] && _checkinStatus[1]),
                    new IconCheckBox(
                        _checkinStatus[1], 1, _updateCheckinStatus),
                    _buildLine(_checkinStatus[1] && _checkinStatus[2]),
                    new IconCheckBox(
                        _checkinStatus[2], 2, _updateCheckinStatus),
                  ])
            ])));
  }
}

class IconCheckBox extends StatelessWidget {
  final bool _isChecked;
  final int _checkinIndex;
  final _callback;

  IconCheckBox(this._isChecked, this._checkinIndex, this._callback);

  Icon getIcon(int index) {
    switch (index) {
      case 0:
        return _isChecked
            ? new Icon(Icons.location_city, color: Colors.blue[300])
            : new Icon(Icons.location_city, color: Colors.black45);
      case 1:
        return _isChecked
            ? new Icon(Icons.airport_shuttle, color: Colors.blue[300])
            : new Icon(Icons.airport_shuttle, color: Colors.black45);
      case 2:
        return _isChecked
            ? new Icon(Icons.store, color: Colors.blue[300])
            : new Icon(Icons.store, color: Colors.black45);
    }
    print("Invalid index");
    return null;
  }

  void _callCallback() {
    _callback(!_isChecked, _checkinIndex);
  }

  @override
  Widget build(BuildContext context) {
    return new IconButton(
        icon: getIcon(_checkinIndex), iconSize: 30.0, onPressed: _callCallback);
  }
}
