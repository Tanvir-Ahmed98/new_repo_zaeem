import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/api_service.dart';
import '../services/storage_service.dart';

class AttendanceDetailsController extends GetxController {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();
  late ScrollController attendanceScrollController = ScrollController();
  RxList<Map<String, dynamic>> attendanceList = <Map<String, dynamic>>[].obs;
  RxBool attendanceListLoading = true.obs, attendanceListHasPage = true.obs;
  RxInt attendanceListPageOffset = 0.obs;
  String? selectedDay;
  int? studentId;

  Future<void> getAttendanceList() async {
    await _storageService.init();
    var pComId = _storageService.read('comId').toString();

    try {
      var response = await _apiService.get(
          "/PT_PARENT_CHILD_ATTEND_TIME_REPORT?P_COM_ID=$pComId&P_MONTH=$selectedDay&P_EROLL_STD_ID=$studentId&offset=${attendanceListPageOffset.value}");
      log("/PT_PARENT_CHILD_ATTEND_TIME_REPORT?P_COM_ID=$pComId&P_MONTH=$selectedDay&P_EROLL_STD_ID=$studentId&offset=${attendanceListPageOffset.value}");
      log("$response");
      if ((response['items'] as List).isNotEmpty) {
        List newItems = response['items'];
        for (Map<String, dynamic> item in newItems) {
          bool exists = attendanceList
              .any((enrollment) => enrollment['datee'] == item['datee']);
          if (!exists) {
            attendanceList.add(item);
          }
        }

        attendanceListHasPage.value = response['hasMore'];

        if (attendanceListHasPage.value) {
          var link = (response['links'] as List)
              .firstWhere((links) => links['rel'] == 'next');

          if (link['rel'] == 'next' && link['href'] != null) {
            var nextPage = link['href'] as String;
            attendanceListPageOffset.value = nextPage.contains('&offset=')
                ? int.parse(nextPage.split('&offset=')[1])
                : attendanceListPageOffset.value;
          }
        }
      }

      attendanceListLoading.value = false;
    } catch (error) {
      log("Error $error");
      attendanceListLoading.value = false;
    }
  }

  void pagination(hasPage, offset, Future<void> Function() update) {
    if (hasPage && offset != 0) {
      update();
    }
  }

  @override
  void onInit() {
    studentId = Get.arguments[0];
    selectedDay = Get.arguments[1];
    getAttendanceList();
    attendanceScrollController.addListener(() {
      if (attendanceScrollController.position.pixels ==
          attendanceScrollController.position.maxScrollExtent) {
        log("-----${attendanceListHasPage.value} ${attendanceListPageOffset.value}");
        pagination(attendanceListHasPage.value, attendanceListHasPage.value,
            getAttendanceList);
      }
    });

    super.onInit();
  }
}
