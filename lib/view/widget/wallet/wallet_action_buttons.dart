import 'package:flutter/material.dart';
import 'package:transport_project/core/constant/AppColor.dart';

class WalletActionButtons extends StatelessWidget {
  const WalletActionButtons({
    super.key,
    required this.onTopUp,
    required this.onTransactions,
  });

  final VoidCallback onTopUp;
  final VoidCallback onTransactions;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _gradientButton(
            title: "Top Up",
            icon: Icons.add_circle_outline,
            onTap: onTopUp,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _darkButton(
            title: "Transactions",
            icon: Icons.history,
            onTap: onTransactions,
          ),
        ),
      ],
    );
  }

  Widget _gradientButton({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColor.thirdColor,
            AppColor.fourthColor,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: Colors.white),
        label: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  Widget _darkButton({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: AppColor.fifthColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
        ),
      ),
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(
          icon,
          color: Colors.white.withOpacity(0.55),
        ),
        label: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}