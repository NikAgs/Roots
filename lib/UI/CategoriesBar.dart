import 'package:flutter/material.dart';

class CategoriesBar extends StatelessWidget {
  final List<String> _categories;
  final _onUpdateCategory;
  final List<String> _schools;

  CategoriesBar(this._categories, this._onUpdateCategory, this._schools);

  @override
  Widget build(BuildContext context) {
    return new Wrap(
      alignment: WrapAlignment.center,
      children: <Widget>[
        new DropdownButton<String>(
          value: _categories[0],
          style: new TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
              color: new Color(0xFF636363)),
          onChanged: (String newValue) {
            _onUpdateCategory(newValue, 0);
          },
          items: _schools.map((String school) {
            return new DropdownMenuItem<String>(
                value: school,
                child: new Container(
                    child: new Text(school, textAlign: TextAlign.center),
                    width: 150.0));
          }).toList(),
        ),
        new SizedBox(width: 15.0, height: 50.0),
        new Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Padding(padding: new EdgeInsets.only(left: 20.0)),
            new Category(
                'all', _categories[1], () => _onUpdateCategory('all', 1)),
            new Category(
                'kinder', _categories[1], () => _onUpdateCategory('kinder', 1)),
            new Category('elementary', _categories[1],
                () => _onUpdateCategory('elementary', 1)),
            new Padding(padding: new EdgeInsets.only(right: 15.0)),
          ],
        )
      ],
    );
  }
}

class Category extends StatelessWidget {
  final String _name, _currCategory;
  final VoidCallback _onPressedButton;

  Category(this._name, this._currCategory, this._onPressedButton);

  @override
  Widget build(BuildContext context) {
    return new FlatButton(
      child: new Text(_name, style: new TextStyle(fontSize: 18.0)),
      color: _name == _currCategory ? Colors.blue : null,
      textColor: _name == _currCategory
          ? new Color(0xFFFFFFFF)
          : new Color(0xFF636363),
      onPressed: _onPressedButton,
    );
  }
}
