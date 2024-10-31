import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../component/custom_snackbar.dart';
import '../services/api_service.dart';
import '../services/routes_path.dart';
import '../services/storage_service.dart';

class AuthController extends GetxController {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();
  final GlobalKey<FormState> loginGlobalFormkey = GlobalKey<FormState>();
  final TextEditingController loginUsernameController = TextEditingController(),
      loginPasswordController = TextEditingController();
  RxBool isChecked = false.obs,
      isVisibility = false.obs,
      loginLoading = true.obs;

  late PageController pageController;
  var progress = 0.0.obs;

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    rememberMe();
    pageController = PageController()
      ..addListener(() {
        progress.value = pageController.page ?? 0;
      });

    super.onInit();
  }

  void nextPage() {
    if (pageController.page == 0) {
      pageController.animateToPage(1,
          duration: const Duration(milliseconds: 400), curve: Curves.ease);
    } else if (pageController.page == 1) {
      if (loginGlobalFormkey.currentState!.validate()) {
        loginGlobalFormkey.currentState!.save();
        login();
      }
    }
  }

  @override
  void dispose() {
    Get.delete<AuthController>();
    loginUsernameController.dispose();
    loginPasswordController.dispose();
    super.dispose();
  }

  rememberMe({bool? value}) async {
    await _storageService.init();
    if (await _storageService.read('username') != null &&
        await _storageService.read('password') != null) {
      loginUsernameController.text = await _storageService.read('username');
      loginPasswordController.text = await _storageService.read('password');
    }
    var storageValue = await _storageService.read('rememberMe');
    if (storageValue != null) {
      if (storageValue == null && value == null) {
        isChecked.value = false;
      } else {
        isChecked.value = storageValue;
        if (value != null) {
          await _storageService.write('rememberMe', value);
          isChecked.value = await _storageService.read('rememberMe');
        }
      }
    } else {
      if (value != null) {
        await _storageService.write('rememberMe', value);
        isChecked.value = await _storageService.read('rememberMe');
      }
    }
  }

  login() async {
    loginLoading.value = false;
    Map<String, dynamic> request = {
      "P_USERNAME": loginUsernameController.text,
      "P_PASSWORD": loginPasswordController.text
    };
    try {
      final response = await _apiService.post("/PT_LOGIN", request);

      if (response['Result'] == "Success") {
        _storageService.write("result", response['Result']);
        _storageService.write("user", response['User']);
        _storageService.write("mainCompany", response['MainCompany']);
        _storageService.write("comId", response['ComId']);

        CustomeSnackbar.showSnackbar(
          title: response['Result'],
          message: "Login Successfull",
          backgroundColor: Colors.green,
          textColor: Colors.white,
          duration: const Duration(seconds: 2),
        );

        if (isChecked.value) {
          await _storageService.write('username', loginUsernameController.text);
          await _storageService.write('password', loginPasswordController.text);
        } else {
          await _storageService.remove('username');
          await _storageService.remove('password');
        }

        loginLoading.value = true;
        Future.delayed(
          const Duration(seconds: 2),
          () {
            Get.offAllNamed(RoutePath.homePath);
          },
        );
      } else {
        loginLoading.value = true;
        CustomeSnackbar.showSnackbar(
            title: response['Result'],
            message: response['Message'],
            backgroundColor: Colors.red,
            textColor: Colors.white,
            duration: const Duration(seconds: 2));
      }
    } catch (error) {
      loginLoading.value = true;
      log("Error: $error");
    }
  }
}
