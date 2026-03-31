import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:transport_project/controller/auth/login_controller.dart';

class CustomPassTextFiled extends StatelessWidget {
  const CustomPassTextFiled({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GetBuilder<LoginController>(
      builder: (controller) {
        return Container(
          decoration: BoxDecoration(
            color:
                theme.brightness == Brightness.dark
                    ? Colors.white.withOpacity(0.08)
                    : Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            obscureText: !controller.isPasswordVisible,
            style: TextStyle(color: theme.textTheme.bodyLarge?.color),
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.lock_outline,
                color: theme.hintColor,
                size: 20,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  controller.isPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: theme.hintColor,
                  size: 20,
                ),
                onPressed: controller.togglePasswordVisibility,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        );
      },
    );
  }
}
