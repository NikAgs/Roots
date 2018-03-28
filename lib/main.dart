import 'package:flutter/material.dart';
import 'UI/CategoriesBar.dart';
import 'UI/KidGrid.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Wed, Mar 28'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _currCategory = 'ALL';

  void updateCategory(String update) {
    setState(() => _currCategory = update);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new ListView(
        padding: new EdgeInsets.only(bottom: 100.0),
        children: <Widget>[
          new Padding(padding: new EdgeInsets.only(top: 20.0)),
          new CategoriesBar(_currCategory, updateCategory),
          new Padding(padding: new EdgeInsets.only(bottom: 20.0)),
          new KidGrid(new KidGridBuilder().get(_currCategory)),
        ],
      ),
    );
  }
}
