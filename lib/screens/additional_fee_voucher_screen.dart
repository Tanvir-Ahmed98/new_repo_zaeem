
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parent_app_by_ats/component/empty_information_widget.dart';
import '../component/custome_shimmer_loading.dart';
import '../component/custome_text.dart';
import '../controller/additional_voucher_controller.dart';
import 'pdf_screen.dart';

class AdditionalFeeVoucherScreen
    extends GetView<AdditionalFeeVoucherController> {
  const AdditionalFeeVoucherScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          title: Text("Additional Fee Vouchers"),
        ),
        body: Obx(() {
          if (controller.additionalFeeVouchersListLoading.value) {
            return ListView.builder(
              itemCount: 20,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: Icon(
                      Icons.event_note, // Icon for each list item
                      color: Colors.blueAccent,
                    ),
                    title: ShimmerLoading(
                      child: Container(
                        height: 16,
                        width: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                        ),
                      ),
                    ),
                    subtitle: ShimmerLoading(
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
                );
              },
            );
          } else if (controller.additionalFeeVouchersList.isEmpty) {
            return EmptyInformationWidget(title: "No data");
          } else {
            return ListView.builder(
              itemCount: controller.additionalFeeVouchersHasPage.value
                  ? controller.additionalFeeVouchersList.length + 1
                  : controller.additionalFeeVouchersList.length,
              itemBuilder: (context, index) {
                var listItems = controller.additionalFeeVouchersList[index];
                return Obx(() {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      leading: Icon(
                        Icons.event_note, // Icon for each list item
                        color: Colors.blueAccent,
                      ),
                      title: CustomeText(
                        text: listItems['list_title']!,
                        fontWeight: FontWeight.bold,
                      ),
                      subtitle: CustomeText(text: listItems['list_text']!),
                      trailing: controller.pdfLoading.value
                          ? Stack(
                              alignment: Alignment
                                  .center, // Center the text inside the circle
                              children: [
                                SizedBox(
                                  width:
                                      40, // Set the size of the CircularProgressIndicator
                                  height: 40,
                                  child: CircularProgressIndicator(
                                    value:
                                        controller.downloadProgress.value / 100,
                                    strokeWidth: 3,
                                    color: Colors.green,
                                    backgroundColor: Colors.blueGrey,
                                  ),
                                ),
                                Text(
                                  '${controller.downloadProgress.value.toStringAsFixed(0)}%', // Show the percentage value
                                  style: TextStyle(
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Colors.black, // Adjust color if needed
                                  ),
                                ),
                              ],
                            )
                          : controller.downloadProgress.value == 100.0 &&
                                  controller.filePathLocation.value != ""
                              ? OutlinedButton(
                                  onPressed: () {
                                    Get.to(() => PdfScreen(
                                        pdfLocation:
                                            controller.filePathLocation.value));
                                  },
                                  child: CustomeText(text: "Open"))
                              : IconButton(
                                  icon: Icon(
                                    Icons.download, // Download icon
                                    color: Colors
                                        .green, // You can change the color if needed
                                  ),
                                  onPressed: () {
                                    controller.downloadAdditionalFeeVoucher(
                                        addtionalVoucherId:
                                            listItems['asafv_add_id']);
                                  },
                                ),
                      onTap: null,
                    ),
                  );
                });
              },
            );
          }
        }));
  }
}
