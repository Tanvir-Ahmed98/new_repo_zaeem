import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {

  final VoidCallback onPressed;
  final ButtonStyle? style;
  final Widget? icon;
  final double? width;
  final double? height;
  final Color buttonLabelColor;
  final Widget? child;

  const CustomElevatedButton({
    super.key,
    required this.onPressed,
    this.style,
    this.icon,
    this.width,
    this.height,
    this.buttonLabelColor = Colors.white,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: style,
        onPressed: onPressed,
        child: icon == null
            ? child
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon!,
                  const SizedBox(width: 8), // spacing between icon and text
                  child ?? const SizedBox.shrink(),
                ],
              ),
      ),
    );
  }
}
