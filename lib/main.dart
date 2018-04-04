import 'package:flutter/material.dart';
import 'UI/CategoriesBar.dart';
import 'UI/KidGrid.dart';
import 'UI/AccountDrawer.dart';
import 'UI/Menus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(new MaterialApp(title: 'Roots For Kids', home: new MyHomePage()));
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _currCategory = 'all';
  bool _pickups = true;

  void _updateCategory(String update) {
    setState(() => this._currCategory = update);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        drawer: new AccountDrawer(),
        appBar: new AppBar(
            centerTitle: true,
            title: const Text('Wed, Mar 28'),
            actions: <Widget>[
              new IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => print('you pressed the search button'),
                  tooltip: 'Search'),
              checkinDayPopup(_pickups),
            ]),
        body: new StreamBuilder<QuerySnapshot>(
          stream: _currCategory == 'all'
              ? Firestore.instance.collection('kids').snapshots
              : Firestore.instance
                  .collection('kids')
                  .where('school', isEqualTo: '$_currCategory')
                  .snapshots,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData ||
                snapshot.connectionState == ConnectionState.waiting)
              return const Text(''); // Blank Loading Page
            List<Kid> kids =
                snapshot.data.documents.map((DocumentSnapshot document) {
              return new Kid(document.documentID, document['name'],
                  document['school'], document['checkinStatus']);
            }).toList();
            // DEBUG: print(kids.toString());
            kids.sort((a, b) => a.name.compareTo(b.name));
            return new ListView(
                padding: new EdgeInsets.only(top: 35.0),
                children: <Widget>[
                  new CategoriesBar(_currCategory, _updateCategory),
                  new Padding(padding: new EdgeInsets.only(bottom: 20.0)),
                  new KidGrid(kids)
                ]);
          },
        ));
  }
}
