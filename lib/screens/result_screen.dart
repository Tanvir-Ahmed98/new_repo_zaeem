import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parent_app_by_ats/controller/result_controller.dart';
import 'package:parent_app_by_ats/screens/pdf_screen.dart';
import 'package:parent_app_by_ats/utils/color_const.dart';
import '../component/custome_paginated_dropdown.dart';
import '../component/custome_text.dart';

class ResultScreen extends GetView<ResultController> {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          backgroundColor: Colors.transparent,
          title: Text('Result Report'),
        ),
        body: FilterPage(controller: controller));
  }
}

class FilterPage extends StatelessWidget {
  final ResultController controller;
  const FilterPage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Session Dropdown
            Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (controller.studentSessionList.isNotEmpty)
                    CustomeText(
                      text: 'Select Session*',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  if (controller.studentSessionList.isNotEmpty)
                    CustomPaginatedDropDown(
                      tooltipController:
                          controller.studentSessionListTooltipController,
                      link: controller.studentSessionListLink,
                      setActiveController: controller.setActiveController,
                      scrollController:
                          controller.studentSessionListScrollController,
                      hasPage: controller.studentSessionHasPage.value,
                      dropDownMenuItemList: controller.studentSessionList,
                      dropDownMenuItemDataKey: 'ar_desc_name',
                      dropdownItemSelectionController:
                          controller.studentSessionListController,
                      hintText:
                          controller.studentSessionListController.text != ""
                              ? controller.studentSessionListController.text
                              : "Session",
                      labelText: "Session",
                      searchTextController:
                          controller.searchStudentSessionListController,
                      searchLoading: controller.studentSessionListLoading.value,
                      searchOnTap: () {
                        // controller.getBankLovs(
                        //     offset: 0,
                        //     searchtext: controller.bankLovSearchController.text);
                      },
                      validatorText: "Please select session",
                    ),
                ],
              ),
            ),
            SizedBox(height: 20),
            //Class Dropdown
            Obx(() {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (controller.studentClassList.isNotEmpty)
                    CustomeText(
                      text: 'Select Class*',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  if (controller.studentClassList.isNotEmpty)
                    CustomPaginatedDropDown(
                      otherComponentIsDependendOnThis: () {
                        controller.studentChildListController.clear();
                        controller.studentChildList.clear();
                        controller.downloadProgress.value = 0.0;
                        controller.enableFilterAttendanceButton.value = false;
                        controller.filePathLocation.value = "";
                        controller.getStudentAsChildList();
                      },
                      tooltipController:
                          controller.studentClassListTooltipController,
                      link: controller.studentClassListLink,
                      setActiveController: controller.setActiveController,
                      scrollController:
                          controller.studentClassListScrollController,
                      hasPage: controller.studentClassHasPage.value,
                      dropDownMenuItemList: controller.studentClassList,
                      dropDownMenuItemDataKey: 'asc_class_name',
                      dropdownItemSelectionController:
                          controller.studentClassListController,
                      hintText: controller.studentClassListController.text != ""
                          ? controller.studentClassListController.text
                          : "Class",
                      labelText: "Class",
                      searchTextController:
                          controller.searchStudentClassListController,
                      searchLoading: controller.studentClassListLoading.value,
                      searchOnTap: () {
                        // controller.getBankLovs(
                        //     offset: 0,
                        //     searchtext: controller.bankLovSearchController.text);
                      },
                      validatorText: "Please select class",
                    ),
                ],
              );
            }),
            SizedBox(height: 20),
            Obx(
              () => Visibility(
                visible: controller.studentChildList.isNotEmpty,
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
                          controller.studentChildListTooltipController,
                      link: controller.studentChildListLink,
                      setActiveController: controller.setActiveController,
                      scrollController:
                          controller.studentChildListScrollController,
                      hasPage: controller.studentChildHasPage.value,
                      dropDownMenuItemList: controller.studentChildList,
                      dropDownMenuItemDataKey: 'std_name',
                      dropdownItemSelectionController:
                          controller.studentChildListController,
                      hintText: controller.studentChildListController.text != ""
                          ? controller.studentChildListController.text
                          : "Student",
                      labelText: "Student",
                      searchTextController:
                          controller.searchStudentChildListController,
                      searchLoading: controller.studentChildListLoading.value,
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
                                      controller.downloadReport();
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
                                      text: 'Download Result',
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
