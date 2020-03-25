import 'package:flutter/material.dart';

class BottomAppBarItem extends StatelessWidget {
  final bool isSelected;
  final Widget icon;
  final Widget selectedIcon;
  final String name;
  final Function callback;
  final Color selectedColor;
  const BottomAppBarItem(
      {Key key,
      @required this.isSelected,
      @required this.icon,
      @required this.selectedIcon,
      @required this.name,
      this.selectedColor = Colors.black,
      this.callback})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 36,
      icon: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          isSelected ? selectedIcon : icon,
          Text(
            name,
            style: TextStyle(
                fontSize: 10,
                color:
                    isSelected ? selectedColor : Colors.black),
          )
        ],
      ),
      onPressed: callback,
    );
  }
}
