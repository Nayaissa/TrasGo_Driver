
import 'package:get/get.dart';
import 'package:transport_project/core/class/diohelper.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
  
    Get.put(DioHelper());
    

  }
}
