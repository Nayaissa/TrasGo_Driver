import 'package:flutter/material.dart';
import 'package:transport_project/core/constant/AppColor.dart';

ThemeData themeEnglish = ThemeData(
  fontFamily: 'Sekuya',
  textTheme: const TextTheme(
    // displayLarge: TextStyle(
    //   fontSize: 25,
    //   fontWeight: FontWeight.bold,
    //   color: AppColor.black,
    // ),
     headlineSmall: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
    ),
    
    // displayMedium: TextStyle(
    //   fontSize: 26,
    //   fontWeight: FontWeight.bold,
    //   color: AppColor.black,
    // ),
    bodyLarge: TextStyle(
      height: 1.8,
      fontWeight: FontWeight.w400,
      color: AppColor.grey,
    ),
    bodyMedium: TextStyle(
      height: 1.7,
      fontWeight: FontWeight.w600,
      fontSize: 13,

      color: AppColor.grey,
    ),
  ),
);


ThemeData themeArabic = ThemeData(
  fontFamily: 'Sekuya',
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontSize: 25,
      fontWeight: FontWeight.bold,
    //  color: AppColor.black,
    ),
    displayMedium: TextStyle(
      fontSize: 26,
      fontWeight: FontWeight.bold,
    //  color: AppColor.black,
    ),
    bodyLarge: TextStyle(
      height: 1.8,
      fontWeight: FontWeight.w400,
      color: AppColor.grey,
    ),
    bodyMedium: TextStyle(
      height: 1.7,
      fontWeight: FontWeight.w600,
      fontSize: 13,

      color: AppColor.grey,
    ),
  ),
);
