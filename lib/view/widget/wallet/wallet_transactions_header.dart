import 'package:flutter/material.dart';
import 'package:transport_project/core/constant/AppColor.dart';

class WalletTransactionsHeader extends StatelessWidget {
  const WalletTransactionsHeader({
    super.key,
    required this.isShowingAll,
    required this.isLoading,
    required this.onViewAll,
  });

  final bool isShowingAll;
  final bool isLoading;
  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          isShowingAll ? "All Transactions" : "Recent Transactions",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: isLoading ? null : onViewAll,
          child: isLoading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColor.thirdColor,
                  ),
                )
              : Text(
                  isShowingAll ? "REFRESH" : "VIEW ALL",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.50),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
        ),
      ],
    );
  }
}