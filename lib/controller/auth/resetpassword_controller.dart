import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transport_project/core/class/diohelper.dart';
import 'package:transport_project/core/class/statusrequest.dart';
import 'package:transport_project/core/constant/routes.dart';

abstract class ResetPasswordController extends GetxController {
  resetPassword();
  goToSuccess();
  toggleVisibility();
  checkPasswordStrength(String value);
}

class ResetPasswordControllerImp extends ResetPasswordController {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  late TextEditingController passwordController;
  late TextEditingController confirmController;

  bool isPasswordVisible = false;
  double strengthLevel = 0.0;
  String strengthText = "weak_label";

  StatusRequest? statusRequest;

  String email = "";

  @override
  void onInit() {
    passwordController = TextEditingController();
    confirmController = TextEditingController();

    email = Get.arguments?['email'] ?? "";
    super.onInit();
  }

  @override
  void onClose() {
    passwordController.dispose();
    confirmController.dispose();
    super.onClose();
  }

  @override
  goToSuccess() {
    Get.offAllNamed(AppRoute.successReset);
  }

  @override
  void toggleVisibility() {
    isPasswordVisible = !isPasswordVisible;
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
    } else {
      strengthLevel = 1.0;
      strengthText = "strong_label";
    }

    update(['strength_meter']);
  }

  @override
  resetPassword() async {
    var formData = formstate.currentState;

    if (formData == null) return;

    if (formData.validate()) {
      if (passwordController.text.trim() != confirmController.text.trim()) {
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
          url: 'v1/auth/reset-password',
          data: {
            'email': email,
            'password': passwordController.text.trim(),
            'password_confirmation': confirmController.text.trim(),
          },
        );

        print(response!.data);

        if (response.statusCode == 200) {
          statusRequest = StatusRequest.success;

          Get.snackbar(
            "success_title".tr,
            response.data['message'] ?? "password_changed_successfully".tr,
          );

          goToSuccess();
        } else {
          statusRequest = StatusRequest.failure;

          Get.snackbar(
            "warning_title".tr,
            response.data['message'] ?? "failed_to_reset_password".tr,
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
  }
}