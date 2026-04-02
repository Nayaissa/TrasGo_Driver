import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transport_project/controller/auth/login_controller.dart';
import 'package:transport_project/core/constant/AppColor.dart';
import 'package:transport_project/core/functions/vaildinput.dart';
import 'package:transport_project/core/constant/routes.dart';
import 'package:transport_project/core/localization/local_controller.dart';
import 'package:transport_project/view/widget/auth/custom_auth_button_widget.dart';
import 'package:transport_project/view/widget/auth/custom_label_widget.dart';
import 'package:transport_project/view/widget/auth/custom_passtext_filed.dart';
import 'package:transport_project/view/widget/auth/custom_text_filed.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Get.put(LoginControllerImp());

    return Scaffold(
      body: GetBuilder<LoginControllerImp>(
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
                child: Form(
                  key: controller.formstate,
                  child: Column(
                    children: [
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
                              "welcome_back".tr,
                              style: Theme.of(context).textTheme.headlineSmall!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            // ElevatedButton(
                            //   onPressed: () {
                            //     Get.find<LocalController>().changeLang('ar');
                            //   },
                            //   child: const Text("AR"),
                            // ),
                            // ElevatedButton(
                            //   onPressed: () {
                            //     Get.find<LocalController>().changeLang('en');
                            //   },
                            //   child: const Text("EN"),
                            // ),
                            const SizedBox(height: 4),
                            Text(
                              "login_subtitle".tr,
                              style: TextStyle(color: theme.hintColor),
                            ),
                            const SizedBox(height: 30),

                            CustomLabel(text: 'email_label'.tr),
                            CustomTextFiled(
                              controller: controller.email,
                              hint: "email_hint".tr,
                              icon: Icons.email_outlined,
                              validator: (val) {
                                return validInput(val!, 5, 100, "email");
                              },
                            ),

                            const SizedBox(height: 20),

                            CustomLabel(text: "password_label".tr),
                            CustomPassTextFiled(
                              controller: controller.password,
                              obscureText: !controller.isPasswordVisible,
                              iconData:
                                  controller.isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                              onPressedIcon:
                                  controller.togglePasswordVisibility,
                              validator: (val) {
                                return validInput(val!, 6, 30, "password");
                              },
                            ),

                            const SizedBox(height: 10),

                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  controller.goToForget();
                                },
                                child: Text(
                                  "forgot_password_question".tr,
                                  style: TextStyle(color: theme.primaryColor),
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            CustomAuthButton(
                              text: 'login_button'.tr,
                              onPressed: () {
                                controller.login();
                              },
                            ),

                            const SizedBox(height: 10),

                            Center(
                              child: TextButton(
                                onPressed: () {
                                  Get.toNamed(AppRoute.changeinitailpassword);
                                },
                                child: Text(
                                  "first_time_login_change_password".tr,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: theme.hintColor.withOpacity(0.9),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 25),

                            _buildOutlineButton(context),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      Text(
                        "login_footer".tr,
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
          "become_driver".tr,
          style: TextStyle(color: theme.textTheme.bodyLarge?.color),
        ),
      ),
    );
  }
}
