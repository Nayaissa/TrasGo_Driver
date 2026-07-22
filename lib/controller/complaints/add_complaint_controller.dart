import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transport_project/core/class/diohelper.dart';
import 'package:transport_project/core/class/statusrequest.dart';

abstract class AddComplaintController extends GetxController {
  updateComplaintType(String value);
  submitComplaint();
  clearForm();
}

class AddComplaintControllerImp extends AddComplaintController {
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  late TextEditingController detailsController;

  StatusRequest? statusRequest;

  String complaintType = "technical";

  int? relatedTripId;
  int? relatedBookingId;

  final List<Map<String, String>> complaintTypes = [
    {"value": "ride", "title": "مشكلة في الرحلة"},
    {"value": "driver", "title": "مشكلة متعلقة بالسائق"},
    {"value": "passenger", "title": "مشكلة مع الراكب"},
    {"value": "payment", "title": "مشكلة في الدفع"},
    {"value": "technical", "title": "مشكلة تقنية"},
    {"value": "system", "title": "مشكلة في النظام"},
  ];

  @override
  updateComplaintType(String value) {
    complaintType = value;
    update();
  }

  void setRelatedTripId(int? id) {
    relatedTripId = id;
    update();
  }

  void setRelatedBookingId(int? id) {
    relatedBookingId = id;
    update();
  }

  @override
  submitComplaint() async {
    var formData = formState.currentState;

    if (formData == null || !formData.validate()) {
      return;
    }

    statusRequest = StatusRequest.loading;
    update();

    try {
      final response = await DioHelper.postsData(
        url: "v1/driver/complaints",
        data: {
          "complaint_type": complaintType,
          "description": detailsController.text.trim(),
          "related_trip_id": relatedTripId,
          "related_booking_id": relatedBookingId,
        },
      );

      print("ADD COMPLAINT RESPONSE => ${response?.data}");
      print("ADD COMPLAINT STATUS CODE => ${response?.statusCode}");

      if (response != null &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        statusRequest = StatusRequest.success;
        update();

        Get.snackbar(
          "تم بنجاح",
          response.data["message"]?.toString() ?? "تم تقديم الشكوى بنجاح",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        update();
        clearForm();

        Get.back(result: true);
      } else {
        statusRequest = StatusRequest.failure;
        update();

        Get.snackbar(
          "تنبيه",
          response?.data["message"]?.toString() ?? "فشل إرسال الشكوى",
          snackPosition: SnackPosition.BOTTOM,
          //   backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      }
    } catch (error) {
      print("ADD COMPLAINT ERROR => $error");

      statusRequest = StatusRequest.serverfailure;
      update();

      Get.snackbar(
        "خطأ",
        "حدث خطأ في الاتصال بالخادم",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  @override
  clearForm() {
    complaintType = "technical";
    relatedTripId = null;
    relatedBookingId = null;
    detailsController.clear();
    update();
  }

  @override
  void onInit() {
    detailsController = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    detailsController.dispose();
    super.onClose();
  }
}
