import 'package:flutter/material.dart';

enum CheckinDayItem { pickups, noPickups }
enum KidItem { markAbsent, viewProfile }

PopupMenuButton<CheckinDayItem> checkinDayPopup(bool pickups) {
  return new PopupMenuButton<CheckinDayItem>(
    icon: new Icon(Icons.more_vert),
    onSelected: (CheckinDayItem value) {},
    itemBuilder: (BuildContext context) => <PopupMenuItem<CheckinDayItem>>[
          new PopupMenuItem<CheckinDayItem>(
            value: pickups ? CheckinDayItem.pickups : CheckinDayItem.noPickups,
            child: pickups
                ? const ListTile(
                    leading: const Icon(Icons.cancel),
                    title: const Text('Cancel pickups'))
                : const ListTile(
                    leading: const Icon(Icons.check_box),
                    title: const Text('Resume pickups')),
          ),
        ],
  );
}

PopupMenuButton<KidItem> kidItem() {
  return new PopupMenuButton<KidItem>(
    icon: new Icon(Icons.more_vert, color: Colors.black45, size: 20.0),
    onSelected: (KidItem value) {},
    itemBuilder: (BuildContext context) => <PopupMenuItem<KidItem>>[
          new PopupMenuItem<KidItem>(
              value: KidItem.markAbsent,
              child: const ListTile(
                  leading: const Icon(Icons.block),
                  title: const Text('Mark Absent'))),
          new PopupMenuItem<KidItem>(
            value: KidItem.viewProfile,
            child: const ListTile(
                leading: const Icon(Icons.account_circle),
                title: const Text('View Profile')),
          )
        ],
  );
}
