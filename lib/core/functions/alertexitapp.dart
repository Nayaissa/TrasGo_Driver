import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: non_constant_identifier_names
Future<bool> AlretExitApp() {
  Get.defaultDialog(
    title: 'تنبيه ',
    middleText: 'هل تريد الخروج من التطبيق:',
    actions: [
      ElevatedButton(
        onPressed: () {
          exit(0);
        },
        child: Text('Confirm'),
      ),
      ElevatedButton(onPressed: () {
                  Get.back();

      }, child: Text('Cancle')),
    ],
  );
  return Future.value(true);
}
