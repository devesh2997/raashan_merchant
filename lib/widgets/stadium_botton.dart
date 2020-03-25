import 'package:flutter/material.dart';
import 'package:raashan_merchant/utils/utils.dart';

class StadiumButton extends StatelessWidget {
  final Function callback;
  final String label;
  StadiumButton({@required this.callback, @required this.label});
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: callback,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
        child: Text(
          label,
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      fillColor: getPrimaryColor(),
      shape: StadiumBorder(),
    );
  }
}
