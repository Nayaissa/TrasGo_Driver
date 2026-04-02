import 'package:get/get.dart';
import 'package:transport_project/core/constant/routes.dart';
import 'package:transport_project/core/middleware/mymiddleware.dart';
import 'package:transport_project/view/screen/auth/changeinitailpassword.dart';
import 'package:transport_project/view/screen/auth/forgetpassword.dart';
import 'package:transport_project/view/screen/auth/loginscreen.dart';
import 'package:transport_project/view/screen/auth/otpscreen.dart';
import 'package:transport_project/view/screen/auth/resetpassword.dart';
import 'package:transport_project/view/screen/auth/success_resetpassword.dart';

List<GetPage<dynamic>>? getPages = [
  // intro.....
  GetPage(name: '/', page: () => LoginScreen(), middlewares: [MyMiddleWare()]),
  GetPage(name: AppRoute.forgetPassword, page: () => ForgotPasswordScreen()),
  GetPage(name: AppRoute.verfiyCode, page: () => VerifyOTPScreen()),
  GetPage(name: AppRoute.resetPassword, page: () => ResetPasswordScreen()),
  GetPage(name: AppRoute.successReset, page: () => ResetSuccessScreen()),
  GetPage(name: AppRoute.changeinitailpassword, page: () => ChangeInitialPasswordScreen()),

  //home
];
