import 'package:flutter/material.dart';

class CategoriesBar extends StatelessWidget {

  final String _currCategory;
  final _onUpdateCategory;

  CategoriesBar(this._currCategory,this._onUpdateCategory);

  @override
  Widget build(BuildContext context) {
    return new Wrap(
      alignment: WrapAlignment.center,
      children: <Widget>[
        new Category('ALL', _currCategory, () => _onUpdateCategory('ALL')),
        new Category('BREWER', _currCategory, () => _onUpdateCategory('BREWER')),
        new Category('AUDUBON', _currCategory, () => _onUpdateCategory('AUDUBON')),
        new Category('FOSTERCITY', _currCategory, () => _onUpdateCategory('FOSTERCITY')),
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
      child: new Text(_name),
      color: _name == _currCategory ? Colors.blue : null,
      textColor: _name == _currCategory
          ? new Color(0xFFFFFFFF)
          : new Color(0xFF636363),
      onPressed: _onPressedButton,
    );
  }
}
