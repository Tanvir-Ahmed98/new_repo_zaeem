import 'dart:async';
import 'package:flutter/material.dart';

import '../services/routes_path.dart';
import 'package:get/get.dart';
import '../services/storage_service.dart';

class SplashController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final StorageService _storageService = StorageService();
  late AnimationController animationController;
  late Animation<double> animation;

  String? user;

  initStprage() async {
    await _storageService.init();
    user = _storageService.read('user');
  }

  @override
  void onInit() async {
    initStprage();
    animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )
        /*..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          // If the animation completes, reverse it
          animationController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          // If the animation is dismissed (reversed), forward it again
          animationController.forward();
        }
      })*/
        ;

    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeIn,
    );

    animationController.forward();
    redirectScreen();
    super.onInit();
  }

  @override
  void dispose() {
    Get.delete<SplashController>();
    animationController.dispose();
    super.dispose();
  }

  void redirectScreen() {
    Future.delayed(const Duration(seconds: 3), () {
      if (user != null) {
        Get.offAllNamed(RoutePath.homePath);
      } else {
        Get.offAllNamed(RoutePath.loginPath);
      }
    });
  }
}
