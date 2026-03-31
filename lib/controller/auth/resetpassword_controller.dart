import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordController extends GetxController {
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  
  bool isPasswordVisible = false;
  double strengthLevel = 0.0; // من 0 إلى 1
  String strengthText = "WEAK";

  void toggleVisibility() {
    isPasswordVisible = !isPasswordVisible;
    update(['password_field']);
  }

  void checkPasswordStrength(String value) {
    // منطق بسيط لحساب القوة
    if (value.isEmpty) {
      strengthLevel = 0.0;
      strengthText = "WEAK";
    } else if (value.length < 6) {
      strengthLevel = 0.25;
      strengthText = "WEAK";
    } else if (value.length < 10) {
      strengthLevel = 0.5;
      strengthText = "FAIR";
    } else {
      strengthLevel = 1.0;
      strengthText = "STRONG";
    }
    update(['strength_meter', 'button_id']);
  }

  void updatePassword() {
    if (strengthLevel == 1.0 && passwordController.text == confirmController.text) {
      Get.snackbar("Success", "Password Updated!", colorText: Colors.white);
    }
  }
}