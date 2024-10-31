import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';
import '../services/routes_path.dart';
import '../services/storage_service.dart';
import '../utils/image_path.dart';

class BottomNavbarController extends GetxController
    with GetTickerProviderStateMixin {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();
  RxInt notificationCount = 0.obs, currentPage = 0.obs;

  late final AnimationController homeController;
  late final AnimationController notificationController;
  late final AnimationController dashboardController;
  late final AnimationController settingsController;
  RxList<Map<String, dynamic>> bottomBars = <Map<String, dynamic>>[
    {
      "icon": ImagePath.homeImage,
      "lable": "Home",
    },
    {
      "icon": ImagePath.notificationImage,
      "lable": "Notification",
    },
    {
      "icon": ImagePath.dashboardImage,
      "lable": "Dashboard",
      "controller": Rx<AnimationController?>(null),
    },
    {
      "icon": ImagePath.menuImage,
      "lable": "Menu",
      "controller": Rx<AnimationController?>(null),
    },
  ].obs;

  @override
  void onInit() {
    getNotificationCount();
    super.onInit();
  }

  @override
  void dispose() {
    homeController.dispose();
    notificationController.dispose();
    dashboardController.dispose();
    settingsController.dispose();
    Get.delete<BottomNavbarController>();
    super.dispose();
  }

  RxList<bool> colorVisibility =
      List.filled(5, false).obs; // Manage visibility for each index
  void changePage(int index) {
    currentPage.value = index;
    Get.offNamed(_getPageRoute(index), id: 1);
    colorVisibility[index] = true;
  }

  // Hide the color after 2 seconds
  void hideColorForIndex(int index) {
    colorVisibility[index] = false;
  }

  // Check if color is visible for the tab
  bool isColorVisibleForIndex(int index) {
    return colorVisibility[index];
  }

  String _getPageRoute(int index) {
    switch (index) {
      case 1:
        return RoutePath.notificationPath;
      case 2:
        return RoutePath.dashboardPath;
      case 3:
        return RoutePath.menuPath;
      default:
        return RoutePath.homePath;
    }
  }

  getNotificationCount() async {
    notificationCount.value = 0;
    _storageService.init();
    var pComId = await _storageService.read('comId');
    var pUsername = await _storageService.read('user');
    try {
      var response = await _apiService
          .get('/COURSE_NOTIFICATION?P_COM_ID=$pComId&P_USERNAME=$pUsername');

      if (response['items'] != []) {
        for (int i = 0; i < response['items'].length; i++) {
          // asn_not_status
          if (response['items'][i]['acn_not_status'] == 0 ||
              response['items'][i]['acn_not_status'] == null) {
            notificationCount.value++;
          }
        }

        //FlutterAppBadger.updateBadgeCount(notificationCount.value);
      } else {}
    } catch (error) {
      log("Error: $error");
    }
  }
}
