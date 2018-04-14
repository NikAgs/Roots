import 'package:flutter/material.dart';

enum CheckinDayItem { pickups, noPickups }
enum KidItem { markAbsent, markPresent, viewProfile }

PopupMenuButton<CheckinDayItem> checkinDayPopup(
    bool pickups, dynamic callback) {
  return new PopupMenuButton<CheckinDayItem>(
    icon: new Icon(Icons.more_vert),
    onSelected: (CheckinDayItem value) {
      callback(!pickups);
    },
    itemBuilder: (BuildContext context) => <PopupMenuItem<CheckinDayItem>>[
          new PopupMenuItem<CheckinDayItem>(
            value: pickups ? CheckinDayItem.pickups : CheckinDayItem.noPickups,
            child: pickups
                ? const ListTile(
                    leading: const Icon(Icons.block),
                    title: const Text('Cancel pickups'))
                : const ListTile(
                    leading: const Icon(Icons.done),
                    title: const Text('Resume pickups')),
          ),
        ],
  );
}

PopupMenuButton<KidItem> kidItem(bool present, dynamic callback) {
  return new PopupMenuButton<KidItem>(
    icon: new Icon(Icons.more_vert, color: Colors.black45, size: 20.0),
    onSelected: (KidItem value) {
      if (value == KidItem.markPresent || value == KidItem.markAbsent) {
        callback(!present);
      } else {
        // TODO: this
        print('you clicked view profile');
      }
    },
    itemBuilder: (BuildContext context) => <PopupMenuItem<KidItem>>[
          new PopupMenuItem<KidItem>(
              value: present ? KidItem.markAbsent : KidItem.markPresent,
              child: present
                  ? const ListTile(
                      leading: const Icon(Icons.cancel),
                      title: const Text('Mark Absent'))
                  : const ListTile(
                      leading: const Icon(Icons.check_circle),
                      title: const Text('Mark Present'))),
          new PopupMenuItem<KidItem>(
            value: KidItem.viewProfile,
            child: const ListTile(
                leading: const Icon(Icons.account_circle),
                title: const Text('View Profile')),
          )
        ],
  );
}
