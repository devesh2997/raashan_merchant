import 'package:flutter/material.dart';
import 'package:raashan_merchant/utils/utils.dart';

class AlertSheet extends StatelessWidget {
  final Widget child;

  const AlertSheet({
    Key key,
    this.child,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: new BorderRadius.only(
            topLeft: const Radius.circular(20.0),
            topRight: const Radius.circular(20.0),
          ),
          color: Colors.white,
        ),
        child: child,
      ),
    );
  }
}
