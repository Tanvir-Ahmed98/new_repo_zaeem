import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/api_service.dart';
import '../services/storage_service.dart';

class VoucherFeeBalanceController extends GetxController {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();
  late ScrollController voucherFeeBalanceListScrollController =
      ScrollController();
  final TextEditingController voucherFeeBalanceSearchController =
      TextEditingController();
  RxList<Map<String, dynamic>> voucherFeeBalanceList =
      <Map<String, dynamic>>[].obs;
  RxBool voucherFeeBalanceHasPage = true.obs,
      voucherFeeBalanceListLoading = true.obs,
      pdfDownLoading = false.obs;
  RxInt voucherFeeBalanceListPageOffset = 0.obs, studentId = 0.obs;

  @override
  void onInit() {
    studentId.value = Get.arguments;
    getVoucherFeeBalanceList();
    super.onInit();
  }

  Future<void> getVoucherFeeBalanceList() async {
    await _storageService.init();
    var pComId = _storageService.read('comId');

    try {
      var response = await _apiService.get(
          "/PT_PARENT_FEE_STD_BALANCE?P_COM_ID=$pComId&P_STD_ID=$studentId&offset=${voucherFeeBalanceListPageOffset.value}");
      log("------------");
      if ((response['items'] as List).isNotEmpty) {
        List newItems = response['items'];
        for (Map<String, dynamic> item in newItems) {
          bool exists = voucherFeeBalanceList.any((enrollment) =>
              enrollment['asse_er_ass_stu_id'] == item['asse_er_ass_stu_id']);
          if (!exists) {
            voucherFeeBalanceList.add(item);
          }
        }

        voucherFeeBalanceHasPage.value = response['hasMore'];

        if (voucherFeeBalanceHasPage.value) {
          var link = (response['links'] as List)
              .firstWhere((links) => links['rel'] == 'next');

          if (link['rel'] == 'next' && link['href'] != null) {
            var nextPage = link['href'] as String;
            voucherFeeBalanceListPageOffset.value =
                nextPage.contains('&offset=')
                    ? int.parse(nextPage.split('&offset=')[1])
                    : voucherFeeBalanceListPageOffset.value;
          }
        }
      }

      voucherFeeBalanceListLoading.value = false;
    } catch (error) {
      voucherFeeBalanceListLoading.value = false;
    }
  }
}
