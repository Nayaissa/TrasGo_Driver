import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:transport_project/bindings/initalbindings.dart';
import 'package:transport_project/core/class/diohelper.dart';
import 'package:transport_project/core/localization/local_controller.dart';
import 'package:transport_project/core/localization/my_translation.dart';
import 'package:transport_project/core/services/service.dart';
import 'package:transport_project/firebase_options.dart';
import 'package:transport_project/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
    await initializeDateFormatting(); 
      await GetStorage.init();

await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
 await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );
  DioHelper.init();
  await initalSevices();

  DioHelper.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    LocalController controller = Get.put(LocalController());

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      locale: controller.language,
      translations: MyTranslation(),
      fallbackLocale: Locale('ar'),
      
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        cardColor: Colors.grey[100],
        hintColor: Colors.black54,
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.blueAccent,
        scaffoldBackgroundColor: const Color(0xFF090B19),
        cardColor: Colors.white.withOpacity(0.05),
        hintColor: Colors.white54,
      ),
      themeMode: ThemeMode.dark,
      initialBinding: InitialBinding(),
      initialRoute: '/',
      getPages: getPages,
    );
  }
}
