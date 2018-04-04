import 'package:flutter/material.dart';

class CategoriesBar extends StatelessWidget {
  final String _currCategory;
  final _onUpdateCategory;

  CategoriesBar(this._currCategory, this._onUpdateCategory);

  @override
  Widget build(BuildContext context) {
    return new Wrap(
      alignment: WrapAlignment.center,
      children: <Widget>[
        new Category('all', _currCategory, () => _onUpdateCategory('all')),
        new Category(
            'brewer', _currCategory, () => _onUpdateCategory('brewer')),
        new Category(
            'audubon', _currCategory, () => _onUpdateCategory('audubon')),
        new Category(
            'fostercity', _currCategory, () => _onUpdateCategory('fostercity')),
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
