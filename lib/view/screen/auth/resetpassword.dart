import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transport_project/controller/auth/resetpassword_controller.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ResetPasswordController>(
      init: ResetPasswordController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: const Color(0xFF0D111F),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildHeader(),
                  const SizedBox(height: 40),
                  _buildTitleSection(),
                  const SizedBox(height: 40),
                  _buildLabel("NEW PASSWORD"),
                  _buildPasswordField(controller),
                  const SizedBox(height: 15),
                  _buildStrengthMeter(controller),
                  const SizedBox(height: 30),
                  _buildLabel("CONFIRM PASSWORD"),
                  _buildConfirmField(controller),
                  const SizedBox(height: 40),
                  _buildUpdateButtonStyle(controller),
                  const SizedBox(height: 30),
                  _buildFooterNote(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.white.withOpacity(0.1),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF4A64FE), size: 20),
            onPressed: () => Get.back(),
          ),
        ),
        const SizedBox(width: 15),
        const Text("TransGo", style: TextStyle(color: Color(0xFF4A64FE), fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildTitleSection() {
    return Column(
      children: [
        const Text("Reset", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
        const Text("Password", style: TextStyle(color: Color(0xFF4A64FE), fontSize: 32, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        const Text(
          "Create a new strong password for your account.",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white54, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(text, style: const TextStyle(color: Colors.white38, fontSize: 10, letterSpacing: 1.5)),
    );
  }

  // حقل كلمة المرور الأبيض
  Widget _buildPasswordField(ResetPasswordController controller) {
    return GetBuilder<ResetPasswordController>(
      id: 'password_field',
      builder: (ctrl) => Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
        child: TextField(
          controller: ctrl.passwordController,
          obscureText: !ctrl.isPasswordVisible,
          onChanged: ctrl.checkPasswordStrength,
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            suffixIcon: IconButton(
              icon: Icon(ctrl.isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.grey),
              onPressed: ctrl.toggleVisibility,
            ),
          ),
        ),
      ),
    );
  }

  // مقياس القوة (مقطع إلى 4 أجزاء كما في الصورة)
  Widget _buildStrengthMeter(ResetPasswordController controller) {
    return GetBuilder<ResetPasswordController>(
      id: 'strength_meter',
      builder: (ctrl) => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("SECURITY STATUS", style: TextStyle(color: Colors.white30, fontSize: 9)),
              Text(ctrl.strengthText, style: const TextStyle(color: Color(0xFF4A64FE), fontSize: 9, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(4, (index) {
              bool isActive = ctrl.strengthLevel > (index / 4);
              return Expanded(
                child: Container(
                  height: 4,
                  margin: EdgeInsets.only(right: index == 3 ? 0 : 5),
                  decoration: BoxDecoration(
                    color: isActive ? const Color(0xFF4A64FE) : Colors.white10,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmField(ResetPasswordController controller) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
      child: TextField(
        controller: controller.confirmController,
        obscureText: true,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        ),
      ),
    );
  }

  Widget _buildUpdateButtonStyle(ResetPasswordController controller) {
    return GetBuilder<ResetPasswordController>(
      id: 'button_id',
      builder: (ctrl) => InkWell(
        onTap: ctrl.updatePassword,
        child: Container(
          width: double.infinity,
          height: 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: const LinearGradient(
              colors: [Color(0xFF3F66F6), Color(0xFFD497FF)], // تدرج أزرق إلى بنفسجي
            ),
          ),
          child: const Center(
            child: Text(
              "Update Password  →",
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooterNote() {
    return const Text(
      "Password must be at least 12 characters and include a mix of uppercase, numbers, and symbols.",
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.white30, fontSize: 12, height: 1.5),
    );
  }
}