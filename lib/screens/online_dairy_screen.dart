import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parent_app_by_ats/component/custome_shimmer_loading.dart';
import 'package:parent_app_by_ats/component/custome_text.dart';
import 'package:parent_app_by_ats/component/date_time_widget.dart';
import 'package:parent_app_by_ats/component/empty_information_widget.dart';
import 'package:pushable_button/pushable_button.dart';
import '../controller/online_dairy_controller.dart';
import '../utils/color_const.dart';

class OnlineDairyScreen extends GetView<OnlineDairyController> {
  const OnlineDairyScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        backgroundColor: Colors.transparent,
        title: Text("Student Dairy"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: PushableButton(
              height: 60,
              elevation: 8,
              hslColor: HSLColor.fromColor(Color(0xFF3CECA2)),
              shadow: BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 2),
              ),
              onPressed: () async {
                await DateTimeWidget.selectDateTime(context).then(
                  (value) async {
                    if (value != null) {
                      // Get.back();
                      controller.pDairyQueryDate =
                          "${value.day}-${DateTimeWidget.getMonthName(value.month)}-${value.year}";
                      controller.dairyLoading.value = true;
                      controller.getOnlineDariyList();
                    }
                  },
                );
              },
              child: CustomeText(
                text: 'Select another date',
                color: AppColors.whiteColor,
                fontSize: 24,
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.dairyLoading.value) {
                return ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 5,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF30cfd0), Color(0xFF330867)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ShimmerLoading(
                                  child: Align(
                                    child: Container(
                                      padding:
                                          EdgeInsets.all(4), // Border width
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      height: 150.0,
                                      width: 150.0,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 16),
                                Row(
                                  children: [
                                    Icon(Icons.calendar_today,
                                        color: Colors.white),
                                    SizedBox(width: 8),
                                    ShimmerLoading(
                                      child: Container(
                                        height: 16,
                                        width: 80,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.subject, color: Colors.white),
                                    SizedBox(width: 8),
                                    ShimmerLoading(
                                      child: Container(
                                        height: 16,
                                        width: 80,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.link, color: Colors.white),
                                    SizedBox(width: 8),
                                    ShimmerLoading(
                                      child: Container(
                                        height: 16,
                                        width: 80,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.description,
                                        color: Colors.white),
                                    SizedBox(width: 8),
                                    ShimmerLoading(
                                      child: Container(
                                        height: 16,
                                        width: 80,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.note, color: Colors.white),
                                    SizedBox(width: 8),
                                    ShimmerLoading(
                                      child: Container(
                                        height: 16,
                                        width: 80,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else if (controller.dairyList.isEmpty) {
                return Align(
                  alignment: Alignment.topCenter,
                  child: EmptyInformationWidget(
                    title: "No records are found. You can search another day",
                    height: MediaQuery.of(context).size.height * 0.2,
                    titleColor: AppColors.greyColor,
                    // color: AppColors.redColor,
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: controller.dairyList.length,
                  itemBuilder: (context, index) {
                    var dairyData = controller.dairyList[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 8),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 5,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF30cfd0), Color(0xFF330867)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                dairyData['ascsa_ass_fileblob'] != null
                                    ? Align(
                                        alignment: Alignment.center,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(
                                                  4), // Border width
                                              decoration: BoxDecoration(
                                                color: Colors.grey,
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                child: GestureDetector(
                                                    onTap: () =>
                                                        Get.dialog(Dialog(
                                                          insetPadding:
                                                              EdgeInsets.zero,
                                                          elevation: 10,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                          ),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15),
                                                              ),
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.5,
                                                              child:
                                                                  InteractiveViewer(
                                                                panEnabled:
                                                                    true,
                                                                boundaryMargin:
                                                                    EdgeInsets
                                                                        .all(0),
                                                                minScale: 0.1,
                                                                maxScale: 4.0,
                                                                child: Image
                                                                    .memory(
                                                                  base64Decode(dairyData[
                                                                          'ascsa_ass_fileblob']
                                                                      .toString()
                                                                      .split(
                                                                          ',')
                                                                      .last),
                                                                  fit: BoxFit
                                                                      .fill,
                                                                  height: 150.0,
                                                                  width: 150.0,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        )),
                                                    child: Image.memory(
                                                      base64Decode(dairyData[
                                                              'ascsa_ass_fileblob']
                                                          .toString()
                                                          .split(',')
                                                          .last),
                                                      fit: BoxFit.fill,
                                                      height: 150.0,
                                                      width: 150.0,
                                                    )),
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () => controller
                                                  .downloadAndSaveImageToGallery(
                                                      dairyData[
                                                              'ascsa_ass_fileblob']
                                                          .toString()
                                                          .split(',')
                                                          .last,
                                                      dairyData['assd_dy_id']
                                                          .toString()),
                                              icon: Icon(
                                                  Icons.download_for_offline,
                                                  size: 36,
                                                  color: AppColors.whiteColor),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Align(
                                        child: Container(
                                          padding:
                                              EdgeInsets.all(4), // Border width
                                          height: 150.0,
                                          width: 150.0,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: Colors.grey.shade300,
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: Icon(
                                              Icons.person,
                                              size: 80,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ),
                                SizedBox(height: 16),
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: AppColors.whiteColor,
                                      child: Icon(Icons.calendar_today,
                                          color: AppColors.blueColor),
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: SelectableText.rich(
                                        TextSpan(
                                          text: "Dairy Date:  ",
                                          style: TextStyle(
                                              color: Colors.amber,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                          children: [
                                            TextSpan(
                                              text:
                                                  "${DateTimeWidget.dateTimeFormat(dairyData['assd_dy_trx_date'])}",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: AppColors.whiteColor,
                                      child: Icon(Icons.subject,
                                          color: AppColors.blueColor),
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: SelectableText.rich(
                                        TextSpan(
                                          text: "Subject:  ",
                                          style: TextStyle(
                                              color: Colors.amber,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                          children: [
                                            TextSpan(
                                              text:
                                                  "${dairyData['ascsa_ass_ascse_sub_id'] ?? ""}",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: AppColors.whiteColor,
                                      child: Icon(Icons.link,
                                          color: AppColors.blueColor),
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: SelectableText.rich(
                                        TextSpan(
                                          text: "Links:  ",
                                          style: TextStyle(
                                              color: Colors.amber,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                          children: [
                                            TextSpan(
                                              text:
                                                  "${dairyData['assd_dy_links'] ?? ""}",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: AppColors.whiteColor,
                                      child: Icon(Icons.description,
                                          color: AppColors.blueColor),
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: SelectableText.rich(
                                        TextSpan(
                                          text: "Dairy:  ",
                                          style: TextStyle(
                                              color: Colors.amber,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                          children: [
                                            TextSpan(
                                              text:
                                                  "${dairyData['ascsa_ass_descr'] ?? ""}",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 16,
                                                letterSpacing: 0.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: AppColors.whiteColor,
                                      child: Icon(Icons.note,
                                          color: AppColors.blueColor),
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: SelectableText.rich(
                                        TextSpan(
                                          text: "Remarks:  ",
                                          style: TextStyle(
                                              color: Colors.amber,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                          children: [
                                            TextSpan(
                                              text:
                                                  "${dairyData['ascsa_ass_remarks'] ?? ""}",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            }),
          ),
        ],
      ),
    );
  }
}
