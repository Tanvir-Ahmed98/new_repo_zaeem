import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:get/get.dart';
import '../component/custome_text.dart';
import '../controller/splash_controller.dart';
import '../utils/color_const.dart';
import '../utils/image_path.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SplashController());
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipPath(
              clipper: SplashTopCliper(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                child: Image.asset(
                  ImagePath.splashLogo1,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Positioned(
              bottom: -15,
              left: -30,
              child: ClipPath(
                clipper: WavyCircleClipper(10),
                child: Container(
                  color: AppColors.blueColor.withOpacity(0.1),
                  height: 100,
                  width: 120,
                  child: Center(
                    child: Image.asset(
                      ImagePath.splashLogo3,
                      fit: BoxFit.fill,
                      height: 50,
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: FadeTransition(
                opacity: controller.animation,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      ImagePath.appLogo,
                      fit: BoxFit.fill,
                      height: 150,
                      width: 150,
                    ),
                    ShaderMask(
                      blendMode: BlendMode.srcIn,
                      shaderCallback: (bounds) {
                        return const LinearGradient(
                                colors: [Color(0xFFC33764), Color(0xFF1D2671)])
                            .createShader(bounds);
                      },
                      child: const CustomeText(
                        text: 'Parents App',
                        fontSize: 44,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      width: 250,
                      child: CustomeText(
                        text: 'Get your child every information from this app',
                        fontSize: 16,
                        textAlign: TextAlign.center,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: -10,
              right: -50,
              child: ClipPath(
                clipper: WavyCircleClipper(18),
                child: SizedBox(
                  height: 120,
                  width: 200,
                  child: Center(
                    child: Image.asset(
                      ImagePath.splashLogo2,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SplashTopCliper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    var x = size.width;
    var y = size.height * 0.6;
    path.moveTo(0, 0); // a
    path.lineTo(0, y); // b
    path.quadraticBezierTo(x * 0.5, y + 50, x, y);
    //path.lineTo(x, y); // c
    path.lineTo(x, 0); //d
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
