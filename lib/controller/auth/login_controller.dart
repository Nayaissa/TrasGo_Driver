// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class AuthController extends GetxController {
//   String phoneNumber = '';
//   String password = '';
//   String newPassword = '';
//   String confirmPassword = '';
//   bool isPasswordVisible = false;
//   bool isNewPasswordVisible = false;
//   bool isConfirmPasswordVisible = false;

//   void togglePasswordVisibility() {
//     isPasswordVisible = !isPasswordVisible;
//     update(); // هكذا سيتم إعادة بناء الـ GetBuilder المرتبط
//   }

//   void toggleNewPasswordVisibility() {
//     isNewPasswordVisible = !isNewPasswordVisible;
//     update();
//   }

//   void toggleConfirmPasswordVisibility() {
//     isConfirmPasswordVisible = !isConfirmPasswordVisible;
//     update();
//   }

//   void login() {
//     if (password.length < 6) {
//       Get.snackbar("Error", "Invalid password. Please try again or reset it.",
//           backgroundColor: Colors.redAccent, colorText: Colors.white);
//     } else {
//       Get.snackbar("Success", "Login Successful",
//           backgroundColor: Colors.green, colorText: Colors.white);
//     }
//   }

//   void updatePassword() {
//     if (newPassword != confirmPassword) {
//       Get.snackbar("Error", "Passwords do not match",
//           backgroundColor: Colors.redAccent, colorText: Colors.white);
//     } else {
//       Get.snackbar("Success", "Password Updated",
//           backgroundColor: Colors.green, colorText: Colors.white);
//     }
//   }
// }
import 'package:get/get.dart';

class LoginController extends GetxController {
  bool isPasswordVisible = false;
  
  // وظيفة لتغيير رؤية كلمة المرور
  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    update(); // تحديث الـ GetBuilder
  }

  void login() {
    // منطق تسجيل الدخول هنا
    print("Login Pressed");
  }
}