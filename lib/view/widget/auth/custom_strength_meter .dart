import 'package:flutter/material.dart';

class CustomStrengthMeter extends StatelessWidget {
  const CustomStrengthMeter({
    super.key,
    required this.strengthText,
    required this.strengthLevel,
  });

  final String strengthText;
  final double strengthLevel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "SECURITY STATUS",
              style: TextStyle(
                color: Colors.white30,
                fontSize: 9,
              ),
            ),
            Text(
              strengthText,
              style: const TextStyle(
                color: Color(0xFF4A64FE),
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: List.generate(4, (index) {
            final isActive = strengthLevel > (index / 4);

            return Expanded(
              child: Container(
                height: 4,
                margin: EdgeInsets.only(right: index == 3 ? 0 : 5),
                decoration: BoxDecoration(
                  color: isActive
                      ? const Color(0xFF4A64FE)
                      : Colors.white10,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}