import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'dart:async';

/*
* If the checkinData does not exist for a given day, create it and put it in the database
* Else, modify today's or any future day's checkinData according to the current 'kids' collection
*/
Future<void> initializeToday(DateTime dt) async {
  List<DocumentSnapshot> kids = await getKids();
  String date = new DateFormat.yMMMMd('en_US').format(dt);

  kids.forEach((DocumentSnapshot kid) async {
    if (new DateFormat.yMMMMd('en_US').format(DateTime.now()) == date ||
        dt.isAfter(DateTime.now())) {
      DocumentSnapshot kidDay = await getKidDay(kid.documentID, date);
      if (kidDay == null || !kidDay.exists) {
        initializeCheckinStatus(
            date, kid, [false, false, false]); // default checkin values
      } else {
        initializeCheckinStatus(date, kid, kidDay.data['checkinStatus']);
      }
    }
  });
}

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

Future<void> initializeCheckinStatus(
    String date, DocumentSnapshot kid, List checkinStatus) async {
  Firestore.instance
      .collection('calendar')
      .document(date)
      .getCollection('checkins')
      .document(kid.documentID)
      .setData({
    'name': kid['name'],
    'school': kid['school'],
    'grade': 'K',
    'checkinStatus': checkinStatus
  });
}
