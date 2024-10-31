// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../component/custom_appbar.dart';
// import '../controller/bottom_nav_controller.dart';
// import '../controller/setting_controller.dart';

// class SettingScreen extends GetView<SettingController> {
//   const SettingScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Get.put(SettingController());
//     final bottomBarController = Get.find<BottomNavbarController>();
//     return Scaffold(
//       appBar: CustomeAppBar(
//         // navigationFromBottombar: true,
//         // navigationFromBottombarFun: () {
//         //   bottomBarController.changePage(0);
//         // },
//         onTap: () => bottomBarController.changePage(0),
//         screenTitle: "Settings",
//       ),
//       body: ListView(
//         padding: EdgeInsets.only(top: 64),
//         children: [
//           ListTile(
//             leading: const Icon(Icons.account_circle),
//             title: const Text('Account'),
//             subtitle: const Text('Manage your account settings'),
//             onTap: () {
//               // Handle Account settings tap
//             },
//           ),
//           const Divider(),
//           ListTile(
//             leading: const Icon(Icons.notifications),
//             title: const Text('Notifications'),
//             subtitle: const Text('Notification preferences'),
//             onTap: () {
//               // Handle Notifications settings tap
//             },
//           ),
//           const Divider(),
//           SwitchListTile(
//             title: const Text('Dark Mode'),
//             secondary: const Icon(Icons.dark_mode),
//             value: true, // Change this value to dynamically control the switch
//             onChanged: (bool value) {
//               // Handle Dark Mode switch
//             },
//           ),
//           const Divider(),
//           ListTile(
//             leading: const Icon(Icons.language),
//             title: const Text('Language'),
//             subtitle: const Text('Change the language'),
//             onTap: () {
//               // Handle Language settings tap
//             },
//           ),
//           const Divider(),
//           ListTile(
//             leading: const Icon(Icons.lock),
//             title: const Text('Privacy'),
//             subtitle: const Text('Privacy settings'),
//             onTap: () {
//               // Handle Privacy settings tap
//             },
//           ),
//           const Divider(),
//           ListTile(
//             leading: const Icon(Icons.info),
//             title: const Text('About'),
//             subtitle: const Text('About the app'),
//             onTap: () {
//               // Handle About tap
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
