import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parent_app_by_ats/services/api_service.dart';
import 'package:parent_app_by_ats/services/storage_service.dart';

class ChatController extends GetxController {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();
  final TextEditingController replyController = TextEditingController();
  final ScrollController chatScrollController = ScrollController();
  String? complainId;
  RxList chatList = [].obs;
  RxBool chatLoading = true.obs,
      chatReplyLoading = true.obs,
      chatHasPage = true.obs;
  RxInt chatPageOffset = 0.obs;
  @override
  void onInit() {
    complainId = Get.arguments;
    chatScrollController.addListener(() {
      if (chatScrollController.position.pixels ==
          chatScrollController.position.maxScrollExtent) {
        log("-----${chatHasPage.value} ${chatPageOffset.value}");
        pagination(chatHasPage.value, chatPageOffset.value, getChatList);
      }
    });

    getChatList();
    super.onInit();
  }

  void pagination(hasPage, offset, Future<void> Function() update) {
    if (hasPage && offset != 0) {
      update();
    }
  }

  // void _scrollToBottom() {
  //   if (chatScrollController.hasClients) {
  //     chatScrollController
  //         .jumpTo(chatScrollController.position.maxScrollExtent);
  //     log("message-------${chatScrollController.position.maxScrollExtent}");
  //   }
  // }

  Future<void> getChatList() async {
    await _storageService.init();
    var pComId = _storageService.read('comId').toString();
    var pMainCompany = _storageService.read('mainCompany');

    try {
      var response = await _apiService.get(
          "/PT_PARENT_COMPLAINT_PARENT_REPLY_ENTRY?P_PARENT_ID=$complainId&P_COM_ID=$pComId&P_MAIN_COMPANY=$pMainCompany&offset=${chatPageOffset.value}");
      // if (response['items'] != []) {
      //   chatList.value = response['items'];
      //   // chatList.value = chatList.reversed.toList();
      // }
      // chatLoading.value = false;
      if ((response['items'] as List).isNotEmpty) {
        List newItems = response['items'];

        for (Map<String, dynamic> item in newItems) {
          bool exists = chatList.any(
              (enrollment) => enrollment['v_reply_id'] == item['v_reply_id']);
          if (!exists) {
            chatList.add(item);
          }
        }

        chatHasPage.value = response['hasMore'];

        if (chatHasPage.value) {
          var link = (response['links'] as List)
              .firstWhere((links) => links['rel'] == 'next');

          if (link['rel'] == 'next' && link['href'] != null) {
            var nextPage = link['href'] as String;
            chatPageOffset.value = nextPage.contains('&offset=')
                ? int.parse(nextPage.split('&offset=')[1])
                : chatPageOffset.value;
          }
        }
      }

      chatLoading.value = false;
    } catch (error) {
      chatLoading.value = false;
    }
  }

  Future<void> replyChat() async {
    await _storageService.init();
    var pComId = _storageService.read('comId').toString();
    var pUsername = _storageService.read('user');
    // var pMainCompany = _storageService.read('mainCompany');
    var request = {
      "P_COM_ID": pComId,
      "P_PARENT_ID": complainId,
      "P_REPLY": replyController.text,
      "P_USERNAME": pUsername
    };
    try {
      var response = await _apiService.post(
          "/PT_PARENT_COMPLAINT_PARENT_REPLY_ENTRY", request);
      if (response['Result'] == "Success") {
        // chatReplyLoading.value = true;
        replyController.clear();
        getChatList();
      } else {}
    } catch (error) {
      log("Error: $error");
    }
  }
}
