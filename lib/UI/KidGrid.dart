import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  final bool _isCheckedIn;
  final String _school;

  String get school => this._school;
  String get name => this._name;

  Kid(this._id, this._name, this._school, this._isCheckedIn);

  @override
  String toString({DiagnosticLevel minLevel: DiagnosticLevel.debug}) =>
      '$_name' + ' : ' + '$_school';

  @override
  Widget build(BuildContext context) {
    return new Container(
        width: 350.0,
        padding: new EdgeInsets.only(left: 25.0, right: 25.0, top: 20.0),
        child: new Card(
          color: _isCheckedIn ? new Color(0xFFCEECF5) : null,
          child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Container(
                    padding: new EdgeInsets.only(left: 25.0, right: 25.0),
                    child: new Text("$_name")),
                new Switch(
                    value: _isCheckedIn,
                    onChanged: (bool value) {
                      Firestore.instance
                          .collection('Kids')
                          .document(_id)
                          .setData({
                        'isCheckedIn': value,
                        'name': _name,
                        'school': _school
                      });
                    })
              ]),
        ));
  }
}
