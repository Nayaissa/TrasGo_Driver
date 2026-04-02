import 'package:flutter/material.dart';

class CustomPassTextFiled extends StatelessWidget {
  const CustomPassTextFiled({
    super.key,
    required this.obscureText,
    required this.iconData,
    this.onPressedIcon,
    this.onChanged,
    this.controller,
    this.validator,
  });

  final bool obscureText;
  final IconData iconData;
  final void Function()? onPressedIcon;
  final void Function(String)? onChanged;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: controller,
      validator: validator,
      onChanged: onChanged,
      obscureText: obscureText,
      style: TextStyle(color: theme.textTheme.bodyLarge?.color),
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
        prefixIcon: Icon(Icons.lock_outline, color: theme.hintColor, size: 20),
        suffixIcon: IconButton(
          icon: Icon(iconData, color: theme.hintColor, size: 20),
          onPressed: onPressedIcon,
        ),
        filled: true,
        fillColor:
            theme.brightness == Brightness.dark
                ? Colors.white.withOpacity(0.08)
                : Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}
