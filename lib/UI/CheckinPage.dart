import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'dart:async';

import '../Database/Initializers.dart';

import 'CategoriesBar.dart';
import 'KidCardGrid.dart';
import 'AccountDrawer.dart';
import 'Menus.dart';

class CheckinPage extends StatefulWidget {
  final DateTime _dt;
  final bool _pickups;

  CheckinPage(this._dt, this._pickups);

  @override
  _CheckinPageState createState() => new _CheckinPageState(_dt, _pickups);
}

class _CheckinPageState extends State<CheckinPage> {
  final DateTime _dt;
  bool _pickups;

  String _currCategory = 'all';

  _CheckinPageState(this._dt, this._pickups);

  void _updateCategory(String update) {
    setState(() => this._currCategory = update);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        drawer: new AccountDrawer(),
        appBar: new AppBar(
            backgroundColor: _pickups ? null : Colors.red,
            centerTitle: true,
            title: new Text(new DateFormat.MMMMEEEEd('en_US').format(_dt)),
            actions: <Widget>[
              new IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => print('you pressed the search button'),
                  tooltip: 'Search'),
              checkinDayPopup(_pickups, _callPickupsCallback),
            ]),
        body: new RefreshIndicator(
            onRefresh: _callRefreshCallback,
            child: new ListView(
                padding: new EdgeInsets.only(top: 35.0),
                children: _pickups
                    ? <Widget>[
                        new CategoriesBar(_currCategory, _updateCategory),
                        new Padding(padding: new EdgeInsets.only(bottom: 20.0)),
                        _buildKidCardGrid()
                      ]
                    : <Widget>[
                        new Padding(padding: new EdgeInsets.only(top: 25.0)),
                        new Center(
                            child: new Text("Today is a No-Pickup day",
                                style: new TextStyle(
                                    fontSize: 20.0, color: Colors.black54)))
                      ])));
  }

  Future<Null> _callRefreshCallback() async {
    initializeToday(_dt);
  }

  void _callPickupsCallback(bool pickups) {
    setState(() => _pickups = pickups);
    Firestore.instance
        .collection('calendar')
        .document(new DateFormat.yMMMMd('en_US').format(_dt))
        .updateData({'pickupDay': pickups});
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
