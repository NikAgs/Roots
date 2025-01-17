import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Pages/CalendarPage.dart';
import '../Pages/LoginPage.dart';
import '../Pages/EditKids.dart';

import '../global.dart';

class AccountDrawer extends StatelessWidget {
 
  AccountDrawer();

  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: new Column(
        children: <Widget>[
          new DrawerHeader(
              padding: new EdgeInsets.only(bottom: 12.0),
              decoration: new BoxDecoration(color: Colors.blue),
              child: new Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    new Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        new CircleAvatar(
                            backgroundImage:
                                new AssetImage('images/' + userInfo['profileType']+ '.png'),
                            radius: 50.0),
                        new Padding(
                            padding: new EdgeInsets.symmetric(vertical: 1.5)),
                        new Text(userInfo['profileName'],
                            style: new TextStyle(color: Colors.white)),
                      ],
                    )
                  ])),
          userInfo['calendarAccess']
              ? new ListTile(
                  leading: const Icon(Icons.date_range),
                  title: new Text('Calendar'),
                  onTap: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new CalendarView()));
                  },
                )
              : null,
          userInfo['canEditKids']
              ? new ListTile(
                  leading: const Icon(Icons.mode_edit),
                  title: new Text('Edit Child Info'),
                  onTap: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new ExpansionPanelsDemo()));
                  },
                )
              : null,
          /*
          new ListTile(
            leading: const Icon(Icons.settings),
            title: new Text('Settings'),
            onTap: () {
              // TODO
              print('you tapped on settings');
            },
          ),
          */
          new ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: new Text('Logout'),
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => new LoginPage()));
            },
          )
        ].where((Object o) => o != null).toList(),
      ),
    );
  }
}
