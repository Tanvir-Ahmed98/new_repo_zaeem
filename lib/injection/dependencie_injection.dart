import 'package:get/get.dart';
import 'package:parent_app_by_ats/controller/attendance_controller.dart';
import 'package:parent_app_by_ats/controller/online_dairy_controller.dart';
import 'package:parent_app_by_ats/controller/syllabus_controller.dart';
import '../controller/additional_voucher_controller.dart';
import '../controller/assignment_controller.dart';
import '../controller/attendance_details_controller.dart';
import '../controller/auth_controller.dart';
import '../controller/bottom_nav_controller.dart';
import '../controller/chat_controller.dart';
import '../controller/complaint_controller.dart';
import '../controller/dashboard_controller.dart';
import '../controller/fee_voucher_controller.dart';
import '../controller/home_controller.dart';
import '../controller/notification_controller.dart';
import '../controller/result_controller.dart';
import '../controller/splash_controller.dart';
import '../controller/voucher_fee_balance_controller.dart';

class SplashBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashController());
  }
}

class AuthBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController());
  }
}

class BottomNavBarBindings extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<BottomNavbarController>(() => BottomNavbarController());
    Get.put(BottomNavbarController());
  }
}

class HomeBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
  }
}

class NotificationBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationController>(() => NotificationController());
    Get.lazyPut<BottomNavbarController>(() => BottomNavbarController());
  }
}

class DashBoardBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashBoardController>(() => DashBoardController());
    Get.lazyPut<BottomNavbarController>(() => BottomNavbarController());
  }
}

class OnlineDairyBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(OnlineDairyController());
  }
}

class AssignmentBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(AssignmentController());
  }
}

class ComplaintBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(ComplaintController());
  }
}

class ChatBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(ChatController());
  }
}

class AttendanceBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(AttendanceController());
  }
}

class AttendanceDetailsBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(AttendanceDetailsController());
  }
}

class ResultBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(ResultController());
  }
}

class FeeVoucherBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(FeeVoucherController());
  }
}

class AdditionalFeeVoucherBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(AdditionalFeeVoucherController());
  }
}

class VoucherFeeBalanceBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(VoucherFeeBalanceController());
  }
}
//SyllabusBilding
class SyllabusBilding extends Bindings {
  @override
  void dependencies() {
    Get.put(SyllabusController());
  }
}