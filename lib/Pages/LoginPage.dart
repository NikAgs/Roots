import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'CheckinPage.dart';
import '../Database/Getters.dart';

import '../email.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _invalidUserPass = false;
  final TextEditingController _username = new TextEditingController();
  final TextEditingController _password = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final logo =
        new Hero(tag: 'hero', child: new Image.asset('images/rfk-logo.png'));

    Widget email = new TextField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: new InputDecoration(
        hintText: 'Username',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
      controller: _username,
    );

    Widget password = new TextField(
        autofocus: false,
        obscureText: true,
        decoration: new InputDecoration(
          hintText: 'Password',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        ),
        controller: _password);

    Widget loginButton = new Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: new Material(
        borderRadius: BorderRadius.circular(30.0),
        shadowColor: Colors.lightBlueAccent.shade100,
        elevation: 5.0,
        child: new MaterialButton(
          minWidth: 200.0,
          height: 42.0,
          onPressed: () async {
            try {
              await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: (_username.text + '@rootsforkids.org'),
                  password: _password.text);

              Map permissions = await getPermissions();
              List<String> schools = await getSchoolNames();
              emailInfo = await getEmailInfo();

              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new CheckinPage(DateTime.now(),
                          permissions, _username.text, schools)));
            } catch (e) {
              setState(() => _invalidUserPass = true);
              _password.text = '';
              print(e);
            }
          },
          color: new Color(0xFF3F69F1),
          child:
              const Text('Log In', style: const TextStyle(color: Colors.white)),
        ),
      ),
    );

    /*
    Widget forgotLabel = new FlatButton(
      child: const Text(
        'Forgot password?',
        style: const TextStyle(color: Colors.black54),
      ),
      onPressed: () {},
    );
    */

    return new Scaffold(
      backgroundColor: Colors.white,
      body: new Center(
        child: new ListView(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 100.0),
          children: <Widget>[
            logo,
            new SizedBox(height: 25.0),
            email,
            new SizedBox(height: 10.0),
            password,
            new SizedBox(height: 30.0),
            loginButton,
            new SizedBox(height: 50.0),
            _invalidUserPass
                ? new Text('Invalid Username/Password',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red))
                : new Text('')
          ],
        ),
      ),
    );
  }
}
