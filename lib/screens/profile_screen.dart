// import '../controller/profile_controller.dart';
// import '../utils/image_path.dart';
// import 'package:flutter/material.dart';

// import 'package:get/get.dart';
// import '../component/custom_appbar.dart';

// import '../services/routes_path.dart';
// import '../utils/color_const.dart';

// class ProfileScreen extends GetView<ProfileController> {
//   const ProfileScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // final MediaQueryData mediaQuery = MediaQuery.of(context);
//     return PopScope(
//       canPop: false,
//       onPopInvokedWithResult: (didPop, result) {
//         if (didPop) {
//           return;
//         } else {
//           Get.offNamed(RoutePath.basePath);
//         }
//       },
//       child: Scaffold(
//         appBar: CustomeAppBar(
//           onTap: () => Get.offNamed(RoutePath.basePath),
//           screenTitle: "Profile",
//         ),
//         body: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Align(
//               alignment: Alignment.center,
//               child: Stack(
//                 clipBehavior: Clip.none,
//                 children: [
//                   CircleAvatar(
//                     radius: 100,
//                     backgroundColor: AppColors.blueColor.withOpacity(0.3),
//                     child: Padding(
//                       padding: const EdgeInsets.all(8), // Border radius
//                       child:
//                           ClipOval(child: Image.asset(ImagePath.profileImage)),
//                     ),
//                   ),
//                   Positioned(
//                     bottom: 20,
//                     right: -25,
//                     child: RawMaterialButton(
//                       onPressed: () {},
//                       elevation: 5.0,
//                       fillColor: const Color(0xFFF5F6F9),
//                       padding: const EdgeInsets.all(15.0),
//                       shape: const CircleBorder(),
//                       child: const Icon(
//                         Icons.camera_alt_outlined,
//                         color: Colors.blue,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 16),
//             Obx(() => Expanded(
//                   child: Container(
//                     width: double.infinity,
//                     margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text.rich(
//                           TextSpan(
//                               text: "User Name: ",
//                               style: const TextStyle(
//                                   color: AppColors.defaultTextColor,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 24),
//                               children: [
//                                 TextSpan(
//                                     text: controller.pUserName.value,
//                                     style: const TextStyle(
//                                         color: AppColors.defaultTextColor,
//                                         fontWeight: FontWeight.normal,
//                                         fontSize: 18))
//                               ]),
//                         )
//                       ],
//                     ),
//                   ),
//                 ))
//           ],
//         ),
//       ),
//     );
//   }
// }
