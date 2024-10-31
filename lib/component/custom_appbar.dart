import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parent_app_by_ats/component/custome_shimmer_loading.dart';
import '../utils/color_const.dart';
import 'custome_text.dart';

class CustomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget appbarSuffix;
  final Color appbarColor;
  final VoidCallback? onTap;
  final RxString? title;

  final String? screenTitle;
  final List<Widget>? action;

  const CustomeAppBar(
      {super.key,
      this.appbarColor = AppColors.secondaryColor,
      this.onTap,
      this.screenTitle,
      this.title,
      this.action,
      this.appbarSuffix = const Icon(
        Icons.arrow_back_ios_new_rounded,
        color: AppColors.blueColor,
      )});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.secondaryTextColor,
      actions: action,
      flexibleSpace: Container(
        padding:
            EdgeInsets.fromLTRB(8, MediaQuery.of(context).padding.top, 8, 0),
        decoration: const BoxDecoration(
          gradient: AppColors.bgLiner1,
        ),
        child: Container(
          color: Colors.transparent,
          margin: const EdgeInsets.only(left: 8, right: 60.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: GestureDetector(
                  onTap: () {
                    Scaffold.of(context).openDrawer();
                  },
                  child: SizedBox(height: 30, width: 30, child: appbarSuffix),
                ),
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(
                    () => title?.value != ""
                        ? FittedBox(
                            child: CustomeText(
                              textAlign: TextAlign.start,
                              text: "Hi, ${title?.value}",
                              fontSize: 16,
                              color: AppColors.whiteColor,
                            ),
                          )
                        : ShimmerLoading(
                            child: Container(
                              height: 24,
                              width: 150,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(height: 2),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(58);
}
