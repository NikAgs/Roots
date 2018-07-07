import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:intl/intl.dart';

import '../UI/KidCard.dart';

Future<List<DocumentSnapshot>> getKids() async {
  return (await Firestore.instance.collection('kids').getDocuments()).documents;
}

Future<DocumentSnapshot> getKidDay(String id, String date) async {
  return Firestore.instance
      .collection('calendar')
      .document(date)
      .collection('checkins')
      .document(id)
      .get();
}

Future<Map> getPermissions() async {
  FirebaseUser user = await FirebaseAuth.instance.currentUser();
  return (await Firestore.instance
          .collection('authenticatedUsers')
          .document(user.uid)
          .get())
      .data;
}

Future<List<KidCard>> getKidCards(DateTime dt) async {
  return (await Firestore.instance
          .collection('calendar')
          .document(new DateFormat.yMMMMd('en_US').format(dt))
          .collection('checkins')
          .getDocuments())
      .documents
      .map((DocumentSnapshot doc) {
    return new KidCard(
        doc.documentID,
        new DateFormat.yMMMMd('en_US').format(dt),
        doc.data['name'],
        doc.data['school'],
        doc.data['grade'],
        doc.data['checkinStatus']);
  }).toList();
}

Future<List<String>> getSchoolNames() async {
  return (await Firestore.instance.collection('schools').getDocuments())
      .documents
      .map((DocumentSnapshot snap) {
    return snap.documentID;
  }).toList();
}
