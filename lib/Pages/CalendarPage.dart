import 'package:flutter/material.dart';
import 'package:flutter_calendar/flutter_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'CheckinPage.dart';
import '../Database/Initializers.dart';
import '../UI/DatePicker.dart';

import 'dart:async';

class CalendarView extends StatefulWidget {
  final Map _permissions;

  CalendarView(this._permissions);

  @override
  _CalendarViewState createState() => new _CalendarViewState(_permissions);
}

class _CalendarViewState extends State<CalendarView> {
  DateTime _noPickupsFromDate = new DateTime.now();
  DateTime _noPickupsToDate = new DateTime.now();

  DateTime _absentFromDate = new DateTime.now();
  DateTime _absentToDate = new DateTime.now();

  String _absentKid;
  List<String> _kidNames = ['', '']; // loading default
  StreamSubscription<QuerySnapshot> _listener;

  Map _permissions;

  _CalendarViewState(this._permissions);

  @override
  void initState() {
    super.initState();
    _listener = Firestore.instance
        .collection('kids')
        .snapshots
        .listen((QuerySnapshot doc) {
      if (doc != null) {
        setState(() {
          _kidNames = doc.documents.map<String>((DocumentSnapshot doc) {
            return doc.data['name'];
          }).toList();
          _kidNames.sort();
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _listener.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Calendar'),
      ),
      body: new Container(
        margin: new EdgeInsets.symmetric(
          horizontal: 40.0,
          vertical: 50.0,
        ),
        child: new ListView(
          shrinkWrap: true,
          children: <Widget>[
            new Calendar(
              onDateSelected: (DateTime dt) async {
                await initializeToday(dt);
                Navigator.pushAndRemoveUntil(
                    context,
                    new MaterialPageRoute(
                        builder: (context) =>
                            new CheckinPage(dt, _permissions)),
                    (Route r) => !Navigator.canPop(context));
              },
            ),
            new Padding(padding: new EdgeInsets.only(top: 60.0)),
            cancelPickupsRow(),
            new Padding(padding: new EdgeInsets.only(top: 50.0)),
            markAbsentRow(),
          ],
        ),
      ),
    );
  }

  Widget cancelPickupsRow() {
    return new Wrap(alignment: WrapAlignment.center, children: <Widget>[
      new Padding(
        padding: new EdgeInsets.only(top: 20.0, right: 20.0),
        child: const Text('Cancel pickups from',
            style: const TextStyle(fontSize: 20.0)),
      ),
      datePicker(_noPickupsFromDate),
      new Padding(
        padding: new EdgeInsets.all(20.0),
        child: const Text('to', style: const TextStyle(fontSize: 20.0)),
      ),
      datePicker(_noPickupsToDate),
      new Padding(
        padding: new EdgeInsets.only(top: 10.0, left: 30.0),
        child: new RaisedButton(
            onPressed: () {
              // TODO
            },
            child: const Text('Cancel')),
      )
    ]);
  }

  Widget markAbsentRow() {
    return new Wrap(alignment: WrapAlignment.center, children: <Widget>[
      new Padding(
        padding: new EdgeInsets.only(top: 20.0, right: 20.0),
        child: const Text('Mark', style: const TextStyle(fontSize: 20.0)),
      ),
      new Padding(
        padding: new EdgeInsets.only(top: 5.0),
        child: new DropdownButton<String>(
            value: _absentKid,
            items: _kidNames.map((String value) {
              return new DropdownMenuItem<String>(
                value: value,
                child: new Text(value),
              );
            }).toList(),
            onChanged: (String name) {
              setState(() {
                _absentKid = name;
              });
            }),
      ),
      new Padding(
        padding: new EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
        child: const Text('as absent from ',
            style: const TextStyle(fontSize: 20.0)),
      ),
      datePicker(_absentFromDate),
      new Padding(
        padding: new EdgeInsets.all(20.0),
        child: const Text('to', style: const TextStyle(fontSize: 20.0)),
      ),
      datePicker(_absentToDate),
      new Padding(
        padding: new EdgeInsets.only(top: 10.0, left: 30.0),
        child: new RaisedButton(
            onPressed: () {
              // TODO
            },
            child: const Text('Mark')),
      )
    ]);
  }

  Widget datePicker(DateTime dt) {
    return new DateTimePicker(
      selectedDate: dt,
      selectDate: (DateTime date) {
        setState(() {
          dt = date;
        });
      },
    );
  }
}
