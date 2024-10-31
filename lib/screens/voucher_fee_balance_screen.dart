import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parent_app_by_ats/component/empty_information_widget.dart';
import 'package:parent_app_by_ats/controller/voucher_fee_balance_controller.dart';
import '../component/custome_shimmer_loading.dart';

class VoucherFeeBalanceScreen extends GetView<VoucherFeeBalanceController> {
  const VoucherFeeBalanceScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          title: Text("Voucher Fee Balance"),
        ),
        body: Obx(() {
          if (controller.voucherFeeBalanceListLoading.value) {
            return ListView.builder(
              itemCount: 20,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerLoading(
                          child: Container(
                            height: 14,
                            //width: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ShimmerLoading(
                              child: Container(
                                height: 14,
                                width: 120,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            ShimmerLoading(
                              child: Container(
                                height: 14,
                                width: 120,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            ShimmerLoading(child: Icon(Icons.check_circle)),
                            SizedBox(width: 8),
                            ShimmerLoading(
                              child: Container(
                                height: 14,
                                width: 200,
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
          } else if (controller.voucherFeeBalanceList.isEmpty) {
            return EmptyInformationWidget(title: "No data");
          } else {
            return ListView.builder(
              itemCount: controller.voucherFeeBalanceHasPage.value
                  ? controller.voucherFeeBalanceList.length + 1
                  : controller.voucherFeeBalanceList.length,
              itemBuilder: (context, index) {
                final item = controller.voucherFeeBalanceList[index];
                // final bool isPaid =
                //     item['vch_paid'] != null && item['reaming_amount'] == 0;
                // final Color statusColor = isPaid ? Colors.green : Colors.red;
                // final IconData statusIcon =
                //     isPaid ? Icons.check_circle : Icons.warning;

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['asse_er_ass_stu_id_desc'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Total Vouchers Amount: ${item['ascgv_vch_tot_amt']}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                        Text(
                          'Remaining Amount: ${item['reaming_amount']}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                        //SizedBox(height: 8),
                        // Row(
                        //   children: [
                        //     // Icon(
                        //     //   statusIcon,
                        //     //   color: statusColor,
                        //     // ),
                        //     // SizedBox(width: 8),

                        //   ],
                        // ),
                        Text(
                          "Total Voucher Amount Paid: ${item['vch_paid']}",
                          style: TextStyle(
                            // color: statusColor,
                            // fontSize: 14,
                            // fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        }));
  }
}
