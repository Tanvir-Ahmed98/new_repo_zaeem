
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parent_app_by_ats/controller/fee_voucher_controller.dart';
import '../component/custome_paginated_dropdown.dart';
import '../component/custome_text.dart';
import '../utils/color_const.dart';
import 'pdf_screen.dart';

class FeeVoucherScreen extends GetView<FeeVoucherController> {
  const FeeVoucherScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        backgroundColor: Colors.transparent,
        title: Text('Fee Voucher'),
      ),
      body: FilterPage(controller: controller),
    );
  }
}

class FilterPage extends StatelessWidget {
  final FeeVoucherController controller;
  const FilterPage({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Month Dropdown
            SizedBox(height: 20),
            Obx(
              () => Visibility(
                  visible: controller.feeVoucherMonthList.isNotEmpty,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomeText(
                        text: 'Select Month*',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      CustomPaginatedDropDown(
                        tooltipController:
                            controller.feeVoucherMonthListTooltipController,
                        link: controller.feeVoucherMonthListLink,
                        setActiveController: controller.setActiveController,
                        scrollController:
                            controller.feeVoucherMonthListScrollController,
                        hasPage: controller.feeVoucherMonthHasPage.value,
                        dropDownMenuItemList: controller.feeVoucherMonthList,
                        dropDownMenuItemDataKey: 'asgm_mont_date',
                        dropdownItemSelectionController:
                            controller.feeVoucherMonthListController,
                        hintText:
                            controller.feeVoucherMonthListController.text != ""
                                ? controller.feeVoucherMonthListController.text
                                : "Month",
                        labelText: "Month",
                        searchTextController:
                            controller.searchfeeVoucherMonthListController,
                        searchLoading:
                            controller.feeVoucherMonthListLoading.value,
                        searchOnTap: () {
                          // controller.getBankLovs(
                          //     offset: 0,
                          //     searchtext: controller.bankLovSearchController.text);
                        },
                        validatorText: "Please select month",
                      ),
                    ],
                  )),
            ),
            // Session Dropdown
            SizedBox(height: 20),
            // Session Dropdown
            Obx(
              () => Visibility(
                  visible: controller.feeVoucherSessionList.isNotEmpty,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomeText(
                        text: 'Select Session*',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      CustomPaginatedDropDown(
                        tooltipController:
                            controller.feeVoucherSessionListTooltipController,
                        link: controller.feeVoucherSessionListLink,
                        setActiveController: controller.setActiveController,
                        scrollController:
                            controller.feeVoucherSessionListScrollController,
                        hasPage: controller.feeVoucherSessionHasPage.value,
                        dropDownMenuItemList: controller.feeVoucherSessionList,
                        dropDownMenuItemDataKey: 'ar_desc_name',
                        dropdownItemSelectionController:
                            controller.feeVoucherSessionListController,
                        hintText: controller
                                    .feeVoucherSessionListController.text !=
                                ""
                            ? controller.feeVoucherSessionListController.text
                            : "Session",
                        labelText: "Session",
                        searchTextController:
                            controller.searchfeeVoucherSessionListController,
                        searchLoading:
                            controller.feeVoucherSessionListLoading.value,
                        searchOnTap: () {
                          // controller.getBankLovs(
                          //     offset: 0,
                          //     searchtext: controller.bankLovSearchController.text);
                        },
                        validatorText: "Please select session",
                      ),
                    ],
                  )),
            ),
            SizedBox(height: 20),
            //Class Dropdown
            Obx(() {
              return Visibility(
                visible: controller.feeVoucherClassList.isNotEmpty,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomeText(
                      text: 'Select Class*',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    CustomPaginatedDropDown(
                      otherComponentIsDependendOnThis: () {
                        controller.feeVoucherChildListController.clear();
                        controller.feeVoucherChildList.clear();
                        controller.downloadProgress.value = 0;
                        controller.enableFilterAttendanceButton.value = false;
                        controller.filePathLocation.value = "";
                        controller.getfeeVoucherAsChildList();
                      },
                      tooltipController:
                          controller.feeVoucherClassListTooltipController,
                      link: controller.feeVoucherClassListLink,
                      setActiveController: controller.setActiveController,
                      scrollController:
                          controller.feeVoucherClassListScrollController,
                      hasPage: controller.feeVoucherClassHasPage.value,
                      dropDownMenuItemList: controller.feeVoucherClassList,
                      dropDownMenuItemDataKey: 'asc_class_name',
                      dropdownItemSelectionController:
                          controller.feeVoucherClassListController,
                      hintText:
                          controller.feeVoucherClassListController.text != ""
                              ? controller.feeVoucherClassListController.text
                              : "Class",
                      labelText: "Class",
                      searchTextController:
                          controller.searchfeeVoucherClassListController,
                      searchLoading:
                          controller.feeVoucherClassListLoading.value,
                      searchOnTap: () {
                        // controller.getBankLovs(
                        //     offset: 0,
                        //     searchtext: controller.bankLovSearchController.text);
                      },
                      validatorText: "Please select class",
                    ),
                  ],
                ),
              );
            }),
            SizedBox(height: 20),
            // Child Dropdown
            Obx(
              () => Visibility(
                visible: controller.feeVoucherChildList.isNotEmpty,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomeText(
                      text: 'Select Child*',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    CustomPaginatedDropDown(
                      tooltipController:
                          controller.feeVoucherChildListTooltipController,
                      link: controller.feeVoucherChildListLink,
                      setActiveController: controller.setActiveController,
                      scrollController:
                          controller.feeVoucherChildListScrollController,
                      hasPage: controller.feeVoucherChildHasPage.value,
                      dropDownMenuItemList: controller.feeVoucherChildList,
                      dropDownMenuItemDataKey: 'std_name',
                      dropdownItemSelectionController:
                          controller.feeVoucherChildListController,
                      hintText:
                          controller.feeVoucherChildListController.text != ""
                              ? controller.feeVoucherChildListController.text
                              : "Student",
                      labelText: "Student",
                      searchTextController:
                          controller.searchfeeVoucherChildListController,
                      searchLoading:
                          controller.feeVoucherChildListLoading.value,
                      searchOnTap: () {
                        // controller.getBankLovs(
                        //     offset: 0,
                        //     searchtext: controller.bankLovSearchController.text);
                      },
                      validatorText: "Please select child",
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Obx(
              () => Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width - 32,
                    child: ElevatedButton(
                      onPressed:
                          controller.enableFilterAttendanceButton.value == false
                              ? null
                              : controller.filePathLocation.isNotEmpty
                                  ? () {
                                      Get.to(() => PdfScreen(
                                            pdfLocation: controller
                                                .filePathLocation.value,
                                          ));
                                    }
                                  : () async {
                                      // log("${controller.pdfDownLoading.value}");
                                      controller.downloadFeeVoucher();
                                    },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.redColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 10,
                      ),
                      child: controller.pdfLoading.value == true
                          ? Stack(
                              alignment: Alignment
                                  .center, // Center the text inside the circle
                              children: [
                                SizedBox(
                                  width:
                                      40, // Set the size of the CircularProgressIndicator
                                  height: 40,
                                  child: CircularProgressIndicator(
                                    value:
                                        controller.downloadProgress.value / 100,
                                    strokeWidth: 3,
                                    color: Colors.green,
                                    backgroundColor: Colors.blueGrey,
                                  ),
                                ),
                                Text(
                                  '${controller.downloadProgress.value.toStringAsFixed(0)}%', // Show the percentage value
                                  style: TextStyle(
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Colors.black, // Adjust color if needed
                                  ),
                                ),
                              ],
                            )
                          : controller.downloadProgress.value == 100.0 &&
                                  controller.filePathLocation.value != ""
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 24,
                                    ),
                                    const CustomeText(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      text: 'View Result',
                                      color: AppColors.whiteColor,
                                    ),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.download,
                                      color: AppColors.whiteColor,
                                    ),
                                    SizedBox(
                                      width: 24,
                                    ),
                                    const CustomeText(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      text: 'Download Fee Voucher',
                                      color: AppColors.whiteColor,
                                    ),
                                  ],
                                ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
