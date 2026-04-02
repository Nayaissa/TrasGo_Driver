import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transport_project/controller/auth/forgetpassword_controller.dart';
import 'package:transport_project/core/class/statusrequest.dart';
import 'package:transport_project/core/constant/AppColor.dart';
import 'package:transport_project/core/functions/vaildinput.dart';
import 'package:transport_project/view/widget/auth/custom_appar_widget.dart';
import 'package:transport_project/view/widget/auth/custom_auth_button_widget.dart';
import 'package:transport_project/view/widget/auth/custom_label_widget.dart';
import 'package:transport_project/view/widget/auth/custom_text_filed.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GetBuilder<ForgotPasswordControllerImp>(
      init: ForgotPasswordControllerImp(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColor.primaryColor,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Form(
                key: controller.formstate,
                child: Column(
                  children: [
                    CustomAppar(),
                    const SizedBox(height: 50),

                    Text(
                      'forgot_password_title'.tr,
                      style: Theme.of(context).textTheme.headlineSmall!
                          .copyWith(fontWeight: FontWeight.bold, fontSize: 28),
                    ),

                    const SizedBox(height: 15),

                    Text(
                      'forgot_password_subtitle'.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: theme.hintColor),
                    ),

                    const SizedBox(height: 40),

                    CustomLabel(text: 'email_label'.tr),

                    CustomTextFiled(
                      controller: controller.email,
                      hint: 'email_hint'.tr,
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (val) {
                        return validInput(val!, 5, 100, "email");
                      },
                    ),

                    const SizedBox(height: 40),

                    controller.statusRequest == StatusRequest.loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : CustomAuthButton(
                          text: 'send_code'.tr,
                          onPressed: () {
                            controller.sendOtp();
                          },
                        ),

                    const SizedBox(height: 30),

                    //  _buildSignInLink(),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Widget _buildSignInLink() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       Text(
  //         'remember_password'.tr,
  //         style: const TextStyle(color: Colors.white54),
  //       ),
  //       GestureDetector(
  //         onTap: () => Get.back(),
  //         child: Text(
  //           'sign_in'.tr,
  //           style: const TextStyle(
  //             color: Colors.white,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }
}
