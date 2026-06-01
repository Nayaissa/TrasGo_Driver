import 'package:get/get.dart';

class DriverProfileController extends GetxController {
  // بيانات افتراضية تحاكي التصميم
  String driverName = "Marcus Vance";
  double rating = 4.98;
  String rank = "Elite Captain • TransGo Black Label";
  
  String trips = "1.2k";
  String passengers = "2.5k";
  int years = 4;

  // Performance Matrix
  int completedTrips = 1240;
  int cancelledTrips = 12;
  double totalEarnings = 12845.00;
  
  // Balance
  double walletBalance = 4280.50;
  double todayEarnings = 42.50;

  // Vehicle Info
  String carModel = "BMW 5 Series";
  String carPlate = "TGD-882";

  // دالة تحديث المحفظة كمثال لإعادة البناء عبر GetBuilder
  void refreshWallet() {
    walletBalance += 10.0; // تجربة التحديث الإنعاشي
    update(); // يقوم بتحديث الـ GetBuilder المرتبط فوراً
  }
}