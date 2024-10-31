import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parent_app_by_ats/component/custome_shimmer_loading.dart';
import 'package:parent_app_by_ats/component/custome_textformfield.dart';
import 'package:parent_app_by_ats/component/date_time_widget.dart';
import 'package:parent_app_by_ats/component/empty_information_widget.dart';
import 'package:parent_app_by_ats/controller/complaint_controller.dart';
import 'package:slide_to_act/slide_to_act.dart';

import '../component/custome_floating_button.dart';
import '../component/custome_text.dart';
import '../services/routes_path.dart';
import '../utils/color_const.dart';

class ComplaintScreen extends GetView<ComplaintController> {
  const ComplaintScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: false,
        title: Text('Complaints'),
        backgroundColor: Colors.transparent,
      ),
      floatingActionButton: CustomeFloatingActonButton(
        mediaQuery: MediaQuery.of(context),
        onPressed: () {
          Get.bottomSheet(CreateComplaintWidget(controller: controller));
        },
        buttonHeight: 60,
        buttonWidth: 60,
        icon: Icons.add_box_rounded,
        iconSize: 30,
      ),
      body: Obx(
        () {
          if (controller.complaintLoading.value) {
            return ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: 10,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        // Colors.tealAccent,
                        Colors.teal,
                        // Colors.greenAccent,
                        Colors.green,
                        Colors.lightGreen,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerLoading(
                          child: Container(
                            height: 18,
                            width: 250,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        ShimmerLoading(
                          child: Container(
                              height: 18,
                              width: 200,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15))),
                        ),
                        SizedBox(height: 8),
                        ShimmerLoading(
                          child: Container(
                              height: 18,
                              width: 100,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15))),
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: null,
                                icon:
                                    Icon(Icons.visibility, color: Colors.white),
                                label: CustomeText(
                                  text: 'View Complaint',
                                  color: AppColors.whiteColor,
                                  textAlign: TextAlign.center,
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orangeAccent,
                                ),
                              ),
                            ),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: null,
                                icon: Icon(Icons.check_circle,
                                    color: Colors.white),
                                label: CustomeText(
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                  text: 'Mark as Resolved',
                                  color: AppColors.whiteColor,
                                  textAlign: TextAlign.center,
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (controller.complaintList.isEmpty) {
            return EmptyInformationWidget(
              title: "No data.",
              height: MediaQuery.of(context).size.height * 0.3,
            );
          } else {
            return ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: controller.complaintList.length,
              itemBuilder: (context, index) {
                final complaint = controller.complaintList[index];
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        // Colors.tealAccent,
                        Colors.teal,
                        // Colors.greenAccent,
                        Colors.green,
                        Colors.lightGreen,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Complaint No: ${complaint['complaint_no']}',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Description: ${complaint['descriptionn']}',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        Text(
                          'Remarks: ${complaint['remarks']}',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Get.bottomSheet(    
                                    ViewComplaintWidget(complaint: complaint),
                                  );
                                },
                                icon:
                                    Icon(Icons.visibility, color: Colors.white),
                                label: CustomeText(
                                  text: 'View Complaint',
                                  color: AppColors.whiteColor,
                                  textAlign: TextAlign.center,
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orangeAccent,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: complaint['status'] ==
                                        "Complaint Resolved"
                                    ? () {}
                                    : () {
                                        controller.markAsResolvedComplaint(
                                          complaint['complaint_id'].toString(),
                                        );
                                      },
                                icon: Icon(
                                    complaint['status'] == "Complaint Resolved"
                                        ? Icons.check_circle
                                        : Icons.close_outlined,
                                    color: Colors.white),
                                label: CustomeText(
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                  text: complaint['status'] ==
                                          "Complaint Resolved"
                                      ? "Resolved"
                                      : 'Mark as Resolved',
                                  color: AppColors.whiteColor,
                                  textAlign: TextAlign.center,
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: complaint['status'] ==
                                          "Complaint Resolved"
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              Get.toNamed(
                                RoutePath.chatPath,
                                arguments: complaint['complaint_id'].toString(),
                              );
                            },
                            icon: Icon(Icons.chat_bubble, color: Colors.white),
                            label: CustomeText(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              text: 'Chat',
                              color: AppColors.whiteColor,
                              textAlign: TextAlign.center,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class CreateComplaintWidget extends StatelessWidget {
  const CreateComplaintWidget({
    super.key,
    required this.controller,
  });

  final ComplaintController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: Form(
        key: controller.createComplainGlobalFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Column(
                children: [
                  CustomeTextFormField(
                    controller: controller.descriptionController,
                    hintText: 'Description',
                    labelText: "Description",
                    validatorText: "Please, add your description",
                    borderColor: AppColors.greyColor,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomeTextFormField(
                    controller: controller.remarksController,
                    hintText: 'Remarks',
                    labelText: "Remarks",
                    validatorText: "Please, add your remarks",
                    borderColor: AppColors.greyColor,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SlideAction(
                height: 40,
                sliderButtonIconSize: 20,
                sliderButtonIconPadding: 4,
                borderRadius: 20,
                elevation: 10,
                innerColor: AppColors.whiteColor,
                outerColor: AppColors.greenColor,
                text: "Submit",
                onSubmit: () {
                  if (controller.createComplainGlobalFormKey.currentState!
                      .validate()) {
                    controller.createComplainGlobalFormKey.currentState!.save();
                    controller.createComplaint();
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ViewComplaintWidget extends StatelessWidget {
  const ViewComplaintWidget({
    super.key,
    required this.complaint,
  });

  final Map<String, dynamic> complaint;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.confirmation_number, color: Colors.black),
                SizedBox(width: 8),
                Expanded(
                  child: CustomeText(
                    text: 'Complaint No: ${complaint["complaint_no"]}',
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.description, color: Colors.black),
                SizedBox(width: 8),
                Expanded(
                  child: CustomeText(
                    text: 'Description: ${complaint["descriptionn"]}',
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.comment, color: Colors.black),
                SizedBox(width: 8),
                Expanded(
                  child: CustomeText(
                    text: 'Remarks: ${complaint["remarks"]}',
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.flag, color: Colors.black),
                SizedBox(width: 8),
                Expanded(
                  child: CustomeText(
                    text: 'Status: ${complaint["status"]}',
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.info_outline, color: Colors.black),
                SizedBox(width: 8),
                Expanded(
                  child: CustomeText(
                    text: 'Status Details: ${complaint["status_detail"]}',
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.black),
                SizedBox(width: 8),
                Expanded(
                  child: CustomeText(
                    text:
                        'Complaint Date: ${DateTimeWidget.dateTimeFormat(complaint["complaint_date"]) ?? ""} ${DateTimeWidget.timeFormat(complaint["complaint_date"]) ?? ""}',
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
