import 'package:flutter/material.dart';

class CategoriesBar extends StatelessWidget {
  final List<String> _categories;
  final _onUpdateCategory;

  CategoriesBar(this._categories, this._onUpdateCategory);

  @override
  Widget build(BuildContext context) {
    return new Wrap(
      alignment: WrapAlignment.center,
      children: <Widget>[
        new Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Padding(padding: new EdgeInsets.only(left: 15.0)),
            new Category(
                'all', _categories[0], () => _onUpdateCategory('all', 0), 0),
            new Category('brewer', _categories[0],
                () => _onUpdateCategory('brewer', 0), 0),
            new Category('audubon', _categories[0],
                () => _onUpdateCategory('audubon', 0), 0),
            new Category('fostercity', _categories[0],
                () => _onUpdateCategory('fostercity', 0), 0),
            new Padding(padding: new EdgeInsets.only(right: 20.0)),
          ],
        ),
        new Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Padding(padding: new EdgeInsets.only(left: 20.0)),
            new Category(
                'all', _categories[1], () => _onUpdateCategory('all', 1), 1),
            new Category('kinder', _categories[1],
                () => _onUpdateCategory('kinder', 1), 1),
            new Category('elementary', _categories[1],
                () => _onUpdateCategory('elementary', 1), 1),
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
  final int _categoryIndex;

  Category(this._name, this._currCategory, this._onPressedButton,
      this._categoryIndex);

  @override
  Widget build(BuildContext context) {
    return new FlatButton(
      child: new Text(_name, style: new TextStyle(fontSize: 18.0)),
      color: _name == _currCategory ? getCategoryColor() : null,
      textColor: _name == _currCategory
          ? new Color(0xFFFFFFFF)
          : new Color(0xFF636363),
      onPressed: _onPressedButton,
    );
  }

  Color getCategoryColor() {
    if (_categoryIndex == 0) return Colors.blue;
    if (_categoryIndex == 1) return Colors.green;
    return null;
  }
}
