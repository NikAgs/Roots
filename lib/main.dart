import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'dart:async';

import 'UI/CheckinPage.dart';

void main() async {
  DateTime now = DateTime.now();

  await initializeToday(now, await getKids());

  runApp(new MaterialApp(title: 'Roots For Kids', home: new CheckinPage(now)));
}

Future<List<DocumentSnapshot>> getKids() async {
  return (await Firestore.instance.collection('kids').getDocuments()).documents;
}

// TODO: Modify to also just modify checkinDay data if checkinDay already exists
Future<void> initializeToday(DateTime dt, List<DocumentSnapshot> kids) async {
  DocumentSnapshot day = await checkinDay(dt);
  if (day == null || !day.exists) {
    kids.forEach((DocumentSnapshot kid) {
      Firestore.instance
          .collection('calendar')
          .document(new DateFormat.yMMMMd('en_US').format(dt))
          .setData({
        kid.documentID: {
          'name': kid['name'],
          'school': kid['school'],
          'grade': 'K',
          'checkinStatus': [false, false, false, false]
        }
      }, SetOptions.merge);
    });
  }
}

Future<DocumentSnapshot> checkinDay(DateTime dt) async {
  return Firestore.instance
      .collection('calendar')
      .document(new DateFormat.yMMMMd('en_US').format(dt))
      .get();
}
