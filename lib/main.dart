import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Roots For Kids'),
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
  List<Widget> firstGraders;
  List<Widget> secondGraders;
  List<Widget> thirdGraders;

  Widget categories = new Wrap(
  alignment: WrapAlignment.center,
  children: <Widget>[
    new FlatButton(
        child: const Text('ALL'),
        textColor: new Color(0xFF636363),
        onPressed: () { /* do nothing */ },
      ),
      new FlatButton(
        child: const Text('FIRST GRADE'),
        textColor: new Color(0xFF636363),
        onPressed: () { /* do nothing */ },
      ),
      new FlatButton(
        child: const Text('SECOND GRADE'),
        textColor: new Color(0xFF636363),
        onPressed: () { /* do nothing */ },
      ),
      new FlatButton(
        child: const Text('THIRD GRADE'),
        textColor: new Color(0xFF636363),
        onPressed: () { /* do nothing */ },
      ),
  ],
);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new ListView(
        padding: new EdgeInsets.all(20.0),
        children: <Widget>[
          categories,
        ],
      ),
    );
  }
}
