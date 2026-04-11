import 'package:flutter/material.dart';

class PriceField extends StatelessWidget {
  const PriceField({
    super.key,
    required this.controller,
    required this.hint,
    required this.prefixText,
  });

  final TextEditingController controller;
  final String hint;
  final String prefixText;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xFF121E3C),
        borderRadius: BorderRadius.circular(18),
      ),
      child: TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.w800,
        ),
        decoration: InputDecoration(
          prefixText: '$prefixText ',
          prefixStyle: const TextStyle(
            color: Colors.white60,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white38, fontSize: 16),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
      ),
    );
  }
}