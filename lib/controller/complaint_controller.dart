import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parent_app_by_ats/component/custom_snackbar.dart';
import 'package:parent_app_by_ats/services/api_service.dart';
import 'package:parent_app_by_ats/services/storage_service.dart';

class ComplaintController extends GetxController {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();
  RxBool complaintLoading = true.obs, chatLoading = true.obs;
  RxList complaintList = [].obs, chatList = [].obs;

  final TextEditingController descriptionController = TextEditingController(),
      remarksController = TextEditingController(),
      replyController = TextEditingController();

  final GlobalKey<FormState> createComplainGlobalFormKey =
      GlobalKey<FormState>();

  @override
  void onInit() {
    getComplaintList();
    super.onInit();
  }

  Future<void> getComplaintList() async {
    await _storageService.init();
    var pComId = _storageService.read('comId').toString();
    var pUsername = _storageService.read('user');

    try {
      var response = await _apiService.get(
          "/PT_PARENT_COMPLAINT_REPORT?P_COM_ID=$pComId&P_USERNAME=$pUsername");
      complaintList.value = response['items'];
      complaintLoading.value = false;
    } catch (error) {
      complaintLoading.value = false;
      log("Error: $error");
    }
  }

  Future<void> createComplaint() async {
    await _storageService.init();
    var pComId = _storageService.read('comId').toString();
    var pUsername = _storageService.read('user');
    var request = {
      "P_COM_ID": pComId,
      "P_USERNAME": pUsername,
      "P_DESC": descriptionController.text,
      "P_REMARKS": remarksController.text,
    };
    try {
      var response =
          await _apiService.post("/PT_PARENT_COMPLAINT_REPORT", request);
      if (response['Result'] == "Success") {
        Get.back();
        complaintLoading.value = true;
        getComplaintList();
        CustomeSnackbar.showSnackbar(
          title: response['Result'],
          message: "Complaint submitted",
          backgroundColor: Colors.green,
          textColor: Colors.white,
          duration: const Duration(seconds: 2),
        );
      } else {
        Get.back();
        CustomeSnackbar.showSnackbar(
          title: response['Result'],
          message: "Complain submission failed",
          backgroundColor: Colors.green,
          textColor: Colors.white,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (error) {
      Get.back();
      CustomeSnackbar.showSnackbar(
        title: "Error",
        message: "NetWork Issue",
        backgroundColor: Colors.green,
        textColor: Colors.white,
        duration: const Duration(seconds: 2),
      );
      log("Error: $error");
    }
  }

  Future<void> markAsResolvedComplaint(String complaintId) async {
    await _storageService.init();
    var pComId = _storageService.read('comId').toString();
    var pUsername = _storageService.read('user');
    var request = {
      "P_COM_ID": pComId,
      "P_USERNAME": pUsername,
      "P_COMPLAINT_ID": complaintId,
    };
    try {
      var response = await _apiService.post(
          "/PT_PARENT_COMPLAINT_REPORT_RESOVLED", request);
      if (response['Result'] == "Success") {
        complaintLoading.value = true;
        getComplaintList();
        CustomeSnackbar.showSnackbar(
          title: response['Result'],
          message: "Complaint resolved",
          backgroundColor: Colors.green,
          textColor: Colors.white,
          duration: const Duration(seconds: 2),
        );
      } else {
        CustomeSnackbar.showSnackbar(
          title: response['Result'],
          message: "Complain resolved failed",
          backgroundColor: Colors.green,
          textColor: Colors.white,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (error) {
      Get.back();
      CustomeSnackbar.showSnackbar(
        title: "Error",
        message: "NetWork Issue",
        backgroundColor: Colors.green,
        textColor: Colors.white,
        duration: const Duration(seconds: 2),
      );
      log("Error: $error");
    }
  }
}
