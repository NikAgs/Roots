import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'CategoriesBar.dart';
import 'KidCardGrid.dart';
import 'AccountDrawer.dart';
import 'Menus.dart';

class CheckinPage extends StatefulWidget {
  final DateTime _dt;

  CheckinPage(this._dt);

  @override
  _CheckinPageState createState() => new _CheckinPageState(_dt);
}

class _CheckinPageState extends State<CheckinPage> {
  final DateTime _dt;

  String _currCategory = 'all';

  _CheckinPageState(this._dt);

  void _updateCategory(String update) {
    setState(() => this._currCategory = update);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        drawer: new AccountDrawer(),
        appBar: new AppBar(
            centerTitle: true,
            title: new Text(new DateFormat.MMMMEEEEd('en_US').format(_dt)),
            actions: <Widget>[
              new IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => print('you pressed the search button'),
                  tooltip: 'Search'),
              checkinDayPopup(true), //TODO: Create State for this
            ]),
        body: new ListView(
            padding: new EdgeInsets.only(top: 35.0),
            children: <Widget>[
              new CategoriesBar(_currCategory, _updateCategory),
              new Padding(padding: new EdgeInsets.only(bottom: 20.0)),
              _buildKidCardGrid()
            ]));
  }

  Widget _buildKidCardGrid() {
    String date = new DateFormat.yMMMMd('en_US').format(_dt);
    return new StreamBuilder<DocumentSnapshot>(
      stream:
          Firestore.instance.collection('calendar').document(date).snapshots,
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData ||
            snapshot.connectionState == ConnectionState.waiting)
          return const Text(''); // Blank Loading Page
        print(snapshot.data.data);
        List<KidCard> kids = new List();
        snapshot.data.data.forEach((id, kid) {
          if (_currCategory == 'all' || kid['school'] == _currCategory) {
            kids.add(new KidCard(id, date, kid['name'], kid['school'],
                kid['grade'], kid['checkinStatus']));
          }
        });
        // DEBUG: print(kids.toString());
        kids.sort((a, b) => a.name.compareTo(b.name));
        return new KidCardGrid(kids);
      },
    );
  }
}
