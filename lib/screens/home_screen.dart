import 'dart:convert';
import 'package:parent_app_by_ats/component/custome_drawer.dart';
import 'package:parent_app_by_ats/component/date_time_widget.dart';
import 'package:parent_app_by_ats/controller/home_controller.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../component/auto_scrolling_text.dart';
import '../component/custom_appbar.dart';
import '../component/custome_shimmer_loading.dart';
import '../component/custome_text.dart';
import '../component/empty_information_widget.dart';
import '../services/routes_path.dart';
import '../utils/color_const.dart';
import '../utils/image_path.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomeAppBar(
        appbarSuffix: Image.asset(
          ImagePath.menuImage,
          color: AppColors.whiteColor,
        ),
        title: controller.pUser,
        action: appbarActionWidgets,
      ),
      drawer: const CustomeDrawer(),
      body: Stack(
        children: [
          ClipPath(
            clipper: RectangleClipper(),
            child: Container(
              decoration: const BoxDecoration(gradient: AppColors.bgLiner1),
              height: MediaQuery.of(context).size.height * 0.2,
            ),
          ),
          Column(
            children: [
              Obx(
                () => Row(
                  children: [
                    controller.companyImage.value != ""
                        ? Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.grey.shade200,
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 2,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Image.memory(
                                  base64Decode(controller.companyImage.value),
                                  fit: BoxFit.fill,
                                  width: 80,
                                  height: 80,
                                ),
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.grey.shade100,
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 2,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: ShimmerLoading(
                                  child: Icon(
                                    Icons.image,
                                    size: 80,
                                  ),
                                ),
                              ),
                            ),
                          ),
                    controller.companyName.value != ""
                        ? Expanded(
                            child: CustomeText(
                              textAlign: TextAlign.center,
                              text:
                                  "Welcome to ${controller.companyName.value}",
                              maxLines: 3,
                              fontSize: 20,
                              color: AppColors.whiteColor,
                            ),
                          )
                        : Expanded(
                            child: Column(
                              children: [
                                ShimmerLoading(
                                  child: Container(
                                    height: 20,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                ShimmerLoading(
                                  child: Container(
                                    height: 20,
                                    width: 220,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                ShimmerLoading(
                                  child: Container(
                                    height: 20,
                                    width: 180,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ],
                ),
              ),
              // ProfileWidget(controller: controller),
              SizedBox(
                height: 10,
              ),
              Obx(() {
                if (controller.newsAlertLoading.value) {
                  return ShimmerLoading(
                    child: Container(
                      color: AppColors.blueColor.withOpacity(0.1),
                      width: MediaQuery.of(context).size.width,
                      child: AutoScrollingText(
                          textWidth: MediaQuery.of(context).size.width,
                          text: "Loading"),
                    ),
                  );
                } else if (!controller.newsAlertLoading.value &&
                    controller.newsAlertList.isEmpty) {
                  return const SizedBox.shrink();
                } else {
                  return Container(
                    color: AppColors.blueColor.withOpacity(0.1),
                    width: MediaQuery.of(context).size.width,
                    child: AutoScrollingText(
                        textWidth: MediaQuery.of(context).size.width,
                        text: controller.newsAlertList[0]['message']),
                  );
                }
              }),
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  width: MediaQuery.of(context).size.width,
                  child: ChildWidget(controller: controller)),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width - 32,
                child: ElevatedButton(
                  onPressed: () {
                    Get.toNamed(RoutePath.complaintPath);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.redColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 10,
                  ),
                  child: const CustomeText(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    text: 'Complaint',
                    color: AppColors.whiteColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> get appbarActionWidgets {
    return [
      // const Padding(
      //   padding: EdgeInsets.only(right: 0.0),
      //   child: SizedBox(
      //     height: 20,
      //     width: 20,
      //     child: Icon(
      //       Icons.search,
      //       size: 20,
      //       color: AppColors.whiteColor,
      //     ),
      //   ),
      // ),
      // const SizedBox(width: 8),
      Obx(
        () => GestureDetector(
          onTap: controller.notificationCount.value != 0
              ? () => Get.toNamed(RoutePath.notificationPath)
              : null,
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Stack(
              children: [
                SizedBox(
                  height: 30,
                  width: 30,
                  child: Image.asset(
                    ImagePath.notificationImage,
                    color: AppColors.whiteColor,
                  ),
                ),
                if (controller.notificationCount.value > 0)
                  Positioned(
                    right: 0,
                    child: Container(
                      height: 12,
                      width: 12,
                      decoration: BoxDecoration(
                        color: AppColors.redColor,
                        borderRadius: BorderRadius.circular(60),
                      ),
                      padding: const EdgeInsets.all(1),
                      child: FittedBox(
                        child: Center(
                          child: CustomeText(
                            textAlign: TextAlign.center,
                            text: controller.notificationCount.value.toString(),
                            color: AppColors.whiteColor,
                            fontSize: 6,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      )
    ];
  }
}

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({
    super.key,
    required this.controller,
  });

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.profileListLoading.value) {
        return const ShimmerLoading(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 36.0, vertical: 8),
            child: Align(
              alignment: Alignment.topLeft,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.whiteColor,
                    child: Icon(Icons.person),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomeText(
                        text: " No data  ",
                        fontSize: 14,
                        color: AppColors.whiteColor,
                      ),
                      CustomeText(
                        text: '   ',
                        fontSize: 10,
                        color: AppColors.whiteColor,
                      ),
                      Row(
                        children: [
                          CustomeText(
                            text: "No data   ",
                            fontSize: 10,
                            color: AppColors.whiteColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          CustomeText(
                            text: " No data  ",
                            fontSize: 10,
                            color: AppColors.whiteColor,
                          ),
                        ],
                      ),
                      CustomeText(
                        text: " No data  ",
                        fontSize: 10,
                        color: AppColors.whiteColor,
                      ),
                    ],
                  ),
                ],
              )
              /*const EmptyInformationWidget(
                    height: 80,
                    width: 200,
                    color: Colors.transparent,
                    title: "This user has no profile data",
                    titleColor: AppColors.whiteColor,
                  )*/
              ,
            ),
          ),
        );
      } else if (controller.profileList.isEmpty &&
          !controller.profileListLoading.value) {
        return const Align(
          alignment: Alignment.topLeft,
          child: EmptyInformationWidget(
            color: Colors.transparent,
            title: "No data",
            titleColor: AppColors.whiteColor,
            height: 80,
            width: 200,
          ),
        );
      } else {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36.0, vertical: 8),
          child: Align(
            alignment: Alignment.topLeft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  backgroundColor: AppColors.whiteColor,
                  child: Icon(Icons.person),
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomeText(
                      text:
                          "Name: ${controller.profileList[0]['user_name'] ?? ""}",
                      fontSize: 14,
                      color: AppColors.whiteColor,
                    ),
                    CustomeText(
                      text:
                          'Email: ${controller.profileList[0]['acs_email'] ?? ""}',
                      fontSize: 10,
                      color: AppColors.whiteColor,
                    ),
                    Row(
                      children: [
                        CustomeText(
                          text:
                              "Contact No: ${controller.profileList[0]['acs_contact_no'] ?? ""}",
                          fontSize: 10,
                          color: AppColors.whiteColor,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        CustomeText(
                          text:
                              "Mobile No: ${controller.profileList[0]['acs_mob_no'] ?? ""}",
                          fontSize: 10,
                          color: AppColors.whiteColor,
                        ),
                      ],
                    ),
                    CustomeText(
                      text:
                          "Address: ${controller.profileList[0]['acs_address'] ?? ""}",
                      fontSize: 10,
                      color: AppColors.whiteColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }
    });
  }
}

class ChildWidget extends StatelessWidget {
  const ChildWidget({
    super.key,
    required this.controller,
  });

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.parentChildLoading.value) {
        return ChildSkeletonWidget(controller: controller);
      } else if (controller.parentChildList.isEmpty) {
        return const Align(
          alignment: Alignment.topLeft,
          child: EmptyInformationWidget(
            color: Colors.transparent,
            title: "No data",
            titleColor: AppColors.whiteColor,
            height: 80,
            width: 200,
          ),
        );
      } else {
        return ChildViewWidget(controller: controller);
      }
    });
  }
}

class ChildViewWidget extends StatelessWidget {
  const ChildViewWidget({
    super.key,
    required this.controller,
  });

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            padEnds: false,
            controller: controller.pageController,
            scrollDirection: Axis.vertical,
            itemCount: controller.parentChildList.length,
            itemBuilder: (context, index) {
              var child = controller.parentChildList[index];
              return GestureDetector(
                onTap: () {
                  Get.dialog(Dialog(
                    insetPadding: EdgeInsets.zero,
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: GridView.count(
                        // gridDelegate:
                        //     SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        padding: const EdgeInsets.all(12.0),
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                        // ),
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Get.back();
                              Get.toNamed(RoutePath.attendancePath);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              shape: RoundedRectangleBorder(
                                // To set rounded corners
                                borderRadius: BorderRadius.circular(
                                    20), // Change 20 to the desired radius
                              ),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    color: AppColors.whiteColor,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  CustomeText(
                                    text: "Attendance",
                                    textAlign: TextAlign.center,
                                    color: AppColors.whiteColor,
                                  )
                                ],
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Get.back();
                              Get.toNamed(RoutePath.resultPath,
                                  arguments: child['std_id']);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.pinkAccent,
                              shape: RoundedRectangleBorder(
                                // To set rounded corners
                                borderRadius: BorderRadius.circular(
                                    20), // Change 20 to the desired radius
                              ),
                            ),
                            child: Center(
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.school,
                                      color: AppColors.whiteColor,
                                    ),
                                    CustomeText(
                                      text: "Result",
                                      textAlign: TextAlign.center,
                                      color: AppColors.whiteColor,
                                    )
                                  ]),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              Get.back();
                              Get.toNamed(
                                RoutePath.assignment,
                                arguments: child['std_id'].toString(),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.greenAccent,
                              shape: RoundedRectangleBorder(
                                // To set rounded corners
                                borderRadius: BorderRadius.circular(
                                    20), // Change 20 to the desired radius
                              ),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.assignment,
                                    color: AppColors.whiteColor,
                                  ),
                                  CustomeText(
                                    text: "Assignment",
                                    textAlign: TextAlign.center,
                                    color: AppColors.whiteColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              await DateTimeWidget.selectDateTime(context).then(
                                (value) async {
                                  if (value != null) {
                                    Get.back();
                                    Get.toNamed(RoutePath.onlineDairy,
                                        arguments: [
                                          child['std_id'].toString(),
                                          "${value.day}-${DateTimeWidget.getMonthName(value.month)}-${value.year}"
                                        ]);
                                  }
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepOrangeAccent,
                              shape: RoundedRectangleBorder(
                                // To set rounded corners
                                borderRadius: BorderRadius.circular(
                                    20), // Change 20 to the desired radius
                              ),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.book,
                                    color: AppColors.whiteColor,
                                  ),
                                  CustomeText(
                                    text: "Online Diary",
                                    textAlign: TextAlign.center,
                                    color: AppColors.whiteColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              Get.back();
                              Get.toNamed(
                                RoutePath.feeVoucherPath,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              shape: RoundedRectangleBorder(
                                // To set rounded corners
                                borderRadius: BorderRadius.circular(
                                    20), // Change 20 to the desired radius
                              ),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.receipt,
                                    color: AppColors.whiteColor,
                                  ),
                                  CustomeText(
                                    text: "Fee Voucher",
                                    textAlign: TextAlign.center,
                                    color: AppColors.whiteColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              Get.back();
                              Get.toNamed(
                                RoutePath.additionalFeeVoucherPath,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigo,
                              shape: RoundedRectangleBorder(
                                // To set rounded corners
                                borderRadius: BorderRadius.circular(
                                    20), // Change 20 to the desired radius
                              ),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.receipt_long,
                                    color: AppColors.whiteColor,
                                  ),
                                  CustomeText(
                                    text: "Additional Fee Vouchers",
                                    textAlign: TextAlign.center,
                                    color: AppColors.whiteColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              Get.back();
                              Get.toNamed(RoutePath.voucherFeeBalancePath,
                                  arguments: child['std_id']);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.tealAccent,
                              shape: RoundedRectangleBorder(
                                // To set rounded corners
                                borderRadius: BorderRadius.circular(
                                    20), // Change 20 to the desired radius
                              ),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.balance_outlined,
                                    color: AppColors.whiteColor,
                                  ),
                                  CustomeText(
                                    text: "Voucher Fee Balance",
                                    textAlign: TextAlign.center,
                                    color: AppColors.whiteColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              Get.back();
                              Get.toNamed(RoutePath.studentSyllabusPath,
                                  arguments: child['std_id']);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                // To set rounded corners
                                borderRadius: BorderRadius.circular(
                                    20), // Change 20 to the desired radius
                              ),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.balance_outlined,
                                    color: AppColors.whiteColor,
                                  ),
                                  CustomeText(
                                    text: "Subject Syllabus",
                                    textAlign: TextAlign.center,
                                    color: AppColors.whiteColor,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ));
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 2,
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                CustomeText(
                                  text: child['student_name'],
                                  fontSize: 24,
                                  maxLines: 2,
                                ),
                                const SizedBox(height: 4),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  child: const Divider(
                                    color: AppColors.yellowColor,
                                    thickness: 3,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                CustomeText(text: "Class: ${child['v_class']}"),
                                CustomeText(
                                    text: "Session: ${child['v_session']}"),
                                CustomeText(
                                    text: "Reg No: ${child['student_reg_no']}"),
                                CustomeText(
                                    text:
                                        "Phone Number: ${child['phone_number']}"),
                              ],
                            ),
                          ),
                        ),
                        Obx(() {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
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
                                      size:
                                          const Size.square(85), // Image radius
                                      child: controller.parentChildImageLoading
                                                  .value ==
                                              false
                                          ? Image.memory(
                                              controller
                                                  .parentChildImageList[index],
                                              fit: BoxFit.fill,
                                              // height: 150.0,
                                              // width: 150.0,
                                            )
                                          : ShimmerLoading(
                                              child: Container(
                                                padding: const EdgeInsets.all(
                                                    2), // Border width
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    width: 2,
                                                    color: AppColors
                                                        .defaultTextColor
                                                        .withOpacity(0.5),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  child: SizedBox.fromSize(
                                                    size: const Size.square(
                                                        85), // Image radius
                                                    child: Icon(Icons.image),
                                                  ),
                                                ),
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                // OutlinedButton(
                                //   onPressed: () {},
                                //   style: ButtonStyle(
                                //     shape: WidgetStateProperty.all(
                                //       RoundedRectangleBorder(
                                //         borderRadius: BorderRadius.circular(10.0),
                                //       ),
                                //     ),
                                //   ),
                                //   child: const CustomeText(
                                //     text: "View Profile",
                                //     decoration: TextDecoration.none,
                                //   ),
                                // ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: controller.parentChildList.isNotEmpty
              ? SmoothPageIndicator(
                  controller: controller.pageController,
                  count: controller.parentChildList.length,
                  effect: const WormEffect(
                    dotHeight: 8,
                    dotWidth: 8,
                    activeDotColor: AppColors.yellowColor,
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

class ChildSkeletonWidget extends StatelessWidget {
  const ChildSkeletonWidget({
    super.key,
    required this.controller,
  });

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            padEnds: false,
            controller: controller.pageController,
            scrollDirection: Axis.vertical,
            itemCount: 5,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 2,
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              ShimmerLoading(
                                child: Container(
                                  height: 24,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              const SizedBox(height: 4),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.25,
                                child: const Divider(
                                  color: AppColors.yellowColor,
                                  thickness: 3,
                                ),
                              ),
                              const SizedBox(height: 4),
                              ShimmerLoading(
                                child: Container(
                                  height: 16,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              ShimmerLoading(
                                child: Container(
                                  height: 16,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              ShimmerLoading(
                                child: Container(
                                  height: 16,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              ShimmerLoading(
                                child: Container(
                                  height: 16,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ShimmerLoading(
                              child: Container(
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
                                    child: Icon(Icons.image),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            OutlinedButton(
                              onPressed: () {},
                              style: ButtonStyle(
                                shape: WidgetStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),
                              child: const CustomeText(
                                text: "View Profile",
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: controller.parentChildList.isNotEmpty
              ? SmoothPageIndicator(
                  controller: controller.pageController,
                  count: controller.parentChildList.length,
                  effect: const WormEffect(
                    dotHeight: 8,
                    dotWidth: 8,
                    activeDotColor: AppColors.yellowColor,
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

class RectangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var y = size.height;
    var x = size.width;
    Path path = Path();
    path.moveTo(0, 0); //a
    path.lineTo(0, y); //b
    path.lineTo(x, y * 0.5);
    path.lineTo(x, 0); //c
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
