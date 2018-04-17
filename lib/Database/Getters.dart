import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<List<DocumentSnapshot>> getKids() async {
  return (await Firestore.instance.collection('kids').getDocuments()).documents;
}

Future<DocumentSnapshot> getKidDay(String id, String date) async {
  return Firestore.instance
      .collection('calendar')
      .document(date)
      .getCollection('checkins')
      .document(id)
      .get();
}

Future<Map> getPermissions() async {
  FirebaseUser user = await FirebaseAuth.instance.currentUser();
  return (await Firestore.instance.collection('authenticatedUsers').document(user.uid).get())
      .data;
}
