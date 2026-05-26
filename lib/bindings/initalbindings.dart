
import 'package:get/get.dart';
import 'package:transport_project/controller/notification_controller.dart';
import 'package:transport_project/core/class/diohelper.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
  
    Get.put(DioHelper());
    Get.put(NotificationController());

    

  }
}
