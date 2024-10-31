import '../component/empty_information_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/dashboard_controller.dart';

class DashBoardScreen extends GetView<DashBoardController> {
  const DashBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(
          () => controller.dashboardLoading.value == true &&
                  controller.dashboardList.isEmpty
              ? const Center(
                  child: CupertinoActivityIndicator(
                  radius: 30,
                ))
              : controller.dashboardLoading.value == false &&
                      controller.dashboardList.isEmpty
                  ? const Center(
                      child: EmptyInformationWidget(title: "No data found"),
                    )
                  : Column(children: [
                      // Total students
                      DashboardCard(
                        value: controller.dashboardList[0]
                            ['total_student_value'],
                        label: controller.dashboardList[0]
                            ['total_student_lable'],
                        color: Colors.blue,
                        icon: Icons.group,
                      ),
                      const SizedBox(height: 16),
                      // Row for male and female
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Male students
                          Expanded(
                            child: DashboardCard(
                              value: controller.dashboardList[0]
                                  ['total_male_value'],
                              label: controller.dashboardList[0]
                                  ['total_male_label'],
                              color: Colors.green,
                              icon: Icons.male,
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Female students
                          Expanded(
                            child: DashboardCard(
                              value: controller.dashboardList[0]
                                  ['total_female_value'],
                              label: controller.dashboardList[0]
                                  ['total_female_lable'],
                              color: Colors.pink,
                              icon: Icons.female,
                            ),
                          ),
                        ],
                      ),
                    ]),
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final int value;
  final String label;
  final Color color;
  final IconData icon;

  const DashboardCard({
    super.key,
    required this.value,
    required this.label,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 8),
            Text(
              '$value',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
