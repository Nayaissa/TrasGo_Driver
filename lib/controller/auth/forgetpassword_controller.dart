import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transport_project/core/class/diohelper.dart';
import 'package:transport_project/core/class/statusrequest.dart';
import 'package:transport_project/core/constant/routes.dart';

abstract class ForgotPasswordController extends GetxController {
  sendOtp();
  goToOtp();
}

class ForgotPasswordControllerImp extends ForgotPasswordController {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  late TextEditingController email;

  StatusRequest? statusRequest;

  @override
  void onInit() {
    email = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    email.dispose();
    super.dispose();
  }

  @override
  goToOtp() {
    Get.toNamed(
      AppRoute.verfiyCode,
      arguments: {
        "email": email.text.trim(),
      },
    );
  }

  @override
  sendOtp() async {
    var formData = formstate.currentState;

    if (formData == null) return;

    if (formData.validate()) {
      try {
        statusRequest = StatusRequest.loading;
        update();

        final response = await DioHelper.postsData(
          url: 'v1/auth/send-otp',
          data: {
            'email': email.text.trim(),
          },
        );

        print(response!.data);

        if (response.statusCode == 200) {
          statusRequest = StatusRequest.success;

          Get.snackbar(
            'success_title'.tr,
            response.data['message'] ?? 'otp_sent_successfully'.tr,
          );

          goToOtp();
        } else {
          statusRequest = StatusRequest.failure;

          Get.snackbar(
            'warning_title'.tr,
            response.data['message'] ?? 'failed_to_send_otp'.tr,
          );
        }
      } catch (e) {
        print(e.toString());
        statusRequest = StatusRequest.serverfailure;

        Get.snackbar(
          'error_title'.tr,
          'server_error'.tr,
        );
      }

      update();
    }
  }
}