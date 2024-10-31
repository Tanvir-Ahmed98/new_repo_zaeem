import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parent_app_by_ats/screens/pdf_screen.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class FeeVoucherController extends GetxController {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();
  final OverlayPortalController feeVoucherMonthListTooltipController =
          OverlayPortalController(),
      feeVoucherSessionListTooltipController = OverlayPortalController(),
      feeVoucherClassListTooltipController = OverlayPortalController(),
      feeVoucherChildListTooltipController = OverlayPortalController();
  final feeVoucherMonthListLink = LayerLink(),
      feeVoucherSessionListLink = LayerLink(),
      feeVoucherClassListLink = LayerLink(),
      feeVoucherChildListLink = LayerLink();
  OverlayPortalController? activeController;
  late ScrollController feeVoucherMonthListScrollController =
          ScrollController(),
      feeVoucherSessionListScrollController = ScrollController(),
      feeVoucherClassListScrollController = ScrollController(),
      feeVoucherChildListScrollController = ScrollController();
  final TextEditingController feeVoucherMonthListController =
          TextEditingController(),
      feeVoucherSessionListController = TextEditingController(),
      feeVoucherClassListController = TextEditingController(),
      feeVoucherChildListController = TextEditingController(),
      searchfeeVoucherMonthListController = TextEditingController(),
      searchfeeVoucherSessionListController = TextEditingController(),
      searchfeeVoucherClassListController = TextEditingController(),
      searchfeeVoucherChildListController = TextEditingController();

  RxList<Map<String, dynamic>> feeVoucherMonthList =
          <Map<String, dynamic>>[].obs,
      feeVoucherSessionList = <Map<String, dynamic>>[].obs,
      feeVoucherClassList = <Map<String, dynamic>>[].obs,
      feeVoucherChildList = <Map<String, dynamic>>[].obs;
  RxBool feeVoucherMonthHasPage = true.obs,
      feeVoucherSessionHasPage = true.obs,
      feeVoucherClassHasPage = true.obs,
      feeVoucherChildHasPage = true.obs,
      attendanceHasPage = true.obs,
      feeVoucherMonthListLoading = true.obs,
      feeVoucherSessionListLoading = true.obs,
      feeVoucherClassListLoading = true.obs,
      feeVoucherChildListLoading = true.obs,
      enableFilterAttendanceButton = false.obs,
      pdfLoading = false.obs;
  RxInt feeVoucherMonthListPageOffset = 0.obs,
      feeVoucherSessionListPageOffset = 0.obs,
      feeVoucherClassListPageOffset = 0.obs,
      feeVoucherChildListPageOffset = 0.obs,
      attendanceListPageOffset = 0.obs;

  void setActiveController(OverlayPortalController controller) {
    if (activeController != null && activeController != controller) {
      activeController!.hide();
    }
    activeController = controller;
  }

  Future<void> getFeeVoucherMonthList() async {
    await _storageService.init();
    var pComId = _storageService.read('comId').toString();
    //var pMainCompany = _storageService.read('mainCompany');

    try {
      var response = await _apiService.get(
          "/PT_PARENT_FEE_MONTH_LIST?P_COM_ID=$pComId&offset=${feeVoucherMonthListPageOffset.value}");

      if ((response['items'] as List).isNotEmpty) {
        List newItems = response['items'];
        for (Map<String, dynamic> item in newItems) {
          bool exists = feeVoucherSessionList.any((enrollment) =>
              enrollment['asgm_mont_id'] == item['asgm_mont_id']);
          if (!exists) {
            feeVoucherMonthList.add(item);
          }
        }

        feeVoucherMonthHasPage.value = response['hasMore'];

        if (feeVoucherMonthHasPage.value) {
          var link = (response['links'] as List)
              .firstWhere((links) => links['rel'] == 'next');

          if (link['rel'] == 'next' && link['href'] != null) {
            var nextPage = link['href'] as String;
            feeVoucherMonthListPageOffset.value = nextPage.contains('&offset=')
                ? int.parse(nextPage.split('&offset=')[1])
                : feeVoucherMonthListPageOffset.value;
          }
        }
      }

      feeVoucherMonthListLoading.value = false;
    } catch (error) {
      feeVoucherMonthListLoading.value = false;
    }
  }

  Future<void> getfeeVoucherSessionList() async {
    await _storageService.init();
    var pComId = _storageService.read('comId').toString();
    //var pMainCompany = _storageService.read('mainCompany');

    try {
      var response = await _apiService.get(
          "/PT_PARENT_ATTND_TIME_SESSION_LIST?P_COM_ID=$pComId&offset=${feeVoucherSessionListPageOffset.value}");

      if ((response['items'] as List).isNotEmpty) {
        List newItems = response['items'];
        for (Map<String, dynamic> item in newItems) {
          bool exists = feeVoucherSessionList.any(
              (enrollment) => enrollment['ar_ref_id'] == item['ar_ref_id']);
          if (!exists) {
            feeVoucherSessionList.add(item);
          }
        }

        feeVoucherSessionHasPage.value = response['hasMore'];

        if (feeVoucherSessionHasPage.value) {
          var link = (response['links'] as List)
              .firstWhere((links) => links['rel'] == 'next');

          if (link['rel'] == 'next' && link['href'] != null) {
            var nextPage = link['href'] as String;
            feeVoucherSessionListPageOffset.value =
                nextPage.contains('&offset=')
                    ? int.parse(nextPage.split('&offset=')[1])
                    : feeVoucherSessionListPageOffset.value;
          }
        }
      }

      feeVoucherSessionListLoading.value = false;
    } catch (error) {
      feeVoucherSessionListLoading.value = false;
    }
  }

  Future<void> getfeeVoucherClassList() async {
    await _storageService.init();
    var pComId = _storageService.read('comId').toString();
    //var pMainCompany = _storageService.read('mainCompany');

    try {
      var response = await _apiService.get(
          "/PT_PARENT_ATTND_TIME_CLASS_LIST?P_COM_ID=$pComId&offset=${feeVoucherClassListPageOffset.value}");

      if ((response['items'] as List).isNotEmpty) {
        List newItems = response['items'];
        for (Map<String, dynamic> item in newItems) {
          bool exists = feeVoucherClassList.any((enrollment) =>
              enrollment['asc_class_id'] == item['asc_class_id']);
          if (!exists) {
            feeVoucherClassList.add(item);
          }
        }

        feeVoucherClassHasPage.value = response['hasMore'];

        if (feeVoucherClassHasPage.value) {
          var link = (response['links'] as List)
              .firstWhere((links) => links['rel'] == 'next');

          if (link['rel'] == 'next' && link['href'] != null) {
            var nextPage = link['href'] as String;
            feeVoucherClassListPageOffset.value = nextPage.contains('&offset=')
                ? int.parse(nextPage.split('&offset=')[1])
                : feeVoucherClassListPageOffset.value;
          }
        }
      }

      feeVoucherClassListLoading.value = false;
    } catch (error) {
      feeVoucherClassListLoading.value = false;
    }
  }

  Future<void> getfeeVoucherAsChildList() async {
    await _storageService.init();
    var pComId = _storageService.read('comId').toString();
    var pUsername = _storageService.read('user');
    var sessionId = feeVoucherSessionList.firstWhere(
      (element) =>
          element['ar_desc_name'] == feeVoucherSessionListController.text,
    )['ar_ref_id'];
    var classId = feeVoucherClassList.firstWhere(
      (element) =>
          element['asc_class_name'] == feeVoucherClassListController.text,
    )['asc_class_id'];
    try {
      var response = await _apiService.get(
          "/PT_PARENT_ATTND_TIME_CHILD_LIST?P_COM_ID=$pComId&P_SESSION=$sessionId&P_CLASS=$classId&P_USERNAME=$pUsername&offset=${feeVoucherChildListPageOffset.value}");
      log("$response");
      if ((response['items'] as List).isNotEmpty) {
        List newItems = response['items'];
        for (Map<String, dynamic> item in newItems) {
          bool exists = feeVoucherChildList.any(
              (enrollment) => enrollment['asse_er_id'] == item['asse_er_id']);
          if (!exists) {
            feeVoucherChildList.add(item);
          }
        }

        feeVoucherChildHasPage.value = response['hasMore'];

        if (feeVoucherChildHasPage.value) {
          var link = (response['links'] as List)
              .firstWhere((links) => links['rel'] == 'next');

          if (link['rel'] == 'next' && link['href'] != null) {
            var nextPage = link['href'] as String;
            feeVoucherChildListPageOffset.value = nextPage.contains('&offset=')
                ? int.parse(nextPage.split('&offset=')[1])
                : feeVoucherChildListPageOffset.value;
          }
        }
      }

      feeVoucherChildListLoading.value = false;
    } catch (error) {
      log("Error $error");
      feeVoucherChildListLoading.value = false;
    }
  }

  RxDouble downloadProgress = 0.0.obs;

  RxString filePathLocation = "".obs;
  Future<void> downloadFeeVoucher() async {
    pdfLoading.value = true;
    await _storageService.init();
    var pComId = _storageService.read('comId').toString();
    var pUsername = _storageService.read('user').toString();
    var monthId = feeVoucherMonthList.firstWhere(
      (element) =>
          element['asgm_mont_date'] == feeVoucherMonthListController.text,
    )['asgm_mont_id'];
    var sessionId = feeVoucherSessionList.firstWhere(
      (element) =>
          element['ar_desc_name'] == feeVoucherSessionListController.text,
    )['ar_ref_id'];
    var classId = feeVoucherClassList.firstWhere(
      (element) =>
          element['asc_class_name'] == feeVoucherClassListController.text,
    )['asc_class_id'];
    var studentId = feeVoucherChildList.firstWhere(
      (element) => element['std_name'] == feeVoucherChildListController.text,
    )['asse_er_id'];

    var response = await _apiService.download(
        port: Port.port1500,
        "/VOUCHER_GEN&standAlone=true&ParentFolderUri=/reports&output=pdf&j_username=demo&j_password=demo&P0_COM_ID=$pComId&P_USER=$pUsername&P_SESSION=$sessionId&P_CLASS=$classId&P_MONTH=$monthId&P_STD_ID=$studentId",
        saveFilePath:
            '/FeeVoucher${DateTime.now().day}0${DateTime.now().month}0${DateTime.now().year}.pdf',
        onProgress: (progress) {
      downloadProgress.value =
          double.parse(progress.toString()); // Update progress observable
    });
    if (response != null) {
      filePathLocation.value = response;
      pdfLoading.value = false;
      Get.to(() => PdfScreen(
            pdfLocation: filePathLocation.value,
          ));
    }
  }

  @override
  void onInit() {
    getFeeVoucherMonthList();
    getfeeVoucherSessionList();
    getfeeVoucherClassList();
    feeVoucherMonthListScrollController.addListener(() {
      if (feeVoucherMonthListScrollController.position.pixels ==
          feeVoucherMonthListScrollController.position.maxScrollExtent) {
        pagination(feeVoucherMonthHasPage.value, feeVoucherMonthHasPage.value,
            getFeeVoucherMonthList);
      }
    });
    feeVoucherSessionListScrollController.addListener(() {
      if (feeVoucherSessionListScrollController.position.pixels ==
          feeVoucherSessionListScrollController.position.maxScrollExtent) {
        pagination(feeVoucherSessionHasPage.value,
            feeVoucherSessionHasPage.value, getfeeVoucherSessionList);
      }
    });
    feeVoucherClassListScrollController.addListener(() {
      if (feeVoucherClassListScrollController.position.pixels ==
          feeVoucherClassListScrollController.position.maxScrollExtent) {
        pagination(feeVoucherClassHasPage.value, feeVoucherClassHasPage.value,
            getfeeVoucherClassList);
      }
    });
    feeVoucherChildListScrollController.addListener(() {
      if (feeVoucherChildListScrollController.position.pixels ==
          feeVoucherChildListScrollController.position.maxScrollExtent) {
        pagination(feeVoucherChildHasPage.value, feeVoucherChildHasPage.value,
            getfeeVoucherAsChildList);
      }
    });

    feeVoucherChildListController.addListener(() {
      if (feeVoucherChildListController.text.isNotEmpty) {
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
