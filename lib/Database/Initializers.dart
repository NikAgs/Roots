import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'dart:async';

Future<List<DocumentSnapshot>> getKids() async {
  return (await Firestore.instance.collection('kids').getDocuments()).documents;
}

Future<DocumentSnapshot> getCheckinDay(String date) async {
  return Firestore.instance.collection('calendar').document(date).get();
}

Future<DocumentSnapshot> getExceptions() async {
  return Firestore.instance.collection('calendar').document('exceptions').get();
}

Future<bool> isPickupDay(String date) async {
  DocumentSnapshot day =
      await Firestore.instance.collection('calendar').document(date).get();
  return day.data['pickupDay'];
}

Future<DocumentSnapshot> getKidDay(String id, String date) async {
  return Firestore.instance
      .collection('calendar')
      .document(date)
      .getCollection('checkins')
      .document(id)
      .get();
}

/*
* Set checkin data for a given date by either updating it or writing it new
* Note: uses exceptions to determine absences/No-Pickup days
*/
Future<void> initializeToday(DateTime dt) async {
  Map<String, dynamic> exceptions = (await getExceptions()).data;
  List<DocumentSnapshot> kids = await getKids();
  String date = new DateFormat.yMMMMd('en_US').format(dt);
  DocumentSnapshot day = await getCheckinDay(date);

  await initializePickupStatus(date);

  kids.forEach((DocumentSnapshot kid) async {
    bool absent = exceptions.containsKey(kid.documentID) &&
        exceptions[kid.documentID].contains(date);

    if (day == null || !day.exists) {
      initializeCheckinStatus(date, kid, [false, false, false, absent]);
    } else {
      DocumentSnapshot kidDay = await getKidDay(kid.documentID, date);
      if (kidDay == null || !kidDay.exists) {
        initializeCheckinStatus(date, kid, [false, false, false, absent]);
      } else {
        List checkinStatus = kidDay.data['checkinStatus'];
        checkinStatus[3] = absent;
        initializeCheckinStatus(date, kid, checkinStatus);
      }
    }
  });
}

Future<void> initializePickupStatus(String date) async {
  Map exceptions = (await getExceptions()).data;
  DocumentSnapshot day = await getCheckinDay(date);
  bool pickups;
  if (day != null && day.exists && day.data['pickupDay'] != null) {
    pickups = day.data['pickupDay'];
  }

  // write over pickupDay value with exceptions
  if (exceptions['all'].contains(date)) {
    pickups = false;
  }

  Firestore.instance
      .collection('calendar')
      .document(date)
      .updateData({"pickupDay": pickups});
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
