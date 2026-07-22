import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transport_project/core/class/diohelper.dart';
import 'package:transport_project/core/class/statusrequest.dart';
import 'package:transport_project/core/constant/routes.dart';

abstract class DriverProfileController extends GetxController {
  Future<void> getDriverProfile();
  Future<void> refreshProfile();
  Future<void> logout();
}

class DriverProfileControllerImp extends DriverProfileController {
  StatusRequest? profileStatusRequest;

  String driverName = "";
  String photo = "";
  String phoneNumber = "";
  String email = "";
  String carPlate = "";
  String carType = "";
  List<String> carPhotos = [];
  double rating = 0;
  List reviews = [];

  @override
  void onInit() {
    super.onInit();
    getDriverProfile();
  }

  @override
  Future<void> getDriverProfile() async {
    profileStatusRequest = StatusRequest.loading;
    update();

    try {
      final value = await DioHelper.getDataa(url: "v1/driver/me");

      print("PROFILE STATUS CODE => ${value?.statusCode}");
      print("PROFILE RESPONSE => ${value?.data}");

      if (value != null && value.statusCode == 200) {
        final responseBody = value.data;

        if (responseBody is Map && responseBody["success"] == true) {
          final data = responseBody["data"];
          final profile = data is Map ? data["profile"] : null;

          if (profile is! Map) {
            profileStatusRequest = StatusRequest.noData;
            update();
            return;
          }

          driverName = profile["name"]?.toString() ?? "";
          photo = profile["photo"]?.toString() ?? "";
          phoneNumber = profile["phone_number"]?.toString() ?? "";
          email = profile["email"]?.toString() ?? "";
          carPlate = profile["car_plate_number"]?.toString() ?? "";
          carType = profile["car_type"]?.toString() ?? "";

          rating = double.tryParse(
                profile["overall_rating"]?.toString() ?? "0",
              ) ??
              0;

          final photos = profile["car_photos"];
          carPhotos = photos is List
              ? photos.map((photo) => photo.toString()).toList()
              : [];

          final reviewsData = data["reviews"];
          reviews = reviewsData is List ? reviewsData : [];

          profileStatusRequest = StatusRequest.success;
        } else {
          profileStatusRequest = StatusRequest.noData;

          Get.snackbar(
            "Error",
            responseBody is Map
                ? responseBody["message"]?.toString() ??
                    "Failed to load profile"
                : "Failed to load profile",
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else if (value != null && value.statusCode == 401) {
        profileStatusRequest = StatusRequest.serverfailure;

        Get.snackbar(
          "Error",
          "انتهت صلاحية تسجيل الدخول، يرجى تسجيل الدخول مرة أخرى",
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        profileStatusRequest = StatusRequest.serverfailure;

        Get.snackbar(
          "Error",
          "Failed to load profile",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (error, stackTrace) {
      print("PROFILE ERROR => $error");
      print("PROFILE STACKTRACE => $stackTrace");

      profileStatusRequest = StatusRequest.serverfailure;

      Get.snackbar(
        "Error",
        "حدث خطأ أثناء تحميل الملف الشخصي",
        snackPosition: SnackPosition.BOTTOM,
      );
    }

    update();
  }

  @override
  Future<void> refreshProfile() async {
    await getDriverProfile();
  }
@override
Future<void> logout() async {
  Get.defaultDialog(
    title: "تسجيل الخروج",
    middleText: "هل أنت متأكد أنك تريد تسجيل الخروج؟",
    textCancel: "إلغاء",
    textConfirm: "نعم",
    confirmTextColor: Get.theme.colorScheme.onPrimary,
    onCancel: () {
      Get.back();
    },
    onConfirm: () async {
      final userid = myServices.sharedPreferences.getString("userid");

      // if (userid != null && userid.isNotEmpty) {
      //   await FirebaseMessaging.instance.unsubscribeFromTopic(userid);
      // }

      // await FirebaseMessaging.instance.unsubscribeFromTopic("drivers");

      await myServices.sharedPreferences.remove("userid");
      await myServices.sharedPreferences.remove("username");
      await myServices.sharedPreferences.remove("token");

      // هذا أهم سطر
      await myServices.sharedPreferences.remove("step");

      // إذا عندك مفاتيح قديمة، احذفها احتياطًا
      await myServices.sharedPreferences.remove("Token");
      await myServices.sharedPreferences.remove("driver_token");
      await myServices.sharedPreferences.remove("driver_id");
      await myServices.sharedPreferences.remove("driver_name");
      await myServices.sharedPreferences.remove("driver_email");
      await myServices.sharedPreferences.remove("driver_phone");

      if (Get.isDialogOpen == true) {
        Get.back();
      }

      Get.offAllNamed(AppRoute.login);
    },
  );
}
}