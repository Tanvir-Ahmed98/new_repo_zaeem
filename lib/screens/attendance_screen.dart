import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parent_app_by_ats/component/date_time_widget.dart';
import 'package:parent_app_by_ats/utils/color_const.dart';

import '../component/custome_paginated_dropdown.dart';
import '../component/custome_text.dart';
import '../component/custome_textformfield.dart';
import '../controller/attendance_controller.dart';
import '../services/routes_path.dart';

class AttendanceScreen extends GetView<AttendanceController> {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          backgroundColor: Colors.transparent,
          title: Text('Attendance'),
        ),
        body: FilterPage(controller: controller));
  }
}

class FilterPage extends StatelessWidget {
  final AttendanceController controller;
  const FilterPage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Month
            CustomeText(
              text: 'Select Month*',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            CustomeTextFormField(
              readOnly: true,
              controller: controller.selectDateWithOutDay,
              hintText:
                  "${DateTimeWidget.getMonthName(DateTime.now().month)}-${DateTime.now().year}",
              onTap: () => controller.selectDate(context),
            ),
            SizedBox(height: 20),
            // Session Dropdown
            Obx(
              () => Visibility(
                  visible: controller.studentSessionList.isNotEmpty,
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
                        searchLoading:
                            controller.studentSessionListLoading.value,
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
                visible: controller.studentClassList.isNotEmpty,
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
                        controller.studentChildListController.clear();
                        controller.studentChildList.clear();
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
                ),
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
                      onPressed: controller.enableFilterAttendanceButton.value
                          ? () async {
                              var studentId =
                                  controller.studentChildList.firstWhere(
                                (element) =>
                                    element['std_name'] ==
                                    controller.studentChildListController.text,
                              )['asse_er_id'];
                              controller.studentSessionListController.clear();
                              controller.studentClassListController.clear();
                              controller.studentChildListController.clear();
                              Get.offNamed(RoutePath.attendanceDetailsPath,
                                  arguments: [
                                    studentId,
                                    controller.selectedDay.value == "" &&
                                            controller.selectDateWithOutDay
                                                    .text ==
                                                ""
                                        ? "${DateTime.now().day}-${DateTimeWidget.getMonthName(DateTime.now().month)}-${DateTime.now().year}"
                                        : "${controller.selectedDay.value}-${controller.selectDateWithOutDay.text}"
                                  ]);
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.redColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 10,
                      ),
                      child: const CustomeText(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        text: 'Filter Attendance',
                        color: AppColors.whiteColor,
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
