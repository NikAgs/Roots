import 'package:flutter/material.dart';
import '../Database/Getters.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Database/KidInfo.dart';

typedef Widget DemoItemBodyBuilder<T>(DemoItem<T> item);
enum DialogDemoAction { yes, no }

class DualHeaderWithHint extends StatelessWidget {
  const DualHeaderWithHint({this.name, this.value, this.hint, this.showHint});

  final String name;
  final String value;
  final String hint;
  final bool showHint;

  Widget _crossFade(Widget first, Widget second, bool isExpanded) {
    return new AnimatedCrossFade(
      firstChild: first,
      secondChild: second,
      firstCurve: const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
      secondCurve: const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
      sizeCurve: Curves.fastOutSlowIn,
      crossFadeState:
          isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    return new Row(children: <Widget>[
      new Expanded(
        flex: 2,
        child: new Container(
          margin: const EdgeInsets.only(left: 24.0),
          child: new FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: new Text(
              name,
              style: textTheme.caption.copyWith(fontSize: 15.0),
            ),
          ),
        ),
      ),
      new Expanded(
          flex: 3,
          child: new Container(
              margin: const EdgeInsets.only(left: 24.0),
              child: _crossFade(
                  new Text(value,
                      style: textTheme.body1.copyWith(fontSize: 15.0)),
                  new Text(hint,
                      style: textTheme.body1.copyWith(fontSize: 15.0)),
                  showHint)))
    ]);
  }
}

class CollapsibleBody extends StatelessWidget {
  const CollapsibleBody(
      {this.margin: EdgeInsets.zero,
      this.child,
      this.onSave,
      this.onCancel,
      this.onDelete});

  final EdgeInsets margin;
  final Widget child;
  final VoidCallback onSave;
  final VoidCallback onCancel;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    return new Column(children: <Widget>[
      new Container(
          margin: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0) -
              margin,
          child: new Center(
              child: new DefaultTextStyle(
                  style: textTheme.caption.copyWith(fontSize: 15.0),
                  child: child))),
      const Divider(height: 1.0),
      new Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Container(
                    margin: const EdgeInsets.only(left: 8.0),
                    child: new FlatButton(
                        onPressed: onDelete,
                        child: const Text('DELETE',
                            style: const TextStyle(
                                color: Colors.redAccent,
                                fontSize: 15.0,
                                fontWeight: FontWeight.w500)))),
                new Row(
                  children: <Widget>[
                    new Container(
                        margin: const EdgeInsets.only(right: 8.0),
                        child: new FlatButton(
                            onPressed: onCancel,
                            child: const Text('CANCEL',
                                style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w500)))),
                    new Container(
                        margin: const EdgeInsets.only(right: 8.0),
                        child: new FlatButton(
                            onPressed: onSave,
                            textTheme: ButtonTextTheme.accent,
                            child: const Text('SAVE')))
                  ],
                ),
              ]))
    ]);
  }
}

class DemoItem<T> {
  DemoItem({this.name, this.values, this.hint, this.builder})
      : nameController = new TextEditingController(text: values[0]),
        schoolController = new TextEditingController(text: values[1]),
        gradeController = new TextEditingController(text: values[2]);

  final String name;
  final String hint;
  final DemoItemBodyBuilder<T> builder;
  final TextEditingController nameController;
  final TextEditingController schoolController;
  final TextEditingController gradeController;
  List<String> values;
  bool isExpanded = false;

  ExpansionPanelHeaderBuilder get headerBuilder {
    return (BuildContext context, bool isExpanded) {
      return new DualHeaderWithHint(
          name: name, value: values[0], hint: hint, showHint: isExpanded);
    };
  }

  Widget build() => builder(this);
}

class ExpansionPanelsDemo extends StatefulWidget {
  @override
  _ExpansionPanelsDemoState createState() => new _ExpansionPanelsDemoState();
}

class _ExpansionPanelsDemoState extends State<ExpansionPanelsDemo> {
  List<DemoItem<dynamic>> _demoItems = [];

  @override
  void initState() {
    super.initState();

    void showDemoDialog<T>({BuildContext context, Widget child}) {
      showDialog<T>(
        context: context,
        builder: (BuildContext context) => child,
      ).then<void>((T value) {
        // The value passed to Navigator.pop() or null.
        if (value != null) {
          print(value);
        }
      });
    }

    getKids().then((List<DocumentSnapshot> kids) {
      kids.sort((a, b) => a.data['name'].compareTo(b.data['name']));
      setState(() {
        _demoItems = kids.map((DocumentSnapshot doc) {
          return new DemoItem<String>(
            name: doc.documentID,
            values: [doc.data['name'], doc.data['school'], doc.data['grade']],
            hint: 'Edit Info',
            builder: (DemoItem<String> item) {
              void close() {
                setState(() {
                  item.isExpanded = false;
                });
              }

              return new Form(
                child: new Builder(
                  builder: (BuildContext context) {
                    return new CollapsibleBody(
                      margin: const EdgeInsets.symmetric(horizontal: 16.0),
                      onSave: () {
                        Form.of(context).save();
                        updateKidInfo(item.name, item.values);
                        close();
                      },
                      onCancel: () {
                        Form.of(context).reset();
                        close();
                      },
                      onDelete: () {
                        showDemoDialog<DialogDemoAction>(
                            context: context,
                            child: new AlertDialog(
                                content: new Text(
                                    'Are you sure you want to delete ${item.values[0]}?'), // name
                                actions: <Widget>[
                                  new FlatButton(
                                      child: const Text('NO'),
                                      onPressed: () {
                                        Navigator.pop(
                                            context, DialogDemoAction.no);
                                      }),
                                  new FlatButton(
                                      child: const Text('YES'),
                                      onPressed: () {
                                        Navigator.pop(
                                            context, DialogDemoAction.yes);
                                        Navigator.pop(context);
                                        deleteKid(item.name);
                                      })
                                ]));
                      },
                      child: new Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: new Column(
                            children: <Widget>[
                              new TextFormField(
                                controller: item.nameController,
                                decoration: new InputDecoration(
                                  hintText: item.hint,
                                  labelText: 'Name',
                                ),
                                onSaved: (String value) {
                                  item.values[0] = value;
                                },
                              ),
                              new TextFormField(
                                controller: item.schoolController,
                                decoration: new InputDecoration(
                                  hintText: item.hint,
                                  labelText: 'School',
                                ),
                                onSaved: (String value) {
                                  item.values[1] = value;
                                },
                              ),
                              new TextFormField(
                                controller: item.gradeController,
                                decoration: new InputDecoration(
                                  hintText: item.hint,
                                  labelText: 'Grade',
                                ),
                                onSaved: (String value) {
                                  item.values[2] = value;
                                },
                              ),
                            ],
                          )),
                    );
                  },
                ),
              );
            },
          );
        }).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          title: const Text('Edit Kids Information'),
          centerTitle: true,
      ),
      body: new SingleChildScrollView(
        child: new SafeArea(
          top: false,
          bottom: false,
          child: new Container(
            margin: const EdgeInsets.all(24.0),
            child: new ExpansionPanelList(
                expansionCallback: (int index, bool isExpanded) {
                  setState(() {
                    _demoItems[index].isExpanded = !isExpanded;
                  });
                },
                children: _demoItems.map((DemoItem<dynamic> item) {
                  return new ExpansionPanel(
                      isExpanded: item.isExpanded,
                      headerBuilder: item.headerBuilder,
                      body: item.build());
                }).toList()),
          ),
        ),
      ),
    );
  }
}
