import 'package:get/get.dart';
import 'package:transport_project/core/middleware/mymiddleware.dart';
import 'package:transport_project/view/screen/auth/loginscreen.dart';

List<GetPage<dynamic>>? getPages = [
  // intro.....
  GetPage(name: '/', page: () => LoginScreen(), middlewares: [MyMiddleWare()]),
 
];
