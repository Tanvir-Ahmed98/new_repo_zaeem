import 'package:flutter/material.dart';

import '../utils/color_const.dart';

class CustomeFloatingActonButton extends StatelessWidget {
  final MediaQueryData mediaQuery;
  final IconData? icon;
  final double? iconSize;
  final double? buttonHeight;
  final double? buttonWidth;
  final VoidCallback onPressed;
  const CustomeFloatingActonButton(
      {super.key,
      required this.mediaQuery,
      required this.onPressed,
      this.icon,
      this.iconSize,
      this.buttonHeight,
      this.buttonWidth});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: buttonHeight ?? 30,
      width: buttonWidth ?? 30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.defaultTextColor,
            Color(0xFF2D3436),
          ],
        ),
      ),
      child: FloatingActionButton(
        backgroundColor: Colors.transparent,
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        child: Icon(
          icon ?? Icons.create_new_folder,
          color: Colors.white,
          size: iconSize ?? 20,
        ),
      ),
    );
  }
}
