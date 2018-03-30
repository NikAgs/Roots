import 'dart:async';

import 'package:flutter/material.dart';
import 'UI/CategoriesBar.dart';
import 'UI/KidGrid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(new MaterialApp(title: 'Firestore Example', home: new MyHomePage()));
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _currCategory = 'all';

  void updateCategory(String update) {
    setState(() => this._currCategory = update);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: const Text('Wed, Mar 28'),
        ),
        body: new StreamBuilder<QuerySnapshot>(
          stream: _currCategory == 'all'
              ? Firestore.instance.collection('Kids').snapshots
              : Firestore.instance
                  .collection('Kids')
                  .where('school', isEqualTo: '$_currCategory')
                  .snapshots,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) return const Text('Loading...');
            return new ListView(
                padding: new EdgeInsets.only(top: 35.0),
                children: <Widget>[
                  new CategoriesBar(_currCategory, updateCategory),
                  new Padding(padding: new EdgeInsets.only(bottom: 20.0)),
                  new KidGrid(
                      snapshot.data.documents.map((DocumentSnapshot document) {
                    return new Kid(document['name'], document['school'],
                        document['isCheckedIn']);
                  }).toList())
                ]);
          },
        ));
  }
}
