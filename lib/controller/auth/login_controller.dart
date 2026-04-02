import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transport_project/core/class/diohelper.dart';
import 'package:transport_project/core/class/statusrequest.dart';
import 'package:transport_project/core/constant/routes.dart';
import 'package:transport_project/core/services/service.dart';
import 'package:transport_project/data/model/login_model.dart';

abstract class LoginController extends GetxController {
  login() {}
  goToForget() {}
}

class LoginControllerImp extends LoginController {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  late TextEditingController email;
  late TextEditingController password;
  bool? isshowpassword = true;
  MyServices myServices = Get.find();
  StatusRequest? statusRequest;
  LoginModel? loginModel;
  bool isPasswordVisible = false;

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

      DioHelper.postsData(
        url: 'v1/driver/login',
        data: {
          'email': email.text,
          'password': password.text,
        },
      ).then((value) {
        print(value!.data);

        if (value.statusCode == 200) {
          loginModel = LoginModel.fromJson(value.data);

          myServices.sharedPreferences.setString(
            'userid',
            loginModel!.data!.user!.userId.toString(),
          );
          myServices.sharedPreferences.setString(
            'username',
            loginModel!.data!.user!.fullName!,
          );
          myServices.sharedPreferences.setString(
            'token',
            loginModel!.data!.token ?? '',
          );
          myServices.sharedPreferences.setString('step', '2');

          statusRequest = StatusRequest.success;

          Get.snackbar(
            'success_title'.tr,
            loginModel!.message ?? 'login_success'.tr,
          );

          // Get.offNamed(AppRoute.homepage);

          update();
        } else {
          loginModel = LoginModel.fromJson(value.data);
          statusRequest = StatusRequest.failure;

          Get.snackbar(
            'warning_title'.tr,
            loginModel!.message ?? 'login_failed'.tr,
          );

          update();
        }
      }).catchError((error) {
        print(error.toString());
        statusRequest = StatusRequest.serverfailure;

        Get.snackbar(
          'error_title'.tr,
          'server_error'.tr,
        );

        update();
      });

      update();
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