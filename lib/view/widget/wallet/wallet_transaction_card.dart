import 'package:flutter/material.dart';
import 'package:transport_project/core/constant/AppColor.dart';
import 'package:transport_project/data/model/wallet_model.dart';

class WalletTransactionCard extends StatelessWidget {
  const WalletTransactionCard({
    super.key,
    required this.transaction,
  });

  final WalletTransactionModel transaction;

  @override
  Widget build(BuildContext context) {
    final color = transaction.isNegative
        ? const Color(0xFFF08C8C)
        : const Color(0xFF8CF0B5);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _titleRow(color),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: Colors.white10, thickness: 0.5),
          ),
          _bottomRow(color),
        ],
      ),
    );
  }

  Widget _titleRow(Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColor.fifthColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            transaction.isNegative
                ? Icons.account_balance_wallet_outlined
                : Icons.account_balance_wallet,
            color: color,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                transaction.title,
                textDirection: TextDirection.rtl,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                transaction.reason,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.50),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _bottomRow(Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _actorAndDate(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              transaction.formattedAmount,
              style: TextStyle(
                color: color,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  transaction.receiptText,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.50),
                    fontSize: 11,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.circle,
                  color: Color(0xFF8CF0B5),
                  size: 6,
                ),
                const SizedBox(width: 4),
                Text(
                  transaction.statusLabel,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.50),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _actorAndDate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.person_outline,
              color: Colors.white.withOpacity(0.50),
              size: 14,
            ),
            const SizedBox(width: 4),
            Text(
              "Actor: ${transaction.actorName}",
              style: TextStyle(
                color: Colors.white.withOpacity(0.50),
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          transaction.dateText,
          style: TextStyle(
            color: Colors.white.withOpacity(0.45),
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}