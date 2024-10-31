import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parent_app_by_ats/component/date_time_widget.dart';
import 'package:parent_app_by_ats/services/api_service.dart';
import 'package:parent_app_by_ats/services/storage_service.dart';

class AttendanceController extends GetxController {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();
  final OverlayPortalController studentSessionListTooltipController =
          OverlayPortalController(),
      studentClassListTooltipController = OverlayPortalController(),
      studentChildListTooltipController = OverlayPortalController();
  final studentSessionListLink = LayerLink(),
      studentClassListLink = LayerLink(),
      studentChildListLink = LayerLink();
  OverlayPortalController? activeController;
  late ScrollController studentSessionListScrollController = ScrollController(),
      studentClassListScrollController = ScrollController(),
      studentChildListScrollController = ScrollController();
  final TextEditingController studentSessionListController =
          TextEditingController(),
      studentClassListController = TextEditingController(),
      studentChildListController = TextEditingController(),
      searchStudentSessionListController = TextEditingController(),
      searchStudentClassListController = TextEditingController(),
      searchStudentChildListController = TextEditingController(),
      selectDateWithOutDay = TextEditingController();
  RxString selectedDay = "".obs;

  RxList<Map<String, dynamic>> studentSessionList =
          <Map<String, dynamic>>[].obs,
      studentClassList = <Map<String, dynamic>>[].obs,
      studentChildList = <Map<String, dynamic>>[].obs,
      attendanceList = <Map<String, dynamic>>[].obs;
  RxBool studentSessionHasPage = true.obs,
      studentClassHasPage = true.obs,
      studentChildHasPage = true.obs,
      attendanceHasPage = true.obs,
      studentSessionListLoading = true.obs,
      studentClassListLoading = true.obs,
      studentChildListLoading = true.obs,
      attendanceListLoading = true.obs,
      showClassDropDown = false.obs,
      showChildDropdown = false.obs,
      enableFilterAttendanceButton = false.obs;
  RxInt studentSessionListPageOffset = 0.obs,
      studentClassListPageOffset = 0.obs,
      studentChildListPageOffset = 0.obs,
      attendanceListPageOffset = 0.obs;

  void setActiveController(OverlayPortalController controller) {
    if (activeController != null && activeController != controller) {
      activeController!.hide();
    }
    activeController = controller;
  }

  Future<void> getStudentSessionList() async {
    await _storageService.init();
    var pComId = _storageService.read('comId').toString();
    //var pMainCompany = _storageService.read('mainCompany');

    try {
      var response = await _apiService.get(
          "/PT_PARENT_ATTND_TIME_SESSION_LIST?P_COM_ID=$pComId&offset=${studentSessionListPageOffset.value}");

      if ((response['items'] as List).isNotEmpty) {
        List newItems = response['items'];
        for (Map<String, dynamic> item in newItems) {
          bool exists = studentSessionList.any(
              (enrollment) => enrollment['ar_ref_id'] == item['ar_ref_id']);
          if (!exists) {
            studentSessionList.add(item);
          }
        }

        studentSessionHasPage.value = response['hasMore'];

        if (studentSessionHasPage.value) {
          var link = (response['links'] as List)
              .firstWhere((links) => links['rel'] == 'next');

          if (link['rel'] == 'next' && link['href'] != null) {
            var nextPage = link['href'] as String;
            studentSessionListPageOffset.value = nextPage.contains('&offset=')
                ? int.parse(nextPage.split('&offset=')[1])
                : studentSessionListPageOffset.value;
          }
        }
      }

      studentSessionListLoading.value = false;
    } catch (error) {
      studentSessionListLoading.value = false;
    }
  }

  Future<void> getStudentClassList() async {
    await _storageService.init();
    var pComId = _storageService.read('comId').toString();
    //var pMainCompany = _storageService.read('mainCompany');

    try {
      var response = await _apiService.get(
          "/PT_PARENT_ATTND_TIME_CLASS_LIST?P_COM_ID=$pComId&offset=${studentClassListPageOffset.value}");

      if ((response['items'] as List).isNotEmpty) {
        List newItems = response['items'];
        for (Map<String, dynamic> item in newItems) {
          bool exists = studentClassList.any((enrollment) =>
              enrollment['asc_class_id'] == item['asc_class_id']);
          if (!exists) {
            studentClassList.add(item);
          }
        }

        studentClassHasPage.value = response['hasMore'];

        if (studentClassHasPage.value) {
          var link = (response['links'] as List)
              .firstWhere((links) => links['rel'] == 'next');

          if (link['rel'] == 'next' && link['href'] != null) {
            var nextPage = link['href'] as String;
            studentClassListPageOffset.value = nextPage.contains('&offset=')
                ? int.parse(nextPage.split('&offset=')[1])
                : studentClassListPageOffset.value;
          }
        }
      }

      studentClassListLoading.value = false;
    } catch (error) {
      studentClassListLoading.value = false;
    }
  }

