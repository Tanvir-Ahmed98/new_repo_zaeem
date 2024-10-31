import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'services/routes_path.dart';
import 'services/routes_service.dart';
import 'utils/color_const.dart';

void main() async {
  runApp(
      // DevicePreview(
      //   enabled: !kReleaseMode,
      //   builder: (context) => const MyApp(), // Wrap your app
      // ),
      const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // useInheritedMediaQuery: true,
      // locale: DevicePreview.locale(context),
      // builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,
      // home: const Scaffold(
      //   body: SplashScreen(),
      // ),
      initialRoute: RoutePath.splashPath,
      getPages: RouteService.routes,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.secondaryColor,
        cardColor: AppColors.blueColor,
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
    );
  }
}
