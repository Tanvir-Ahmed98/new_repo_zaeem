// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controller/class_opening_controller.dart';

// class CustomeBottomsheet extends StatelessWidget {
//   final bool isEdit;
//   final Map<String, dynamic>? editData;
//   const CustomeBottomsheet({super.key, this.isEdit = false, this.editData});

//   @override
//   Widget build(BuildContext context) {
//     int? classId;
//     final controller = Get.put(ClassOpeningController());
//     if (editData != null) {
//       controller.classNameController.text = editData!['asc_class_name'] ?? '';
//       controller.classAlternativeNameController.text =
//           editData!['asc_class_alt_name'] ?? '';
//       controller.classAmountController.text =
//           editData!['asc_class_amt'].toString();
//       controller.isActive.value =
//           editData!['asc_class_active_flag'] == 1 ? true : false;
//       classId = editData!['asc_class_id'];
//     }

//     return PopScope(
//       canPop: false,
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.grey.shade100,
//           borderRadius: const BorderRadius.only(
//             topLeft: Radius.circular(20),
//             topRight: Radius.circular(20),
//           ),
//         ),
//         child: Form(
//           key: controller.classFormkey,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextFormField(
//                 controller: controller.classNameController,
//                 //onChanged: (value) => controller.onClassNameFilter(value),
//                 style: const TextStyle(color: Colors.black),
//                 validator: (value) {
//                   if (value == null || value == "") {
//                     return "Please enter class name";
//                   }
//                   return null;
//                 },
//                 decoration: InputDecoration(
//                   fillColor: Colors.white,
//                   filled: true,
//                   hintText: "Class Name",
//                   hintStyle: const TextStyle(
//                       color: Colors.grey,
//                       fontSize: 12,
//                       fontWeight: FontWeight.bold),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 8),
//               TextFormField(
//                 controller: controller.classAmountController,
//                 validator: (value) {
//                   if (value == null || value == "") {
//                     return "Please enter amount";
//                   }
//                   return null;
//                 },
//                 decoration: InputDecoration(
//                   fillColor: Colors.white,
//                   filled: true,
//                   hintText: 'Amount',
//                   hintStyle: const TextStyle(
//                       color: Colors.grey,
//                       fontSize: 12,
//                       fontWeight: FontWeight.bold),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 keyboardType: TextInputType.number,
//               ),
//               const SizedBox(height: 8),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text('Active ?'),
//                   Obx(() => Switch(
//                         value: controller.isActive.value,
//                         onChanged: (value) => controller.isActive.value = value,
//                       )),
//                 ],
//               ),
//               const SizedBox(height: 16),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                         elevation: 0,
//                         backgroundColor: Colors.white,
//                         shape: RoundedRectangleBorder(
//                           side:
//                               BorderSide(width: 2, color: Colors.grey.shade400),
//                         ),
//                         padding: const EdgeInsets.only(left: 10, right: 10)),
//                     onPressed: () {
//                       controller.classNameController.text = '';
//                       controller.classAlternativeNameController.text = '';
//                       controller.classAmountController.text = '';
//                       controller.isActive.value = true;
//                       Get.back();
//                     },
//                     child: const Text(
//                       'Cancel',
//                       style: TextStyle(
//                           color: Colors.black,
//                           fontSize: 12,
//                           fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                         elevation: 0,
//                         backgroundColor: Colors.blue,
//                         shape: const RoundedRectangleBorder(),
//                         padding: const EdgeInsets.only(left: 10, right: 10)),
//                     onPressed: () {
//                       if (controller.classFormkey.currentState!.validate()) {
//                         controller.classFormkey.currentState!.save();
//                         !isEdit
//                             ? controller.createClass()
//                             : controller.updateClass(
//                                 classId: classId.toString());
//                       }
//                     },
//                     child: Text(
//                       isEdit ? "Update" : 'Create',
//                       style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 12,
//                           fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
