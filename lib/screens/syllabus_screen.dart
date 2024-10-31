import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parent_app_by_ats/component/custome_text.dart';
import 'package:parent_app_by_ats/component/date_time_widget.dart';
import 'package:parent_app_by_ats/component/empty_information_widget.dart';
import '../component/custome_paginated_dropdown.dart';
import '../controller/syllabus_controller.dart';
import '../utils/color_const.dart';

class SyllabusScreen extends GetView<SyllabusController> {
  const SyllabusScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        backgroundColor: Colors.transparent,
        title: Text('Student Syllabus'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Session
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
                  const SizedBox(
                    height: 8,
                  ),
                  //Class
                  if (controller.studentClassList.isNotEmpty)
                    CustomeText(
                      text: 'Select Class*',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  if (controller.studentClassList.isNotEmpty)
                    CustomPaginatedDropDown(
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
                  const SizedBox(
                    height: 8,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  if (controller.studentTermList.isNotEmpty)
                    CustomeText(
                      text: 'Select Term*',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  if (controller.studentTermList.isNotEmpty)
                    CustomPaginatedDropDown(
                      tooltipController:
                          controller.studentTermListTooltipController,
                      link: controller.studentTermListLink,
                      setActiveController: controller.setActiveController,
                      scrollController:
                          controller.studentTermListScrollController,
                      hasPage: controller.studentTermHasPage.value,
                      dropDownMenuItemList: controller.studentTermList,
                      dropDownMenuItemDataKey: 'ar_desc_name',
                      dropdownItemSelectionController:
                          controller.studentTermListController,
                      hintText: controller.studentTermListController.text != ""
                          ? controller.studentTermListController.text
                          : "Term",
                      labelText: "Term",
                      searchTextController:
                          controller.searchStudentTermListController,
                      searchLoading: controller.studentTermListLoading.value,
                      searchOnTap: () {
                        // controller.getBankLovs(
                        //     offset: 0,
                        //     searchtext: controller.bankLovSearchController.text);
                      },
                      validatorText: "Please select term",
                    ),
                ],
              ),
            ),
            SizedBox(height: 20),
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
                        onPressed: controller.enableFilter.value == false
                            ? null
                            : () async {
                                // log("${controller.pdfDownLoading.value}");
                                // Get.toNamed(RoutePath.dashboardPath);
                                controller.getSyllabusList().whenComplete(() {
                                  Get.bottomSheet(
                                    enableDrag: true,
                                    isDismissible: true,
                                    enterBottomSheetDuration:
                                        const Duration(seconds: 1),
                                    exitBottomSheetDuration:
                                        const Duration(seconds: 1),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0),
                                    ),
                                    elevation: 5.00,
                                    isScrollControlled: true,
                                    SyllabusListWidget(
                                      controller: controller,
                                      height: (mediaQuery.size.height -
                                          kToolbarHeight -
                                          mediaQuery.padding.top),
                                    ),
                                  );
                                });
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.redColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 10,
                        ),
                        child: controller.syllabusLoading.value == false
                            ? const CustomeText(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                text: 'Filter Syllabus',
                                color: AppColors.whiteColor,
                              )
                            : CupertinoActivityIndicator(
                                radius: 20,
                                color: Colors.white,
                              )),
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

class SyllabusListWidget extends StatelessWidget {
  final SyllabusController controller;
  final double height;
  const SyllabusListWidget(
      {super.key, required this.controller, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if (controller.syllabusList.isEmpty) {
            return EmptyInformationWidget(title: "No data found");
          } else {
            return ListView.builder(
              itemCount: controller.syllabusHasPage.value
                  ? controller.syllabusList.length + 1
                  : controller.syllabusList.length,
              itemBuilder: (context, index) {
                final item = controller.syllabusList[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Card(
                    color: Colors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Subject: ${item['subject_desc'] ?? 'N/A'}",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Class: ${item['asss_sy_class_id'] ?? 'N/A'}",
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                                Text(
                                  "Term: ${item['asss_sy_term_ty'] ?? 'N/A'}",
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                                Text(
                                  "Session: ${item['asss_sy_session'] ?? 'N/A'}",
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Syllabus: ${item['asss_sy_sylbus'] ?? 'N/A'}",
                                  style: TextStyle(color: Colors.blueAccent),
                                ),
                                SizedBox(height: 8),
                                if (item['asss_sy_links'] != null)
                                  Text(
                                    "Link: ${item['asss_sy_links']}",
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                SizedBox(height: 8),
                                Text(
                                  "Created By: ${item['asss_sy_created_by'] ?? 'N/A'}",
                                  style: TextStyle(
                                      color: Colors.grey[500], fontSize: 12),
                                ),
                                Text(
                                  "Last Modified By: ${item['asss_sy_last_modified_by'] ?? 'N/A'}",
                                  style: TextStyle(
                                      color: Colors.grey[500], fontSize: 12),
                                ),
                                Text(
                                  "Created Date: ${DateTimeWidget.dateTimeFormat(item['asss_sy_created_date'] ?? '')} ${DateTimeWidget.timeFormat(item['asss_sy_created_date'] ?? '')}",
                                  style: TextStyle(
                                      color: Colors.grey[500], fontSize: 12),
                                ),
                                Text(
                                  "Last Modified Date: ${DateTimeWidget.dateTimeFormat(item['asss_sy_last_modified_date'] ?? '')} ${DateTimeWidget.timeFormat(item['asss_sy_last_modified_date'] ?? '')}",
                                  style: TextStyle(
                                      color: Colors.grey[500], fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          // Add image on the right side
                          SizedBox(width: 16),
                          Row(
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.all(2), // Border width
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 2,
                                    color: AppColors.defaultTextColor
                                        .withOpacity(0.5),
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: SizedBox.fromSize(
                                    size: const Size.square(85), // Image radius
                                    child: item['asss_sy_fileblob'] != null
                                        ? Image.memory(
                                            base64Decode(
                                                item['asss_sy_fileblob']
                                                    .toString()
                                                    .split(',')
                                                    .last),
                                            fit: BoxFit.fill,
                                            // height: 150.0,
                                            // width: 150.0,
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Icon(
                                              Icons.image,
                                              size: 80,
                                              color: AppColors.greyColor,
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                              if (item['asss_sy_fileblob'] != null)
                                IconButton(
                                  onPressed: () =>
                                      controller.downloadAndSaveImageToGallery(
                                    item['asss_sy_fileblob']
                                        .toString()
                                        .split(',')
                                        .last,
                                    item['asss_sy_id'].toString(),
                                  ),
                                  icon: Icon(Icons.download_for_offline,
                                      size: 36, color: AppColors.greenColor),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        }),
      ),
    );
  }
}
