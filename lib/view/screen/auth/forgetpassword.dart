import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transport_project/controller/auth/forgetpassword_controller.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // تعريف الـ Controller لمرة واحدة
    return GetBuilder<ForgotPasswordController>(
      init: ForgotPasswordController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: const Color(0xFF0F1221), // لون الخلفية الداكن
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildHeader(),
                  const SizedBox(height: 50),
                  const Text(
                    'Forgot Password',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Enter your phone number and we\'ll send\nyou a verification code.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white60, fontSize: 16),
                  ),
                  const SizedBox(height: 40),
                  _buildPhoneField(controller),
                  const SizedBox(height: 35),
                  _buildSendCodeButton(controller),
                  const SizedBox(height: 30),
                  _buildSignInLink(),
                  const SizedBox(height: 80),
                  _buildContactSupport(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // الجزء العلوي: أيقونة الرجوع واسم التطبيق
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4A64FE)),
          onPressed: () => Get.back(),
        ),
        const Text(
          'TransGo',
          style: TextStyle(
            color: Color(0xFF4A64FE),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 48), // لموازنة العنوان في المنتصف
      ],
    );
  }

  // حقل إدخال رقم الهاتف
  Widget _buildPhoneField(ForgotPasswordController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "PHONE NUMBER",
          style: TextStyle(color: Colors.white30, fontSize: 12, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: const Color(0xFF191D31),
            borderRadius: BorderRadius.circular(15),
          ),
          child: TextField(
            controller: controller.phoneController,
            onChanged: controller.onPhoneChanged,
            keyboardType: TextInputType.phone,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "(555) 000-0000",
              hintStyle: const TextStyle(color: Colors.white24),
              prefixIcon: SizedBox(
                width: 80,
                child: Row(
                  children: [
                    const Icon(Icons.flag, color: Colors.white, size: 20), // يمكن استبداله بصورة علم
                    const Icon(Icons.arrow_drop_down, color: Colors.white54),
                    const Text("+1", style: TextStyle(color: Colors.white, fontSize: 16)),
                    const SizedBox(width: 5),
                    Container(width: 1, height: 20, color: Colors.white10),
                  ],
                ),
              ),
              suffixIcon: GetBuilder<ForgotPasswordController>(
                id: 'suffix_id',
                builder: (ctrl) => ctrl.isPhoneValid
                    ? const Icon(Icons.check_circle, color: Color(0xFF4A64FE))
                    : const SizedBox.shrink(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // زر الإرسال مع التدرج اللوني
  Widget _buildSendCodeButton(ForgotPasswordController controller) {
    return GetBuilder<ForgotPasswordController>(
      id: 'btn_id',
      builder: (ctrl) {
        return InkWell(
          onTap: ctrl.sendCode,
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: LinearGradient(
                colors: ctrl.isPhoneValid
                    ? [const Color(0xFF6371FF), const Color(0xFF9E7BFF)]
                    : [Colors.grey.withAlpha(50), Colors.grey.withAlpha(30)],
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "Send Code",
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 10),
                Icon(Icons.arrow_forward, color: Colors.white),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSignInLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Remember your password? ", style: TextStyle(color: Colors.white54)),
        GestureDetector(
          onTap: () => Get.back(),
          child: const Text("Sign In", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildContactSupport() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.headset_mic_outlined, color: Colors.white54, size: 18),
          SizedBox(width: 10),
          Text(
            "CONTACT SUPPORT",
            style: TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}