import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../screens/pdf_screen.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class AdditionalFeeVoucherController extends GetxController {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();
  late ScrollController additionalFeeVouchersListScrollController =
      ScrollController();
  final TextEditingController searchAdditionalFeeVouchersListController =
      TextEditingController();
  RxList<Map<String, dynamic>> additionalFeeVouchersList =
      <Map<String, dynamic>>[].obs;
  RxBool additionalFeeVouchersHasPage = true.obs,
      additionalFeeVouchersListLoading = true.obs,
      pdfLoading = false.obs;
  RxInt additionalFeeVouchersListPageOffset = 0.obs;

  Future<void> getAdditionalFeeVouchersList() async {
    await _storageService.init();
    var pComId = _storageService.read('comId').toString();

    try {
      var response = await _apiService.get(
          "/PT_PARENT_ADDTIONAL_FEE_VCH?P_COM_ID=$pComId&offset=${additionalFeeVouchersListPageOffset.value}");

      if ((response['items'] as List).isNotEmpty) {
        List newItems = response['items'];
        for (Map<String, dynamic> item in newItems) {
          bool exists = additionalFeeVouchersList.any((enrollment) =>
              enrollment['asafv_add_id'] == item['asafv_add_id']);
          if (!exists) {
            additionalFeeVouchersList.add(item);
          }
        }

        additionalFeeVouchersHasPage.value = response['hasMore'];

        if (additionalFeeVouchersHasPage.value) {
          var link = (response['links'] as List)
              .firstWhere((links) => links['rel'] == 'next');

          if (link['rel'] == 'next' && link['href'] != null) {
            var nextPage = link['href'] as String;
            additionalFeeVouchersListPageOffset.value =
                nextPage.contains('&offset=')
                    ? int.parse(nextPage.split('&offset=')[1])
                    : additionalFeeVouchersListPageOffset.value;
          }
        }
      }

      additionalFeeVouchersListLoading.value = false;
    } catch (error) {
      additionalFeeVouchersListLoading.value = false;
    }
  }

  RxDouble downloadProgress = 0.0.obs;
  RxString filePathLocation = "".obs;

  Future<void> downloadAdditionalFeeVoucher({int? addtionalVoucherId}) async {
    pdfLoading.value = true;
    await _storageService.init();
    var pComId = _storageService.read('comId').toString();
    var pUsername = _storageService.read('user').toString();
    var response = await _apiService.download(
        port: Port.port1500,
        "/ADD_VCH_GEN&standAlone=true&ParentFolderUri=/reports&output=pdf&j_username=demo&j_password=demo&P_ADD_ID=$addtionalVoucherId&P0_COM_ID=$pComId&P_USER=$pUsername",
        saveFilePath:
            '/AdditionalFeeVoucher${DateTime.now().day}0${DateTime.now().month}0${DateTime.now().year}.pdf',
        onProgress: (progress) {
      downloadProgress.value = double.parse(progress.toString());
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
    getAdditionalFeeVouchersList();
    super.onInit();
  }
}
