import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

Future<void> setNoPickups(DateTime from, DateTime to) async {
  if (from.isAfter(to)) return null;

  DateTime temp = from;

  while (temp.isBefore(to)) {
    Firestore.instance
        .collection('calendar')
        .document('exceptions')
        .collection('noPickupDays')
        .document(new DateFormat.yMMMMd('en_US').format(temp))
        .setData({});

    temp = temp.add(new Duration(days: 1));
  }
}

Future<void> setAbsentDays(String id, DateTime from, DateTime to) async {
  if (from.isAfter(to)) return null;

  DateTime temp = from;

  while (temp.isBefore(to)) {
    Firestore.instance
        .collection('calendar')
        .document('exceptions')
        .collection('absences')
        .document(id)
        .collection('dates')
        .document(new DateFormat.yMMMMd('en_US').format(temp))
        .setData({'noPickup': true}, SetOptions.merge);

    temp = temp.add(new Duration(days: 1));
  }
}
