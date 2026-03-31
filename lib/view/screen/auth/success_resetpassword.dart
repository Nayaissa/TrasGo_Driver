import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transport_project/controller/auth/successresetcontroller.dart';

class ResetSuccessScreen extends StatelessWidget {
  const ResetSuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ResetSuccessController>(
      init: ResetSuccessController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: const Color(0xFF0D111F),
          body: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                _buildSuccessIcon(),
                const SizedBox(height: 40),
                const Text(
                  "Password Updated!",
                  style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                const Text(
                  "Your password has been changed\nsuccessfully. You can now login with your\nnew credentials.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white54, fontSize: 14, height: 1.5),
                ),
                const Spacer(),
                _buildBackToLoginButton(controller),
                const SizedBox(height: 25),
                const Text(
                  "SECURE SESSION ACTIVE",
                  style: TextStyle(color: Colors.white12, fontSize: 12, letterSpacing: 2),
                ),
                const Spacer(),
                _buildSystemStatus(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  // أيقونة النجاح مع تأثير الهالة (Glow)
  Widget _buildSuccessIcon() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // الهالة الخلفية
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
        // المربع المنحني الأساسي
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
                gradient: LinearGradient(colors: [Color(0xFF7B8CFF), Color(0xFFD497FF)]),
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 30),
            ),
          ),
        ),
      ],
    );
  }

  // الزر المتدرج العريض
  Widget _buildBackToLoginButton(ResetSuccessController controller) {
    return InkWell(
      onTap: controller.goToLogin,
      child: Container(
        width: double.infinity,
        height: 55,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            colors: [Color(0xFF3F66F6), Color(0xFFD497FF)],
          ),
        ),
        child: const Center(
          child: Text(
            "Back to Login",
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  // شريط حالة النظام في الأسفل
  Widget _buildSystemStatus() {
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
            decoration: const BoxDecoration(color: Color(0xFF161B2E), shape: BoxShape.circle),
            child: const Icon(Icons.shield_outlined, color: Colors.blueAccent, size: 18),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("SYSTEM STATUS", style: TextStyle(color: Colors.blueAccent, fontSize: 10, fontWeight: FontWeight.bold)),
              Text("Encrypted connection verified.", style: TextStyle(color: Colors.white38, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}