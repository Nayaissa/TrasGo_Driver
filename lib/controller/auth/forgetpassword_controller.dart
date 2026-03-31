import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  final TextEditingController phoneController = TextEditingController();
  bool isPhoneValid = false;

  void onPhoneChanged(String value) {
    if (value.length > 8) {
      if (!isPhoneValid) {
        isPhoneValid = true;
        update(['btn_id', 'suffix_id']); // تحديث أجزاء محددة فقط للكفاءة
      }
    } else {
      if (isPhoneValid) {
        isPhoneValid = false;
        update(['btn_id', 'suffix_id']);
      }
    }
  }

  void sendCode() {
    if (isPhoneValid) {
      print("Sending code to: ${phoneController.text}");
    }
  }

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }
}