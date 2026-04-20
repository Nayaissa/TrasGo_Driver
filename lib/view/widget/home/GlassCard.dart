import 'package:flutter/material.dart';
import 'package:transport_project/core/constant/AppColor.dart';

class GlassCard extends StatelessWidget {
  const GlassCard({
    required this.child,
    this.padding = const EdgeInsets.all(18),
  });

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: AppColor.primaryColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColor.grey),
      ),
      child: child,
    );
  }
}
