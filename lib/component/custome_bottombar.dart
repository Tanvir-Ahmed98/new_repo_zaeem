import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/bottom_nav_controller.dart';
import '../utils/color_const.dart';
import 'custome_text.dart';

class CustomeBottomNavBar extends GetView<BottomNavbarController> {
  const CustomeBottomNavBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const double sigmaX = 5; // from 0-10
    const double sigmaY = 5; // from 0-10

    Get.put(BottomNavbarController());
    return BottomAppBar(
      height: 70,
      elevation: 200,
      color: AppColors.secondaryColor,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
          child: Card(
            color: Colors.white,
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Obx(() => Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ...List.generate(
                      controller.bottomBars.length,
                      (index) {
                        return GestureDetector(
                          onTap: () {
                            controller.changePage(index);
                            // Trigger the color change for 2 seconds
                            Timer(const Duration(milliseconds: 1000), () {
                              controller.hideColorForIndex(index);
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 1000),
                            width: 60,
                            decoration: BoxDecoration(
                              color: controller.isColorVisibleForIndex(index)
                                  ? AppColors.blueColor.withOpacity(0.2)
                                  : Colors.transparent,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                                bottomLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Stack(
                                  children: [
                                    ColorFiltered(
                                      colorFilter: ColorFilter.mode(
                                        controller.currentPage.value == index
                                            ? AppColors.blueColor
                                            : AppColors.defaultTextColor,
                                        BlendMode.srcATop,
                                      ),
                                      child: Image.asset(
                                        controller.bottomBars[index]['icon'],
                                        height: 15,
                                        width: 15,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    if (controller.notificationCount.value !=
                                            0 &&
                                        controller.bottomBars[index]['lable'] ==
                                            "Notification")
                                      Positioned(
                                        right: 0,
                                        child: Container(
                                          padding: const EdgeInsets.all(2),
                                          height: 20,
                                          width: 20,
                                          decoration: BoxDecoration(
                                            color: AppColors.whiteColor,
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          child: CircleAvatar(
                                            radius: 10,
                                            backgroundColor: Colors.red,
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                  1), // Border radius
                                              child: ClipOval(
                                                child: CustomeText(
                                                  textAlign: TextAlign.center,
                                                  text:
                                                      "${controller.notificationCount.value}",
                                                  color: AppColors.whiteColor,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                FittedBox(
                                  child: CustomeText(
                                    text: controller.bottomBars[index]['lable'],
                                    color: controller.currentPage.value == index
                                        ? AppColors.blueColor
                                        : AppColors.defaultTextColor,
                                    fontSize: 12,
                                  ),
                                ),
                                Container(
                                  height: 2,
                                  width: 10,
                                  decoration: BoxDecoration(
                                    color: controller.currentPage.value == index
                                        ? AppColors.blueColor
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }

  // Color bottombarMenuItemBackgroundColorVisibility(int index) {
  //   return controller.currentPage.value == index
  //       ? AppColors.blueColor.withOpacity(0.5)
  //       : Colors.transparent;
  // }
}
