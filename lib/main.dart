import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'UI/CheckinPage.dart';
import 'Database/Initializers.dart';

void main() async {
  DateTime now = DateTime.now();

  await initializeToday(now);

  runApp(new MaterialApp(
      title: 'Roots For Kids',
      home: new CheckinPage(
          now, await isPickupDay(new DateFormat.yMMMMd('en_US').format(now)))));
}
