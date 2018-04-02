import 'package:flutter/material.dart';

class KidGrid extends StatelessWidget {
  final List<Widget> kids;
  KidGrid(this.kids);

  @override
  Widget build(BuildContext context) {
    return new Wrap(
        alignment: WrapAlignment.center,
        direction: Axis.horizontal,
        children: this.kids);
  }
}

class Kid extends StatefulWidget {
  final String _name;
  final bool _isCheckedIn;
  final String _school;

  String get school => this._school;
  String get name => this._name;

  Kid(this._name, this._school, this._isCheckedIn);

  @override
  String toString({DiagnosticLevel minLevel: DiagnosticLevel.debug}) =>
      '$_name' + ' ' + '$_school';

  @override
  State createState() => new KidState(_name, _isCheckedIn);
}

class KidState extends State<Kid> {
  String _name;
  bool _isCheckedIn;

  KidState(this._name, this._isCheckedIn);

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
                  onChanged: (bool newValue) {
                    setState(() {
                      _isCheckedIn = newValue;
                    });
                  },
                )
              ]),
        ));
  }
}
