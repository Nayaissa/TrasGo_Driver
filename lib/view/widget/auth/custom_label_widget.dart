import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomLabel extends StatelessWidget {
  const CustomLabel({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4),
      child: Text(
        text,
        textAlign: TextAlign.start,
        style: TextStyle(
          color: Theme.of(context).hintColor,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}
