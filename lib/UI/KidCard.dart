import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mailer/mailer.dart';

import 'dart:async';

import 'Menus.dart';
import '../email.dart';
import '../Database/Getters.dart';

class KidCard extends StatefulWidget {
  final String _id;
  final String _date;
  final String _name;
  final String _school;
  final String _grade;
  final List
      _checkinStatus; // [0] -> at school, [1] -> at van, [2] -> at center, [3] absent?

  String get school => this._school;
  String get grade => this._grade;
  String get name => this._name;

  KidCard(this._id, this._date, this._name, this._school, this._grade,
      this._checkinStatus)
      : super(key: new Key(_id));

  @override
  String toString({DiagnosticLevel minLevel: DiagnosticLevel.debug}) =>
      '$_name' + ' : ' + '$_school';

  @override
  _KidCardState createState() =>
      new _KidCardState(_id, _date, _name, _school, _grade, _checkinStatus);
}

class _KidCardState extends State<KidCard> {
  final String _id;
  final String _date;
  final String _name;
  final String _school;
  final String _grade;

  List _checkinStatus; // [0] -> at school, [1] -> at van, [2] -> at center

  bool _noPickup = false, _dropoff = false; // default values

  StreamSubscription<QuerySnapshot> _exceptionListener;
  StreamSubscription<DocumentSnapshot> _checkinListener;

  _KidCardState(this._id, this._date, this._name, this._school, this._grade,
      this._checkinStatus);

  @override
  void initState() {
    super.initState();
    _exceptionListener = Firestore.instance
        .collection('calendar')
        .document('exceptions')
        .collection('absences')
        .document(_id)
        .collection('dates')
        .snapshots
        .listen((QuerySnapshot doc) {
      if (doc != null) {
        setState(() {
          _noPickup = !(doc.documents.where((DocumentSnapshot doc) {
                return doc.documentID == _date && doc.data['noPickup'] == true;
              }).length <
              1);
          _dropoff = !(doc.documents.where((DocumentSnapshot doc) {
                return doc.documentID == _date && doc.data['dropoff'] == true;
              }).length <
              1);
        });
      }
    });

    _checkinListener = Firestore.instance
        .collection('calendar')
        .document(_date)
        .collection('checkins')
        .document(_id)
        .snapshots
        .listen((DocumentSnapshot snap) {
      if (snap != null) {
        setState(() {
          _checkinStatus = snap.data['checkinStatus'];
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _exceptionListener.cancel();
    _checkinListener.cancel();
  }

  void _updateCheckinStatus(bool value, int checkinIndex) {
    List copy = _checkinStatus;
    // if (_noPickup || _dropoff) return;
    // if (checkinIndex == 1 && copy[0] == false) return;
    // if (checkinIndex == 2 && (copy[1] == false || copy[0] == false)) return;

    copy[checkinIndex] = value;
    Firestore.instance
        .collection('calendar')
        .document(_date)
        .collection('checkins')
        .document(_id)
        .updateData({'checkinStatus': copy});
  }

  void _updateException(String exception, bool value) {
    DocumentReference ref = Firestore.instance
        .collection('calendar')
        .document('exceptions')
        .collection('absences')
        .document(_id)
        .collection('dates')
        .document(_date);

    ref.setData({exception: value}, SetOptions.merge);
  }

  void _sendEmail() async {
    bool send = true;

    Scaffold.of(context).showSnackBar(new SnackBar(
          content: new Text('Sending Email(s):       ' + _name),
          duration: new Duration(seconds: 5),
          action: new SnackBarAction(
              label: 'CANCEL',
              onPressed: () {
                Scaffold.of(context).showSnackBar(
                    new SnackBar(content: new Text('No Email(s) sent')));
                send = false;
              }),
        ));

    await (new Future.delayed(const Duration(seconds: 5))); //recommend

    if (send) {
      Map<String, dynamic> credentials = emailInfo[0].data;
      Map<String, dynamic> message = emailInfo[1].data;

      var options = new GmailSmtpOptions();
      options.username = credentials["username"];
      options.password = credentials["password"];

      var emailTransport = new SmtpTransport(options);

      // Create our mail/envelope.
      var envelope = new Envelope();
      envelope.from = credentials["address"];
      getParentEmails(_id).then((emails) {
        emails.forEach((email) {
          envelope.recipients.add(email);
        });
      });

      envelope.subject = message["subject"].replaceAll("___", _name);
      envelope.text = message["text"].replaceAll("___", _name);

      // Email it.
      emailTransport
          .send(envelope)
          .then((envelope) => print('Email sent!'))
          .catchError((e) => print('Error occurred: $e'));
    }
  }

  Widget _buildLine(bool visible) {
    return new Container(
      width: 30.0,
      height: visible ? 1.0 : 0.0,
      color: Colors.grey.shade400,
    );
  }

  Color _colorChooser() {
    if (_noPickup) return new Color(0xFFFFB3B3);
    if (_dropoff) return new Color(0xFFb3d9ff);
    if (_checkinStatus[2]) return new Color(0xFF5DEFA8);
    if (_checkinStatus[1]) return new Color(0xFFA2F6CD);
    if (_checkinStatus[0]) return new Color(0xFFD0FBE6);
    return null;
  }

  Widget _buildIconRow() {
    if (_dropoff) {
      return new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new IconCheckBox(_checkinStatus[2], 2, _updateCheckinStatus)
          ]);
    }

    if (_noPickup) {
      return new SizedBox(height: 48.0);
    }
    return new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          new IconCheckBox(_checkinStatus[0], 0, _updateCheckinStatus),
          _buildLine(_checkinStatus[0] && _checkinStatus[1]),
          new IconCheckBox(_checkinStatus[1], 1, _updateCheckinStatus),
          _buildLine(_checkinStatus[1] && _checkinStatus[2]),
          new IconCheckBox(_checkinStatus[2], 2, _updateCheckinStatus),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        width: 380.0,
        padding: new EdgeInsets.all(15.0),
        child: new Card(
            color: _colorChooser(),
            child: new Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new Padding(
                      padding: new EdgeInsets.only(top: 10.0),
                      child: new Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            new Padding(
                                padding: new EdgeInsets.only(left: 20.0)),
                            new Expanded(
                              child: new Text("$_name",
                                  overflow: TextOverflow.ellipsis,
                                  style: new TextStyle(
                                      fontSize: 23.0,
                                      color: new Color(0xFF595959))),
                            ),
                            new Padding(
                                padding: new EdgeInsets.only(left: 5.0),
                                child: new Text("$_grade",
                                    style: new TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.black54))),
                            kidItem(_noPickup, _dropoff, _updateException,
                                _sendEmail)
                          ])),
                  _buildIconRow()
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
            ? new Icon(Icons.location_city, color: new Color(0xFF0086b3))
            : new Icon(Icons.location_city, color: new Color(0xFF737373));
      case 1:
        return _isChecked
            ? new Icon(Icons.airport_shuttle, color: new Color(0xFF0086b3))
            : new Icon(Icons.airport_shuttle, color: new Color(0xFF737373));
      case 2:
        return _isChecked
            ? new Icon(Icons.store, color: new Color(0xFF0086b3))
            : new Icon(Icons.store, color: new Color(0xFF737373));
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
