import 'dart:developer';
import 'package:parent_app_by_ats/component/empty_information_widget.dart';

import '../component/custome_text.dart';
import '../component/date_time_widget.dart';
import '../component/page_and_record_count_widget.dart';
import '../controller/notification_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/color_const.dart';

class NotificationScreen extends GetView<NotificationController> {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    return Obx(
      () => Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: false,
          backgroundColor: Colors.transparent,
          title: Text("Notifications"),
          actions: [
            Obx(
              () => CupertinoSwitch(
                value: controller.selectAll.value,
                onChanged: (value) {
                  log("$value");
                  controller.selectAll.value = value;
                  if (value) {
                    for (var notification in controller.notificationList) {
                      if (notification['asn_not_status'] == 0) {
                        controller.selectedNotifications
                            .add(notification['asn_not_id']);
                      }
                    }
                  } else {
                    controller.selectedNotifications.clear();
                  }
                },
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // CustomeTextFormField(
              //   controller: controller.searchNotificationListController,
              //   hintText: "Search notification",
              //   textInputAction: TextInputAction.done,
              //   onKeyBoardPressSubmitted: (value) =>
              //       controller.getNotificationList(offset: 0).then(
              //     (value) async {
              //       if (context.mounted) {
              //         FocusScope.of(context).unfocus();
              //       }
              //     },
              //   ),
              //   suffixIcon: GestureDetector(
              //     onTap: () => controller.getNotificationList(offset: 0).then(
              //       (value) async {
              //         if (context.mounted) {
              //           FocusScope.of(context).unfocus();
              //         }
              //       },
              //     ),
              //     child: const Icon(Icons.search),
              //   ),
              // ),
              const SizedBox(height: 8),
              PageAndRecordCountWidget(
                  count: controller.notificationCount.value),
              const SizedBox(height: 8),
              Expanded(
                child: !controller.notificationListLoading.value &&
                        controller.notificationList.isNotEmpty
                    ? ListView.builder(
                        controller: controller.notificationScrollController,
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: controller.notificationCount.value,
                        itemBuilder: (context, index) {
                          if (index == controller.notificationList.length) {
                            return const Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 2.0),
                                child: CircularProgressIndicator.adaptive(),
                              ),
                            );
                          }
                          return NotificationItem(
                            notificationId: controller.notificationList[index]
                                ['asn_not_id'],
                            title: controller.notificationList[index]
                                    ['asn_not_label'] ??
                                "",
                            subtitle: controller.notificationList[index]
                                    ['asn_not_desc'] ??
                                "",
                            createdBy: controller.notificationList[index]
                                    ['asn_not_created_by'] ??
                                "",
                            createdDate: controller.notificationList[index]
                                    ['asn_not_created_date'] ??
                                "",
                            read: controller.notificationList[index]
                                        ['asn_not_status'] ==
                                    0
                                ? false
                                : true,
                            mediaQuery: mediaQuery,
                            controller: controller,
                          );
                        },
                      )
                    : controller.notificationListLoading.value &&
                            controller.notificationList.isEmpty
                        ? const Align(
                            alignment: Alignment.center,
                            child: CupertinoActivityIndicator(
                              radius: 30,
                            ),
                          )
                        : Align(
                            alignment: Alignment.center,
                            child: EmptyInformationWidget(
                              title: "No notifications",
                              height: 200,
                            ),
                          ),
              ),
              controller.selectAll.value
                  ? ElevatedButton(
                      onPressed: () {
                        controller.readAllNotification();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        minimumSize: const Size(double.infinity, 40),
                        backgroundColor: AppColors.blueColor, // Red color
                      ),
                      child: controller.readAllNotificationLoading.value
                          ? const CustomeText(
                              text: "Read All",
                              color: AppColors.whiteColor,
                            )
                          : const CupertinoActivityIndicator(
                              radius: 20,
                              color: AppColors.whiteColor,
                            ))
                  : const SizedBox.shrink()
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationItem extends StatelessWidget {
  final int notificationId;
  final String title;
  final String subtitle;
  final String createdBy;
  final String createdDate;
  final bool read;
  final MediaQueryData mediaQuery;
  final NotificationController? controller;
  const NotificationItem(
      {super.key,
      required this.notificationId,
      required this.title,
      required this.subtitle,
      required this.createdBy,
      required this.createdDate,
      required this.read,
      required this.mediaQuery,
      this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2,
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: read
                  ? [
                      Colors.grey.shade400,
                      Colors.grey.shade800,
                    ]
                  : [
                      AppColors.greenColor,
                      AppColors.secondaryTextColor,
                    ]),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              width: 2,
              color: !read ? Colors.transparent : Colors.transparent)),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
      child: Row(
        children: [
          Icon(
            read ? Icons.notifications_off : Icons.notifications_active,
            color: read ? Colors.black : Colors.white,
            size: 36,
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                              color: read ? Colors.black : Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.8,
                          child: Text(
                            subtitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            style: TextStyle(
                                color: read ? Colors.black : Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12.0),
                          ),
                        ),
                      ],
                    ),
                    Obx(
                      () => controller!.selectAll.value && read == false
                          ? GestureDetector(
                              onTap: () {
                                controller!.toggleNotificationSelection(
                                    notificationId);
                              },
                              child: Container(
                                height: 25,
                                width: 25,
                                decoration: BoxDecoration(
                                  color: controller!.isSelected(notificationId)
                                      ? const Color(0xFF44ce1b)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: controller!.isSelected(notificationId)
                                    ? const Icon(
                                        Icons.done,
                                        color: Colors.white,
                                        size: 16,
                                      )
                                    : null,
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    read
                        ? const SizedBox.shrink()
                        : SizedBox(
                            // width: 120,
                            height: 30,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                shape: const StadiumBorder(),
                                side: const BorderSide(
                                    color: AppColors.whiteColor, width: 1),
                                backgroundColor: AppColors.secondaryTextColor
                                    .withOpacity(0.3),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                              ),
                              onPressed: () => showNotificationAlertDialog(
                                context,
                                controller!,
                                notificationId,
                              ),
                              child: const CustomeText(
                                text: "Read Notification",
                                fontSize: 12,
                                color: AppColors.whiteColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                    SizedBox(
                      height: 30,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: const StadiumBorder(),
                          backgroundColor:
                              AppColors.secondaryTextColor.withOpacity(0.3),
                          side: const BorderSide(
                              color: AppColors.whiteColor, width: 1),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                        ),
                        onPressed: () => Get.bottomSheet(
                          enableDrag: true,
                          isDismissible: true,
                          enterBottomSheetDuration: const Duration(seconds: 1),
                          exitBottomSheetDuration: const Duration(seconds: 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                          elevation: 5.00,
                          isScrollControlled: true,
                          ViewNotificationDetails(
                            title: title,
                            description: subtitle,
                            createdBy: createdBy,
                            createdDate: createdDate,
                            height: (mediaQuery.size.height -
                                kToolbarHeight -
                                mediaQuery.padding.top),
                          ),
                        ),
                        child: const CustomeText(
                          text: "View more",
                          fontSize: 12,
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ViewNotificationDetails extends StatelessWidget {
  final String title, description, createdBy, createdDate;

  final double height;
  const ViewNotificationDetails({
    super.key,
    required this.height,
    required this.title,
    required this.description,
    required this.createdBy,
    required this.createdDate,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.whiteColor,
      height: height * 0.5,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Title Section
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.subtitles, color: AppColors.defaultTextColor),
                    const SizedBox(width: 8),
                    const CustomeText(text: "Title"),
                  ],
                ),
                CustomeText(
                  text: title,
                  color: AppColors.greyColor,
                  fontSize: 18, // Adjust font size for better readability
                ),
                const SizedBox(height: 16),

                // Description Section
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.description, color: AppColors.defaultTextColor),
                    const SizedBox(width: 8),
                    const CustomeText(text: "Description"),
                  ],
                ),
                CustomeText(
                  text: description,
                  color: AppColors.greyColor,
                  fontSize: 16,
                ),
                const SizedBox(height: 16),

                // Created By Section
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.person, color: AppColors.defaultTextColor),
                    const SizedBox(width: 8),
                    const CustomeText(text: "Created By"),
                  ],
                ),
                CustomeText(
                  text: createdBy,
                  color: AppColors.greyColor,
                  fontSize: 16,
                ),
                const SizedBox(height: 16),

                // Created Date Section
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.calendar_today,
                        color: AppColors.defaultTextColor),
                    const SizedBox(width: 8),
                    const CustomeText(text: "Created Date"),
                  ],
                ),
                CustomeText(
                  text:
                      "${DateTimeWidget.dateTimeFormat(createdDate) ?? ""} ${DateTimeWidget.timeFormat(createdDate) ?? ""}",
                  color: AppColors.greyColor,
                  fontSize: 16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Future<bool?> showNotificationAlertDialog(
    context, NotificationController controller, int notificationId) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text(
          'Are you sure you want to read that notification?',
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Yes'),
            onPressed: () {
              controller.readNotification(notificationId);
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('No'),
            onPressed: () {
              Get.back();
            },
          ),
        ],
      );
    },
  );
}
