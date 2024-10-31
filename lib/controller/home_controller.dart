import 'dart:convert';
import 'dart:developer';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class HomeController extends GetxController with GetTickerProviderStateMixin {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();
  RxList parentChildList = [].obs,
      parentChildImageList = [].obs,
      profileList = [].obs,
      newsAlertList = [].obs /*classSessionList = [].obs*/;
  RxBool parentChildLoading = true.obs,
      parentChildImageLoading = true.obs,
      profileListLoading = true.obs,
      newsAlertLoading = true.obs;

  RxString companyName = "".obs, companyImage = "".obs, pUser = "".obs;
  RxInt parentChildCurrentIndex = 0.obs, notificationCount = 0.obs;
  final CarouselSliderController bannerController = CarouselSliderController();
  late PageController pageController;
  // final ScrollController homeMenuScrollController = ScrollController();

  @override
  void onInit()  {
    pageController = PageController(viewportFraction: 0.65);
     getUserName();
     getCompanyName();
     getCompanyLogo();
     getCompanyNewsReportList();
     getNotificationCount();
     getProfile();
     getParentChildList().whenComplete(() async {
      for (var element in parentChildList) {
        await getParentChildImages(element['std_id']);
      }
      parentChildImageLoading.value = false;
    });

    super.onInit();
  }

  @override
  void dispose() {
    Get.delete<HomeController>();
    super.dispose();
  }

  getUserName() async {
    await _storageService.init();
    pUser.value = await _storageService.read('user');
  }

  Future<void> getCompanyName() async {
    await _storageService.init();
    var pComId = await _storageService.read('comId');
    var pMainCompany = await _storageService.read('mainCompany');
    try {
      var response = await _apiService
          .get("/companyname?P_MAIN_COMPANY=$pMainCompany&P_COM_ID=$pComId");
      if ((response['items'] as List).isNotEmpty) {
        companyName.value = response['items'][0]['company_name'];
      }
      companyName.value = response['items'][0]['company_name'];
      // companyImage.value =
      //     response['items'][0]['asc_company_logo'].toString().split(',').last;
    } catch (error) {
      log("Error: $error");
    }
  }

  Future<void> getCompanyLogo() async {
    await _storageService.init();
    var pMainCompany = await _storageService.read('mainCompany');

    try {
      final response = await _apiService
          .get("/companynamelogo?P_MAIN_COMPANY=$pMainCompany");
      if ((response['items'] as List).isNotEmpty) {
        companyImage.value =
            response['items'][0]['asc_company_logo'].toString().split(',').last;
      }
    } catch (error) {
      log("Error: $error");
    }
  }

  Future<void> getProfile() async {
    await _storageService.init();
    var pMainComId = await _storageService.read('mainCompany');
    var pUsername = await _storageService.read('user');
    try {
      var response = await _apiService.get(
          "/SCH_USER_PROFILE_DTL?P_USERNAME=$pUsername&P_MAIN_COM_ID=$pMainComId");
      profileList.value = response['items'];

      profileListLoading.value = false;
    } catch (error) {
      profileListLoading.value = false;
      log("Error: $error");
    }
  }

  Future<void> getNotificationCount() async {
    notificationCount.value = 0;
    _storageService.init();
    var pComId = await _storageService.read('comId');
    var pUsername = await _storageService.read('user');

    try {
      var response = await _apiService
          .get('/SCH_NOTIFICATION?P_COM_ID=$pComId&P_USERNAME=$pUsername');

      if ((response['items'] as List).isNotEmpty) {
        for (int i = 0; i < (response['items'] as List).length; i++) {
          if (response['items'][i]['asn_not_status'] == 0 ||
              response['items'][i]['asn_not_status'] == null) {
            notificationCount.value++;
          }
        }
      }
    } catch (error) {
      log("Error: $error");
    }
  }

  Future<void> getParentChildList() async {
    await _storageService.init();
    var pComId = await _storageService.read('comId');
    var pUsername = await _storageService.read('user');
    try {
      var response = await _apiService
          .get("/PT_PARENT_CHILD_LIST?P_USERNAME=$pUsername&P_COM_ID=$pComId");
      parentChildList.value = response['items'];
      parentChildLoading.value = false;
    } catch (error) {
      parentChildLoading.value = false;
      log("Error: $error");
    }
  }

  Future<void> getParentChildImages(int studentId) async {
    await _storageService.init();
    var pComId = await _storageService.read('comId');

    try {
      final response = await _apiService
          .get("/PT_CHILD_PIC?P_COM_ID=$pComId&&P_STD_ID=$studentId");
      if ((response['items'] as List).isNotEmpty) {
        parentChildImageList.add(base64Decode(
            response['items'][0]['stud_fileblob'].toString().split(',').last));
      }
    } catch (error) {
      log("Error: $error");
    }
  }

  // getChildClassSession(int stuId) async {
  //   await _storageService.init();
  //   var pComId = await _storageService.read('comId');
  //   try {
  //     var response = await _apiService
  //         .get("/PT_CHILD_CLASS_SESSION?P_COM_ID=$pComId&P_STD_ID=$stuId");
  //     classSessionList.add(response['items'][0]);
  //     log("message----- $classSessionList");
  //   } catch (error) {
  //     log("Error: $error");
  //   }
  // }

  Future<void> getCompanyNewsReportList() async {
    await _storageService.init();
    var pComId = await _storageService.read('comId');

    try {
      var response =
          await _apiService.get("/COMPANY_NEWS_REPORT?P_COM_ID=$pComId");
      newsAlertList.value = response['items'];
      newsAlertLoading.value = false;
      log("message--- $newsAlertList");
    } catch (error) {
      newsAlertLoading.value = false;
      log("Error: $error");
    }
  }
}
