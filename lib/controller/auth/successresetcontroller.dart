import 'package:get/get.dart';

class ResetSuccessController extends GetxController {
  void goToLogin() {
    // الانتقال لصفحة تسجيل الدخول وإزالة الصفحات السابقة من الذاكرة
    Get.offAllNamed('/login'); 
  }
}