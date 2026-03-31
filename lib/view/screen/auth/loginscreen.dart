import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transport_project/controller/auth/login_controller.dart';
import 'package:transport_project/core/constant/AppColor.dart';
import 'package:transport_project/core/localization/local_controller.dart';
import 'package:transport_project/view/screen/auth/forgetpassword.dart';
import 'package:transport_project/view/screen/auth/otpscreen.dart';
import 'package:transport_project/view/screen/auth/resetpassword.dart';
import 'package:transport_project/view/screen/auth/success_resetpassword.dart';
import 'package:transport_project/view/widget/custom_auth_button_widget.dart';
import 'package:transport_project/view/widget/custom_label_widget.dart';
import 'package:transport_project/view/widget/custom_passtext_filed.dart';
import 'package:transport_project/view/widget/custom_text_filed.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: GetBuilder<LoginController>(
        init: LoginController(),
        builder: (controller) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors:
                    isDark
                        ? [AppColor.primaryColor, AppColor.secondaryColor]
                        : [AppColor.primaryColorL, AppColor.secondaryColorL],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.dark_mode),
                      onPressed: () {
                        Get.find<LocalController>().toggleTheme();
                      },
                    ),
                    Image.asset(
                      'assets/images/download.png',
                      height: 170,
                      fit: BoxFit.fill,
                    ),
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color:
                            isDark
                                ? Colors.white.withOpacity(0.05)
                                : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color:
                              isDark
                                  ? Colors.white10
                                  : Colors.black.withOpacity(0.05),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome Back",
                            style: Theme.of(context).textTheme.headlineSmall!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Login to continue your journey",
                            style: TextStyle(color: theme.hintColor),
                          ),
                          const SizedBox(height: 30),
                          CustomLabel(text: 'PHONE'),
                          CustomTextFiled(
                            hint: "000 000 0000",
                            icon: Icons.phone_iphone,
                          ),
                          const SizedBox(height: 20),
                          CustomLabel(text: "PASSWORD"),
                          CustomPassTextFiled(),

                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Get.to(ResetSuccessScreen());
                              },
                              child: Text(
                                "Forgot Password?",
                                style: TextStyle(color: theme.primaryColor),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          CustomAuthButton(
                            text: 'Login',
                            onPressed: () {
                              controller.login();
                            },
                          ),
                          const SizedBox(height: 25),

                          _buildOutlineButton(context),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),
                    Text(
                      "© 2026 TransGo Logistics. Premium Drive Experience.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: theme.hintColor.withOpacity(0.4),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOutlineButton(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: theme.dividerColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          backgroundColor:
              theme.brightness == Brightness.dark
                  ? Colors.white.withOpacity(0.03)
                  : Colors.transparent,
        ),
        child: Text(
          "Become a TransGo Driver",
          style: TextStyle(color: theme.textTheme.bodyLarge?.color),
        ),
      ),
    );
  }
}
