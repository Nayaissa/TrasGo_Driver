import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transport_project/controller/auth/changeinitailpassword_controller.dart';
import 'package:transport_project/core/class/statusrequest.dart';
import 'package:transport_project/core/constant/AppColor.dart';
import 'package:transport_project/view/widget/auth/custom_appar_widget.dart';
import 'package:transport_project/view/widget/auth/custom_auth_button_widget.dart';
import 'package:transport_project/view/widget/auth/custom_label_widget.dart';
import 'package:transport_project/view/widget/auth/custom_passtext_filed.dart';
import 'package:transport_project/view/widget/auth/custom_strength_meter%20.dart';
import 'package:transport_project/view/widget/auth/custom_text_filed.dart';

class ChangeInitialPasswordScreen extends StatelessWidget {
  const ChangeInitialPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GetBuilder<ChangeInitialPasswordControllerImp>(
      init: ChangeInitialPasswordControllerImp(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColor.primaryColor,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Form(
                key: controller.formstate,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomAppar(),
                    const SizedBox(height: 50),

                    Text(
                      'Change Initial Password',
                      style: Theme.of(context).textTheme.headlineSmall!
                          .copyWith(fontWeight: FontWeight.bold, fontSize: 28),
                    ),

                    const SizedBox(height: 15),

                    Text(
                      'Create a new secure password before continuing.',
                      textAlign: TextAlign.start,
                      style: TextStyle(color: theme.hintColor),
                    ),

                    const SizedBox(height: 40),

                    const CustomLabel(text: 'Email'),
                    CustomTextFiled(
                      controller: controller.emailController,
                      hint: 'Enter your email',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: controller.validateEmail,
                    ),

                    const SizedBox(height: 30),

                    const CustomLabel(text: 'Current Password'),
                    CustomPassTextFiled(
                      controller: controller.currentPasswordController,
                      obscureText: !controller.isCurrentPasswordVisible,
                      iconData:
                          controller.isCurrentPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                      onPressedIcon: controller.toggleCurrentPasswordVisibility,
                      validator: controller.validateCurrentPassword,
                    ),

                    const SizedBox(height: 30),

                    const CustomLabel(text: 'New Password'),
                    CustomPassTextFiled(
                      controller: controller.newPasswordController,
                      obscureText: !controller.isNewPasswordVisible,
                      iconData:
                          controller.isNewPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                      onPressedIcon: controller.toggleNewPasswordVisibility,
                      validator: controller.validateNewPassword,
                      onChanged: (value) {
                        controller.checkPasswordStrength(value);
                      },
                    ),

                    const SizedBox(height: 15),

                    GetBuilder<ChangeInitialPasswordControllerImp>(
                      id: 'strength_meter',
                      builder: (controller) {
                        return CustomStrengthMeter(
                          strengthText: controller.strengthText,
                          strengthLevel: controller.strengthLevel,
                        );
                      },
                    ),

                    const SizedBox(height: 30),

                    const CustomLabel(text: 'Confirm New Password'),
                    CustomPassTextFiled(
                      controller: controller.confirmPasswordController,
                      obscureText: !controller.isConfirmPasswordVisible,
                      iconData:
                          controller.isConfirmPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                      onPressedIcon: controller.toggleConfirmPasswordVisibility,
                      validator: controller.validateConfirmPassword,
                    ),

                    const SizedBox(height: 40),

                    controller.statusRequest == StatusRequest.loading
                        ? const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        )
                        : CustomAuthButton(
                          text: 'Save Changes',
                          onPressed: () {
                            controller.changeInitialPassword();
                          },
                        ),

                    const SizedBox(height: 30),

                    _buildFooterNote(),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget _buildFooterNote() {
  return const Text(
    'Your new password should be different from the current password and easy for you to remember.',
    textAlign: TextAlign.center,
    style: TextStyle(color: Colors.white30, fontSize: 12, height: 1.5),
  );
}
