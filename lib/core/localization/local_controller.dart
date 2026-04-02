import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transport_project/core/constant/AppTheme.dart';
import 'package:transport_project/core/services/service.dart';


// class LocalController extends GetxController {
//   Locale? language;
//   ThemeData appTheme = themeEnglish;
//   MyServices myServices = Get.find();
  
//   bool isDarkMode = false;

//   void changeLange(String langCode) {
//     final locale = Locale(langCode);
//     myServices.sharedPreferences.setString('lang', langCode);
//     appTheme = langCode == 'ar' ? themeArabic : themeEnglish;
//     Get.changeTheme(appTheme);
//     Get.updateLocale(locale);

//     language = locale;
//     update();
//   }

//   // void toggleTheme() {
//   //   isDarkMode = !isDarkMode;
//   //   appTheme = isDarkMode ? ThemeData.dark() : themeEnglish; 
//   //   Get.changeTheme(appTheme);
//   //   update();
//   // }
//  void toggleTheme() {
//     isDarkMode = !isDarkMode;

//     Get.changeThemeMode(
//       isDarkMode ? ThemeMode.dark : ThemeMode.light,
//     );
//   }
//   @override
//   void onInit() {
//     super.onInit();
//     final sharedPerLang = myServices.sharedPreferences.getString('lang');
//     if (sharedPerLang == "ar") {
//       language = const Locale("ar");
//       appTheme = themeArabic;
//     } else if (sharedPerLang == "en") {
//       language = const Locale("en");
//       appTheme = themeEnglish;
//     } else {
//       language = Locale(Get.deviceLocale?.languageCode ?? 'en');
//       appTheme = themeEnglish;
//     }
//   }
// }
class LocalController extends GetxController {
  Locale? language;
  ThemeData appTheme = themeEnglish;
  MyServices myServices = Get.find();

  bool isDarkMode = false;

  void changeLang(String langCode) {
    final locale = Locale(langCode);
    myServices.sharedPreferences.setString('lang', langCode);

    appTheme = langCode == 'ar' ? themeArabic : themeEnglish;
    Get.changeTheme(appTheme);
    Get.updateLocale(locale);

    language = locale;
    update();
  }

  void toggleTheme() {
    isDarkMode = !isDarkMode;
    Get.changeThemeMode(
      isDarkMode ? ThemeMode.dark : ThemeMode.light,
    );
  }

  @override
  void onInit() {
    super.onInit();
    final sharedPerLang = myServices.sharedPreferences.getString('lang');

    if (sharedPerLang == "ar") {
      language = const Locale("ar");
      appTheme = themeArabic;
    } else if (sharedPerLang == "en") {
      language = const Locale("en");
      appTheme = themeEnglish;
    } else {
      language = Locale(Get.deviceLocale?.languageCode ?? 'en');
      appTheme = themeEnglish;
    }
  }
}