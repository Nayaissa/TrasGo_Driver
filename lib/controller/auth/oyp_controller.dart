import 'dart:async';
import 'package:get/get.dart';

class AuthController extends GetxController {
  // للتحكم في مؤقت الـ OTP
  RxInt timerCount = 119.obs; // دقيقتان
  Timer? _timer;

  @override
  void onInit() {
    startTimer();
    super.onInit();
  }

  void startTimer() {
    _timer?.cancel();
    timerCount.value = 119;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timerCount.value > 0) {
        timerCount.value--;
      } else {
        _timer?.cancel();
      }
    });
  }

  String get timerText {
    int minutes = timerCount.value ~/ 60;
    int seconds = timerCount.value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}