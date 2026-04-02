import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transport_project/controller/auth/otp_controller.dart';
import 'package:transport_project/core/class/statusrequest.dart';
import 'package:transport_project/core/constant/AppColor.dart';
import 'package:transport_project/view/widget/auth/custom_appar_widget.dart';
import 'package:transport_project/view/widget/auth/custom_auth_button_widget.dart';

class VerifyOTPScreen extends StatelessWidget {
  VerifyOTPScreen({super.key});

  final VerfiyCodeControllerImp controller =
      Get.put(VerfiyCodeControllerImp());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GetBuilder<VerfiyCodeControllerImp>(
      builder: (_) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: true,
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark
                    ? [AppColor.primaryColor, AppColor.secondaryColor]
                    : [AppColor.primaryColorL, AppColor.secondaryColorL],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    CustomAppar(),
                    const SizedBox(height: 50),

                    Text(
                      "verify_otp_title".tr,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      "verify_otp_subtitle".tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: theme.hintColor),
                    ),

                    const SizedBox(height: 50),

                    /// 🔥 OTP BOXES
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        6,
                        (index) => _buildOTPBox(
                          context,
                          index,
                          first: index == 0,
                          last: index == 5,
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    /// ⏱️ TIMER
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.access_time,
                            color: Colors.white70,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Obx(
                            () => Text(
                              controller.timerText,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .copyWith(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 18,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// 🔁 RESEND
                    TextButton(
                      onPressed: () {
                        controller.startTimer();
                        // تقدر تضيف resend API هنا لاحقًا
                      },
                      child: Text(
                        "resend_code".tr,
                        style: TextStyle(color: theme.hintColor),
                      ),
                    ),

                    const SizedBox(height: 40),

                    /// 🔥 BUTTON + LOADING
                    controller.statusRequest == StatusRequest.loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : CustomAuthButton(
                            text: "verify_continue".tr,
                            onPressed: () {
                              controller.verifyOtp(); // 🔥 أهم تعديل
                            },
                          ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// 🔥 OTP BOX
  Widget _buildOTPBox(
    BuildContext context,
    int index, {
    bool first = false,
    bool last = false,
  }) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 48,
      height: 58,
      child: TextFormField(
        controller: controller.otpControllers[index], // 🔥 الربط
        autofocus: first,
        onChanged: (value) {
          if (value.length == 1 && !last) {
            FocusScope.of(context).nextFocus();
          }
          if (value.isEmpty && !first) {
            FocusScope.of(context).previousFocus();
          }
        },
        showCursor: false,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white70,
        ),
        keyboardType: TextInputType.number,
        maxLength: 1,
        decoration: InputDecoration(
          counterText: "",
          filled: true,
          fillColor: theme.brightness == Brightness.dark
              ? Colors.white.withOpacity(0.08)
              : Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}