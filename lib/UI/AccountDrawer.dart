import 'package:flutter/material.dart';

class AccountDrawer extends StatelessWidget {
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
                                new AssetImage('images/Schuchi.png'),
                            radius: 50.0),
                        new Padding(
                            padding:
                                new EdgeInsets.only(top: 1.5, bottom: 1.5)),
                        new Text('Schuchi Agrawal',
                            style: new TextStyle(color: Colors.white)),
                      ],
                    )
                  ])),
          new ListTile(
            leading: const Icon(Icons.date_range),
            title: new Text('Calendar'),
            onTap: () {
              // TODO
            },
          ),
          new ListTile(
            leading: const Icon(Icons.mode_edit),
            title: new Text('Edit Child Info'),
            onTap: () {
              // TODO
            },
          ),
          new ListTile(
            leading: const Icon(Icons.settings),
            title: new Text('Settings'),
            onTap: () {
              // TODO
            },
          ),
          new ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: new Text('Logout'),
            onTap: () {
              // TODO
            },
          )
        ],
      ),
    );
  }
}
