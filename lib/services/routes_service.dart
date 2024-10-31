import 'package:get/get.dart';
import 'package:parent_app_by_ats/component/custome_drawer.dart';
import 'package:parent_app_by_ats/screens/additional_fee_voucher_screen.dart';
import 'package:parent_app_by_ats/screens/assignment_screen.dart';
import 'package:parent_app_by_ats/screens/complaint_screen.dart';
import 'package:parent_app_by_ats/screens/online_dairy_screen.dart';
import 'package:parent_app_by_ats/screens/result_screen.dart';
import 'package:parent_app_by_ats/screens/syllabus_screen.dart';

import '../injection/dependencie_injection.dart';
import '../screens/attendance_details_screen.dart';
import '../screens/attendance_screen.dart';
import '../screens/chat_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/fee_voucher_screen.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/notification_screen.dart';

import '../screens/splash_screen.dart';

import '../screens/voucher_fee_balance_screen.dart';
import 'routes_path.dart';

class RouteService {
  static final List<GetPage<dynamic>> routes = [
    GetPage(
      name: RoutePath.splashPath,
      page: () => const SplashScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
      binding: SplashBindings(),
    ),
    GetPage(
      name: RoutePath.loginPath,
      page: () => const LoginScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
      binding: AuthBindings(),
    ),
    // GetPage(
    //   name: RoutePath.basePath,
    //   page: () => const BaseScreenScreen(),
    //   transition: Transition.fadeIn,
    //   transitionDuration: const Duration(milliseconds: 500),
    //   binding: BottomNavBarBindings(),
    // ),
    GetPage(
      name: RoutePath.homePath,
      page: () => const HomeScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
      binding: HomeBindings(),
    ),
    GetPage(
      name: RoutePath.notificationPath,
      page: () => const NotificationScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
      binding: NotificationBindings(),
    ),
    GetPage(
      name: RoutePath.dashboardPath,
      page: () => const DashBoardScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
      binding: DashBoardBindings(),
    ),
    GetPage(
      name: RoutePath.menuPath,
      page: () => const CustomeDrawer(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: RoutePath.onlineDairy,
      page: () => const OnlineDairyScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
      binding: OnlineDairyBindings(),
    ),

    GetPage(
      name: RoutePath.assignment,
      page: () => const AssignmentScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
      binding: AssignmentBindings(),
    ),
    GetPage(
      name: RoutePath.complaintPath,
      page: () => ComplaintScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
      binding: ComplaintBindings(),
    ),
    GetPage(
      name: RoutePath.chatPath,
      page: () => ChatScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
      binding: ChatBindings(),
    ),
    GetPage(
      name: RoutePath.attendancePath,
      page: () => AttendanceScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
      binding: AttendanceBindings(),
    ),
    GetPage(
      name: RoutePath.attendanceDetailsPath,
      page: () => AttendanceDetailsScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
      binding: AttendanceDetailsBindings(),
    ),

    GetPage(
      name: RoutePath.resultPath,
      page: () => ResultScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
      binding: ResultBindings(),
    ),
    GetPage(
      name: RoutePath.feeVoucherPath,
      page: () => FeeVoucherScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
      binding: FeeVoucherBindings(),
    ),
    GetPage(
      name: RoutePath.additionalFeeVoucherPath,
      page: () => AdditionalFeeVoucherScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
      binding: AdditionalFeeVoucherBindings(),
    ),
    GetPage(
      name: RoutePath.voucherFeeBalancePath,
      page: () => VoucherFeeBalanceScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
      binding: VoucherFeeBalanceBindings(),
    ),
    
     GetPage(
      name: RoutePath.studentSyllabusPath,
      page: () => SyllabusScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
      binding: SyllabusBilding(),
    ),
  ];
}
