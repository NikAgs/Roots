import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> updateKidInfo(String id, List<String> values) async {
  // values[0] -> name, values[1] -> school, values[2] -> grade
  Firestore.instance
      .collection('kids')
      .document(id)
      .setData({'name': values[0], 'school': values[1], 'grade': values[2]});
}

Future<void> deleteKid(String id) async {
  Firestore.instance.collection('kids').document(id).delete();
}

Future<void> addKid(List<String> values) async {
  // values[0] -> name, values[1] -> school, values[2] -> grade
  Firestore.instance
      .collection('kids')
      .add({'name': values[0], 'school': values[1], 'grade': values[2]});
}
