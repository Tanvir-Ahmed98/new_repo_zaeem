import 'dart:developer';

import 'package:get/get.dart';

import '../services/api_service.dart';
import '../services/storage_service.dart';

class DashBoardController extends GetxController {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();
  RxList dashboardList = [].obs;
  RxBool dashboardLoading = true.obs;

  @override
  void onInit() {
    getDashboard();
    super.onInit();
  }

  Future<void> getDashboard() async {
    await _storageService.init();
    var pComId = await _storageService.read('comId');
    dashboardList.clear();

    try {
      var response =
          await _apiService.get("/COURSE_STD_DASH_SHOW?P_COM_ID=$pComId");
      dashboardList.value = response['items'];
      dashboardLoading.value = false;
    } catch (error) {
      dashboardLoading.value = false;
      log("Error: $error");
    }
  }
}
