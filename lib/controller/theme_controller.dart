import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  // Initialize with system theme mode or light mode
  var isDarkMode = false.obs;

  // Function to toggle between light and dark mode
  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }
}