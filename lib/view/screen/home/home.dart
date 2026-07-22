import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transport_project/controller/profile/driver_profile_controller.dart';
import 'package:transport_project/controller/home/home_screen_controller.dart';
import 'package:transport_project/core/constant/AppColor.dart';
import 'package:transport_project/view/widget/home/bottom_nav_bar.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeScreenController controller = Get.put(HomeScreenController());

  void _initControllers() {
    if (!Get.isRegistered<DriverProfileControllerImp>()) {
      Get.put(DriverProfileControllerImp(), permanent: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    _initControllers();

    return GetBuilder<HomeScreenController>(
      builder: (controller) {
        return Scaffold(
          extendBody: true,
          resizeToAvoidBottomInset: false,
          backgroundColor: AppColor.primaryColor,
          body: SafeArea(
            child: Stack(
              children: [
                controller.pages.elementAt(controller.currentPage),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: SafeArea(
                    top: false,
                    child: BottomNavBar(controller: controller),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}