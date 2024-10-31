import 'package:flutter/material.dart';

import 'custome_text.dart';

class EmptyInformationWidget extends StatelessWidget {
  final String title;
  final double? height;
  final double? width;
  final Color? color;
  final Color? titleColor;
  const EmptyInformationWidget({
    super.key,
    required this.title,
    this.height,
    this.width,
    this.color,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? MediaQuery.of(context).size.height * 0.3,
      width: width ?? MediaQuery.of(context).size.width - 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        border: Border.all(width: 2, color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: CustomeText(
            text: title,
            textAlign: TextAlign.center,
            fontWeight: FontWeight.w900,
            fontSize: 24,
            color: titleColor ?? Colors.grey),
      ),
    );
  }
}
