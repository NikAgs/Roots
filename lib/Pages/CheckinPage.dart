import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import 'dart:async';

import '../Database/Initializers.dart';

import '../UI/CategoriesBar.dart';
import '../UI/KidCardGrid.dart';
import '../UI/AccountDrawer.dart';
import '../UI/Menus.dart';

class CheckinPage extends StatefulWidget {
  final DateTime _dt;
  final Map _permissions;

  CheckinPage(this._dt, this._permissions);

  @override
  _CheckinPageState createState() => new _CheckinPageState(_dt, _permissions);
}

class _CheckinPageState extends State<CheckinPage> {
  final DateTime _dt;

  Map _permissions; // {calendarAccess -> T/F, canEditKids -> T/F, canEditToday -> T/F}
  bool _canEditToday;
  bool _pickups = true;
  String _currCategory = 'all';
  StreamSubscription<QuerySnapshot> _listener;

  _CheckinPageState(this._dt, this._permissions) {
    if (new DateFormat.yMMMMd('en_US').format(DateTime.now()) ==
        new DateFormat.yMMMMd('en_US').format(_dt)) {
      _canEditToday = _permissions['canEditToday'];
    } else {
      _canEditToday = _permissions['calendarAccess'];
    }
  }

  @override
  void initState() {
    super.initState();
    initializeToday(_dt);
    _listener = Firestore.instance
        .collection('calendar')
        .document('exceptions')
        .getCollection('noPickupDays')
        .snapshots
        .listen((QuerySnapshot doc) {
      if (doc != null) {
        setState(() {
          _pickups = !(doc.documents.where((DocumentSnapshot doc) {
                return doc.documentID ==
                    new DateFormat.yMMMMd('en_US').format(_dt);
              }).length >=
              1);
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
        drawer: new AccountDrawer(_permissions),
        appBar: new AppBar(
            backgroundColor: _pickups ? null : Colors.red,
            centerTitle: true,
            title: new Text(new DateFormat.MMMMEEEEd('en_US').format(_dt)),
            actions: <Widget>[
              /*
              new IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => print('you pressed the search button'),
                  tooltip: 'Search'),
              */
              _canEditToday
                  ? checkinDayPopup(_pickups, _callPickupsCallback)
                  : null,
            ].where((Object o) => o != null).toList()),
        body: new RefreshIndicator(
            onRefresh: _callRefreshCallback,
            child: new ListView(
                padding: new EdgeInsets.only(top: 35.0),
                children: _pickups
                    ? <Widget>[
                        _canEditToday
                            ? new CategoriesBar(_currCategory, _updateCategory)
                            : null,
                        new Padding(padding: new EdgeInsets.only(bottom: 20.0)),
                        _buildKidCardGrid()
                      ].where((Object o) => o != null).toList()
                    : <Widget>[
                        new Padding(padding: new EdgeInsets.only(top: 25.0)),
                        new Center(
                            child: new Text("Today is a No-Pickup day",
                                style: new TextStyle(
                                    fontSize: 20.0, color: Colors.black54)))
                      ])));
  }

  void _updateCategory(String update) {
    setState(() => this._currCategory = update);
  }

  Future<Null> _callRefreshCallback() async {
    initializeToday(_dt);
  }

  void _callPickupsCallback(bool pickups) {
    DocumentReference ref = Firestore.instance
        .collection('calendar')
        .document('exceptions')
        .getCollection('noPickupDays')
        .document(new DateFormat.yMMMMd('en_US').format(_dt));
    if (pickups)
      ref.delete();
    else
      ref.setData({});
  }

  Widget _buildKidCardGrid() {
    String date = new DateFormat.yMMMMd('en_US').format(_dt);
    return new StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('calendar')
          .document(date)
          .getCollection('checkins')
          .snapshots,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData ||
            snapshot.connectionState == ConnectionState.waiting)
          return const Text(''); // Blank Loading Page
        List<KidCard> kids = new List();
        snapshot.data.documents.forEach((DocumentSnapshot kid) {
          if (_currCategory == 'all' || kid.data['school'] == _currCategory) {
            kids.add(new KidCard(
                kid.documentID,
                date,
                kid.data['name'],
                kid.data['school'],
                kid.data['grade'],
                kid.data['checkinStatus']));
          }
        });
        kids.sort((a, b) => a.name.compareTo(b.name));
        return new KidCardGrid(kids);
      },
    );
  }
}
