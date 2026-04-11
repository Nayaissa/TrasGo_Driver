import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transport_project/controller/home/home_screen_controller.dart';
import 'package:transport_project/view/widget/home/bottom_nav_bar.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeScreenController controller = Get.put(HomeScreenController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeScreenController>(
      builder: (controller) {
        return Scaffold(
          extendBody: true,
          resizeToAvoidBottomInset: false,
          backgroundColor: const Color(0xFF081225),
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
