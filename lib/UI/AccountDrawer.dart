import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Pages/CalendarPage.dart';
import '../Pages/LoginPage.dart';
import '../Pages/EditKids.dart';

class AccountDrawer extends StatelessWidget {
  final Map _permissions;
  final String _user;
  final List<String> _schools;

  AccountDrawer(this._permissions, this._user, this._schools);

  String getName(String user) {
    switch (user) {
      case 'anu':
        return 'Anu Varshney';
      case 'sonu':
        return 'Shuchi Agarwal';
      case 'teacher':
        return 'Teacher/Staff';
      case 'thenik':
        return 'Developer';
      default:
        return 'Manager';
    }
  }

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
                                new AssetImage('images/' + _user + '.png'),
                            radius: 50.0),
                        new Padding(
                            padding: new EdgeInsets.symmetric(vertical: 1.5)),
                        new Text(getName(_user),
                            style: new TextStyle(color: Colors.white)),
                      ],
                    )
                  ])),
          _permissions['calendarAccess']
              ? new ListTile(
                  leading: const Icon(Icons.date_range),
                  title: new Text('Calendar'),
                  onTap: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new CalendarView(
                                _permissions, _user, _schools)));
                  },
                )
              : null,
          _permissions['canEditKids']
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
              try {
                FirebaseAuth.instance.signOut();
              } catch (err) {
                print(err);
              }
              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => new LoginPage()));
            },
          )
        ].where((Object o) => o != null).toList(),
      ),
    );
  }
}
