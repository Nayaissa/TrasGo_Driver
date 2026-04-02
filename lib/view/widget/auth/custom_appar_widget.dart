import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transport_project/core/constant/AppColor.dart';

class CustomAppar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
        final theme = Theme.of(context);

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColor.thirdColor),
        onPressed: () => Get.back(),
      ),
      title:  Text(
        "TransGo",
        style: TextStyle(
          color: theme.primaryColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
