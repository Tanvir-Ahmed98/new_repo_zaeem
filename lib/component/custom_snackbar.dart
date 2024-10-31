import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomeSnackbar {
  static void showSnackbar({
    required String title,
    required String message,
    SnackPosition position = SnackPosition.BOTTOM,
    Color backgroundColor = Colors.black,
    Color textColor = Colors.white,
    Duration duration = const Duration(seconds: 3),
    IconData? icon,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: position,
      backgroundColor: backgroundColor,
      colorText: textColor,
      duration: duration,
      icon: icon != null ? Icon(icon, color: textColor) : null,
      margin: const EdgeInsets.all(8),
      borderRadius: 8,
    );
  }
}
