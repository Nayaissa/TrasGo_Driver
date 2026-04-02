import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transport_project/controller/auth/successresetcontroller.dart';
import 'package:transport_project/core/constant/AppColor.dart';
import 'package:transport_project/view/widget/auth/custom_auth_button_widget.dart';

class ResetSuccessScreen extends StatelessWidget {
  const ResetSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GetBuilder<ResetSuccessController>(
      init: ResetSuccessController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColor.primaryColor,
          body: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                _buildSuccessIcon(),
                const SizedBox(height: 55),
                Text(
                  "reset_success_title".tr,
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  "reset_success_subtitle".tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: theme.hintColor),
                ),
                const Spacer(),
                CustomAuthButton(
                  text: 'back_to_login'.tr,
                  onPressed: () {
                    controller.goToLogin();
                  },
                ),
                const SizedBox(height: 25),
                Text(
                  "secure_session_active".tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: theme.hintColor),
                ),
                const Spacer(),
                _buildSystemStatus(context),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSuccessIcon() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4A64FE).withOpacity(0.2),
                blurRadius: 50,
                spreadRadius: 10,
              ),
            ],
          ),
        ),
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: const Color(0xFF191D31),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFF7B8CFF), Color(0xFFD497FF)],
                ),
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 30),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSystemStatus(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFF161B2E),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shield_outlined,
              color: Colors.blueAccent,
              size: 18,
            ),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "system_status".tr,
                style: const TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "encrypted_connection_verified".tr,
                textAlign: TextAlign.center,
                style: TextStyle(color: theme.hintColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
