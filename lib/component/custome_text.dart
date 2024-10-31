import 'package:flutter/material.dart';

class CustomeText extends StatelessWidget {
  final String text;
  final FontWeight fontWeight;
  final double fontSize;
  final Color color;
  final TextDirection textDirection;
  final TextAlign textAlign;
  final bool softWrap;
  final FontStyle fontStyle;
  final int? maxLines;
  final TextDecoration? decoration;

  const CustomeText({
    super.key,
    required this.text,
    this.fontWeight = FontWeight.normal,
    this.fontSize = 14.0,
    this.color = Colors.black,
    this.textDirection = TextDirection.ltr,
    this.decoration,
    this.textAlign = TextAlign.left,
    this.softWrap = true,
    this.fontStyle = FontStyle.normal,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontWeight: fontWeight,
          fontSize: fontSize,
          color: color,
          fontStyle: fontStyle,
          decoration: decoration),
      textDirection: textDirection,
      textAlign: textAlign,
      maxLines: maxLines,
      softWrap: softWrap,
    );
  }
}
