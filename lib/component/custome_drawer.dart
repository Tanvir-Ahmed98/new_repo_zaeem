import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parent_app_by_ats/services/storage_service.dart';
import 'package:parent_app_by_ats/utils/color_const.dart';

import '../services/routes_path.dart';
import 'custome_text.dart';

class CustomeDrawer extends StatelessWidget {
  const CustomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () {
                      log("message-----");
                      Scaffold.of(context).closeDrawer();
                    },
                    child: const Icon(
                      Icons.close_outlined,
                      color: Colors.red,
                    ),
                  ),
                ),
                const CircleAvatar(
                  radius: 30,
                  child: Icon(
                    Icons.person_2,
                    color: AppColors.defaultTextColor,
                  ), // Add your profile image here
                ),
                const SizedBox(height: 20),
                CustomeText(
                  text: '${StorageService().read('user')}',
                ),
                // const CustomeText(
                //   text: 'john.doe@example.com',
                // ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          const Divider(
            color: AppColors.defaultTextColor,
          ),
          ListTile(
            leading: const Icon(
              Icons.settings,
              color: AppColors.defaultTextColor,
            ),
            title: const CustomeText(
              text: 'Settings',
            ),
            onTap: () {
              // Add your navigation or functionality here
            },
          ),
          // ListTile(
          //   leading: const Icon(
          //     Icons.help,
          //     color: AppColors.defaultTextColor,
          //   ),
          //   title: const CustomeText(
          //     text: 'Help & Support',
          //   ),
          //   onTap: () {
          //     // Add your functionality here
          //   },
          // ),
          ListTile(
            leading: const Icon(
              Icons.logout,
              color: AppColors.defaultTextColor,
            ),
            title: const CustomeText(
              text: 'Logout',
            ),
            onTap: () {
              var storageService = StorageService();
              storageService.remove("result");
              storageService.remove("user");
              storageService.remove("mainCompany");
              storageService.remove("comId");
              Get.offNamed(RoutePath.loginPath);
              // Handle logout
            },
          ),
        ],
      ),
    );
  }
}
