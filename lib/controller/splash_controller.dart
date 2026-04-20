import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transport_project/view/screen/auth/loginscreen.dart';
class SplashController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> progress;

  @override
  void onInit() {
    super.onInit();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();

    progress = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    );

    _startLoading();
  }

  Future<void> _startLoading() async {
    await Future.delayed(const Duration(milliseconds: 2000));
    Get.offAll(LoginScreen());
  }

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }
}