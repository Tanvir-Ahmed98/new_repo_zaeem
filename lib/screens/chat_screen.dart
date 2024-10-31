import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:get/get.dart';
import 'package:parent_app_by_ats/component/custome_shimmer_loading.dart';
import 'package:parent_app_by_ats/component/custome_text.dart';
import 'package:parent_app_by_ats/component/empty_information_widget.dart';
import 'package:parent_app_by_ats/controller/chat_controller.dart';
import '../component/custome_textformfield.dart';
import '../component/date_time_widget.dart';

class ChatScreen extends GetView<ChatController> {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Text('Messages'),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Obx(() {
              if (controller.chatLoading.value) {
                return Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.all(10),
                    itemCount: 20,
                    itemBuilder: (context, index) {
                      return Row(
                        mainAxisAlignment: index.isEven
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          if (!index.isEven)
                            ShimmerLoading(
                              child: CircleAvatar(
                                child: CustomeText(
                                  text: "N/A",
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ChatBubble(
                            clipper: index.isEven
                                ? ChatBubbleClipper1(
                                    type: BubbleType.sendBubble)
                                : ChatBubbleClipper1(
                                    type: BubbleType.receiverBubble),
                            alignment: index.isEven ? Alignment.topRight : null,
                            margin: EdgeInsets.only(top: 20),
                            backGroundColor: index.isEven
                                ? Colors.blue[100]
                                : Colors.green[100],
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              padding: EdgeInsets.all(0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              constraints: BoxConstraints(
                                minWidth:
                                    MediaQuery.of(context).size.width * 0.5,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ShimmerLoading(
                                    child: Container(
                                      height: 16,
                                      width: 200,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: Colors.white),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        ShimmerLoading(
                                          child: Container(
                                            height: 12,
                                            width: 50,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color: Colors.white),
                                          ),
                                        ),
                                        ShimmerLoading(
                                          child: Container(
                                            height: 12,
                                            width: 80,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          if (index.isEven)
                            ShimmerLoading(
                              child: CircleAvatar(
                                child: CustomeText(
                                  text: "N/A",
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                );
              } else if (controller.chatList.isEmpty) {
                return Expanded(
                  child: EmptyInformationWidget(
                    title: "No chat found",
                    height: MediaQuery.of(context).size.height * 0.3,
                  ),
                );
              } else {
                return Expanded(
                  child: ListView.builder(
                    controller: controller.chatScrollController,
                    shrinkWrap: true,
                    reverse: true,
                    padding: EdgeInsets.all(10),
                    itemCount: controller.chatHasPage.value
                        ? controller.chatList.length + 1
                        : controller.chatList.length,
                    itemBuilder: (context, index) {
                      if (index == controller.chatList.length) {
                        return const Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 2.0),
                            child: CircularProgressIndicator.adaptive(),
                          ),
                        );
                      }
                      final chat = controller.chatList[index];
                      bool isParent = chat['admin_reply'] == null;

                      return Row(
                        mainAxisAlignment: isParent
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          if (!isParent)
                            CircleAvatar(
                              backgroundColor: Colors.greenAccent,
                              child: CustomeText(
                                text: chat['aspcr_com_created_by']
                                    .toString()
                                    .substring(0, 2),
                                color: Colors.white,
                              ),
                            ),
                          ChatBubble(
                            clipper: isParent
                                ? ChatBubbleClipper1(
                                    type: BubbleType.sendBubble)
                                : ChatBubbleClipper1(
                                    type: BubbleType.receiverBubble),
                            alignment: isParent ? Alignment.topRight : null,
                            margin: EdgeInsets.only(top: 20),
                            backGroundColor:
                                isParent ? Colors.blue[100] : Colors.green[100],
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              padding: EdgeInsets.all(0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              constraints: BoxConstraints(
                                minWidth:
                                    MediaQuery.of(context).size.width * 0.5,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SelectableText(
                                    isParent
                                        ? chat['parent_reply'] ?? ''
                                        : chat['admin_reply'] ?? '',
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CustomeText(
                                        text:
                                            "by ${chat['aspcr_com_created_by']}",
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      CustomeText(
                                          text:
                                              "${DateTimeWidget.timeFormat(chat['aspcr_com_created_date']) ?? ""}  ${DateTimeWidget.dateTimeFormat(chat['aspcr_com_created_date']) ?? ""}",
                                          fontSize: 12,
                                          color: Colors.grey),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          if (isParent)
                            CircleAvatar(
                              backgroundColor: Colors.blueAccent,
                              child: CustomeText(
                                text: chat['aspcr_com_created_by']
                                    .toString()
                                    .substring(0, 2),
                                color: Colors.white,
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                );
              }
            }),
            CustomeTextFormField(
              controller: controller.replyController,
              onKeyBoardPressSubmitted: (value) => controller.replyChat(),
              suffixIcon: GestureDetector(
                  onTap: () => controller.replyChat(),
                  child: Icon(Icons.reply, size: 18, color: Colors.blue)),
              hintText: 'Reply',
            ),
          ],
        ),
      ),
    );
  }
}
