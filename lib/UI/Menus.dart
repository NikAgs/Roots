import 'package:flutter/material.dart';

enum CheckinDayItem { pickups, noPickups }
enum KidItem {
  markNoPickup,
  markYesPickup,
  markYesDropoff,
  markNoDropoff,
  viewProfile
}

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

PopupMenuButton<KidItem> kidItem(
    bool noPickup, bool dropoff, dynamic callback) {
  return new PopupMenuButton<KidItem>(
      icon: new Icon(Icons.more_vert, color: Colors.black45, size: 24.0),
      onSelected: (KidItem value) {
        if (value == KidItem.markNoPickup || value == KidItem.markYesPickup) {
          callback('noPickup', !noPickup);
        } else if (value == KidItem.markYesDropoff ||
            value == KidItem.markNoDropoff) {
          callback('dropoff', !dropoff);
        } else {
          // TODO: this
          print('you clicked view profile');
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuItem<KidItem>>[
            dropoff
                ? null
                : new PopupMenuItem<KidItem>(
                    value:
                        noPickup ? KidItem.markYesPickup : KidItem.markNoPickup,
                    child: noPickup
                        ? const ListTile(
                            leading: const Icon(Icons.check_circle),
                            title: const Text('Resume Pickup'))
                        : const ListTile(
                            leading: const Icon(Icons.cancel),
                            title: const Text('Cancel Pickup'))),
            noPickup
                ? null
                : new PopupMenuItem<KidItem>(
                    value: dropoff
                        ? KidItem.markNoDropoff
                        : KidItem.markYesDropoff,
                    child: dropoff
                        ? const ListTile(
                            leading:
                                const Icon(Icons.transfer_within_a_station),
                            title: const Text('Unmark Dropoff'))
                        : const ListTile(
                            leading:
                                const Icon(Icons.transfer_within_a_station),
                            title: const Text('Mark Dropoff'))),
            new PopupMenuItem<KidItem>(
              value: KidItem.viewProfile,
              child: const ListTile(
                  leading: const Icon(Icons.account_circle),
                  title: const Text('View Profile')),
            )
          ].where((Object o) => o != null).toList());
}
