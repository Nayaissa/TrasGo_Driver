import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transport_project/core/class/diohelper.dart';
import 'package:transport_project/core/class/statusrequest.dart';
import 'package:transport_project/core/constant/routes.dart';

abstract class VerfiyCodeController extends GetxController {
  verifyOtp();
  goToReset();
}

class VerfiyCodeControllerImp extends VerfiyCodeController {
  RxInt timerCount = 119.obs;
  Timer? _timer;

  List<TextEditingController> otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );

  String email = "";

  StatusRequest? statusRequest;

  @override
  void onInit() {
    email = Get.arguments['email'];
    startTimer();
    super.onInit();
  }

  String getOtpCode() {
    return otpControllers.map((e) => e.text).join();
  }

  @override
  verifyOtp() async {
    String otp = getOtpCode();

    if (otp.length < 6) {
      Get.snackbar("error_title".tr, "enter_complete_otp".tr);
      return;
    }

    try {
      statusRequest = StatusRequest.loading;
      update();

      final response = await DioHelper.postsData(
        url: 'v1/auth/verify-otp',
        data: {"email": email, "otp": otp},
      );

      print(response!.data);

      if (response.statusCode == 200) {
        statusRequest = StatusRequest.success;

        Get.snackbar(
          "success_title".tr,
          response.data['message'] ?? 'verified_message'.tr,
        );

        goToReset();
      } else {
        statusRequest = StatusRequest.failure;

        Get.snackbar(
          "warning_title".tr,
          response.data['message'] ?? 'invalid_otp'.tr,
        );
      }
    } catch (e) {
      print(e.toString());
      statusRequest = StatusRequest.serverfailure;

      Get.snackbar("error_title".tr, "server_error".tr);
    }

    update();
  }

  @override
  goToReset() {
    Get.toNamed(AppRoute.resetPassword, arguments: {"email": email});
  }

  void startTimer() {
    _timer?.cancel();
    timerCount.value = 119;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timerCount.value > 0) {
        timerCount.value--;
      } else {
        _timer?.cancel();
      }
    });
  }

  String get timerText {
    int minutes = timerCount.value ~/ 60;
    int seconds = timerCount.value % 60;

    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void onClose() {
    for (var c in otpControllers) {
      c.dispose();
    }
    _timer?.cancel();
    super.onClose();
  }
}
