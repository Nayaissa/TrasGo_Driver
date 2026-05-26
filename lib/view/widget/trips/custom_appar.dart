import 'package:flutter/material.dart';
import 'package:transport_project/core/constant/AppColor.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: const BoxDecoration(
        color: AppColor.primaryColor,
        border: Border(
          bottom: BorderSide(color: Color(0xFF1A2740), width: 0.6),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// LEFT SIDE
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF2B6CFF),
                      width: 1.4,
                    ),
                  ),
                  child: const CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.transparent,
                    backgroundImage: NetworkImage(
                      'https://i.pravatar.cc/150?u=1',
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                ShaderMask(
                  shaderCallback: (bounds) {
                    return const LinearGradient(
                      colors: [AppColor.thirdColor, AppColor.fourthColor],
                    ).createShader(bounds);
                  },
                  child: const Text(
                    "TransGo",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ],
            ),

            /// NOTIFICATION BUTTON
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.primaryColor.withOpacity(0.07),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.primaryColor.withOpacity(0.08),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(
                    Icons.notifications_rounded,
                    color: AppColor.thirdColor,
                    size: 20,
                  ),

                  Positioned(
                    top: 10,
                    right: 11,
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: AppColor.thirdColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
