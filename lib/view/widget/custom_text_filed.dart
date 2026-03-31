import 'package:flutter/material.dart';

class CustomTextFiled extends StatelessWidget {
  const CustomTextFiled({super.key, required this.hint, required this.icon});
  final String hint;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color:
            theme.brightness == Brightness.dark
                ? Colors.white.withOpacity(0.08)
                : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow:
            theme.brightness == Brightness.light
                ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                  ),
                ]
                : [],
      ),
      child: TextFormField(
        style: TextStyle(color: theme.textTheme.bodyLarge?.color),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: theme.hintColor, size: 20),
          hintText: hint,
          hintStyle: TextStyle(color: theme.hintColor.withOpacity(0.5)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}
