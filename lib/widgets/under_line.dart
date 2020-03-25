import 'package:flutter/material.dart';
import 'package:raashan_merchant/utils/utils.dart';

class UnderLine extends StatelessWidget {
  final double width;
  final double height;
  final Color color;

  const UnderLine({Key key, this.width, this.height, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height ?? 3,
      decoration: BoxDecoration(
        color: color ?? getAccentColor(),
        border: Border.all(color: color ?? getAccentColor()),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
