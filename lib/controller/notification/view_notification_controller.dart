import 'package:get/get.dart';
import 'package:transport_project/core/class/diohelper.dart';
import 'package:transport_project/core/class/statusrequest.dart';
import 'package:transport_project/data/model/notification_model.dart';

abstract class DriverNotificationViewController extends GetxController {
  Future<void> getNotifications({bool showLoading = true});
  Future<void> readAllNotifications();
  void markAsReadLocal(int userNotificationId);
}

class DriverNotificationViewControllerImp extends DriverNotificationViewController {
  StatusRequest statusRequest = StatusRequest.loading;

  DriverNotificationModel? notificationModel;
  List<DriverNotificationItem> notifications = [];

  bool isReadingAll = false;

  @override
  void onInit() {
    super.onInit();
    getNotifications();
  }

  @override
  Future<void> getNotifications({bool showLoading = true}) async {
    if (showLoading) {
      statusRequest = StatusRequest.loading;
      update();
    }

    try {
      final response = await DioHelper.getDataa(
        url: "v1/driver/notifications", 
      );

      if (response != null && response.statusCode == 200) {
        final body = response.data;

        if (body is Map && body["success"] == true) {
          notificationModel = DriverNotificationModel.fromJson(
            Map<String, dynamic>.from(body),
          );

          notifications = notificationModel?.items ?? [];
          _syncUnreadCount();
          statusRequest = StatusRequest.success;
        } else {
          statusRequest = StatusRequest.failure;
        }
      } else if (response != null && response.statusCode == 401) {
        statusRequest = StatusRequest.serverfailure;
        Get.snackbar(
          "Error",
          "انتهت صلاحية تسجيل الدخول",
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        statusRequest = StatusRequest.serverfailure;
      }
    } catch (error) {
      statusRequest = StatusRequest.serverfailure;
    }

    update();
  }

  @override
  Future<void> readAllNotifications() async {
    if (isReadingAll) return;

    isReadingAll = true;
    update();

    try {
      final response = await DioHelper.patchData(
        url: "v1/driver/notifications/read-all", 
        query: {}
      );

      if (response != null && response.statusCode == 200) {
        final body = response.data;
        String msg = body["message"]?.toString() ?? "تم تحديث الإشعارات كمقروءة";

        for (final item in notifications) {
          item.isRead = true;
        }
        _syncUnreadCount();

        Get.snackbar(
          "Notifications",
          msg,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          "Error",
          "فشل في تحديث حالة الإشعارات",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (error) {
      Get.snackbar(
        "Error",
        "حدث خطأ أثناء تنفيذ العملية",
        snackPosition: SnackPosition.BOTTOM,
      );
    }

    isReadingAll = false;
    update();
  }

  @override
  void markAsReadLocal(int userNotificationId) {
    final index = notifications.indexWhere(
      (item) => item.userNotificationId == userNotificationId,
    );

    if (index == -1) return;

    notifications[index].isRead = true;
    _syncUnreadCount();
    update();
  }

  void _syncUnreadCount() {
    if (!Get.isRegistered<DriverNotificationViewControllerImp>()) return;
    
  }
}