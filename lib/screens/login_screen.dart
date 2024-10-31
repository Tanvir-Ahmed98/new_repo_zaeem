import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parent_app_by_ats/component/custome_textformfield.dart';
import 'package:parent_app_by_ats/controller/auth_controller.dart';
import 'package:parent_app_by_ats/utils/image_path.dart';

import '../component/custome_text.dart';
import '../utils/color_const.dart';

class LoginScreen extends GetView<AuthController> {
  const LoginScreen({super.key});

  static const double _sigmaX = 5; // from 0-10
  static const double _sigmaY = 5; // from 0-10
  static const double _opacity = 0.2;

  @override
  Widget build(BuildContext context) {
    Get.put(AuthController());
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CarouselSlider(
                items: [
                  Image.asset(
                    ImagePath.loginScreenBg,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    fit: BoxFit.fill,
                    opacity: const AlwaysStoppedAnimation(0.7),
                  ),
                  Image.asset(
                    ImagePath.loginScreenBg2,
                    // width: MediaQuery.of(context).size.width,
                    // height: MediaQuery.of(context).size.height,
                    fit: BoxFit.fill,
                    opacity: const AlwaysStoppedAnimation(0.7),
                  ),
                ],
                options: CarouselOptions(
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayCurve: Curves.linear,
                  aspectRatio: 1,
                  viewportFraction: 1,
                  height: MediaQuery.of(context).size.height,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.26),
                  Align(
                    alignment: Alignment.center,
                    child: ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment(0.8, 1),
                        colors: <Color>[
                          Color(0xff1f005c),
                          Color(0xff5b0060),
                          Color(0xff870160),
                          Color(0xffac255e),
                          Color(0xffca485c),
                          Color(0xffe16b5c),
                          Color(0xfff39060),
                          Color(0xffffb56b),
                        ],
                      ).createShader(bounds),
                      child: const CustomeText(
                        text: 'Login',
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  ClipRect(
                    child: BackdropFilter(
                      filter:
                          ImageFilter.blur(sigmaX: _sigmaX, sigmaY: _sigmaY),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                            color: const Color.fromRGBO(0, 0, 0, 1)
                                .withOpacity(_opacity),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(30))),
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Form(
                          key: controller.loginGlobalFormkey,
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const CustomeText(
                                    text:
                                        "Let's login to your account for know about your child better",
                                    color: Colors.white,
                                    fontSize: 20,
                                    textAlign: TextAlign.start),
                                const SizedBox(height: 30),
                                CustomeTextFormField(
                                  controller:
                                      controller.loginUsernameController,
                                  hintText: 'Username',
                                ),
                                const SizedBox(height: 10),
                                CustomeTextFormField(
                                  controller:
                                      controller.loginPasswordController,
                                  hintText: 'Password',
                                  obscureText: true,
                                ),
                                const SizedBox(height: 30),
                                Obx(
                                  () => ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: const RoundedRectangleBorder(),
                                      backgroundColor: AppColors.greenColor,
                                    ),
                                    onPressed: () {
                                      if (controller
                                          .loginGlobalFormkey.currentState!
                                          .validate()) {
                                        controller
                                            .loginGlobalFormkey.currentState!
                                            .save();
                                        controller.login();
                                      }
                                    },
                                    child: controller.loginLoading.value
                                        ? const CustomeText(
                                            text: 'Login',
                                            color: AppColors.whiteColor,
                                          )
                                        : const CupertinoActivityIndicator(
                                            radius: 10,
                                            color: AppColors.defaultTextColor,
                                          ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Obx(
                                          () => Checkbox(
                                            value: controller.isChecked.value,
                                            onChanged: (value) {
                                              controller.rememberMe(
                                                  value: value);
                                            },
                                          ),
                                        ),
                                        const CustomeText(
                                          text: "Remember Me",
                                          fontSize: 12,
                                          color: AppColors.whiteColor,
                                        ),
                                      ],
                                    ),
                                    const CustomeText(
                                      text: "Forget Password?",
                                      color: AppColors.whiteColor,
                                      fontSize: 12,
                                    ),
                                  ],
                                ),
                                RichText(
                                  text: const TextSpan(
                                    text:
                                        'By selecting Agree & Continue below, I agree to our ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        color: AppColors.whiteColor),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text:
                                              'Terms of Service and Privacy Policy',
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 71, 233, 133),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12)),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
