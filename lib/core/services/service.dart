
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class MyServices extends GetxService {
//   late SharedPreferences sharedPreferences;
//   Future<MyServices> init() async {
//     sharedPreferences = await SharedPreferences.getInstance();
//     return this;
//   }
// }

// initalSevices() async {

//    await Get.putAsync(() => MyServices().init());
// }

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyServices extends GetxService {
  late SharedPreferences sharedPreferences;

  Future<MyServices> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
    return this;
  }

  Future<void> clearSharedPreferences() async {
    await sharedPreferences.clear();
  }

  Future<void> removeFromSharedPreferences(String key) async {
    await sharedPreferences.remove(key);
  }

  String? getString(String key) {
    return sharedPreferences.getString(key);
  }

  Future<void> setString(String key, String value) async {
    await sharedPreferences.setString(key, value);
  }
}

Future<void> initalSevices() async {
  await Get.putAsync(() => MyServices().init());
}

MyServices get myServices => Get.find<MyServices>();