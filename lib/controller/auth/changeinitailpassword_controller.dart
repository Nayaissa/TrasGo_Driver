import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transport_project/core/class/diohelper.dart';
import 'package:transport_project/core/class/statusrequest.dart';
import 'package:transport_project/core/constant/routes.dart';
import 'package:transport_project/core/functions/vaildinput.dart';

abstract class ChangeInitialPasswordController extends GetxController {
  toggleCurrentPasswordVisibility();
  toggleNewPasswordVisibility();
  toggleConfirmPasswordVisibility();
  checkPasswordStrength(String value);
  changeInitialPassword();
}

class ChangeInitialPasswordControllerImp
    extends ChangeInitialPasswordController {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  late TextEditingController emailController;
  late TextEditingController currentPasswordController;
  late TextEditingController newPasswordController;
  late TextEditingController confirmPasswordController;

  bool isCurrentPasswordVisible = false;
  bool isNewPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  double strengthLevel = 0.0;
  String strengthText = "weak_label";

  StatusRequest? statusRequest;

  @override
  void onInit() {
    emailController = TextEditingController();
    currentPasswordController = TextEditingController();
    newPasswordController = TextEditingController();
    confirmPasswordController = TextEditingController();

    final args = Get.arguments;
    if (args != null && args['email'] != null) {
      emailController.text = args['email'];
    }

    super.onInit();
  }

  @override
  void onClose() {
    emailController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  @override
  void toggleCurrentPasswordVisibility() {
    isCurrentPasswordVisible = !isCurrentPasswordVisible;
    update();
  }

  @override
  void toggleNewPasswordVisibility() {
    isNewPasswordVisible = !isNewPasswordVisible;
    update();
  }

  @override
  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible = !isConfirmPasswordVisible;
    update();
  }

  @override
  void checkPasswordStrength(String value) {
    if (value.isEmpty) {
      strengthLevel = 0.0;
      strengthText = "weak_label";
    } else if (value.length < 6) {
      strengthLevel = 0.25;
      strengthText = "weak_label";
    } else if (value.length < 10) {
      strengthLevel = 0.5;
      strengthText = "fair_label";
    } else if (value.length < 14) {
      strengthLevel = 0.75;
      strengthText = "good_label";
    } else {
      strengthLevel = 1.0;
      strengthText = "strong_label";
    }

    update(['strength_meter']);
  }

  @override
  Future<void> changeInitialPassword() async {
    final formData = formstate.currentState;
    if (formData == null) return;

    if (!formData.validate()) return;

    if (newPasswordController.text.trim() !=
        confirmPasswordController.text.trim()) {
      Get.snackbar(
        "warning_title".tr,
        "password_confirmation_not_match".tr,
      );
      return;
    }

    try {
      statusRequest = StatusRequest.loading;
      update();

      final response = await DioHelper.postsData(
        url: 'v1/auth/change-initial-password',
        data: {
          'email': emailController.text.trim(),
          'current_password': currentPasswordController.text.trim(),
          'new_password': newPasswordController.text.trim(),
          'new_password_confirmation':
              confirmPasswordController.text.trim(),
        },
      );

      print(response!.data);

      if (response.statusCode == 200) {
        statusRequest = StatusRequest.success;

        Get.snackbar(
          "success_title".tr,
          response.data['message'] ?? "password_changed_successfully".tr,
        );

        Get.offAllNamed(AppRoute.login);
      } else {
        statusRequest = StatusRequest.failure;

        Get.snackbar(
          "warning_title".tr,
          response.data['message'] ?? "failed_to_change_password".tr,
        );
      }
    } catch (e) {
      print(e.toString());
      statusRequest = StatusRequest.serverfailure;

      Get.snackbar(
        "error_title".tr,
        "server_error".tr,
      );
    }

    update();
  }

  String? validateEmail(String? val) {
    return validInput(val!, 5, 100, "email");
  }

  String? validateCurrentPassword(String? val) {
    return validInput(val!, 6, 100, "password");
  }

  String? validateNewPassword(String? val) {
    return validInput(val!, 6, 100, "password");
  }

  String? validateConfirmPassword(String? val) {
    return validInput(val!, 6, 100, "password");
  }
}