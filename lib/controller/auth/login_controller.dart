import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transport_project/core/class/diohelper.dart';
import 'package:transport_project/core/class/statusrequest.dart';
import 'package:transport_project/core/constant/routes.dart';
import 'package:transport_project/core/services/service.dart';
import 'package:transport_project/data/model/login_model.dart';

abstract class LoginController extends GetxController {
  login();
  goToForget();
}

class LoginControllerImp extends LoginController {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  late TextEditingController email;
  late TextEditingController password;

  bool? isshowpassword = true;
  bool isPasswordVisible = false;

  MyServices myServices = Get.find();

  StatusRequest? statusRequest;
  LoginModel? loginModel;

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    update();
  }

  @override
  goToForget() {
    Get.toNamed(AppRoute.forgetPassword);
  }

  @override
  login() async {
    var formdata = formstate.currentState;

    if (formdata!.validate()) {
      statusRequest = StatusRequest.loading;
      update();

      try {
        final value = await DioHelper.postsData(
          url: 'v1/driver/login',
          data: {
            'email': email.text,
            'password': password.text,
          },
        );

        print("LOGIN RESPONSE => ${value?.data}");
        print("LOGIN STATUS CODE => ${value?.statusCode}");

        if (value != null && value.statusCode == 200) {
          loginModel = LoginModel.fromJson(value.data);

          final String userid =
              loginModel?.data?.user?.userId?.toString() ?? "";

          final String username =
              loginModel?.data?.user?.fullName?.toString() ?? "";

          final String token =
              loginModel?.data?.token?.toString() ?? "";

          await myServices.sharedPreferences.setString(
            'userid',
            userid,
          );

          await myServices.sharedPreferences.setString(
            'username',
            username,
          );

          await myServices.sharedPreferences.setString(
            'token',
            token,
          );

          await myServices.sharedPreferences.setString(
            'step',
            '2',
          );

          if (userid.isNotEmpty) {
            await FirebaseMessaging.instance.subscribeToTopic(userid);
          }

          await FirebaseMessaging.instance.subscribeToTopic("drivers");
          await FirebaseMessaging.instance.subscribeToTopic("user_2");


          statusRequest = StatusRequest.success;
          update();

          Get.snackbar(
            'success_title'.tr,
            loginModel?.message ?? 'login_success'.tr,
          );

          Get.offAllNamed(AppRoute.homepage);
        } else {
          if (value?.data != null) {
            loginModel = LoginModel.fromJson(value!.data);
          }

          statusRequest = StatusRequest.failure;
          update();

          Get.snackbar(
            'warning_title'.tr,
            loginModel?.message ?? 'login_failed'.tr,
          );
        }
      } catch (error) {
        print("LOGIN ERROR => $error");

        statusRequest = StatusRequest.serverfailure;
        update();

        Get.snackbar(
          'error_title'.tr,
          'server_error'.tr,
        );
      }
    }
  }

  @override
  void onInit() {
    email = TextEditingController();
    password = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }
}