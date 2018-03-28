import 'package:flutter/material.dart';
import 'package:quiver/collection.dart';

class KidGrid extends StatelessWidget {
  final List<Widget> kids;
  KidGrid(this.kids);

  @override
  Widget build(BuildContext context) {
    return new Wrap(
        alignment: WrapAlignment.center,
        direction: Axis.horizontal,
        children: this.kids);
  }
}

class KidGridBuilder {
  List<Kid> _all = <Kid> [
    new Kid("Aashi Upadhyay", "BREWER", false),
    new Kid("Anoushka Raj", "BREWER", false),
    new Kid("Chase Lee", "BREWER", false),
    new Kid("Aaira Srivastava", "BREWER", false),
    new Kid("Neel S Irrinki", "BREWER", false),
    new Kid("Rhia Bouttamy", "BREWER", false),
    new Kid("Ansh Gupta", "AUDUBON", false),
    new Kid("Anya Rajasekhar", "AUDUBON", false),
    new Kid("Brendan Dias", "AUDUBON", false),
    new Kid("David Pradeep", "AUDUBON", false),
    new Kid("Hridhaan Mittal", "AUDUBON", false),
    new Kid("Mihir Raghavan", "AUDUBON", false),
    new Kid("Rishan Vengala", "AUDUBON", false),
    new Kid("Ronin Abajon", "AUDUBON", false),
    new Kid("Soha Thakkar", "AUDUBON", false),
    new Kid("Abdul Ali Mohammed", "FOSTERCITY", false),
    new Kid("Adwita Jha", "FOSTERCITY", false),
    new Kid("Allison Clark", "FOSTERCITY", false),
    new Kid("Andrew Vuong", "FOSTERCITY", false),
    new Kid("Antara Shriniwar", "FOSTERCITY", false),
    new Kid("Ari Joshi", "FOSTERCITY", false),
    new Kid("Ashima Anajpure", "FOSTERCITY", false),
    new Kid("Bridget Evensen", "FOSTERCITY", false),
    new Kid("Emerald Fogt", "FOSTERCITY", false),
    new Kid("Ian Soares", "FOSTERCITY", false),
    new Kid("Joshua Healy", "FOSTERCITY", false),
    new Kid("Kristina Evensen", "FOSTERCITY", false),
    new Kid("Mokshay Subramaniam", "FOSTERCITY", false),
    new Kid("Neharika choudhary", "FOSTERCITY", false),
    new Kid("Oliver Markaley", "FOSTERCITY", false),
    new Kid("Reyansh Bhattacharya", "FOSTERCITY", false),
    new Kid("Sandhya Mukhyala", "FOSTERCITY", false),
    new Kid("Saurav Somu", "FOSTERCITY", false),
    new Kid("Yajwan Balajee", "FOSTERCITY", false),
    new Kid("Zachary Thorpe", "FOSTERCITY", false),
    new Kid("Zoie Neurgaonkar", "FOSTERCITY", false),
  ];


  TreeSet<Kid> _brewer = new TreeSet<Kid>(comparator: (a,b) => a.name.compareTo(b.name));
  TreeSet<Kid> _audubon = new TreeSet<Kid>(comparator: (a,b) => a.name.compareTo(b.name));
  TreeSet<Kid> _fostercity = new TreeSet<Kid>(comparator: (a,b) => a.name.compareTo(b.name));
  
  KidGridBuilder() {
    for (int i = 0; i < _all.length; i++) {
      switch(_all[i].school) {
        case 'BREWER': 
          _brewer.add(_all[i]);
          break;
        case 'AUDUBON':
          _audubon.add(_all[i]);
          break;
        case 'FOSTERCITY':
          _fostercity.add(_all[i]);
          break;
      }
    }
  }

  List<Widget> get(String category) {
    switch (category) {
      case 'ALL':
        return _all;
        break;
      case 'BREWER':
        return _brewer.toList();
        break;
      case 'AUDUBON':
        return _audubon.toList();
        break;
      case 'FOSTERCITY':
        return _fostercity.toList();
        break;
    }
    print("Unknown Category");
    return null;
  }
}

class Kid extends StatefulWidget {

  final String _name;
  final bool _isCheckedIn;
  final String _school;

  String get school => this._school;
  String get name => this._name;

  Kid(this._name, this._school, this._isCheckedIn);

  @override
  State createState() => new KidState(_name, _isCheckedIn);
}

class KidState extends State<Kid> {
  
  String _name;
  bool _isCheckedIn;

  KidState(this._name, this._isCheckedIn);


  @override
  Widget build(BuildContext context) {
    return new Container(
      width: 350.0,
      padding: new EdgeInsets.only(left: 25.0, right: 25.0, top: 20.0),
      child: new Card(
        color: _isCheckedIn ? new Color(0xFFCEECF5) : null,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget> [
            new Container(
              padding: new EdgeInsets.only(left: 25.0, right: 25.0),
              child: new Text("$_name")
            ),
            new Switch(
              value: _isCheckedIn,
              onChanged: (bool newValue) {
                setState(() {
                _isCheckedIn = newValue;
                });
              },
            )
          ]
        ),
      )
    );
  }
}