  Future<void> getStudentAsChildList() async {
    await _storageService.init();
    var pComId = _storageService.read('comId').toString();
    var pUsername = _storageService.read('user');
    var sessionId = studentSessionList.firstWhere(
      (element) => element['ar_desc_name'] == studentSessionListController.text,
    )['ar_ref_id'];
    var classId = studentClassList.firstWhere(
      (element) => element['asc_class_name'] == studentClassListController.text,
    )['asc_class_id'];
    try {
      var response = await _apiService.get(
          "/PT_PARENT_ATTND_TIME_CHILD_LIST?P_COM_ID=$pComId&P_SESSION=$sessionId&P_CLASS=$classId&P_USERNAME=$pUsername&offset=${studentChildListPageOffset.value}");
      log("$response");
      if ((response['items'] as List).isNotEmpty) {
        List newItems = response['items'];
        for (Map<String, dynamic> item in newItems) {
          bool exists = studentChildList.any(
              (enrollment) => enrollment['asse_er_id'] == item['asse_er_id']);
          if (!exists) {
            studentChildList.add(item);
          }
        }

        studentChildHasPage.value = response['hasMore'];

        if (studentChildHasPage.value) {
          var link = (response['links'] as List)
              .firstWhere((links) => links['rel'] == 'next');

          if (link['rel'] == 'next' && link['href'] != null) {
            var nextPage = link['href'] as String;
            studentChildListPageOffset.value = nextPage.contains('&offset=')
                ? int.parse(nextPage.split('&offset=')[1])
                : studentChildListPageOffset.value;
          }
        }
      }

      studentChildListLoading.value = false;
    } catch (error) {
      log("Error $error");
      studentChildListLoading.value = false;
    }
  }

  selectDate(context) async {
    DateTime? selectedDate = await DateTimeWidget.selectDateTime(context);
    if (selectedDate != null) {
      selectedDay.value = "${selectedDate.day}";
      selectDateWithOutDay.text =
          "${DateTimeWidget.getMonthName(selectedDate.month)}-${selectedDate.year}";
    } else {
      selectDateWithOutDay.text =
          "${DateTime.now().day}-${DateTimeWidget.getMonthName(DateTime.now().month)}-${DateTime.now().year}";
    }
  }

  @override
  void onInit() {
    getStudentSessionList();
    getStudentClassList();
    studentSessionListScrollController.addListener(() {
      if (studentSessionListScrollController.position.pixels ==
          studentSessionListScrollController.position.maxScrollExtent) {
        log("-----${studentSessionHasPage.value} ${studentSessionListPageOffset.value}");
        pagination(studentSessionHasPage.value, studentSessionHasPage.value,
            getStudentSessionList);
      }
    });
    studentClassListScrollController.addListener(() {
      if (studentClassListScrollController.position.pixels ==
          studentClassListScrollController.position.maxScrollExtent) {
        log("-----${studentClassHasPage.value} ${studentClassListPageOffset.value}");
        pagination(studentClassHasPage.value, studentClassHasPage.value,
            getStudentClassList);
      }
    });
    studentChildListScrollController.addListener(() {
      if (studentChildListScrollController.position.pixels ==
          studentChildListScrollController.position.maxScrollExtent) {
        log("-----${studentChildHasPage.value} ${studentChildListPageOffset.value}");
        pagination(studentChildHasPage.value, studentChildHasPage.value,
            getStudentAsChildList);
      }
    });
    studentSessionListController.addListener(() {
      if (studentSessionListController.text.isNotEmpty) {
        showClassDropDown.value = true;
      }
    });

    studentClassListController.addListener(() {
      if (studentClassListController.text.isNotEmpty) {
        showChildDropdown.value = true;
      }
    });
    studentChildListController.addListener(() {
      if (studentChildListController.text.isNotEmpty) {
        enableFilterAttendanceButton.value = true;
      }
    });
    super.onInit();
  }

  void pagination(hasPage, offset, Future<void> Function() update) {
    if (hasPage && offset != 0) {
      update();
    }
  }
}
