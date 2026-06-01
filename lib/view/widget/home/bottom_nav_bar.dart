import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transport_project/controller/home/home_screen_controller.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key, required this.controller});

  final HomeScreenController controller;

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.home_rounded, 'home'.tr),
      (Icons.compare_arrows_rounded, 'trips'.tr),
      (Icons.person_2_outlined, 'profile'.tr),
      (Icons.report_problem_outlined, 'complaints'.tr),
      (Icons.account_balance_wallet_outlined, 'earnings'.tr),
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(14, 0, 14, 14),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF0C1731).withOpacity(.96),
        borderRadius: BorderRadius.circular(26),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final selected = controller.currentPage == index;
          final item = items[index];

          return GestureDetector(
            onTap: () => controller.changePage(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: selected ? 64 : 58,
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 5,
              ),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: selected
                    ? const LinearGradient(
                        colors: [
                          Color(0xFF6E88FF),
                          Color(0xFFD08DFF),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: selected ? null : Colors.transparent,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    item.$1,
                    color: selected ? Colors.white : Colors.white54,
                    size: 20,
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    height: 14,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        item.$2,
                        style: TextStyle(
                          color: selected ? Colors.white : Colors.white54,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}