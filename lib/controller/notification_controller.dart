import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../component/custom_snackbar.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import 'bottom_nav_controller.dart';

class NotificationController extends GetxController {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();
  RxList<Map<String, dynamic>> notificationList = <Map<String, dynamic>>[].obs,
      unreadNotifications = <Map<String, dynamic>>[].obs;

  RxBool notificationsLoading = true.obs,
      hasPage = true.obs,
      selectAll = false.obs,
      notificationListLoading = true.obs,
      readAllNotificationLoading = true.obs,
      notificationListHasPage = true.obs;
  RxInt notificationListPageOffset = 0.obs, notificationCount = 0.obs;

  final ScrollController notificationScrollController = ScrollController();
  final TextEditingController searchNotificationListController =
      TextEditingController();

  @override
  void onInit() async {
    await getNotificationList();
    notificationScrollController.addListener(() {
      if (notificationScrollController.position.pixels ==
          notificationScrollController.position.maxScrollExtent) {
        pagination(notificationListHasPage.value,
            notificationListPageOffset.value, getNotificationList);
      }
    });
    super.onInit();
  }

  @override
  void dispose() {
    Get.delete<NotificationController>();
    notificationScrollController.dispose();
    clearNotifications();
    super.dispose();
  }

  void pagination(hasPage, offset, Future<void> Function() update) {
    if (hasPage && offset != 0) {
      update();
    }
  }

  Future<void> getNotificationList({offset}) async {
    await _storageService.init();
    var pComId = await _storageService.read('comId');
    var pUsername = await _storageService.read('user');
    log("$pUsername");
    if (offset != null) {
      notificationListLoading.value = true;
      notificationList.clear();
      notificationListPageOffset.value = offset;
    }

    try {
      String url = searchNotificationListController.text == ""
          ? '/SCH_NOTIFICATION?P_COM_ID=$pComId&P_USERNAME=$pUsername&offset=${notificationListPageOffset.value}'
          : '/SCH_NOTIFICATION?P_COM_ID=$pComId&P_USERNAME=$pUsername&offset=${notificationListPageOffset.value}';
      Map<String, dynamic> response = await _apiService.get(url);
      if ((response['items'] as List).isNotEmpty) {
        List newItems = response['items'];

        for (Map<String, dynamic> item in newItems) {
          bool exists = notificationList.any(
              (enrollment) => enrollment['asn_not_id'] == item['asn_not_id']);
          if (!exists) {
            notificationList.add(item);
          }
        }

        notificationListHasPage.value = response['hasMore'];

        if (notificationListHasPage.value) {
          var link = (response['links'] as List)
              .firstWhere((links) => links['rel'] == 'next');

          if (link['rel'] == 'next' && link['href'] != null) {
            var nextPage = link['href'] as String;
            notificationListPageOffset.value = nextPage.contains('&offset=')
                ? int.parse(nextPage.split('&offset=')[1])
                : notificationListPageOffset.value;
          }
        }
        notificationCount.value = notificationListHasPage.value
            ? notificationList.length + 1
            : notificationList.length;

        // selectAll.value = !notificationList.any(
        //   (element) {
        //     return element['acn_not_status'] == 1;
        //   },
        // );
      }

      notificationListLoading.value = false;
    } catch (error) {
      notificationListLoading.value = false;
      log("Error: $error");
    }
  }

  var selectedNotifications = <int>[].obs;
  // RxList selectedNotification = [].obs;
  bool isSelected(int notificationId) {
    return selectedNotifications.contains(notificationId);
  }

  // Toggle notification selection
  void toggleNotificationSelection(int notificationId) {
    if (selectedNotifications.contains(notificationId)) {
      selectedNotifications.remove(notificationId);
    } else {
      selectedNotifications.add(notificationId);
    }
  }

  readNotification(int id) async {
    _storageService.init();

    var pComId = await _storageService.read('comId');
    var request = {"P_COM_ID": pComId, "P_NOT_ID": id};

    try {
      var response = await _apiService.post('/SCH_NOTIFICATION', request);

      if (response['Result'] != "Failure") {
        clearNotifications();
        getNotificationList(offset: 0).then(
          (value) {
            final bottomNavController = Get.put(BottomNavbarController());
            bottomNavController.getNotificationCount();
          },
        );
        Get.back();
        CustomeSnackbar.showSnackbar(
          title: response['Result'],
          message: "Notification Marked as read",
          backgroundColor: Colors.green,
          textColor: Colors.white,
          duration: const Duration(seconds: 2),
        );
      } else {
        clearNotifications();
        getNotificationList();
        CustomeSnackbar.showSnackbar(
            title: response['Result'],
            message: response['Message'],
            backgroundColor: Colors.red,
            textColor: Colors.white,
            duration: const Duration(seconds: 2));
      }
    } catch (error) {
      log("ERROR: $error");
    }
  }

  Future<void> readAllNotification() async {
    readAllNotificationLoading.value = false;
    _storageService.init();
    var pComId = await _storageService.read('comId');
    var pUsername = await _storageService.read('user');
    var request = {"P_COM_ID": pComId, "P_USERNAME": pUsername};

    try {
      var response =
          await _apiService.post('/SCH_NOTIFICATON_MARK_ALL', request);

      if (response['Result'] != "Failure") {
        clearNotifications();
        readAllNotificationLoading.value = true;
        final bottomNavBar = Get.put(BottomNavbarController());
        bottomNavBar.getNotificationCount();
        getNotificationList();

        CustomeSnackbar.showSnackbar(
          title: response['Result'],
          message: "All notifications are read",
          backgroundColor: Colors.green,
          textColor: Colors.white,
          duration: const Duration(seconds: 2),
        );
      } else {
        readAllNotificationLoading.value = true;
        clearNotifications();
        getNotificationList();
        CustomeSnackbar.showSnackbar(
            title: response['Result'],
            message: response['Message'],
            backgroundColor: Colors.red,
            textColor: Colors.white,
            duration: const Duration(seconds: 2));
      }
    } catch (error) {
      readAllNotificationLoading.value = true;
      log("ERROR: $error");
    }
  }

  void clearNotifications() {
    notificationList.clear();
    notificationsLoading.value = true;
    selectAll.value = false;
  }
}
