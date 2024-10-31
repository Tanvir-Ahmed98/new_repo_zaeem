import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parent_app_by_ats/services/routes_path.dart';

import '../component/custome_shimmer_loading.dart';
import '../component/date_time_widget.dart';
import '../component/empty_information_widget.dart';
import '../controller/attendance_details_controller.dart';

class AttendanceDetailsScreen extends GetView<AttendanceDetailsController> {
  const AttendanceDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        backgroundColor: Colors.transparent,
        title: Text("Attendance Details"),
        leading: GestureDetector(
          onTap: () {
            Get.offNamed(RoutePath.attendancePath);
          },
          child: Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(() {
          if (controller.attendanceListLoading.value) {
            return ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 4,
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Date and Day
                        Row(
                          children: [
                            Icon(Icons.calendar_today, color: Colors.grey[600]),
                            const SizedBox(width: 8),
                            ShimmerLoading(
                              child: Container(
                                height: 16,
                                width: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Employee Name
                        Row(
                          children: [
                            Icon(Icons.person_outline, color: Colors.blue),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ShimmerLoading(
                                child: Container(
                                  height: 16,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Class Description
                        Row(
                          children: [
                            Icon(Icons.class_, color: Colors.deepOrangeAccent),
                            const SizedBox(width: 8),
                            ShimmerLoading(
                              child: Container(
                                height: 16,
                                width: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Attendance Time In/Out
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.access_time, color: Colors.green),
                                const SizedBox(width: 8),
                                ShimmerLoading(
                                  child: Container(
                                    height: 16,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.exit_to_app,
                                    color: Colors.redAccent),
                                const SizedBox(width: 8),
                                ShimmerLoading(
                                  child: Container(
                                    height: 16,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Status
                        Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.green,
                            ),
                            const SizedBox(width: 8),
                            ShimmerLoading(
                              child: Container(
                                height: 16,
                                width: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white,
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
          } else if (controller.attendanceList.isEmpty) {
            return EmptyInformationWidget(title: "No data");
          } else {
            return ListView.builder(
              controller: controller.attendanceScrollController,
              itemCount: controller.attendanceListHasPage.value
                  ? controller.attendanceList.length + 1
                  : controller.attendanceList.length,
              itemBuilder: (context, index) {
                if (index == controller.attendanceList.length) {
                  return const Center(
                      child: Padding(
                    padding: EdgeInsets.only(bottom: 2.0),
                    child: CircularProgressIndicator.adaptive(),
                  ));
                }

                var record = controller.attendanceList[index];
                var dateFormatted =
                    DateTimeWidget.dateTimeFormat(record['datee']);
                var day = record['dayy'].trim();
                var empName = record['emp_name'];
                var classDesc = record['asse_er_asc_class_id_desc'];
                var timeIn =
                    DateTimeWidget.timeFormat(record['assat_att_time_in']);
                var timeOut =
                    DateTimeWidget.timeFormat(record['assat_att_time_out']);
                var status = record['status'] ?? "";

                return Card(
                  elevation: 4,
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Date and Day
                        Row(
                          children: [
                            Icon(Icons.calendar_today, color: Colors.grey[600]),
                            const SizedBox(width: 8),
                            Text(
                              '$day, $dateFormatted',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Employee Name
                        Row(
                          children: [
                            Icon(Icons.person_outline, color: Colors.blue),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                empName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.start,
                                //overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Class Description
                        Row(
                          children: [
                            Icon(Icons.class_, color: Colors.deepOrangeAccent),
                            const SizedBox(width: 8),
                            Text(
                              classDesc,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Attendance Time In/Out
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.access_time, color: Colors.green),
                                const SizedBox(width: 8),
                                Text(
                                  'In: $timeIn',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.exit_to_app,
                                    color: Colors.redAccent),
                                const SizedBox(width: 8),
                                Text(
                                  'Out: $timeOut',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Status
                        Row(
                          children: [
                            Icon(
                              status != '' ? Icons.check_circle : Icons.warning,
                              color: status != '' ? Colors.green : Colors.amber,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              status,
                              style: TextStyle(
                                fontSize: 14,
                                color: status != "" ? Colors.green : Colors.red,
                                fontWeight: FontWeight.bold,
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
          }
        }),
      ),
    );
  }
}
